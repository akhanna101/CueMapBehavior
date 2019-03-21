function [] = Cue_Map_Counterbalance()
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

gridsize = [12 12];

days = 30;

%THis produces a 2D map of the states:
MAP = reshape(1:prod(gridsize),gridsize(1),gridsize(2));

RW_file = 'E:/Cue Map/Pi_030719_Run/RWLists';

save_folder = 'E:/Cue Map/Pi_030719_Run/Lists';

rew_loc = [sub2ind([12 12],3,3) sub2ind([12 12],10,6) sub2ind([12 12],6,10)];
    
blocks = 4;

%This gets the horizontal and vertical lists
List = HVList();
RW_List = RWList();

%Vertical and horizontal are counterbalanced such that on any given day
%movement along a trajectory is in the same direction for the two vertical
%and two horizontal lists. For even numbered gridsizes this amounts to
%either using the top left and bottom right corners to start or the top
%right and bottom left corners. Counterbalancing is done such that every 4
%days each possible combination of vertical and horizontal lists are done
%Day 1: top left and bottom right corners are used for starting points for
%both horizontal and vertical trajectories
%Day 2: top left and bottom right corner starting positions for horizontal
%and top right and bottom left corners for vertical.
%Day 3: top right and bottom left corners for both
%Day 4: top right and bottom left for horizontal and opposite for vertical
%top left corner = 1
%bottom left corner = 2
%top right corner = 3
%bottom right corner = 4

RW{1} = [1; 4; 4; 1];
RW{2} = [4; 1; 2; 3];
RW{3} = [2; 3; 3; 2];
RW{4} = [3; 1; 2; 4];

V{1} = [1 4; 4 1; 4 1; 1 4];
H{1} = [4 1; 1 4; 1 4; 4 1];
V{2} = [4 1; 1 4; 1 4; 4 1];
H{2} = [3 2; 2 3; 2 3; 3 2];
V{3} = [3 2; 2 3; 2 3; 3 2];
H{3} = [2 3; 3 2; 3 2; 2 3];
V{4} = [2 3; 3 2; 3 2; 2 3];
H{4} = [1 4; 4 1; 4 1; 1 4];

RW{5} = [4; 1; 1; 4];
RW{6} = [2; 3; 4; 1];
RW{7} = [3; 2; 2; 3];
RW{8} = [1; 4; 3; 2];

V{5} = [4 1; 1 4; 1 4; 4 1];
H{5} = [1 4; 4 1; 4 1; 1 4];
V{6} = [1 4; 4 1; 4 1; 1 4];
H{6} = [2 3; 3 2; 3 2; 2 3];
V{7} = [2 3; 3 2; 3 2; 2 3];
H{7} = [3 2; 2 3; 2 3; 3 2];
V{8} = [3 2; 2 3; 2 3; 3 2];
H{8} = [4 1; 1 4; 1 4; 4 1];

%This gives the block counterbalance per day. !!!!!!We want jumps between
%all blocks, so we have to make sure that vertical lists starting in the
%top left corner are not followed by horizontal lists starting in the
%bottom right corner as there would be no 'jump' between block changes. For
%this reason we have to define the counterbalance across days:
%Here:
%Random Walk Block = 1
%Vertical Block = 2
%Horizontal Block = 3

Block_Counter{1} = [1 2 3; 2 3 1; 3 2 1; 1 3 2];
Block_Counter{2} = [3 2 1; 2 1 3; 1 3 2; 3 1 2];
Block_Counter{3} = [1 3 2; 3 2 1; 2 1 3; 2 3 1];
Block_Counter{4} = [2 1 3; 1 3 2; 1 3 2; 3 1 2];
Block_Counter{5} = [2 3 1; 3 2 1; 3 1 2; 1 2 3];
Block_Counter{6} = [3 1 2; 1 3 2; 1 3 2; 2 1 3];
Block_Counter{7} = [1 3 2; 2 1 3; 3 2 1; 3 2 1];
Block_Counter{8} = [2 1 3; 1 3 2; 2 1 3; 3 2 1];

%This keeps track of which random walk list is currently being used
for i = 1:4
    RWn(i) = 0;
end
%Counterbalance rats by direction of tones and clicks. There are four
%groups - tones increasing and clicks decreasing; vice versa, and the axes flipped for both

