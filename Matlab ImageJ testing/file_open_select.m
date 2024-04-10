clearvars h_ave dat_list

pre=1;% pre=2 by defualt
%bck=1.5;
bck=pre-0.5;
dur=0.3;% dur=1 by default
end_point=4;
select_stack_flag=1; % whether or not select particular strings for analysis.
select_stack_num=[3];

str=["cell5","region1"];
% str=["2ON","Ca","imaging"];
% str=["laser","killing"];
%str=["pair1"];

files=dir(cd);
dirFlags = [files.isdir];
subFolders = files(dirFlags); % A structure with extra info.
names=string({subFolders(:).name});

for i=1:size(str,2)
    curr=regexp(names,str(i));
    empty_ind=cellfun('isempty',curr);
    curr(empty_ind)={0};
    if exist('res','var')
        res=cell2mat(curr).*res;
    else
        res=cell2mat(curr);
    end
end
ind=res;
clearvars res;

ind=find(ind);
names=sort(names(ind)); % ascending order, getting the names out.
rnames=[];
for i=1:size(names,2)
    cind(i)=floor(str2num(extractAfter(names(i),'-')));
end

[p,temp]=ismember(select_stack_num,cind);

names=names(temp);

parent_dir=[char(cd),'\'];

count=0;
min_frame=[]; % finally the averaged stack will be truncated to match smallest number of frames
for i=1:size(names,2)
    cd([parent_dir,char(names(i))]);
    dat_list(i)=ImagingData(pre,bck,1);
    if i==1
        min_frame=dat_list(i).num_frame;
    else
        min_frame=min([dat_list(i).num_frame,min_frame]);
    end
end

    h_ave=dat_list(1);
    h_ave.data=h_ave.data-h_ave.data;
    h_ave.data=h_ave.data(:,:,:,1:min_frame);
    for i=1:size(select_stack_num,2)
        h_ave.data=dat_list(i).data(:,:,:,1:min_frame)+h_ave.data;
    end
    h_ave.data=h_ave.data/size(select_stack_num,2);
    h_ave.data=h_ave.data(:,:,:,1:min_frame);
    h_ave.num_frame=min_frame;


cd(parent_dir);
clearvars -except dat_list h_ave






