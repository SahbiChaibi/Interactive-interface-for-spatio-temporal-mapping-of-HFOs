try
    choix = choix_force;
    clear choix_force
catch
    choix = gco;
end

switch choix
    case Start_firrms;  
   wwww;
    case GUI.ajuste_t_sign
         
        if get(GUI.ajuste_t_sign, 'Value')+round(fenetre_affich*Fsample) < size(x,2)
           set(GUI.p_sign, 'YData', x(get(GUI.ajuste_t_sign, 'Value'):get(GUI.ajuste_t_sign, 'Value')+round(fenetre_affich*Fsample)))
           set(get(GUI.p_sign, 'Parent'), 'xLim', [1 round(fenetre_affich*Fsample)])
          if(CC~=0)
           set(GUI.p_signn, 'YData', xx(get(GUI.ajuste_t_sign, 'Value'):get(GUI.ajuste_t_sign, 'Value')+round(fenetre_affich*Fsample)))
           set(get(GUI.p_signn, 'Parent'), 'xLim', [1 round(fenetre_affich*Fsample)])
          end
        end
if(CC==1)
    
           set(GUI.p_sign_filt, 'YData', y(get(GUI.ajuste_t_sign, 'Value'):get(GUI.ajuste_t_sign, 'Value')+(fenetre_affich*Fsample)));
           set(get(GUI.p_sign_filt, 'Parent'), 'xLim', [1 round(fenetre_affich*Fsample)])

            try
           set(GUI.p_signdetection, 'CData', matt(1,get(GUI.ajuste_t_sign, 'Value'):get(GUI.ajuste_t_sign, 'Value')+(fenetre_affich*Fsample)));
           set(get(GUI.p_signdetection,'Parent'), 'xLim', [1 round(fenetre_affich*Fsample)])
            end  
end

if(CC==2)
    try
           set(GUI.p_sign_filt,'CData', dBS(:,get(GUI.ajuste_t_sign, 'Value'):get(GUI.ajuste_t_sign, 'Value')+(fenetre_affich*Fsample)));
           set(get(GUI.p_sign_filt, 'Parent'), 'xLim', [1 round(fenetre_affich*Fsample)])

    end
            try
                set(GUI.p_signdetection,'CData', matt(1,get(GUI.ajuste_t_sign, 'Value'):get(GUI.ajuste_t_sign, 'Value')+(fenetre_affich*Fsample)));
                set(get(GUI.p_signdetection, 'Parent'), 'xLim', [1 round(fenetre_affich*Fsample)])
            end
end
if(CC==3)
    
    try
           set(GUI.p_sign_filt,'CData', mapp((300:2000),get(GUI.ajuste_t_sign, 'Value'):get(GUI.ajuste_t_sign, 'Value')+(fenetre_affich*Fsample)));
           set(get(GUI.p_sign_filt, 'Parent'), 'xLim', [1 round(fenetre_affich*Fsample)])

    end
    
            try
                set(GUI.p_signdetection, 'CData', matt(1,get(GUI.ajuste_t_sign, 'Value'):get(GUI.ajuste_t_sign, 'Value')+(fenetre_affich*Fsample)));
                set(get(GUI.p_signdetection, 'Parent'), 'xLim', [1 round(fenetre_affich*Fsample)])
            end
end

if(CC==4)
    try
           set(GUI.p_sign_filt,'CData', dBSS(:,get(GUI.ajuste_t_sign, 'Value'):get(GUI.ajuste_t_sign, 'Value')+(fenetre_affich*Fsample)));
           set(get(GUI.p_sign_filt, 'Parent'), 'xLim', [1 round(fenetre_affich*Fsample)])

    end
            try
                set(GUI.p_signdetection,'CData', matt(1,get(GUI.ajuste_t_sign, 'Value'):get(GUI.ajuste_t_sign, 'Value')+(fenetre_affich*Fsample)));
                set(get(GUI.p_signdetection, 'Parent'), 'xLim', [1 round(fenetre_affich*Fsample)])
            end
end
if(CC==5)
    
         try
           set(GUI.p_sign_filt,'CData', SSS(:,get(GUI.ajuste_t_sign, 'Value'):get(GUI.ajuste_t_sign, 'Value')+(fenetre_affich*Fsample)));
           set(get(GUI.p_sign_filt, 'Parent'), 'xLim', [1 round(fenetre_affich*Fsample)])
         end

            try
           set(GUI.p_signdetection, 'CData', matt(1,get(GUI.ajuste_t_sign, 'Value'):get(GUI.ajuste_t_sign, 'Value')+(fenetre_affich*Fsample)));
           set(get(GUI.p_signdetection,'Parent'), 'xLim', [1 round(fenetre_affich*Fsample)])
            end
          
