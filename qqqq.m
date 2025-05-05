GUI_RES= figure('units','pixels',...
            'position',[250  200 950  500],...
            'color',[0.925 0.913 0.687]);
        
         uicontrol(gcf,'style','text', 'position',[170 450 125 25], 'string', 'Onset(sample)', 'BackgroundColor',[1 1 0 ])
        uicontrol(gcf,'style','text', 'position',[320 450 125 25], 'string', 'End(sample) ', 'BackgroundColor',[1 1 0 ])
        uicontrol(gcf,'style','text', 'position',[470 450 125 25], 'string', 'Duration(ms) ', 'BackgroundColor',[1 1 0 ])
        uicontrol(gcf,'style','text', 'position',[20 450 125 25], 'string', 'Event ', 'BackgroundColor',[1 1 0])
        if((CC==1)||(CC==6))
        uicontrol(gcf,'style','text', 'position',[620 450 125 25], 'string', 'FFT', 'BackgroundColor',[1 1 0 ])
        uicontrol(gcf,'style','text', 'position',[770 450 125 25], 'string', 'Classification', 'BackgroundColor',[1 1 0 ])
        end
        if((CC==2) || (CC==3)||(CC==4)||(CC==5))
        
        uicontrol(gcf,'style','text', 'position',[620 450 125 25], 'string', 'Classification', 'BackgroundColor',[1 1 0 ])
        end