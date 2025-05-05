if(CC==1)
uicontrol(gcf,'style','text', 'position',[10 115 80 25], 'string', 'Cycles', 'BackgroundColor',[0.8 0.8 0.8]);
GUI.cycles=uicontrol('style','edit', 'BackgroundColor',[1 1 1], 'position',[10 95 80 25], 'string', num2str(cycles),...5 50 180 30
            'Callback', 'cycles= str2num(get(GUI.cycles, ''String''))');
   
   
uicontrol(gcf,'style','text', 'position',[100 115 80 25], 'string', 'Beta', 'BackgroundColor',[0.8 0.8 0.8]);
GUI.beta=uicontrol('style','edit', 'BackgroundColor',[1 1 1], 'position',[100 95 80 25], 'string', num2str(beta),...
            'Callback', 'beta= str2num(get(GUI.beta, ''String''))');
end
if(CC==2)
 uicontrol(gcf,'style','text', 'position',[10 115 80 25], 'string', 'Cycles', 'BackgroundColor',[0.8 0.8 0.8]);
GUI.cycles=uicontrol('style','edit', 'BackgroundColor',[1 1 1], 'position',[10 95 80 25], 'string', num2str(cycles),...
            'Callback', 'cycles= str2num(get(GUI.cycles, ''String''))');
   
   
uicontrol(gcf,'style','text', 'position',[100 115 80 25], 'string', 'Beta', 'BackgroundColor',[0.8 0.8 0.8]);
GUI.beta=uicontrol('style','edit', 'BackgroundColor',[1 1 1], 'position',[100 95 80 25], 'string', num2str(beta),...
            'Callback', 'beta= str2num(get(GUI.beta, ''String''))');
end
if(CC==3)
  uicontrol(gcf,'style','text', 'position',[10 115 80 25], 'string', 'Cycles', 'BackgroundColor',[0.8 0.8 0.8]);
GUI.cycles=uicontrol('style','edit', 'BackgroundColor',[1 1 1], 'position',[10 95 80 25], 'string', num2str(cycles),...
            'Callback', 'cycles= str2num(get(GUI.cycles, ''String''))');
        
        
uicontrol(gcf,'style','text', 'position',[100 115 80 25], 'string', 'Amp', 'BackgroundColor',[0.8 0.8 0.8]);
 GUI.amp=uicontrol('style','edit', 'BackgroundColor',[1 1 1], 'position',[100 95 80 25], 'string', num2str(amp),...
            'Callback', 'amp= str2num(get(GUI.amp, ''String''))');
end
if(CC==4)
  uicontrol(gcf,'style','text', 'position',[10 115 80 25], 'string', 'Cycles', 'BackgroundColor',[0.8 0.8 0.8]);
GUI.cycles=uicontrol('style','edit', 'BackgroundColor',[1 1 1], 'position',[10 95 80 25], 'string', num2str(cycles),...
            'Callback', 'cycles= str2num(get(GUI.cycles, ''String''))');
        
uicontrol(gcf,'style','text', 'position',[100 115 80 25], 'string', 'Fc', 'BackgroundColor',[0.8 0.8 0.8]);
 GUI.fc=uicontrol('style','edit', 'BackgroundColor',[1 1 1], 'position',[100 95 80 25], 'string', num2str(fc),...
            'Callback', 'fc= str2num(get(GUI.fc, ''String''))');
end
if(CC==5)
  uicontrol(gcf,'style','text', 'position',[10 115 80 25], 'string', 'Cycles', 'BackgroundColor',[0.8 0.8 0.8]);
GUI.cycles=uicontrol('style','edit', 'BackgroundColor',[1 1 1], 'position',[10 95 80 25], 'string', num2str(cycles),...
            'Callback', 'cycles= str2num(get(GUI.cycles, ''String''))');
              
uicontrol(gcf,'style','text', 'position',[100 115 80 25], 'string', 'rmsth', 'BackgroundColor',[0.8 0.8 0.8]);
 GUI.rmsth=uicontrol('style','edit', 'BackgroundColor',[1 1 1], 'position',[100 95 80 25], 'string', num2str(rmsth),...
            'Callback', 'rmsth= str2num(get(GUI.rmsth, ''String''))');
end
if(CC==6)
  uicontrol(gcf,'style','text', 'position',[10 115 80 25], 'string', 'Cycles', 'BackgroundColor',[0.8 0.8 0.8]);
GUI.cycles=uicontrol('style','edit', 'BackgroundColor',[1 1 1], 'position',[10 95 80 25], 'string', num2str(cycles),...
            'Callback', 'cycles= str2num(get(GUI.cycles, ''String''))');
        
        
uicontrol(gcf,'style','text', 'position',[100 115 80 25], 'string', 'recti', 'BackgroundColor',[0.8 0.8 0.8]);
 GUI.recti=uicontrol('style','edit', 'BackgroundColor',[1 1 1], 'position',[100 95 80 25], 'string', num2str(recti),...
            'Callback', 'recti= str2num(get(GUI.recti, ''String''))');
end
les_enfants = get(GUI.main,'children');
   
for xi_enfant = 1:length(les_enfants)
    try
        set(les_enfants(xi_enfant),'Units','normalized');
    end;
end