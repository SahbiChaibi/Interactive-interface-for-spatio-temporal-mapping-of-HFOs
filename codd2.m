%% part2:mapping color_duration
[ggg hhh]= size(TABDUR);
TABDUR(:,end+1)=0;
subplot(10,2,[ 4 6 8 10 12 14 16 18])
GUI_ele1= uicontrol(gcf,'style','text', 'position',[500 90 64 350], 'BackgroundColor',[0.925 0.913 0.687]);
bcc=0
for iijj=1:1:ggg
    for lki=1:length(TABDUR(iijj,:))
        if((TABDUR(iijj,lki)~=0) & (TABDUR(iijj,lki+1)==0))
            bcc=max(bcc,lki);
ran=range(durationn); %finding range of data
min_val=min(durationn);%finding minumum value of data.
max_val=max(durationn);%finding maxumum value of data.
y=floor(((TABDUR(iijj,1:lki)-min_val)/ran)*63)+1;
col=zeros(length(TABDUR(iijj,1:lki)),3);
p=colormap('jet');caxis([min_val max_val]);
 vcv=TABDUR(iijj,1:lki)/max(max(TABDUR));
for i=1:lki
a=y(i);
col(i,:)=p(a,:);
hold on
line([i i], [iijj-1 vcv(i)+iijj-1],'LineWidth',2,'Color',col(i,:));
colorbar
axis([ 0 bcc 0 ggg])
xlabel('HFO index')
end
        end 
    end
hb=380-60;
divv=hb/ggg;
nmn=95+divv*(iijj-1);
GUI_ele2= uicontrol(gcf,'style','text', 'position',[500 nmn 65 15], 'string', ['Elect',num2str(INDEXXX1(iijj))], 'BackgroundColor',[0.925 0.913 0.687]);
end
Start_Exit = uicontrol('Style', 'pushbutton', 'String', 'EXIT', 'Position', [850 20 80 25],...
'Callback', 'codd3');
les_enfants = get(GUI_RESS,'children');
        for xi_enfant = 1 : length(les_enfants)
            try
                set(les_enfants(xi_enfant),'Units','normalized');
            end;
        end