function Compute_wavefiles_fromcell(base,filename,header,valz)
% This function calls the matlab wavelet toolbox to transform signals into 
% wavelets.
%
% base : cell variable, containing a list of signals to transform
% base{1} = vector of dimension 1xN, represents signal 1,
% base{2} = vector of dimension 1xN, represents signal 2,
% etc...
% filename = filename for wave file ".mat" and ".wvf" saving
% - header = bump modelling header variable, with the follwing subfields:
% - header.freqsmp = signal sampling rate
% - header.freqmin = minimal frequency investigated                           
%             note: signal length must be at least 3.5*(frequsmp/freqmin) 
%                   due to wavelet lower bounds.
% - header.freqmax = maximal frequency investigated
% - header.freqstp = frequency step
% - header.freqdown = down-sampling rate 
%             note: before wavelet transform, freqmax must be > 5*freqsmp
%                   after wavelet transform, freqmax must be > 2*freqdown
% - header.begin = beginning of modelled period inside the signal (in secs)
% - header.end = end of modelled period inside the signal (in secs)
% - header.beginref = beginning of reference period for the z-score (in secs)
% - header.endref = end of reference period for the z-score (in secs)
% - header.wavelet = name of the used wavelet
%                  note: only cmor2.0558-0.5874 is supported until now
%                        Fc = 2.0558;  Fb = 0.5874; --> M=7 oscillations
% - header.offset_val = z-score offset, positive value in [0-3]
%                   note: to study ERD-like components, use offset = -1
% - header.cote = size of the modelling windows, usually 4 for ERS-like
%                 components (but should be =2 for ERD-like components)  
% valz is an optional parameter. Use valz is you want to compute
% externally the z-score references. In this case, header.beginref and
% endref are not used anymore. valz contains the following subfields
%  - valz.spec: a 1xN vector, representing the average amplitude for each
%   frequencies in the reference period
%  - valz.vspc: a 1xN vector, representing the standard deviation of 
%   amplitude for each frequencies in the reference period
%
% Copyright (C) 2008 Lab. ABSP, Riken (Japan) Francois-B. Vialatte et al.
% Please cite related papers when publishing results obtained with this
% toolbox

disp(['wavelet transform']);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%       Computing wavelet transform      %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
[base_waves, resvals, spectre, varspec, norme, reg, normesig] = signals_to_wavelets(base,header,valz);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%          Saving result to disk         %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% Variables :
% - base_waves contains the wavelet transform, 
% - resvals contains the resolutions for each studied frequencies, 
% - spectre contains the avergae frequency amplitude, 
% - varspec contains the standard deviation of frequency amplitude, 
% - norme contains the max value of the wavelet map before its 
% normalization
% - reg contains the reference period wavelet representation
save(['waves_',filename],'base_waves','resvals','spectre','varspec','norme','reg','normesig','header');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%      Saving result to ".wvf" file      %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%saving the ".wvf" file for bump modelling
% only wavelet transform, resolutions, and header are useful for bump
% modelling. Other variables are added to the model when "sumo.m" is
% called (see demo file)
save_wavefile(base_waves, resvals, header, [filename,'.wvf']);