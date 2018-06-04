function prop_les_regionTESIS_dos(rut,gr)
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
disp('******** beginning PROPIEDADES OF LESSIONS ********');
tic
%% 
% subjects={'sb1', 'sb2', 'sb3', 'sb4', 'sb5', 'sb6', 'sb7', 'sb8', 'sb9', 'sb10' };
matlabroot= rut;%'/Users/orlando/Documents/MATLAB/TESIS/test';

%% 

filename1 = '14jul_ninf_region21-sb1.txt';
filename2 = '14jul_ninf_region22-sb1.txt';
filename3 = '14jul_ninf_region23-sb1.txt';
filename4 = '14jul_ninf_region24-sb1.txt';
filename5 = '14jul_ninf_region25-sb1.txt';
filename6 = '14jul_ninf_region26-sb1.txt';
filename7 = '14jul_ninf_region27-sb1.txt';
filename8 = '14jul_ninf_region28-sb1.txt';
fid1 = fopen(filename1, 'w');
fid2 = fopen(filename2, 'w');
fid3 = fopen(filename3, 'w');
fid4 = fopen(filename4, 'w');
fid5 = fopen(filename5, 'w');
fid6 = fopen(filename6, 'w');
fid7 = fopen(filename7, 'w');
fid8 = fopen(filename8, 'w');

%% elegir varias poblaciones
poblacion = gr; %{'HC', 'LPD', 'RPD'};
for pobl = 1 : length (poblacion)

    [sb_files , subjects] = spm_select('List',fullfile(matlabroot,poblacion(pobl)));
    subjects = cellstr(subjects)'; % escojo todos los sujetos del estudio
    
    
for i=1 : length(subjects)
    fnm1 = spm_select('List', fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm'),'^region_r.*\.nii$'); % select images for the smooth
    [lregion colb]= size (fnm1);
    
    for r = 1: 2 : lregion
    
    WMflair = char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm',deblank(fnm1(r,:))));  % image(s) to be smoothed (or 3D array)
    VolEtiq = char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm',deblank(fnm1(r+1,:))));  % image(s) to be smoothed (or 3D array)
%     nii_32bit (WMflair);
%     fnm2 = spm_select('List', fullfile(matlabroot,subjects{i},'TEMP6'),'^rs.*\.nii$');
%     rsflair = fullfile(matlabroot,subjects{i},'TEMP6',deblank(fnm2));  % image(s) to be smoothed (or 3D array)
%     nii_32bit (rsflair);
     Vf = spm_vol(WMflair);
     imgf = spm_read_vols(Vf);
     V = spm_vol(VolEtiq);
     img = spm_read_vols(V);
     %% 
     % agregar intensidad para normalizar al espacio NMI y no perder informacion
%      [pth bnm ext] = spm_fileparts(WMflair);
%     VO = Vf; % copy input info for output image
%     VO.fname = fullfile(pth, ['norm' bnm ext]);
%     L = logical(img);
%     LX= double(L)*100;
%     imgf = imgf + LX;
%     spm_write_vol(VO,imgf); % guardo volumen logico como .nii

%      %% imrimir lesiones en vlumen
%       
% figNumber=figure;
% colordef(figNumber,'white');
% set(gcf,'InvertHardcopy','off')
% 
% cla
% LZ=imgf;
% %  LZ(:,:,1:30)=[];
% %  LZ(:,:,100:130)=[];
% % imgreshape = reshape(LZ,192,2304);
% D=LZ;
% D = squeeze(D);
% [x, y, z, D] = subvolume(D, [nan nan nan nan nan 160]);
% % [x,y,z,D] = subvolume(D,[nan,nan,nan,60,nan,nan]);
% p = patch(isosurface(x,y,z,D, 5), 'FaceColor', 'black', 'EdgeColor', 'none');
% patch(isocaps(x,y,z,D, 5), 'FaceColor', 'interp', 'EdgeColor', 'none');
% isonormals(x,y,z,D,p);
% view(3)
% daspect([1 1 1])    % setea los ejes de 0 a 1
% colormap(gray(100)) % color interno 
% camva('manual')
% box on
% camlight(40, 40) % iluminacion
% camlight(-20,-10)% iluminacion
% % % lighting phong, alpha(.5) 
%   lighting gouraud , alpha(.09)   %  me da la transparencia alpha(.5)
%  
%  
% %  ColorSpec funcion para escoger color en RGB
%  % imprime lessiones
% % hold on
%  img=round(img+10);
%  min(min(min(img)));
%   for l=11 : max(max(max(img)))
%       
% % figNumber=figure;
% % colordef(figNumber,'white');
% % set(gcf,'InvertHardcopy','off')
% % cla
%       
%      LL=img;
%     
%      LL(LL~=l) = 0;
% %  LZ(:,:,1:30)=[];
% %  LZ(:,:,100:130)=[];
% D=LL;
% % label2rgb(la1)
% D = squeeze(D);  % exprimo de 4D a 3D
% [x, y, z, D] = subvolume(D, [nan nan nan nan nan 160]); 
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
% %  light('Position',[0 1 0],'Style','infinite');
% lighting flat%, alpha(1) 
% %   lighting gouraud
% % close all
%   end
%  
% % print('-dtiff','-r200',fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm','lessions') );
% % saveas(figNumber,fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm','lessions'))
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
     
        if r == 1
        fprintf(fid1, '%s %s %s %s %s %s %s\n', 'SUJETO# ',num2str(i),' con ',num2str(sum(n)/1000),' cmm3 de lessions', 'en region',num2str(r));
        end   
        if r == 3
        fprintf(fid2, '%s %s %s %s %s %s %s\n', 'SUJETO# ',num2str(i),' con ',num2str(sum(n)/1000),' cmm3 de lessions', 'en region',num2str(r));
        end
        if r == 5
        fprintf(fid3, '%s %s %s %s %s %s %s\n', 'SUJETO# ',num2str(i),' con ',num2str(sum(n)/1000),' cmm3 de lessions', 'en region',num2str(r));
        end
        if r == 7
        fprintf(fid4, '%s %s %s %s %s %s %s\n', 'SUJETO# ',num2str(i),' con ',num2str(sum(n)/1000),' cmm3 de lessions', 'en region',num2str(r));
        end
        if r == 9
        fprintf(fid5, '%s %s %s %s %s %s %s\n', 'SUJETO# ',num2str(i),' con ',num2str(sum(n)/1000),' cmm3 de lessions', 'en region',num2str(r));
        end
        if r == 11
        fprintf(fid6, '%s %s %s %s %s %s %s\n', 'SUJETO# ',num2str(i),' con ',num2str(sum(n)/1000),' cmm3 de lessions', 'en region',num2str(r));
        end
        if r == 13
        fprintf(fid7, '%s %s %s %s %s %s %s\n', 'SUJETO# ',num2str(i),' con ',num2str(sum(n)/1000),' cmm3 de lessions', 'en region',num2str(r));
        end
        if r == 15
        fprintf(fid8, '%s %s %s %s %s %s %s\n', 'SUJETO# ',num2str(i),' con ',num2str(sum(n)/1000),' cmm3 de lessions', 'en region',num2str(r));
        end
        
        
     % 
     % 
% 	[n, x] = histvol(V, 256);
%     n(1)=0;
% 	figure;
% 	bar(x,n);
    end
end
end
fclose(fid1);
fclose(fid2);
fclose(fid3);
fclose(fid4);
fclose(fid5);
fclose(fid6);
fclose(fid7);
fclose(fid8);
disp('done')
toc
% type inf_region3.txt
% type infdelessMNI.txt