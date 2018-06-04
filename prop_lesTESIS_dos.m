function prop_lesTESIS_dos (ruta,type,space,nombresdepoblacion)
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
% clc 
% clear all 
% close all

disp('********ACL beginning PROPIEDADES OF LESSIONS ********');
tic
%% 
matlabroot = ruta;
% matlabroot='/Users/orlando/Documents/MATLAB/TESIS/test';

%% creo los archivos de acuerdo a el tipo de caracteristica y espacio en que requiero 

filename = strcat('14jul_result_',type,space,'.txt');
fid2 = fopen(filename, 'w');
if strcmp(space,'NE');
    ty = '^WMrs.*\.nii$';
else
    ty = '^wnormWMrs.*\.nii$';
end
    %% Talairach
    if strcmp (type,'talairach');
          segment_HemisphereTESIS_dos(ruta,nombresdepoblacion);
          segment_regionTESISdos(ruta,nombresdepoblacion);
          prop_les_regionTESIS_dos(ruta,nombresdepoblacion)
    end
    if strcmp (type,'intensidad');
        intensity_norm (ruta,nombresdepoblacion);
        prop_intensidad(ruta,nombresdepoblacion);
    
    else
        
    

%% elegir varias poblaciones
poblacion = nombresdepoblacion;%{'HC', 'LPD', 'RPD'};
for pobl = 1 : length (poblacion)

    [sb_files , subjects] = spm_select('List',fullfile(matlabroot,poblacion(pobl)));
    subjects = cellstr(subjects)'; % escojo todos los sujetos del estudio
    
    
