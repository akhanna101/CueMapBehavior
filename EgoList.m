function [Probs,HistCons] = EgoList(V)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
Vd = diff(V);
sizeV = (numel(V)/2)^.5;
%allocentric directions:
%-1 is up,
%1 is down
% > 1 is right
% < 1 is left

%These are egocentric directions - forward,back,left,right -  for each of the allocentric directions, up,down,left
%right
allo = [-1;1;-sizeV; sizeV];
ego = [-1,1,-sizeV,sizeV;...
    1,-1,sizeV,-sizeV;...
    -sizeV,sizeV,1,-1;...
    sizeV,-sizeV,-1,1];

Probs = zeros(4,1);
Forward_Hist = zeros(1,12);

for i = 2:numel(Vd)
    
    prev = Vd(i-1) == allo;
    
    direction = ego(prev,:) == Vd(i);
    
    Probs(direction) = Probs(direction) + 1;
    
    
end

Probs = Probs/(numel(Vd));

%This gets a histogram of consecutive runs
Vdd = [100 diff(diff(V))];

consec = diff(find(Vdd ~= 0)) - 1;

HistCons = histc(consec, 0:1:sizeV - 1);


end


