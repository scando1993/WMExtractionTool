% List of open inputs
nrun = 1; % enter the number of runs here
jobfile = {'/Users/orlando/Documents/MATLAB/BATCH_nuevos/Mult_Vols_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(0, nrun);
for crun = 1:nrun
end
job_id = cfg_util('initjob', jobs);
sts    = cfg_util('filljob', job_id, inputs{:});
if sts
    cfg_util('run', job_id);
end
cfg_util('deljob', job_id);
