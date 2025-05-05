function [dBS,t,freq]=trans(y)
kk=1;
t=1:1:length(y);
fc=7/(2*pi);
freq=[53:1:529];
Fsample=2000;
wvname= 'cmor2.0558-0.5874'
for ii=1:1:length(freq) 
a(kk) =fc/((1/Fsample).*freq(ii));
kk=kk+1;
end
len =length(a);
W=cwt(y,a,wvname);
S=W.*W;
dBS = 10*log10(abs(S));
dBS = max(0,dBS);





