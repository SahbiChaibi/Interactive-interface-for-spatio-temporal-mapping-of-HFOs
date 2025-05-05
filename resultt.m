function resultt
load resull

GUI_RES= figure('units','pixels',...
'position',[250  200 500  500],...
'color',[0.925 0.913 0.687],...
'numbertitle','off',...
'name','Detection Result',...
'menubar','none',...
'tag','interface');
uicontrol(gcf,'style','text', 'position',[100 450 100 25], 'string', 'Onset(sample)', 'BackgroundColor',[1 1 0 ])
uicontrol(gcf,'style','text', 'position',[300 450 100 25], 'string', 'End(sample) ', 'BackgroundColor',[1 1 0 ])

mm=400
for jj=1:1:length(posdebhfo)
    


uicontrol(gcf,'style','text', 'position',[100  mm 100  15], 'string', num2str(posdebhfo(jj)), 'BackgroundColor',[0 1 0 ])
uicontrol(gcf,'style','text', 'position',[300 mm 100 15], 'string', num2str(posfinhfo(jj)), 'BackgroundColor',[0 1 0 ])

mm=mm-20
end
les_enfants = get(GUI_RES,'children');
for xi_enfant = 1 : length(les_enfants)
    try
        set(les_enfants(xi_enfant),'Units','normalized');
    end;
end