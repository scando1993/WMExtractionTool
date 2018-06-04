function clean_StudyTESIS_dos (ruta)
% Batch que sirve para crear el estudio 

%__________________________________________________________________________
% ESPOL     FIEC & FIMCP    NBL"Neuroimaging & Bioengineering Laboratory"

% Orlando Chancay
% $Id: organizarfoldersTESIS.m  23-Nov-2013  9:48:13z$

% clear all
% close all
% clc
% tic
%--------------------------------------------------------------------------

% matlabroot = '/Users/orlando/Documents/MATLAB/TESIS/test';
matlabroot = ruta;
%% 

[filesA,dirsA] = spm_select('List', fullfile(matlabroot,'forg2')); % select folders
[fd cf] = size(dirsA);

for sub = 1 : fd
    
    [filesB,dirsB] = spm_select('List', fullfile(matlabroot,'forg2',deblank(dirsA(sub,:)),'DICOM')); % select contenido of each folder
    [fsf csf] = size(dirsB);
    
    
    if fsf == 0  % if  do not have file, the folder is deleted
        [status, message, messageid] = rmdir(fullfile(matlabroot,'forg2',deblank(dirsA(sub,:))),'s') ;
    end
%     [filesC,dirsC] = spm_select('List', fullfile(matlabroot,'forg2',deblank(dirsA(sub,:)),'DICOM'),deblank(dirsA(sub,:)));
        
end
toc
%% 
%% base de datos desde carpetas
%clc
[filesSUBJ,dirsSUBJ] = spm_select('List', fullfile(matlabroot,'forg2')); % select images for the smooth
[nrows,ncols]= size(dirsSUBJ);

filename = 'celldata2xx.txt';
fid2 = fopen(filename, 'w');

for row=1:nrows
    fprintf(fid2, '%s \n', dirsSUBJ(row,:));
end

fclose(fid2);

