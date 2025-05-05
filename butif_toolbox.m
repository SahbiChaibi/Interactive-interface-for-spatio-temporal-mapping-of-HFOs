function butif_toolbox(signal, samplingrate, name, reference, freqmin, freqmax, freqstep, downsample, offset_val, limit, maxi)
% butif_toolbox(signal, samplingrate, name, reference, freqmin, freqmax,
% freqstep, downsample, offset_val, limit, maxi)
% or more usually:
% butif_toolbox(signal, samplingrate, name);
%
% Calling this file will compute a basic sparse time-frequency representation
% from the input vector "signal" (dimension 1xN or Nx1).
% samplingrate = samplingrate of the input signal in Hz.
% only "signal" and "samplingrate" are necessary inputs, and [] can be
% given as parameter to skip an input variable: for instance
% demo_vectorial(rand(1000,1),100,[],[],[],20,[],1) is accepted.
%
% - name = name of output files (.mat, .wvf, .bdc). If omitted, the
% outputfile will be 'default';
% - reference = a reference signal used to compute the zscore. If this input
% is omitted, signal will be self-referenced
% - freqmin = minimal frequency for modelling. If freqmin is omitted, the
% minimal frequency will be determined as the lowest possible frequency
% according to signal duration (limit of wavelet lateral border effects,
% with min = 1Hz, so that at least 80% of the signal is modelled).
% - freqmax = maximal frequency for modelling. If freqmax is omitted, the
% maximal frequency will be determined as 1/5th of the sampling rate (with
% max=85Hz).
% - freqstep = the step between frequencies. If the step is omitted,
% freqstep=1 will be used
% - downsample = downsampling of the wavelet map before bump modelling
% (considerably accelerates modeling). If downsample is not precised, it
% will be assigned the value of the Nyquist rate (1/2 of sampling rate).
% - offset_val = the z-score offset (value in [1-3]; or -1 for 
% desynchronizations). If omitted, offset=+1 will be used.
% - limit = modeling limit, usually in [0.1-0.3] (in percentage of the
% total energy). If omitted, limit = 0.2 will be used.
% - maxi = maximal number of bump modelled (usually in [100-500]).
% If omitted, maxi = 300 will be used.
%
%
% Copyright (C) 2008 Lab. ABSP, Riken (Japan) Francois-B. Vialatte et al.
% Please cite related papers when publishing results obtained with this
% toolbox


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     Completing missing inputs          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 2
    disp('not enough arguments - an input vector signal + its sampling rate are necessary');
    return;
end
ls = length(signal);
duration = ls/samplingrate;

if (nargin < 3) | (isempty(varargin{3}))
    name = 'default'; 
end

if (nargin < 4) | (isempty(varargin{4}))
    %uses self-referenced signal\
    sig{1} = signal(:);
    durationr = 0;
else
    sig{1} = [reference(:),signal(:)];
    durationr = length(reference)/samplingrate;
end

if (nargin < 5) | (isempty(varargin{5}))
    freqmin = max(1,round(7/((.2*ls)/samplingrate)));
end

if (nargin < 6) | (isempty(varargin{6}))
    freqmax = min(85,round(samplingrate/5));
end

if (nargin < 7) | (isempty(varargin{7}))
    freqstep = 1;
end

if (nargin < 8) | (isempty(varargin{8}))
    downsample = freqmax*2;
end

if (nargin < 9) | (isempty(varargin{9}))
    offset_val = 1;
end

if (nargin < 10) | (isempty(varargin{10}))
    limit = .2;
end

if (nargin < 11) | (isempty(varargin{11}))
    maxi = 300;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%        Defining model header           %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

header.freqsmp = samplingrate; % signal sampling rate
header.freqmin = freqmin; % minimal frequency investigated                           
% note: signal length must be at least 3.5*(frequsmp/freqmin) due to wavelet
% lower bounds.
header.freqmax = freqmax;% maximal frequency investigated
header.freqstp = freqstep;% frequency step
header.freqdown = downsample; % down-sampling rate 
% note: before wavelet transform, freqmax must be > 5*freqsmp
% after wavelet transform, freqmax must be > 2*freqdown (nyquist rate)
header.begin = 1/samplingrate+durationr;%beginning of modelled period inside the signal (in secs)
header.end = duration+durationr;%end of modelled period inside the signal (in secs)
header.beginref = 1/samplingrate;%beginning of reference period for the z-score (in secs)
if durationr > 0
   header.endref = durationr;% end of reference period for the z-score (in secs)
else
   header.endref = header.end;
end;
header.wavelet = 'cmor2.0558-0.5874'; % name of the used wavelet
% note: only cmor2.0558-0.5874 is supported until now
%       Fc = 2.0558;  Fb = 0.5874; --> M=7
if offset_val == -1
    header.cote = 2; % size of the modelling windows (should be 2 for ERD)
else
    header.cote = 4; % size of the modelling windows (should be 4 for ERS)
end;
header.offset_val = offset_val; % z-score offset (removing ERD-like or ERS-like components)
header.limit = limit; % modeling limit, usually in [0.1-0.3]
%(in percentage of the total energy)
header.maxi = maxi; % maximal number of bump modelled (usually in [100-500])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%             Bump modeling              %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Compute_wavefiles_fromcell(sig,name,header,[]);    
butif(name);
 