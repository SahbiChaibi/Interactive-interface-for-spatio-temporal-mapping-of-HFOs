function model = load_decompfile(filename,attached_waveinf)

% This function loads a bump database from a .bdc file
%
% Copyright (C) 2008 Lab. ABSP, Riken (Japan) Francois-B. Vialatte et al.
% Please cite related papers when publishing results obtained with this
% toolbox

fid = fopen(filename,'r');
LOADCST = 8388608;

model.version = fread(fid, 1, 'int');
if version == 0
    model.freqmin  = 0;
    model.freqmax  = 0;
    model.freqsmp  = 0;
    model.freqdown = 0;
else
    model.cote     = fread(fid, 1, 'int');
    model.freqmin  = fread(fid, 1, 'int')/LOADCST;
    model.freqmax  = fread(fid, 1, 'int')/LOADCST;
    model.freqsmp  = fread(fid, 1, 'int')/LOADCST;
    model.freqdown = fread(fid, 1, 'int')/LOADCST;
end;
model.ByUp   = fread(fid, 1, 'int')/LOADCST;
model.ByDn   = fread(fid, 1, 'int')/LOADCST;
model.Bx     = fread(fid, 1, 'int')/LOADCST;
resnum       = fread(fid, 1, 'int');
model.resols = zeros(resnum,3);
for i=1:resnum
    model.resols(i,1) = fread(fid, 1, 'int')/LOADCST;
    model.resols(i,2) = fread(fid, 1, 'int')/LOADCST;
    model.resols(i,3) = fread(fid, 1, 'int')/LOADCST;
end;
N    = fread(fid, 1, 'int');
kind = fread(fid, 1, 'int');
num  = 0;
for i=1:N
   nm = fread(fid, 1, 'int');
   num = max(nm,num);
   for j=1:nm
      nump = fread(fid, 1, 'int');
      dc = fread(fid, nump, 'int');
      dc = dc / LOADCST;
      wc = zeros(4,1);
      wc(1) = fread(fid, 1, 'int');      
      wc(2) = fread(fid, 1, 'int');
      wc(3) = fread(fid, 1, 'int');      
      wc(4) = fread(fid, 1, 'int');
      erreur = fread(fid, 1, 'int');
      erreur = erreur / LOADCST;
      restes = fread(fid, 1, 'int');
      restes = restes / LOADCST;
      decomp.d{i}{j} = dc;
      decomp.window{i}{j} = wc;
      decomp.restes{i}.bump{j} = restes;
      decomp.erreur{i}.bump{j} = erreur;
   end;
end;
fclose(fid);
dec = -1*ones(N*num,5);
for i=1:N
   for j=1:length(decomp.d{i})
      dec((i-1)*num+j,:) = decomp.d{i}{j}';
   end;
end;     
windows = -1*ones(N*num,4);
for i=1:N
   for j=1:length(decomp.d{i})
      windows((i-1)*num+j,:) = decomp.window{i}{j}';
   end;
end;  
model.dec = dec;
model.windows = windows;
model.num = num;
model.N = N;
model.restes = decomp.restes;
model.erreur = decomp.erreur;
model.cell_dec = decomp.d;
if (length(attached_waveinf)>0)
    load(attached_waveinf);
    model.maxnorm = norme;
    model.size_freq = size(base_waves{1},1);
    model.size_time = size(base_waves{1},2);
    for i=1:model.N
       model.varspec{i} = varspec{i}{1};
       model.spectre{i} = spectre{i}{1};
    end;
end;