function [spectre, varspec] = spectre_waves(b)
% Copyright (C) 2008 Lab. ABSP, Riken (Japan) Francois-B. Vialatte et al.
% Please cite related papers when publishing results obtained with this
% toolbox

for i=1:length(b)
   spectre{i} = mean(b{i},2);
   varspec{i} = std(b{i},0,2);
end;