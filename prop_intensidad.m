function prop_intensidad(ruta,nombresdepoblacion)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
disp('******** beginning PROP INTESITY OF LESSIONS ********');
tic
%% 
% subjects={'sb1', 'sb2', 'sb3', 'sb4', 'sb5', 'sb6', 'sb7', 'sb8', 'sb9', 'sb10' };
% matlabroot= fullfile(spm('Dir'),'toolbox','ACL','Study');
matlabroot = ruta;%'/Users/orlando/Documents/MATLAB/TESIS/test';

%% 
filename = '14jul_pro_intesidad_promedio.txt';
fid2 = fopen(filename, 'w');

%% elegir varias poblaciones
poblacion = nombresdepoblacion;%{'HC', 'LPD', 'RPD'};
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
     
     
     
     % imagen de intensidad
     % y resultados
    fnm1 = spm_select('List', fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm'),'^urs.*\.nii$'); % select images for the smooth
    uflair = char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm',deblank(fnm1(1,:))));  % image(s) to be smoothed (or 3D array)
    Uf = spm_vol(uflair);
    imgu = spm_read_vols(Uf);
         
         LU = logical(img);
         LX = double(LU);
         
         figure,imshow(LX(:,:,80))
         imagesc(imgu(:,:,80)),colormap(gray)
         
         M_LES_INT = imgu.*LX;
         
         imagesc(M_LES_INT(:,:,80)),colormap(gray)
         
         M_LES_INT(M_LES_INT== 0) = [];
          
     fprintf(fid2, '%s %s %s %s %s\n', 'SUJETO# ',num2str(i),' con ',num2str(mean (M_LES_INT)),' promedio de intensidad');
     
     
     
end 
end
fclose(fid2);


end

