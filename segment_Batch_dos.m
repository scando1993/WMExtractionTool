%% Segment
function segment_Batch_dos (ruta,nombresdepoblacion)
%% 
% Funcion que Segmenta las imagenes T1 y aplica una correción de Bias.
% En SPM se utiliza una versión modificada del algoritmo mixture model. 
% Se asume que las imágenes de RM consisten de un número de distintos 
% tipos de tejido (clusters) a partir de los cuales cada vóxel ha sido
% dibujado
%%
%-----------------------------------------------------------------------
% 
% * ESPOL     FIEC & FIMCP    NBL"Neuroimaging & Bioengineering Laboratory"
% * Orlando Chancay
% Job saved on 30-Nov-2013 23:05:06 by cfg_util (rev $Rev: 4972 $)
% spm SPM - SPM12b (5616)
% cfg_basicio BasicIO - Unknown
%
%% Descripcion
% Esta funcion seleciona todas las imagenes T1 con *spm_selec*
% aplica un smooth al histograma con la funcion *spm_smooth*
% usamos mapas de probabilidades de los tejidos que los proporciona SPM.
% ademas para nuestro trabajo debemos setear parámetros para que la funcion
% nos arroje como resultado los tejidos en en espacio nativo y en el  espacio
% MNI para que estas puedan ser utilizadas por *DARTEL* al moneto de crear la plantilla.
%% Código
% La funcion necesita ruta de la carpeta de trabajo la cual debe ser
% enviada desde el programa principal y los nombre de los grupos que
% creamos. 
% en las variable *ruta* , *nombresdepoblacion* 

disp('ACL Working in Segment')
tic
matlabroot = ruta; 
poblacion = nombresdepoblacion;%{'HC', 'LPD', 'RPD'};
%% 
clear matlabbatch;
for pobl = 1 : length (poblacion)
    [sb_files , subjects] = spm_select('List',char(fullfile(matlabroot,poblacion(pobl))));
    subjects = cellstr(subjects)'; % escojo todos los sujetos del estudio
    
%% 
for i=1 : length(subjects)
    fnm = spm_select('List', char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t1_mprage_TRA_1x1x1')),'^s.*\.nii$'); % select images for the smooth
    anatomical = char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t1_mprage_TRA_1x1x1',deblank(fnm(1,:))));  % image(s) to be smoothed (or 3D array)
    [p, nm, e v] = spm_fileparts(anatomical) ;
    outfilename = [p filesep 's' nm e]; %filename for smoothed image (or 3D array)
    spm_smooth(anatomical,outfilename,[4 4 4]); % T1 smooth
    
    S = spm_vol(outfilename); % Get header information for images
%-----------------------------------------------------------------------
    matlabbatch{1}.spm.spatial.preproc.channel.vols = {char(S.fname)};
    matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0.001;
    matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = 60;
    matlabbatch{1}.spm.spatial.preproc.channel.write = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm = {'/Users/orlando/Documents/MATLAB/spm12b/tpm/TPM.nii,1'};
    matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 1;
    matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [1 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm = {'/Users/orlando/Documents/MATLAB/spm12b/tpm/TPM.nii,2'};
    matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
    matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [1 1];
    matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm = {'/Users/orlando/Documents/MATLAB/spm12b/tpm/TPM.nii,3'};
    matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
    matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [1 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm = {'/Users/orlando/Documents/MATLAB/spm12b/tpm/TPM.nii,4'};
    matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
    matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm = {'/Users/orlando/Documents/MATLAB/spm12b/tpm/TPM.nii,5'};
    matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
    matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(6).tpm = {'/Users/orlando/Documents/MATLAB/spm12b/tpm/TPM.nii,6'};
    matlabbatch{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
    matlabbatch{1}.spm.spatial.preproc.tissue(6).native = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(6).warped = [0 0];
%% 
    matlabbatch{1}.spm.spatial.preproc.warp.mrf = 1;
    matlabbatch{1}.spm.spatial.preproc.warp.cleanup = 1;
    matlabbatch{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
    matlabbatch{1}.spm.spatial.preproc.warp.affreg = 'mni';
    matlabbatch{1}.spm.spatial.preproc.warp.fwhm = 0;
    matlabbatch{1}.spm.spatial.preproc.warp.samp = 3;
    matlabbatch{1}.spm.spatial.preproc.warp.write = [1 1];
%% 
    spm_jobman('serial',matlabbatch);
end
end
    disp('ACL Done Segment')
    toc 