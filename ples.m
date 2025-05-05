GUI_1a=uicontrol(gcf,'style','text', 'position',[10 100 515  15], 'string', '>>>>>>', 'BackgroundColor',[0 0 1 ]);
            
mm=10;
        for jj=1:1:45
    pause(0.01)
GUI_1b(jj)=uicontrol(gcf,'style','text', 'position',[mm 100 75  15], 'string', '>>>>>>', 'BackgroundColor',[0 0 0 ]);
            mm=mm+10;
            
        end
        
pause(3)

delete(GUI_1a);
for jj=1:1:45
delete(GUI_1b(jj));
end
GUI_1c=uicontrol(gcf,'style','text', 'position',[300 490 300 30], 'string', 'Data is corctly loaded', 'BackgroundColor',[0 1 0]')
pause(1)
delete(GUI_1c)

hpop_2 = uicontrol('Style', 'popup',...
       'String', '1|2|3|4',...
       'Position', [10 380 25 10],...
       'BackgroundColor',[1 0.4 0.1],....
   'callback','choix(get(hpop_2, ''Value''))');
choix_beta = [1:1:4];   
uicontrol(gcf,'style','text', 'position',[10 400 25 10], 'string', 'CHOIX', 'BackgroundColor',[0.8 0.8 0.8]);
hpop_2 = uicontrol('Style', 'popup',...
       'String', 'FIR-RMS|Wavelet|MP|Bumps',...
       'Position', [10 380 25 10],...
       'BackgroundColor',[1 0.4 0.1],....
   'callback','choix_beta(get(hpop_2, ''Value''))');
switch choix_beta(get(hpop_2, 'Value'))
    case  1
         Main111
    case  2
        Main222
    case 3
        Main333
        
    case 4
        Main 444     
end



