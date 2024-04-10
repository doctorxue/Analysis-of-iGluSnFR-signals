% extracting light response

bck_time_bef_ON=2; % the time for background subtraction before every flash
ON_dur=3; % duration for flash ON
post_time_aft_ON=3; % duration for after trace

list_num=4; % index of the dat_list that needs to be processed
threshold=-20;
 
df_f=[];
for i=list_num
    x=squeeze(mean(dat_list(i).data(:,:,1,:),[1,2])); % x represents the red channel time series averaged in the whole frame
    x=diff(x);
    a=find(x<threshold); % a represents the time point where flash is on;
    b=diff(a); % copy of flash on
    rep_ind=find(b==1);
    a(rep_ind+1)=[];
    on_ind=a;
    %D=diff([0;diff(a)==1;0]);
    %on_ind=a(D>0); % on_ind represents the time point of flash beginning
    if isempty(on_ind)
        continue;
    end
    period=dat_list(i).frame_period;
    temp=[];
    count=0;
    for j=on_ind
        count=count+1;
        vec=(j-floor(bck_time_bef_ON/period):1:(j+floor((ON_dur+post_time_aft_ON)/period)));
        if count==1
            temp=dat_list(i).data(:,:,:,vec);
        else
            temp=temp+dat_list(i).data(:,:,:,vec);
        end
    end
    temp=temp/length(on_ind);
    h_ave=dat_list(i);
    h_ave.data=h_ave.data-h_ave.data;
    h_ave.data=temp;
    h_ave.num_frame=length(vec);
    [ave_arr(:,:,i),logi_arr(:,:,i)]=h_ave.mat_proc_LR();
end