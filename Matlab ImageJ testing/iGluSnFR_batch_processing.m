% all the ImagingData object is stored in dat_list file.
pre=2;
%bck=1.5;
bck=pre-0.5;
dur=1;
end_point=5;

if ~exist('ROI','var')
    ori_num=7;
    h=dat_list(ori_num).getbck();
    h.app=my_test(h);
    ROI=h.drawROI();
end

pre_frame=floor(pre/dat_list(1).frame_period);
bck_frame=floor(bck/dat_list(1).frame_period);
end_frame=floor((pre+dur)/dat_list(1).frame_period);

clearvars df_F
for i=1:size(dat_list,2)
    ori=dat_list(i).getROIValue(ROI);
    if size(ori,2)<=floor(end_point/dat_list(1).frame_period)
        ori(:,(end+1):floor(end_point/dat_list(1).frame_period))=ori(:,1:(floor(end_point/dat_list(1).frame_period)-size(ori,2)));    
    end
    ori(:,floor(end_point/dat_list(1).frame_period):end)=[]; % stardarizing the vector length. 
    bck_signal=mean(ori(2,bck_frame:pre_frame));
    temp=ori(2,:)-bck_signal;
    delta=min(temp(1:pre_frame))-0.01; % avoiding negative values  
    if exist('df_F','var')
        df_F(end+1,:)=(ori(2,:)-bck_signal)/(bck_signal);
    else
        df_F=(ori(2,:)-bck_signal)/(bck_signal);
    end
end
if floor((pre-1)/dat_list(1).frame_period)>0
    df_F(:,1:(1+floor((pre-1)/dat_list(1).frame_period)))=[];
end