function sig = gaborT(b,t)
    sig = exp(-pi*((t-b(3))/b(1)).^2).*cos(b(2)*(t-b(3)))