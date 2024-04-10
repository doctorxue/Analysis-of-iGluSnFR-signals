% small script for plotting in z direction
%names=["T5o","T5t","T5i","T6","T7","T9",'RBC'];
names=["T5o","T5t","T5i","T6","T7","T9"];
% names=["T2","T3b"]
%names=["T6","T7","T9","RBC"];
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
        ind=~isnan(dat(:,j));
        if j==1
            plot(z_pos(ind),dat(ind,j)','color',c_map(i,:),'DisplayName',char(names(i)),'LineWidth',0.5,'Marker','.--','MarkerSize',10);
        else
            plot(z_pos(ind),dat(ind,j)','color',c_map(i,:),'HandleVisibility','off','LineWidth',0.5,'Marker','.--','MarkerSize',10);
        end
        hold on;
    end
    m_dat=mean(dat,1)
end
legend show;




