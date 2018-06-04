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
clear all 
close all
disp('******** beginning PROPIEDADES FRACTAL OF LESSIONS ********');
tic
%% 
% subjects={'sb1', 'sb2', 'sb3', 'sb4', 'sb5', 'sb6', 'sb7', 'sb8', 'sb9', 'sb10' };
% matlabroot= fullfile(spm('Dir'),'toolbox','ACL','Study');
matlabroot = '/Users/orlando/Documents/MATLAB/TESIS/test';

%% 
filename = '14jul_pro_intesidad_promedio3.txt';
fid2 = fopen(filename, 'w');

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
     
     % imagen de intensidad
     % y resultados
% % % % % % % % %      fnm1 = spm_select('List', fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm'),'^urs.*\.nii$'); % select images for the smooth
% % % % % % % % %      uflair = char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm',deblank(fnm1(1,:))));  % image(s) to be smoothed (or 3D array)
% % % % % % % % %      Uf = spm_vol(uflair);
% % % % % % % % %      imgu = spm_read_vols(Uf);
% % % % % % % % %          LU = logical(img);
% % % % % % % % %          LX = double(LU);
% % % % % % % % %          
% % % % % % % % %          M_LES_INT = imgu.*LX;
% % % % % % % % %          M_LES_INT(M_LES_INT== 0) = [];
% % % % % % % % %           
% % % % % % % % %      fprintf(fid2, '%s %s %s %s %s\n', 'SUJETO# ',num2str(i),' con ',num2str(mean (M_LES_INT)),' promedio de intensidad');
% % % % % % % % %      
% % % % % % % % %      
% % % % % % % % %      
% % % % % % % % % end 
% % % % % % % % % end
% % % % % % % % % fclose(fid2);
     
     % [fds ics averFD averIC]= fdvolfft(D)
%         [n, r] = boxcount(imgf,'plot');
%         df = -diff(log(n))./diff(log(r));
%         mean(df(4:8))
%         FD(l-10)  = mean(df(4:8))
     

     %% imrimir lesiones en vlumen
%  ColorSpec funcion para escoger color en RGB
 % imprime lessiones
% hold on
% figNumber=figure;
% colordef(figNumber,'white');
% set(gcf,'InvertHardcopy','off')
% cla

 img=round(img+10); % se le suma 10 para poder imprimir las primeras lesiones
 min(min(min(img))); % calculo el minimo para corroborar
 nunofless = max(max(max(img)))-10;
 %FDX  = zeros(1,nunofless);
 FD = zeros(1,nunofless);
  for l=11 : max(max(max(img)))
      
    figNumber=figure;
    colordef(figNumber,'white');
    set(gcf,'InvertHardcopy','off')
    cla
      
     LL=img;
    
     LL(LL~=l) = 0; % elimino el resto de lesiones solo dejo la que me interesa
D=LL;
     
D = squeeze(D);  % exprimo de 4D a 3D
[x, y, z, D] = subvolume(D, [nan nan nan nan nan 160]); 
% [x,y,z,D] = subvolume(D,[nan,nan,nan,60,nan,nan]); % 60 y 100 son limites en x , cuando pongo NaN estoy cogiendo todo  
p = patch(isosurface(x,y,z,D, 5), 'FaceColor', [round(rand) round(rand) round(rand)], 'EdgeColor', 'none');
patch(isocaps(x,y,z,D, 5), 'FaceColor', 'interp', 'EdgeColor', 'none');
isonormals(x,y,z,D,p);
view(3)
daspect([1 1 1])
colormap(gray(100))
camva('manual')
box on
 camlight(40, 40)
 camlight(-20,-10)
lighting flat
%close all % cierro todo
% [fds ics averFD averIC]= fdvolfft(D)
%         [n, r] = boxcount(D);
%         df = -diff(log(n))./diff(log(r));
%         mean(df(4:8))
% FD(l-10)  = mean(df(4:8))


RED = LL;
Mtrim = trim_Lesion ( RED );
RED = Mtrim;
%   


%close all % cierro todo
% [fds ics averFD averIC]= fdvolfft(D)
%         [n, r] = boxcount(RED);
%         df = -diff(log(n))./diff(log(r));
%         mean(df)
        
        
%         c = randcantor(0.7, 2^7, 3);
%         boxcount(RED, 'slope');
%         [n, r] = boxcount(RED,'plot');
%         df = -diff(log(n))./diff(log(r));
%         df;
% %         D = squeeze(RED);
% %         
% %         [fds, ics, averFD, averIC] = fdvolfft(D)
%  FD(l-10)  = mean(df);

 

         J = expand3M(RED);
%         figNumber=figure;
%     colordef(figNumber,'white');
%     set(gcf,'InvertHardcopy','off')
%     cla
%     D=J;
%      
% D = squeeze(D);  % exprimo de 4D a 3D
% [x, y, z, D] = subvolume(D, [nan nan nan nan nan nan]); 
% % [x,y,z,D] = subvolume(D,[nan,nan,nan,60,nan,nan]); % 60 y 100 son limites en x , cuando pongo NaN estoy cogiendo todo  
% p = patch(isosurface(x,y,z,D, 5), 'FaceColor', [round(rand) round(rand) round(rand)], 'EdgeColor', 'none');
% patch(isocaps(x,y,z,D, 5), 'FaceColor', 'interp', 'EdgeColor', 'none');
% isonormals(x,y,z,D,p);
% view(3)
% daspect([1 1 1])
% colormap(gray(100))
% camva('manual')
% box on
%  camlight(40, 40)
%  camlight(-20,-10)
% lighting flat
       
        [n, r] = boxcount(J);
        df = -diff(log(n))./diff(log(r));
%         med = mean (df);
%         mayores = find(df>med);
%         FD = mean (mayores);
%         FD = max (df)
        FD(l-10) = max (df);
        close all;
  end
  FD
  FD(isnan(FD)) = []; % use ~ isfinite instead of isnan to replace +/-inf with zero
     %% 
     
     fprintf(fid2, '%s %s %s %s %s\n', 'SUJETO# ',num2str(i),' con ',num2str(sum(FD)/length(FD)),' promedio de fractalidad');

end
end
fclose(fid2);
disp('done')
toc

% type infdelessMNI.txt