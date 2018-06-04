%% WM EXTRACTION
clc 
clear all 
disp('******** beginning FRACTAL DIMENSION ********');
tic
%% 
% subjects={'sb1', 'sb2', 'sb3', 'sb4', 'sb5', 'sb6', 'sb7', 'sb8', 'sb9', 'sb10' };
matlabroot='/Users/orlando/Documents/MATLAB/TESIS/test';

%% elegir varias poblaciones
poblacion = {'HC', 'LPD', 'RPD'};
for pobl = 1 : length (poblacion)

    [sb_files , subjects] = spm_select('List',fullfile(matlabroot,poblacion(pobl)));
    subjects = cellstr(subjects)'; % escojo todos los sujetos del estudio
    for i=1:length(subjects)
%         wm = spm_select('List', fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t1_mprage_TRA_1x1x1'),'^c2ss.*\.nii$'); % select images for the smooth
        rs = spm_select('List', fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm'),'^WMrs.*\.nii$'); % select images for the smooth
%         wmT1 = char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t1_mprage_TRA_1x1x1',deblank(wm)));
        resflair = char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm',deblank(rs))); 

    fnm = spm_select('List', '/Users/orlando/Documents/MATLAB/TESIS/test/sb10/TEMP','resFLAIRxWM.nii');
[pth bnm ext] = spm_fileparts(fnm);
VI = spm_vol(fnm);
img = spm_read_vols(VI);



% load mri
% D = squeeze(D) ;
% image_num = 8;
% image(D(:,:,image_num))
% axis image
% colormap(map)
% title('Image of MRI slice No. 8 ')
% [fds ics averFD averIC]= fdvolfft(D)


end
toc