for jjjj=1:1:ddd
    TABDEL(jjjj)=jjjj;
      if((CC==1)||(CC==6))
            uicontrol(gcf,'style','text', 'position',[170 mm 125  15], 'string', num2str(Occuranee(jjjj)), 'BackgroundColor',[0 1 0 ])
            uicontrol(gcf,'style','text', 'position',[320 mm 125 15], 'string', num2str(DurationHFOO(jjjj)), 'BackgroundColor',[0 1 0 ])
            uicontrol(gcf,'style','text', 'position',[470 mm 125 15], 'string', num2str(powerrr(jjjj)), 'BackgroundColor',[0 1 0 ])
             uicontrol(gcf,'style','text', 'position',[620 mm 125 15], 'string', num2str(occurate), 'BackgroundColor',[0 1 0 ])
            
            GUI.show(jjjj)= uicontrol('Style', 'pushbutton', 'String', num2str(jjjj), 'Position', [20 mm 125 15],'BackgroundColor',[0 1 1 ],...
                'Callback','choix_force = 1028, Plot_main');
             GUI.del(jjjj) = uicontrol('Style', 'radio', 'String',num2str(jjjj), 'Value', 1, 'Position', [770 mm 125 15],'BackgroundColor',[0 1 1],...
                'Callback','TABDEL(str2num(get(gco, ''String''))) = 0,');
            mm = mm-20;
      end
      if( (CC==2)|| (CC==3) || (CC==4)|| (CC==5))
           uicontrol(gcf,'style','text', 'position',[150 mm 100  15], 'string', num2str(Occuranee(jjjj)), 'BackgroundColor',[0 1 0 ])
            uicontrol(gcf,'style','text', 'position',[280 mm 100 15], 'string', num2str(DurationHFOO(jjjj)), 'BackgroundColor',[0 1 0 ])
            uicontrol(gcf,'style','text', 'position',[410 mm 100 15], 'string', num2str(frequencyyy(jjjj)), 'BackgroundColor',[0 1 0 ])
             uicontrol(gcf,'style','text', 'position',[540 mm 100 15], 'string', num2str(powerrr(jjjj)), 'BackgroundColor',[0 1 0 ])
             uicontrol(gcf,'style','text', 'position',[670 mm 100 15], 'string', num2str(occurate), 'BackgroundColor',[0 1 0 ])
            GUI.show(jjjj)= uicontrol('Style', 'pushbutton', 'String', num2str(jjjj), 'Position', [20 mm 100 15],'BackgroundColor',[0 1 1 ],...
                'Callback','choix_force=1028, Plot_main');
             GUI.del(jjjj) = uicontrol('Style', 'radio', 'String',num2str(jjjj), 'Value', 1, 'Position', [800 mm 100 15],'BackgroundColor',[0 1 1],...
                'Callback','TABDEL(str2num(get(gco, ''String''))) = 0,');
            mm = mm-20;
      end
end
      
        
