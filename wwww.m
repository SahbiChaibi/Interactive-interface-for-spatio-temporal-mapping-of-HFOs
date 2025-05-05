if(CC==1)
    electchange
[posdebhfo, posfinhfo, matt] = firrms_2(x, Fsample,beta ,cycles ); 
b = fir1(155,[0.08 0.45]);
a=1; %filtre FIR n'a pas des poles, seulement zeros.
y = filtfilt(b,a,x);
Zz=y(1:+(fenetre_affich*Fsample));
born_sign_filt = [-max(abs(Zz)) max(abs(Zz))]*3;
subplot(11,20,[103:120 123:140 143:160 163:180])
GUI.p_sign_filt = plot(y(1:+(fenetre_affich*Fsample)), 'k','LineWidth',0.88); 
% set(gca,'color',[0.925 0.913 0.687]);
axis([1 length(1:fenetre_affich*Fsample) born_sign_filt(1) born_sign_filt(2)])
        subplot(11,20,[203:220])
        GUI.p_signdetection = imagesc(matt(1,1:fenetre_affich*Fsample));
        set(gca,'ydir','normal');
        colormap(hot);
        set(gca,'ydir','normal');
        xx=x;
for i=1:length(posdebhfo)
    xx(posdebhfo(i):posfinhfo(i))=NaN;
    if(i<length(posdebhfo))
    Occurane(i)= (posdebhfo(i+1)-posfinhfo(i))*(1000/Fsample);
    else 
       Occurane(i)=  Occurane(end);
    end
     DurationHFO(i)=((posfinhfo(i)-posdebhfo(i))/Fsample)*1000;
     powerr(i)=sum(abs(x(posdebhfo(i):posfinhfo(i))))/(posfinhfo(i)-posdebhfo(i));
     frequencyy(i)=0;
end
occurate=length(posfinhfo)/(length(x)/Fsample);
subplot(11,20,[3:20 23:40 43:60 63:80])
hold on;
GUI.p_signn = plot(xx(1:+(fenetre_affich*Fsample)), 'k','LineWidth',0.90);
        
Start_result = uicontrol('Style', 'pushbutton', 'String', 'Detection Results', 'Position', [5 50 180 30],...
'Callback','Plot_main');
mapps = uicontrol('Style', 'pushbutton', 'String', 'Mapping of HFOs', 'Position', [5 20 180 30],...
'Callback','codemapping');
end

if(CC==2)
   electchange
  [posdebhfo, posfinhfo, matt,freq,dBS,matt1,matt2,free1]=waveletcmor(x,ni,ns,Fsample,beta ,cycles); 
 subplot(11,20,[103:120 123:140 143:160 163:180])
 
   %GUI.p_sign_filt= imagesc(1:fenetre_affich*Fsample,freq,dBS(:,1:fenetre_affich*Fsample));
   %set(gca,'ydir', 'normal');
   colormap(hot)
    GUI.p_sign_filt= imagesc(1:fenetre_affich*Fsample,freq,dBS(:,1:fenetre_affich*Fsample));
        set(gca,'ydir', 'normal')
       
  % axis([1 length(1:fenetre_affich*Fsample)  freq(1) freq(end)])
   subplot(11,20,[203:220])
     
     colormap(hot)
        GUI.p_signdetection = imagesc(matt(1,1:fenetre_affich*Fsample));
        set(gca,'ydir', 'normal')
        xx=x;
for i=1:length(posdebhfo)
    xx(posdebhfo(i):posfinhfo(i))=NaN;
    if(i<length(posdebhfo))
    Occurane(i)= (posdebhfo(i+1)-posfinhfo(i))*(1000/Fsample);
    else 
       Occurane(i)=  Occurane(end);
    end
     DurationHFO(i)=((posfinhfo(i)-posdebhfo(i))/Fsample)*1000;
     powerr(i)=sum(abs(x(posdebhfo(i):posfinhfo(i))))/(posfinhfo(i)-posdebhfo(i));
     frequencyy(i)=free1(i);
end
occurate=length(posfinhfo)/(length(x)/Fsample);
subplot(11,20,[3:20 23:40 43:60 63:80])
hold on;
GUI.p_signn = plot(xx(1:+(fenetre_affich*Fsample)), 'k','LineWidth',0.90);

Start_result = uicontrol('Style', 'pushbutton', 'String', 'Detection Results', 'Position', [5 50 180 30],...
'Callback','Plot_main');
mapps = uicontrol('Style', 'pushbutton', 'String', 'Mapping of HFOs', 'Position', [5 20 180 30],...
'Callback','Plot_main');
end

if(CC==3)
electchange    
fid = fopen('match.txt','w');
fprintf(fid,'%-.0f\r',x);
fclose(fid);
len=length(x);
dos('MP4 &');
pause
    [posdebhfo, posfinhfo, matt,y,matt1,matt2,free1,map,xxx,yyy]=mpdec(x,Fsample,len,cycles,amp);
