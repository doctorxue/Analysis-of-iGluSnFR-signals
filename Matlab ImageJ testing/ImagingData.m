classdef ImagingData
    properties
        window_name;
        basename;
        num_frame;
        frame_period;
        pixel_size;
        num_channel;
        x_size;
        y_size;
        data;
        app;
        total_time;
        pre_dur; % The pre-pulse time. 
        bck_time_start; % The time range for bck subtraction.
    end
    
    methods
        function obj=ImagingData(a,b,flag)
                if nargin==3
                        path=[char(cd),'\'];
                        file_name=dir('*.xml');
                        file_name=char(file_name.name);
                else           
                    [file_name,path]=uigetfile('*.*');
                    cd(path);
                    
                end

                obj.basename=[path,file_name];
                obj.window_name=file_name;
                tree=parseXML(obj.basename); % using MATLAB builtin functions to read .xml file to get basic info about the stack
                obj.pixel_size=str2num(tree.Children(4).Children(26).Children(2).Attributes(2).Value); % in the unit of micron
                obj.frame_period=str2num(tree.Children(4).Children(14).Attributes(2).Value); % in the unit of second
                obj.num_frame=str2num(tree.Children(6).Children(end-1).Attributes(2).Value); 
                obj.num_channel=floor(size(tree.Children(6).Children,2)/obj.num_frame);
                obj.pre_dur=a;
                obj.bck_time_start=b;
                if obj.num_channel ~=2
                    disp("channel number is not 2. Error."); % double checking channel number.
                end
                obj.y_size=str2num(tree.Children(4).Children(22).Attributes(2).Value);
                obj.x_size=str2num(tree.Children(4).Children(38).Attributes(2).Value);
                obj.total_time=round(obj.frame_period*(obj.num_frame-1),2);
                % from here load the images
                dc=dir('*.tif');
                image_names=string({dc(:).name});
                obj.data=zeros(obj.y_size,obj.x_size,obj.num_channel,obj.num_frame);
                for i=1:obj.num_channel
                    ch_name=['Ch',num2str(i)];
                    x=strfind(image_names,ch_name);
                    empty_ind=cellfun('isempty',x);
                    x(empty_ind)={0};
                    ind=find(cell2mat(x));
                    if size(ind) ~=obj.num_frame
                        disp('Error. Frame number inconsistent');
                    end
                    count=1;
                    temp=sort(image_names(ind));
                    for j=temp
                        obj.data(:,:,i,count)=imread(char(j));
                        count=count+1;
                    end
                end
            % obj.app=my_test(obj); % calling the window to show the image.
        end
        
        function ori=subregion_curve(obj,num_region) % both in the unit of second. pulse_start indicates when the pulse is delivered,% read from LabChart. pre_dur indicates how much time proceeding the pulse % should the background be subtracted.
            ori=zeros(num_region,obj.num_channel,obj.num_frame);         
            bin_size=floor(obj.x_size/num_region);  % doing along x dimension.
            for i=1:num_region
                if i~=num_region
                    x_range=((i-1)*bin_size+1):i*bin_size;
                else
                    x_range=((i-1)*bin_size+1):obj.x_size;
                end
                ori(i,:,:)=squeeze(mean(mean(obj.data(:,x_range,:,:),2),1));
            end
        end                                                              
        
        function image=getbck(obj) % returning the structured ImageData;
            image=obj;
            image.num_frame=1;
            image.total_time=round(image.frame_period,2);
            frame_start=floor(obj.bck_time_start/obj.frame_period);
            frame_end=floor(obj.pre_dur/obj.frame_period)-1;
            image.data=zeros(obj.y_size,obj.x_size,obj.num_channel,1);
            image.data(:,:,:,1)=mean(obj.data(:,:,:,frame_start:frame_end),4);
            image.data(:,:,1,1)=floor(image.data(:,:,1,1)*2^12/max(max(image.data(:,:,1,1))));
            image.window_name=['bck_',obj.window_name];
        end

        function image=subbck(obj)
            image=obj;
            image.data=image.data-obj.getbck().data;
        end

        function image=getdf(obj)
            image=obj;
            bck=obj.getbck().data;
            for i=1:size(obj.data,1)
                for j=1:size(obj.data,2)
                    image.data(i,j,2,:)=(image.data(i,j,2,:)-bck(i,j,2))/bck(i,j,2);
                end
            end
        end

        function [y1,y2]=mat_proc(obj) % here is calculating df only, not df/f. But actually the two are the same since each pixel will be divided by the same F0 for both bck signal and in-stimulation signal. 
            df=obj.getdf();
            g_fluo=squeeze(df.data(:,:,2,:));
            for i=1:obj.x_size % x_size is the number of columns, y_size is the number of rows, so j will be the first param in the parentheses
                for j=1:obj.y_size
                    bck_std=std(g_fluo(j,i,floor(obj.bck_time_start/obj.frame_period):floor(obj.pre_dur/obj.frame_period)));
                    curr_max=max(g_fluo(j,i,floor(obj.pre_dur/obj.frame_period):floor((obj.pre_dur+1)/obj.frame_period)));
                    %ave_arr(j,i)=mean(g_fluo(j,i,floor(obj.pre_dur/obj.frame_period):floor((obj.pre_dur+1)/obj.frame_period)));
                    ave_arr(j,i)=mean(g_fluo(j,i,(floor(obj.pre_dur/obj.frame_period)+2):(floor((obj.pre_dur+1)/obj.frame_period)-2)));
                    % if curr_max>6*bck_std % 6 times standard deviation of background signals
                    if ave_arr(j,i)>3*bck_std
                    logi_arr(j,i)=1; 
                    else
                    logi_arr(j,i)=0;
                    end
                end
            end

            t_arr=[1,1,1;1,0,1;1,1,1];
            for i=2:(obj.x_size-1)
                for j=2:(obj.y_size-1)
                curr_arr=logi_arr((j-1):(j+1),(i-1):(i+1));
                    if sum(sum(curr_arr.*t_arr))==0
                    logi_arr(j,i)=0;
                    end
                end
            end

            y1=ave_arr;
            y2=logi_arr;
        end

        function [y1,y2]=mat_proc_LR(obj) % here is calculating df only, not df/f. But actually the two are the same since each pixel will be divided by the same F0 for both bck signal and in-stimulation signal. 
            df=obj.getdf();
            g_fluo=squeeze(df.data(:,:,2,:));
            for i=1:obj.x_size % x_size is the number of columns, y_size is the number of rows, so j will be the first param in the parentheses
                for j=1:obj.y_size
                    bck_std=std(g_fluo(j,i,floor(obj.bck_time_start/obj.frame_period):floor(obj.pre_dur/obj.frame_period)));
                    curr_max=max(g_fluo(j,i,floor(obj.pre_dur/obj.frame_period+1):floor((obj.pre_dur+3)/obj.frame_period)));
                    %ave_arr(j,i)=mean(g_fluo(j,i,floor(obj.pre_dur/obj.frame_period):floor((obj.pre_dur+1)/obj.frame_period)));
                    ave_arr(j,i)=mean(g_fluo(j,i,(floor(obj.pre_dur/obj.frame_period+1)+2):(floor((obj.pre_dur+3)/obj.frame_period)-2)));
                    % if curr_max>6*bck_std % 6 times standard deviation of background signals
                    if ave_arr(j,i)>1.6*bck_std
                    logi_arr(j,i)=1; 
                    else
                    logi_arr(j,i)=0;
                    end
                end
            end

            t_arr=[1,1,1;1,0,1;1,1,1];
            for i=2:(obj.x_size-1)
                for j=2:(obj.y_size-1)
                curr_arr=logi_arr((j-1):(j+1),(i-1):(i+1));
                    if sum(sum(curr_arr.*t_arr))==0
                    logi_arr(j,i)=0;
                    end
                end
            end

            y1=ave_arr;
            y2=logi_arr;
        end


        function y=whole_curve(obj)
            y=zeros(obj.num_channel,obj.num_frame);
            y(:,:)=squeeze(mean(mean(obj.data(:,:,:,:),2),1));
        end

        function ROI=drawROI(obj) % a polygon ROI. Returning the binary mask. 
            p=drawpolygon(obj.app.UIAxes);
            ROI=poly2mask(floor(p.Position(:,1)),floor(p.Position(:,2)),obj.y_size,obj.x_size);
        end

        function y=getROIValue(obj,ROI)
            mask=repmat(ROI,1,1,obj.num_channel,obj.num_frame);
            y=squeeze(mean(mean(obj.data.*mask,1),2));
            y=y*(obj.x_size*obj.y_size)/sum(nonzeros(mask));
        end

        function pos = customWait(ROI)

        % Listen for mouse clicks on the ROI
        l = addlistener(ROI,'ROIClicked',@clickCallback);
        
        % Block program execution
        uiwait;
        
        % Remove listener
        delete(l);
        
        % Return the current position
        pos = ROI.Center;
        
        end

        function clickCallback(~,evt)

            if strcmp(evt.SelectionType,'double')
                uiresume;
            end
        
        end
    end
end


    