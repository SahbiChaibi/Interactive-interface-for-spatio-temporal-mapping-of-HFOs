Fseuil=fc;
% Fseuil=choix_F(get(hpop_2, 'Value'));
amplitude=0;
KK=NNN;
sss=1;
dispmat =zeros(model.size_freq, model.size_time);
   i=1;
   for j=1:model.num
       F=0;
       maxpos=0;
      d = model.dec((i-1)*model.num+j,:);
      w = model.windows((i-1)*model.num+j,:);
         xl = w(4);
         yl = w(3);      
         up = w(1);  
         lf = w(2);   
      mat = calc_demi_ellips(d,xl,yl);
      ppp=sum(sum(mat));
         F=ppp/pp; 
      if(F>Fseuil)
        upp=477-up;
        MM=upp-yl/2;
        mm=MM+53;  
        if(mm>80)
      dispmat(up:up+yl-1,lf:lf+xl-1)= max(dispmat(up:up+yl-1,lf:lf+xl-1),mat);
        tab(sss)=xl;
        dep(sss)=lf;
        fin(sss)=(lf+xl-1);
        freq(sss)=mm;
        sss=sss+1;
        end
      end  
   end
    dispmat=flipud(dispmat);
    dBS=dispmat;
%    subplot(14,1,[9 10 11])
%        GUI.p_sign2= imagesc(TT,(80-27:1:400+129),dispmat);set(gca,'ydir', 'normal');
       
       n=model.size_time*2.5;
matt=zeros(1, n);
matt1=zeros(1,n);
matt2=zeros(1,n);
dep=fix(dep*2.5);
fin=fix(fin*2.5);
tab=fix(tab*2.5);
for jj=1:1:length(dep);
    matt(posdebhfo(jj):fin(jj))=1;
end
for jj=1:1:length(dep)
if (freq(jj)<250)
    matt1(dep(jj):fin(jj))=1;
end
if (freq(jj)>250)
    matt2(dep(jj):fin(jj))=1;
end
end

posdebhfo=dep+65+ni;
posfinhfo=fin+65+ni;
freq=80-27:1:400+129;
