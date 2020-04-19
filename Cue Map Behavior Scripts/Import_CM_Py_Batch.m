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

TXT_File = ~cellfun(@isempty, (strfind(Filenames, File_End)))...
     & (~cellfun(@isempty, (strfind(Filenames, String_Identifier{1})))); %| ~cellfun(@isempty, (strfind(Filenames, String_Identifier{2}))));

%TXT_File = (~cellfun(@isempty, (strfind(Filenames, String_Identifier{1})))); %| ~cellfun(@isempty, (strfind(Filenames, String_Identifier{2}))));

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
    
    M(1,ind).Rat = uint8(MAT.Rat);
    M(1,ind).Day = uint8(MAT.Day);
    %To reduce memory, block is now saved as an 8bit value
    %Horizontal = 1
    %Vertical = 2
    %Random_Walk = 3
    %Random_Jump = 4
    Blockint = uint8(zeros(size(MAT.Block)));
    Blockint(strcmp('H',MAT.Block)) = 1;
    Blockint(strcmp('V',MAT.Block)) = 2;
    Blockint(strcmp('R',MAT.Block)) = 3;
    Blockint(strcmp('J',MAT.Block)) = 4;
    
    M(1,ind).Block = Blockint;
    M(1,ind).BlockSubType = uint8(MAT.BlockSubType);
    M(1,ind).Vertices = uint16(MAT.Vertices);
   % M(1,ind).Response(1,ind) = single(MAT.Response);
    M(1,ind).Rewards = MAT.Rewards;
    M(1,ind).Pokes = uint8(MAT.Pokes);
    M(1,ind).Resp_Perc = single(MAT.Resp_Perc);
    M(1,ind).Filename = New_Sessions{i};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Uncomment below code to store data using cell arrays rather than structures

%     M{ind}{1} = uint8(MAT.Rat);
%     M{ind}{2} = uint8(MAT.Day);
%     %To reduce memory, block is now saved as an 8bit value
%     %Horizontal = 1
%     %Vertical = 2
%     %Random_Walk = 3
%     %Random_Jump = 4
%     Blockint = uint8(zeros(size(MAT.Block)));
%     Blockint(strcmp('H',MAT.Block)) = 1;
%     Blockint(strcmp('V',MAT.Block)) = 2;
%     Blockint(strcmp('R',MAT.Block)) = 3;
%     Blockint(strcmp('J',MAT.Block)) = 4;
%     
%     M{ind}{3} = Blockint;
%     M{ind}{4} = uint8(MAT.BlockSubType);
%     M{ind}{5} = uint16(MAT.Vertices);
%    % M(1,ind).Response(1,ind) = single(MAT.Response);
%     M{ind}{6} = MAT.Rewards;
%     M{ind}{7} = uint8(MAT.Pokes);
%     M{ind}{8} = single(MAT.Resp_Perc);
%     M{ind}{9} = New_Sessions{i};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
save('Cue_Map_Data.mat','M');
clear M

end