end
if(CC==6)
           set(GUI.p_sign_filt, 'YData', y(get(GUI.ajuste_t_sign, 'Value'):get(GUI.ajuste_t_sign, 'Value')+(fenetre_affich*Fsample)));
           set(get(GUI.p_sign_filt, 'Parent'), 'xLim', [1 round(fenetre_affich*Fsample)])

            try
           set(GUI.p_signdetection, 'CData', matt(1,get(GUI.ajuste_t_sign, 'Value'):get(GUI.ajuste_t_sign, 'Value')+(fenetre_affich*Fsample)));
           set(get(GUI.p_signdetection,'Parent'), 'xLim', [1 round(fenetre_affich*Fsample)])
            end

        end
        
    case GUI.ajuste_a_echelle
        
        set(get(GUI.p_sign,'Parent'), 'Ylim', [born_sign(1) born_sign(2)]/get(GUI.ajuste_a_echelle, 'Value'))
    case GUI.fenetre
        
        set(get(GUI.p_sign, 'Parent'), 'YData', [get(GUI.ajuste_t_sign, 'Value') get(GUI.ajuste_t_sign, 'Value')+(fenetre_affich*Fsample)]);
      set(get(GUI.p_sign_filt, 'Parent'), 'YData', [get(GUI.ajuste_t_sign, 'Value') get(GUI.ajuste_t_sign, 'Value')+(fenetre_affich*Fsample)]);
    set(get(GUI.p_signdetection, 'Parent'), 'YData', [get(GUI.ajuste_t_sign, 'Value') get(GUI.ajuste_t_sign, 'Value')+(fenetre_affich*Fsample)]);
 
   
    case Start_result

if(MMNN==0)
        mm=420;
        TABDEL = [];
        GUI.show= [];
        GUI.del = [];
        ddd=length(posdebhfo)
        nombre=fix(ddd/17);
        if(ddd<18)
            qqq;
            oooo;
            GUI_suiv = uicontrol('Style', 'pushbutton' , 'String','Repeat', 'Value', 1, 'Position', [10 10 70 25],'BackgroundColor',[1 0 0 ],...
            'Callback','delete(GUI_RES)');
        GUI.execute= uicontrol(gcf,'style','pushbutton', 'position',[840 10 100 25], 'string', 'Execute ', 'BackgroundColor',[1 0 0 ],.....
            'Callback','delete(GUI_RES), [posdebhfo, posfinhfo,matt,xx,Occuranee,powerrr,DurationHFOO,frequencyyy] = conversion(TABDEL, posdebhfo, posfinhfo,zz,electrode,x,xx,Occurane,powerr,DurationHFO,frequencyy),enreg');
        end
        nnn=0;
         zz=length(x);
        
        if(ddd>17)
           for ijj=1:nombre+1 
               mmm=420;
            qqq;
            ooo;
            GUI_suiv = uicontrol('Style', 'pushbutton' , 'String','Repeat', 'Value', 1, 'Position', [10 40 70 35],'BackgroundColor',[1 0 0 ],...
            'Callback','delete(GUI_RES)');
        if(ijj<nombre+1)
            pause
            delete(GUI_RES)
        else
            GUI.execute= uicontrol(gcf,'style','pushbutton', 'position',[440 30 80 35], 'string', 'Execute ', 'BackgroundColor',[1 0 0 ],.....
            'Callback','delete(GUI_RES), [posdebhfo, posfinhfo,matt,xx,Occuranee,powerrr,DurationHFOO,frequencyyy] = conversion(TABDEL, posdebhfo, posfinhfo,zz,electrode,x,xx,Occurane,powerr,DurationHFO,frequencyy),enreg');
        end
           end
         end
