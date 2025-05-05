function [wavesimg,errors] = zscore(waves, spectre, varspec, decal)
% This function computes the z-score, then removes the part folling below
% the offset.
%
% decal = offset in [0-3]. If decal == -1, use the negative part of the map
%
% Copyright (C) 2008 Lab. ABSP, Riken (Japan) Francois-B. Vialatte et al.
% Please cite related papers when publishing results obtained with this
% toolbox

for i=1:length(waves)
   waveimg = waves{i};
   sp = spectre{i};
   vs = varspec{i};
   if decal >= 0
       for j=1:size(waveimg,1)
          waveimg(j,:) = waveimg(j,:) - sp(j);
          if (vs(j) ~= 0), waveimg(j,:) = waveimg(j,:) ./ vs(j); end;
          waveimg(j,:) = waveimg(j,:) + decal;
       end;
       errors{i} = waveimg(find(waveimg < 0));
       waveimg(find(waveimg < 0)) = 0;
   else
       if decal < 0
           for j=1:size(waveimg,1)
              waveimg(j,:) = waveimg(j,:) - sp(j);
              if (vs(j) ~= 0), waveimg(j,:) = waveimg(j,:) ./ vs(j); end;
           end;
           errors{i} = waveimg(find(waveimg > 0));
           waveimg(find(waveimg > 0)) = 0;
           waveimg = abs(waveimg);
       else
           disp('unusual offset. offset should be in [0-3] for ERS-like oscillations or equal to -1 for ERD-like oscillations');
       end;
   end;           
   wavesimg{i} = waveimg;
end;