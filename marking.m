index=Tableauu(inx)
R=15;
aa=eval(['cursor_info',num2str(index),'.','Position'])   
cx(index)=aa(1);
cy(index)=aa(2);
mm=cx(index);
nn=cy(index);
viscircles([mm nn],R,'EdgeColor','k','LineWidth',0.1);
text(mm-R-5, nn-R-5,['E' num2str(index)]);
inx=inx+1;
les_enfants = get(GUI_RESS,'children');
        for xi_enfant = 1 : length(les_enfants)
            try
                set(les_enfants(xi_enfant),'Units','normalized');
            end;
        end