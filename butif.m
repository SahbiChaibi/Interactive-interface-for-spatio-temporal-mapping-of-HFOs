function butif(filename)
% This function calls the SUMO toolbox, passing the filename as a parameter
% SUMO toolbox executable file will open the ".wvf" file, and save a ".bdc"
% file with the same name. On the exit, the ".bdc" file is trasformed into
% a ".mat" file containing all necessary information about the decomposition.
%
% Copyright (C) 2008 Lab. ABSP, Riken (Japan) Francois-B. Vialatte et al.
% Please cite related papers when publishing results obtained with this
% toolbox


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%    bump generation from ".wvf" file    %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp([filename,' : bump generation']);
out_bumpmod(filename);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%   saving from ".bdc" to ".mat" file    %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = load_decompfile([filename,'.bdc'],['waves_',filename]);
disp([filename,' : saving output mat file']);
save(filename,'model');
