function [MAT] = Import_CM_Py(filename)
%This function imports cue map data for the CMv1 script
%   Detailed explanation goes here

%Incase filenames are copied and pasted into the Import_CM_Py function this
%flips the forward slash to backslash in the string. Backslashes are used
%to avoid escape in sprintf
filename(filename == '\') = '/';

%This gets the rat num and list. First get rid of the directory info...
bs = strfind(filename,'/');
if isempty(bs); bs = 0; end
filen = filename(bs(end)+1:end);
nums = regexp(filen,'\d*','Match');
Rat_Num = str2double(nums{1});
List_Num = str2double(nums{2});

%open the file
fileID = fopen(filename);
header = textscan(fileID, '%s %s', 1);

%This flag keeps track of whether the old version of the script is being
%used, or the new version
%old_v = true
old_v = false;

Reward_Zones = cell(1,6);
%The file structure was changed on April 16th. The reward zones were added
%to the top of the file
if all(strncmp(header{1}, 'Reward',6))
   header2 = textscan(fileID, '%s', 3); 
   RZs = regexp(header2{1},'\d*','Match');
   Reward_Zones{Rat_Num} = cellfun(@str2double,RZs);
   %Reward_Zones{Rat_Num} = cellfun(@(x) str2double(x) + 1,RZs);
   old_v = false;
else
    %The following checks the reward zones for each rat to make sure they match
    %the vertices with 'F'. This can be turned off
    Rew_Zones{1} = [26,69,113];%Rew_Zones{1} = [27,70,114];
    Rew_Zones{2} = [26,69,113];%[34,63,115];
    Rew_Zones{3} = [28,71,115];%[111,82,30];
    Rew_Zones{4} = [26,69,113];%Rew_Zones{4} = [118,75,31];
    Rew_Zones{5} = [39,82,126];%Rew_Zones{5} = [27,114,70];
    Rew_Zones{6} = [15,58,102];%Rew_Zones{6} = [34,155,63];
end   

Behavior_Data = textscan(fileID, '%f %s');

%load the LISTS file which contains the list information for each day
%load('E:/Cue Map/Pi_030719_Run/Lists/LISTS_DAT.mat')
%load('C:/Users/khannaa3/Desktop/Cue Map MATLAB/Cue Map 0319/Lists/LISTS_EXTENDED_DAT.mat')
%load('C:/Users/khannaa3/Desktop/Cue Map MATLAB/Behavioral Data Aug 2019/Latent Learning Extinction/Lists_RW/LISTS_DAT.mat')
%load('E:/Cue Map/Pi_030719_Run/Lists_Ext_Traj_1_4/LISTS_DAT2.mat')

%The actual lists should be taken from the file as the random_walk lists
%are randomized for different calls to the Cue_Map_Counterbalance

%Currently 'O' is for an input
DAT.ins = cellfun(@(x) all(strcmp(x,'O')),Behavior_Data{2});
DAT.outs = cellfun(@(x) all(strcmp(x,'I')),Behavior_Data{2});

% DAT.ins = cellfun(@(x) all(strcmp(x,'O')),Behavior_Data{2});
% DAT.outs = cellfun(@(x) all(strcmp(x,'I')),Behavior_Data{2});

DAT.F = cellfun(@(x) all(strcmp(x,'F')),Behavior_Data{2});
DAT.state = cellfun(@str2double,Behavior_Data{2});


Time_Stamps = round(1000*(Behavior_Data{1} - Behavior_Data{1}(1)));

[response]= Logical_On_Off(Time_Stamps(DAT.ins)/1000, Time_Stamps(DAT.outs)/1000,Time_Stamps(1)/1000,Time_Stamps(end)/1000);
%histc of spiketimes as [response]
state_inds = find(~isnan(DAT.state));

check_rews = false;

reward_inds = find(DAT.F);
if isempty(reward_inds)
    check_rews = true;
end    

%This pads the end of state_inds with the end of the session
state_inds(end+1) = find(strcmp('end',Behavior_Data{2}));
%state_inds(end+1) = numel(Behavior_Data{2}) + 1;

%MAT is a structure in which the response for each trial is saved in
%the Response field. The vertices are stored in List and Block info is
%stored in Block

%This gets all of the states:
if old_v
    Vertices = DAT.state(state_inds) + 1;
else
    Vertices = DAT.state(state_inds);
end

%%%%%%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The end was padded
%THere is a problem in which sessions ended before finishing the last cue of the list
%This tags on the correct vertex at the end to allow for the
%Block_Info script to work
Vertices = padlist(Vertices);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%THe rats were counterbalanced according to the CueMapListTransform
%script. To transform the vertices to the standard map run the inverse
%transformation in the script
rat_counter = rem(Rat_Num,8);
    if rat_counter == 0
        rat_counter = 8;
    end    


Vertices = CueMapListTransform(Vertices,rat_counter,[12 12],true);

MAT.Rat = Rat_Num;
MAT.Day = List_Num;

[MAT.Block,MAT.BlockSubType] = Block_Info(Vertices,[12 12]);

%The last vertex is missing:
MAT.Vertices = Vertices(1:end-1)';
MAT.Block = MAT.Block(1:end-1);
MAT.BlockSubType(end) = [];
for i = 1:numel(state_inds)-1
    
    MAT.Response{i} = response(Time_Stamps(state_inds(i))+1:Time_Stamps(state_inds(i+1)));
    
    if check_rews
       MAT.Rewards(i) = any(vertex == (Rew_Zones{Rat_Num}));  
    else
        MAT.Rewards(i) = any(reward_inds > state_inds(i) & reward_inds < state_inds(i+1));
    end
    
    if MAT.Rewards(i) > 0
      %  a = 1
    end    
    MAT.Pokes(i) = sum(diff(MAT.Response{i} == 1));
    MAT.Resp_Perc(i) = sum(MAT.Response{i}/numel(MAT.Response{i}));

end
fclose(fileID);
end

function [padded] = padlist(list)
%THis assumes only one vertex is missing
padded = list;
for i = 1:144
    
    if sum(list == i) < ceil(numel(list)/144)
        padded(end) = i;
        return
    end
end 
end