function [MAT] = Import_CM_Py(filename)
%This function imports cue map data for the CMv1 script
%   Detailed explanation goes here

%This gets the rat num and list. First get rid of the directory info...
bs = strfind(filename,'/');
filen = filename(bs(end)+1:end);
nums = regexp(filen,'\d*','Match');
Rat_Num = str2double(nums{1});
List_Num = str2double(nums{2});

%open the file
fileID = fopen(filename);
header = textscan(fileID, '%s %s', 1);
Behavior_Data = textscan(fileID, '%f %s');

%load the LISTS file which contains the list information for each day
load('E:/Cue Map/Pi_030719_Run/Lists/LISTS_DAT.mat')

%The actual lists should be taken from the file as the random_walk lists
%are randomized for different calls to the Cue_Map_Counterbalance

%Currently 'O' is for an output
DAT.ins = cellfun(@(x) all(strcmp(x,'O')),Behavior_Data{2});
DAT.outs = cellfun(@(x) all(strcmp(x,'I')),Behavior_Data{2});

DAT.F = cellfun(@(x) all(strcmp(x,'F')),Behavior_Data{2});
DAT.state = cellfun(@str2double,Behavior_Data{2});

Time_Stamps = round(1000*(Behavior_Data{1} - Behavior_Data{1}(1)));

[response]= Logical_On_Off(Time_Stamps(DAT.ins)/1000, Time_Stamps(DAT.outs)/1000,Time_Stamps(1)/1000,Time_Stamps(end)/1000);

state_inds = find(~isnan(DAT.state));
reward_inds = find(DAT.F);

%This pads the end of state_inds with the end of the session
state_inds(end+1) = find(strcmp('end',Behavior_Data{2}));

%MAT is a structure in which the response for each trial is saved in
%the Response field. The vertices are stored in List and Block info is
%stored in Block

n = 0;
MAT.Block = cell(1,numel(state_inds)-1);
for i = 1:numel(state_inds)-1

    n = n + 1; 
    
    %The vertices need to be corrected for the counterbalancing:
    vertex = DAT.state(state_inds(i)) + 1;
    ind_temp = CounterBalance_Key{Rat_Num}(:,1) == vertex; %#ok<USENS>
    vertex = CounterBalance_Key{Rat_Num}(ind_temp,2);
    MAT.Rat = Rat_Num;
    MAT.Day = List_Num;
    

    MAT.Vertices(i) = vertex;
    MAT.Block(i) = LISTS(List_Num).Block(i);
    MAT.Response{i} = response(Time_Stamps(state_inds(i)):Time_Stamps(state_inds(i+1)));
    MAT.Rewards(i) = any(reward_inds > state_inds(i) & reward_inds < state_inds(i+1));
    if MAT.Rewards(i) > 0
        a = 1
    end    
    MAT.Pokes(i) = sum(diff(MAT.Response{i} == 1));
    MAT.Resp_Perc(i) = sum(MAT.Response{i}/numel(MAT.Response{i}));
end

