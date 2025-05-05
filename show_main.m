function show_main(vv,TT,BBB,jj)
load resull
poss=posdebhfo+(posfinhfo-posdebhfo)/2;
  if((poss>501) &(poss<12001-501));
switch gco
    case '
       
        set(GUI.p_sign, 'YData', x(poss-(fenetre_affich*Fsample)/2:poss+(fenetre_affich*Fsample)/2));
        set(GUI.p_sign_filt, 'YData', y(poss-(fenetre_affich*Fsample)/2:poss+(fenetre_affich*Fsample)/2)); 
        set(GUI.p_signdetection, 'CData', matt(1,poss-(fenetre_affich*Fsample)/2:poss+(fenetre_affich*Fsample)/2));
       
  end
end
