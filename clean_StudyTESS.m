function dicom_convertTESIS_dos (ruta)
% Batch que sirve para crear el estudio 

%__________________________________________________________________________
% ESPOL     FIEC & FIMCP    NBL"Neuroimaging & Bioengineering Laboratory"

% Orlando Chancay
% $Id: organizarfoldersTESIS.m  23-Nov-2013  9:48:13z$

clear all
close all
clc
tic
%--------------------------------------------------------------------------

matlabroot = '/Users/orlando/Documents/MATLAB/TESIS/test';
%% 

[filesA,dirsA] = spm_select('List', fullfile(matlabroot,'forg')); % select folders
[fd cf] = size(dirsA);

for sub = 1 : 1%fd
    
    [filesB,dirsB] = spm_select('List', fullfile(matlabroot,'forg',deblank(dirsA(sub,:)))); % select contenido of each folder
    [fsf csf] = size(dirsB);
    
    
    if fsf == 0  % if  do not have file, the folder is deleted
        [status, message, messageid] = rmdir(fullfile(matlabroot,'forg',deblank(dirsA(sub,:))),'s') ;
    end
    
    if fsf > 0
        for lp = 1 : fsf
            [filesDICOM,dirsDICOM] = spm_select('List',fullfile(matlabroot,'forg',deblank(dirsA(sub,:)),deblank(dirsB(lp,:)) ),'\.dcm');
            
            if filesDICOM > 0 % confirm which exist DICON files
                
                for j = 1 : 1%lfil % get informations of field
                    if isdicom(fullfile(matlabroot,'forg',deblank(dirsA(sub,:)),deblank(dirsB(lp,:)),deblank(filesDICOM(j,:))))
                        X =  dicominfo(fullfile(matlabroot,'forg',deblank(dirsA(sub,:)),deblank(dirsB(lp,:)),deblank(filesDICOM(j,:))));
                        name = X.PatientName;
                        secuencia = X.SeriesDescription;
                    end
                end
                
            
            
                [status, message, messageid] = mkdir(fullfile(matlabroot,'forg',deblank(dirsA(sub,:))), secuencia );
                [ffT1,cfT1] =  size(filesDICOM);
                    clear hdrT1
                for ft1=1 : ffT1
                    hdrT1(ft1,1) = spm_dicom_headers(fullfile(matlabroot,'forg',deblank(dirsA(sub,:)),deblank(dirsB(lp,:)),deblank(filesDICOM(ft1,:))));
                end
                if length(hdrT1)> 0 % si existe hdrT1 entonces convierto
                    cd(fullfile(matlabroot,'forg',deblank(dirsA(sub,:)),secuencia));
                    spm_dicom_convert(hdrT1,'all','flat','nii');
                end
            end
        end
        
    end
        
end
toc


