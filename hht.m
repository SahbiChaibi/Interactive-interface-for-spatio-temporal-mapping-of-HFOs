function [posdebhfo, posfinhfo, matt,matt1,matt2, sig1,S,free1] = hht(xyt,ni,ns,Fsample,cycles,rmsth)
y=xyt;
Fs=Fsample;   
Ts=1/Fs;      % Sampling period.
imf=emd(y); %  EMD decomposition.
L=size(imf,1);  % size of IMFs.
S=zeros(499,length(y)); % Matrix inialisation.
x=imf'; % Transposition of IMFs matrix.
z=hilbert(x); % Analytic(complex) signals of IMFs.
m=abs(z); % Module of z.  
p=angle(z); % Phase of z.
thr=rmsth/3;
thrr=rmsth;
%% Estimation of Map for (onset-end time position).
%% and estimation pics numbers.
vvcc=1;
for i=1:L 
    rr1=1;
    rr2=1;
    comm=0;
p(:,i)=unwrap(p(:,i)); % unwrap phase 
freq(:,i)= abs(diff(p(:,i)))/(2*pi*Ts); % computing instantanous frequencies.
ceilfreq(:,i)= ceil(freq(:,i));% ceil of instantanous frequencies(integering).
for j=1:length(x)-1 % length of signal
if((ceilfreq(j,i)>80)&&(ceilfreq(j,i)<500))
S(ceilfreq(j,i),j)=m(j,i);% Extraction of map between 80-500 Hz.
if(m(j,i)>thr) %avoidiing noise effect
    comm=1;
SA1{vvcc}(rr1)=ceilfreq(j,i);   % Extraction of IMFs with significant amplitudes at HFOs frequencies band. imf1 .... imf2..... imfn
SA2{vvcc}(rr1)=j;               % Extraction of IMFs with significant amplitudes at HFOs frequencies band.
rr1=rr1+1;
else
    if(m(j,i)<thrr)
S(ceilfreq(j,i),j)=0;% Extraction of map between 80-500 Hz with thresholding.
    end
end 
if(m(j,i)>thrr) %avoidiing noise effect
SA11{vvcc}(rr2)=ceilfreq(j,i);   % Extraction of IMFs with significant amplitudes at HFOs frequencies band. imf1 .... imf2..... imfn
SA22{vvcc}(rr2)=j;               % Extraction of IMFs with significant amplitudes at HFOs frequencies band.
rr2=rr2+1;
end 
end
end
if(comm==1)
TA(vvcc)=i;  % position of IMFs.
vvcc=vvcc+1;
end
end 
[U H]=size(S);
S=smoothn(S);
f=1:1:U;
rr=1;
for hh=1:H
    somm(rr)=sum(S(:,hh));
    rr=rr+1;
end
lll=1;
dt=81;
u=(dt-1)/2;
yy=[zeros(1,u+2) somm zeros(1,u+2)];
for jj=u+1:1:length(y)+u
mmm(lll)=rms(yy(jj-u:jj+u));
lll=lll+1;
end
mmm=mmm-min(mmm);
seuil1=thrr;
x22=mmm;
ee=1;
ff=1;
for ii=1:(length(x22)-1)
    if(((x22(ii)<seuil1)&&(x22(ii+1)>seuil1)));
        dep1(ee)=ii;
        ee=ee+1;
    end
    if(((x22(ii)==seuil1)&&(x22(ii+1)>seuil1)));
        dep1(ee)=ii;
        ee=ee+1;
    end
    if(((x22(ii)>seuil1)&&(x22(ii+1)<seuil1)));
        fin1(ff)=ii;
        ff=ff+1;
    end
    if(((x22(ii)==seuil1)&&(x22(ii+1)<seuil1)));
       fin1(ff)=ii;
        ff=ff+1;
    end  
end
%% Boundry Effect 
if((length(dep1)==length(fin1))&&(dep1(1)<fin1(1)))
    dep1=dep1;
    fin1=fin1;
end
if((length(dep1)==length(fin1))&&(dep1(1)>fin1(1)))
    dep1=dep1(1:end-1);
    fin1=fin1(2:end);
end
if((length(dep1)>length(fin1))&&(dep1(1)<fin1(1)))
    dep1=dep1(1:end-1);
    fin1=fin1;
end
if((length(dep1)>length(fin1))&&(dep1(1)>fin1(1)))
    
    dep1=dep1(2:end);
    fin1=fin1;
end
if((length(dep1)<length(fin1))&&(dep1(1)<fin1(1)))
    dep1=dep1;
    fin1=fin1(1:end-1);
end
if((length(dep1)<length(fin1))&&(dep1(1)>fin1(1)))
    dep1=dep1;
    fin1=fin1(2:end);
end   
%% 

