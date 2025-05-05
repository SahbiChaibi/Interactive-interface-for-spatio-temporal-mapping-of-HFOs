for jjjj=1+nnn:1:17+nnn
           if(jjjj<ddd+1)
            TABDEL(jjjj)=jjjj;
             if((CC==1)||(CC==6))
                    GUI.show(jjjj)= uicontrol('Style', 'pushbutton', 'String', num2str(jjjj), 'Position', [20 mm 125 15],'BackgroundColor',[0 1 1 ],...
                'Callback','choix_force = 1028, Plot_main');
            uicontrol(gcf,'style','text', 'position',[170 mm 125  15], 'string', num2str(Occurane(jjjj)), 'BackgroundColor',[0 1 0 ])
            uicontrol(gcf,'style','text', 'position',[320 mm 125 15], 'string', num2str(DurationHFO(jjjj)), 'BackgroundColor',[0 1 0 ])
            uicontrol(gcf,'style','text', 'position',[470 mm 125 15], 'string', num2str(powerr(jjjj)), 'BackgroundColor',[0 1 0 ])
             GUI.del(jjjj) = uicontrol('Style', 'radio', 'String',num2str(jjjj), 'Value', 1, 'Position', [620 mm 125 15],'BackgroundColor',[0 1 1],...
                'Callback','TABDEL(str2num(get(gco, ''String''))) = 0,');
            mm = mm-20;
      end
      if( (CC==2)|| (CC==3) || (CC==4)|| (CC==5))
          GUI.show(jjjj)= uicontrol('Style', 'pushbutton', 'String', num2str(jjjj), 'Position', [20 mm 125 15],'BackgroundColor',[0 1 1 ],...
                'Callback','choix_force = 1028, Plot_main');
           uicontrol(gcf,'style','text', 'position',[170 mm 125  15], 'string', num2str(Occurane(jjjj)), 'BackgroundColor',[0 1 0 ])
            uicontrol(gcf,'style','text', 'position',[320 mm 125 15], 'string', num2str(DurationHFO(jjjj)), 'BackgroundColor',[0 1 0 ])
            uicontrol(gcf,'style','text', 'position',[470 mm 125 15], 'string', num2str(frequencyy(jjjj)), 'BackgroundColor',[0 1 0 ])
             uicontrol(gcf,'style','text', 'position',[620 mm 125 15], 'string', num2str(powerr(jjjj)), 'BackgroundColor',[0 1 0 ])
            
             GUI.del(jjjj) = uicontrol('Style', 'radio', 'String',num2str(jjjj), 'Value', 1, 'Position', [770 mm 125 15],'BackgroundColor',[0 1 1],...
                'Callback','TABDEL(str2num(get(gco, ''String''))) = 0,');
            mm = mm-20;
      end
           end
end
        nnn=nnn+17;
        mm=420;