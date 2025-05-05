function [ascwt, s] = wavelet_trans(Signal,Cwt, Min, Max, FreqEch, frqsmp)

% This function calls the matlab wavelet toolbox to transform signals into 
% wavelets. If you do not have wavelet toolbox, you must change calls to 
% ctrfrq and cwt and call a free toolbox such as Yawtb, or wait for the
% next release of SUMO toolbox where complex Morlet will be implemented
%
% Signal = signal to be transformed
% Cwt = wavelet type
%     'haar' : Haar, 'meyr' : Meyer, 'mexh' : Mexican hat, 'morl' : Morlet
% Min = minimal frequency
% Max = maximal frequency
% FreqEch = sampling rate
% frqsmp = step in frequencies between Min and Max 
%          (use 1 for linear spacing)
%
% output: ascwt = wavelet transform, s = transform scales
%
% Copyright (C) 2008 Lab. ABSP, Riken (Japan) Francois-B. Vialatte et al.
% Please cite related papers when publishing results obtained with this
% toolbox


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%             Initialization             %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    % Note : cwt and centrfrq function both      %      
    % call the matlab wavelet toolbox            %
    % if you do not have this toolbox, wait for  %
    % future versions of the toolbox which will  %
    % implement complex morlet transform         %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Sig = Signal(:);
sz = size(Sig,1);
Fc = centfrq(Cwt);
minscal = 1/(Fc * FreqEch / Min);
maxscal = 1/(Fc * FreqEch / Max);
step = frqsmp.*(maxscal-minscal)/(Max-Min);
s = fliplr(1./[minscal:step:maxscal]);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%          Wavelet Transform             %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ccfs = cwt(Sig,s,Cwt);
ascwt = abs(ccfs);
