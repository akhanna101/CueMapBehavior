function [meanPokeMap] = pokeHeatMap(M2);

idxDate = ismember({M2.Date}, {'11/30/2017'});
extinctionStructure = M2(idxDate);

trajRats = [1 2 3 4 6 7 9 10 11 15];
randRats = [5 12 13 16 17 18 19 20];
%idxRat = ismember([extinctionStructure.Rat], randRats);
idxRat = ismember([extinctionStructure.Rat], trajRats);
extinctionStructure = extinctionStructure(idxRat);
trials = ceil(length(extinctionStructure(1).Vertices)/100);

%The below block creates a structure that contains all the poke responses
%for each animal x pixel x trial (with post reward zone removal)
pokeSet = NaN(length(extinctionStructure),100, trials); 
for i = 1:length(extinctionStructure)
    rewards = find(extinctionStructure(i).Rewards);
    for p = 1:100
        for r = 1:length(rewards)
            for t = 1:trials
                indexP = find(extinctionStructure(i).Vertices == p,t);
                pixelTrialIDX = indexP(end);
                if ((rewards(r) - pixelTrialIDX) < 0) &&  ((rewards(r) - pixelTrialIDX) > -1)
                else
                    pokeSet(i,p,t) = (extinctionStructure(i).Pokes(pixelTrialIDX));
                    
                end
            end
        end
    end
end


%DO OUTLINE OF REWARD PIXELS IN RED

meanTrialPokeSet = nanmean(pokeSet,3); % Mean across trials
meanPokeSet = nanmean(meanTrialPokeSet, 1); %Mean across animals 

meanPokeMap = reshape(meanPokeSet, [10 10]);
        
figure
hold on
imagesc(meanPokeMap)


%line([3.5 5.5],[8.5 8.5],'color', 'r')
%imagesc(imgaussfilt(meanPokeMap,0.1))
%imagesc(meanPokeMap)

colorbar
title('Mean Pokes per Pixel')
xlabel("Tone Coordinate")
ylabel("Clicker Coordinate")
hold off
figure
heatmap(meanPokeMap)