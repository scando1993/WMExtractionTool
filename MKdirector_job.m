%-----------------------------------------------------------------------
% Job saved on 21-Oct-2013 08:39:30 by cfg_util (rev $Rev: 4972 $)
% spm SPM - SPM12b (5616)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
subjects={'sb1', 'sb2', 'sb3', 'sb4', 'sb5', 'sb6', 'sb7', 'sb8', 'sb9', 'sb10' };
matlabroot='/Users/orlando/Documents/MATLAB/TESIS/test';
for i=1: length(subjects)
    clear matlabbatch
% matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.parent = {'/Users/orlando/Documents/MATLAB/TESIS/test/sb1'};
matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.parent = cellstr(fullfile(matlabroot,subjects{i}))
matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.name = 'TEMP';
 try
         spm_jobman('serial',matlabbatch); %run the previously prepared spm task in batch serial mode
     catch
         fprintf('error during BRAIN EXTRACTION %s\n',fullfile(matlabroot,subjects{i}))
 end
end
