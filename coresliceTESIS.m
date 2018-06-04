%% 
subjects={'sb1', 'sb2', 'sb3', 'sb4', 'sb5', 'sb6', 'sb7', 'sb8', 'sb9', 'sb10' };
matlabroot='/Users/orlando/Documents/MATLAB/TESIS/test';
% clc; clear all
global Defaults;
Defaults = spm_get_defaults
%% 
for i=1: length(subjects)
    fnm = spm_select('List', fullfile(matlabroot,subjects{i},'TEMP6'),'^s.*\.nii$');
    anatomical = fullfile(matlabroot,subjects{i},'TEMP6',deblank(fnm(1,:)));
    flair = fullfile(matlabroot,subjects{i},'TEMP6',deblank(fnm(2,:)));
    VG = spm_vol(anatomical);
    VF = spm_vol(flair);
    %
    % flags= {[4 2];[0 0 0 0 0 0];'nmi';...
    %         [0.02 0.02 0.02 0.001 0.001 ...
    %         0.001 0.01 0.01 0.01 0.001 ...
    %         0.001 0.001];[7 7]};
        defaults.coreg.estimate.cost_fun = 'nmi';
        defaults.coreg.estimate.sep      = [4 2];
        defaults.coreg.estimate.tol      = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
        defaults.coreg.estimate.fwhm     = [7 7];


    x = spm_coreg(VG,VF);%,flags)
    % VF.mat\spm_matrix(x(:)')*VG.mat
    %

    M = inv(spm_matrix(x));
    PO = strvcat(anatomical,flair);
    for j = 1:size(PO,1)
     MM(:,:,j)=spm_get_space(deblank(PO(j,:)))
    end

    for j = 2:size(PO,1)
     spm_get_space(deblank(PO(j,:)), M*MM(:,:,j))
    end
    %
    resflags = struct(...b
          'mask',0,... % don't mask anything
          'mean',0,... % write mean image
          'which',1,... % write everything else
          'interp',1); % I forget... linear interp?
        imgs = [anatomical; flair]
    spm_reslice(imgs,resflags); % reslices all images
end
