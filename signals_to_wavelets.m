function [base_waves, resvals, spectre, varspec, norme, reg, normesig] = signals_to_wavelets(sigs,header,valz);
% This function calls the matlab wavelet toolbox to transform signals into 
% wavelets. 
%
% sigs : cell variable, containing a list of signals to transform
% sigs{1} = vector of dimension 1xN, represents signal 1,
% sigs{2} = vector of dimension 1xN, represents signal 2,
% etc...
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
% - header.offset = offset; % z-score offset, positive value in [0-3]
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

freqech = header.freqsmp;
freqmin = header.freqmin;
freqmax = header.freqmax;
freqstp = header.freqstp;
freqdown = header.freqdown;
Freqs = freqmin:freqstp:freqmax;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%          Computing resolutions         %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
resols = all_resolutions(Freqs, header,freqdown,freqstp);
bornes.byup = ceil(resols(length(Freqs),1)/2)+1;
bornes.bydn = ceil(resols(1,1)/2)+1;
resdwn = all_resolutions(max(freqmin-bornes.bydn*freqstp,1), header,freqech,freqstp);
bornes.bx = ceil(resols(1,2)/2)+1;
borneslat = round((freqech/(freqmin-bornes.bydn*freqstp))*3.5);
brnlat2 = round((freqech/(freqmin-bornes.bydn*freqstp))*3.5);


decalage = header.offset_val;
stepin = round(freqech/freqdown);
debut = round(header.begin*freqech);
fin = round(header.end*freqech);
debutref = round(header.beginref*freqech);
finref = round(header.endref*freqech);
cwtn = header.wavelet;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Optimizing time vs. wavelet boundaries %%%
    %%%%%%%%%%%%%%%%%%%=%%%%%%%%%%%%%%%%%%%%%%%%%%
if (debut+1-borneslat>1)
    positemps = (debut+1-borneslat):fin;
else
    positemps = 1:fin;
end;
if (finref+brnlat2>fin)
    posiref   = (debutref+1):fin;
else
    posiref   = (debutref+1):finref+brnlat2;
end;

resvals.resols = resols;
resvals.bornes = bornes;
resvals.freqs  = Freqs;


for i=1:length(sigs)
   disp(['recording n°',int2str(i),' on ',int2str(length(sigs))]);
   sig = sigs{i};
   normesig{i} = sum(abs(sig));
   sig = sig/normesig{i};
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%   wavelet transform (signal and ref)   %%%
    %%%%%%%%%%%%%%%%%%%=%%%%%%%%%%%%%%%%%%%%%%%%%%
   ascwt{1} = wavelet_trans(sig(positemps),cwtn, max(freqmin-bornes.bydn*freqstp,1), freqmax+bornes.byup*freqstp, freqech, freqstp);
   refmap = wavelet_trans(sig(posiref),cwtn, max(freqmin-bornes.bydn*freqstp,1), freqmax+bornes.byup*freqstp, freqech, freqstp);
   r{1} = refmap(:,brnlat2:stepin:length(posiref)-brnlat2);
   reg{i} = r{1};
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%               z-score                  %%%
    %%%%%%%%%%%%%%%%%%%=%%%%%%%%%%%%%%%%%%%%%%%%%%
   if  (isempty(valz)==1)
        [spectre{i}, varspec{i}] = spectre_waves(r);
   else
        spectre{i}{1} = valz.spec;
        varspec{i}{1} = valz.vspc;
   end;
   clear r;
   clear refmap;
   [crwtc,errors]= zscore(ascwt, spectre{i}, varspec{i}, decalage);
   crwt = ascwt{1};
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%             downsampling               %%%
    %%%%%%%%%%%%%%%%%%%=%%%%%%%%%%%%%%%%%%%%%%%%%%
   c = resample(crwt(:,borneslat:end-borneslat)',freqdown,freqech)';
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% normalization and adding to cell list  %%%
    %%%%%%%%%%%%%%%%%%%=%%%%%%%%%%%%%%%%%%%%%%%%%%
   norme{i} = max(max(c));
   base_waves{i} = abs(c)./norme{i};
end;
