function [ output_args ] = normalize_mni( route, data_folder, mni_folder)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

disp('******** beginning normalize to MNI ********');
tic
%%
% matlabroot='/Users/orlando/Documents/MATLAB/TESIS/test';
matlabroot = route;
data_dir = fullfile(matlabroot,data_folder);
[sb_files , subjects] = spm_select('List', data_dir);

for i=1:length(subjects(:,1))
    % aumenta intensidd para normalizar
    image_route = fullfile(data_dir,deblank(subjects(i,:)));
    fnm1 = spm_select('List', image_route ,'^WMr.*\.nii$'); % select images for the smooth
    WMflair = char(fullfile(image_route,deblank(fnm1(1,:))));  % image(s) to be smoothed (or 3D array)
    
    %%% nuevo por archivo)
    VI = spm_vol(WMflair);
    imgx = spm_read_vols(VI);
    [i1,j,k] = size(imgx);
    imgx(isnan(imgx)) = 0; % use ~ isfinite instead of isnan to replace +/-inf with zero
    imgout = zeros([i1,j,k]);
    imglog = zeros([i1,j,k]);
    
    %%
    for sl= 1:k
        I=imgx(:,:,sl);
        
%         figure,imagesc(I),colormap(gray), title('Image Original'), axis off;axis equal
        ICJ = I;
        
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
%         figure ; plot(x,n)
        
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
    
    
    
    matlabbatch{1}.spm.tools.dartel.mni_norm.template = {fullfile(pwd,'TEMPLATES','Template_6.nii')};
    
    fnm1= spm_select('List', image_route,'^u_rc2s.*\.nii$');
    fnm2= spm_select('List', image_route,'^normWMr.*\.nii$');
    u = char(fullfile(image_route,deblank(fnm1)));
    wmflair = char(fullfile(image_route,deblank(fnm2(1,:))));
    matlabbatch{1}.spm.tools.dartel.mni_norm.data.subj(i).flowfield = {u};
    matlabbatch{1}.spm.tools.dartel.mni_norm.data.subj(i).images = {wmflair};
    
end

matlabbatch{1}.spm.tools.dartel.mni_norm.vox = [NaN NaN NaN];
matlabbatch{1}.spm.tools.dartel.mni_norm.bb = [NaN NaN NaN
    NaN NaN NaN];
matlabbatch{1}.spm.tools.dartel.mni_norm.preserve = 0;
matlabbatch{1}.spm.tools.dartel.mni_norm.fwhm = [0 0 0];

spm_jobman('serial',matlabbatch);

end

