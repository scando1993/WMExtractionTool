%-----------------------------------------------------------------------
% Job saved on 30-Nov-2013 23:05:06 by cfg_util (rev $Rev: 4972 $)
% spm SPM - SPM12b (5616)
% cfg_basicio BasicIO - Unknown
clc 
clear all 
% close all
tic
%% 
subjects={'sb1', 'sb2', 'sb3', 'sb4', 'sb5', 'sb6', 'sb7', 'sb8', 'sb9', 'sb10' };
matlabroot='/Users/orlando/Documents/MATLAB/TESIS/test';

%% 
for i=1:length(subjects)
    clear matlabbatch;
    fnm = spm_select('List', fullfile(matlabroot,subjects{i},'TEMP6'),'^s.*\.nii$'); % select images for the smooth
    anatomical = fullfile(matlabroot,subjects{i},'TEMP6',deblank(fnm(1,:)));  % image(s) to be smoothed (or 3D array)
    [p, nm, e v] = spm_fileparts(anatomical) ;
    outfilename = [p filesep 's' nm e]; %filename for smoothed image (or 3D array)
    spm_smooth(anatomical,outfilename,[4 4 4]); % T1 smooth
    
    S = spm_vol(outfilename); % Get header information for images
%-----------------------------------------------------------------------
    matlabbatch{1}.spm.spatial.preproc.channel.vols = {S.fname};
    matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0.001;
    matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = 60;
    matlabbatch{1}.spm.spatial.preproc.channel.write = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm = {'/Users/orlando/Documents/MATLAB/spm12b/tpm/TPM.nii,1'};
    matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 1;
    matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [1 1];
    matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [1 1];
    matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm = {'/Users/orlando/Documents/MATLAB/spm12b/tpm/TPM.nii,2'};
    matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
    matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [1 1];
    matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [1 1];
    matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm = {'/Users/orlando/Documents/MATLAB/spm12b/tpm/TPM.nii,3'};
    matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
    matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [1 1];
    matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [1 1];
    matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm = {'/Users/orlando/Documents/MATLAB/spm12b/tpm/TPM.nii,4'};
    matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
    matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [1 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm = {'/Users/orlando/Documents/MATLAB/spm12b/tpm/TPM.nii,5'};
    matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
    matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [1 0];
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
    disp('done ORLANDO')
    toc 
    

