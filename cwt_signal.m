function [ascwt, s] = cwt_signal(Signal,Cwt, Min, Max, FreqEch, Seuil, frqsmp, Aff)

% This function calls the matlab wavelet toolbox to transform signals into 
% wavelets. 
%
% Signal = signal to be transformed
% Cwt = wavelet type
%     'haar' : Haar, 'meyr' : Meyer, 'mexh' : Mexican hat, 'morl' : Morlet
% Min = minimal frequency
% Max = maximal frequency
% FreqEch = sampling rate
% Seuil = seuillage des coefficients d'ondelettes
% Copyright (C) 2008 Lab. ABSP, Riken (Japan) Francois-B. Vialatte et al.
% Please cite related papers when publishing results obtained with this
% toolbox

NBITS = 256;

%figure;
%Sig = conv(Signal, hamming(20));
Sig = Signal(:);%Sig = pad_sig(Signal(:));%
sz = size(Sig,1);
%plot(Sig);
%title('Signal analysé.'); 
%figure;
%Sig = conv(Sig, blackman(100));%Sig = Sig .* blackman(sz);%
%plot(Sig);
%title('Signal filtré.'); 
%s = fliplr([12.1269:0.3109:24.2537 24.6212:0.63131:49.2424 49.3921:1.1845:95.5882 96.1538:2.742:203.125]);

Fc = centfrq(Cwt);
minscal = 1/(Fc * FreqEch / Min);
maxscal = 1/(Fc * FreqEch / Max);
step = frqsmp.*(maxscal-minscal)/(Max-Min);

s = fliplr(1./[minscal:step:maxscal]);


ccfs = cwt(Sig,s,Cwt);%ccfs = cwt_frob(Sig,s,Cwt);
%ccfs = real(ccfs);
%ccfs = abs(imag(ccfs));
%ccfs = ccfs.*conj(ccfs);
%ccfs = abs(ccfs);

ccfs = flipud(ccfs);
ascwt = abs(ccfs)-Seuil;
%ascwt = norme_waves(ascwt, s); %afac;
ascwt(find(ascwt < 0)) = 0;
%for i=1:length(s) ascwt(i,:) = ascwt(i,:) ./ sum(ascwt(i,:)); end;
%ascwt = WCONV('r',ascwt,blackman(100));
%ascwt = sqrt(ascwt);
%disp_cwt_mat(ascwt,s,size(Signal,1),Cwt,1/2000);
if (Aff == 1)
figure;
colormap(jet(NBITS)); 
F = scal2frq(s,Cwt,1/FreqEch);
Y = F;%fliplr(1:100);
X = 1:sz;%0:(1/2000):(size(Signal,1)/2000);
image(X,Y,wcodemat(ascwt,NBITS));%,'row');%
set(gca,'YTickLabel',flipud(get(gca,'YTickLabel')));
title(['Transformée continue  : ',Cwt]); 
ylabel('Fréquences');
xlabel('Temps');
%surf(ascwt);
end;

ascwt=flipud(ascwt);