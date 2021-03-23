

function [structureANOVA, meanAnova, p, tbl, stats, terms] = learningANOVA(M2); 
%Cue Map ANOVA V2 - This is the ANOVA to run for learning curves

%Exlude dates when we did ofc inactivations, tests, or extinctions. If you
%want to look at first stage, change input to M1 and select the proper
%dates for the exclusion. 

% idxDate = ~ismember({M1.Date}, {'09/14/2017','09/18/2017','09/19/2017','09/20/2017','09/21/2017','09/28/2017','09/29/2017','10/02/2017','10/03/2017','10/04/2017'});
% learningM = M1(idxDate);

idxDate = ~ismember({M2.Date}, {'11/03/2017','11/30/2017'}); %Use this line for second stage
learningM = M2(idxDate);

%Filter out based on rat number
trajRats = [1 2 3 4 6 7 9 10 11 15];
randRats = [5 12 13 16 17 18 19 20];
allRats = sort([trajRats randRats]);
idxRat = ismember([learningM.Rat], trajRats);
learningM = learningM(idxRat);


nRats = length(unique([learningM.Rat]));
nPixels = length(unique([learningM.Vertices]));
nTrials = ceil(length(learningM(1).Vertices)/100);
nDays = length(unique([learningM.Day]));


%In this approach, we will essentially have two data points per rat per day
% one point is the mean of rewarded, one point is the mean of unrewarded
% pixels. 

structureANOVA = zeros(length(learningM),2);
for i = 1:length(learningM)
    rewardIDX = find(learningM(i).Rewards);
    structureANOVA(i,1) = mean(learningM(i).Pokes(rewardIDX));
    nonRewardIDX = find(learningM(i).Rewards == 0);
    rewardIDX = find(learningM(i).Rewards == 1);
    postRewardIDX = rewardIDX + [0;1;2];
    exclude = find(postRewardIDX > length(learningM(i).Vertices));
    postRewardIDX(exclude) = [];
    postRewardIDX = postRewardIDX(:);
    pokes = (learningM(i).Pokes);
    pokes(postRewardIDX) = [];
    structureANOVA(i,2) = mean(pokes);
end
    
%Create factor vectors

rewardANOVA = zeros(length(learningM),2);
rewardANOVA(:,1) = 1;

dayANOVA = zeros(length(learningM),2);

for i = 1:length(learningM)
    dayANOVA(i,:) = learningM(i).Day - 1;
end

%Vectorize everything 

structureANOVA = structureANOVA(:);
rewardANOVA = rewardANOVA(:);
dayANOVA = dayANOVA(:);


%ANOVA STRUCTURE - Should be a cell array of vectors 
%pokeAnova = cell(1,5);
meanANOVA = cell(1,2);
meanANOVA{1} = (rewardANOVA);
meanANOVA{2} = (dayANOVA);

%%Running ANOVAN
    %Be sure to indicate what kind of variables each vector is.
    %Consider pixel# and Reward vectors as blocking variables. NESTING
    %might be the right term for this. 
    %Consider interaction terms for days vs. Rewarded/Non-Rewarded. 
    [p,tbl,stats,terms] = anovan(structureANOVA, meanANOVA, 'model', 'interaction', 'varnames',{'Reward','Days'},'continuous',[2]);
%[p,tbl,stats,terms] = anovan(allPokes, pokeAnova, 'nested',[0,0,0,0,0;0,0,0,0,0;0,0,0,0,0;0,0,0,0,1;0,0,0,0,0], 'model', [eye(5);[0 1 0 0 1]], 'varnames',{'Rats','Days','Trials','Pixels','Rewards'},'continuous',[2]);
% Options selected include nesting matrix for rewards nested in pixels,
% model interaction between days and rewards.
%CONSIDER ADDING A TERM FOR DISTANCE FROM REWARD ZONE...


% Try anovan without days as a continuous variable
% 'nested', [0,0,0,0,0;0,0,0,0,0;0,0,0,0,0;0,0,0,0,0;0,0,0,1,0]);
% 'model', [eye(5);[0 1 0 0 1]],
end