function [oneAwayAnimalStructureExp,oneAwayAnimalStructureControl,allDataOneVector,meanOneANOVA  ] = firstDirectionANOVA(M1,M2)

%This script runs an ANOVA and creates figures specifically for comparing
%the directional difference that exists in the first trial of the final extinction session
%with the directional difference that existed at those pixels of interest
%during the end of their initial training on trajectories. 
    
    %First need to create the towards vs away matrices for the control condition
    % (pixels that are twoAway from the newRewardZones but experienced in the first stage,
    % when these pixels are not close to actual reward zones. 
    
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
    
    
    %First Hardcoded Two Aways for original and new reward zones
    %Hardcoded TwoAways
    twoAwayOriginal = [15 25 35 45 55 65 66 67 68 69 70 60 50 40 30 20 19 18 17 16 41 51 61 71 81 91 92 93 94 95 96 86 76 66 56 46 45 44 43 42]; 
    twoAwayNew = sort([31 32 33 34 35 25 15 5 70 69 68 67 66 76 86 96]);
    
    %Hardcoded oneAways
    oneAwayOriginal = [26 27 28 29 39 49 59 58 57 56 46 36 52 53 54 55 65 75 85 84 83 82 72 62];
    oneAwayNew = [1 11 21 22 23 24 14 4 77 87 97 78 79 80 90 100];
    
    twoAwayPixels = twoAwayNew;
    oneAwayPixels = oneAwayNew;
    
    nextRewardZones = [2,3,12,13,88,89,98,99];
   
    %% Control Pixels 
    trials = ceil(length(sessionStructure(1).Vertices)/100);
    oneAwayFirstIDXControl = NaN(length(ratVector),length(oneAwayPixels));
    oneAwayRewardPokeControl = NaN(length(ratVector),length(oneAwayPixels),length(find(sessionStructure(1).Rewards)));
    oneAwayAwayPokeControl = NaN(length(ratVector),length(oneAwayPixels),length(find(sessionStructure(1).Rewards)));
    oneAwayPostPokeControl = NaN(length(ratVector),length(oneAwayPixels),length(find(sessionStructure(1).Rewards)));
   
    
    for i = 1:length(sessionStructure)
        nextIDX = ismember(sessionStructure(i).Vertices, nextRewardZones);
        nextRewards = find(nextIDX);
        rewardIDX = find(sessionStructure(i).Rewards);
        for j = 1:length(oneAwayPixels)
            foundPixels = find(sessionStructure(i).Vertices == oneAwayPixels(j),1);
            for k = 1:length(nextRewards)
                if (nextRewards(k) - foundPixels < 3) && (nextRewards(k) - foundPixels > 0)
                    oneAwayRewardPokeControl(i,j,k) = sessionStructure(i).Pokes(foundPixels);
%                 elseif (abs(rewardIDX(k) - foundPixels) < 2)
%                     oneAwayPostPokeControl(i,j,k) = sessionStructure(i).Pokes(foundPixels);
                else
                    oneAwayAwayPokeControl(i,j,k) = sessionStructure(i).Pokes(foundPixels);
                end
            end
        end
    end
    
    
    oneAwayAwayPokeVectorControl = oneAwayAwayPokeControl(:);
    oneAwayRewardPokeVectorControl = oneAwayRewardPokeControl(:);
    oneAwayPostPokeVectorControl = oneAwayPostPokeControl(:);
    nanmean(oneAwayAwayPokeVectorControl)
    nanmean(oneAwayRewardPokeVectorControl)
    nanmean(oneAwayPostPokeVectorControl)
    
    
    trials = ceil(length(sessionStructure(1).Vertices)/100);
    twoAwayFirstIDXControl = NaN(length(ratVector),length(twoAwayPixels));
    twoAwayRewardPokeControl = NaN(length(ratVector),length(twoAwayPixels),length(find(sessionStructure(1).Rewards)));
    twoAwayAwayPokeControl = NaN(length(ratVector),length(twoAwayPixels),length(find(sessionStructure(1).Rewards)));
    twoAwayPostPokeControl = NaN(length(ratVector),length(twoAwayPixels),length(find(sessionStructure(1).Rewards)));
    
    for i = 1:length(sessionStructure)
        nextIDX = ismember(sessionStructure(i).Vertices, nextRewardZones);
        nextRewards = find(nextIDX);
        rewardIDX = find(sessionStructure(i).Rewards);
        for j = 1:length(twoAwayPixels)
            foundPixels = find(sessionStructure(i).Vertices == twoAwayPixels(j),1);
            for k = 1:length(nextRewards)
                if (nextRewards(k) - foundPixels < 3) && (nextRewards(k) - foundPixels > 0)
                    twoAwayRewardPokeControl(i,j,k) = sessionStructure(i).Pokes(foundPixels);
%                 elseif abs(rewardIDX(k) - foundPixels) < 2
%                     twoAwayPostPokeControl(i,j,k) = sessionStructure(i).Pokes(foundPixels);
                else
                    twoAwayAwayPokeControl(i,j,k) = sessionStructure(i).Pokes(foundPixels);
                end
            end
        end
    end

    
    
    twoAwayAwayPokeVectorControl = twoAwayAwayPokeControl(:);
    twoAwayRewardPokeVectorControl = twoAwayRewardPokeControl(:);
    twoAwayPostPokeVectorControl = twoAwayPostPokeControl(:);
    nanmean(twoAwayAwayPokeVectorControl)
    nanmean(twoAwayRewardPokeVectorControl)
    nanmean(twoAwayPostPokeVectorControl)
    
    %TO Reduce Degrees of Freedome in Final ANOVA, take mean of responses
    %(towards vs away) for each animal just like in the learning curve ANOVA

    
    twoAwayAnimalStructureControl = NaN(length(ratVector),2);
    twoAwayAnimalStructureControl(:,1) = squeeze(mean(twoAwayAwayPokeControl, [2 3], 'omitnan'));
    twoAwayAnimalStructureControl(:,2) = squeeze(mean(twoAwayRewardPokeControl, [2 3], 'omitnan'));
    
    oneAwayAnimalStructureControl = NaN(length(ratVector),2);
    oneAwayAnimalStructureControl(:,1) = squeeze(mean(oneAwayAwayPokeControl, [2 3], 'omitnan'));
    oneAwayAnimalStructureControl(:,2) = squeeze(mean(oneAwayRewardPokeControl, [2 3], 'omitnan'));
    
%     twoAwayAnimalStructureControl = NaN(length(ratVector),2);
%     for i = 1:length(ratVector)
%         twoAwayAnimalStructureControl(i,1) = nanmean(reshape(twoAwayAwayPokeControl(i,:,:), 1, []));
%         twoAwayAnimalStructureControl(i,2) = nanmean(reshape(twoAwayRewardPokeControl(i,:,:), 1, []));
%     end
%     
%     oneAwayAnimalStructureControl = NaN(length(ratVector),2);
%     for i = 1:length(ratVector)
%         oneAwayAnimalStructureControl(i,1) = nanmean(reshape(oneAwayAwayPokeControl(i,:,:), 1, []));
%         oneAwayAnimalStructureControl(i,2) = nanmean(reshape(oneAwayRewardPokeControl(i,:,:), 1, []));
%     end
%     
    
    
    
    %% Pixels from Final Extinction 
    
    
    date = '11/30/2017'
    idxDate = ismember({M2.Date}, date);
    sessionStructureExp = M2(idxDate);
    
    %Then Filter by ratVector (using ratVector)
    trajRats = [1 2 3 4 6 7 9 10 11 15];
    randRats = [5 12 13 16 17 18 19 20];
    allRats = sort([trajRats randRats]);
    
    ratVector = trajRats;
    idxRat = ismember([sessionStructureExp.Rat], ratVector);
    sessionStructureExp = sessionStructureExp(idxRat);
    trials = ceil(length(sessionStructureExp(1).Vertices)/100);
    
    oneAwayFirstIDX = NaN(length(ratVector),length(oneAwayPixels),trials);
    oneAwayRewardPoke = NaN(length(ratVector),length(oneAwayPixels),length(find(sessionStructureExp(1).Rewards)));
    oneAwayAwayPoke = NaN(length(ratVector),length(oneAwayPixels),length(find(sessionStructureExp(1).Rewards)));
    oneAwayPostPoke = NaN(length(ratVector),length(oneAwayPixels),length(find(sessionStructureExp(1).Rewards)));
    
    for i = 1:length(sessionStructureExp)
        rewardIDX = find(sessionStructureExp(i).Rewards);
        for j = 1:length(oneAwayPixels)
                foundPixels = find(sessionStructureExp(i).Vertices == oneAwayPixels(j),1);
                for k = 1:length(rewardIDX)
                    if (rewardIDX(k) - foundPixels < 3) && (rewardIDX(k) - foundPixels > 0)
                        oneAwayRewardPoke(i,j,k) = sessionStructureExp(i).Pokes(foundPixels);
%                     elseif abs(rewardIDX(k) - foundPixels) < 2 %
%                         oneAwayPostPoke(i,j,k) = sessionStructureExp(i).Pokes(foundPixels);
                    else
                        oneAwayAwayPoke(i,j,k) = sessionStructureExp(i).Pokes(foundPixels);
                    end
                end
            end
        end
    
    
    
    trials = ceil(length(sessionStructureExp(1).Vertices)/100);
    twoAwayFirstIDX = NaN(length(ratVector),length(twoAwayPixels));
    twoAwayRewardPoke = NaN(length(ratVector),length(twoAwayPixels),length(find(sessionStructureExp(1).Rewards)));
    twoAwayAwayPoke = NaN(length(ratVector),length(twoAwayPixels),length(find(sessionStructureExp(1).Rewards)));
    twoAwayPostPoke = NaN(length(ratVector),length(twoAwayPixels),length(find(sessionStructureExp(1).Rewards)));
    
    for i = 1:length(sessionStructureExp)
        rewardIDX = find(sessionStructureExp(i).Rewards);
        for j = 1:length(twoAwayPixels)
                foundPixels = find(sessionStructureExp(i).Vertices == twoAwayPixels(j),1);
                for k = 1:length(rewardIDX)
                    if (rewardIDX(k) - foundPixels < 3) && (rewardIDX(k) - foundPixels > 0)
                        twoAwayRewardPoke(i,j,k) = sessionStructureExp(i).Pokes(foundPixels);
%                     elseif abs(rewardIDX(k) - foundPixels) < 2 % 
%                         twoAwayPostPoke(i,j,k) = sessionStructureExp(i).Pokes(foundPixels);
                    else
                        twoAwayAwayPoke(i,j,k) = sessionStructureExp(i).Pokes(foundPixels);
                    end
                end
            end
        end
 
    
    %TO Reduce Degrees of Freedome in Final ANOVA, take mean of responses
    %(towards vs away) for each animals just like in the learning curve ANOVA
    
    %Mean of TwoAways per animal
    
    twoAwayAnimalStructureExp = NaN(length(ratVector),2);
    twoAwayAnimalStructureExp(:,1) = squeeze(mean(twoAwayAwayPoke, [2 3], 'omitnan'));
    twoAwayAnimalStructureExp(:,2) = squeeze(mean(twoAwayRewardPoke, [2 3], 'omitnan'));
    
    oneAwayAnimalStructureExp = NaN(length(ratVector),2);
    oneAwayAnimalStructureExp(:,1) = squeeze(mean(oneAwayAwayPoke, [2 3], 'omitnan'));
    oneAwayAnimalStructureExp(:,2) = squeeze(mean(oneAwayRewardPoke, [2 3], 'omitnan'));
    
    
    %T-test for mean of all towards and all away trials for each animal.
    
    [h,p,CI,stats] = ttest(oneAwayAnimalStructureExp(:,1), oneAwayAnimalStructureExp(:,2))
    pOneAwayExp = p;
    
    [h,p,CI,stats] = ttest(oneAwayAnimalStructureControl(:,1), oneAwayAnimalStructureControl(:,2))
    pOneAwayControl = p;
    
%     twoAwayAnimalStructureExp = NaN(length(ratVector),2);
%     for i = 1:length(ratVector)
%         twoAwayAnimalStructureExp(i,1) = nanmean(reshape(twoAwayAwayPoke(i,:,:), 1, []));
%         twoAwayAnimalStructureExp(i,2) = nanmean(reshape(twoAwayRewardPoke(i,:,:), 1, []));
%     end
%     
%     oneAwayAnimalStructureExp = NaN(length(ratVector),2);
%     for i = 1:length(ratVector)
%         oneAwayAnimalStructureExp(i,1) = nanmean(reshape(oneAwayAwayPoke(i,:,:), 1, []));
%         oneAwayAnimalStructureExp(i,2) = nanmean(reshape(oneAwayRewardPoke(i,:,:), 1, []));
%     end
%     
%     
    twoAwayAwayPokeVectorExp = twoAwayAwayPoke(:);
    twoAwayRewardPokeVectorExp = twoAwayRewardPoke(:);
%     nanmean(twoAwayAwayPokeVectorExp)
%     nanmean(twoAwayRewardPokeVectorExp)
%     [h,p] = ttest2(twoAwayAwayPokeVectorExp, twoAwayRewardPokeVectorExp)
    
    oneAwayAwayPokeVectorExp = oneAwayAwayPoke(:);
    oneAwayRewardPokeVectorExp = oneAwayRewardPoke(:);
%     nanmean(oneAwayAwayPokeVectorExp)
%     nanmean(oneAwayRewardPokeVectorExp)
%     [h,p] = ttest2(oneAwayAwayPokeVectorExp, oneAwayRewardPokeVectorExp)

    
    %% CREATE THE ALL DATA VECTOR FOR USE WITH ANOVA
    %There are a bunch of NANs in these vectors, but ANOVAn ignores Nan
    %values so you should be ok. Probably shouldnt remove them because then
    %index values will be inconsistent...

%% ANOVA for mean of all towards and all away for each animal
    %CREATE THE ALL DATA VECTOR FOR THE MEANED VERSION OF ANOVA. 
    %First lay control and experiment end to end
    allDataTwo = [twoAwayAnimalStructureControl;twoAwayAnimalStructureExp];
    allDataTwoVector = allDataTwo(:);
    
    allDataOne = [oneAwayAnimalStructureControl;oneAwayAnimalStructureExp];
    allDataOneVector = allDataOne(:);
    
    %Vectors for Away vs Towards
    towardsAwayTwo = zeros(length(ratVector)*2,2);
    towardsAwayTwo(:,1) = 1;
    towardsAwayTwo = towardsAwayTwo(:);
    
    towardsAwayOne = zeros(length(ratVector)*2,2);
    towardsAwayOne(:,1) = 1;
    towardsAwayOne = towardsAwayOne(:);
    
    %Vectors for Control vs Exp
    
    controlExpTwo = zeros(length(ratVector)*2, 2);
    controlExpTwo(1:10,:) = 1;
    controlExpTwo = controlExpTwo(:);
    
    controlExpOne = zeros(length(ratVector)*2, 2);
    controlExpOne(1:10,:) = 1;
    controlExpOne = controlExpOne(:);
    
    %Create structures for ANOVA
    
    meanTwoANOVA = cell(1,2);
    meanTwoANOVA{1} = towardsAwayTwo;
    meanTwoANOVA{2} = controlExpTwo;
    
    meanOneANOVA = cell(1,2);
    meanOneANOVA{1} = towardsAwayOne;
    meanOneANOVA{2} = controlExpOne;
    
    %Actual Mean ANOVA for oneAway and twoAway
    [p,tbl,stats,terms] = anovan(allDataOneVector, meanOneANOVA, 'model','interaction', 'varnames',{'Towards vs Away', 'Stage'});
    %[p,tbl,stats,terms] = anovan(allDataTwoVector, meanTwoANOVA, 'model','interaction', 'varnames',{'Towards vs Away', 'Stage'});
    
%% ANOVA for all pixel vector

 % Factor Vectors: (Control vs. Experimental Group, Towards vs. Away...)
 
    allDirectionsTwoAwayVector = [twoAwayAwayPokeVectorControl; twoAwayRewardPokeVectorControl; twoAwayAwayPokeVectorExp; twoAwayRewardPokeVectorExp];
 
    allDirectionsOneAwayVector = [oneAwayAwayPokeVectorControl; oneAwayRewardPokeVectorControl; oneAwayAwayPokeVectorExp; oneAwayRewardPokeVectorExp];
    
 
 %Group Vector 
 %0 = Control, 1 = Experimental  
 allDirectionsTwoAwayGroup = ones(length(allDirectionsTwoAwayVector),1);
 allDirectionsTwoAwayGroup(1:(length(twoAwayAwayPokeVectorControl)+length(twoAwayRewardPokeVectorControl))) = 0;
 
 allDirectionsOneAwayGroup = ones(length(allDirectionsOneAwayVector),1);
 allDirectionsOneAwayGroup(1:(length(oneAwayAwayPokeVectorControl)+length(oneAwayRewardPokeVectorControl))) = 0;
    
 
 %Towards vs Away 
 %Away = 0, towards = 1;
 
 allDirectionsTwoAwayDirection = zeros(length(allDirectionsTwoAwayVector),1);
 allDirectionsTwoAwayDirection((length(twoAwayAwayPokeVectorControl)+1):(length(twoAwayAwayPokeVectorControl)+length(twoAwayRewardPokeVectorControl))) = 1; %Handles the towards pixels in the control group
 allDirectionsTwoAwayDirection((length(twoAwayAwayPokeVectorControl) + length(twoAwayRewardPokeVectorControl) + length(twoAwayAwayPokeVectorExp) + 1):end) = 1; %Handles the towards pixels in the exp group
 
 allDirectionsOneAwayDirection = zeros(length(allDirectionsOneAwayVector),1);
 allDirectionsOneAwayDirection((length(oneAwayAwayPokeVectorControl)+1):(length(oneAwayAwayPokeVectorControl)+length(oneAwayRewardPokeVectorControl))) = 1; %Handles the towards pixels in the control group
 allDirectionsOneAwayDirection((length(oneAwayAwayPokeVectorControl) + length(oneAwayRewardPokeVectorControl) + length(oneAwayAwayPokeVectorExp) + 1):end) = 1; %Handles the towards pixels in the exp group
 
 %Two separate ANOVAs. One for one-away, one for two-away

%One Away ANOVA

directionOneANOVA = cell(1,2);
directionOneANOVA{1} = allDirectionsOneAwayGroup;
directionOneANOVA{2} = allDirectionsOneAwayDirection;

[p,tbl,stats,terms] = anovan(allDirectionsOneAwayVector, directionOneANOVA, 'model','interaction', 'varnames',{'Group','Towards vs Away'});

% %Two Away ANOVA
directionTwoANOVA = cell(1,2);
directionTwoANOVA{1} = allDirectionsTwoAwayGroup;
directionTwoANOVA{2} = allDirectionsTwoAwayDirection;

[p,tbl,stats,terms] = anovan(allDirectionsTwoAwayVector, directionTwoANOVA, 'model','interaction', 'varnames',{'Group','Towards vs Away'});

    

%% Plot one and two (towards vs away) for control session and final extinction
%CAN EITHER TAKE SEM ACROSS ANIMALS OR ACROSS ALL PIXELS

%Mean of one away towards control group
oneAwayRewardControlMean = nanmean(oneAwayRewardPokeVectorControl);
%stderrorOneAwayRewardControl = std(oneAwayRewardPokeVectorControl,'omitnan') / sqrt(length(oneAwayRewardPokeVectorControl) - sum(isnan(oneAwayRewardPokeVectorControl)));
stderrorOneAwayRewardControl = std(oneAwayAnimalStructureControl(:,2),'omitnan') / sqrt(length(oneAwayAnimalStructureControl(:,2)) - sum(isnan(oneAwayAnimalStructureControl(:,2))));

%Mean of one away away control group
oneAwayAwayControlMean = nanmean(oneAwayAwayPokeVectorControl);
%stderrorOneAwayAwayControl = std(oneAwayAwayPokeVectorControl,'omitnan') / sqrt(length(oneAwayAwayPokeVectorControl) - sum(isnan(oneAwayAwayPokeVectorControl)));
stderrorOneAwayAwayControl = std(oneAwayAnimalStructureControl(:,1),'omitnan') / sqrt(length(oneAwayAnimalStructureControl(:,1)) - sum(isnan(oneAwayAnimalStructureControl(:,1))));

%Mean of one away towards experimental group
oneAwayRewardExpMean = nanmean(oneAwayRewardPokeVectorExp);
%stderrorOneAwayRewardExp = std(oneAwayRewardPokeVectorExp,'omitnan') / sqrt(length(oneAwayRewardPokeVectorExp) - sum(isnan(oneAwayRewardPokeVectorExp)));
stderrorOneAwayRewardExp = std(oneAwayAnimalStructureExp(:,2),'omitnan') / sqrt(length(oneAwayAnimalStructureExp(:,2)) - sum(isnan(oneAwayAnimalStructureExp(:,2))));

%Mean of one away Away experimental group
oneAwayAwayExpMean = nanmean(oneAwayAwayPokeVectorExp);
%stderrorOneAwayAwayExp = std(oneAwayAwayPokeVectorExp,'omitnan') / sqrt(length(oneAwayAwayPokeVectorExp) - sum(isnan(oneAwayAwayPokeVectorExp)));
stderrorOneAwayAwayExp = std(oneAwayAnimalStructureExp(:,1),'omitnan') / sqrt(length(oneAwayAnimalStructureExp(:,1)) - sum(isnan(oneAwayAnimalStructureExp(:,1))));


figure
hold on
x = [1:4];
data = [oneAwayRewardControlMean oneAwayAwayControlMean oneAwayRewardExpMean oneAwayAwayExpMean]
errHigh = [(stderrorOneAwayRewardControl/2) (stderrorOneAwayAwayControl/2) (stderrorOneAwayRewardExp/2) (stderrorOneAwayAwayExp/2)];
errLow = errHigh ;
bar(x,data)
er = errorbar(x,data,errLow,errHigh, '.');
er.Color = [0 0 0];
xticks([1 2 3 4])
xticklabels({'Towards Control' 'Away Control' 'Towards in Ext' 'Away in Ext'})
xlim([0.5 4.5])
ylabel('Mean Pokes')
title("Mean Poke Responses Based on Stage and Direction(One Away)")
sigstar({[3 4]}, [pOneAwayExp])
hold off

%Mean of two away towards control group
twoAwayRewardControlMean = nanmean(twoAwayRewardPokeVectorControl);
stderrorTwoAwayRewardControl = std(twoAwayRewardPokeVectorControl,'omitnan') / sqrt(length(twoAwayRewardPokeVectorControl) - sum(isnan(twoAwayRewardPokeVectorControl)));

%Mean of two away away control group
twoAwayAwayControlMean = nanmean(twoAwayAwayPokeVectorControl);
stderrorTwoAwayAwayControl = std(twoAwayAwayPokeVectorControl,'omitnan') / sqrt(length(twoAwayAwayPokeVectorControl) - sum(isnan(twoAwayAwayPokeVectorControl)));

%Mean of two away towards experimental group
twoAwayRewardExpMean = nanmean(twoAwayRewardPokeVectorExp);
stderrorTwoAwayRewardExp = std(twoAwayRewardPokeVectorExp,'omitnan') / sqrt(length(twoAwayRewardPokeVectorExp) - sum(isnan(twoAwayRewardPokeVectorExp)));

%Mean of two away Away experimental group
twoAwayAwayExpMean = nanmean(twoAwayAwayPokeVectorExp);
stderrorTwoAwayAwayExp = std(twoAwayAwayPokeVectorExp,'omitnan') / sqrt(length(twoAwayAwayPokeVectorExp) - sum(isnan(twoAwayAwayPokeVectorExp)));

%figure for twoAway
figure
hold on
x = [1:4];
data = [twoAwayRewardControlMean twoAwayAwayControlMean twoAwayRewardExpMean twoAwayAwayExpMean]
errHigh = [(stderrorTwoAwayRewardControl/2) (stderrorTwoAwayAwayControl/2) (stderrorTwoAwayRewardExp/2) (stderrorTwoAwayAwayExp/2)];
errLow = errHigh;
bar(x,data)
er = errorbar(x,data,errLow,errHigh);
er.Color = [0 0 0];
title("Two Away")
hold off

%WHAT WORKS: ONE AWAY, FULL WINDOWS FOR BOTH, POKES, 09/13 

%THINGS TO TRY:
%USING RANDOM RATS AS CONTROL
%NORMALIZING RESPONSES BY MEAN OF ALL RESPONSES...





