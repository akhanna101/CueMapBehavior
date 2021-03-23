function [oneDiffMeans, twoDiffMeans] = directionalDiffFinalExtinction(M2)
    
    %First filter by session date
    date = '11/30/2017'
    idxDate = ismember({M2.Date}, date);
    extinctionStructure = M2(idxDate);
    Response = "Resp_Perc" ;
    %Response = "Resp_Perc";
    
    %Then Filter by ratVector (using ratVector)
    trajRats = [1 2 3 4 6 7 9 10 11 15];
    randRats = [5 12 13 16 17 18 19 20];
    allRats = sort([trajRats randRats]);
    
    ratVector = trajRats;
    idxRat = ismember([extinctionStructure.Rat], ratVector);
    extinctionStructure = extinctionStructure(idxRat);
    trials = ceil(length(extinctionStructure(1).Vertices)/100);
    
    %Create vectors for (1:nAway) poke responses based on towards vs. away
    %For example mean responses if you are within 3 pixles and moving
    %towards versus moving away. (This would be the mean of responses
    %across 1,2,3 towards vs. mean of responses of 1,2,3 away.
    
    %First Hardcoded Two Aways for original and new reward zones
    %Hardcoded TwoAways
    twoAwayOriginal = [15 25 35 45 55 65 66 67 68 69 70 60 50 40 30 20 19 18 17 16 41 51 61 71 81 91 92 93 94 95 96 86 76 66 56 46 45 44 43 42]; 
    twoAwayNew = sort([31 32 33 34 35 25 15 5 70 69 68 67 66 76 86 96]);
    
    %Hardcoded oneAways
    oneAwayOriginal = [26 27 28 29 39 49 59 58 57 56 46 36 52 53 54 55 65 75 85 84 83 82 72 62];
    oneAwayNew = [1 11 21 22 23 24 14 4 77 87 97 78 79 80 90 100];
    
    twoAwayPixels = twoAwayNew;
    oneAwayPixels = oneAwayNew;
    
    %The below block of code finds the responses of all one away pixels (for
    %the first trial), split by towards reward zones vs. away
    %from reward zones vs. post reward zones
    
    oneAwayFirstIDX = NaN(length(ratVector),length(oneAwayPixels));
    oneAwayRewardPoke = NaN(length(ratVector),length(oneAwayPixels),length(find(extinctionStructure(1).Rewards)));
    oneAwayAwayPoke = NaN(length(ratVector),length(oneAwayPixels),length(find(extinctionStructure(1).Rewards)));
    oneAwayPostPoke = NaN(length(ratVector),length(oneAwayPixels),length(find(extinctionStructure(1).Rewards)));
    
    for i = 1:length(extinctionStructure)
        a = find(extinctionStructure(i).Rewards);
        for j = 1:length(oneAwayPixels)
            foundPixels = find(extinctionStructure(i).Vertices == oneAwayPixels(j),1);
            oneAwayFirstIDX(i,j) = foundPixels(end);
            for k = 1:length(a)
                if a(k) - oneAwayFirstIDX(i,j) == 1
                    oneAwayRewardPoke(i,j,k) = extinctionStructure(i).Resp_Perc(oneAwayFirstIDX(i,j));
                elseif -8 <= (a(k) - oneAwayFirstIDX(i,j)) && (a(k) - oneAwayFirstIDX(i,j)) <= -1 % Change this in order to increase post reward exclusions
                    oneAwayPostPoke(i,j,k) = extinctionStructure(i).Resp_Perc(oneAwayFirstIDX(i,j));
                else
                    oneAwayAwayPoke(i,j,k) = extinctionStructure(i).Resp_Perc(oneAwayFirstIDX(i,j));
                end
            end
        end
    end
    

    %The Below block is if you want to include responses from the whole
    %extinction session
%     oneAwayFirstIDX = NaN(length(ratVector),length(oneAwayPixels), trials);
%     oneAwayRewardPoke = NaN(length(ratVector),length(oneAwayPixels),length(find(extinctionStructure(1).Rewards)),trials);
%     oneAwayAwayPoke = NaN(length(ratVector),length(oneAwayPixels),length(find(extinctionStructure(1).Rewards)),trials);
%     oneAwayPostPoke = NaN(length(ratVector),length(oneAwayPixels),length(find(extinctionStructure(1).Rewards)),trials);
%     
%     for i = 1:length(extinctionStructure)
%         a = find(extinctionStructure(i).Rewards);
%         for j = 1:length(oneAwayPixels)
%             for m = 1:length(trials)
%                 foundPixels = find(extinctionStructure(i).Vertices == oneAwayPixels(j),m);
%                 oneAwayFirstIDX(i,j,m) = foundPixels(end);
%                 for k = 1:length(a)
%                     if a(k) - oneAwayFirstIDX(i,j,m) == 1
%                         oneAwayRewardPoke(i,j,k,m) = extinctionStructure(i).Resp_Perc(oneAwayFirstIDX(i,j,m));
%                     elseif -8 <= (a(k) - oneAwayFirstIDX(i,j,m)) && (a(k) - oneAwayFirstIDX(i,j,m)) <= -1 % Change this in order to increase post reward exclusions
%                         oneAwayPostPoke(i,j,k,m) = extinctionStructure(i).Resp_Perc(oneAwayFirstIDX(i,j,m));
%                     else
%                         oneAwayAwayPoke(i,j,k,m) = extinctionStructure(i).Resp_Perc(oneAwayFirstIDX(i,j,m));
%                     end
%                 end
%             end
%         end
%     end
    
    
    oneReward = nanmean(oneAwayRewardPoke,'all');
    oneAway = nanmean(oneAwayAwayPoke,'all');
    onePost = nanmean(oneAwayPostPoke,'all');
    oneAwayRewardVector = oneAwayRewardPoke(:);
    oneAwayAwayPokeVector = oneAwayAwayPoke(:);
    oneAwayPostPokeVector = oneAwayPostPoke(:);
    
    %To Compute standard error for one away
    stderrorOneReward = std(oneAwayRewardVector,'omitnan') / sqrt(length(oneAwayRewardVector) - sum(isnan(oneAwayRewardVector)));
    stderrorOneAway = std(oneAwayAwayPokeVector,'omitnan') / sqrt(length(oneAwayAwayPokeVector) - sum(isnan(oneAwayAwayPokeVector)));
    stderrorOnePost = std(oneAwayPostPokeVector,'omitnan') / sqrt(length(oneAwayPostPokeVector) - sum(isnan(oneAwayPostPokeVector)));
    
    %% Two Away Towards vs. Away
    
    %RESPONSES ONLY FOR THE FIRST TRIAL
    trials = ceil(length(extinctionStructure(1).Vertices)/100);
    twoAwayFirstIDX = NaN(length(ratVector),length(twoAwayPixels));
    twoAwayRewardPoke = NaN(length(ratVector),length(twoAwayPixels),length(find(extinctionStructure(1).Rewards)));
    twoAwayAwayPoke = NaN(length(ratVector),length(twoAwayPixels),length(find(extinctionStructure(1).Rewards)));
    twoAwayPostPoke = NaN(length(ratVector),length(twoAwayPixels),length(find(extinctionStructure(1).Rewards)));
    
    for i = 1:length(extinctionStructure)
        a = find(extinctionStructure(i).Rewards);
        for j = 1:length(twoAwayPixels)
            foundPixels = find(extinctionStructure(i).Vertices == twoAwayPixels(j),1);
            twoAwayFirstIDX(i,j) = foundPixels(end);
            for k = 1:length(a)
                if a(k) - twoAwayFirstIDX(i,j) == 2;
                    twoAwayRewardPoke(i,j,k) = extinctionStructure(i).Resp_Perc(twoAwayFirstIDX(i,j));
                elseif -8 <= (a(k) - twoAwayFirstIDX(i,j)) && (a(k) - twoAwayFirstIDX(i,j))  <= -1; %POST REWARD EXCLUSION MODIFICATION OCCURS HERE...
                    twoAwayPostPoke(i,j,k) = extinctionStructure(i).Resp_Perc(twoAwayFirstIDX(i,j));
                else
                    twoAwayAwayPoke(i,j,k) = extinctionStructure(i).Resp_Perc(twoAwayFirstIDX(i,j));
                end
            end
        end
    end
%     

    %INCLUDE RESPONSES FOR THE WHOLE SESSION
%     trials = ceil(length(extinctionStructure(1).Vertices)/100);
%     twoAwayFirstIDX = NaN(length(ratVector),length(twoAwayPixels),trials);
%     twoAwayRewardPoke = NaN(length(ratVector),length(twoAwayPixels),length(find(extinctionStructure(1).Rewards)),trials);
%     twoAwayAwayPoke = NaN(length(ratVector),length(twoAwayPixels),length(find(extinctionStructure(1).Rewards)),trials);
%     twoAwayPostPoke = NaN(length(ratVector),length(twoAwayPixels),length(find(extinctionStructure(1).Rewards)),trials);
%     
%     for i = 1:length(extinctionStructure)
%         a = find(extinctionStructure(i).Rewards);
%         for j = 1:length(twoAwayPixels)
%             for m = 1:length(trials)
%                 foundPixels = find(extinctionStructure(i).Vertices == twoAwayPixels(j),m);
%                 twoAwayFirstIDX(i,j,m) = foundPixels(end);
%                 for k = 1:length(a)
%                     if a(k) - twoAwayFirstIDX(i,j,m) == 2
%                         twoAwayRewardPoke(i,j,k,m) = extinctionStructure(i).Resp_Perc(twoAwayFirstIDX(i,j,m));
%                     elseif -8 <= (a(k) - twoAwayFirstIDX(i,j,m)) && (a(k) - twoAwayFirstIDX(i,j,m))  <= -1 %POST REWARD EXCLUSION MODIFICATION OCCURS HERE...
%                         twoAwayPostPoke(i,j,k,m) = extinctionStructure(i).Resp_Perc(twoAwayFirstIDX(i,j,m));
%                     else
%                         twoAwayAwayPoke(i,j,k,m) = extinctionStructure(i).Resp_Perc(twoAwayFirstIDX(i,j,m));
%                     end
%                 end
%             end
%         end
%     end

    twoAwayAnimalStructure = NaN(length(ratVector),3);
    for i = 1:length(ratVector)
            twoAwayAnimalStructure(i,1) = nanmean(reshape(twoAwayAwayPoke(i,:,:,:), 1, []));
            twoAwayAnimalStructure(i,2) = nanmean(reshape(twoAwayRewardPoke(i,:,:,:), 1, []));
            twoAwayAnimalStructure(i,3) = nanmean(reshape(twoAwayPostPoke(i,:,:,:,:), 1, []));
    end
    
    oneAwayAnimalStructure = NaN(length(ratVector),3);
    for i = 1:length(ratVector)
        oneAwayAnimalStructure(i,1) = nanmean(reshape(oneAwayAwayPoke(i,:,:,:), 1, []));
        oneAwayAnimalStructure(i,2) = nanmean(reshape(oneAwayRewardPoke(i,:,:,:), 1, []));
        oneAwayAnimalStructure(i,3) = nanmean(reshape(oneAwayPostPoke(i,:,:,:), 1, []));
    end
    

    twoReward = nanmean(twoAwayRewardPoke,'all');
    twoAway = nanmean(twoAwayAwayPoke,'all');
    twoPost = nanmean(twoAwayPostPoke,'all');
    twoAwayRewardVector = twoAwayRewardPoke(:);
    twoAwayAwayPokeVector = twoAwayAwayPoke(:);
    twoAwayPostPokeVector = twoAwayPostPoke(:);
    
    %To Compute standard error for two away responses
    stderrorTwoReward = std(twoAwayRewardVector,'omitnan') / sqrt(length(twoAwayRewardVector) - sum(isnan(twoAwayRewardVector)));
    stderrorTwoAway = std(twoAwayAwayPokeVector,'omitnan') / sqrt(length(twoAwayAwayPokeVector) - sum(isnan(twoAwayAwayPokeVector)));
    stderrorTwoPost = std(twoAwayPostPokeVector,'omitnan') / sqrt(length(twoAwayPostPokeVector) - sum(isnan(twoAwayPostPokeVector)));
    
%% Find Responses at Old Reward Zones, New Reward Zones, and Remaining Pixels

%Responses at New Reward Zones (only first pass through the space)

newRewardPixels = [2,3,12,13,88,89,98,99];
rewardPixels = newRewardPixels;
rewardPokes = NaN(length(extinctionStructure),length(rewardPixels));

for r = 1:length(extinctionStructure)
    for s = 1:length(rewardPixels)
        rewardIDX = find(extinctionStructure(r).Vertices == rewardPixels(s),1); 
        rewardPokes(r,s) = (extinctionStructure(r).Resp_Perc(rewardIDX));
    end
end

rewardPokesVector = rewardPokes(:);
rewardMeanPokes = nanmean(rewardPokesVector);
stderrorReward = std(rewardPokesVector,'omitnan') / sqrt(length(rewardPokesVector) - sum(isnan(rewardPokesVector)));

%Response at Old Reward Zones

oldRewardPixels = [37,38,47,48,63,64,73,74];
oldRewardPokes = NaN(length(extinctionStructure),length(oldRewardPixels));

for r = 1:length(extinctionStructure)
    for s = 1:length(oldRewardPixels)
        rewardIDX(r,s) = find(extinctionStructure(r).Vertices == oldRewardPixels(s),1); 
        oldRewardPokes(r,s) = (extinctionStructure(r).Resp_Perc(rewardIDX(r,s)));
    end
end

oldRewardPokesVector = oldRewardPokes(:);
oldRewardMeanPokes = nanmean(oldRewardPokesVector);
stderrorOldReward = std(oldRewardPokesVector,'omitnan') / sqrt(length(oldRewardPokesVector) - sum(isnan(oldRewardPokesVector)));


%Responses at Remaining Pixels 

exclusion = [oneAwayNew oneAwayOriginal twoAwayNew twoAwayOriginal oldRewardPixels newRewardPixels]; 
exclusion = unique(exclusion);
exclusionLogical = true(1,100);
exclusionLogical(exclusion) = false;
remainderPixels = [1:100];
remainderPixels = remainderPixels(exclusionLogical);

%The section below might need some work, particularly in regards to the sum
%of the remainderPixel logical vector. 
% remainderFirstIndex = NaN(length(extinctionStructure), sum(remainderPixels)); 
% remainderPokes = NaN(length(extinctionStructure), sum(remainderPixels));
% for p = 1:length(extinctionStructure) %This is basically the same as the rat vector because it takes place over one day.
%     for q = 1:sum(remainderPixels);
%         remainderFirstIndex(p,q) = find(extinctionStructure(p).Vertices == remainderPixels(q),1);
%         remainderPokes(p,q) = extinctionStructure(p).Resp_Perc(remainderFirstIndex(p,q));
%     end
% end
% 
% remainderPokeVector = remainderPokes(:);
% remainderMeanPokes = nanmean(remainderPokeVector);
% stderrorRemainder = std(remainderPokeVector,'omitnan') / sqrt(length(remainderPokeVector) - sum(isnan(remainderPokeVector)));


    %HIGH/LOW ERRORS FOR BAR CHARTS
    
%     errhighReward = stderrorReward/2;
%     errlowReward  = stderrorReward/2;
%     
%     errhighRemainder = stderrorRemainder/2;
%     errlowRemainder = stderrorRemainder/2;
    
    
    %three columns, first for post, second for towards reward, third for away from reward zone responding. each row
    %is an animal
    twoDiffMeans = NaN(length(ratVector),3);
    for i = 1:length(ratVector)
        %twoDiffMeans(i, ) = %Actual Rewards.
        twoDiffMeans(i,1) = nanmean(reshape(twoAwayPostPoke(i,:,:,:),1,[]));
        twoDiffMeans(i,2) = nanmean(reshape(twoAwayRewardPoke(i,:,:,:),1,[]));
        twoDiffMeans(i,3) = nanmean(reshape(twoAwayAwayPoke(i,:,:,:),1,[]));
        %twoDiffMeans(i,4) = %oldRewards
        %twoDiffMeans(i,4) = nanmean( %Remainder Pixels
    end
    
    oneDiffMean = NaN(length(ratVector),3);
    for i = 1:length(ratVector)
        oneDiffMeans(i,1) = nanmean(reshape(oneAwayPostPoke(i,:,:,:),1,[]));
        oneDiffMeans(i,2) = nanmean(reshape(oneAwayRewardPoke(i,:,:,:),1,[]));
        oneDiffMeans(i,3) = nanmean(reshape(oneAwayAwayPoke(i,:,:,:),1,[]));
    end
    
    twoPostMean = nanmean(twoDiffMeans(:,1),1);
    twoTowardsMean =  nanmean(twoDiffMeans(:,2),1);
    twoAwayFromMean = nanmean(twoDiffMeans(:,3),1);
    
    onePostMean = nanmean(oneDiffMeans(:,1),1);
    oneTowardsMean = nanmean(oneDiffMeans(:,2),1);
    oneAwayFromMean = nanmean(oneDiffMeans(:,3),1);
 
    %% T tests
    
   [h,p,ci,stats] = ttest(twoAwayAnimalStructure(:,1), twoAwayAnimalStructure(:,2))
   pTwoAwayTowards = p;
   
   [h,p,ci,stats] = ttest(twoAwayAnimalStructure(:,2), twoAwayAnimalStructure(:,3))
   pTwoPostReward = p;
   
   [h,p,ci,stats] = ttest(twoAwayAnimalStructure(:,1), twoAwayAnimalStructure(:,3))
   pTwoPostAway = p;
    
   [h,p,ci,stats] = ttest(oneAwayAnimalStructure(:,1), oneAwayAnimalStructure(:,2))
   pOneAwayTowards = p;
   
   [h,p,ci,stats] = ttest(oneAwayAnimalStructure(:,2), oneAwayAnimalStructure(:,3))
   pOnePostReward = p;
   
   [h,p,ci,stats] = ttest(oneAwayAnimalStructure(:,1), oneAwayAnimalStructure(:,3))
   pOnePostAway = p;
    
    
  %%Plotting  
    figure
    hold on
    %Include a bar graph of means of each group (with errors)
    x = 1:3
    data = [twoPostMean twoTowardsMean twoAwayFromMean];
    
    errhighTwoPost = stderrorTwoPost/2;
    errlowTwoPost = stderrorTwoPost/2;
    errhighTwoReward = stderrorTwoReward/2;
    errlowTwoReward = stderrorTwoReward/2;
    errhighTwoAway = stderrorTwoAway/2;
    errlowTwoAway = stderrorTwoAway/2;
    
    errhigh = [errhighTwoPost errhighTwoReward errhighTwoAway];
    errlow = [errlowTwoPost errlowTwoReward errlowTwoAway];
    bar(x,data, 0.7)
    er = errorbar(x,data,errlow,errhigh);
    er.Color = [0 0 0];
    
    title("Poke Responses During Extinction at Reward Adjacent Pixels (Two Away)")
    xticks([1 2 3])
    xlim([0.5 3.5])
    xticklabels({'Post Reward' 'Towards Reward' 'Away from Reward'})
    ylabel("Resp_Perc")
    
    for p = 1:length(ratVector)
        %Scatter Plots to see breakdown by animal
        scatter(1, twoDiffMeans(p,1))
        scatter(2, twoDiffMeans(p,2))
        scatter(3, twoDiffMeans(p,3))
        plot([1 2 3], [twoDiffMeans(p,1) twoDiffMeans(p,2) twoDiffMeans(p,3)])
         
        %If you want to include post reward zone responses (as their own
        %column, use the commented out lines below. 
        %scatter(3, twoDiffMeans(p,3))
        %plot([1 2 3], [twoDiffMeans(p,1) twoDiffMeans(p,2) twoDiffMeans(p,3)])
        

    end
    hold off
    
    figure 
    hold on
    %Then include a bar graph of means of each group (with errors)
    x = 1:3
    data = [onePostMean oneTowardsMean oneAwayFromMean];
    
    errhighOnePost = stderrorOnePost/2;
    errlowOnePost = stderrorOnePost/2;
    errhighOneReward = stderrorOneReward/2;
    errlowOneReward = stderrorOneReward/2;
    errhighOneAway = stderrorOneAway/2;
    errlowOneAway = stderrorOneAway/2;
    
    errhigh = [errhighOnePost errhighOneReward errhighOneAway];
    errlow = [errlowOnePost errlowOneReward errlowOneAway];
    bar(x,data, 0.7)
    er = errorbar(x,data,errlow,errhigh);
    er.Color = [0 0 0];
    title("Poke Responses During Extinction at Reward Adjacent Pixels (One Away)")
    xticks([1 2 3])
    xlim([0.5 3.5])
    ylim([0 0.3])
    xticklabels({'Post Reward' 'Towards Reward' 'Away from Reward'})
    ylabel("Resp_Perc")
    sigstar({[2 3] [1 2]}, [pOneAwayTowards pOnePostReward])
        
        for p = 1:length(ratVector)
        scatter(1, oneDiffMeans(p,1))
        scatter(2, oneDiffMeans(p,2))
        scatter(3, oneDiffMeans(p,3))
        plot([1 2 3], [oneDiffMeans(p,1) oneDiffMeans(p,2) oneDiffMeans(p,3)])
       
    end
        
