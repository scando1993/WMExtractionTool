%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 4252 $)
%-----------------------------------------------------------------------
matlabbatch{1}.spm.util.imcalc.input = {
                                        '/Users/orlando/Documents/MATLAB/TESIS/test/sb3/TEMP/s446223-0009-00001-000001-01.nii,1'
                                        '/Users/orlando/Documents/MATLAB/TESIS/test/sb3/TEMP/resc2ss446223-0008-00001-000001-01.nii,1'
                                        };
matlabbatch{1}.spm.util.imcalc.output = 'resWMxFlair36_SPM.nii';
matlabbatch{1}.spm.util.imcalc.outdir = {''};
matlabbatch{1}.spm.util.imcalc.expression = 'i1.*i2';
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 8;
matlabbatch{2}.spm.util.imcalc.input = {
                                        '/Users/orlando/Documents/MATLAB/TESIS/test/sb3/TEMP/rs446223-0009-00001-000001-01.nii,1'
                                        '/Users/orlando/Documents/MATLAB/TESIS/test/sb3/TEMP/c2ss446223-0008-00001-000001-01.nii,1'
                                        };
matlabbatch{2}.spm.util.imcalc.output = 'WMxresFLAIR160_SPM.nii';
matlabbatch{2}.spm.util.imcalc.outdir = {''};
matlabbatch{2}.spm.util.imcalc.expression = 'i1.*i2';
matlabbatch{2}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{2}.spm.util.imcalc.options.mask = 0;
matlabbatch{2}.spm.util.imcalc.options.interp = 1;
matlabbatch{2}.spm.util.imcalc.options.dtype = 8;
