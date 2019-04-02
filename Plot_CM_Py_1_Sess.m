function [ output_args ] = Plot_CM_Py_1_Sess(days)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

Source_Folder = 'E:/Cue Map/Data/0319 Data';


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
rat_use = rat_num == 6;

Response = cell(1,3);
Rewards = cell(1,3);
for i = find(d_use & rat_use)
    filename = sprintf('%s/%s',Source_Folder,Filenames{i})
    [MAT] = Import_CM_Py(filename);
    [Resp,Rew] = Response_MAT(MAT);
    for j = 1:3
        
        Response{j} = cat(1,Response{j},Resp{j});
        Rewards{j} =  cat(1,Rewards{j},Rew{j});
    end    
    
    [App] = Approach_MAT(MAT); 
    
    break
end

Titles = {'Random Walk', 'Vertical', 'Horizontal'};
figure
hold on
for j = 1:3
subplot(1,3,j)
imagesc(reshape((Response{j}),12,12))
set(gca, 'FontSize',16)
title(Titles{j}, 'FontSize',16)
xlabel('Tone Frequency', 'FontSize',16)
ylabel('Click Frequency', 'FontSize',16)
end

set(gcf,'position',[35 390 1530 410])


for j = 1:3
figure
b = bar3(reshape((Response{j}),12,12));
for k = 1:length(b)
    zdata = b(k).ZData;
    b(k).CData = zdata;
    b(k).FaceColor = 'interp';
end
set(gca, 'FontSize',16)
title(Titles{j}, 'FontSize',16)
xlabel('Tone Frequency', 'FontSize',16)
ylabel('Click Frequency', 'FontSize',16)
end

%figure
% hold on
% for j = 1:3
% subplot(2,3,j+3)
% imagesc(reshape((Rewards{j}),12,12))
% end


figure
hold on
errorbar(-60:1:59,mean(App)*100,ste(App)*100)
set(gca, 'FontSize',16, 'box','off')
plot([0 0], [0 60], '--k')
xlabel('Trials - Centered at Reward', 'FontSize',16)
ylabel('Response Percentage','FontSize',16)

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
        if i < 61 || i > numel(MAT.Resp_Perc) - 59
        else
            n = n + 1;
            Resp(n,:) = MAT.Resp_Perc(i-60:i+59);
        end    
    end
    
    end 
    