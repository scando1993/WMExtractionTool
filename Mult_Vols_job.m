%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 4252 $)
%-----------------------------------------------------------------------

matlabbatch{1}.spm.util.imcalc.input = {
                                        '/Users/orlando/Documents/MATLAB/TESIS/test/sb10/TEMP/rs122469-0011-00001-000001-01.nii,1'
                                        '/Users/orlando/Documents/MATLAB/TESIS/test/sb10/TEMP/c2ss122469-0010-00001-000001-01.nii,1'
                                        };
matlabbatch{1}.spm.util.imcalc.output = 'ResFlairXWM.nii';
matlabbatch{1}.spm.util.imcalc.outdir = {'/Users/orlando/Documents/MATLAB/TESIS/test/sb10/TEMP/'};
matlabbatch{1}.spm.util.imcalc.expression = 'i1.*i2';
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;

   