for i = 1:24%days
    %The counterbalancing repeats every 8 days
    cb = mod(i,8);
    cb(cb==0)=8;
    L = [];
    %CB_Mat = Unique_Rand_Mat(blocks)
    for j = 1:blocks
        
        %this loops through each trajectory type
        for m = 1:3
            
            switch Block_Counter{cb}(j,m)
                
                case 1 %Random Walk
                    %random walk lists have 2 visits of each vertex
                    %This iterates the random walk list
                    RWn(RW{cb}(j)) = RWn(RW{cb}(j)) + 1;
                    
                    NewL = RW_List{RW{cb}(j)}{RWn(RW{cb}(j))};
                    %This just double checks to make sure there is a jump
                    %between the block change
                    if isempty(L) 
                    elseif NewL(1) == L(end)
                        disp('no jump between blocks')
                        fprintf('%d,%d,%d',cb,j,m)
                    end    
                    L = cat(1,L,NewL);
                    
                case 2 %Vertical Block
                    NewL = cat(1,List.Vert{V{cb}(j,1)}(:),List.Vert{V{cb}(j,2)}(:));
                    %This just double checks to make sure there is a jump
                    %between the block change
                    if isempty(L)
                    elseif NewL(1) == L(end)
                        disp('no jump between blocks')
                        fprintf('%d,%d,%d',cb,j,m)
                    end  
                    L = cat(1,L,NewL);
                    
                case 3 %Horizontal Block
                    NewL = cat(1,List.Horz{H{cb}(j,1)}(:),List.Horz{H{cb}(j,2)}(:));
                    %This just double checks to make sure there is a jump
                    %between the block change
                    if isempty(L)
                    elseif NewL(1) == L(end)
                        disp('no jump between blocks')
                        fprintf('%d,%d,%d',cb,j,m)
                    end  
                    L = cat(1,L,NewL);
                    
            end
        end
    end
    %This goes through and double checks the list to make sure there are no
    %issues
    [Error] = CheckList(L);
    if Error
        disp('Error with list')
    end    
    
    %This next loop creates 8 counterbalanced lists which have the same path through
    %space yet rotated and flipped such that each corner is started from
    %twice with mirrored starts at each corner. 
    
    %First_Rew jut double checks to make sure the rewarded location is at
    %the same location in each list
    First_Rew = L == rew_loc(1);
    for k = 1:8
        RewardLoc = ListTransform(rew_loc,k);
        Lk = ListTransform(L,k);
        if ~all(First_Rew == (Lk == RewardLoc(1)))
            disp('error in reward location')
        end    
        savelist(Lk,RewardLoc,k,i);
    end
    
