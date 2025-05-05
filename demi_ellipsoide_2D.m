function e = demi_ellipsoide_2D(y,x,p)

% This fonction computes a half ellipsoid function
% p = ellipsoid parameters (5 parameters), see below
% x,y = position in the 2D space
% FBV'25/09/03

h  = p(1);      % amplitude
l1 = p(2);      % height
l2 = p(3);      % width
Oy = p(4);      % y position
Ox = p(5);      % x position

y = Oy-y;
x = x-Ox;
seuil = 1e-5;

ex = (y^2/l1^2 + x^2/l2^2);
if (1-ex) < seuil
   e = 0;
else
   e = h * sqrt(1-ex);   
end;