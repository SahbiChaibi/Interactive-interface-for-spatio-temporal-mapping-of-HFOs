if(CCC==1)
   subplot(10,2,[ 3 5 7 9 11 13 15 17])
GUI.p_sign1 = imshow(I)
llkk=1;
    for iii=1:MM
        tess=exist(['Electrod' num2str(iii) '.mat']);
        if(tess==2)
        Tableau(llkk)=iii
        llkk=llkk+1;
        end
    end
 for jjj=1:length(Tableau) 
            load (['Electrod' num2str(Tableau(jjj)) '.mat']')
            for iii=1:length(posdebhfo)
            Vectd(jjj,iii)=posdebhfo(iii);
            Vectf(jjj,iii)=posfinhfo(iii);
            TABDUR(jjj,iii)=Occuranee(iii);
            end
 end
 llmm=1;
 mmll=1;
 [s position]= sort(Vectd(:));
 [i j]=ind2sub(size(Vectd),position);
 for iii=1:length(i)
         if((Vectf(i(iii),j(iii)))~=0)
         TABF(mmll)=Vectf(i(iii),j(iii));
         TABM(mmll)=TABDUR(i(iii),j(iii));
         mmll=mmll+1;
         end
     end
INDEXX=[];
 for ii=1:length(s(:,1))
        if(s(ii,1)~=0)
           TABD(llmm)=s(ii,1);
           INDEXX(llmm)=i(ii);
           llmm=llmm+1;
       end
 end
 %%
 indexxx=1;
 cx=[];
 cy=[];
 for jjj=1:length(Tableau)        
aa=eval(['cursor_info',num2str(Tableau(jjj)),'.','Position'])   
cx(indexxx)=aa(1);
cy(indexxx)=aa(2);
indexxx=indexxx+1;
 end
 
 for jjj=1:length(TABD)
     duration(jjj)=TABM(jjj);
 end
 
ran=range(duration);
min_val=min(duration); % min(x);%finding maximum value of data
max_val= max(duration);        % max(x)%finding minimum value of data
y= floor(((duration-min_val)/ran)*63)+1;               %  
p=colormap('jet');
caxis([min_val max_val])
POS=1;
vectsort=sort(INDEXX)
INDEXXX1(1)=Tableau(1)
INDEXXX2(1)=vectsort(1)
lkj=1
for kl=1:length(INDEXX)-1
    if(vectsort(kl+1)~=vectsort(kl))
        lkj=lkj+1;
        INDEXXX1(lkj)=Tableau(lkj);
        INDEXXX2(lkj)=vectsort(kl+1)
    end
end
INDEXXX=[];
for mmk=1:length(INDEXX)
    cvc=INDEXX(mmk);
    for gfk=1:length(INDEXXX2)
        if (cvc==INDEXXX2(gfk))
    INDEXXX(mmk)=INDEXXX1(gfk);
        end
    end
end
for i=1:length(duration)
    Time(i)= (TABD(i)/Fsample)*1000;
a=y(i);
col=p(a,:);
mm=cx(INDEXX(i));
nn=cy(INDEXX(i));
pp= circles(mm,nn,R,'facecolor',[col])
text(mm-R-5, nn-R-5,['E' num2str(INDEXXX(i))]);
colorbar

GUI_timing= uicontrol(gcf,'style','text', 'position',[130 70 110 25], 'string', 'Time (mseconds)', 'BackgroundColor',[1 1 0]); % Sampling Frequency Button.
GUI.Time = uicontrol('style','edit','BackgroundColor',[1 1 0], 'position',[250 70 60 25], 'string', num2str(Time(i)),...
     'Callback', 'Time = str2num(get(GUI.Fsample, ''String''))');
Start_R  = uicontrol('Style', 'pushbutton', 'String', '<< Speed down', 'Position', [130 40 120 25],...
'Callback', 'POS=POS+0.05');
Start_A  = uicontrol('Style', 'pushbutton', 'String', ' Speed up >>', 'Position', [250 40 120 25],...
'Callback','POS=POS-0.05');
  pause() % Timepause(POS)
end
end


%%
if(CCC==2)
 subplot(10,2,[ 3 5 7 9 11 13 15 17])
GUI.p_sign1 = imshow(I)
llkk=1;
    for iii=1:MM
        tess=exist(['Electrod' num2str(iii) '.mat']);
        if(tess==2)
        Tableau(llkk)=iii
        llkk=llkk+1;
        end
    end
 for jjj=1:length(Tableau) 
            load (['Electrod' num2str(Tableau(jjj)) '.mat']')
            for iii=1:length(posdebhfo)
            Vectd(jjj,iii)=posdebhfo(iii);
            Vectf(jjj,iii)=posfinhfo(iii);
            TABDUR(jjj,iii)=DurationHFOO(iii);
            end
 end
 llmm=1;
 mmll=1;
 [s position]= sort(Vectd(:));
 [i j]=ind2sub(size(Vectd),position);
 for iii=1:length(i)
         if((Vectf(i(iii),j(iii)))~=0)
         TABF(mmll)=Vectf(i(iii),j(iii));
         TABM(mmll)=TABDUR(i(iii),j(iii));
         mmll=mmll+1;
         end
     end

 for ii=1:length(s(:,1))
        if(s(ii,1)~=0)
           TABD(llmm)=s(ii,1);
           INDEXX(llmm)=i(ii);
           llmm=llmm+1;
       end
 end
 %%
  %%
 indexxx=1;
 cx=[];
 cy=[];
 for jjj=1:length(Tableau)        
aa=eval(['cursor_info',num2str(Tableau(jjj)),'.','Position'])   
cx(indexxx)=aa(1);
cy(indexxx)=aa(2);
indexxx=indexxx+1;
 end
 
 for jjj=1:length(TABD)
     duration(jjj)=TABM(jjj);
 end
 
ran=range(duration);
min_val=min(duration); % min(x);%finding maximum value of data
max_val= max(duration);        % max(x)%finding minimum value of data
y= floor(((duration-min_val)/ran)*63)+1;               %  
p=colormap('jet');
caxis([min_val max_val])
POS=1;
vectsort=sort(INDEXX)
INDEXXX1(1)=Tableau(1)
INDEXXX2(1)=vectsort(1)
lkj=1
for kl=1:length(INDEXX)-1
    if(vectsort(kl+1)~=vectsort(kl))
        lkj=lkj+1;
        INDEXXX1(lkj)=Tableau(lkj);
        INDEXXX2(lkj)=vectsort(kl+1)
    end
end
INDEXXX=[];
for mmk=1:length(INDEXX)
    cvc=INDEXX(mmk);
    for gfk=1:length(INDEXXX2)
        if (cvc==INDEXXX2(gfk))
    INDEXXX(mmk)=INDEXXX1(gfk);
        end
    end
end
for i=1:length(duration)
    Time(i)= (TABD(i)/Fsample)*1000;
a=y(i);
col=p(a,:);
mm=cx(INDEXX(i));
nn=cy(INDEXX(i));
pp= circles(mm,nn,R,'facecolor',[col])
text(mm-R-5, nn-R-5,['E' num2str(INDEXXX(i))]);
colorbar

GUI_timing= uicontrol(gcf,'style','text', 'position',[130 70 110 25], 'string', 'Time (mseconds)', 'BackgroundColor',[1 1 0]); % Sampling Frequency Button.
GUI.Time = uicontrol('style','edit','BackgroundColor',[1 1 0], 'position',[250 70 60 25], 'string', num2str(Time(i)),...
     'Callback', 'Time = str2num(get(GUI.Fsample, ''String''))');
Start_R  = uicontrol('Style', 'pushbutton', 'String', '<<Speed down', 'Position', [130 40 120 25],...
'Callback', 'POS=POS+0.05');
Start_A  = uicontrol('Style', 'pushbutton', 'String', 'Speed up>>', 'Position', [250 40 120 25],...
'Callback','POS=POS-0.05');
  pause() % Timepause(POS)
end
end
if (CCC==3)
  subplot(10,2,[ 3 5 7 9 11 13 15 17])
GUI.p_sign1 = imshow(I)
llkk=1;
    for iii=1:MM
        tess=exist(['Electrod' num2str(iii) '.mat']);
        if(tess==2)
        Tableau(llkk)=iii
        llkk=llkk+1;
        end
    end
 for jjj=1:length(Tableau) 
            load (['Electrod' num2str(Tableau(jjj)) '.mat']')
            for iii=1:length(posdebhfo)
            Vectd(jjj,iii)=posdebhfo(iii);
            Vectf(jjj,iii)=posfinhfo(iii);
            TABDUR(jjj,iii)=powerrr(iii);
            end
 end
 llmm=1;
 mmll=1;
 [s position]= sort(Vectd(:));
 [i j]=ind2sub(size(Vectd),position);
 for iii=1:length(i)
         if((Vectf(i(iii),j(iii)))~=0)
         TABF(mmll)=Vectf(i(iii),j(iii));
         TABM(mmll)=TABDUR(i(iii),j(iii));
         mmll=mmll+1;
         end
     end

 for ii=1:length(s(:,1))
        if(s(ii,1)~=0)
           TABD(llmm)=s(ii,1);
           INDEXX(llmm)=i(ii);
           llmm=llmm+1;
       end
 end
 %%
 %%
 indexxx=1;
 cx=[];
 cy=[];
 for jjj=1:length(Tableau)        
aa=eval(['cursor_info',num2str(Tableau(jjj)),'.','Position'])   
cx(indexxx)=aa(1);
cy(indexxx)=aa(2);
indexxx=indexxx+1;
 end
 
 for jjj=1:length(TABD)
     duration(jjj)=TABM(jjj);
 end
 
ran=range(duration);
min_val=min(duration); % min(x);%finding maximum value of data
max_val= max(duration);        % max(x)%finding minimum value of data
y= floor(((duration-min_val)/ran)*63)+1;               %  
p=colormap('jet');
caxis([min_val max_val])
POS=1;
vectsort=sort(INDEXX)
INDEXXX1(1)=Tableau(1)
INDEXXX2(1)=vectsort(1)
lkj=1
for kl=1:length(INDEXX)-1
    if(vectsort(kl+1)~=vectsort(kl))
        lkj=lkj+1;
        INDEXXX1(lkj)=Tableau(lkj);
        INDEXXX2(lkj)=vectsort(kl+1)
    end
end
INDEXXX=[];
for mmk=1:length(INDEXX)
    cvc=INDEXX(mmk);
    for gfk=1:length(INDEXXX2)
        if (cvc==INDEXXX2(gfk))
    INDEXXX(mmk)=INDEXXX1(gfk);
        end
    end
end
for i=1:length(duration)
    Time(i)= (TABD(i)/Fsample)*1000;
a=y(i);
col=p(a,:);
mm=cx(INDEXX(i));
nn=cy(INDEXX(i));
pp= circles(mm,nn,R,'facecolor',[col])
text(mm-R-5, nn-R-5,['E' num2str(INDEXXX(i))]);
colorbar

GUI_timing= uicontrol(gcf,'style','text', 'position',[130 70 110 25], 'string', 'Time (mseconds)', 'BackgroundColor',[1 1 0]); % Sampling Frequency Button.
GUI.Time = uicontrol('style','edit','BackgroundColor',[1 1 0], 'position',[250 70 60 25], 'string', num2str(Time(i)),...
     'Callback', 'Time = str2num(get(GUI.Fsample, ''String''))');
Start_R  = uicontrol('Style', 'pushbutton', 'String', '<< Speed down', 'Position', [130 40 120 25],...
'Callback', 'POS=POS+0.05');
Start_A  = uicontrol('Style', 'pushbutton', 'String', 'Speed up >>', 'Position', [250 40 120 25],...
'Callback','POS=POS-0.05');
  pause() % Timepause(POS)
end
end
if (CCC==4)
  subplot(10,2,[ 3 5 7 9 11 13 15 17])
GUI.p_sign1 = imshow(I)
llkk=1;
    for iii=1:MM
        tess=exist(['Electrod' num2str(iii) '.mat']);
        if(tess==2)
        Tableau(llkk)=iii
        llkk=llkk+1;
        end
    end
 for jjj=1:length(Tableau) 
            load (['Electrod' num2str(Tableau(jjj)) '.mat']')
            for iii=1:length(posdebhfo)
            Vectd(jjj,iii)=posdebhfo(iii);
            Vectf(jjj,iii)=posfinhfo(iii);
            TABDUR(jjj,iii)=frequencyyy(iii);
            end
 end
 llmm=1;
 mmll=1;
 [s position]= sort(Vectd(:));
 [i j]=ind2sub(size(Vectd),position);
 for iii=1:length(i)
         if((Vectf(i(iii),j(iii)))~=0)
         TABF(mmll)=Vectf(i(iii),j(iii));
         TABM(mmll)=TABDUR(i(iii),j(iii));
         mmll=mmll+1;
         end
     end

 for ii=1:length(s(:,1))
        if(s(ii,1)~=0)
           TABD(llmm)=s(ii,1);
           INDEXX(llmm)=i(ii);
           llmm=llmm+1;
       end
 end
 %%
  %%
 indexxx=1;
 cx=[];
 cy=[];
 for jjj=1:length(Tableau)        
aa=eval(['cursor_info',num2str(Tableau(jjj)),'.','Position'])   
cx(indexxx)=aa(1);
cy(indexxx)=aa(2);
indexxx=indexxx+1;
 end
 
 for jjj=1:length(TABD)
     duration(jjj)=TABM(jjj);
 end
 
ran=range(duration);
min_val=min(duration); % min(x);%finding maximum value of data
max_val= max(duration);        % max(x)%finding minimum value of data
y= floor(((duration-min_val)/ran)*63)+1;               %  
p=colormap('jet');
caxis([min_val max_val])
POS=1;
vectsort=sort(INDEXX)
INDEXXX1(1)=Tableau(1)
INDEXXX2(1)=vectsort(1)
lkj=1
for kl=1:length(INDEXX)-1
    if(vectsort(kl+1)~=vectsort(kl))
        lkj=lkj+1;
        INDEXXX1(lkj)=Tableau(lkj);
        INDEXXX2(lkj)=vectsort(kl+1)
    end
end
INDEXXX=[];
for mmk=1:length(INDEXX)
    cvc=INDEXX(mmk);
    for gfk=1:length(INDEXXX2)
        if (cvc==INDEXXX2(gfk))
    INDEXXX(mmk)=INDEXXX1(gfk);
        end
    end
end
for i=1:length(duration)
    Time(i)= (TABD(i)/Fsample)*1000;
a=y(i);
col=p(a,:);
mm=cx(INDEXX(i));
nn=cy(INDEXX(i));
pp= circles(mm,nn,R,'facecolor',[col])
text(mm-R-5, nn-R-5,['E' num2str(INDEXXX(i))]);
colorbar

GUI_timing= uicontrol(gcf,'style','text', 'position',[130 70 110 25], 'string', 'Time (mseconds)', 'BackgroundColor',[1 1 0]); % Sampling Frequency Button.
GUI.Time = uicontrol('style','edit','BackgroundColor',[1 1 0], 'position',[250 70 60 25], 'string', num2str(Time(i)),...
     'Callback', 'Time = str2num(get(GUI.Fsample, ''String''))');
Start_R  = uicontrol('Style', 'pushbutton', 'String', '<< Speed down', 'Position', [130 40 120 25],...
'Callback', 'POS=POS+0.05');
Start_A  = uicontrol('Style', 'pushbutton', 'String', 'Speed up >>', 'Position', [250 40 120 25],...
'Callback','POS=POS-0.05');
  pause(POS) % Time  pause(POS)
end
end
durationn=duration;
%%
les_enfants = get(GUI_RESS,'children');
        for xi_enfant = 1 : length(les_enfants)
            try
                set(les_enfants(xi_enfant),'Units','normalized');
            end;
        end