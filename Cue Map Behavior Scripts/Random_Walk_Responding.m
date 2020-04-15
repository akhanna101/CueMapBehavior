%This script plots the response percentage for pixels n-away from reward
%zones. Only using pixels in the Random Walk block. Excluding pixels that
%are post 5 reward zone. Runs on the MAT file created by Import_CM_Py

rew_pix = unique(MAT.Vertices(MAT.Rewards));
%Consider using different variable name than 'ans'

num_away = 10
root_vertices = 12
%how many pixels away from reward zone to start plot
away_pixels = cell(length(rew_pix), num_away);

mean_resp = zeros(1, num_away);
SEM = zeros(1,num_away);

rw =  strcmp('RW', MAT.Block) | strcmp('R', MAT.Block);
postR =  find(MAT.Rewards) + [0:1:10]';
postR = postR(:);
exclude = true(1,3455);
exclude(postR) = false;
%This finds the rewarded indices then pulls out the next 5 pixles (based on
%their indices), and excludes their indices in further analyses.

log_away = n_away(rew_pix, num_away, root_vertices); 

for i = 1:num_away
    temp = log_away(i,:);
    temp2 = temp(MAT.Vertices);
    temp3 = MAT.Resp_Perc(temp2 & rw & exclude);
    mean_resp(i) = mean(temp3);
    SEM(i) = std(temp3)/sqrt(length(temp3));
end


figure
hold on
errorbar(mean_resp,SEM, 'b*')


function[log_away] = n_away(rew_pix, num_away, root_vertices)
%This function takes as input the rewarded pixels, how many away pixels
%away, and the size of each dimension. Output is a matrix of logicals
%of size (num_away, pixels) containing info about whether that pixel is
%n-away. 
log_away = false(num_away, root_vertices^2);
rew_iter = rew_pix
for i = 1:num_away
    allo = [-1;1;-root_vertices;root_vertices];
    rew_adj = rew_iter + allo;
    rew_adj = rew_adj(rew_adj>0 & rew_adj<145);
    temp = false(1,(root_vertices^2));
    temp(rew_adj(:)) = true;
    log_away(i,:) = ~any(log_away) & temp;
    rew_iter = rew_adj(:)';
end
    
%     j = root_vertices*i;
%     allo = [-i;i;-j;j];
%     for k = 1:length(rew_pix)
%         adj_pix = rew_pix(k) + allo
%         adj_pix = adj_pix(adj_pix>0 & adj_pix<145);
%         away_pixels(k,i) = {adj_pix};
        
%     end
end
        
