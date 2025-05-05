tess1=exist('GUI_RESS');
if(tess1==1)
    delete('GUI_RESS');
end
tess2=exist('GUI.main');
if(tess2==1)
    delete('GUI.main');
end

delete(GUI.main);
GUI_RESS= figure('units','pixels',...
            'position',[100  100 1000  500],...
            'color',[0.925 0.913 0.687]);
        
hp = uipanel('fontAngle','italic','fontWeight','bold','FontSize',12,'ForegroundColor','blue','Position',[.005 .68 .12 .25]);% Zone radio buttons.  
uicontrol(gcf,'style','text', 'position',[5 470 150 25], 'string', 'Parameters of Mapping', 'BackgroundColor',[0.5 0.9 0.1]);
uicontrol(gcf,'style','text', 'position',[08 440 95 20], 'string', 'Frequency', 'BackgroundColor',[0 1 1]);
uicontrol(gcf,'style','text', 'position',[08 410 95 20], 'string', 'Duration', 'BackgroundColor',[0 1 1]);
uicontrol(gcf,'style','text', 'position',[08 380 95 20], 'string', 'Inter Dur', 'BackgroundColor',[0 1 1]);
uicontrol(gcf,'style','text', 'position',[08 350 95 20], 'string', 'Power', 'BackgroundColor',[0 1 1]);


GUI.frequency = uicontrol('Style', 'radio', 'String',num2str(4), 'Value', 0, 'Position', [100 440 20 20],'BackgroundColor',[1 0 0],...
                'Callback','CCC=str2num(get(gco, ''String''))');
GUI.duration = uicontrol('Style', 'radio', 'String',num2str(2), 'Value', 0, 'Position', [100 410 20 20],'BackgroundColor',[1 0 0],...
                'Callback','CCC=str2num(get(gco, ''String''))');
GUI.rate= uicontrol('Style', 'radio', 'String',num2str(1), 'Value', 0, 'Position', [100 380 20 20],'BackgroundColor',[1 0 0],...
                'Callback','CCC=str2num(get(gco, ''String''))');
GUI.power= uicontrol('Style', 'radio', 'String',num2str(3), 'Value', 0, 'Position', [100 350 20 20],'BackgroundColor',[1 0 0],...
                'Callback','CCC=str2num(get(gco, ''String''))');

I=imread('brain.jpg'); %% choose brain model
subplot(10,2,[ 3 5 7 9 11 13 15 17])
GUI.p_sign1 = imshow(I)
for i=1:3
h= uicontrol(gcf,'style','text','FontSize',[10.0],'fontAngle','italic','fontWeight','bold','ForegroundColor',[0 0 0 ],'position',[130 410 335 20], 'string',' Electrodes palcement should be checked','BackgroundColor',[0 1 1 ]);
pause(1)
delete(h)
pause(1)
end
llkkk=1;
    for iii=1:MM
        tesss=exist(['Electrod' num2str(iii) '.mat']);
        if(tesss==2)
        Tableauu(llkkk)=iii
        llkkk=llkkk+1;
        end
    end
    inx=1;
AddEle= uicontrol('Style', 'pushbutton', 'String', 'Add Electrode', 'Position', [140 110 120 25],...
'Callback', 'marking');
Start_STBM = uicontrol('Style', 'pushbutton', 'String', ' Brain spatio-temporal mapping', 'Position', [200 450 250 40],...
'Callback','Plot_main');   
Start_M  = uicontrol('Style', 'pushbutton', 'String', ' Histogram-based spatio temporal mapping', 'Position', [600 450 260 40],...
'Callback', 'Plot_main');   

 les_enfants = get(GUI_RESS,'children');
        for xi_enfant = 1 : length(les_enfants)
            try
                set(les_enfants(xi_enfant),'Units','normalized');
            end;
        end