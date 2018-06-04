% List of open inputs
% Coregister: Estimate & Reslice: Reference Image - cfg_files
% Coregister: Estimate & Reslice: Source Image - cfg_files
nrun = X; % enter the number of runs here
jobfile = {'/Users/orlando/Documents/MATLAB/spm12b/toolbox/ACL/batch/coregestand reslice_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(2, nrun);
for crun = 1:nrun
    inputs{1, crun} = MATLAB_CODE_TO_FILL_INPUT; % Coregister: Estimate & Reslice: Reference Image - cfg_files
    inputs{2, crun} = MATLAB_CODE_TO_FILL_INPUT; % Coregister: Estimate & Reslice: Source Image - cfg_files
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
