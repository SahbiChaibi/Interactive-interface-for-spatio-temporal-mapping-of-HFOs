function [bump,window] = get_bump(model,i,j)

% This function retrieves the bump number j of signal i
% inputs  
% model = bump model
% i = number of the signal (=1 if only one signal)
% j = number of the bump (modeling order). If less than j bumps exist in 
% the i-th model, then a vector with -1 values is returned.
% ouputs:
% bump = the bump parameters
% window = time-frequency window where the bump was located
%
% FBV'02/02/2009

bump = model.dec((i-1)*model.num+j,:);
window = model.windows((i-1)*model.num+j,:);