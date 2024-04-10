% extracting light response

bck_time_bef_ON=1; % the time for background subtraction before every flash
ON_dur=3; % duration for flash ON
post_time_aft_ON=3; % duration for after trace

list_num=4; % index of the dat_list that needs to be processed
threshold=2500;
 
if ~exist('ROI','var') % drawing ROI
    ori_num=1;
    h=dat_list(ori_num).getbck();
    h.app=my_test(h);
    ROI=h.drawROI();
end
df_f=[];
for i=list_num
    x=squeeze(mean(dat_list(i).data(:,:,1,:),[1,2])); % x represents the red channel time series averaged in the whole frame
    a=find(x>threshold); % a represents the time point where flash is on;
    D=diff([0;diff(a)==1;0]);
    on_ind=a(D>0); % on_ind represents the time point of flash beginning
    if isempty(on_ind)
        continue;
    end
    period=dat_list(i).frame_period;
    fluo_value=dat_list(i).getROIValue(ROI);
    df_f_temp=[];
    for j=on_ind
        vec=(j-floor(bck_time_bef_ON/period):1:(j+floor((ON_dur+post_time_aft_ON)/period)));
        temp=fluo_value(2,vec);
        temp_bck=mean(temp(1:floor(bck_time_bef_ON/period)));
        if isempty(df_f_temp)
            df_f_temp(1,:)=(temp-temp_bck)/temp_bck;
        else
            df_f_temp(end+1,:)=(temp-temp_bck)/temp_bck;
        end
    end
    df_f(i,:)=mean(df_f_temp,1);    
end

