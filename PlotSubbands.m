function PlotSubbands(x,w,p,q,s,J1,J2,fs,eflag)
% PlotSubbands(x,w,p,q,s,J1,J2,fs)
% Plot subbands from levels J1 to J2.
% NEED
%   1 <= J1 < J2 <= J+1 where J is total number of levels.
%
% PlotSubbands(x,w,p,q,s,J1,J2,fs,'energy') - displays the
% subband energy as a percentage of the total energy.


N = length(x);
clf
plot([0:N-1]/fs,x/(2*max(abs(x))),'b')
hold on
J = length(w)-1;

if nargin > 8
    e = zeros(1,J+1);
    for j = 1:J+1
        e(j) = sum(w{j}.^2);
    end
end

for j = J1:J2
    Nj = length(w{j});
    t = (0:Nj-1)*(q/p)^(j-1)*s;
    Mj = 0.5/max(abs(w{j}));
    plot(t/fs, w{j}*Mj-j+J1-1,'k');

    if nargin > 8
        % display fraction of total energy
        txt = sprintf('%5.2f%%',e(j)/sum(e)*100);
        text(1.02*N/fs,-j+J1-1,txt,'units','data');
    end
end
hold off
axis([0 N/fs -(J2-J1)-1.5 1])
title('SUBBANDS OF SIGNAL')
xlabel('TIME (SECONDS)')
ylabel('SUBBAND')
set(gca,'Ytick',(J1-J2:0)-1,'YtickLabel',[J2:-1:J1])

red = 1/s * 1/(1-p/q);              % Redundancy

% Display parameter values in figure
txt = sprintf('P = %d, Q = %d, S = %d, Levels = %d',p,q,s,J);
text(0,-0.05,txt,'units','normalized');
txt = sprintf('Dilation = %.2f, Redundancy = %.2f',q/p, red);
text(1,-0.05,txt,'units','normalized','horizontalalignment','right');

