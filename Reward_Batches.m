function [] = Reward_Batches()
%This function creates a .txt of reward batch files by transforming the
%batch cell array into appropriate coordinates for each of the
%counterbalanced maps.

gridsize = [12 12];

Batch{1} = [19 32 98];
Batch{2} = [27 67 119];

save_folder = 'E:/Cue Map/Pi_030719_Run/Reward_Batches';

%loop through the 8 counterbalanced scripts
for i = 1:8
    
    filename = sprintf('%s/Batch_%d.txt',save_folder,i);
    fileID = fopen(filename,'w');
    
    for j = 1:numel(Batch)
  
        [List_Out] = CueMapListTransform(Batch{j},i,gridsize);
        
        %This turns List_Out into a string with commas separating the
        %rewarded vertices
        Curr_Rew_str = '';
        for k = 1:numel(List_Out)
            Curr_Rew_str = sprintf('%s,%d',Curr_Rew_str,List_Out(k));
        end    
        Curr_Rew_str(1) = [];
        
        fprintf(fileID,'%s\r\n',Curr_Rew_str);
    end
    
    fclose(fileID);
end