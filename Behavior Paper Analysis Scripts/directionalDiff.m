function [oneDiffMeans, twoDiffMeans] = directionalDiff(M1)
    
    %WOULD BE WORTH CHECKING TO SEE WHAT BINS ARE ACTUALLY BEING USED
    %HERE. IS THIS FULL CUE OR JUST FIRST BIN????
    %First filter by session date
    date = '09/13/2017'
    %date = '11/30/2017'
    idxDate = ismember({M1.Date}, date);
    sessionStructure = M1(idxDate);
    
    %Then Filter by ratVector (using ratVector)
    trajRats = [1 2 3 4 6 7 9 10 11 15];
    randRats = [5 12 13 16 17 18 19 20];
    allRats = sort([trajRats randRats]);
    
    ratVector = trajRats;
    idxRat = ismember([sessionStructure.Rat], ratVector);
    sessionStructure = sessionStructure(idxRat);
    trials = ceil(length(sessionStructure(1).Vertices)/100);
    
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
    
    twoAwayPixels = twoAwayOriginal;
    oneAwayPixels = oneAwayOriginal;
    
    nextRewardZones = [2,3,12,13,88,89,98,99];
    nextRewardZonesIDX = find(sessionStructure(1).Vertices == any(nextRewardZones));
    nextRewardVector = ismember(sessionStructure(1).Vertices ,nextRewardZones);
    
   %% %The below block of code finds the responses of all one away pixels (for
    %the whole session), split by towards reward zones vs. away
    %from reward zones vs. post reward zones
    
    oneAwayFirstIDX = NaN(length(ratVector),length(oneAwayPixels),trials);
    oneAwayRewardPoke = NaN(length(ratVector),length(oneAwayPixels),length(find(sessionStructure(1).Rewards)),trials);
    oneAwayAwayPoke = NaN(length(ratVector),length(oneAwayPixels),length(find(sessionStructure(1).Rewards)),trials);
    oneAwayPostPoke = NaN(length(ratVector),length(oneAwayPixels),length(find(sessionStructure(1).Rewards)),trials);
    
    for i = 1:length(sessionStructure)
        a = find(sessionStructure(i).Rewards);
        for j = 1:length(oneAwayPixels)
            for m = 1:trials
                foundPixels = find(sessionStructure(i).Vertices == oneAwayPixels(j),m);
                oneAwayFirstIDX(i,j,m) = foundPixels(end);
                for k = 1:length(a)
                    if a(k) - oneAwayFirstIDX(i,j,m) == 1
                        oneAwayRewardPoke(i,j,k,m) = sessionStructure(i).Resp_Perc(oneAwayFirstIDX(i,j,m));
                    elseif -3 <= (a(k) - oneAwayFirstIDX(i,j,m)) && (a(k) - oneAwayFirstIDX(i,j,m)) <= -1 %TRY CHANGING THESE VALUES AROUND TO LENGTHEN POST REWARD EXCLUSION...
                        oneAwayPostPoke(i,j,k,m) = sessionStructure(i).Resp_Perc(oneAwayFirstIDX(i,j,m));
                    else
                        oneAwayAwayPoke(i,j,k,m) = sessionStructure(i).Resp_Perc(oneAwayFirstIDX(i,j,m));
                    end
                end
            end
        end
    end

    
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
    
    trials = ceil(length(sessionStructure(1).Vertices)/100);
    twoAwayFirstIDX = NaN(length(ratVector),length(twoAwayPixels),(trials));
    twoAwayRewardPoke = NaN(length(ratVector),length(twoAwayPixels),length(find(sessionStructure(1).Rewards)),trials);
    twoAwayAwayPoke = NaN(length(ratVector),length(twoAwayPixels),length(find(sessionStructure(1).Rewards)),trials);
    twoAwayPostPoke = NaN(length(ratVector),length(twoAwayPixels),length(find(sessionStructure(1).Rewards)),trials);
    
    for i = 1:length(sessionStructure)
        a = find(sessionStructure(i).Rewards);
        for j = 1:length(twoAwayPixels)
            for m = 1:trials
                foundPixels = find(sessionStructure(i).Vertices == twoAwayPixels(j),m);
                twoAwayFirstIDX(i,j,m) = foundPixels(end);
                for k = 1:length(a)
                    if a(k) - twoAwayFirstIDX(i,j,m) == 2;
                        twoAwayRewardPoke(i,j,k,m) = sessionStructure(i).Resp_Perc(twoAwayFirstIDX(i,j,m));
                    elseif -3 <= (a(k) - twoAwayFirstIDX(i,j,m)) && (a(k) - twoAwayFirstIDX(i,j,m)) <= -1 %TRY CHANGING THESE VALUES AROUND TO LENGTHEN POST REWARD EXCLUSION...
                        twoAwayPostPoke(i,j,k,m) = sessionStructure(i).Resp_Perc(twoAwayFirstIDX(i,j,m));
                    else
                        twoAwayAwayPoke(i,j,k,m) = sessionStructure(i).Resp_Perc(twoAwayFirstIDX(i,j,m));
                    end
                end
            end
        end
    end

    twoReward = nanmean(twoAwayRewardPoke,'all');
    twoAway = nanmean(twoAwayAwayPoke,'all');
    twoPost = nanmean(twoAwayPostPoke,'all');
    twoAwayRewardVector = twoAwayRewardPoke(:);
    twoAwayAwayPokeVector = twoAwayAwayPoke(:);
    twoAwayPostPokeVector = twoAwayPostPoke(:);
    
    %CREATE STRUCTURES OF MEANS FOR EACH ANIMAL FOR USE IN T-TEST WITH
    %LOWER DEGREES OF FREEDOM
    
    %Fix the reshape
    
    collapseMeanTwoAway = squeeze(mean(twoAwayAwayPoke, [2 3], 'omitnan'));
    collapseMeanTwoReward = squeeze(mean(twoAwayRewardPoke, [2 3], 'omitnan'));
    collapseMeanTwoPost = squeeze(mean(twoAwayPostPoke, [2 3], 'omitnan'));
    collapseMeanOneAway = squeeze(mean(oneAwayAwayPoke, [2 3], 'omitnan'));
    collapseMeanOneReward = squeeze(mean(oneAwayRewardPoke, [2 3], 'omitnan'));
    collapseMeanOnePost = squeeze(mean(oneAwayPostPoke, [2 3], 'omitnan'));
    
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
    

    
    %To Compute standard error for two away responses
    stderrorTwoReward = std(twoAwayRewardVector,'omitnan') / sqrt(length(twoAwayRewardVector) - sum(isnan(twoAwayRewardVector)));
    stderrorTwoAway = std(twoAwayAwayPokeVector,'omitnan') / sqrt(length(twoAwayAwayPokeVector) - sum(isnan(twoAwayAwayPokeVector)));
    stderrorTwoPost = std(twoAwayPostPokeVector,'omitnan') / sqrt(length(twoAwayPostPokeVector) - sum(isnan(twoAwayPostPokeVector)));
    
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
        twoDiffMeans(i,1) = nanmean(reshape(twoAwayPostPoke(i,:,:,:,:),1,[]));
        twoDiffMeans(i,2) = nanmean(reshape(twoAwayRewardPoke(i,:,:,:,:),1,[]));
        twoDiffMeans(i,3) = nanmean(reshape(twoAwayAwayPoke(i,:,:,:,:),1,[]));
    end
    
    oneDiffMean = NaN(length(ratVector),3);
    for i = 1:length(ratVector)
        oneDiffMeans(i,1) = nanmean(reshape(oneAwayPostPoke(i,:,:,:,:),1,[]));
        oneDiffMeans(i,2) = nanmean(reshape(oneAwayRewardPoke(i,:,:,:,:),1,[]));
        oneDiffMeans(i,3) = nanmean(reshape(oneAwayAwayPoke(i,:,:,:,:),1,[]));
    end
    
    twoPostMean = nanmean(twoDiffMeans(:,1),1);
    twoTowardsMean =  nanmean(twoDiffMeans(:,2),1);
    twoAwayFromMean = nanmean(twoDiffMeans(:,3),1);
    
    onePostMean = nanmean(oneDiffMeans(:,1),1);
    oneTowardsMean = nanmean(oneDiffMeans(:,2),1);
    oneAwayFromMean = nanmean(oneDiffMeans(:,3),1);
    
 %%   %TO COMBINE ONEAWAY AND TWOAWAY INTO JUST TOWARDS VS AWAY (INCLUDING
    %ALL ADJACENT PIXELS, MAYBE CONCATENATE THE FULL VECTORS).
    
    towardsVector = [oneAwayRewardVector; twoAwayRewardVector];
    awayVector = [oneAwayAwayPokeVector; twoAwayAwayPokeVector];
    postVector = [oneAwayPostPokeVector; twoAwayPostPokeVector];
    
    stderrorTowards = std(towardsVector,'omitnan') / sqrt(length(towardsVector) - sum(isnan(towardsVector)));
    stderrorAway = std(awayVector,'omitnan') / sqrt(length(awayVector) - sum(isnan(awayVector)));
    stderrorPost = std(postVector,'omitnan') / sqrt(length(postVector) - sum(isnan(postVector)));
    
    errhighTowards = stderrorTowards/2;
    errlowTowards = errhighTowards;
    errhighAway = stderrorAway/2;
    errlowAway = errhighAway;
    errhighPost = stderrorPost/2;
    errlowPost = errhighPost;
    
    %Now think about how to do scatter plot for individual animals here...
    %You want a structure that is 10 x 2. But should start as 10 x 
    
    awayMatrix = cat(2, oneAwayAwayPoke, twoAwayAwayPoke); 
    towardsMatrix = cat(2, oneAwayRewardPoke, twoAwayRewardPoke);
    postMatrix = cat(2, oneAwayPostPoke, twoAwayPostPoke);
    
    combinedDiffMeans = NaN(length(ratVector),3);
    for r = 1:length(ratVector)
        combinedDiffMeans(r,1) = nanmean(reshape(postMatrix(r,:,:,:,:),1,[]));
        combinedDiffMeans(r,2) = nanmean(reshape(towardsMatrix(r,:,:,:,:),1,[]));
        combinedDiffMeans(r,3) = nanmean(reshape(awayMatrix(r,:,:,:,:),1,[]));
    end
    
    postMeansRats = nanmean(combinedDiffMeans(:,1),1);
    towardsMeansRats = nanmean(combinedDiffMeans(:,2),1);
    awayMeansRats = nanmean(combinedDiffMeans(:,3),1);
    
