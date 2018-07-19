function [ output_args ] = core_slice( route , data_folder)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
tic
disp('ACL Working Coregister: Estimate & Reslice\n');

matlabroot = route;
global Defaults;
Defaults = spm_get_defaults;

data_route = fullfile(matlabroot, data_folder);
[sb_files , subjects] = spm_select('List', data_route);

%     fnmtemplate = spm_select('List', fullfile(matlabroot,'TEMPLATES'),'^GG-366-T1-1.0mm.*\.nii$');
%     templateT1 = fullfile(matlabroot,'TEMPLATES',deblank(fnmtemplate));
%     VG = spm_vol(templateT1);
%%

for i = 1 : length(subjects(:,1))
%     defaults = spm_get_defaults;
    folder_temp = fullfile(data_route, subjects(i,:));
    [files , fol_sec] = spm_select('List', folder_temp);
    
    flair = char(fullfile(deblank(folder_temp), files(1,:)));
    anatomical = char(fullfile(deblank(folder_temp), files(2,:)));
    VF = spm_vol(anatomical);
    VE = spm_vol(flair);
    
    defaults.coreg.estimate.cost_fun = 'nmi';
    defaults.coreg.estimate.sep      = [4 2];
    defaults.coreg.estimate.tol      = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    defaults.coreg.estimate.fwhm     = [7 7];
    
    x = spm_coreg(VF,VE);
    
%     M2 = inv(spm_matrix(x));
%     PO2 = char(anatomical, flair);
%     MM2 = zeros(0,0,2);
%     for j = 1:size(PO2,1)
%         MM2(:,:,j) = spm_get_space(deblank(PO2(j,:)));
%     end
%     
%     parfor j = 2:size(PO2,1)
%         spm_get_space(deblank(PO2(j,:)), M2*MM2(:,:,j));
%     end
    spm_get_space(deblank(flair), spm_matrix(x)\spm_get_space(deblank(flair)));
    %
    resflags = struct(...b
        'mask',0,... % don't mask anything
        'mean',0,... % write mean image
        'which',1,... % write everything else
        'interp',1); % I forget... linear interp?
    imgs = [cellstr(anatomical); cellstr(flair)];
    %             cd(char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6')));
    spm_reslice(imgs,resflags); % reslices all images
    
    
end
disp('ACL Done Coregister: Estimate & Reslice');
toc

end

