function [TABD, TABF,matt,xx,Occuranee,powerrr,DurationHFOO,frequencyyy] = conversion(TABDEL, posdebhfo, posfinhfo,zz,electrode,x,xx,Occurane,powerr,DurationHFO,frequencyy)
% load resull 

TABD=[];
TABF=[];
mmm=1;
nnn=1;
for jj=1:1:length(TABDEL)
    if (TABDEL(jj)>0)
        TABD (mmm)= [posdebhfo(TABDEL(jj))]
        TABF(nnn) = [posfinhfo(TABDEL(jj))]
        Occuranee(nnn)=[Occurane(TABDEL(jj))]
        powerrr(nnn)=[powerr(TABDEL(jj))]
         DurationHFOO(nnn)=[DurationHFO(TABDEL(jj))]
          frequencyyy(nnn)=[frequencyy(TABDEL(jj))]
        mmm=mmm+1;
        nnn=nnn+1;
    else
         xx(posdebhfo(jj):posfinhfo(jj))= x(posdebhfo(jj):posfinhfo(jj));
    end
      
end

%if((length(TABD))==0)
 % TABD(1)=0;
  %TABF(1)=0;
%end
matt=zeros(1,zz)
for ii=1:1:length(TABD)
     matt(TABD(ii):TABF(ii))=1;
end 
    

% clear posdebhfo
% clear posfinhfo 
% posdebhfo=TABD;
% posfinhfo=TABF;
% 
% save resull posdebhfo posfinhfo
