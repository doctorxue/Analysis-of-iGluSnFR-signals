% small script for plotting in z direction
%names=["T5o","T5t","T5i","T6","T7","T9",'RBC'];
% names=["T5o","T5t","T5i","T6","T7","T9"];
% names=["T1","T2","T3a","T3b","T4"];
%names=["T6","T7","T9","RBC"];
% names=["T5o","T5t","T6","T7"]
names=["T2","T3b"]
z_pos=[0,2.5,5,7.5,10,12.5,15,-2.5,-5,-7.5,-10,-12.5];
z_pos=[flip(z_pos(8:end)),z_pos(1:7)];
h=figure(1);
c_map=[winter(size(names,2)-2);hot(7)];
c_map(1,:)=[];
c_map(end-2:end,:)=[];
for i=1:size(names,2)
    eval(['dat=',char(names(i)),'_int']);
    for j=1:size(dat,2)
        dat(:,j)=[flip(dat(8:end,j));dat(1:7,j)];
        dat(:,j)=dat(:,j)/max(dat(:,j)); % normalization
    end
    m_dat=nanmean(dat,2);
    m_dat=m_dat/max(m_dat);% normalization
    ind=~isnan(m_dat);
    plot(z_pos(ind),m_dat(ind)','color',c_map(i,:),'DisplayName',char(names(i)),'LineWidth',1.5,'Marker','.','LineStyle','-','MarkerSize',10);
    hold on;
    for j=1:size(dat,2)
        ind=~isnan(dat(:,j));
        plot(z_pos(ind),dat(ind,j)','color',[c_map(i,:),0.3],'HandleVisibility','off','LineWidth',0.5,'LineStyle','--');
        hold on;
    end
    
end
legend show;




