%% Coreslice
function coresliceTESIS_dos (ruta,nombresdepoblacion)
%% 
% funcion que Coregistra las imagenes T1 y FLAIR y le aplica una
% interpolacion a las imagen FLIAR que posee 36 cortes.
%%
% 
% * ESPOL     FIEC & FIMCP    NBL"Neuroimaging & Bioengineering Laboratory"
% * Orlando Chancay
% * $Id: organizarfoldersTESIS.m  23-Nov-2013  9:48:13z$
%
%% Descripcion
% Esta funcion seleciona todas las imagenes T1 y FLAIR 
% y las coregistra mediante la funcion 'spm_coreg', para leer las cabezaras
% de las iamgenes usamos la funcion 'spm_vol', obtenemos el espacio de la T1 
% mediante la funcion spm_get_space y por último para interpolas
% cortes intermedios de la imagen FLAIR de 36 cortes se usa la funcion
% spm_reslice 
%% Código
% la ruta de la carpeta de trabajo es enviada desde el programa principal
% y los nombre de los grupos.
% en las variable *ruta* , *nombresdepoblacion* 
% Opciones seteadas:
%         defaults.coreg.estimate.cost_fun = 'nmi';
%         defaults.coreg.estimate.sep      = [4 2];
%         defaults.coreg.estimate.tol      = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
%         defaults.coreg.estimate.fwhm     = [7 7];

%%
fprintf('ACL Working Coregister: Estimate & Reslice\n');
tic
% matlabroot='/Users/orlando/Documents/MATLAB/TESIS/test';
matlabroot= ruta;
global Defaults;
Defaults = spm_get_defaults;
%% 
poblacion = nombresdepoblacion;%{'HC', 'LPD', 'RPD'};
for pobl = 1 : length (poblacion)

    [sb_files , subjects] = spm_select('List',fullfile(matlabroot,poblacion(pobl)));
    subjects = cellstr(subjects)'; % escojo todos los sujetos del estudio
%     fnmtemplate = spm_select('List', fullfile(matlabroot,'TEMPLATES'),'^GG-366-T1-1.0mm.*\.nii$');
%     templateT1 = fullfile(matlabroot,'TEMPLATES',deblank(fnmtemplate));
%     VG = spm_vol(templateT1);
%% 
    
    for i=1 : length(subjects)
        [files , fol_sec] = spm_select('List',char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6')));
        
        [T1 , fol] = spm_select('List',char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6',deblank(fol_sec(1,:)))),'^s.*\.nii$');
        anatmical = char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6',deblank(fol_sec(1,:)),deblank(T1)));
        [FLAIR , fol] = spm_select('List',char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6',deblank(fol_sec(2,:)))),'^s.*\.nii$');
        flaird = char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6',deblank(fol_sec(2,:)),deblank(FLAIR)));
        VF = spm_vol(anatmical);
        VE = spm_vol(flaird);
%         -----------------------------------------------------------------
%         defaults.coreg.estimate.cost_fun = 'nmi';
%         defaults.coreg.estimate.sep      = [4 2];
%         defaults.coreg.estimate.tol      = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
%         defaults.coreg.estimate.fwhm     = [7 7];
%         
%         x = spm_coreg(VG,VF);
%         
%         M = inv(spm_matrix(x));
%         PO = strvcat(templateT1,anatmical);
%         for j = 1:size(PO,1)
%              MM(:,:,j)=spm_get_space(deblank(PO(j,:)));
%         end
% 
%         for j = 2:size(PO,1)
%              spm_get_space(deblank(PO(j,:)), M*MM(:,:,j));
%         end
%         -----------------------------------------------------------------
        defaults.coreg.estimate.cost_fun = 'nmi';
        defaults.coreg.estimate.sep      = [4 2];
        defaults.coreg.estimate.tol      = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
        defaults.coreg.estimate.fwhm     = [7 7];
        
        x = spm_coreg(VF,VE);
        
        M2 = inv(spm_matrix(x));
        PO2 = strvcat(anatmical,flaird);
        for j = 1:size(PO2,1)
             MM2(:,:,j)=spm_get_space(deblank(PO2(j,:)));
        end

        for j = 2:size(PO2,1)
             spm_get_space(deblank(PO2(j,:)), M2*MM2(:,:,j));
        end
        %
        resflags = struct(...b
              'mask',0,... % don't mask anything
              'mean',0,... % write mean image
              'which',1,... % write everything else
              'interp',1); % I forget... linear interp?
            imgs = [cellstr(anatmical); cellstr(flaird)];
%             cd(char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6')));
        spm_reslice(imgs,resflags); % reslices all images
        
    
    end
end
fprintf('ACL Done Coregister: Estimate & Reslice\n');
toc