%     Zz=y(1:+(fenetre_affich*Fsample));
% born_sign_filt = [-max(abs(Zz)) max(abs(Zz))]*3;
    subplot(11,20,[103:120 123:140 143:160 163:180])
%     GUI.p_sign_filt = plot(y(1:+(fenetre_affich*Fsample)), 'k'); 
% axis([1 length(1:fenetre_affich*Fsample) born_sign_filt(1) born_sign_filt(2)])
        
 
   %GUI.p_sign_filt= imagesc(1:fenetre_affich*Fsample,freq,dBS(:,1:fenetre_affich*Fsample));
   %set(gca,'ydir', 'normal')
   mapp= histeq(map);
    GUI.p_sign_filt= imagesc(1:fenetre_affich*Fsample,yyy(300:2000),mapp((300:2000),1:fenetre_affich*Fsample));
        set(gca,'ydir', 'normal')
        colormap(hot)
subplot(11,20,[203:220])
        GUI.p_signdetection = imagesc(matt(1,1:fenetre_affich*Fsample));
        set(gca,'ydir', 'normal')
        colormap(hot)
         xx=x;
for i=1:length(posdebhfo)
    xx(posdebhfo(i):posfinhfo(i))=NaN;
    if(i<length(posdebhfo))
    Occurane(i)= (posdebhfo(i+1)-posfinhfo(i))*(1000/Fsample);
    else 
       Occurane(i)=  Occurane(end);
    end
     DurationHFO(i)=((posfinhfo(i)-posdebhfo(i))/Fsample)*1000;
     powerr(i)=sum(abs(x(posdebhfo(i):posfinhfo(i))))/(posfinhfo(i)-posdebhfo(i));
     frequencyy(i)=free1(i);
end
occurate=length(posfinhfo)/(length(x)/Fsample);
subplot(11,20,[3:20 23:40 43:60 63:80])
hold on;
GUI.p_signn = plot(xx(1:+(fenetre_affich*Fsample)), 'k','LineWidth',0.90);
   Start_result = uicontrol('Style', 'pushbutton', 'String', 'Detection Results', 'Position', [5 50 180 30],...
'Callback','Plot_main');
mapps = uicontrol('Style', 'pushbutton', 'String', 'Mapping of HFOs', 'Position', [5 20 180 30],...
'Callback','Plot_main');
end

if(CC==4)
    electchange
 [posdebhfo, posfinhfo, matt,freq,dBSS,matt1,matt2,free1]=bump(x,ni,ns,Fsample,cycles,fc);    
 subplot(11,20,[103:120 123:140 143:160 163:180])
 
   %GUI.p_sign_filt= imagesc(1:fenetre_affich*Fsample,freq,dBS(:,1:fenetre_affich*Fsample));
   %set(gca,'ydir', 'normal');
   
    GUI.p_sign_filt= imagesc(1:fenetre_affich*Fsample,freq,dBSS(:,1:fenetre_affich*Fsample));
        set(gca,'ydir', 'normal')
        colormap(jet)
        caxis([0.0 0.2])
  % axis([1 length(1:fenetre_affich*Fsample)  freq(1) freq(end)])
   subplot(11,20,[203:220])
        GUI.p_signdetection = imagesc(matt(1,1:fenetre_affich*Fsample));
        set(gca,'ydir', 'normal')
        colormap(hot)
         xx=x;
for i=1:length(posdebhfo)
    xx(posdebhfo(i):posfinhfo(i))=NaN;
    if(i<length(posdebhfo))
    Occurane(i)= (posdebhfo(i+1)-posfinhfo(i))*(1000/Fsample);
    else 
       Occurane(i)=  Occurane(end);
    end
     DurationHFO(i)=((posfinhfo(i)-posdebhfo(i))/Fsample)*1000;
     powerr(i)=sum(abs(x(posdebhfo(i):posfinhfo(i))))/(posfinhfo(i)-posdebhfo(i));
     frequencyy(i)=free1(i);
end
occurate=length(posfinhfo)/(length(x)/Fsample);
subplot(11,20,[3:20 23:40 43:60 63:80])
hold on;
GUI.p_signn = plot(xx(1:+(fenetre_affich*Fsample)), 'k','LineWidth',0.90);
Start_result = uicontrol('Style', 'pushbutton', 'String', 'Detection Results', 'Position', [5 50 180 30],...
'Callback','Plot_main');
mapps = uicontrol('Style', 'pushbutton', 'String', 'Mapping of HFOs', 'Position', [5 20 180 30],...
'Callback','Plot_main');
end

if(CC==5)
    electchange