end

    function [List_Out] = ListTransform(List_In,type)
        
        %This function tranforms the current list to a different
        %starting position.
        switch type
            %Cases 1 - 4 are transforms in which the [1,1] maps to itself,
            %[gridsize(1),1], to [1,gridsize(2)], and [gridsize(1) gridsize(2)].
            %Cases 5 - 6 are the same as 1-4 after the map has been
            %transposed
            case 1 %Nothing changes for this case:
                List_Out = List_In;
                return
            case 2 %This moves the [1,1] to [gridsize(1),1]
                nMAP = flipud(MAP);    
            case 3 %This moves the [1,1] to [1,gridsize(2)]
                nMAP = fliplr(MAP);    
            case 4 %This flips both axes
                nMAP = fliplr(flipud(MAP)); %#ok<*FLUDLR>
                nMAP = nMAP(:);
            case 5 %This transposes the axes
                nMAP = MAP';
                nMAP = nMAP(:);
            case 6 %This moves the [1,1] to [gridsize(1),1] after transposition
                nMAP = fliplr(MAP');
            case 7 %This moves the [1,1] to [1, gridsize(2)] after transposition
                nMAP = flipud(MAP');
    
            case 8 %THis transposes and flips...
                nMAP = fliplr(flipud(MAP'));
                nMAP = nMAP(:);
       
                
        end
        %List_Out = arrayfun(@(x) nMAP(find(x)),List_In);
        List_Out = arrayfun(@(x) nMAP(x),List_In);
    end

    function [List] = HVList()
        
        for p = 1:gridsize(1)
            if rem(p,2) == 0
                Horz(p, :) = p*gridsize(2):-1:(p - 1)*gridsize(2) + 1;
            else
                
                Horz(p, :) = (p - 1)*gridsize(2) + 1:p*gridsize(2);
            end
        end
        
        HorzL = arrayfun(@(x) find(Horz == x), 1:prod(gridsize));
        
        List.Horz{1} = HorzL';
        List.Horz{2} = ListTransform(HorzL',2);
        List.Horz{3} = ListTransform(HorzL',3);
        List.Horz{4} = ListTransform(HorzL',4);
        
        for p = 1:gridsize(2)
            if rem(p,2) == 0
                Vert(:,p) = p*gridsize(1):-1:(p - 1)*gridsize(1) + 1;
            else
                
                Vert(:,p) = (p - 1)*gridsize(1) + 1:p*gridsize(1);
            end
        end
        
        VertL = arrayfun(@(x) find(Vert == x), 1:prod(gridsize));
        
        List.Vert{1} = VertL';
        List.Vert{2} = ListTransform(VertL',2);
        List.Vert{3} = ListTransform(VertL',3);
        List.Vert{4} = ListTransform(VertL',4);
                
    end

    function [RW_List] = RWList()
        
        A = load(RW_file);
        
        
        n = 0;
        for jj = 1:20
            %THe first run through ii switches whether the MAP is transposed
            %before transformations to each corner
            for ii = 1:2
                n = n + 1;
                for kk = 1:4
                    RW_List{kk}{n} = ListTransform(A.RWLists(jj,:)',(ii-1)*4+kk); %#ok<*AGROW,*NODEF>
                end
            end
            %This randomizes the lists after 4 lists have been used for a
            %full counterbalance after 10*8 random walks pulled
            %number of lists to randomize after:
            list2counter = 10;
            if mod(jj,list2counter) == 0
                inds = list2counter*(floor(jj/list2counter)-1)+1:jj;
                for kk = 1:4
                RW_List{kk}(inds) = RW_List{kk}(list2counter*(floor(jj/10)-1)+randperm(list2counter));
                end
            end    
        end

    end
        function [] = savelist(listin,Reward_Loc,ratnum,day)
            
            
            filename = sprintf('%s/List_%d_%d.txt',save_folder,ratnum,day);
            fileID = fopen(filename,'w');
            fprintf(fileID,'%5s %d %3s %d\r\n','##Rat',ratnum,'Day',day);
            fprintf(fileID,'%10s\r\n','##rewards');
            fprintf(fileID,'%d\r\n',Reward_Loc);
            fprintf(fileID,'%10s\r\n','##Vertices');
            fprintf(fileID,'%d\r\n',listin);
            fclose(fileID);
            
        end
    
    function [Error] = CheckList(L)
        
        %First check to make sure that each vertex is visited the same
        %number of times in the list
        for q = 1:prod(gridsize)
            sums(q) = sum(L==q);
        end
        Unequal_Travels = numel(unique(sums)) ~= 1;
        
        %Check whether there are any jumps in the list that are not at a
        %the end of a single pass through the space (no jumps between
        %multiples of the total number of vertices (144 for 12x12) 
        D_Check = [-1 1 -12 12];
        Jump = false;
        
        for q = 2:numel(L)
            if ~any(L(q) + D_Check == L(q-1))
                if mod(q,prod(gridsize)) ~= 1
                    Jump = True;
                    break
                end   
            end
        end
        Error = Unequal_Travels || Jump;
    end   
end
    



% RW{1} = [1; 4; 4];
% RW{2} = [4; 1; 2];
% RW{3} = [2; 3; 3];
% RW{4} = [3; 1; 2];
% 
% V{1} = [1 4; 4 1; 1 4];
% H{1} = [4 1; 1 4; 4 1];
% V{2} = [4 1; 1 4; 1 4];
% H{2} = [3 2; 2 3; 2 3];
% V{3} = [3 2; 2 3; 3 2];
% H{3} = [2 3; 3 2; 2 3];
% V{4} = [2 3; 3 2; 3 2];
% H{4} = [1 4; 4 1; 4 1];
% 
% RW{5} = [4; 1; 1];
% RW{6} = [2; 3; 4];
% RW{7} = [3; 2; 2];
% RW{8} = [1; 4; 3];
% 
% V{5} = [4 1; 1 4; 4 1];
% H{5} = [1 4; 4 1; 1 4];
% V{6} = [1 4; 4 1; 4 1];
% H{6} = [2 3; 3 2; 3 2];
% V{7} = [2 3; 3 2; 2 3];
% H{7} = [3 2; 2 3; 3 2];
% V{8} = [3 2; 2 3; 2 3];
% H{8} = [4 1; 1 4; 1 4];