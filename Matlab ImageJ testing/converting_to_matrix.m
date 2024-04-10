% small script for transforming iGluSnFR data at various depth to matrix
vec_int=zeros(12,1);vec_peak=zeros(12,1);
if exist('u_0','var')
    vec_int(1)=mean(u_0(10:20));vec_peak(1)=max(u_0(10:20));
end

if exist('u_2p5','var')
    vec_int(2)=mean(u_2p5(10:20));vec_peak(2)=max(u_2p5(10:20));
end

if exist('u_5','var')
    vec_int(3)=mean(u_5(10:20));vec_peak(3)=max(u_5(10:20));
end

if exist('u_7p5','var')
    vec_int(4)=mean(u_7p5(10:20));vec_peak(4)=max(u_7p5(10:20));
end

if exist('u_10','var')
    vec_int(5)=mean(u_10(10:20));vec_peak(5)=max(u_10(10:20));
end

if exist('u_12p5','var')
    vec_int(6)=mean(u_12p5(10:20));vec_peak(6)=max(u_12p5(10:20));
end

if exist('u_15','var')
    vec_int(7)=mean(u_15(10:20));vec_peak(7)=max(u_15(10:20));
end

if exist('d_2p5','var')
    vec_int(8)=mean(d_2p5(10:20));vec_peak(8)=max(d_2p5(10:20));
end

if exist('d_5','var')
    vec_int(9)=mean(d_5(10:20));vec_peak(9)=max(d_5(10:20));
end

if exist('d_7p5','var')
    vec_int(10)=mean(d_7p5(10:20));vec_peak(10)=max(d_7p5(10:20));
end

if exist('d_10','var')
    vec_int(11)=mean(d_10(10:20));vec_peak(11)=max(d_10(10:20));
end

if exist('d_12p5','var')
    vec_int(12)=mean(d_12p5(10:20));vec_peak(12)=max(d_12p5(10:20));
end
vec_int(vec_int==0)=nan;vec_peak(vec_peak==0)=nan;
clearvars u_0 u_2p5 u_5 u_7p5 u_10 u_12p5 u_15 d_2p5 d_5 d_7p5 d_10 d_12p5

