
function [exclude] = postRewardExclude(MAT, n)
%This function takes as an input the number of pixels post reward that you
%want to exclude and returns a logical vector 'exclude' that is false for
%post reward pixels.
postR = find(MAT.Rewards) + [1:n]';
%Above line pulls out post reward pixels up to n past rewards
postR = postR(:);
exclude = true(1,length(MAT.Vertices));
exclude(postR) = false;
exclude = exclude(1:length(MAT.Vertices));
end