for jjj=1+nnn:1:17+nnn
           if(jjj<ddd+1)
            TABDEL1(jjj) = jjj;
            uicontrol(gcf,'style','text', 'position',[170 mm 125  15], 'string', num2str(posdebhfo(jjj)), 'BackgroundColor',[0 1 0 ])
            uicontrol(gcf,'style','text', 'position',[320 mm 125 15], 'string', num2str(posfinhfo(jjj)), 'BackgroundColor',[0 1 0 ])
            uicontrol(gcf,'style','text', 'position',[470 mm 125 15], 'string', num2str((posfinhfo(jjj)-posdebhfo(jjj))*0.5), 'BackgroundColor',[0 1 0 ])
            GUI.show(jjj)= uicontrol('Style', 'pushbutton', 'String', num2str(jjj), 'Position', [20 mm 125 15],'BackgroundColor',[0 1 1 ],...
                'Callback','choix_force = 1028, Plot_main');
            if((CC==1)|| (CC==6))
              GUI.plot(jjj) = uicontrol('Style', 'pushbutton' , 'String',num2str(jjj), 'Value', 1, 'Position', [620 mm 125 15],'BackgroundColor',[0 1 1],...
              'Callback','poos1=TABDEL1(str2num(get(gco,''String''))),Plot_main,KKK,rrr');
            end
            if(CC==2)
                uuu;
            uicontrol(gcf,'style','text', 'position',[620 mm 125  15], 'string', QQFF(jjj), 'BackgroundColor',[0 1 0 ]);
            end
            if(CC==3)
             uuu;
            uicontrol(gcf,'style','text', 'position',[620 mm 125  15], 'string', QQFF(jjj), 'BackgroundColor',[0 1 0 ]);
            end
            if(CC==4)
             uuu;
            uicontrol(gcf,'style','text', 'position',[620 mm 125  15], 'string', QQFF(jjj), 'BackgroundColor',[0 1 0 ]);
            end
            if(CC==5)
             uuu;
            uicontrol(gcf,'style','text', 'position',[620 mm 125  15], 'string', QQFF(jjj), 'BackgroundColor',[0 1 0 ]);
            end
           
            mm = mm-20;    
end
               
end
        nnn=nnn+17;