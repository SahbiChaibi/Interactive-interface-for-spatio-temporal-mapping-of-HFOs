function save_wavefile(base_waves, resvals, entete, filename)

% This function saves a wavelet database to a .wvf file
%
% Copyright (C) 2008 Lab. ABSP, Riken (Japan) Francois-B. Vialatte et al.
% Please cite related papers when publishing results obtained with this
% toolbox

disp('Saving transfer wave file .wvf - version 4');
VERBASE = 999999; % version (1000001 = version 2)
FLOATDEC = 8388608;
fid = fopen(filename,'w+');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%                Config info             %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fwrite(fid, VERBASE+4, 'int'); 
fwrite(fid, entete.limit * FLOATDEC, 'int64');
fwrite(fid, 3, 'int');
fwrite(fid, entete.maxi, 'int');
fwrite(fid, 1e-10 * FLOATDEC, 'int64');
fwrite(fid, 100, 'int');
fwrite(fid, 60, 'int');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%                Saving header           %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fwrite(fid, entete.cote, 'int');
fwrite(fid, entete.freqmin * FLOATDEC, 'int64');
fwrite(fid, entete.freqmax * FLOATDEC, 'int64');
fwrite(fid, entete.freqstp * FLOATDEC, 'int64');
fwrite(fid, entete.freqdown * FLOATDEC, 'int64');


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%            Saving resolutions          %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fwrite(fid, length(resvals.resols), 'int');
fwrite(fid,  resvals.freqs.* FLOATDEC, 'int64');%1:100
fwrite(fid, resvals.resols(:,1) .* FLOATDEC, 'int64');
fwrite(fid, resvals.resols(:,2) .* FLOATDEC, 'int64');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%             Saving map limites         %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fwrite(fid, resvals.bornes.byup, 'int');
fwrite(fid, resvals.bornes.bydn, 'int');
fwrite(fid, resvals.bornes.bx, 'int');


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%                Saving maps             %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fwrite(fid, length(base_waves), 'int');
fwrite(fid, size(base_waves{1}), 'int');
for i=1:length(base_waves)
   w = round(base_waves{i} * FLOATDEC);
   fwrite(fid, w, 'int64');
end;

fclose(fid);