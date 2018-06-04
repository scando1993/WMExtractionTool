

matlabroot='/Users/orlando/Documents/MATLAB/TESIS/test';
poblacion = {'HC', 'LPD', 'RPD'};
for pobl = 1 : length (poblacion)

    [sb_files , subjects] = spm_select('List',fullfile(matlabroot,poblacion(pobl)));
    subjects = cellstr(subjects)'; % escojo todos los sujetos del estudio
    
%% 


for i=1:length(subjects)
% %     
    fnm1 = spm_select('List', fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t1_mprage_TRA_1x1x1'),'^u_rc2ss.*\.nii$'); % select images for the smooth
    name1 = char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t1_mprage_TRA_1x1x1',deblank(fnm1(1,:))));  % image(s) to be smoothed (or 3D array)
%     
matlabbatch{1}.spm.tools.dartel.crt_iwarped.flowfields = {name1};
matlabbatch{1}.spm.tools.dartel.crt_iwarped.images = {'/Users/orlando/Documents/MATLAB/TESIS/test/TEMPLATES/atlas_wm.nii'};
matlabbatch{1}.spm.tools.dartel.crt_iwarped.K = 6;
matlabbatch{1}.spm.tools.dartel.crt_iwarped.interp = 4;
spm_jobman('serial',matlabbatch);
clear matlabbatch;
% %     
    fnm5 = spm_select('List', fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t1_mprage_TRA_1x1x1'),'^c2ss.*\.nii$'); % select images for the smooth
    name5 = char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t1_mprage_TRA_1x1x1',deblank(fnm5(1,:))));  % image(s) to be smoothed (or 3D array)
% %     
% matlabbatch{1}.spm.spatial.coreg.estimate.ref = {name5};
% %     
    fnm2 = spm_select('List', fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t1_mprage_TRA_1x1x1'),'^watlas_wm_u_rc2ss.*\.nii$'); % select images for the smooth
    name2 = char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t1_mprage_TRA_1x1x1',deblank(fnm2(1,:))));  % image(s) to be smoothed (or 3D array)
% %     
% matlabbatch{1}.spm.spatial.coreg.estimate.source = {name2};
% matlabbatch{1}.spm.spatial.coreg.estimate.other = {''};
% matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
% matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
% matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
% matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
% spm_jobman('serial',matlabbatch);
% clear matlabbatch;

matlabbatch{1}.spm.spatial.coreg.estwrite.ref = {name5};
matlabbatch{1}.spm.spatial.coreg.estwrite.source = {name2};
matlabbatch{1}.spm.spatial.coreg.estwrite.other = {''};
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.interp = 4;
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.mask = 0;
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.prefix = 'r';
spm_jobman('serial',matlabbatch);
clear matlabbatch;

%     
    fnm3 = spm_select('List', fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm'),'^WMrs.*\.nii$'); % select images for the smooth
    name3 = char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm',deblank(fnm3(1,:))));  % image(s) to be smoothed (or 3D array)
%  
%     
    fnmx = spm_select('List', fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t1_mprage_TRA_1x1x1'),'^rwatlas_wm_u_rc2ss.*\.nii$'); % select images for the smooth
    namex = char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t1_mprage_TRA_1x1x1',deblank(fnmx(1,:))));  % image(s) to be smoothed (or 3D array)
%     
matlabbatch{1}.spm.util.imcalc.input = {
                                        name3
                                        namex
                                        };
matlabbatch{1}.spm.util.imcalc.output = 'TPMxWM.nii';
%     

    name4 = char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm'));  % image(s) to be smoothed (or 3D array)
%    

matlabbatch{1}.spm.util.imcalc.outdir = {name4};
matlabbatch{1}.spm.util.imcalc.expression = 'i1.*i2';
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
spm_jobman('serial',matlabbatch);
clear matlabbatch;




%% para haverlo a 36 cortes
%     
    fnm6 = spm_select('List', fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm'),'^s.*\.nii$'); % select images for the smooth
    name6 = char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm',deblank(fnm6(1,:))));  % image(s) to be smoothed (or 3D array)
%  
matlabbatch{1}.spm.spatial.coreg.write.ref = {name6};
%     
    fnm7 = spm_select('List', fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm'),'^TPMxWM.*\.nii$'); % select images for the smooth
    name7 = char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm',deblank(fnm7(1,:))));  % image(s) to be smoothed (or 3D array)
%  
matlabbatch{1}.spm.spatial.coreg.write.source = {name7};
matlabbatch{1}.spm.spatial.coreg.write.roptions.interp = 4;
matlabbatch{1}.spm.spatial.coreg.write.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.coreg.write.roptions.mask = 0;
matlabbatch{1}.spm.spatial.coreg.write.roptions.prefix = 'r';
spm_jobman('serial',matlabbatch);
clear matlabbatch;
end
end



