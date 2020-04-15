function [] = Import_CM_Py_Batch()
%This updates Cue_Map_Data.mat file with all of the data stored in the current folder
%Only sessions not previously incorporated into file are added.

%For analysis, the .mat file will be accessed using the matfile function so
%data will be stored in the following format. Each session will be stored
%as a separate index for each of the variables



%Find the potential files to be added
Source_Folder = pwd;
Data_Folder = '/Recorded Animals/';
%This gets all the files from the directory
AllFiles = dir(sprintf('%s%s',Source_Folder,Data_Folder));

String_Identifier = {'CM'};
File_End = '.txt';

%This puts all of the filenames into a cell array of sessions, with only
%.txt files and files which begin with group
Filenames = {AllFiles.name};

% TXT_File = ~cellfun(@isempty, (strfind(Filenames, File_End)))...
%     & (~cellfun(@isempty, (strfind(Filenames, String_Identifier{1})))); %| ~cellfun(@isempty, (strfind(Filenames, String_Identifier{2}))));

TXT_File = (~cellfun(@isempty, (strfind(Filenames, String_Identifier{1})))); %| ~cellfun(@isempty, (strfind(Filenames, String_Identifier{2}))));

%This reduces the filenames to those which are putative data files
Filenames = Filenames(TXT_File); 

%Open Cue_Map_Data.mat to store the new sessions
%M = matfile('Cue_Map_Data.mat','Writable',true);
%using the matfile function was extremely slow
%M = load('Cue_Map_Data.mat');
M = struct;
%Check whether Cue_Map_Data.mat has been created
% if isempty(who(M))
%     New_Sessions = Filenames;
%     ind = 0;
% else    
% %This finds which sessions are new
% New_Sessions = Filenames(~ismember(M.Filename,Filenames));
% 
% %Add the new sessions to the Cue_Map_Data.mat
% ind = numel(M.Filenames);
% end
New_Sessions = Filenames;
ind = 0;
for i = 1:numel(New_Sessions)
    
    try
        [MAT] = Import_CM_Py(New_Sessions{i});
    catch
        warning('%s%s%s','Problem with session ', New_Sessions{i}, ', was skipped.')
        continue
    end

    ind = ind + 1;
    
    M.Rat(1,ind) = MAT.Rat;
    M.Day(1,ind) = MAT.Day;
    M.Block(1,ind) = {MAT.Block};
    M.BlockSubType(1,ind) = {MAT.BlockSubType};
    M.Vertices(1,ind) = {MAT.Vertices};
    M.Response(1,ind) = {MAT.Response};
    M.Rewards(1,ind) = {MAT.Rewards};
    M.Pokes(1,ind) = {MAT.Pokes};
    M.Resp_Perc(1,ind) = {MAT.Resp_Perc};
    M.Filename(1,ind) = {New_Sessions{i}};
end
save('Cue_Map_Data.mat','M');
clear M

end

