function [ output_args ] = segment_images( route , data_dir, tpm_dir)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

disp('ACL Working in Segment')
tic
matlabroot = route;
clear matlabbatch;

subjectbatch = matlabbatch;
dat_dir = fullfile(matlabroot,data_dir);
[sb_files , subjects] = spm_select('List', dat_dir);

for i=1 : length(subjects(:,1))
    fnm = spm_select('List', fullfile(dat_dir, subjects(i,:)), '^T1.*'); % select images for the smooth
    anatomical = deblank(fullfile(dat_dir, deblank(subjects(i,:)), fnm(1,:)));  % image(s) to be smoothed (or 3D array)
    [p, nm, e, v] = spm_fileparts(anatomical) ;
    outfilename = [deblank(p) filesep 's' nm e]; %filename for smoothed image (or 3D array)
    spm_smooth(anatomical,outfilename,[4 4 4]); % T1 smooth
    
    S = spm_vol(outfilename); % Get header information for images
    %-----------------------------------------------------------------------
    subjectbatch{1}.spm.spatial.preproc.channel.vols = {char(S.fname)};
    subjectbatch{1}.spm.spatial.preproc.channel.biasreg = 0.001;
    subjectbatch{1}.spm.spatial.preproc.channel.biasfwhm = 60;
    subjectbatch{1}.spm.spatial.preproc.channel.write = [0 0];
    
    subjectbatch{1}.spm.spatial.preproc.tissue(1).tpm = {[fullfile(tpm_dir,'TPM.nii'),',1']};
    subjectbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 1;
    subjectbatch{1}.spm.spatial.preproc.tissue(1).native = [1 0];
    subjectbatch{1}.spm.spatial.preproc.tissue(1).warped = [0 0];
    subjectbatch{1}.spm.spatial.preproc.tissue(2).tpm = {[fullfile(tpm_dir,'TPM.nii'),',2']};
    subjectbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
    subjectbatch{1}.spm.spatial.preproc.tissue(2).native = [1 1];
    subjectbatch{1}.spm.spatial.preproc.tissue(2).warped = [0 0];
    subjectbatch{1}.spm.spatial.preproc.tissue(3).tpm = {[fullfile(tpm_dir,'TPM.nii'),',3']};
    subjectbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
    subjectbatch{1}.spm.spatial.preproc.tissue(3).native = [1 0];
    subjectbatch{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
    subjectbatch{1}.spm.spatial.preproc.tissue(4).tpm = {[fullfile(tpm_dir,'TPM.nii'),',4']};
    subjectbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
    subjectbatch{1}.spm.spatial.preproc.tissue(4).native = [0 0];
    subjectbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
    subjectbatch{1}.spm.spatial.preproc.tissue(5).tpm = {[fullfile(tpm_dir,'TPM.nii'),',5']};
    subjectbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
    subjectbatch{1}.spm.spatial.preproc.tissue(5).native = [0 0];
    subjectbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
    subjectbatch{1}.spm.spatial.preproc.tissue(6).tpm = {[fullfile(tpm_dir,'TPM.nii'),',6']};
    subjectbatch{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
    subjectbatch{1}.spm.spatial.preproc.tissue(6).native = [0 0];
    subjectbatch{1}.spm.spatial.preproc.tissue(6).warped = [0 0];

    subjectbatch{1}.spm.spatial.preproc.warp.mrf = 1;
    subjectbatch{1}.spm.spatial.preproc.warp.cleanup = 1;
    subjectbatch{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
    subjectbatch{1}.spm.spatial.preproc.warp.affreg = 'mni';
    subjectbatch{1}.spm.spatial.preproc.warp.fwhm = 0;
    subjectbatch{1}.spm.spatial.preproc.warp.samp = 3;
    subjectbatch{1}.spm.spatial.preproc.warp.write = [1 1];
    %%
    spm_jobman('serial',subjectbatch);
    
end
disp('ACL Done Segment')
toc

end

