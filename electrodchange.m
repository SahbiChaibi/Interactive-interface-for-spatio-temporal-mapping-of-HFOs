ni=1;
ns= 8000; %length(allData(1,:)); % Length of each Electrode. 
x=allData(electrode,ni:ns); % EEG data to be processed.
p1=x(1);
p2=x(end);
if(p1>0)
    x=[zeros(1,100) 0:1:p1 x];
elseif (p1==0)
    x=[zeros(1,100) x];
else
    x=[zeros(1,100) 0:-1:p1 x];
end

if(p2>0)
    x=[x p2:-1:0 zeros(1,100)];
elseif(p2==0)
    x=[x  zeros(1,100)];
else
    x=[x p2:1:0 zeros(1,100)];
end
[MM NN]=size(allData);
