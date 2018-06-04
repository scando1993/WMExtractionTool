%% MNI
function mniTESIS_dos (ruta,nombresdepoblacion)
%%
% Normalmente, Dartel genera imágenes deformadas que se alinean con la 
% plantilla en forma de media \cite{ashburner2007fast}.
% Esta rutina incluye un registro afín inicial de la plantilla (el final
% uno generado por Dartel), con los datos TPM generados con SPM 
%% Descripción
% Esta rutina selecciona todas las imágenes SB_Flair con *spm_selec*
% luego toma los campos de deformacion generados por DARTEL
% *'^u_rc2ss.*\.nii$'*, y la Plantilla *'Template_6.nii'*
% luego deforma las imágenes al espacio y forma de la plantilla.
%% Código
% La función necesita ruta de la carpeta de trabajo la cual debe ser
% enviada desde el programa principal y los nombre de los grupos que
% creamos, en las variable *ruta* , *nombresdepoblacion* .
%-----------------------------------------------------------------------
% Job saved on 07-Dec-2013 15:39:16 by cfg_util (rev $Rev: 4972 $)
% spm SPM - SPM12b (5616)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------

disp('******** beginning normalize to MNI ********');
tic
%% 
% matlabroot='/Users/orlando/Documents/MATLAB/TESIS/test';
matlabroot = ruta;
poblacion = nombresdepoblacion;%{'HC', 'LPD', 'RPD'};
for pobl = 1 : length (poblacion)

    [sb_files , subjects] = spm_select('List',fullfile(matlabroot,poblacion(pobl)));
    subjects = cellstr(subjects)'; % escojo todos los sujetos del estudio
    
%% 


for i=1:length(subjects)
    % aumenta intensidd para normalizar
    fnm1 = spm_select('List', fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm'),'^WMrs.*\.nii$'); % select images for the smooth
    WMflair = char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm',deblank(fnm1(1,:))));  % image(s) to be smoothed (or 3D array)
 
    %%% nuevo por archivo) 
    VI = spm_vol(WMflair);
    imgx = spm_read_vols(VI);
    [i1,j,k] = size(imgx);
    imgx(isnan(imgx)) = 0; % use ~ isfinite instead of isnan to replace +/-inf with zero
    imgout = zeros([i1,j,k]);
    imglog = zeros([i1,j,k]);
    
    %% 
for sl=1: k 
    I=imgx(:,:,sl);
    
%     figure,imagesc(I),colormap(gray), title('Image Original'), axis off;axis equal 
    ICJ=I;
    
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
    n(1:10)=0;
%     figure ; plot(x,n)
    
    ICJ(ICJ<=100) = [];
    media = mean(ICJ(:));
    moda = mode(mode(ICJ));
    if isnan(moda) || moda < 105
       imgout(:,:,sl) = 0;
    else
        I=I-moda; % solo me quedo con intensidades altas
        I(I<=0) = 0; % remove negatives
        ICJ=I;
        
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
%       figure ; plot(x,n)
        ceros=find(n==0);
        ICJ=I;
        ICJ(ICJ==0) = [];
        media = mean(ICJ(:));
        tresholdianmico = 3.2* media; % treshol dinamico 
%         disp(['Slice #: ',num2str(sl),' treshold = ',num2str(tresholdianmico), ' max = ',num2str(mx)]);
        I(I<=tresholdianmico) = 0;
        imgout(:,:,sl) = I;
    end
end
    L = logical(imgout);% I convert my lessions matrix, matrix logic of lessions
    L=bwareaopen(L,8); % elimina volumenes menores que 4 voxels
    [LA, NUM] = bwlabeln(L); % etiqueta volumenes con identificadores y guarda el numero de etiquetas en NUM
    
    
%%% nuevo por archivo)    
    
    
    
%(elim por archivo)     VolEtiq = char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm',deblank(fnm1(2,:))));  % image(s) to be smoothed (or 3D array)
     Vf = spm_vol(WMflair);
     imgf = spm_read_vols(Vf);
%(elim por archivo)      V = spm_vol(VolEtiq);
%(elim por archivo)      img = spm_read_vols(V);
       img = LA; % %(agregado por archivo)
%      agregar intensidad para normalizar al espacio NMI y no perder informacion
     [pth bnm ext] = spm_fileparts(WMflair);
    VO = Vf; % copy input info for output image
    VO.fname = fullfile(pth, ['norm' bnm ext]);
    L = logical(img);
    LX= double(L)*100;
    imgf = imgf + LX;
    spm_write_vol(VO,imgf); % guardo volumen logico como .nii
    
    
    
matlabbatch{1}.spm.tools.dartel.mni_norm.template = {fullfile(matlabroot,'TEMPLATES','Template_6.nii')};

    fnm1= spm_select('List', fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t1_mprage_TRA_1x1x1'),'^u_rc2ss.*\.nii$'); 
    fnm2= spm_select('List', fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm'),'^normWMrs.*\.nii$'); 
    u = char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t1_mprage_TRA_1x1x1',deblank(fnm1)));
    wmflair = char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm',deblank(fnm2(1,:))));
matlabbatch{1}.spm.tools.dartel.mni_norm.data.subj(i).flowfield = {u};
matlabbatch{1}.spm.tools.dartel.mni_norm.data.subj(i).images = {wmflair};
% matlabbatch{1}.spm.tools.dartel.mni_norm.data.subj(2).flowfield = {'/Users/orlando/Documents/MATLAB/TESIS/test/sb2/TEMP5/u_rc2ss508840-0010-00001-000001-01_Templatecinco.nii'};
% matlabbatch{1}.spm.tools.dartel.mni_norm.data.subj(2).images = {'/Users/orlando/Documents/MATLAB/TESIS/test/sb2/TEMP5/WMrs508840-0011-00001-000001-01.nii'};
end
matlabbatch{1}.spm.tools.dartel.mni_norm.vox = [NaN NaN NaN];
matlabbatch{1}.spm.tools.dartel.mni_norm.bb = [NaN NaN NaN
                                               NaN NaN NaN];
matlabbatch{1}.spm.tools.dartel.mni_norm.preserve = 0;
matlabbatch{1}.spm.tools.dartel.mni_norm.fwhm = [0 0 0];
spm_jobman('serial',matlabbatch);
end