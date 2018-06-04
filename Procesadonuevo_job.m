%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 4252 $)
%-----------------------------------------------------------------------
subjects={'sb1', 'sb2', 'sb3', 'sb4', 'sb5', 'sb6', 'sb7', 'sb8', 'sb9', 'sb10','sb11' };
matlabroot = '/Users/orlando/Documents/MATLAB/TESIS/test'
clear matlabbatch;
clear av_files;
matlabbatch = cell(1,5);
i=11;
av_files = dir(fullfile(matlabroot,subjects{i},'TEMP')); %selecionar los archivos de TEMP en el sujeto i...
matlabbatch{1}.spm.spatial.coreg.estimate.ref = {fullfile(matlabroot,subjects{i},'TEMP',av_files(3,1).name)};
matlabbatch{1}.spm.spatial.coreg.estimate.source = {fullfile(matlabroot,subjects{i},'TEMP',av_files(4,1).name)};
matlabbatch{1}.spm.spatial.coreg.estimate.other = {''};
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
matlabbatch{2}.spm.spatial.smooth.data = {fullfile(matlabroot,subjects{i},'TEMP',av_files(3,1).name)};
matlabbatch{2}.spm.spatial.smooth.fwhm = [4 4 4];
matlabbatch{2}.spm.spatial.smooth.dtype = 8;
matlabbatch{2}.spm.spatial.smooth.im = 0;
matlabbatch{2}.spm.spatial.smooth.prefix = 's';
matlabbatch{3}.spm.tools.preproc8.channel.vols(1) = cfg_dep;
matlabbatch{3}.spm.tools.preproc8.channel.vols(1).tname = 'Volumes';
matlabbatch{3}.spm.tools.preproc8.channel.vols(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{3}.spm.tools.preproc8.channel.vols(1).tgt_spec{1}(1).value = 'image';
matlabbatch{3}.spm.tools.preproc8.channel.vols(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{3}.spm.tools.preproc8.channel.vols(1).tgt_spec{1}(2).value = 'e';
matlabbatch{3}.spm.tools.preproc8.channel.vols(1).sname = 'Smooth: Smoothed Images';
matlabbatch{3}.spm.tools.preproc8.channel.vols(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{3}.spm.tools.preproc8.channel.vols(1).src_output = substruct('.','files');
matlabbatch{3}.spm.tools.preproc8.channel.biasreg = 0.0001;
matlabbatch{3}.spm.tools.preproc8.channel.biasfwhm = 60;
matlabbatch{3}.spm.tools.preproc8.channel.write = [0 0];
matlabbatch{3}.spm.tools.preproc8.tissue(1).tpm = {'/Users/orlando/Documents/MATLAB/spm8/toolbox/Seg/TPM.nii,1'};
matlabbatch{3}.spm.tools.preproc8.tissue(1).ngaus = 2;
matlabbatch{3}.spm.tools.preproc8.tissue(1).native = [1 1];
matlabbatch{3}.spm.tools.preproc8.tissue(1).warped = [1 1];
matlabbatch{3}.spm.tools.preproc8.tissue(2).tpm = {'/Users/orlando/Documents/MATLAB/spm8/toolbox/Seg/TPM.nii,2'};
matlabbatch{3}.spm.tools.preproc8.tissue(2).ngaus = 2;
matlabbatch{3}.spm.tools.preproc8.tissue(2).native = [1 1];
matlabbatch{3}.spm.tools.preproc8.tissue(2).warped = [1 1];
matlabbatch{3}.spm.tools.preproc8.tissue(3).tpm = {'/Users/orlando/Documents/MATLAB/spm8/toolbox/Seg/TPM.nii,3'};
matlabbatch{3}.spm.tools.preproc8.tissue(3).ngaus = 2;
matlabbatch{3}.spm.tools.preproc8.tissue(3).native = [1 1];
matlabbatch{3}.spm.tools.preproc8.tissue(3).warped = [1 1];
matlabbatch{3}.spm.tools.preproc8.tissue(4).tpm = {'/Users/orlando/Documents/MATLAB/spm8/toolbox/Seg/TPM.nii,4'};
matlabbatch{3}.spm.tools.preproc8.tissue(4).ngaus = 3;
matlabbatch{3}.spm.tools.preproc8.tissue(4).native = [1 0];
matlabbatch{3}.spm.tools.preproc8.tissue(4).warped = [0 0];
matlabbatch{3}.spm.tools.preproc8.tissue(5).tpm = {'/Users/orlando/Documents/MATLAB/spm8/toolbox/Seg/TPM.nii,5'};
matlabbatch{3}.spm.tools.preproc8.tissue(5).ngaus = 4;
matlabbatch{3}.spm.tools.preproc8.tissue(5).native = [1 0];
matlabbatch{3}.spm.tools.preproc8.tissue(5).warped = [0 0];
matlabbatch{3}.spm.tools.preproc8.tissue(6).tpm = {'/Users/orlando/Documents/MATLAB/spm8/toolbox/Seg/TPM.nii,6'};
matlabbatch{3}.spm.tools.preproc8.tissue(6).ngaus = 2;
matlabbatch{3}.spm.tools.preproc8.tissue(6).native = [0 0];
matlabbatch{3}.spm.tools.preproc8.tissue(6).warped = [0 0];
matlabbatch{3}.spm.tools.preproc8.warp.mrf = 0;
matlabbatch{3}.spm.tools.preproc8.warp.reg = 4;
matlabbatch{3}.spm.tools.preproc8.warp.affreg = 'mni';
matlabbatch{3}.spm.tools.preproc8.warp.samp = 3;
matlabbatch{3}.spm.tools.preproc8.warp.write = [1 1];
matlabbatch{4}.spm.spatial.coreg.estwrite.ref(1) = cfg_dep;
matlabbatch{4}.spm.spatial.coreg.estwrite.ref(1).tname = 'Reference Image';
matlabbatch{4}.spm.spatial.coreg.estwrite.ref(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{4}.spm.spatial.coreg.estwrite.ref(1).tgt_spec{1}(1).value = 'image';
matlabbatch{4}.spm.spatial.coreg.estwrite.ref(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{4}.spm.spatial.coreg.estwrite.ref(1).tgt_spec{1}(2).value = 'e';
matlabbatch{4}.spm.spatial.coreg.estwrite.ref(1).sname = 'Coregister: Estimate: Coregistered Images';
matlabbatch{4}.spm.spatial.coreg.estwrite.ref(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{4}.spm.spatial.coreg.estwrite.ref(1).src_output = substruct('.','cfiles');
matlabbatch{4}.spm.spatial.coreg.estwrite.source(1) = cfg_dep;
matlabbatch{4}.spm.spatial.coreg.estwrite.source(1).tname = 'Source Image';
matlabbatch{4}.spm.spatial.coreg.estwrite.source(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{4}.spm.spatial.coreg.estwrite.source(1).tgt_spec{1}(1).value = 'image';
matlabbatch{4}.spm.spatial.coreg.estwrite.source(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{4}.spm.spatial.coreg.estwrite.source(1).tgt_spec{1}(2).value = 'e';
matlabbatch{4}.spm.spatial.coreg.estwrite.source(1).sname = 'New Segment: c2 Images';
matlabbatch{4}.spm.spatial.coreg.estwrite.source(1).src_exbranch = substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{4}.spm.spatial.coreg.estwrite.source(1).src_output = substruct('.','tiss', '()',{2}, '.','c', '()',{':'});
matlabbatch{4}.spm.spatial.coreg.estwrite.other = {''};
matlabbatch{4}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
matlabbatch{4}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
matlabbatch{4}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{4}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
matlabbatch{4}.spm.spatial.coreg.estwrite.roptions.interp = 1;
matlabbatch{4}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
matlabbatch{4}.spm.spatial.coreg.estwrite.roptions.mask = 0;
matlabbatch{4}.spm.spatial.coreg.estwrite.roptions.prefix = 'res';
matlabbatch{5}.spm.spatial.coreg.estwrite.ref = {fullfile(matlabroot,subjects{i},'TEMP',av_files(3,1).name)};
matlabbatch{5}.spm.spatial.coreg.estwrite.source(1) = cfg_dep;
matlabbatch{5}.spm.spatial.coreg.estwrite.source(1).tname = 'Source Image';
matlabbatch{5}.spm.spatial.coreg.estwrite.source(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{5}.spm.spatial.coreg.estwrite.source(1).tgt_spec{1}(1).value = 'image';
matlabbatch{5}.spm.spatial.coreg.estwrite.source(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{5}.spm.spatial.coreg.estwrite.source(1).tgt_spec{1}(2).value = 'e';
matlabbatch{5}.spm.spatial.coreg.estwrite.source(1).sname = 'Coregister: Estimate: Coregistered Images';
matlabbatch{5}.spm.spatial.coreg.estwrite.source(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{5}.spm.spatial.coreg.estwrite.source(1).src_output = substruct('.','cfiles');
matlabbatch{5}.spm.spatial.coreg.estwrite.other = {''};
matlabbatch{5}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
matlabbatch{5}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
matlabbatch{5}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{5}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
matlabbatch{5}.spm.spatial.coreg.estwrite.roptions.interp = 1;
matlabbatch{5}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
matlabbatch{5}.spm.spatial.coreg.estwrite.roptions.mask = 0;
matlabbatch{5}.spm.spatial.coreg.estwrite.roptions.prefix = 'r';
try
        i
        spm_jobman('serial',matlabbatch); %run the previously prepared spm task in batch serial mode
    catch
        fprintf('error during NEWSEGMENT %s\n',fullfile(matlabroot,subjects{i}))
end
disp('******** end NewSegment ********');
