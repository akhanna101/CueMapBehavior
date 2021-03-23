function [meanPokeMaps] = earlyMidLateHeat(M1,ratVector) 

    dates = {'08/09/2017' '08/23/2017' '09/12/2017'};
    meanPokeMaps = NaN(10,10,length(dates));
    idxRat = ismember([M1.Rat], ratVector);
    earlyMidLate = M1(idxRat);
    for d = 1:length(dates);
        idxDate = ismember({earlyMidLate.Date}, dates(d));
        stageSessions = earlyMidLate(idxDate);
        pokeSet = NaN(100, length(stageSessions));
        for i = 1:length(stageSessions)
            postPokeIDX = find(stageSessions(i).Rewards) + [1;2;3];
            postPokeIDX = unique(postPokeIDX(:));
            postPokeLogical = true(length(stageSessions(i).Vertices),1);
            postPokeLogical(postPokeIDX) = false;
            for j = 1:100;
                pokeVertIDX = find(stageSessions(i).Vertices == j);
                pokeVertInclude = ~ismember(pokeVertIDX,postPokeIDX);
                pokeIDX = pokeVertIDX(pokeVertInclude);
                pokeSet(j,i) = mean(stageSessions(i).Resp_Perc(pokeIDX));
            end
        end
        
        pokeSet = mean(pokeSet, 2);
        meanPokeMaps(:,:,d) = reshape(pokeSet, [10,10]);
   
    end
    
    figure
    for k = 1:length(dates);
        subplot(1,3,k) 
        imagesc(imgaussfilt(meanPokeMaps(:,:,k)));
        colorbar
        axis('square')
        title('Mean Pokes per Pixel')
        xlabel("Tone Coordinate")
        ylabel("Clicker Coordinate")
    end
end

        
        
  
%         %Do this figure as a subplot for early, mid, late
%         figure
%         hold on
%         %h = subplot(3,1,d)
%         %imagesc(meanPokeMap)
%         imagesc(imgaussfilt(meanPokeMap));
%         colorbar
%         title('Mean Pokes per Pixel')
%         xlabel("Tone Coordinate")
%         ylabel("Clicker Coordinate")
%         hold off
   

