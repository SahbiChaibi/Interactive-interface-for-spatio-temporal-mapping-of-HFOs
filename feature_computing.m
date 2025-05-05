function [vect]= feature_computing(cc,dbs,Fsample)
Ts=1/Fsample;
%% mean+std feature.
amp=mean(abs(cc))+std(abs(cc));
% %% convolution Feature
% [ss ff]=size(dbs);
% for kk=1:ss
% DD(kk)=sum(dbs(kk,:))
% end
% corrr=max(DD);
% corrr=corrr/1000000;
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
%% RMS_feature 
Rms_feat= sqrt(mean(cc).^2);
%% Line_Length Future
LL_feat= mean(diff(cc));
%% Entropy Feature
m=3;
tau=1;
%implementation based on matrices
[pe1 npe1]=my_permutation_entropy(cc,m,tau);
%% Correlation Feature
 Npoints = length(cc);
 ree= real(xcorr(cc))/Npoints;
 [reemax k0] = max(ree); % maximum central
 lmm=ree(k0);
ree = ree(k0 :length(ree)); % partie droite de ree
 % le 1er pic latéral doit se trouver entre Tpmin et Tpmax
 fpmax = 500 ; fpmin = 80 ; % fréquences min/max du HFO
 Tpmax = 1/fpmin ; Tpmin = 1/fpmax ; % périodes min et max du HFO
 kpmin = round(Tpmin/Ts) ; kpmax= round(Tpmax/Ts) ;
% recherche du premier pic.
ree= ree(kpmin:kpmax); % domaine temporel limité par Tpmin et Tpmax
[reemax1 k1] = max(ree); % k1 = position du 1er max latéral
Rapp=ree(k1)/lmm;
%% PSD feature
% [Pxx,w]= pwelch(cc)
% pow=max(Pxx);
vect=[npe1 amp corrr phss  pass_zeros Rms_feat LL_feat Rapp];