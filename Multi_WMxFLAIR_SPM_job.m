%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 4252 $)
%-----------------------------------------------------------------------
matlabbatch{1}.spm.util.imcalc.input = {
                                        '/Users/orlando/Documents/MATLAB/TESIS/test/sb1/TEMP/s572978-0004-00001-000036-01.nii,1'
                                        '/Users/orlando/Documents/MATLAB/TESIS/test/sb1/TEMP/resc2ss572978-0002-00001-000001-01.nii,1'
                                        };
matlabbatch{1}.spm.util.imcalc.output = 'resWMxFlair36_SPM.nii';
matlabbatch{1}.spm.util.imcalc.outdir = {''};
matlabbatch{1}.spm.util.imcalc.expression = 'i1.*i2';
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 8;
matlabbatch{2}.spm.util.imcalc.input = {
                                        '/Users/orlando/Documents/MATLAB/TESIS/test/sb1/TEMP/rs572978-0004-00001-000036-01.nii,1'
                                        '/Users/orlando/Documents/MATLAB/TESIS/test/sb1/TEMP/c2ss572978-0002-00001-000001-01.nii,1'
                                        };
matlabbatch{2}.spm.util.imcalc.output = 'WMxresFLAIR160_SPM.nii';
matlabbatch{2}.spm.util.imcalc.outdir = {''};
matlabbatch{2}.spm.util.imcalc.expression = 'i1.*i2';
matlabbatch{2}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{2}.spm.util.imcalc.options.mask = 0;
matlabbatch{2}.spm.util.imcalc.options.interp = 1;
matlabbatch{2}.spm.util.imcalc.options.dtype = 8;
