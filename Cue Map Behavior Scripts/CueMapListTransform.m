function [List_Out] = CueMapListTransform(List_In,type,gridsize,varargin)


%This script transforms a list of vertices in the space by redefining which
%corner of the space is the (1,1) point. This is primarily used for
%counterbalancing.

%THis produces a 2D map of the states:
MAP = reshape(1:prod(gridsize),gridsize(1),gridsize(2));

%The varargin input determines whether to run the inverse transposition
if isempty(varargin) || ~varargin{1}
%gridsize = [12 12];

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
    
elseif varargin{1}
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
                nMAP = fliplr(MAP)';
            case 7 %This moves the [1,1] to [1, gridsize(2)] after transposition
                nMAP = flipud(MAP)';
    
            case 8 %THis transposes and flips...
                nMAP = fliplr(flipud(MAP'));
                nMAP = nMAP(:);
       
                
        end
        %List_Out = arrayfun(@(x) nMAP(find(x)),List_In);
        List_Out = arrayfun(@(x) nMAP(x),List_In);
else
    display('varargin must be true or false')
end
end