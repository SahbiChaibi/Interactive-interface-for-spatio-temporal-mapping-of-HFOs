clear all;
load ppp
fe=2000;
%ALGORITHME DE DETECTION AUTOMATIQUE DES ACTIVITES OSCILLATIORES epiliptiques HFO :FIR+RMS
% FIR filter design example using the MATLAB FIR1 function 
fs=2000; %frequence d'echantionnage .
ts=1/fs; %periode d'echantionnage.
nch=2;
ni=25000; % temps du depart de signal.
ns=30000; %temps de fin de signal.en cas d'une analyse complet, ni=1,ns=longeur de database.
t=ni*ts:1*ts:ns*ts; %vecteur de temps contient ns-ni elements.
%loading signal
x =allData(nch,ni:ns)
 %exemple ,Specifier la bande passante par fc*(Fs/2):b obtenu par designfilter. 
b = fir1(155,[0.08 0.45])
a=1; %filtre FIR n'a pas des poles, seulement zeros.
y = filtfilt(b,a,x);
%calcul de signal rms
lll=1;
dt=31;
u=(dt-1)/2;
yy=[zeros(1,u) y zeros(1,u)]
for jj=u+1:1:length(y)+u
m(lll)=rms(yy(jj-u:jj+u));
lll=lll+1;
end
m=[0 m 0]
QQ=2.886
seuil=QQ;%seuil inferieur a amplitude max
yy=m;
for ii=1:1:length(yy) %nombre des echantillons
    if (yy(ii)>=seuil)
    signal(ii)= yy(ii)
    else
    signal(ii)=seuil
    end 
end 
ee=1;
ff=1;
%detection les positions,les durees et les amplitudes des oscillations superieur
%de seuil.
for ii=1:(length(signal)-1)
    if(((signal(ii+1)-signal(ii))>0)&&( signal(ii)==seuil));
        dep(ee)=ii-1;
        ee=ee+1;
    end
    if(((signal(ii+1)-signal(ii))<0)&& (signal(ii+1)==seuil));
        fin(ff)=ii-1;
        ff=ff+1
    end
end
for mm=1:1:length(dep)
    dure(mm)=fin(mm)-dep(mm)
end
%seuillage par duree:detection des hfo putatifs
gg=1;
ee=1;
tt=1;
DT=13;
for ii=1:1:length(dure)
    if(dure(ii)>DT)
        duree(gg)=dure(ii)
        debut(ee)=dep(ii)
        fine(tt)=fin(ii)
        gg=gg+1;
        ee=ee+1;
        tt=tt+1;
    end
end
%deux oscillations separees par une durees inferieurs de 10ms sont combinees
%comme une seule hfo.

if (length(duree)>=2)
    sss=1;
du(sss)=1
for ii=1:(length(duree)-1)
    if(debut(ii+1)-fine(ii)<21)
        du(ii+1)=1
    else
        du(ii+1)=0
    end
end
mm=1;
rr=1;
jk=1;
kl=1;
wer=length(du);
if(du(wer)==0)
    du(wer+1)=1;
else
    du(wer+1)=0;
end
eerr=length(duree)
fine(eerr+1)=0;
debut(eerr+1)=0;
for ii=1:1:(length(du)-1)
    if((du(ii+1)==0) && (du(ii)==0))
        tabl(mm)=(fine(ii)-debut(rr))
        posdeb(jk)=debut(ii)
        posfin(kl)=fine(ii)
        rr=ii+1;
        jk=jk+1;
        kl=kl+1;
        mm=mm+1
    end
    if((du(ii+1)==0)&&(du(ii)==1))
        tabl(mm)=(fine(ii)-debut(rr))
        posdeb(jk)=debut(rr)
        rr=ii+1;
        posfin(kl)=fine(ii)
        jk=jk+1;
        kl=kl+1;
        mm=mm+1;
    end
    if((du(ii+1)==1) && (du(ii)==0))
        tabl(mm)=(fine(ii)-debut(rr))
        posdeb(jk)=debut(ii)
        posfin(kl)=fine(ii)
        rr=rr;
        jk=jk;
        kl=kl;
        mm=mm
    end
    if((du(ii+1)==0) && (du(ii)==0))
        tabl(mm)=(fine(ii)-debut(rr))
        posdeb(jk)=debut(ii)
        posfin(kl)=fine(ii)
        rr=rr;
        jk=jk;
        kl=kl;
        mm=mm;
    end
end
else
        if(length(duree)==1)
        tabl(1)=duree(1)
        posdeb(1)=debut(1)
        posfin(1)=fine(1)
        end
         if(length(duree)==0)
       tabl(1)=0;
        posdeb(1)=0;
        posfin=0;
        end
end
%module d'estimation des nombres des pic(detection des maximums
%locaux):detection des vrais HFO.
cou=1;
for ii=1:1:length(tabl)
    long1=posfin(ii)
    long2=posdeb(ii)
    for iii=long2:1:long1
        lo(cou)=iii;
        cou=cou+1;
    end
end
ggg=length(lo);
ddd=lo(ggg)
lo(ggg+1)=ddd+2;
%estimation et seuillage par nombre des pics:

 mf=abs(y);
 sasa=2.424
 for ii=1:1:length(mf) %nombre des echantillons
    if (mf(ii)>=sasa)
    vvv(ii)= mf(ii)
    else
        vvv(ii)=sasa;
    end 
 end 
inc=1;
inc1=1;
inc2=1;
u=lo(1);
de=u+1;
pa=1;
for ii=1:length(lo)-1
    if((lo(ii+1)-lo(ii))>=2)
         nombre=0;
        for iiii=de:1:lo(ii)
           if((vvv(iiii+1)<vvv(iiii))&&(vvv(iiii-1)<vvv(iiii)))
            nombre=nombre+1;
           else
               nombre=nombre;
           end
       end
       if(nombre>=6)     %seuillage par nombre des pics
           nombrepic(pa)=nombre;
       pa=pa+1;
        vraihfo(inc)= (lo(ii)-u)*ts%vrai hfo.
        
        posdebhfo(inc1)=u+ni
        posfinhfo(inc2)=lo(ii)+ni
        inc=inc+1; 
        inc1=inc1+1;
        inc2=inc2+1;
         u=lo(ii+1)
         de=u+1;
       else
        u=lo(ii+1)
        de=u+1;
       end
    end
    
end
posdebhfo9=posdebhfo  
posfinhfo9=posfinhfo  
 save segment_fir9.mat posdebhfo9  posfinhfo9
 