[posdebhfo, posfinhfo, matt,matt1,matt2,sig1,S,free1] = hht(x,ni,ns,Fsample,cycles,rmsth)
y = sig1;
% Zz=y(1:+(fenetre_affich*Fsample));
% born_sign_filt = [-max(abs(Zz)) max(abs(Zz))]*3;
subplot(11,20,[103:120 123:140 143:160 163:180])
%GUI.p_sign_filt = plot(y(1:+(fenetre_affich*Fsample)), 'k'); 
%axis([1 length(1:fenetre_affich*Fsample) born_sign_filt(1) born_sign_filt(2)])
%     GUI.p_sign_filt = plot(y(1:+(fenetre_affich*Fsample)), 'k'); 
% axis([1 length(1:fenetre_affich*Fsample) born_sign_filt(1) born_sign_filt(2)])
        
 
   %GUI.p_sign_filt= imagesc(1:fenetre_affich*Fsample,freq,dBS(:,1:fenetre_affich*Fsample));
   %set(gca,'ydir', 'normal')
   SSS= histeq(S);
    GUI.p_sign_filt= imagesc(1:fenetre_affich*Fsample,1:499,SSS(:,1:fenetre_affich*Fsample));
        set(gca,'ydir', 'normal')
        colormap(hot)
        

subplot(11,20,[203:220])
        GUI.p_signdetection = imagesc(matt(1,1:fenetre_affich*Fsample));
        set(gca,'ydir','normal');
        colormap(hot);
        set(gca,'ydir','normal');
        xx=x;
for i=1:length(posdebhfo)
    xx(posdebhfo(i):posfinhfo(i))=NaN;
    if(i<length(posdebhfo))
    Occurane(i)= (posdebhfo(i+1)-posfinhfo(i))*(1000/Fsample);
    else 
       Occurane(i)=  Occurane(end);
    end
     DurationHFO(i)=((posfinhfo(i)-posdebhfo(i))/Fsample)*1000;
     powerr(i)=sum(abs(x(posdebhfo(i):posfinhfo(i))))/(posfinhfo(i)-posdebhfo(i));
    frequencyy(i)=free1(i);
end
occurate=length(posfinhfo)/(length(x)/Fsample);
subplot(11,20,[3:20 23:40 43:60 63:80])
hold on;
GUI.p_signn = plot(xx(1:+(fenetre_affich*Fsample)), 'k','LineWidth',0.90);
Start_result = uicontrol('Style', 'pushbutton', 'String', 'Detection Results', 'Position', [5 50 180 30],...
'Callback','Plot_main');
mapps = uicontrol('Style', 'pushbutton', 'String', 'Mapping of HFOs', 'Position', [5 20 180 30],...
'Callback','Plot_main');
end
if(CC==6)
    electchange
[posdebhfo, posfinhfo, matt] = treee(x, Fsample ,cycles,recti ); 
b = fir1(155,[0.08 0.5]);
a=1; %filtre FIR n'a pas des poles, seulement zeros.
z=filtfilt(b,a,x);
ghf=length(x);
y=zeros(1,ghf);
for kk=1:length(posdebhfo);
    y(posdebhfo(kk):posfinhfo(kk))= z(posdebhfo(kk):posfinhfo(kk));
end
Zz=y(1:+(fenetre_affich*Fsample));
born_sign_filt = [-max(abs(Zz)) max(abs(Zz))]*3;
subplot(11,20,[103:120 123:140 143:160 163:180])
GUI.p_sign_filt = plot(y(1:+(fenetre_affich*Fsample)), 'k'); 
axis([1 length(1:fenetre_affich*Fsample) born_sign_filt(1) born_sign_filt(2)])
        subplot(11,20,[203:220])
        GUI.p_signdetection = imagesc(matt(1,1:fenetre_affich*Fsample));
        set(gca,'ydir','normal');
        colormap(hot);
        set(gca,'ydir','normal');
         xx=x;
for i=1:length(posdebhfo)
    xx(posdebhfo(i):posfinhfo(i))=NaN;
    if(i<length(posdebhfo))
    Occurane(i)= (posdebhfo(i+1)-posfinhfo(i))*(1000/Fsample);
    else 
        Occurane(i)=  Occurane(end);
    end
     DurationHFO(i)=((posfinhfo(i)-posdebhfo(i))/Fsample)*1000;
     powerr(i)=sum(abs(x(posdebhfo(i):posfinhfo(i))))/(posfinhfo(i)-posdebhfo(i));
     frequencyy(i)=0;
end
occurate=length(posfinhfo)/(length(x)/Fsample);
subplot(11,20,[3:20 23:40 43:60 63:80])
hold on;
GUI.p_signn = plot(xx(1:+(fenetre_affich*Fsample)), 'k','LineWidth',0.90);

Start_result = uicontrol('Style', 'pushbutton', 'String', 'Detection Results', 'Position', [5 50 180 30],...
'Callback','Plot_main');
mapps = uicontrol('Style', 'pushbutton', 'String', 'Mapping of HFOs', 'Position', [5 20 180 30],...
'Callback','Plot_main');
end