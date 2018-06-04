
matlabroot='/Users/orlando/Documents/MATLAB/TESIS/test';

poblacion = {'HC', 'LPD', 'RPD'};
for pobl = 1 : length (poblacion)

    [sb_files , subjects] = spm_select('List',fullfile(matlabroot,poblacion(pobl)));
    subjects = cellstr(subjects)'; % escojo todos los sujetos del estudio

    
 for i=1:length(subjects)   
    
[filesB,dirsB] = spm_select('List', fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm'),'^WMrs.*\.nii$') % select contenido of each folder
    [fsf csf] = size(dirsB);
    %% eliminar files de culquier localidad

%     fil_to_elim = char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm',deblank(filesB(3,:))))
%     delete(fil_to_elim)
%% elimina folders de cualquier localidad 


% [status, message, messageid] = rmdir(char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm',deblank(filesB(3,:)))),'s') ;

 end
end