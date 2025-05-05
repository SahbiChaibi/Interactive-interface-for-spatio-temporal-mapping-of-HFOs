GUI_RES= figure('units','pixels',...
            'position',[250  150 950  500],...
            'color',[0.925 0.913 0.687]);
        if((CC==1)||(CC==6))
        uicontrol(gcf,'style','text', 'position',[20 450 125 40], 'string', 'Show', 'BackgroundColor',[1 1 0])
        uicontrol(gcf,'style','text', 'position',[170 450 125 40], 'string', 'Inter-duration (ms)', 'BackgroundColor',[1 1 0 ])
        uicontrol(gcf,'style','text', 'position',[320 450 125 40], 'string', 'Duration(ms)', 'BackgroundColor',[1 1 0 ])
        uicontrol(gcf,'style','text', 'position',[470 450 125 40], 'string', 'Power(µw)', 'BackgroundColor',[1 1 0 ])
        uicontrol(gcf,'style','text', 'position',[620 450 125 40], 'string', ' Occurence Rate(Events/s)', 'BackgroundColor',[1 1 0 ])
        uicontrol(gcf,'style','text', 'position',[770 450 125 40], 'string', 'delete ', 'BackgroundColor',[1 1 0 ])
        end
        
        if( (CC==2)|| (CC==3) || (CC==4)|| (CC==5))
        uicontrol(gcf,'style','text', 'position',[20 450 100 40], 'string', 'Show', 'BackgroundColor',[1 1 0])
        uicontrol(gcf,'style','text', 'position',[150 450 100 40], 'string', 'Inter duartion (ms)', 'BackgroundColor',[1 1 0 ])
        uicontrol(gcf,'style','text', 'position',[280 450 100 40], 'string', 'Duration(ms)', 'BackgroundColor',[1 1 0 ])
        uicontrol(gcf,'style','text', 'position',[410 450 100 40], 'string', 'Frequency(Hz)', 'BackgroundColor',[1 1 0 ])
        uicontrol(gcf,'style','text', 'position',[540 450 100 40], 'string', 'Power(µW)', 'BackgroundColor',[1 1 0 ])
         uicontrol(gcf,'style','text', 'position',[670 450 100 40], 'string', 'Occurence Rate(Events/s) ', 'BackgroundColor',[1 1 0 ])
        uicontrol(gcf,'style','text', 'position',[800 450 100 40], 'string', 'delete ', 'BackgroundColor',[1 1 0 ])
        
        end