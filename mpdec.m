function [posdebhfo, posfinhfo,matt,y,matt1,matt2,free1,map,xxx,yyy]= mpdec(x,Fsample,len,cycles,amp)

%save the signal to a file
%and decomposed using mp4 with commands:
%MP4>set -e 95 -i 10
%MP4>reinit -O 512 -R 1000000
%MP4>loadsig -O tmp.txt -F 128
%MP4>mp
%MP4>save


%% now we load the results of the decomposition, atoms in 'a' and header in 'h':

[a,h]=readbook('book.b',0);
% some constants related to the internal structure of the 'book':
SCALE  =1;
FREQ   =2;
POS    =3;
MODULUS=4;
AMPLI  =5;
PHASE  =6;
H_SAMPLING_FREQ=1;
H_SIGNAL_SIZE=2
H_POINTS_PER_MICROVOLT=3;
H_VERSION=4;
con=1;
for ii=1:1:size(a,1)
    if((a(ii,2)>80)&&(a(ii,2)<450))
    if((amp<a(ii,5))&&(1.7*a(ii,1)>cycles/a(ii,2)));
bb(con,:)=a(ii,:)
fre(con)=a(ii,2);     
pos(con)=(a(ii,3).*Fsample);
deb(con)=(a(ii,3).*Fsample)-0.85*(a(ii,1).*Fsample);
fine(con)=(a(ii,3).*Fsample)+0.85*(a(ii,1).*Fsample);
    con=con+1;
    end
    end
end
deb=fix(deb);
fine =fix(fine);
pos=fix(pos);
fre=fre;
y=zeros(1,len); 
for ii=1:1:size(bb,1)
        mm=gabor(h(H_SIGNAL_SIZE)/h(H_SAMPLING_FREQ),h(H_SAMPLING_FREQ),bb(ii,SCALE),bb(ii,FREQ),bb(ii,POS),bb(ii,AMPLI),bb(ii,PHASE))
        y=mm+y;
end
if(y==0)
    y=zeros(1,len) 
end
posdebhfo1=deb;
posfinhfo1=fine;
matto=zeros(1,len);
for jj=1:1:length(posdebhfo1)
    matto(posdebhfo1(jj):posfinhfo1(jj))=1;
end  
ttttt=1;
tttt=1;
wew=1;
ewe=length(matto);
    while(matto(wew)~=0)
        wew=wew+1;
    end
    while(matto(ewe)~=0)
        ewe=ewe-1;
    end
        
for jj=wew:1:ewe-1
    if((matto(jj)==0)&&(matto(jj+1)==1))
      posdebhfo(ttttt)=jj; 
      ttttt=ttttt+1;
    end
    if((matto(jj)==1)&&(matto(jj+1)==0))
      posfinhfo(tttt)=jj;  
      tttt=tttt+1;
    end
end 
matt=zeros(1,len);
matt1=zeros(1,len);
matt2=zeros(1,len);
for jj=1:1:length(posdebhfo)
    matt(posdebhfo(jj):posfinhfo(jj))=1;
end 

for jj=1:1:length(deb);

if (fre(jj)<250)
    matt1(deb(jj):fine(jj))=1;
end

if (fre(jj)>250)
    matt2(deb(jj):fine(jj))=1;
end
end
for kkk=1:length(posdebhfo)
    aaaa=posdebhfo(kkk);
    bbbb=posfinhfo(kkk);
    somm=0
    llka=0
    for jjkk=1:length(fre)
        if((pos(jjkk)>aaaa)&&(pos(jjkk)<bbbb))
            somm=somm+fre(jjkk);
            llka=llka+1;
        end
    end
    free1(kkk)=sum(somm)/llka;
end
[map,xxx,yyy]=mp2tf(a, h, 1, 1);
xxx=xxx*1000;
