pre=2;
%bck=1.5;
bck=pre-0.5;
dur=1;
end_point=5;

clearvars dat_list

str=["cell14","region1"];
%str=["2ON","Ca","imaging"];
%str=["ON","SAC","D25","obj255"];

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
names=sort(names(ind)); % ascending order
parent_dir=[char(cd),'\'];

count=0;

for i=1:size(names,2)
    cd([parent_dir,char(names(i))]);
    if i==1
        dat_list(1)=ImagingData(pre,bck,1);
    else
        cind=floor(str2num(extractAfter(names(i),'-')));
        if cind~=i+count
            dat_list(cind-1)=dat_list(1);
            count=count+1;
        end
        dat_list(cind)=ImagingData(pre,bck,1);
    end
end

cd(parent_dir);
clearvars -except dat_list names






