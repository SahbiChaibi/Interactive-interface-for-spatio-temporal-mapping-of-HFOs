function [vect]= featurecomputing(cc,dbs,Fsample)
Ts=1/Fsample;
%% mean+std feature.
amp=mean(abs(cc))+std(abs(cc));
%% convolution Feature
DD=abs(dbs);
corrr=max(max(DD))-min(min(DD));
%% SNEO Feature.
for ll=2:length(cc)-1
    phsii(ll)=cc(ll).^2+cc(ll-1).*cc(ll+1);
end
phss=mean(phsii)+std(phsii);
%% Passing per_zeros.
Nech=length(cc);
xz = cc- mean(cc);
xz = (1+sign(xz))/2; % transformation en un signal binaire 0/1.
xz = diff(xz); % derivee du signal binaire = +/-1.
Nzx = sum(abs(xz));
pass_zeros=Nzx/Nech;
%% Correlation Feature
 Npoints = length(cc);
 ree= real(xcorr(cc))/Npoints;
 [reemax k0] = max(ree); % maximum central
Rapp=reemax;
%% PSD feature
 [Pxx,w]= pwelch(cc);
pow=max(Pxx);
vect=[ Rapp amp corrr phss  pass_zeros pow];