function [BlockType,TrajType] = Block_Info(List,gridsize)
%This function takes a cue map list and determines which block are included
%in the session. This script uses a trial and error method to determine
%what the block-type is.

%This script currently assumes a square gridsize in the random jump check
%porint of the scipt

%The list that is input must contain the universal
%indices for the space: top left index is 1, the next row down in the same
%column is index 2. The next colum over, but top row would be the number of
%rows + 1

%Block Types:
%Random-walk
%Vertical
%Horizontal
%Random Jump

%This gets the basic horizontal and vertical lists:
HorzL = Horz(gridsize);
VertL = Vert(gridsize);

%This function loops through each block within the session which is defined
%by the number of vertices in the space

block_length = prod(gridsize);

BlockType = cell(1,numel(List));
TrajType = NaN(1,numel(List));
%Loop through each block:
for i = 1:ceil(numel(List)/block_length)
    
    %This is a dummy variable for tracking when the list has been found
    list_true = false;
    
    %get the range for the current block:
    bl_range = (i-1)*block_length + 1:i*block_length;
    
%     %This if statement was added for situations in which the session did
%     %not reach the 
%     if i == ceil(numel(List)/block_length)
%         bl_range = (i-1)*block_length + 1:numel(List);
%     end
    
    %Get the sublist for the current block:
    slist = List(bl_range);

        
    %Now determine which block type the current portion of the list is:
    %Check Horizontal blocks:
    for j = 1:4
        if all(slist == CueMapListTransform(HorzL,j,gridsize))
            BlockType(bl_range) = repmat({'H'},block_length,1);
            list_true = true;
            TrajType(bl_range) = int8(j*ones(block_length,1));
            break
        end
    end    
    if list_true; continue; end
    
    %check vertical lists
    for j = 1:4
        if all(slist == CueMapListTransform(VertL,j,gridsize))
            BlockType(bl_range) = repmat({'V'},block_length,1);
            list_true = true;
            TrajType(bl_range) = int8(j*ones(block_length,1));
            break
        end
    end    
    if list_true; continue; end
    
    %check whether there is a random jump
    difflist = diff(slist);
    
    %Now add each direction of movement to the indice difference
    direction_mat = [-1 1 -gridsize(1) gridsize(1)];

    %check to make sure the list moved only in one of the directions, if this
    %is not true for any vertice, this is a random jump
    if all(sum(difflist == direction_mat,2) == 1)
        BlockType(bl_range) = repmat({'R'},block_length,1);
        TrajType(bl_range) = NaN(block_length,1);
    else
        %otherwise this is a random walk list
        BlockType(bl_range) = repmat({'J'},block_length,1);
        TrajType(bl_range) = NaN(block_length,1);
    end


end

end

    function [HorzL] = Horz(gridsize)
        
        for p = 1:gridsize(1)
            if rem(p,2) == 0
                Horz(p, :) = p*gridsize(2):-1:(p - 1)*gridsize(2) + 1;
            else
                
                Horz(p, :) = (p - 1)*gridsize(2) + 1:p*gridsize(2);
            end
        end
        
        HorzL = arrayfun(@(x) find(Horz == x), 1:prod(gridsize));
        
        HorzL = HorzL';
    end

    function [VertL] = Vert(gridsize)
        
        for p = 1:gridsize(2)
            if rem(p,2) == 0
                Vert(:,p) = p*gridsize(1):-1:(p - 1)*gridsize(1) + 1;
            else
                
                Vert(:,p) = (p - 1)*gridsize(1) + 1:p*gridsize(1);
            end
        end
        
        VertL = arrayfun(@(x) find(Vert == x), 1:prod(gridsize));
        
        VertL = VertL';
                
    end