end
        if(MMNN==1)
       mm=420;
        TABDEL1 =[];
        GUI.show= [];
        GUI.del = [];
        ddd=length(posdebhfo)
        nombre=fix(ddd/17);
        CLASSS=zeros(1,ddd);
        if(ddd<18)
            qqqq;
            yyyy;
        end
            
     nnn=0;
         zz=length(x); 
        if(ddd>17)
           for ijj=1:nombre+1
               mm=420;
            qqqq;
            yyy;
            
    if(ijj<nombre+1)
            pause
            delete(GUI_RES)
        else
           GUI_suiv = uicontrol('Style', 'pushbutton' , 'String','Exit', 'Value', 1, 'Position', [10 40 70 35],'BackgroundColor',[1 0 0 ],...
            'Callback','delete(GUI_RES)');
        end         
            
            
           end
        end
        end      
        
    case 1028
        
        if(CC==1)
            
  if (coupos~=0)
  delete(xyx);
  delete(yxy);
  refresh;
  end
        if posdebhfo(str2num(get(gco, 'String')))<round((fenetre_affich*Fsample)/2)
            quel_sample_show = posdebhfo(str2num(get(gco, 'String')));
            quel_sample_show1 = posfinhfo(str2num(get(gco, 'String')));
      difff=quel_sample_show1-quel_sample_show;
       figure(1);
            vcv=max(y);
           figure(1); 
        subplot(11,20,[103:120 123:140 143:160 163:180])
        hold on
xyx=line([1 1], [-vcv vcv],'LineWidth',2,'Color',[0 0 1]);
que=1+difff;
 figure(1);
        subplot(11,20,[103:120 123:140 143:160 163:180])
        hold on
yxy=line([que que], [-vcv vcv],'LineWidth',2,'Color',[0 0 1]);
        elseif posdebhfo(str2num(get(gco, 'String')))>length(x)-round((fenetre_affich*Fsample)/2)
            quel_sample_show = posfinhfo(str2num(get(gco, 'String')))-fenetre_affich*Fsample;
             quel_sample_show1 = posdebhfo(str2num(get(gco, 'String')))-fenetre_affich*Fsample;
      difff= abs(quel_sample_show1-quel_sample_show);
       figure(1);
            vcv=max(y);
           figure(1); 
        subplot(11,20,[103:120 123:140 143:160 163:180])
        hold on
xyx=line([(fenetre_affich*Fsample-difff) (fenetre_affich*Fsample-difff)], [-vcv vcv],'LineWidth',2,'Color',[0 0 1]);
que=fenetre_affich*Fsample;
 figure(1);
        subplot(11,20,[103:120 123:140 143:160 163:180])
        hold on
yxy=line([que que], [-vcv vcv],'LineWidth',2,'Color',[0 0 1]);

        else
            quel_sample_show = posdebhfo(str2num(get(gco, 'String')))-round((fenetre_affich*Fsample)/2);
            quel_sample_show1 = posfinhfo(str2num(get(gco, 'String')))-round((fenetre_affich*Fsample)/2);
            difff=quel_sample_show1-quel_sample_show;
            figure(1);
            vcv=max(y);
            figure(1); 
        subplot(11,20,[103:120 123:140 143:160 163:180])
        hold on
xyx=line([round((fenetre_affich*Fsample)/2) round((fenetre_affich*Fsample)/2)], [-vcv vcv],'LineWidth',2,'Color',[0 0 1]);
que=round((fenetre_affich*Fsample)/2)+difff;
 figure(1);
        subplot(11,20,[103:120 123:140 143:160 163:180])
        hold on
yxy=line([que que], [-vcv vcv],'LineWidth',2,'Color',[0 0 1]);
        end
        set(GUI.ajuste_t_sign, 'Value', quel_sample_show);
        choix_force = GUI.ajuste_t_sign;
        Plot_main; 
        coupos=1;
        end

%%
if (CC==2)
if (coupos~=0)
delete(xyx);
delete(yxy);
refresh;
end
        if posdebhfo(str2num(get(gco, 'String')))<round((fenetre_affich*Fsample)/2)
            quel_sample_show = posdebhfo(str2num(get(gco, 'String')));
            quel_sample_show1= posfinhfo(str2num(get(gco, 'String')));
            difff=quel_sample_show1-quel_sample_show;
            figure(1);
            subplot(11,20,[103:120 123:140 143:160 163:180])
            hold on;
            xyx=line([1 1], [1 500],'LineWidth',2,'Color',[0 0.9 1]);
            que=1+difff;
            figure(1);
            subplot(11,20,[103:120 123:140 143:160 163:180])
            hold on;
            yxy=line([que que], [1 500],'LineWidth',2,'Color',[0 0.9 1]);
            
            elseif posdebhfo(str2num(get(gco, 'String')))>length(x)-round((fenetre_affich*Fsample)/2)
            quel_sample_show = posfinhfo(str2num(get(gco, 'String')))-fenetre_affich*Fsample;
            quel_sample_show1 = posdebhfo(str2num(get(gco, 'String')))-fenetre_affich*Fsample;
            difff= abs(quel_sample_show1-quel_sample_show);
            figure(1); 
            subplot(11,20,[103:120 123:140 143:160 163:180])
            hold on
            xyx=line([(fenetre_affich*Fsample-difff) (fenetre_affich*Fsample-difff)],[1 500],'LineWidth',2,'Color',[0 0.9 1]);
            que=fenetre_affich*Fsample;
            figure(1);
            subplot(11,20,[103:120 123:140 143:160 163:180])
            hold on
            yxy=line([que que], [1 500],'LineWidth',4,'Color',[0 0.9 1]);
            
        else
            quel_sample_show= posdebhfo(str2num(get(gco,'String')))-round((fenetre_affich*Fsample)/2);
            quel_sample_show1= posfinhfo(str2num(get(gco,'String')))-round((fenetre_affich*Fsample)/2);
            difff= quel_sample_show1-quel_sample_show;
            figure(1); 
        subplot(11,20,[103:120 123:140 143:160 163:180]);
        hold on;
