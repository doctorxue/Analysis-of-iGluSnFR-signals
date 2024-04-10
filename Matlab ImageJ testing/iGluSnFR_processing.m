pre=1;
bck=0.5;
dur=1;
end_point=4;


pre_frame=floor(pre/h.frame_period);
bck_frame=floor(bck/h.frame_period);
end_frame=floor((pre+dur)/h.frame_period);
ori=h.whole_curve;
if size(ori,2)<=floor(end_point/h.frame_period)
    ori(:,(end+1):floor(end_point/h.frame_period))=ori(:,1:(floor(end_point/h.frame_period)-size(ori,2)));
end
ori(:,floor(end_point/h.frame_period):end)=[]; % stardarizing the vector length. 
bck_signal=mean(ori(2,bck_frame:pre_frame));
temp=ori(2,:)-bck_signal;
delta=min(temp(1:pre_frame))-0.01; % avoiding negative values

if exist('df_F','var')
    df_F(end+1,:)=(ori(2,:)-bck_signal-delta)/(bck_signal);
else
    df_F=(ori(2,:)-bck_signal-delta)/(bck_signal);
end