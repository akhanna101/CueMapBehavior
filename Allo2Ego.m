    function [Ego_Order] = Allo2Ego(ListType,Vertices)
    %This function takes an index from the absolute or standard map, and finds the
    %order in which that index occurs in a given trajectory.
    
    %ListType: 1 list of the set {'V1','H1','V2','H2',...
    %Vertices: Vertices to be converted
    
    %For example 'V2' starts in the lower left corner (standardized index
    %of 12 for the the 12 X 12 map), and entering Vertices of [1 2 13] will
    %yield an output of [11 12 13].
    
    gridsize = [12,12];
    MAP = reshape(1:prod(gridsize),gridsize(1),gridsize(2));
    
        for p = 1:gridsize(1)
            if rem(p,2) == 0
                Horz(p, :) = p*gridsize(2):-1:(p - 1)*gridsize(2) + 1;
            else
                
                Horz(p, :) = (p - 1)*gridsize(2) + 1:p*gridsize(2);
            end
        end
        
        HorzL = arrayfun(@(x) find(Horz == x), 1:prod(gridsize));
        
        List.H1 = HorzL';
        List.H2 = ListTransform(HorzL',2);
        List.H3 = ListTransform(HorzL',3);
        List.H4 = ListTransform(HorzL',4);
        
        for p = 1:gridsize(2)
            if rem(p,2) == 0
                Vert(:,p) = p*gridsize(1):-1:(p - 1)*gridsize(1) + 1;
            else
                
                Vert(:,p) = (p - 1)*gridsize(1) + 1:p*gridsize(1);
            end
        end
        
        VertL = arrayfun(@(x) find(Vert == x), 1:prod(gridsize));
        
        List.V1 = VertL';
        List.V2 = ListTransform(VertL',2);
        List.V3 = ListTransform(VertL',3);
        List.V4 = ListTransform(VertL',4);
                
    	Ego_Order = find(ismember(List.(ListType),Vertices));
    
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
        
        
    end

