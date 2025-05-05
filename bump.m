function [posdebhfo, posfinhfo, matt,freq,dBSS,matt1,matt2,free1]=bump(x,ni,ns,Fsample,cycles,fc)
header.freqsmp = 2000; % signal sampling rate
header.freqmin = 80; % minimal frequency investigated                           
% note: signal length must be at least 3.5*(frequsmp/freqmin) due to wavelet
% lower bounds.
header.freqmax =400;% maximal frequency investigated
header.freqstp = 1;% frequency step
header.freqdown = 800; % down-sampling rate 
% note: before wavelet transform, freqmax must be < 5*freqsmp
% after wavelet transform, freqmax must be < 2*freqdown (nyquist rate)
header.begin= 1/2000;%beginning of modelled period inside the signal (in secs)
header.end= length(x)/2000;%end of modelled period inside the signal (in secs)
header.beginref= 1/2000;%beginning of reference period for the z-score (in secs)
header.endref= length(x)/2000;% end of reference period for the z-score (in secs)
header.wavelet = 'cmor2.0558-0.5874'; % name of the used wavelet
% note: only cmor2.0558-0.5874 is supported until now
%       Fc = 2.0558;  Fb = 0.5874; --> M=7
header.cote=5; % size of the modelling windows (should be 4 for ERS)
header.offset_val=1; % z-score offset (removing ERD-like or ERS-like components)
header.limit= 0.0001; % modeling limit, usually in [0.1-0.3]
%(in percentage of the total energy)
header.maxi= 2500;
% maximal number of bump modelled (usually in [100-500])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%            Loading signal              %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sigs{1}=x;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%             Bump modeling              %%%
  %name = 'signali'; 
 %Compute_wavefiles_fromcell(sigs,name,header,[]);    
 % butif(name);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load signali
options='2D';
fresamp=Fsample;
freqdown=800;
mu=fresamp/freqdown;
len=length(x);
   TT=1*mu:1*mu:mu*model.size_time;
   len1=length(TT)*mu;
   len2=round((len-len1)/2);
    [cofh,t,freq]= trans(x);
%  load lem
       cofh=cofh/60;
       cohf=cofh(:,len2:len-len2);
         pp=sum(sum(cofh));
         
%%
Fseuil=fc;
sss=1;
azea=length(x);
dispmat =zeros(model.size_freq,azea);
   i=1;
   decale=fix((azea-model.size_time*2.5));
   for j=1:model.num
       F=0;
      d = model.dec((i-1)*model.num+j,:);
      w = model.windows((i-1)*model.num+j,:);
         xl = fix(w(4)*mu);
         yl = w(3);      
         up = w(1);  
         lf = fix(w(2)*mu+decale);   
      mat = calc_demi_ellips(d,xl,yl);
      ppp=sum(sum(mat));
         F=ppp/pp; 
      if(F>Fseuil)
        upp=477-up;
        MM=upp-yl/2;
        mm=MM+53;  
        if(mm>80)
      dispmat(up:up+yl-1,fix(lf-(xl/2)):fix(lf+(xl/2))-1)= max(dispmat(up:up+yl-1,fix(lf-(xl/2)):fix(lf+(xl/2))-1),mat);
        dep(sss)=fix(lf-(xl/2));
        fin(sss)=fix(lf+(xl/2));
        poss(sss)=lf
        freqq(sss)=mm;
        sss=sss+1;
        end
      end  
   end
 dispmat=flipud(dispmat);
 dBSS=dispmat;
 n=azea;
matt=zeros(1, n);
matt1=zeros(1,n);
matt2=zeros(1,n);
dep=fix(dep);
fin=fix(fin);
for jj=1:1:length(dep);
    matt(dep(jj):fin(jj))=1;
end
for jj=1:1:length(dep)
if (freq(jj)<250)
    matt1(dep(jj):fin(jj))=1;
end
if (freq(jj)>250)
    matt2(dep(jj):fin(jj))=1;
end
end
ttttt=1;
tttt=1;
wew=1;
ewe=length(matt);
    while(matt(wew)~=0)
        wew=wew+1;
    end
    while(matt(ewe)~=0)
        ewe=ewe-1;
    end 
for jj=wew:1:ewe-1
    if((matt(jj)==0)&&(matt(jj+1)==1))
      posdebhfo(ttttt)=jj; 
      ttttt=ttttt+1;
    end
    if((matt(jj)==1)&&(matt(jj+1)==0))
      posfinhfo(tttt)=jj;  
      tttt=tttt+1;
    end
end 
freq=80-27:1:400+129;
for kkk=1:length(posdebhfo)
    aaaa=posdebhfo(kkk);
    bbbb=posfinhfo(kkk);
    somm=0
    llka=0
    for jjkk=1:length(freqq)
        if((poss(jjkk)>aaaa)&&(poss(jjkk)<bbbb))
            somm=somm+freqq(jjkk);
            llka=llka+1;
        end
    end
    free1(kkk)=sum(somm)/llka;
end