for i=1 : length(subjects)
    fnm1 = spm_select('List', fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm'),ty); % select images for the smooth
    WMflair = char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm',deblank(fnm1(1,:))));  % image(s) to be smoothed (or 3D array)
    VolEtiq = char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm',deblank(fnm1(2,:))));  % image(s) to be smoothed (or 3D array)
%     nii_32bit (WMflair);
%     fnm2 = spm_select('List', fullfile(matlabroot,subjects{i},'TEMP6'),'^rs.*\.nii$');
%     rsflair = fullfile(matlabroot,subjects{i},'TEMP6',deblank(fnm2));  % image(s) to be smoothed (or 3D array)
%     nii_32bit (rsflair);
     Vf = spm_vol(WMflair);
     imgf = spm_read_vols(Vf);
     V = spm_vol(VolEtiq);
     img = spm_read_vols(V);
     %% cantidad de lesiones
     if strcmp (type,'cantidad');
     img=round(img);
     
     fprintf(fid2, '%s %s %s %s %s\n', 'SUJETO# ',num2str(i),' con ',num2str(max(max(max(img)))),' lessions');
     end
     
     
     %% 
     % agregar intensidad para normalizar al espacio NMI y no perder informacion
%      [pth bnm ext] = spm_fileparts(WMflair);
%     VO = Vf; % copy input info for output image
%     VO.fname = fullfile(pth, ['norm' bnm ext]);
%     L = logical(img);
%     LX= double(L)*100;
%     imgf = imgf + LX;
%     spm_write_vol(VO,imgf); % guardo volumen logico como .nii
%% Intensidad
%     if strcmp (type,'intensidad');
%              % imagen de intensidad
%      % y resultados
%      intensity_norm (ruta,nombresdepoblacion)
%      
%      
%      fnm1 = spm_select('List', fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm'),'^urs.*\.nii$'); % select images for the smooth
%      uflair = char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm',deblank(fnm1(1,:))));  % image(s) to be smoothed (or 3D array)
%      Uf = spm_vol(uflair);
%      imgu = spm_read_vols(Uf);
%          LU = logical(img);
%          LX = double(LU);
%          
%          M_LES_INT = imgu.*LX
%          M_LES_INT(M_LES_INT== 0) = [];
%           
%      fprintf(fid2, '%s %s %s %s %s\n', 'SUJETO# ',num2str(i),' con ',num2str(mean (M_LES_INT)),' promedio de intensidad');
%     end
%% Fractal dimension
    if strcmp (type,'fractalidad');
    
%     D=img;
%     D = squeeze(D) ;
%     [fds ics averFD averIC]= fdvolfft(D)
%     fprintf(fid2, '%s %s %s %s %s\n', 'SUJETO# ',num2str(i),' con ',num2str(averFD),' dimFractal');
        img=round(img+10); % se le suma 10 para poder imprimir las primeras lesiones
 nunofless = max(max(max(img)))-10;
 FD = zeros(1,nunofless);
  for l=11 : max(max(max(img)))    
        LL=img;
        LL(LL~=l) = 0; % elimino el resto de lesiones solo dejo la que me interesa
        RED = LL;
        Mtrim = trim_Lesion ( RED );
        RED = Mtrim;
        J = expand3M(RED);
        [n, r] = boxcount(J);
        df = -diff(log(n))./diff(log(r));
        FD(l-10) = max (df);
  end
    FD(isnan(FD)) = []; % use ~ isfinite instead of isnan to replace +/-inf with zero 
    fprintf(fid2, '%s %s %s %s %s\n', 'SUJETO# ',num2str(i),' con ',num2str(sum(FD)/length(FD)),' promedio de fractalidad');

     
    end
    
%% imrimir lesiones en vlumen
    if strcmp (type,'volumen');

     
      
figNumber=figure;
colordef(figNumber,'white');
set(gcf,'InvertHardcopy','off')

cla
LZ=imgf;
%  LZ(:,:,1:30)=[];
%  LZ(:,:,100:130)=[];
% imgreshape = reshape(LZ,192,2304);
D=LZ;
D = squeeze(D);
[x, y, z, D] = subvolume(D, [nan nan nan nan nan 160]);
% [x,y,z,D] = subvolume(D,[nan,nan,nan,60,nan,nan]);
p = patch(isosurface(x,y,z,D, 5), 'FaceColor', 'black', 'EdgeColor', 'none');
patch(isocaps(x,y,z,D, 5), 'FaceColor', 'interp', 'EdgeColor', 'none');
isonormals(x,y,z,D,p);
view(3)
daspect([1 1 1])    % setea los ejes de 0 a 1
colormap(gray(100)) % color interno 
camva('manual')
box on
camlight(40, 40) % iluminacion
camlight(-20,-10)% iluminacion
% % lighting phong, alpha(.5) 
  lighting gouraud , alpha(.09)   %  me da la transparencia alpha(.5)
 
 
%  ColorSpec funcion para escoger color en RGB
 % imprime lessiones
% hold on
 img=round(img+10);
 min(min(min(img)));
  for l=11 : max(max(max(img)))

% % imrimir lesions en box      
% figNumber=figure;
% colordef(figNumber,'white');
% set(gcf,'InvertHardcopy','off')
% cla
      
     LL=img;
    
     LL(LL~=l) = 0;
%  LZ(:,:,1:30)=[];
%  LZ(:,:,100:130)=[];
D=LL;
% label2rgb(la1)
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
%  light('Position',[0 1 0],'Style','infinite');
lighting flat%, alpha(1) 
%   lighting gouraud
  end
 
% print('-dtiff','-r200',fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm','lessions') );
% saveas(figNumber,fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm','lessions'))
     %% 
     
%      find
     ICJ = img;
     ICJ(ICJ==0) = [];
     mx = -Inf;
    mn =  Inf;
    imgt = ICJ;
    msk = find(isfinite(imgt));
    mx  = max([max(imgt(msk)) mx]);
    mn  = min([min(imgt(msk)) mn]);
    % compute histograms..
    x = [mn:1:mx];
    n = zeros(size(x));
    imgt = ICJ;
    msk = find(isfinite(imgt));
    n   = n+hist(imgt(msk),x);
    n(1)=0;
%     figure
%     plot(x,n)
    
    title(['SUJETO# ',num2str(i),' con ',num2str(sum(n)/1000),' cmm3 de lessions']);
     disp(['SUJETO# ',num2str(i),' con ',num2str(sum(n)/1000),' cmm3 de lessions']); 
     fprintf(fid2, '%s %s %s %s %s\n', 'SUJETO# ',num2str(i),' con ',num2str(sum(n)/1000),' cmm3 de lessions');
%      
% 	[n, x] = histvol(V, 256);
%     n(1)=0;
% 	figure;
% 	bar(x,n);
     end
     
end
end
    end
fclose(fid2);
disp('ACL done PROPIEDADES OF LESSIONS')
toc
% type (strcat('result_',type,space,'.txt'))


