clc 
% clear all 
% close all
disp('******** beginning PROPIEDADES FRACTAL OF LESSIONS ********');
tic
%% 
matlabroot=fullfile(spm('Dir'),'toolbox','ACL','Study');
%% elegir varias poblaciones
poblacion = {'HC', 'LPD', 'RPD'};
for pobl = 1 : length (poblacion)

    [sb_files , subjects] = spm_select('List',char(fullfile(matlabroot,poblacion(pobl))));
    subjects = cellstr(subjects)'; % escojo todos los sujetos del estudio
    
    
for i=1 : length(subjects)
    fnm1 = spm_select('List', fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm'),'^WMrs.*\.nii$'); % select images for the smooth
    WMflair = char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm',deblank(fnm1(1,:))));  % image(s) to be smoothed (or 3D array)
    VolEtiq = char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm',deblank(fnm1(2,:))));  % image(s) to be smoothed (or 3D array)
     Vf = spm_vol(WMflair);
     imgf = spm_read_vols(Vf);
     V = spm_vol(VolEtiq);
     img = spm_read_vols(V);
     [n, r] = boxcount(imgf);
     df = -diff(log(n))./diff(log(r));
    disp(['Fractal dimension, Df = ' num2str(mean(df(4:8))) ' +/- ' num2str(std(df(4:8)))]);
end 
end
toc
disp('done fractalidad')