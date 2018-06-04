clc 
clear all 
close all
tic
%% 
subjects={'sb1', 'sb2', 'sb3', 'sb4', 'sb5', 'sb6', 'sb7', 'sb8', 'sb9', 'sb10' };
matlabroot='/Users/orlando/Documents/MATLAB/TESIS/test';

%% 
for i=1:1%length(subjects)
    fnm = spm_select('List', fullfile(matlabroot,subjects{i},'TEMP4'),'^s.*\.nii$'); % select images for the smooth
    anatomical = fullfile(matlabroot,subjects{i},'TEMP4',deblank(fnm(1,:)));  % image(s) to be smoothed (or 3D array)
    [p, nm, e v] = spm_fileparts(anatomical) ;
    outfilename = [p filesep 's' nm e]; %filename for smoothed image (or 3D array)
    spm_smooth(anatomical,outfilename,[4 4 4]); % T1 smooth
    
    S = spm_vol(outfilename); % Get header information for images
    %% Defaults for segmentation
        opts0.tpm           = char(...
        fullfile(spm('Dir'),'tpm','TPM.nii,1'),...
        fullfile(spm('Dir'),'tpm','TPM.nii,2'),...
        fullfile(spm('Dir'),'tpm','TPM.nii,3'),...
        fullfile(spm('Dir'),'tpm','TPM.nii,4'),...
        fullfile(spm('Dir'),'tpm','TPM.nii,5'),...
        fullfile(spm('Dir'),'tpm','TPM.nii,6'));% Prior probability maps
        opts0.biasreg       = 0.001;    % Bias regularisation
        opts0.biasfwhm      = 60;       % Bias FWHM
        opts0.write         = [0 0];
        opts0.channel.write = [0 0];
        opts0.ngaus         = [1 1 1 2 3 3 2];
        opts0.mrf           = 1;
        opts0.cleanup       = 1;
        opts0.reg           = [0 0.001 0.5 0.05 0.2];
        opts0.affreg        = 'mni';    % Affine Regularisation
        opts0.fwhm          = 0;
        opts0.samp          = 3;        % Sampling distance
        opts0.write         = [1 1];
        opts0.native        = [1 1];
        opts0.warped        = [1 1];    % Warping Regularisation
        results = spm_preproc(S,opts0);  %Combined Segmentation and Spatial Normalisation
        %% 
        
        opts_write = struct('biascor',1,'GM',[0 0 1],'WM',[0 0 1],'CSF',[0 0 1],'EXTRA1',[0 0 1],'EXTRA2',[0 0 1],...
            'cleanup',1);% this should be in one line in the script! spm_preproc_write
        
        [po,pin] = spm_prep2sn(results); %Convert the output from spm_preproc into an sn.mat file
        
        % save parameters (forward) :ranatomy_seg_sn.mat
        VG = po.VG;
        VF = po.VF;
        Tr = po.Tr;
        Affine = po.Affine;
        flags = po.flags;
        fnam = fullfile(matlabroot,subjects{i},'TEMP4',['anatomy' '_seg_sn.mat']);
        save(fnam,'-V6','VG','VF','Tr','Affine','flags');


        % save parameters (inverse): ranatomy_seg_inv_sn.mat
         VG = pin.VG;
         VF = pin.VF;
         Tr = pin.Tr;
         Affine = pin.Affine;
         flags = pin.flags;
         fnam = fullfile(matlabroot,subjects{i},'TEMP4',['anatomy' '_seg_inv_sn.mat']);
         save(fnam,'-V6','VG','VF','Tr','Affine','flags');
        
         spm_preproc_write(po,opts_write);  %Write out VBM preprocessed data

%         save(fullfile(fullfile(matlabroot,subjects{i},'TEMP4'),'inv_sn.mat'),'-STRUCT','isn');
%         save(fullfile(fullfile(matlabroot,subjects{i},'TEMP4'),'sn.mat'),'-STRUCT','sn');
end
disp('done Segment')
toc
% spm_load_priors
% spm_preproc8 % segment en spm8
% spm_preproc  % segment en spm12

%% 
%         obj.image = S;
%         obj.biasfwhm = 60;
%         obj.biasreg = 0.001;
%         obj.tpm = spm_load_priors(char(...
%                                     fullfile(spm('Dir'),'tpm','TPM.nii,1'),...
%                                     fullfile(spm('Dir'),'tpm','TPM.nii,2'),...
%                                     fullfile(spm('Dir'),'tpm','TPM.nii,3'),...
%                                     fullfile(spm('Dir'),'tpm','TPM.nii,4'),...
%                                     fullfile(spm('Dir'),'tpm','TPM.nii,5'),...
%                                     fullfile(spm('Dir'),'tpm','TPM.nii,6')));
%         obj.lkp = [1,1,2,2,3,3,4,4,5,5,5,5,6,6];
%         obj.Affine= 'nmi';
%         obj.reg = [0 0.001 0.5 0.05 0.2];
%         obj.samp = 3;
%         obj.fwhm = 0;
%         
%         results = spm_preproc8(obj)
%         cls = spm_preproc_write8(results)

        


