%% Template
function tempTESIS_dos (ruta,nombresdepoblacion)
%%
% Función que sirve para crear una plantilla a partir de todas las imágenes
% con la ayuda de *DARTEL*  'A Fast Diffeomorphic Registration Algorithm'
% \cite{ashburner2007fast} .
% de los sujetos del estudio. en nuestra tesis solamente creamos una
% plantilla con la Sustancia Blanca. La cual nos sirva para normalizar las
% imágenes y poder hacer comparaciones y ¡análisis de ANOVA.
%% Descripción
% Esta función selecciona todas las imágenes SB_T1 con *spm_selec*
% de la imagen T1 y crea nuestra plantilla mediante la función de SPM
% *dartel* .
%% Código
% La función necesita ruta de la carpeta de trabajo la cual debe ser
% enviada desde el programa principal y los nombre de los grupos que
% creamos. 
%-----------------------------------------------------------------------
% Job saved on 07-Dec-2013 14:29:15 by cfg_util (rev $Rev: 4972 $)
% spm SPM - SPM12b (5616)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
% clc 
% clear all 
disp('******** beginning CREATE TEMPLATE ********');
tic
%% 
% matlabroot='/Users/orlando/Documents/MATLAB/TESIS/test';
matlabroot = ruta;
%% 
clear matlabbatch;

%% elegir varias poblaciones
poblacion = nombresdepoblacion,%{'HC', 'LPD', 'RPD'};
count = 1; 

for pobl = 1 : length (poblacion)

    [sb_files , subjects] = spm_select('List',fullfile(matlabroot,poblacion(pobl)));
    subjects = cellstr(subjects)'; % escojo todos los sujetos del estudio
    
%     for i=1:length(subjects)
%         fnm= spm_select('List', fullfile(matlabroot,subjects{i},'TEMP6'),'^rc2ss.*\.nii$'); % select images for the smooth
%         rc2{i} = fullfile(matlabroot,subjects{i},'TEMP6',deblank(fnm(1,:)));
%     end
    
    
    i = 1;
    while (pobl <=3 && i <= length(subjects))
        fnm= spm_select('List', fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t1_mprage_TRA_1x1x1'),'^rc2ss.*\.nii$'); % select images for the smooth
        rc2{count} = char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t1_mprage_TRA_1x1x1',deblank(fnm(1,:))));
        count = count + 1;
        i = i + 1;
    end
    
end
%% 

matlabbatch{1}.spm.tools.dartel.warp.images = { rc2
%                                                {
%                                                '/Users/orlando/Documents/MATLAB/TESIS/test/sb1/TEMP5/rc2ss572978-0002-00001-000001-01.nii,1'
%                                                '/Users/orlando/Documents/MATLAB/TESIS/test/sb2/TEMP5/rc2ss508840-0010-00001-000001-01.nii,1'
%                                                '/Users/orlando/Documents/MATLAB/TESIS/test/sb3/TEMP5/rc2ss446223-0008-00001-000001-01.nii,1'
%                                                }
                                               }';
matlabbatch{1}.spm.tools.dartel.warp.settings.template = 'Template';
matlabbatch{1}.spm.tools.dartel.warp.settings.rform = 1;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(1).its = 3;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(1).rparam = [4 2 1e-06];
matlabbatch{1}.spm.tools.dartel.warp.settings.param(1).K = 0;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(1).slam = 16;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(2).its = 3;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(2).rparam = [2 1 1e-06];
matlabbatch{1}.spm.tools.dartel.warp.settings.param(2).K = 0;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(2).slam = 8;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(3).its = 3;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(3).rparam = [1 0.5 1e-06];
matlabbatch{1}.spm.tools.dartel.warp.settings.param(3).K = 1;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(3).slam = 4;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(4).its = 3;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(4).rparam = [0.5 0.25 1e-06];
matlabbatch{1}.spm.tools.dartel.warp.settings.param(4).K = 2;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(4).slam = 2;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(5).its = 3;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(5).rparam = [0.25 0.125 1e-06];
matlabbatch{1}.spm.tools.dartel.warp.settings.param(5).K = 4;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(5).slam = 1;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(6).its = 3;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(6).rparam = [0.25 0.125 1e-06];
matlabbatch{1}.spm.tools.dartel.warp.settings.param(6).K = 6;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(6).slam = 0.5;
matlabbatch{1}.spm.tools.dartel.warp.settings.optim.lmreg = 0.01;
matlabbatch{1}.spm.tools.dartel.warp.settings.optim.cyc = 3;
matlabbatch{1}.spm.tools.dartel.warp.settings.optim.its = 3;

 spm_jobman('serial',matlabbatch);
    disp('done CREATE TEMPLATE')
    toc 