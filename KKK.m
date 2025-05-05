 %calcul de FFT
 
        GUI_fft= figure('units','pixels',...
            'position',[250  200 300  250],...
            'color',[0.925 0.913 0.687]);
        

sig2=y(posdebhfo(poos1):posfinhfo(poos1));

yy = [zeros(1,10) sig2 zeros(1,10)]

FFT_size=200;
X=abs(fft(yy,FFT_size));
X=X/max(X);
f=(0:FFT_size/2)/(FFT_size/2)*Fsample/2;
plot(f(8:52),abs(X(8:52))); %
xlabel('Frequency(Hz)')
grid;

         GUI.rip = uicontrol('Style', 'pushbutton' , 'String','R', 'Value', 1, 'Position', [70 230 30  15],'BackgroundColor',[1 0 0 ],...
            'Callback','CLASSS(poos1)=1000,delete(GUI_fft),ab=''R'',rrr,rrrr');
         GUI.fastrip = uicontrol('Style', 'pushbutton' , 'String','FR', 'Value', 1, 'Position', [100 230 30  15],'BackgroundColor',[1 0 0 ],...
            'Callback','CLASSS(poos1)=2000, delete(GUI_fft),ab=''FR'',rrr,rrrr');
         GUI.deux = uicontrol('Style', 'pushbutton' , 'String','FR+R', 'Value', 1, 'Position', [150 230 30  15],'BackgroundColor',[1 0 0 ],...
            'Callback','CLASSS(poos1)=3000,delete(GUI_fft),ab=''FR+R'',rrr,rrrr');
       