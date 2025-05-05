function [posdebhfo, posfinhfo,matt,freq,dBS,matt1,matt2,free1]= waveletcmor(x,ni,ns,Fsample,beta ,cycles)
i=sqrt(-1);
l=length(x);
n=length(x);
xq=-l:1:l;
kk=1;
fc=7/(2*pi);
freq=[80:5:450];
for ii=1:1:length(freq)
a(kk) =fc/(0.0005.*freq(ii));
kk=kk+1;
end
len =length(a);
W=zeros(len,n);
for jj=1:1:len
   xx=xq/a(jj); 
   g=exp(-xx.^2/2).*exp(i*7*xx)/sqrt(a(jj));
   wa=conv(x,g);
   W(jj,1:n)= wa(n+1:2*n);
    end
    S=W.*W;
   dBS = 10*log10(abs(S));
dBS = max(0,dBS);
load reference
par=ref.*beta;
ab=1;
bc=1;
for ii=2:1:len-1%ligne
    for jj=2:1:n-1
        if((dBS(ii,jj)>dBS(ii-1,jj))&&(dBS(ii,jj)>dBS(ii+1,jj)) &&(dBS(ii,jj)>dBS(ii,jj-1))&&(dBS(ii,jj)>dBS(ii,jj+1))&&(dBS(ii,jj)>dBS(ii+1,jj+1))&&(dBS(ii,jj)>dBS(ii-1,jj-1))&&(dBS(ii,jj)>dBS(ii-1,jj+1))&&(dBS(ii,jj)>dBS(ii+1,jj-1))&&(dBS(ii,jj)>par(ii)))
            axe(ab)=jj;
            ord(bc)=ii;
            ab=ab+1;
            bc=bc+1;
        end
    end
end
com1=0;
com2=0;
pos1=1;
pos2=1;
for kk=1:length(ord)
    while ((dBS(ord(kk),axe(kk)-pos1)>par(ord(kk)))&&((axe(kk)-pos1)>1))
        com1=com1+1;
        pos1=pos1+1;   
    end
    gauche(kk)=com1;
    debut(kk)=(axe(kk)-com1);
    while ((dBS(ord(kk),axe(kk)+pos2)>par(ord(kk)))&&((axe(kk)+pos2)<n-1))
        com2=com2+1;
        pos2=pos2+1;
     end
    droite(kk)=com2;
    fin(kk)=(axe(kk)+com2);
   
    tab(kk)=com1+com2;
    pos1=1;
    pos2=1;
    com1=0;
    com2=0;
end
%;;;;trier
 for kk=1:length(ord)-1
     if(ord(kk+1)==ord(kk))
         if ((axe(kk)+droite(kk))>(axe(kk+1)-gauche(kk+1)))
           tab(kk)=tab(kk);
           tab(kk+1)=0;
         end
     end
 end
 
 %duree se seuillage 
 
 iii=1;
 for kk=1:length(tab)
 %calcul de seuil
 indic=ord(kk)
 D=(cycles/freq(indic)).*Fsample;
 if(tab(kk)>D&&(tab(kk)~=0))
     dur(iii)=tab(kk);
     pos(iii)=axe(kk);
     fre(iii)=freq(indic);
     ddd(iii)=debut(kk);
     fff(iii)=fin(kk);
     iii=iii+1;
 end
 end
%%
posdebhfo1=ddd;
posfinhfo1=fff;
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
matt=zeros(1,n);
matt1=zeros(1,n);
matt2=zeros(1,n);
for jj=1:1:length(posdebhfo)
    matt(posdebhfo(jj):posfinhfo(jj))=1;
end 

for jj=1:1:length(ddd);
if (fre(jj)<250)
    matt1(posdebhfo1(jj):posfinhfo1(jj))=1;
end
if (fre(jj)>250)
    matt2(posdebhfo1(jj):posfinhfo1(jj))=1;
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
            
            
        
