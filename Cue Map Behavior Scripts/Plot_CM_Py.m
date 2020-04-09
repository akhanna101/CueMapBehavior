function [ output_args ] = Plot_CM_Py(days)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%Source_Folder = 'E:/Cue Map/Data/0319 Data';
Source_Folder = 'E:/Cue Map/Data/0919 Data';

File_End = '.txt';


%This gets all the files from the directory
AllFiles = dir(Source_Folder);

% %This sorts the files by animal and run
% [~, Ind] = sort([AllFiles(:).datenum]);
% 
% AllFiles = AllFiles(Ind);

%This puts all of the filenames into a cell array of sessions, with only
%.txt files and files which begin with group
Filenames = {AllFiles.name};

Filenames = Filenames(~cellfun(@isempty, (strfind(Filenames, File_End))));

%This finds the earliest date within the TXT_Files. All session and stage
%information is based on this date. It is important not to include other
%sessions within the folder which are not part of the experiment
rat_list_nums = cellfun(@(x) regexp(x,'\d*','Match'), Filenames,'UniformOutput', false);

for i = 1:numel(rat_list_nums)
    
    rat_num(i) = str2double(rat_list_nums{i}{1});
    day(i) = str2double(rat_list_nums{i}{2});
end

%This gets the days that should be used
d_use = ismember(day,days);

Response = cell(1,3);
Rewards = cell(1,3);
for i = find(d_use)
    filename = sprintf('%s/%s',Source_Folder,Filenames{i});
    [MAT] = Import_CM_Py(filename);
    [Resp,Rew] = Response_MAT(MAT);
    for j = 1:3
        
        Response{j} = cat(1,Response{j},Resp{j});
        Rewards{j} =  cat(1,Rewards{j},Rew{j});
    end    
    
    [App] = Approach_MAT(MAT); 
    
    break
end

figure
hold on
for j = 1:3
subplot(1,3,j)
imagesc(reshape(mean(Response{j}),12,12))
end

figure
hold on
for j = 1:3
subplot(1,3,j)
imagesc(reshape(mean(Rewards{j}),12,12))
end

figure
plot(-10:1:19,mean(App))

end

    function [Resp,Rew] = Response_MAT(MAT)
    Blocks = {'R','V','H'};
    for j = 1:3
        Resp{j} = [];
        Rew{j} = [];
        bl = strncmp(Blocks{j},MAT.Block,1);
        for i = 1:144
            %Edit this to get all trials
            v = MAT.Vertices == i;
            
            Resp{j}(i) = mean(MAT.Resp_Perc(bl & v));
            Rew{j}(i) = mean(MAT.Rewards(bl & v));
        end        
        
    end    
    
    end

    function [Resp,Rew] = Approach_MAT(MAT)
    Blocks = {'V','H'};
    
    rew_inds = find(MAT.Rewards);
    n = 0;
    for i = rew_inds
        
        %Skip random walk blocks
        if ~any(strncmp(MAT.Block(i),Blocks,1))
            continue
        end
        n = n + 1;
        
        Resp(n,:) = MAT.Resp_Perc(i-10:i+9);
    end
    
     
    
    end