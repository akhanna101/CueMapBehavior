function [] = Plot_CM_Py_Batch(varargin)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


%varargin should contain the structure for all sessions and rats
%if its empty, then load the structure
if isempty(varargin)
    %This loads the data into the M structure array
    load('Cue_Map_Data.mat', 'M')
else
    M = varargin{1};
    clear varargin
end

%Blocks in the MAT struct are: 
%1 : horizontal trajectory blocks
%2 : vertical trajectory blocks
%3 : random walk blocks
%4 : random jump blocks

%post reward keeps track of responses after a reward is given for n
%vertices. Use the following terms for including or not including post
%rewards
%Post_Rew : Includes only the input number of vertices following a
            %reward(includes the reward such that a value of 1 only includes the
            %rewarded vertice

%No_Post_Rew : Omits the post reward vertices

%This gets all the rat numbers
all_rats = unique([M.Rat]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%This section is for defining the plots to produce
%PLOTS = {12};
PLOTS = {1,4,2,3,10,12};
%PLOTS = {1,2,3,4,5,6,7};

for pl = 1:numel(PLOTS)
rats_use = [14 15 16 18];
switch PLOTS{pl}
    
    case 1
        %Plot the mean average heat maps for the first 20 days of behavior for all
        %rats
        Conditions = {'Block',3,'No_Post_Rew', 10};
        %rats_use = all_rats;
        days_use = 1:20;
        mean_heatmap_days(rats_use, days_use, Conditions)
    case 2
        %Plot the mean average heat maps for the first 20 days of behavior for all
        %rats
        Conditions = {'Block',1,'No_Post_Rew', 2};
        %rats_use = all_rats;
        days_use = 21:24;
        mean_heatmap_days_sub_block(rats_use, days_use, Conditions)
        
    case 3
        %Plot the mean average heat maps for the first 20 days of behavior for all
        %rats
        Conditions = {'Block',2,'No_Post_Rew', 2};
        %rats_use = all_rats;
        days_use = 21:24;
        mean_heatmap_days_sub_block(rats_use, days_use, Conditions)
        
    case 4 
        Conditions = {'Block',3,'No_Post_Rew', 10};
        %rats_use = all_rats;
        days_use = 1:20;
        pixels_away = 13;
        mean_resp_dist_days(rats_use, days_use, pixels_away, Conditions)
    
        
    case 5 
        %Plot the mean average heat maps for the first 20 days of behavior for all
        %rats
        Conditions = {'Block',4,'No_Post_Rew', 10};
        rats_use = all_rats;
        days_use = 26:27;
        mean_heatmap_days(rats_use, days_use, Conditions)
    
     case 6
        %Plot the mean average heat maps for the first 20 days of behavior for all
        %rats
        Conditions = {'Block',3,'No_Post_Rew', 10};
        rats_use = all_rats;
        days_use = 26:27;
        mean_heatmap_days(rats_use, days_use, Conditions)
        
     case 7 
        Conditions = {'Block',4,'No_Post_Rew', 10};
        rats_use = all_rats;
        days_use = 26:27;
        pixels_away = 13;
        mean_resp_dist_days(rats_use, days_use, pixels_away, Conditions)
       
        
    case 5 
        Conditions = {'Block',3,'No_Post_Rew', 10};
        rats_use = all_rats;
        days_use = 28:43;
        mean_heatmap_days(rats_use, days_use, Conditions)      
        
    case 6 
        Conditions = {'Block',3,'No_Post_Rew', 10};
        rats_use = all_rats;
        days_use = 28:43;
        pixels_away = 13;
        mean_resp_dist_days(rats_use, days_use, pixels_away, Conditions)    
    
    
    case 10
        Conditions = {'No_Post_Rew', 6};
        %rats_use = all_rats;
        days_use = 21:24;
        pixels_away = 10;
        mean_resp_pixels_away_trajectory(rats_use, days_use, pixels_away, Conditions)
        
    case 11
        Conditions = {'No_Post_Rew', 6};
        %rats_use = all_rats;
        days_use = 38:43;
        pixels_away = 10;
        mean_resp_pixels_away_trajectory(rats_use, days_use, pixels_away, Conditions) 
    
    case 12    
        days_use = 21:24;
        mean_resp_approach_pixels_away(rats_use, days_use)
end

end

% for r = 1:numel(rat)
%     rat_use = rat_num == rat(r);
%     
% for i = find(d_use & rat_use)
%     filename = sprintf('%s/%s',Source_Folder,Filenames{i});
%     [MAT] = Import_CM_Py(filename);
%     %This converst the response percentage to a 144 x n matrix
%     [Response{r}] = Response_MAT(MAT);
%     
%     %This gets logicals in the 144 x n format
%     L(r).R = Time2Vert(strncmp('R',MAT.Block,1),MAT);
%     L(r).V = Time2Vert(strncmp('V',MAT.Block,1),MAT);
%     L(r).H = Time2Vert(strncmp('H',MAT.Block,1),MAT);
%     L(r).Reward = Time2Vert(MAT.Rewards,MAT);
%     L(r).Post5 = Time2Vert(log_extend(MAT.Rewards,5),MAT);
%     L(r).Post_Rew = Time2Vert(log_extend(MAT.Rewards,post_rew),MAT);
%     L(r).Post_Rew_Rem = Time2Vert(~log_extend(MAT.Rewards,post_rew),MAT);
%     
% %     for j = 1:3
% %         
% %         Response{j} = cat(1,Response{j},Resp{j});
% %         Rewards{j} =  cat(1,Rewards{j},Rew{j});
% %         Post_Response{j} = cat(1,Post_Response{j},Post_Resp{j});
% %         Post_Response_Rem{j} = cat(1,Post_Response_Rem{j},Post_Resp_Rem{j});
% %     end
%     
%     plot_tr = false;
%     plot_rw = false;
%     
%     if any(strncmp('V',MAT.Block,1) | strncmp('H',MAT.Block,1))
%         [App_Tr,App_Tr_Rew] = Approach_MAT(MAT,{'V','H'}); 
%         plot_tr = true;
%         
%     end
%     if any(strncmp('R',MAT.Block,1))
%         [App_RW,App_RW_Rew] = Approach_MAT(MAT,{'R'}); 
%         plot_rw = true;
%     end
%     break
% end
% end
% 
% if plot_tr && plot_rw
%     
%     Titles = {'Random Walk', 'Vertical', 'Horizontal'};
%     figure
%     hold on
%     for j = 1:3
%         subplot(1,3,j)
%         imagesc(reshape((Response{j}),12,12))
%         set(gca, 'FontSize',16)
%         title(Titles{j}, 'FontSize',16)
%         xlabel('Tone Frequency', 'FontSize',16)
%         ylabel('Click Frequency', 'FontSize',16)
%     end
%     
%     set(gcf,'position',[35 390 1530 410])
%     
%     
%     for j = 1:3
%         figure
%         b = bar3(reshape((Response{j}),12,12));
%         for k = 1:length(b)
%             zdata = b(k).ZData;
%             b(k).CData = zdata;
%             b(k).FaceColor = 'interp';
%         end
%         set(gca, 'FontSize',16)
%         title(Titles{j}, 'FontSize',16)
%         xlabel('Tone Frequency', 'FontSize',16)
%         ylabel('Click Frequency', 'FontSize',16)
%     end
%     
% end
% 
% if ~plot_tr || plot_rw
% 
%     Titles = {'Response', 'Post Reward', 'Post Reward Removed'};
%     figure
%     hold on
%     for j = 1:3
%         
%         switch j
%             
%             case 1   
%                 curr_plot = lmean(Response,L,'R');
%                 clims = [0 max(curr_plot)];
%             case 2
%                 curr_plot = lmean(Response,L,'R','Post_Rew');
%                 %keep clims the same
%             case 3
%                 curr_plot = lmean(Response,L,'R','Post_Rew_Rem');
%                 clims = [0 max(curr_plot)];
%         end
% 
%     subplot(1,3,j)
%     hold on
%     imagesc(reshape(curr_plot,12,12),clims)
%     set(gca, 'FontSize',16)
%     title(Titles{j}, 'FontSize',16)
%     xlabel('Tone Frequency', 'FontSize',16)
%     ylabel('Click Frequency', 'FontSize',16)
%     
%     set(gcf,'position',[35 390 1530 410])
%     end
%     
%     
% %     figure
% %     b = bar3(reshape(lmean(Response,L,'R','Post_Rew_Rem'),12,12));
% %     for k = 1:length(b)
% %         zdata = b(k).ZData;
% %         b(k).CData = zdata;
% %         b(k).FaceColor = 'interp';
% %     end
% %     set(gca, 'FontSize',16)
% %     title(Titles{j}, 'FontSize',16)
% %     xlabel('Tone Frequency', 'FontSize',16)
% %     ylabel('Click Frequency', 'FontSize',16)
%     
% end
% %figure
% % hold on
% % for j = 1:3
% % subplot(2,3,j+3)
% % imagesc(reshape((Rewards{j}),12,12))
% % end
% 
% if plot_tr
%     
% figure
% hold on
% errorbar(-60:1:59,mean(App_Tr)*100,ste(App_Tr)*100)
% stairs(-.5 + -60:1:59, -10 + mean(App_Tr_Rew)*20,'k','linewidth',1.5)
% set(gca, 'XLim', [-60 59],'FontSize',16, 'box','off')
% plot([0 0], [0 60], '--k')
% xlabel('Trials - Centered at Reward', 'FontSize',16)
% ylabel('Response Percentage','FontSize',16)
% 
% end

% if plot_rw
%     
% figure
% hold on
% errorbar(-60:1:59,mean(App_RW)*100,ste(App_RW)*100)
% stairs(-.5 + -60:1:59, -10 + mean(App_RW_Rew)*20,'k','linewidth',1.5)
% set(gca, 'XLim', [-60 59], 'FontSize',16, 'box','off')
% plot([0 0], [0 60], '--k')
% xlabel('Trials - Centered at Reward', 'FontSize',16)
% ylabel('Response Percentage','FontSize',16)
% 
% end


    function [] = mean_heatmap_days(rats_use, days_use, conditions)
        
        figure
        hold on
%         rows = floor(sqrt(numel(days_use)));
%         cols = ceil(sqrt(numel(days_use)));
        rows = 4;
        cols = ceil(numel(days_use)/rows);
        
        ns = 0;
        for j = days_use
            ns = ns + 1;
            subplot(rows,cols,ns)
            
            %this gets the data for each day
            [MDay] = Create_Vertice_Matrix(M,rats_use,j,conditions);
            
            curr_plot = nanmean(squeeze(nanmean(MDay,3)));
            
            %clims = [0 max(curr_plot)];
            clims = [0 .4];
            
            hold on
            imagesc(reshape(curr_plot',12,12),clims)
            %set(gca, 'xtick',[],'ytick',[])
            set(gca, 'FontSize',16)
            %title(sprintf('%s %s','Day', num2str(j)), 'FontSize',10)
            title(sprintf('%s %s','Day', num2str(j)), 'FontSize',16)
            xlabel('Tone Frequency', 'FontSize',16)
            ylabel('Click Frequency', 'FontSize',16)
            axis square
        end
        
        if numel(days_use) <=4
            set(gcf,'position',[680 32 551 964])
        elseif numel(days_use) >=12
            set(gcf,'position',[39 62 1848 920])
        %set(gcf,'position',[35 390 1530 410])
        end
        
    end

    function [] = mean_heatmap_days_sub_block(rats_use, days_use, conditions)
        
        figure
        hold on
%         rows = floor(sqrt(numel(days_use)));
%         cols = ceil(sqrt(numel(days_use)));
        rows = 4;
        cols = 4*ceil(numel(days_use)/rows);
        
        conditions{end+1} = 'BlockSubType';
        conditions{end+1} = 0;
        
        ns = 0;
        for j = days_use

            for s = 1:4
                conditions{end} = s;
            ns = ns + 1;
            subplot(rows,cols,ns)
            
            %this gets the data for each day
            [MDay] = Create_Vertice_Matrix(M,rats_use,j,conditions);
            
            curr_plot = nanmean(squeeze(nanmean(MDay,3)));
            
            if isempty(curr_plot)
                continue
            end
            
            %clims = [0 max(curr_plot)];
            clims = [0 .4];
            
            hold on
            imagesc(reshape(curr_plot',12,12),clims)
            %set(gca, 'xtick',[],'ytick',[])
            set(gca, 'FontSize',16)
            %title(sprintf('%s %s','Day', num2str(j)), 'FontSize',10)
            title(sprintf('%s %s','Day', num2str(j)), 'FontSize',16)
            xlabel('Tone Frequency', 'FontSize',16)
            ylabel('Click Frequency', 'FontSize',16)
            axis square
            end
        end

            set(gcf,'position',[39 62 1848 920])
        
    end


    function [] = mean_resp_dist_days(rats_use, days_use, pixels_away, conditions)
        
        figure
        hold on
        rows = floor(sqrt(numel(days_use)));
        cols = ceil(sqrt(numel(days_use)));
        
        ns = 0;
        Colors = [1-linspace(.1,1,numel(days_use))' 1-linspace(.1,1,numel(days_use))',1-linspace(.1,1,numel(days_use))'];
        %Colors = [linspace(0,.9,numel(days_use))' linspace(0,.9,numel(days_use))',linspace(0,.9,numel(days_use))'];
        
        conditions{end + 1} = 'N-Away-Space';
        conditions{end + 1} = 1;
        for j = days_use
            ns = ns + 1;
            %subplot(rows,cols,ns)
            for k = 1:pixels_away
                %this gets the data for each day
                
                conditions{end} = k;
                [MDay] = Create_Vertice_Matrix(M,rats_use,j,conditions);
                
                Away_Mean(k) = nanmean(nanmean(nanmean(MDay,3),2));
                Away_SEM(k) = ste(nanmean(nanmean(MDay,3),2));
            end
            Away_Mean = Away_Mean - mean(Away_Mean(end-4:end));
            
            hold on
            plot(Away_Mean, 'Color',Colors(ns,:))
            %errorbar(Away_Mean,Away_SEM, 'Color',Colors(j,:))
            axis square
        end
        
            set(gca, 'FontSize',16)
            %title(sprintf('%s %s','Day', num2str(j)), 'FontSize',10)
            title('Euclidean Distance Response Over Days', 'FontSize',16)
            xlabel('Pixels Away', 'FontSize',16)
            ylabel('Response %', 'FontSize',16)
        %set(gcf,'position',[35 390 1530 410])
        
        
    end

    function [] = mean_resp_pixels_away_trajectory(rats_use, days_use, pixels_away, conditions)
        %This function compares responding in the same pixels for
        %horizontal and vertical trajectories n vertices away (in time)
        %from the rewarded pixels
        figure
        hold on
        rows = floor(sqrt(numel(days_use)));
        cols = ceil(sqrt(numel(days_use)));
        
        ns = 0;
        Colors = [1-linspace(.1,1,numel(days_use))' 1-linspace(.1,1,numel(days_use))',1-linspace(.1,1,numel(days_use))'];
        %Colors = [linspace(0,.9,numel(days_use))' linspace(0,.9,numel(days_use))',linspace(0,.9,numel(days_use))'];

        conditions{end + 1} = 'N-Away-Block';
        conditions{end + 1} = 1;
        n_away_block = numel(conditions)-1;
        n_away = numel(conditions);
        
        conditions{end + 1} = 'Block';
        conditions{end + 1} = 0;
        block = numel(conditions);
        
        for j = days_use
            ns = ns + 1;
            subplot(ceil(numel(days_use)/4),4,ns)
            
            %this loops through how many pixels away are analyzed
            for k = 1:pixels_away
                %this gets the data for each day
                
                %this loops through which n-way block is considered
                for l = 1:2
                    %conditions{n_away} = [l -k nan];
                    conditions{n_away} = [l -k nan];
                    %this loops through the blocks
                    for m = 1:2
                        conditions{block} = m;
                    
                        [MDay] = Create_Vertice_Matrix(M,rats_use,j,conditions);
                    
                        data{l,m} = MDay(~isnan(MDay));
                     
                    end
                end
                %Now combine the horizontal and vertical approaches and
            %together
            Mean_Approach(k) = nanmean([squeeze(data{1,1}); squeeze(data{2,2})]);
            SEM_Approach(k) = ste([squeeze(data{1,1}); squeeze(data{2,2})]);
            
            Mean_Orth(k) = nanmean([squeeze(data{1,2}); squeeze(data{2,1})]);
            SEM_Orth(k) = ste([squeeze(data{1,2}); squeeze(data{2,1})]);
            end
            
            
            
            hold on
            plot(Mean_Approach,'k')
            plot(Mean_Orth,'b')
            
            set(gca, 'FontSize',10)
            %title(sprintf('%s %s','Day', num2str(j)), 'FontSize',10)
            title(sprintf('%s%s%s%s','N Away Comparison Trajectories',newline,'Day ',num2str(j)), 'FontSize',10)
            xlabel('Pixels Away', 'FontSize',10)
            ylabel('Response %', 'FontSize',10)
            legend({'Towards','Away'},'Box','off')
            %errorbar(Away_Mean,Away_SEM, 'Color',Colors(j,:))
            axis square
        end
        
            
        set(gcf,'position',[35 390 1530 410])
        
        
    end


function [] = mean_resp_approach_pixels_away(rats_use, days_use)
        %THis function compares the approach not just for the rewarded
        %vertices, but also for vertices on the same row or column.
        
        figure
        hold on
        rows = floor(sqrt(numel(days_use)));
        cols = ceil(sqrt(numel(days_use)));
        
        ns = 0;
        
pre_post = [10 10];
dist_away = 3;
dist_other_rew = 10;
post_reward = 10;
   
    %Colors1 = [1-linspace(.1,1,dist_away+1)' 1-linspace(.1,1,dist_away+1)',1-linspace(.1,1,dist_away+1)'];
    Colors1 = [zeros(dist_away+1,1) 1-linspace(.1,1,dist_away+1)',1-linspace(.1,1,dist_away+1)'];
    Colors2 = [1-linspace(.1,1,dist_away+1)' zeros(dist_away+1,1) 1-linspace(.1,1,dist_away+1)'];    
        conditions = cell(1);
%         conditions{end + 1} = 'Block';
%         conditions{end + 1} = 0;
%         block = numel(conditions);
        
        for j = days_use
            ns = ns + 1;
            subplot(2,4,ns)
                for k = 0:dist_away
                %this loops through which block is considered
                for l = 1:2
                    %this loops through whether the current block is the
                    %conditioned block or the control block
                    for m = 1:2
                    %conditions 
                    conditions = {l, m == l, pre_post,k,dist_other_rew,post_reward}; 
                    
                        [MDay] = Create_Approach_Matrix(M,rats_use,j,conditions);
                    
                        data{l,m} = MDay;
                     
                    end
                end
            %Now find the average activity over time for each vertice

            Mean_Approach(k+1,:) = squeeze(nanmean(nanmean(cat(3,data{1,1}, data{2,2}),3),1));
            Mean_Control(k+1,:) = squeeze(nanmean(nanmean(cat(3,data{1,2}, data{2,1}),3),1));
            %SEM_Approach(k+1,:) = squeeze(ste(nanmean([data{1,1}; data{2,2}],3),1));
           
           legend_names{k+1} = sprintf('%s%s', num2str(k),' Offset');
           hold on
           subplot(2,4,ns)
            stairs(-pre_post(1):pre_post(2),Mean_Approach(k+1,:),'Color',Colors1(k+1,:))
%             if k == 0
%                 hold on
%                 stairs(-pre_post(1):pre_post(2),Mean_Control(k+1,:),'Color',Colors2(k+1,:))
%             end    
            set(gca, 'YLim',[0 .5], 'FontSize',10)
            title(sprintf('%s %s','Day', num2str(j)), 'FontSize',10)
             xlabel('Pixels Away', 'FontSize',10)
             ylabel('Response %', 'FontSize',10)
             
%              legend(legend_names,'Box','off')
%            subplot(2,4,ns+4) 
%             stairs(-pre_post(1):pre_post(2),Mean_Control(k+1,:),'Color',Colors2(k+1,:))
%             set(gca, 'YLim',[0 .5], 'FontSize',10)
%             title(sprintf('%s %s','Day', num2str(j)), 'FontSize',10)
%              xlabel('Pixels Away', 'FontSize',10)
%              ylabel('Response %', 'FontSize',10)
%              legend(legend_names,'Box','off')

                end
            
            
%             set(gca, 'FontSize',10)
%             %title(sprintf('%s %s','Day', num2str(j)), 'FontSize',10)
%             title(sprintf('%s%s%s%s','N Away Comparison Trajectories',newline,'Day ',num2str(j)), 'FontSize',10)
%             xlabel('Pixels Away', 'FontSize',10)
%             ylabel('Response %', 'FontSize',10)
%             legend({'Towards','Away'},'Box','off')
%             %errorbar(Away_Mean,Away_SEM, 'Color',Colors(j,:))
%             axis square
        end
        
            
        set(gcf,'position',[67 168 1740 803])
        
        
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    
    function [Resp] = Response_MAT(MAT, conditions)
    %THis function converts the response rate from a time vector of
    %vertices to a vertices x time matrix.
    
    %MAT.Vertices is a 1 x n vector indicating the vertex indicated at the ith
    %entry of n total entries for the session
    
    %Resp is a 144 x (n/144) matrix with time defined by each vertice entry
    
    %varargin is a logical vector (1 x n) of which vertices to include in the output 
    if isempty(MAT)
        Resp = [];
        return
    end
    
    Fields = fieldnames(MAT);
    
    if ~isempty(conditions)
        log_use = true(1,numel(MAT.Vertices));
        
        for c = 1:2:numel(conditions)
            
            if strcmp('No_Post_Rew',conditions{c})
                
                log_use = log_use & ~log_extend(MAT.Rewards,conditions{c + 1});
            
            elseif strcmp('Post_Rew',conditions{c})
                log_use = log_use & log_extend(MAT.Rewards,conditions{c + 1});
                
            elseif strcmp('N-Away-Space',conditions{c})
                log_use = log_use & ismember(MAT.Vertices,find(n_away(unique(MAT.Vertices(MAT.Rewards)),conditions{c + 1},12)));    
            
            elseif strcmp('N-Away-Block',conditions{c})
                %N-Away time has three variables in the conditions{c+1}). The
                %first value tells which block-type to determine the
                %vertices, the second tells which block to condition to
                %log_use
                log_use = log_use & N_Away_Block(MAT,conditions{c + 1});    
            
            elseif strcmp('N-Offset-Block',conditions{c})
                log_use = log_use & N_Offset_Block(MAT,conditions{c + 1}); 
                
            %This checks whether the condition is a fieldname of MAT    
            elseif any(strcmp(conditions{c}, Fields))
                
                log_use = log_use & ismember(MAT.(conditions{c}), conditions{c+1});
            
            %If none of these are true, there is a problem with the
            %condition
            else
                %Resp = nan(144,ceil(numel(MAT.Vertices)/144));
                stop = true
            end    
                
        end
            
    end    
   
        Resp = zeros(144,ceil(numel(MAT.Vertices)/144));
        
        for i = 1:144
            %Edit this to get all trials
            v = MAT.Vertices == i;  
            
            iTrials = MAT.Resp_Perc(v);
            %iTrials = MAT.Pokes(v);
            
            %This sets any trials not included in log_use equal to NaN.
            %This is done to keep the form of the matrix
            iTrials(~log_use(v)) = NaN;
            
            
            Resp(i,1:sum(v)) = iTrials;

        end    

    end 
    
    function [L_2D] = Time2Vert(Logical,MAT)
    %THis function converts a logical vector from a time vector of
    %vertices to a vertices x time matrix.
    
    %MAT.Vertices is a 1 x n vector indicating the vertex indicated at the ith
    %entry of n total entries for the session
    
    %L_2D is a 144 x (n/144) matrix with time defined by each vertice entry
        L_2D = false(144,ceil(numel(MAT.Vertices)/144));
        
        for i = 1:144
            %Edit this to get all trials
            v = MAT.Vertices == i;  
            
            L_2D(i,1:sum(v)) = Logical(v);
        end
    end    

function [L_4D] = Create_Logic_Matrix(M,rats,days,conditions)
    
    %This function creates a logical matrix of Rats X Days X Vertices X Trials
    %For 10 rats and 24 trials per visit and 10 days, this would be a 10 X 10 X 144 X 24
    %Matrix
    %NOTE: MAT gets squeezed at the end. If rats or days are singular, the
    %dimensionality of MAT is reduced to 3D
    
    %If data is missing, it is filled in with nans
    
    %conditions defines the logicals to use
    
    L_4D = false(numel(unique(M.Rat)),numel(unique(M.Day)),144,ceil(numel(M(1).Vertices)/144));
    ni = 0;
    for i = rats
        ni = ni + 1;
        nj = 0;
        for j = days
            nj = nj + 1;
            
            use = [M.Rats == rats(i)] & [M.Day == days(j)];
            if sum(use) > 1
                stop = 1
                
            elseif  sum(use) == 0
                %This sets current data to nans
                Dims = size(MAT);
                [MAT(i,j,:,:)] = nan(Dims([3 4]));
            end    
            [MAT(i,j,:,:)] = Response_MAT(M(use));
        end
    end   
    
    %For inputs in which the length of rats or days are equal to 1, squeeze
    %the matrix
    MAT = squeeze(MAT);
end 

%     function [Resp,Rew,Post_Resp,Post_Resp_Rem] = Response_MAT(MAT,post_rew)
%     Blocks = {'R','V','H'};
%     use_range = false(size(MAT.Resp_Perc));
%     use_range(1:144*6) = true;
%     use_range = true(size(MAT.Resp_Perc));
%     
%     %This creates a filter for post-reward trials
%     post_range = log_extend(MAT.Rewards,post_rew);
%     
%     for j = 1:3
%         Resp{j} = [];
%         Rew{j} = [];
%         Post_Resp{j} = [];
%         Post_Resp_Rem{j} = [];
%         bl = strncmp(Blocks{j},MAT.Block,1);
%         for i = 1:144
%             %Edit this to get all trials
%             v = MAT.Vertices == i;
%             
%             Resp{j}(i) = mean(MAT.Resp_Perc(bl & v & use_range));
%             Rew{j}(i) = mean(MAT.Rewards(bl & v & use_range));  
%             Post_Resp{j}(i) = mean(MAT.Resp_Perc(bl & v & use_range & post_range));
%             Post_Resp_Rem{j}(i) = mean(MAT.Resp_Perc(bl & v & use_range & ~post_range));
%         end    
%         %Set any nans to zero
%         Post_Resp{j}(isnan(Post_Resp{j})) = 0;
%     end 
%     
%     end 


% function [MAT] = Create_Vertice_Matrix(M,rats,days)
%     
%     %This function creates a matrix of Rats X Days X Vertices X Trials
%     %For 10 rats and 24 trials per visit and 10 days, this would be a 10 X 10 X 144 X 24
%     %Matrix
%     %NOTE: MAT gets squeezed at the end. If rats or days are singular, the
%     %dimensionality of MAT is reduced to 3D
%     
%     %If data is missing, it is filled in with nans
%     MAT = [];
%     ni = 0;
%     for i = rats
%         ni = ni + 1;
%         nj = 0;
%         for j = days
%             nj = nj + 1;
%             
%             use = [M.Rats == rats(i)] & [M.Day == days(j)];
%             if sum(use > 1)
%                 stop = 1
%             elseif  sum(use) == 0
%                 %This sets current data to nans
%                 Dims = size(MAT);
%                 [MAT(i,j,:,:)] = nan(Dims([3 4]));
%             end    
%             [MAT(i,j,:,:)] = Response_MAT(M(use));
%         end
%     end   
%     
%     %For inputs in which the length of rats or days are equal to 1, squeeze
%     %the matrix
%     MAT = squeeze(MAT);
% end     

function [DAT] = Create_Vertice_Matrix(M,rats,days,conditions)
    
    %This function creates a matrix of Rats X Days X Vertices X Trials
    %For 10 rats and 24 trials per visit and 10 days, this would be a 10 X 10 X 144 X 24
    %Matrix
    %NOTE: MAT gets squeezed at the end. If rats or days are singular, the
    %dimensionality of MAT is reduced to 3D
    
    %If data is missing, it is filled in with nans
    DAT = nan(numel(rats),numel(days),144,ceil(numel(M(1).Vertices)/144));
    ni = 0;
    for i = rats
        ni = ni + 1;
        nj = 0;
        for j = days
            nj = nj + 1;
            
            use = [M.Rat] == i & [M.Day] == j;
            if sum(use) > 1
                stop = 1
                use(find(use,1)) = false;
                
            elseif  sum(use) == 0 || isempty(M(use))
                %This sets current data to nans
                %Dims = size(DAT);
                %[DAT(ni,nj,:,:)] = nan(Dims([3 4]));
                continue
            end   
            [DAT(ni,nj,:,:)] = Response_MAT(M(use),conditions);
        end
    end   
    
    %For inputs in which the length of rats or days are equal to 1, squeeze
    %the matrix
    DAT = squeeze(DAT);
end  


function [DAT] = Create_Approach_Matrix(M,rats,days,conditions)
    
    %This function creates a matrix of Rats X Days X Approaches X Trials
    %NOTE: MAT gets squeezed at the end. If rats or days are singular, the
    %dimensionality of MAT is reduced to 3D
    
    %If data is missing, it is filled in with nans
    DAT = nan(numel(rats),numel(days),sum(conditions{3})+1,400);
    ni = 0;
    for i = rats
        ni = ni + 1;
        nj = 0;
        for j = days
            nj = nj + 1;
            
            use = [M.Rat] == i & [M.Day] == j;
            if sum(use) > 1
                stop = 1
                use(find(use,1)) = false;
                
            elseif  sum(use) == 0 || isempty(M(use))
                %This sets current data to nans
                %Dims = size(DAT);
                %[DAT(ni,nj,:,:)] = nan(Dims([3 4]));
                continue
            end   
            TEMP = Response_Approach_Offset(M(use),conditions);
            DAT(ni,nj,:,1:size(TEMP,2)) = TEMP;
        end
    end   
    
    %For inputs in which the length of rats or days are equal to 1, squeeze
    %the matrix
    remove = all(isnan(DAT),4);
    DAT(:,:,:,remove) = [];
    DAT = squeeze(DAT);
end  




    function [Resp,Rew] = Approach_MAT(MAT,Blocks)
    %Blocks = {'V','H'};
    
    rew_inds = find(MAT.Rewards);
    n = 0;
    for i = rew_inds
        
        %Skip random walk blocks
        if ~any(strncmp(MAT.Block(i),Blocks,1))
            continue
        end
        n = n + 1;
        if i < 61 || i > numel(MAT.Resp_Perc) - 59
        else
            n = n + 1;
            Resp(n,:) = MAT.Resp_Perc(i-60:i+59);
            Rew(n,:) = MAT.Rewards(i-60:i+59);
        end    
    end
    
    end 
    
    function [V] = log_extend(V,n)
    %This extends any true by n times. A vector of [0 0 1 0 0 0 0 0] input
    %with n = 3 ---> [0 0 1 1 1 1 0 0]
    
    %extend = @(x) x | [false x(1:end - 1)];
    
    for i = 1:n
        
        V = V | [false V(1:end-1)];
    end        
    
    end
    
%     function [meanV] = lmean(Response,Logical_MAT)
%     %This function takes the mean for each vertice (across rows) based on the logical
%     %matrix of which trials to include
%     Response(~Logical_MAT) = NaN;
%     meanV = nanmean(Response,2);
%     end

function[log_away] = n_away(rew_pix, num_away, root_vertices)
%This function takes as input the rewarded pixels, how many away pixels
%away, and the size of each dimension. Output is a matrix of logicals
%of size (num_away, pixels) containing info about whether that pixel is
%n-away. 

log_away = false(num_away, root_vertices^2);
rew_iter = double(rew_pix);
for i = 1:num_away
%     if num_away == 10
%         a = 1
%     end
    allo = [-1;1;-root_vertices;root_vertices];
    rew_adj = rew_iter + allo;
    %Make sure that the top or bottom row cannot move up or down
    %respectively - i.e., 13 cannot go to 12
    top_to_bottom = rem(rew_adj(1,:),12);
    rew_adj(1,top_to_bottom == 0) = 0;
    bottom_to_top = rem(rew_adj(2,:)-1,12);
    rew_adj(2,bottom_to_top == 0) = 0;
    
    rew_adj = rew_adj(rew_adj>0 & rew_adj<145);
    rew_adj = unique(rew_adj(:));
    temp = false(1,(root_vertices^2));
    temp(rew_adj(:)) = true;
    log_away(i,:) = ~any(log_away) & temp;
    rew_iter = rew_adj(:)';
    
end
%Take only the last row
log_away = log_away(i,:);
end


function [meanV] = lmean(Response,Logical_MAT,varargin)
%This function takes the mean for each vertice (across rows) based on the logical
%matrix of which trials to include
meansMAT = nan(144,numel(Response));
for i = 1:numel(Response)
    
    use = true(size(Response{1}));
    for j = 1:numel(varargin)
        use = use & Logical_MAT(i).(varargin{j});
    end
    
    resp = Response{i};
    resp(~use) = NaN;
    meansMAT(:,i) = nanmean(resp,2);
end
meanV = nanmean(meansMAT,2);

end

function [Lout] = N_Away_Block(MAT, conds)

%conds contains 2 inputs, the first is which block to use to determine the
%n-away vertices, the second is the number of steps to shift, the third is
%whether to ignore edges and how far an edge needs to be. IF edges is nan,
%its not included, if edges is 2, only 1 n-shift away can be considered. If
%n-shift >= edges -1 , an error occurs
gridsize = [12 12];

block_away = conds(1);
n_shift = (conds(2));
edges = uint16(conds(3));
%edges = uint16(abs(n_shift));
use = MAT.Block == block_away;

use = use & MAT.Rewards;

reward_vertices = unique(MAT.Vertices(MAT.Rewards));

% %this finds the n-away for the given block-type
% use_shift = Time_Shift(use, n_shift);

% %Now find the vertices that fall in this range
% vertices_use = unique(MAT.Vertices(use_shift));

vertices_use = [];

for r = 1:numel(reward_vertices)
    
    
    use_r = use & MAT.Vertices == reward_vertices(r);
    
    %this finds the n-away for the given block-type
    use_shift = Time_Shift(use_r, n_shift);
    
    %Now check if there are multiple vertices for prior to the rewarded
    %vertice. This indicates a u-turn at an edge. If this is true, do
    %not use the current vertices
    if numel(unique(MAT.Vertices(use_shift))) == 1
        
        v_curr = unique(MAT.Vertices(use_shift));
        
        %Check whether this vertice falls within the edges range. If no
        %edge conditions are input, ignore this
        if ~isnan(edges) && ~(edges == 0)
            
            %This is for the horizonal blocks
            if block_away == 1
                
                %This checks the left and right side of the space
                if v_curr <= edges*gridsize(1) || v_curr >= 144 - edges*12 + 1
                    %if its within the edges range, move on
                    
                    continue
                end
                
            elseif block_away == 2
                %This gets rid of the top and bottom rows of the space. Note that the
                %first logical comparison gets rid of top rows as well as the bottom
                %row (i.e. 12 24 36 etc...)

                rew_vert_rem = rem(v_curr,12);
                rew_vert_rem(rew_vert_rem==0) = 12;
                
                %This checks the top and bottom of the space, respectively
                if rew_vert_rem <= edges || rew_vert_rem > 12 - edges
                    
                    continue
                end
            end
        end
        
        %include the vertice
        vertices_use = [vertices_use v_curr];
    end
    
%     %If edges is not nan, vertices next to rewards close to the edge need to be removed
%     if ~isnan(edges) && ~(edges == 1)
%         
%         if block_away == 1
%             %This gets the row of the reward vertice
%             row = rem(reward_vertices(r),gridsize(1));
%             %this just sets the 0 remaineder to the bottom row
%             row(row == 0) = gridsize(1);
%             %this gets the column
%             col = ceil(reward_vertices(r)/gridsize(1));
%             
%             if reward_vertices(r) <= edges*gridsize(1)
%                 %This checks the left side of the space
%                 %this fills in the row up to the rewarded vertice from the
%                 %left side
%                 rem_vertices = [rem_vertices (0:12:col*12) + row];
%                 
%             elseif reward_vertices(r) >= 144 - edges*12 + 1
%                 %this checks the right side
%                 rem_vertices = [rem_vertices (144-col*12:12:144) + row];
%             end
%             
%             
%             
%         elseif block_away == 2
%             %This gets rid of the top and bottom rows of the space. Note that the
%             %first logical comparison gets rid of top rows as well as the bottom
%             %row (i.e. 12 24 36 etc...)
%             
%             
%             rew_vert_rem = rem(reward_vertices(r),12);
%             rew_vert_rem(rew_vert_rem==0) = 12;
%             
%             %This gets the row of the reward vertice
%             row = rem(reward_vertices(r),gridsize(1));
%             %this just sets the 0 remaineder to the bottom row
%             row(row == 0) = gridsize(1);
%             %this gets the column
%             col = ceil(reward_vertices(r)/gridsize(1));
%             
%             if rew_vert_rem <= edges
%                 %This checks the top of the space
%                 rem_vertices = [rem_vertices, col+(1:row)];
%                 
%             elseif rew_vert_rem > 12 - edges
%                 %This checks the bottom of the space
%                 rem_vertices = [rem_vertices, col + (12-row+1:1:12)];
%             end
%             
%         end
%     end
end

Lout = ismember(MAT.Vertices,vertices_use);


end



% function [LIST] = N_Offset_Block(MAT, conds)
% %This function determines the vertices on the same row or column of the
% %rewarded pixels and then determines the vertices on approach for those
% %pixels for a given block
% gridsize = [12 12];
% 
% block = conds{2};
% sub_block = conds{3};
% 
% verts_pre = conds{4}(1);
% verts_post = conds{4}(2);
% 
% dist = conds{5};
% %edges = uint16(conds(5));
% 
% %This is the distance that another reward must be from the vertice of
% %interest.
% dist_other_rew = conds{6};
% 
% use = MAT.Block == block & MAT.BlockSubType == sub_block;
% 
% %all that's needed are the order of the vertices in these block subtypes
% List = MAT.Vertices(use);
% List = List(1:prod(gridsize));
% List = List(:);
% 
% reward_vertices = unique(MAT.Vertices(MAT.Rewards));

% for d = 1:dist
%   
%     for r = 1:numel(reward_vertices)
%         n = 0;
%         LIST_TEMP{r} = cell(1); 
%         
%         row = rem(reward_vertices(r),gridsize(1));
%             %this just sets the 0 remaineder to the bottom row
%             row(row == 0) = gridsize(1);
%             %this gets the column
%             col = ceil(reward_vertices(r)/gridsize(1));
%         rows = 1:gridsize(1);
%         cols = 1:gridsize(2);
%         
%     %This is for the horizonal blocks
%     if block_away == 1
%         
%         dist_r = abs(rows - row);
%         rows_use = rows(dist_r == d);
%             for j = 1:numel(rows_use)
%                 n = n + 1;
%                 %this gets the vertices around the current vertice of
%                 %interest
%                 ind_v = find(List == rows_use(j) + (col-1)*gridsize(2));
%                 inds_use = -verts_pre:verts_post + ind_v;
%                 %create a temp variable to keep track of the indices
%                 %positions if some of the indices are removed
%                 temp = 1:numel(inds_use);
%                 %Set the list of vertices array:
%                 v_pre_post = nan(size(inds_use));
%                 
%                 %remove indices outside of the range
%                 inds_use(inds_use < 1 | inds_use > prod(gridsize)) = [];
%                 temp(inds_use < 1 | inds_use > prod(gridsize)) = [];
%                 
%                 %This gets the actual vertices and puts them into the
%                 %appropriate positions
%                 v_pre_post(temp) = List(inds_use);
%                 
%                 LIST_TEMP(n,:) = v_pre_post;
%                 
%             end   
%     elseif block_away == 2
%         
%         dist_r = abs(cols - col);
%         cols_use = cols(dist_r == d);
%             for j = 1:numel(cols_use)
%                 n = n + 1;
%                 %this gets the vertices around the current vertice of
%                 %interest
%                 ind_v = find(List == row + (cols_use(j)-1)*gridsize(2));
%                 inds_use = -verts_pre:verts_post + ind_v;
%                 %create a temp variable to keep track of the indices
%                 %positions if some of the indices are removed
%                 temp = 1:numel(inds_use);
%                 %Set the list of vertices array:
%                 v_pre_post = nan(size(inds_use));
%                 
%                 %remove indices outside of the range
%                 inds_use(inds_use < 1 | inds_use > prod(gridsize)) = [];
%                 temp(inds_use < 1 | inds_use > prod(gridsize)) = [];
%                 
%                 %This gets the actual vertices and puts them into the
%                 %appropriate positions
%                 v_pre_post(temp) = List(inds_use);
%                 
%                 LIST_TEMP(n,:) = v_pre_post;
%             end   
%     end
%     
%     %Now remove vertices that are close to other rewarded vertices
%     other_rewards = reward_vertices(reward_vertices ~= reward_vertices(r));
%     
%     rem_vertices_inds = find(ismember(List,other_rewards)) + -dist_other_rew:dist_other_rew;
%     rem_vertices_inds(inds_use < 1 | inds_use > prod(gridsize)) = [];
%     
%     %NOTE This method clips the approaches to being specific to the current
%     %block
%     LIST_TEMP{r}(ismember(LIST_TEMP,List(rem_vertices_inds))) = NaN; %#ok<*AGROW>
%     
%      
%     end    
%     
%     LIST{d} = [];
%     for r = 1:3
%     
%         LIST{d} = [LIST{d}; LIST_TEMP{r}];
%     end
% end    
% 
% end

function [LIST] = N_Offset_Block(MAT, block,sub_block,pre_post,dist,dist_other_rew)
%This function determines the vertices on the same row or column of the
%rewarded pixels and then determines the vertices on approach for those
%pixels for a given block
gridsize = [12 12];

verts_pre = pre_post(1);
verts_post = pre_post(2);

use = MAT.Block == block & MAT.BlockSubType == sub_block;

%all that's needed are the order of the vertices in these block subtypes
List = MAT.Vertices(use);
List = List(1:prod(gridsize));
List = List(:);

reward_vertices = double(unique(MAT.Vertices(MAT.Rewards)));


    for r = 1:numel(reward_vertices)
        n = 0;
        LIST_TEMP{r} = []; 
        
        row = double(rem(reward_vertices(r),gridsize(1)));
            %this just sets the 0 remaineder to the bottom row
            row(row == 0) = gridsize(1);
            %this gets the column
            col = ceil(reward_vertices(r)/gridsize(1));
        rows = 1:gridsize(1);
        cols = 1:gridsize(2);
        
    %This is for the horizonal blocks
    if block == 1
        
        dist_r = abs(rows - row);
        rows_use = rows(dist_r == dist);
            for j = 1:numel(rows_use)
                n = n + 1;
                %this gets the vertices around the current vertice of
                %interest
                ind_v = find(List == rows_use(j) + (col-1)*gridsize(2));
                inds_use = (-verts_pre:verts_post) + ind_v;
                %create a temp variable to keep track of the indices
                %positions if some of the indices are removed
                temp = 1:numel(inds_use);
                %Set the list of vertices array:
                v_pre_post = nan(size(inds_use));
                
                %remove indices outside of the range
                temp(inds_use < 1 | inds_use > prod(gridsize)) = [];
                inds_use(inds_use < 1 | inds_use > prod(gridsize)) = [];
                
                %This gets the actual vertices and puts them into the
                %appropriate positions
                v_pre_post(temp) = List(inds_use);
                
                LIST_TEMP{r}(n,:) = v_pre_post;
                
            end   
    elseif block == 2
        
        dist_r = abs(cols - col);
        cols_use = cols(dist_r == dist);
            for j = 1:numel(cols_use)
                n = n + 1;
                %this gets the vertices around the current vertice of
                %interest
                ind_v = find(List == row + (cols_use(j)-1)*gridsize(2));
                inds_use = (-verts_pre:verts_post) + ind_v;
                %create a temp variable to keep track of the indices
                %positions if some of the indices are removed
                temp = 1:numel(inds_use);
                %Set the list of vertices array:
                v_pre_post = nan(size(inds_use));
                
                %remove indices outside of the range
                temp(inds_use < 1 | inds_use > prod(gridsize)) = [];
                inds_use(inds_use < 1 | inds_use > prod(gridsize)) = [];
                
                %This gets the actual vertices and puts them into the
                %appropriate positions
                v_pre_post(temp) = List(inds_use);
                
                LIST_TEMP{r}(n,:) = v_pre_post;
            end   
    end
    
    %Now remove vertices that are close to other rewarded vertices
    other_rewards = reward_vertices(reward_vertices ~= reward_vertices(r));
    
    rem_vertices_inds = find(ismember(List,other_rewards)) + -dist_other_rew:dist_other_rew;
    rem_vertices_inds(inds_use < 1 | inds_use > prod(gridsize)) = [];
    
    %NOTE This method clips the approaches to being specific to the current
    %block
    LIST_TEMP{r}(ismember(LIST_TEMP{r},List(rem_vertices_inds))) = NaN; %#ok<*AGROW>
    
     
    end    
    
    LIST = [];
    for r = 1:3
    
        LIST = [LIST; LIST_TEMP{r}];
    end
   

end

function [Resp] = Response_Approach_Offset(MAT, conds)
%THis function converts the response rate from a time vector of
%vertices to a vertices x time matrix.

%MAT.Vertices is a 1 x n vector indicating the vertex indicated at the ith
%entry of n total entries for the session

%Resp is a 144 x (n/144) matrix with time defined by each vertice entry

%varargin is a logical vector (1 x n) of which vertices to include in the output

%This determines the vertices to use based on which sub_block to use
block = conds{1};
block_same = conds{2};
pre_post = conds{3};
dist_away = conds{4};
dist_other_rew = conds{5};
post_reward = conds{6};

if block_same
    block_sub_types = unique(MAT.BlockSubType(MAT.Block == block));
    block_cond = block;
else
    if block == 1; block_cond = 2; else block_cond = 1;end
    block_sub_types = unique(MAT.BlockSubType(MAT.Block == block_cond));
        
end    

[LIST{1}] = N_Offset_Block(MAT, block_cond, block_sub_types(1), pre_post,dist_away,dist_other_rew);
[LIST{2}] = N_Offset_Block(MAT, block_cond, block_sub_types(2), pre_post,dist_away,dist_other_rew);

% 
%     %this just combines the lists together
%     LIST = [LIST1;LIST2];
%    

%LIST is a cell array containing the different distances away from the
%rewarded vertice
sList(1) = size(LIST{1},1);
sList(2) = size(LIST{2},1);
Resp = [];
    for j = 1:2
        Resp_Temp = nan(size(LIST{1},2),1000);
        for k = 1:size(LIST{j},2)
            if block_same
                %USE = MAT.Block == block & MAT.BlockSubType == block_sub_types(j);
                USE = MAT.Block == block & MAT.BlockSubType == block_sub_types(j) & ~log_extend(MAT.Rewards,post_reward);
            else 
                %USE = MAT.Block == block;
                USE = MAT.Block == block & ~log_extend(MAT.Rewards,post_reward);
            end 
            v_use = MAT.Vertices(USE);
            v = v_use(ismember(v_use,LIST{j}(:,k)));
            USE_V = ismember(MAT.Vertices,uint16(v)) & USE;
            Resp_Temp(k,1:sum(USE_V)) = MAT.Resp_Perc(USE_V);
        end
        trials_rem = all(isnan(Resp_Temp));
        Resp_Temp(:,trials_rem) = [];
        Resp = [Resp Resp_Temp];
    end




end


% function [Resp] = Response_Approach_Offset(MAT, conds)
% %THis function converts the response rate from a time vector of
% %vertices to a vertices x time matrix.
% 
% %MAT.Vertices is a 1 x n vector indicating the vertex indicated at the ith
% %entry of n total entries for the session
% 
% %Resp is a 144 x (n/144) matrix with time defined by each vertice entry
% 
% %varargin is a logical vector (1 x n) of which vertices to include in the output
% 
% %This determines the vertices to use based on which sub_block to use
% block = conds{1};
% block_same = conds{2};
% pre_post = conds{3};
% dist_away = conds{4};
% dist_other_rew = conds{5};
% 
% 
% if block_same
%     block_sub_types = unique(MAT.BlockSubType & MAT.Block == block);
%     block_cond = block
% else
%     if block == 1; block_cond = 2; else block_cond = 1;end
%     block_sub_types = unique(MAT.BlockSubType & MAT.Block == block_cond);
%         
% end    
% 
% [LIST1] = N_Offset_Block(MAT, block_cond, block_sub_types(1), pre_post,dist_away,dist_other_rew);
% [LIST2] = N_Offset_Block(MAT, block_cond, block_sub_types(2), pre_post,dist_away,dist_other_rew);
% 
% for d = 1:numel(LIST1)
%     %this just combines the lists together
%     LIST{d} = [LIST1{d};LIST2{d}];
% end    
% 
% %LIST is a cell array containing the different distances away from the
% %rewarded vertice
% Resp = nan(dist_away,sum(pre_post) + 1,100);
% for d = 1:dist_away
%     %for j = 1:size(LIST,1)
%     for k = 1:size(LIST,2)
%         v = ismember(MAT.Vertices,LIST{d}(:,k));
%         Resp(d,k,1:numel(v)) = MAT.Resp_Perc(v);
%     end
% end
% end
    

function [Lout] = Time_Shift(Lin, n_shift)
%This function shifts a logical time vertice list based on n_shift. True
%values can be shifted later or early based on the number indicated by
%n_shift. A value of -1 shifts the true one step earlier, a value of 1
%shifts one later
if n_shift < 0

    Lout = [Lin(-n_shift+1:end) false(1,-n_shift)];
elseif n_shift > 0
    Lout = [false(1,n_shift) Lin(1:end-n_shift)];
else
    Lout = Lin;
end
end