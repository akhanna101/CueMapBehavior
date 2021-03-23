function [animalMeanStructure] = newRandomTraining(M2)
% This function looks at the responding during a session late in the second
% stage random training based on proximity to rewarded locations. 

    idxDate = ismember({M2.Date}, {'11/29/2017'}); %Pick a date late in random training
    learningM = M2(idxDate);

    %First Hardcoded Two Aways for original and new reward zones
    %Hardcoded TwoAways
    twoAwayOriginal = [15 25 35 45 55 65 66 67 68 69 70 60 50 40 30 20 19 18 17 16 41 51 61 71 81 91 92 93 94 95 96 86 76 66 56 46 45 44 43 42]; 
    twoAwayNew = sort([31 32 33 34 35 25 15 5 70 69 68 67 66 76 86 96]);
    
    %Hardcoded oneAways
    oneAwayOriginal = [26 27 28 29 39 49 59 58 57 56 46 36 52 53 54 55 65 75 85 84 83 82 72 62];
    oneAwayNew = [1 11 21 22 23 24 14 4 77 87 97 78 79 80 90 100];
    
    twoAwayPixels = twoAwayNew;
    oneAwayPixels = oneAwayNew;
    
    originalRewardZones = [37,38,47,48,63,64,73,74];
    newRewardZones = [2,3,12,13,88,89,98,99];
    
    trajRats = [1 2 3 4 6 7 9 10 11 15];
    randRats = [5 12 13 16 17 18 19 20];
    ratVector = trajRats;
    idxRat = ismember([learningM.Rat], trajRats);
    learningM = learningM(idxRat);
    
    trials = ceil(length(learningM(1).Vertices)/100);
    %Create a structure which contains the responses for new rewards,
    %oneAwayNew, twoAwayNew, oldRewardZones, and remainder
    
    
    %New and Old Reward Zone Responding
    newRewardResponding = nan(length(learningM), length(newRewardZones)*trials);
    oldRewardResponding = nan(length(learningM), length(originalRewardZones)*trials);
    
    for i = 1:length(learningM)
        for r = 1:length(newRewardZones)
            for s = 1:trials
                rewardIDX = find(learningM(i).Vertices == newRewardZones(r),s);
                rewardIDX = rewardIDX(end);
                newRewardResponding(i,r*s) = learningM(i).Pokes(rewardIDX);
                oldRewardIDX = find(learningM(i).Vertices == originalRewardZones(r),s);
                oldRewardIDX = oldRewardIDX(end);
                oldRewardResponding(i,r*s) = learningM(i).Pokes(oldRewardIDX);
            end
        end
    end
    
    %One Away and Two Away Responding
    oneAwayResponding = nan(length(learningM), length(oneAwayPixels)*trials);
    twoAwayResponding = nan(length(learningM), length(twoAwayPixels)*trials);           
    
    for i = 1:length(learningM)
        for r = 1:length(oneAwayPixels)
            for s = 1:trials
                oneAwayIDX = find(learningM(i).Vertices == oneAwayPixels(r),s);
                oneAwayIDX = oneAwayIDX(end);
                oneAwayResponding(i,r*s) = learningM(i).Pokes(oneAwayIDX);
                twoAwayIDX = find(learningM(i).Vertices == twoAwayPixels(r),s);
                twoAwayIDX = twoAwayIDX(end);
                twoAwayResponding(i,r*s) = learningM(i).Pokes(twoAwayIDX);
            end
        end
    end
    
    %Remainder Responses - Maybe need to exclude post reward zone pixels 
    
    remainderPixels = [1:100];
    exclusion = [originalRewardZones newRewardZones oneAwayPixels twoAwayPixels];
    remainderPixels(exclusion) = [];
    
    remainderResponding = nan(length(learningM), length(remainderPixels)*trials);
    
    for i = 1:length(learningM)
        for r = 1:length(remainderPixels)
            for s = 1:trials
                remainderIDX = find(learningM(i).Vertices == remainderPixels(r),s);
                remainderIDX = remainderIDX(end);
                remainderResponding(i,r*s) = learningM(i).Pokes(remainderIDX);
            end
        end
    end
    
    
   %TO DO... Post Reward Zone Exclusion...
    
   %Take Means and SEMs of different categories
   
   %Means 
   rewardMean = nanmean(newRewardResponding(:));
   oneAwayMean = nanmean(oneAwayResponding(:));
   twoAwayMean = nanmean(twoAwayResponding(:));
   oldRewardMean = nanmean(oldRewardResponding(:));
   remainderMean = nanmean(remainderResponding(:));
   
   %SEM 
   
   stderrorReward = std(newRewardResponding(:),'omitnan') / sqrt(length(newRewardResponding(:)) - sum(isnan(newRewardResponding(:))));
   stderrorOneAway = std(oneAwayResponding(:),'omitnan') / sqrt(length(oneAwayResponding(:)) - sum(isnan(oneAwayResponding(:))));
   stderrorTwoAway = std(twoAwayResponding(:),'omitnan') / sqrt(length(twoAwayResponding(:)) - sum(isnan(twoAwayResponding(:))));
   stderrorOldReward = std(oldRewardResponding(:),'omitnan') / sqrt(length(oldRewardResponding(:)) - sum(isnan(oldRewardResponding(:))));
   stderrorRemainder = std(remainderResponding(:),'omitnan') / sqrt(length(remainderResponding(:)) - sum(isnan(remainderResponding(:))));
   
   %Means separated by animal
   
   meanNewRewardAnimal = nanmean(newRewardResponding, 2);
   meanOneAwayAnimal = nanmean(oneAwayResponding, 2);
   meanTwoAwayAnimal = nanmean(twoAwayResponding, 2);
   meanOldRewardAnimal = nanmean(oldRewardResponding, 2);
   meanRemainderAnimal = nanmean(remainderResponding, 2);
   

      
   animalMeanStructure = nan(length(learningM), 5);
   for i = 1:length(learningM)
       animalMeanStructure(i,1) = meanNewRewardAnimal(i);
       animalMeanStructure(i,2) = meanOneAwayAnimal(i);
       animalMeanStructure(i,3) = meanTwoAwayAnimal(i);
       animalMeanStructure(i,4) = meanOldRewardAnimal(i);
       animalMeanStructure(i,5) = meanRemainderAnimal(i);
   end
   
   %Stats for group comparisons
   %Paired t-test between both samples 
   
   [h,p,ci,stats] = ttest2(newRewardResponding(:),oldRewardResponding(:));
   newOldRewardP = p;
   
   [h,p,ci,stats] = ttest2(newRewardResponding(:),oneAwayResponding(:));
   newOneAwayP = p;
   
   [h,p,ci,stats] = ttest2(oneAwayResponding(:),twoAwayResponding(:));
   oneTwoP = p;
   
   figure
    hold on
    