%% Find Responding at Rewarded Pixels and Remainder Pixels
    
%Responses at New Reward Zones (only first pass through the space)
%newRewardPixels = [2,3,12,13,88,89,98,99];
oldRewardPixels = [37,38,47,48,63,64,73,74];
rewardPixels = oldRewardPixels;
rewardPokes = NaN(length(sessionStructure),length(rewardPixels));

for r = 1:length(sessionStructure)
    for s = 1:length(rewardPixels)
        rewardIDX = find(sessionStructure(r).Vertices == rewardPixels(s),1); 
        rewardPokes(r,s) = (sessionStructure(r).Resp_Perc(rewardIDX));
    end
end

rewardPokesVector = rewardPokes(:);
rewardMeanPokes = nanmean(rewardPokesVector);
stderrorReward = std(rewardPokesVector,'omitnan') / sqrt(length(rewardPokesVector) - sum(isnan(rewardPokesVector)));

%Response at Old Reward Zones

oldRewardPixels = [37,38,47,48,63,64,73,74];
oldRewardPokes = NaN(length(sessionStructure),length(oldRewardPixels));

for r = 1:length(sessionStructure)
    for s = 1:length(oldRewardPixels)
        rewardIDX(r,s) = find(sessionStructure(r).Vertices == oldRewardPixels(s),1); 
        oldRewardPokes(r,s) = (sessionStructure(r).Resp_Perc(rewardIDX(r,s)));
    end
