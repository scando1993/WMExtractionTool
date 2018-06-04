% function prop_fractal_lesTESIS_dos
% Batch que sirve para segementar lesiones, tomando encuenta el histograma
% encontrando la moda y la media
% donde cada paciente necesita tener segementada la materia Blanca de la
% FLAIR.
%__________________________________________________________________________
% ESPOL     FIEC & FIMCP    NBL"Neuroimaging & Bioengineering Laboratory"

% Orlando Chancay
% $Id: seg_lesTESIS.m  25-Nov-2013  9:48:13z$
%% Prpop de lesiones:Volumen, Orientacion, intesidad, fractal dimension
%% 
clc 
disp('******** beginning PROPIEDADES FRACTAL OF LESSIONS ********');
tic
%% 
% subjects={'sb1', 'sb2', 'sb3', 'sb4', 'sb5', 'sb6', 'sb7', 'sb8', 'sb9', 'sb10' };
% matlabroot= fullfile(spm('Dir'),'toolbox','ACL','Study');
matlabroot = '/Users/orlando/Documents/MATLAB/TESIS/test';

%% 
filename = 'fractalidad_WM_total.txt';
fid2 = fopen(filename, 'w');

%% elegir varias poblaciones
poblacion = {'HC', 'LPD', 'RPD'};
for pobl = 1 : length (poblacion)

    [sb_files , subjects] = spm_select('List',char(fullfile(matlabroot,poblacion(pobl))));
    subjects = cellstr(subjects)'; % escojo todos los sujetos del estudio
    
    
for i=1 : length(subjects)
    fnm1 = spm_select('List', fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm'),'^WMrs.*\.nii$'); % select images for the smooth
    WMflair = char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm',deblank(fnm1(1,:))));  % image(s) to be smoothed (or 3D array)
    
    fnm1 = spm_select('List', fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm'),'^wnormWMrs.*\.nii$'); % select images for the smooth
    WMflairnorm = char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm',deblank(fnm1(1,:))));  % image(s) to be smoothed (or 3D array)
    
    Vf = spm_vol(WMflair);
    imgNE = spm_read_vols(Vf);
     V = spm_vol(WMflairnorm);
     imgMNI = spm_read_vols(V);
     
     
        [n, r] = boxcount(imgNE);
        df = -diff(log(n))./diff(log(r));
         DFNE = mean(df(4:8));
        disp(['Fractal dimension, DFNE = ' num2str(mean(df(4:8))) ' +/- ' num2str(std(df(4:8)))]);
 
        [n, r] = boxcount(imgMNI);
        df = -diff(log(n))./diff(log(r));
         DFMNI = mean(df(4:8));
        disp(['Fractal dimension, DFMNI = ' num2str(mean(df(4:8))) ' +/- ' num2str(std(df(4:8)))]);
     
      fprintf(fid2, '%s %s %s %s\n', 'SUJETO# ',num2str(i),num2str(DFNE),num2str(DFMNI));

end
end
fclose(fid2);
disp('done')
toc

% type infdelessMNI.txt