%     cmap = zeros(5,3);
%     cmap = [colorblind(1,:); colorblind(2,:); colorblind(3,:); colorblind(4,:); colorblind(5,:)];
%     imshow(mapTemplate, 'InitialMagnification', 8000)
%     colormap(parula(5));
%     colorbar;
    
%     x = 1:5;
%     data = [rewardMean oneAwayMean twoAwayMean oldRewardMean remainderMean];
%     bar(x,data)
%     
    x = 1:5;
    data = [(rewardMean-(stderrorReward/2)) (oneAwayMean-(stderrorOneAway/2)) (twoAwayMean-(stderrorTwoAway/2)) (oldRewardMean-(stderrorOldReward/2)) (remainderMean-(stderrorRemainder/2))];
    bar(x,data)
    
    %Maybe do the PPT solution 
    %errhigh = stderror
    %Subtract off errlow from mean
    %errlow = 0 
    errhigh = [stderrorReward stderrorOneAway stderrorTwoAway stderrorOldReward stderrorRemainder];
    errlow = [0 0 0 0 0];
    er = errorbar(x,data,errlow,errhigh, '.');
    er.Color = [0 0 0];
    
    

    %sigstar({[1 4] [2 3] [1 2]}, [newOldRewardP oneTwoP newOneAwayP])
    sigstar({[1 4] [2 3]}, [newOldRewardP oneTwoP])
    
    title("Mean Poke Responses During Late Stage Random Training Session")
    xticks([1 2 3 4 5])
    xlim([0.5 5.5])
    %ylim([0 1.8])
    xticklabels({'Reward' 'One Away' 'Two Away' 'Old Reward' 'Remaining Pixels'})
    ylabel("Pokes")
   
    
    %Plot Heatmap Template
    
%     mapTemplate = ones(100,1);
%     mapTemplate(newRewardZones) = 2;
%     mapTemplate(oneAwayPixels) = 3;
%     mapTemplate(twoAwayPixels) = 4;
%     mapTemplate(originalRewardZones) = 5;
%     
%     mapTemplate = reshape(mapTemplate, [10 10]);
%     mapTemplate = flip(mapTemplate);
%     figure 
%     hold on
%     imagesc(mapTemplate)
%     xlim([0.5 10.5])
%     ylim([0.5 10.5])
%     axis square
%     set(gca,'xtick', ([1:10]), 'xlabel' 'ytick', ([1:10]), 'xgrid', 'on', 'ygrid', 'on', 'gridlinestyle', '-', 'xcolor', 'w', 'ycolor', 'w', 'linewidth', 1);
%     colorbar
%     hold off
%     
%     imshow(mapTemplate, 'InitialMagnification', 8000)
%     
    
    
    %IF YOU WANT SPLIT BY ANIMAL, UNCOMMENT BELOW...
%     
    for p = 1:length(learningM);
        scatter(1, animalMeanStructure(p,1))
        scatter(2, animalMeanStructure(p,2))
        scatter(3, animalMeanStructure(p,3))
        scatter(4, animalMeanStructure(p,4))
        scatter(5, animalMeanStructure(p,5))
        plot([1 2 3 4 5], [animalMeanStructure(p,1) animalMeanStructure(p,2) animalMeanStructure(p,3) animalMeanStructure(p,4) animalMeanStructure(p,5)])
    end
    hold off