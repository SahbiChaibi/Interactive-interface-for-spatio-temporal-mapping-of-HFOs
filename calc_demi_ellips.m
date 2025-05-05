function mat = calc_demi_ellips(p,xl,yl)

% This function generates the matrix representation of a 2D half ellispoid
% p = ellipsoid parameters (amplitude, height, width, y-position, x-position)
% x = x-dimension of the matrix
% y = y-dimension of the matrix
%
% FBV'25/09/03

mat=zeros(yl,xl);
for kx=1:xl;
   for ky=1:yl;
      mat(ky,kx) = demi_ellipsoide_2D(ky,kx,p);
   end;
end;