xyx=line([round((fenetre_affich*Fsample)/2) round((fenetre_affich*Fsample)/2)], [1 500],'LineWidth',2,'Color',[0 0.9 1]);
que=round((fenetre_affich*Fsample)/2)+difff;
 figure(1);
        subplot(11,20,[103:120 123:140 143:160 163:180]);
        hold on;
yxy=line([que que], [1 500],'LineWidth',2,'Color',[0 0.9 1]);

        end
        set(GUI.ajuste_t_sign, 'Value', quel_sample_show);
        choix_force= GUI.ajuste_t_sign;
        Plot_main; 
        coupos=1;
end;
%%
if(CC==3)
            
  if (coupos~=0)
delete(xyx);
delete(yxy);
refresh;
end
        if posdebhfo(str2num(get(gco, 'String')))<round((fenetre_affich*Fsample)/2)
            quel_sample_show = posdebhfo(str2num(get(gco, 'String')));
            quel_sample_show1= posfinhfo(str2num(get(gco, 'String')));
            difff=quel_sample_show1-quel_sample_show;
            figure(1);
            subplot(11,20,[103:120 123:140 143:160 163:180])
            hold on;
            xyx=line([1 1], [1 500],'LineWidth',2,'Color',[0 0.9 1]);
            que=1+difff;
            figure(1);
            subplot(11,20,[103:120 123:140 143:160 163:180])
            hold on;
            yxy=line([que que], [1 500],'LineWidth',2,'Color',[0 0.9 1]);
           
            elseif posdebhfo(str2num(get(gco, 'String')))>length(x)-round((fenetre_affich*Fsample)/2)
            quel_sample_show = posfinhfo(str2num(get(gco, 'String')))-fenetre_affich*Fsample;
            quel_sample_show1 = posdebhfo(str2num(get(gco, 'String')))-fenetre_affich*Fsample;
            difff= abs(quel_sample_show1-quel_sample_show);
            figure(1); 
            subplot(11,20,[103:120 123:140 143:160 163:180])
            hold on
            xyx=line([(fenetre_affich*Fsample-difff) (fenetre_affich*Fsample-difff)],[1 500],'LineWidth',2,'Color',[0 0.9 1]);
            que=fenetre_affich*Fsample;
            figure(1);
            subplot(11,20,[103:120 123:140 143:160 163:180])
            hold on
            yxy=line([que que], [1 500],'LineWidth',4,'Color',[0 0.9 1]);
           
        else
            quel_sample_show= posdebhfo(str2num(get(gco,'String')))-round((fenetre_affich*Fsample)/2);
            quel_sample_show1= posfinhfo(str2num(get(gco,'String')))-round((fenetre_affich*Fsample)/2);
            difff= quel_sample_show1-quel_sample_show;
            figure(1); 
        subplot(11,20,[103:120 123:140 143:160 163:180]);
        hold on;
xyx=line([round((fenetre_affich*Fsample)/2) round((fenetre_affich*Fsample)/2)], [1 500],'LineWidth',2,'Color',[0 0.9 1]);
que=round((fenetre_affich*Fsample)/2)+difff;
 figure(1);
        subplot(11,20,[103:120 123:140 143:160 163:180]);
        hold on;
yxy=line([que que], [1 500],'LineWidth',2,'Color',[0 0.9 1]);

        end
        set(GUI.ajuste_t_sign, 'Value', quel_sample_show);
        choix_force= GUI.ajuste_t_sign;
        Plot_main; 
        coupos=1;