end

oldRewardPokesVector = oldRewardPokes(:);
oldRewardMeanPokes = nanmean(oldRewardPokesVector);
stderrorOldReward = std(oldRewardPokesVector,'omitnan') / sqrt(length(oldRewardPokesVector) - sum(isnan(oldRewardPokesVector)));

%%t tests for mean towards vs away

    %Includes trials 
%    [h,p,ci,stats] = ttest(collapseMeanTwoAway(:), collapseMeanTwoReward(:))
%    [h,p,ci,stats] = ttest(collapseMeanOneAway(:), collapseMeanOneReward(:))
   
   %Mean across trials
   [h,p,ci,stats] = ttest(twoAwayAnimalStructure(:,1), twoAwayAnimalStructure(:,2))
   pTwoAwayTowards = p;
   
   [h,p,ci,stats] = ttest(twoAwayAnimalStructure(:,2), twoAwayAnimalStructure(:,3))
   pTwoPostReward = p;
   
   [h,p,ci,stats] = ttest(twoAwayAnimalStructure(:,1), twoAwayAnimalStructure(:,3))
   pTwoPostAway = p;
   
%    
%    [h,p,ci,stats] = ttest(oneAwayAnimalStructure(:,1), oneAwayAnimalStructure(:,2))
%    
%    
%    [h,p,ci,stats] = ttest(twoAwayAwayPokeVector, twoAwayRewardVector)
   