for ii=1:length(fin1)% Extraction of IMFs with significant amplitudes at HFOs frequencies band for each deteced events as putative HFO.
aa=dep1(ii);
bb=fin1(ii);
rr1=1;
rr2=1;
lll=1;
for jj=1:length(SA1)   
v1=SA1{jj};
v2=SA2{jj};
v3=TA(jj);
comm=0;
for ll=1:length(v2)
    if((aa-1<v2(ll))&&(bb+1>v2(ll)))
        TAB1{ii}(rr1)=v1(ll);
        TAB2{ii}(rr1)=v2(ll);
        rr1=rr1+1;
        comm=1; 
    end
end           
if(comm==1)
tabposo=min(TAB2{ii});
tabpose=max(TAB2{ii});
poss=TA(jj);
ss(lll)=tabposo;
ss(lll+1)=tabpose;
ss(lll+2)=poss;
lll=lll+3;
end
end
tabrev{ii}=ss;% Combination of IMFs and detected position with significant amplitudes at HFOs frequencies band for each deteced evenys as putative HF0
clear ss;
for jj=1:length(SA11)   
v11=SA11{jj};
v22=SA22{jj};
for ll=1:length(v22)
    if((aa-1<v22(ll))&&(bb+1>v22(ll)))
        TAB12{ii}(rr2)=v11(ll);
        TAB21{ii}(rr2)=v22(ll);
        rr2=rr2+1;
    end
end 
end
end
%% Rejection of false events
nv=1;
    for jj=1:length(TAB1) 
    if(length(TAB1{jj})~=0)
        dep11(nv)=dep1(jj);
        fin11(nv)=fin1(jj);
        TAB11{nv}=TAB1{jj};
        TAB22{nv}=TAB2{jj};
        tabrevv{nv}=tabrev{nv};
        nv=nv+1;
    end
    end
 ZZa=(S);
cc1=ones(1,length(mmm))*thrr;
cc2=ones(1,length(mmm))*250;
   sig1=zeros(1,H)';
   for kk=1:length(tabrevv)
       sig=zeros(1,H)';
       for jj=1:3:length(tabrevv{kk})-2
           p1=tabrevv{kk}(jj)-20;
           p2=tabrevv{kk}(jj+1)+20;
           p3=tabrevv{kk}(jj+2);
           kl=zeros(1,H)';
           kl(p1:p2)=x(p1:p2,p3);
           sig1=sig1+kl;  
           sig=sig+kl;
       end
       sig=abs(sig);
       nombre=0;
       for iiii=1:1:H-1
           if((sig(iiii+1)<sig(iiii))&&(sig(iiii-1)<sig(iiii)))
            nombre=nombre+1;
           else
               nombre=nombre;
           end
       end
       if(nombre>6)
           dep11(kk)=dep11(kk);
           fin11(kk)=fin11(kk);
       else
           dep11(kk)=0;
           fin11(kk)=0;
       end
       clear sig
   end
    for jj=1:length(dep11) 
    if(dep11(jj)~=0)
        dep0(nv)=dep11(jj);
        fin0(nv)=fin11(jj);
        nv=nv+1;
    end
    end
%%
clear dep11 fin11
aaa=dep0;
bbb=fin0;
vvcc=1;
for kk=1:length(aaa)
    if(fix(bbb(kk)+ni)>1)
posdebhfo(vvcc)=fix(aaa(kk)+ni);
posfinhfo(vvcc)=fix(bbb(kk)+ni);
vvcc=vvcc+1;
    end
end
matt=zeros(1,length(x));
for jj=1:1:length(posdebhfo)
    matt(posdebhfo(jj):posfinhfo(jj))=1;
end
matt1=zeros(1,length(x));
matt2=zeros(1,length(x));
 for kk=1:length(TAB21)
     if (((max(TAB12{kk}))>250) & ((min(TAB12{kk}))<250))
         ab=min(TAB21{kk});
         ba=max(TAB21{kk});
         matt1(ab:ba)=1;
         matt2(ab:ba)=1;
     end
      if (((min(TAB12{kk}))>250))
         ab=min(TAB21{kk});
         ba=max(TAB21{kk});
        
         matt2(ab:ba)=1;
      end
      if (((max(TAB12{kk}))<250))
         ab=min(TAB21{kk});
         ba=max(TAB21{kk});
         matt1(ab:ba)=1;
      end
 end
 
 for kkk=1:length(posdebhfo)
   aaaa=posdebhfo(kkk);
   bbbb=posfinhfo(kkk);
   somm=0
   llka=0
        for kkjj=1:499
            for jjkk=aaaa:bbbb
      if(S(kkjj,jjkk)>0.2)
       somm=somm+kkjj;
        llka=llka+1;
         end
        end
        end
    aaaa=0;
    bbbb=0;
    free1(kkk)=sum(somm)/llka;
 end