end;
%%
if (CC==4)
if (coupos~=0)
delete(xyx);
delete(yxy);
refresh;
end
        if posdebhfo(str2num(get(gco, 'String')))<round((fenetre_affich*Fsample)/2)
            quel_sample_show = posdebhfo(str2num(get(gco, 'String')));
            quel_sample_show1= posfinhfo(str2num(get(gco, 'String')));
            difff=quel_sample_show1-quel_sample_show;
            figure(1);
            subplot(11,20,[103:120 123:140 143:160 163:180])
            hold on;
            xyx=line([1 1], [1 500],'LineWidth',2,'Color',[0 0.9 1]);
            que=1+difff;
            figure(1);
            subplot(11,20,[103:120 123:140 143:160 163:180])
            hold on;
            yxy=line([que que], [1 500],'LineWidth',2,'Color',[0 0.9 1]);
            
            elseif posdebhfo(str2num(get(gco, 'String')))>length(x)-round((fenetre_affich*Fsample)/2)
            quel_sample_show = posfinhfo(str2num(get(gco, 'String')))-fenetre_affich*Fsample;
            quel_sample_show1 = posdebhfo(str2num(get(gco, 'String')))-fenetre_affich*Fsample;
            difff= abs(quel_sample_show1-quel_sample_show);
            figure(1); 
            subplot(11,20,[103:120 123:140 143:160 163:180])
            hold on
            xyx=line([(fenetre_affich*Fsample-difff) (fenetre_affich*Fsample-difff)],[1 500],'LineWidth',2,'Color',[0 0.9 1]);
            que=fenetre_affich*Fsample;
            figure(1);
            subplot(11,20,[103:120 123:140 143:160 163:180])
            hold on
            yxy=line([que que], [1 500],'LineWidth',4,'Color',[0 0.9 1]);
           
        else
            quel_sample_show= posdebhfo(str2num(get(gco,'String')))-round((fenetre_affich*Fsample)/2);
            quel_sample_show1= posfinhfo(str2num(get(gco,'String')))-round((fenetre_affich*Fsample)/2);
            difff= quel_sample_show1-quel_sample_show;
            figure(1); 
        subplot(11,20,[103:120 123:140 143:160 163:180]);
        hold on;
xyx=line([round((fenetre_affich*Fsample)/2) round((fenetre_affich*Fsample)/2)], [1 500],'LineWidth',2,'Color',[0 0.9 1]);
que=round((fenetre_affich*Fsample)/2)+difff;
 figure(1);
        subplot(11,20,[103:120 123:140 143:160 163:180]);
        hold on;
yxy=line([que que], [1 500],'LineWidth',2,'Color',[0 0.9 1]);

        end
        set(GUI.ajuste_t_sign, 'Value', quel_sample_show);
        choix_force= GUI.ajuste_t_sign;
        Plot_main; 
        coupos=1;
end;
%%
if(CC==5)
if (coupos~=0)
delete(xyx);
delete(yxy);
refresh;
end
        if posdebhfo(str2num(get(gco, 'String')))<round((fenetre_affich*Fsample)/2)
            quel_sample_show = posdebhfo(str2num(get(gco, 'String')));
            quel_sample_show1= posfinhfo(str2num(get(gco, 'String')));
            difff=quel_sample_show1-quel_sample_show;
            figure(1);
            subplot(11,20,[103:120 123:140 143:160 163:180])
            hold on;
            xyx=line([1 1], [1 500],'LineWidth',2,'Color',[0 0.9 1]);
            que=1+difff;
            figure(1);
            subplot(11,20,[103:120 123:140 143:160 163:180])
            hold on;
            yxy=line([que que], [1 500],'LineWidth',2,'Color',[0 0.9 1]);
           
            elseif posdebhfo(str2num(get(gco, 'String')))>length(x)-round((fenetre_affich*Fsample)/2)
            quel_sample_show = posfinhfo(str2num(get(gco, 'String')))-fenetre_affich*Fsample;
            quel_sample_show1 = posdebhfo(str2num(get(gco, 'String')))-fenetre_affich*Fsample;
            difff= abs(quel_sample_show1-quel_sample_show);
            figure(1); 
            subplot(11,20,[103:120 123:140 143:160 163:180])
            hold on
            xyx=line([(fenetre_affich*Fsample-difff) (fenetre_affich*Fsample-difff)],[1 500],'LineWidth',2,'Color',[0 0.9 1]);
            que=fenetre_affich*Fsample;
            figure(1);
            subplot(11,20,[103:120 123:140 143:160 163:180])
            hold on
            yxy=line([que que], [1 500],'LineWidth',4,'Color',[0 0.9 1]);
            
        else
            quel_sample_show= posdebhfo(str2num(get(gco,'String')))-round((fenetre_affich*Fsample)/2);
            quel_sample_show1= posfinhfo(str2num(get(gco,'String')))-round((fenetre_affich*Fsample)/2);
            difff= quel_sample_show1-quel_sample_show;
            figure(1); 
        subplot(11,20,[103:120 123:140 143:160 163:180]);
        hold on;