%% Plotting

%Figure for combined towards vs away


    figure
    hold on
    x = 1:3;
    data = [postMeansRats towardsMeansRats awayMeansRats];
    
    errhigh = [errhighPost errhighTowards errhighAway];
    errlow = [errlowPost errlowTowards errlowAway];
    bar(x,data, 0.7)
    er = errorbar(x,data,errlow,errhigh);
    er.Color = [0 0 0];
    
    title("Poke Responses during First Stage at Reward Adjacent Pixels (Within 2 pixels)")
    xticks([1 2 3])
    xlim([0.5 3.5])
    xticklabels({'Post Reward' 'Towards Reward' 'Away from Reward'})
    ylabel("Resp_Perc")
    
    for p = 1:length(ratVector);
        scatter(1, combinedDiffMeans(p,1))
        scatter(2, combinedDiffMeans(p,2))
        scatter(3, combinedDiffMeans(p,3))
        plot([1 2 3], [combinedDiffMeans(p,1) combinedDiffMeans(p,2) combinedDiffMeans(p,3)])
    end
    hold off

%Figure for twoAway
    figure
    hold on
    %Include a bar graph of means of each group (with errors)
    x = 1:3;
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
    sigstar({[2 3] [1 3] [1 2]}, [pTwoAwayTowards pTwoPostAway pTwoPostReward])
    
    title("Poke Responses during First Stage at Reward Adjacent Pixels (Two Away)")
    xticks([1 2 3]);
    xlim([0.5 3.5]);
    ylim([0 0.6]);
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
    title("Poke Responses During First Stage at Reward Adjacent Pixels (One Away)")
    xticks([1 2 3])
    xlim([0.5 3.5])
    xticklabels({'Post Reward' 'Towards Reward' 'Away from Reward'})
    ylabel("Resp_Perc")
        
    for p = 1:length(ratVector)
        scatter(1, oneDiffMeans(p,1))
        scatter(2, oneDiffMeans(p,2))
        scatter(3, oneDiffMeans(p,3))
        plot([1 2 3], [oneDiffMeans(p,1) oneDiffMeans(p,2) oneDiffMeans(p,3)])
        
        
        %Below section includes post reward zone responses
        %scatter(3, oneDiffMeans(p,3))
        %plot([1 2 3], [oneDiffMeans(p,1) oneDiffMeans(p,2) oneDiffMeans(p,3)])
    end
   
    %Combining post, towards, and away for one and two away pixels...
    
     
        
%end
    

%meaned t-test



   %RESP_PERC, TRIALS, FIRST THREE SECONDS P = 0.00
    