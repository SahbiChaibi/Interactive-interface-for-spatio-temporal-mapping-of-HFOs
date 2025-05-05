load ([F]); % Load Database, should contain signals in the variable allData and sampling frequency Fs.
fenetre_affich=2.5; % Default: length of displaying window is 2.5 seconds.
Fsample=Fs; % Sampling frequency of EEG Data.
electrode=3;% Default: display Electrode with index 3.  
electrodchange;
%% Fixed values for different methods of detection.
cycles=3;
beta=3;
amp=10;
fc=0.00008;
rmsth=7;
recti=2;
%%
hp = uipanel('fontAngle','italic','fontWeight','bold','FontSize',12,'ForegroundColor','blue','Position',[.01 .330 .15 .30]);% Zone radio buttons.
GUI_sampling= uicontrol(gcf,'style','text', 'position',[10 415 80 30], 'string', 'Sampling Frequency', 'BackgroundColor',[1 1 0]) % Sampling Frequency Button.
GUI.Fsample = uicontrol('style','edit','BackgroundColor',[1 1 0], 'position',[100 415 80 30], 'string', num2str(Fsample),...
            'Callback', 'Fsample = str2num(get(GUI.Fsample, ''String''))');
 
born_sign = [-max(abs(x)) max(abs(x))]*1.1;

GUI_w= uicontrol(gcf,'style','text', 'position',[10 380 80 30], 'string', 'Electrode', 'BackgroundColor',[1 1 0]);
GUI.electrode = uicontrol('style','edit', 'BackgroundColor',[1 1 0], 'position',[100 380 80 30], 'string', num2str(electrode),...
            'Callback', 'electrode = str2num(get(GUI.electrode, ''String''));clear x; electrodchange;electchange; born_sign = [-max(abs(x)) max(abs(x))]*1.1;set(GUI.ajuste_t_sign, ''Max'', length(x)-(fenetre_affich*Fsample)), choix_force = GUI.ajuste_t_sign; Plot_main');

MMNN=0;
subplot(11,20,[3:20 23:40 43:60 63:80])
GUI.p_sign = plot(x(1:+(fenetre_affich*Fsample)), 'r','LineWidth',0.90);
% set(gca,'color',[0.925 0.913 0.687]);
ab='FR';
axis([0 length(1:fenetre_affich*Fsample) born_sign(1) born_sign(2)])


% ajustement de l'echelle des ordonnees du signal brut                        
GUI.ajuste_a_echelle = uicontrol('Style', 'slider', 'Min', 1,'Max', 20, 'Position', [950 280 15 200], 'SliderStep', [0.008 0.05], 'Value', 1,...
                            'BackgroundColor',[0 0 1],...
                            'Callback', 'Plot_main');                      

Method =[1 2 3 4 5 6];   
uicontrol(gcf,'style','text', 'position',[25 300 120 20], 'string', 'Detection_Methods', 'BackgroundColor',[1 0 1]);
uicontrol(gcf,'style','text', 'position',[25 280 100 15], 'string', 'RMS', 'BackgroundColor',[0 1 1]);
uicontrol(gcf,'style','text', 'position',[25 260 100 15], 'string', 'CMOR', 'BackgroundColor',[0 1 1]);
uicontrol(gcf,'style','text', 'position',[25 240 100 15], 'string', 'MP', 'BackgroundColor',[0 1 1]);
uicontrol(gcf,'style','text', 'position',[25 220 100 15], 'string', 'BUMP', 'BackgroundColor',[0 1 1]);
uicontrol(gcf,'style','text', 'position',[25 200 100 15], 'string', 'HHT', 'BackgroundColor',[0 1 1]);
uicontrol(gcf,'style','text', 'position',[25 180 100 15], 'string', 'D-TREE', 'BackgroundColor',[0 1 1]);

GUI.fir = uicontrol('Style', 'radio', 'String',num2str(1), 'Value', 0, 'Position', [125 280 15 15],'BackgroundColor',[1 0 0],...
                'Callback','CC=str2num(get(gco, ''String'')),llll,MMNN=0');
GUI.wavelet = uicontrol('Style', 'radio', 'String',num2str(2), 'Value', 0, 'Position', [125 260 15 15],'BackgroundColor',[1 0 0],...
                'Callback','CC=str2num(get(gco, ''String'')),llll,MMNN=0');
GUI.mp= uicontrol('Style', 'radio', 'String',num2str(3), 'Value', 0, 'Position', [125 240 15 15],'BackgroundColor',[1 0 0],...
                'Callback','CC=str2num(get(gco, ''String'')),llll,MMNN=0');
GUI.Bumps = uicontrol('Style', 'radio', 'String',num2str(4), 'Value', 0, 'Position', [125 220 15 15],'BackgroundColor',[1 0 0],...
                'Callback','CC=str2num(get(gco, ''String'')),llll,MMNN=0');
GUI.hht = uicontrol('Style', 'radio', 'String',num2str(5), 'Value', 0, 'Position', [125 200 15 15],'BackgroundColor',[1 0 0],...
                'Callback','CC=str2num(get(gco, ''String'')),llll,MMNN=0');
GUI.tree= uicontrol('Style', 'radio', 'String',num2str(6), 'Value', 0, 'Position', [125 180 15 15],'BackgroundColor',[1 0 0],...
                'Callback','CC=str2num(get(gco, ''String'')),llll,MMNN=0');
Start_firrms  = uicontrol('Style', 'pushbutton', 'String', 'Run', 'Position', [20 145 140 20],...
'Callback','filess,Plot_main');   

%Start_result = uicontrol('Style', 'pushbutton', 'String', 'Detection Result', 'Position', [10 100 100 30],...
            %'Callback','Plot_main');
        
        
uicontrol(gcf,'style','text', 'position',[10 345 80 30], 'string', 'Window(s)', 'BackgroundColor',[1 1 0]);
GUI.fenetre = uicontrol('style','edit', 'BackgroundColor',[1 1 0], 'position',[100 345 80 30], 'string', num2str(fenetre_affich),...
            'Callback', 'fenetre_affich = str2num(get(GUI.fenetre, ''String'')); set(GUI.ajuste_t_sign, ''Max'', length(x)-(fenetre_affich*Fsample)), choix_force = GUI.ajuste_t_sign; Plot_main');
           
%%        
% glissement de la fenetre de temps
GUI.ajuste_t_sign = uicontrol('Style', 'slider', 'Min', 1,'Max', length(x)-(fenetre_affich*Fsample),...       
                            'Position', [200 5 700 15],'SliderStep',[0.008 0.05], 'Value', 1,...
                            'BackgroundColor',[0 0 0],...
                            'Callback', 'set(GUI.ajuste_t_sign, ''Value'', round(get(GUI.ajuste_t_sign, ''Value''))), filess, Plot_main');
                  
   les_enfants = get(GUI.main,'children');
   
for xi_enfant = 1:length(les_enfants)
    try
        set(les_enfants(xi_enfant),'Units','normalized');
    end;
end