if(exist(['xx'])==1)
    set(GUI.p_signn,'Visible','off')
     set(GUI.p_sign,'Visible','off')
else
    set(GUI.p_sign,'Visible','off')
end
subplot(11,20,[3:20 23:40 43:60 63:80])
GUI.p_sign = plot(x(1:+(fenetre_affich*Fsample)), 'r','LineWidth',0.90);
axis([0 length(1:fenetre_affich*Fsample) born_sign(1) born_sign(2)])