xyx=line([round((fenetre_affich*Fsample)/2) round((fenetre_affich*Fsample)/2)], [1 500],'LineWidth',2,'Color',[0 0.9 1]);
que=round((fenetre_affich*Fsample)/2)+difff;
 figure(1);
        subplot(11,20,[103:120 123:140 143:160 163:180]);
        hold on;
yxy=line([que que], [1 500],'LineWidth',2,'Color',[0 0.9 1]);
        end
        set(GUI.ajuste_t_sign, 'Value', quel_sample_show);
        choix_force= GUI.ajuste_t_sign;
        Plot_main; 
        coupos=1;
end;
 %%
  if(CC==6)
            
  if (coupos~=0)
  delete(xyx);
delete(yxy);
refresh;
  end
        if posdebhfo(str2num(get(gco, 'String')))<round((fenetre_affich*Fsample)/2)
            quel_sample_show = posdebhfo(str2num(get(gco, 'String')));
            quel_sample_show1 = posfinhfo(str2num(get(gco, 'String')));
      difff=quel_sample_show1-quel_sample_show;
       figure(1);
            vcv=max(y);
           figure(1); 
        subplot(11,20,[103:120 123:140 143:160 163:180])
        hold on
xyx=line([1 1], [-vcv vcv],'LineWidth',2,'Color',[0 0 1]);
que=1+difff;
 figure(1);
        subplot(11,20,[103:120 123:140 143:160 163:180])
        hold on
yxy=line([que que], [-vcv vcv],'LineWidth',2,'Color',[0 0 1]);
        elseif posdebhfo(str2num(get(gco, 'String')))>length(x)-round((fenetre_affich*Fsample)/2)
            quel_sample_show = posfinhfo(str2num(get(gco, 'String')))-fenetre_affich*Fsample;
             quel_sample_show1 = posdebhfo(str2num(get(gco, 'String')))-fenetre_affich*Fsample;
      difff= abs(quel_sample_show1-quel_sample_show);
       figure(1);
            vcv=max(y);
           figure(1); 
        subplot(11,20,[103:120 123:140 143:160 163:180])
        hold on
xyx=line([(fenetre_affich*Fsample-difff) (fenetre_affich*Fsample-difff)], [-vcv vcv],'LineWidth',2,'Color',[0 0 1]);
que=fenetre_affich*Fsample;
 figure(1);
        subplot(11,20,[103:120 123:140 143:160 163:180])
        hold on
yxy=line([que que], [-vcv vcv],'LineWidth',2,'Color',[0 0 1]);
        else
            quel_sample_show = posdebhfo(str2num(get(gco, 'String')))-round((fenetre_affich*Fsample)/2);
            quel_sample_show1 = posfinhfo(str2num(get(gco, 'String')))-round((fenetre_affich*Fsample)/2);
            difff=quel_sample_show1-quel_sample_show;
            figure(1);
            vcv=max(y);
            figure(1); 
        subplot(11,20,[103:120 123:140 143:160 163:180])
        hold on
xyx=line([round((fenetre_affich*Fsample)/2) round((fenetre_affich*Fsample)/2)], [-vcv vcv],'LineWidth',2,'Color',[0 0 1]);
que=round((fenetre_affich*Fsample)/2)+difff;
 figure(1);
        subplot(11,20,[103:120 123:140 143:160 163:180])
        hold on
yxy=line([que que], [-vcv vcv],'LineWidth',2,'Color',[0 0 1]);
        end
        set(GUI.ajuste_t_sign, 'Value', quel_sample_show);
        choix_force = GUI.ajuste_t_sign;
        Plot_main; 
        coupos=1;
  end
    case mapps
        codemapping;
    case Start_STBM
        codd1;
    case Start_M
        codd2;
    
end
%%
clear choix
for xi_enfant = 1:length(les_enfants)
    try
        set(les_enfants(xi_enfant),'Units','normalized');
    end;
end;