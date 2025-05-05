function res = all_resolutions(Spectre, header, FreqEch, FreqSmp)
% This function computes wavelet resolutions for each frequencies, using
% the window size defined in the header. This function must be changed
% if cmor2.0558-0.5874 wavelet is not used (the variable Osc_num must be
% defined, it represents the number of periods covered by the wavelet,
% furthermore, the relationship between df and dt depends on the wavelet)
%
% Copyright (C) 2008 Lab. ABSP, Riken (Japan) Francois-B. Vialatte et al.
% Please cite related papers when publishing results obtained with this
% toolbox
res = zeros(length(Spectre),2);


if header.wavelet == 'cmor2.0558-0.5874'
    Osc_num = 7;
else
    disp('The number of oscillations must be adapted to the wavelet, please edit all_resolutions.m');
    keyboard;
end;
cpt = 1;
for i=Spectre   
   df = i/7;
   dt = 1/(2*pi*df);
   haut = 2*df/FreqSmp;
   larg = FreqEch*2*dt;
   rapp = haut / larg;
   cycles = header.cote * FreqEch/ i;  
   res(cpt,1) = max(round(cycles * rapp),1);
   res(cpt,2) = max(round(cycles),1);
   cpt = cpt + 1;
end;
