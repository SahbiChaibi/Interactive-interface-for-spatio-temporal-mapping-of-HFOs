function [posdebhfo, posfinhfo, matt] = treee(x, Fsample,cycles, recti)
y=x
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
for jj=1:1:length(x)-100
   aa=y_filt(jj:jj+100); 
   dBS1=dBS(:,jj:jj+100);
   meas1(jj,:)=featurcomputing(aa,dBS1,Fsample);
end
mi=[meas1];
load data_Train
predicted = t(mi); %predit des classes pour les parametres mi-tes de teste
predicted1=char(predicted);  
% save chaine4 y_filt predicted1
% 
% cycles=3;
% beta=30;
 ns=length(y);
for k=1: length(predicted1)
    if(predicted1(k)=='H')
        sortie(k)=1;
    else sortie(k)=0;
    end
end
ee=1;
ff=1;
sortie=[zeros(1,2) sortie zeros(1,2)];
for ii=1:(length(sortie)-1)
    if(((sortie(ii+1)-sortie(ii))>0)&&( sortie(ii)==0));
        dep(ee)=ii-1-5;
        ee=ee+1;
    end
    if(((sortie(ii+1)-sortie(ii))<0)&& (sortie(ii+1)==0));
        fin(ff)=ii-1+5;
        ff=ff+1;
    end
end

mf=abs(y_filt);
 sasa=2.424*recti;
 for ii=1:1:length(mf) %nombre des echantillons
    if (mf(ii)>=sasa)
    vvv(ii)= mf(ii);
    else
        vvv(ii)=sasa;
    end 
 end 
aaa=1;
for ii=1:length(dep)
    signall=vvv(dep(ii):fin(ii));
    nombre=0;
    for iiii=2:length(signall)-1
           if((signall(iiii+1)>signall(iiii))&&(signall(iiii-1)<signall(iiii)))
            nombre=nombre+1;
           else
               nombre=nombre;
           end
    end  
       if(nombre>=2*cycles)     %seuillage par nombre des pics
           depp(aaa)=dep(ii);
           finn(aaa)=fin(ii);
           aaa=aaa+1;
       end
       signall=0;
end

posdebhfo=fix(depp);
posfinhfo=fix(finn);
matt=zeros(1,length(y));
for jj=1:1:length(posdebhfo)
    matt(posdebhfo(jj):posfinhfo(jj))=1;
end