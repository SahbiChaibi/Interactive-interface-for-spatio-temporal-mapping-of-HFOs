clear all;
%% HFOs Detection based on Data Mining (Decision Tree)
load database2; % load datbase.
Fsample=2000;
load Data1;   % visual HFO marking database include(depHFO,finHFO)
Electrode_number=1;
number_HFOevents=100;% Equivalent also to N=100 number of Backroud Acitivities.
y=Data(1,1:(finHFO(number_HFOevents+1))); % please verify variable in visual_ marking_database.
a=1;
low_frequency=80/(Fsample/2);
high_frequency=500/(Fsample/2);
b=fir1(100,[low_frequency  high_frequency]);
y_filt=filter(b,a,y);
kk=1;
fc=7/(2*pi);
freq=[80:5:500];
wvname= 'cmor2-1.114';
for ii=1:1:length(freq)
a(kk) =fc/((1/Fsample).*freq(ii));
kk=kk+1;
end
len =length(a);
W=cwt(y,a,wvname);
S=W.*W;
dBS = 10*log10(abs(S));
dBS = max(0,dBS);
for jj=1:1:number_HFOevents
   aa=y_filt(depHFO(jj):finHFO(jj)); 
   dBS1=dBS(:,depHFO(jj):finHFO(jj));
   meas1(jj,:)=featurcomputing(aa,dBS1,Fsample);
   bb=y_filt(finHFO(jj):depHFO(jj+1));   
   dBS2=dBS(:,finHFO(jj):depHFO(jj+1));
   meas2(jj,:)=featurcomputing(bb,dBS2,Fsample);
end
for kk=1:number_HFOevents
     clss1{kk}='HFO';
end
for kk=1:number_HFOevents
     clss2{kk}='FOND';
end
clss1=clss1';
clss2=clss2';
mi_Train=[meas1;
    meas2];
mi_Train(64,:)=mi_Train(63,:);
 cls_Train=[clss1;
     clss2];
t = classregtree(mi_Train,cls_Train,...
'names',{ 'Rapp' 'amp' 'corrr' 'phss'  'pass_zeros' 'pow'});
view(t);
save data_Train t mi_Train cls_Train;