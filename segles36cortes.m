tic
close all
 matlabroot='/Users/orlando/Documents/MATLAB/TESIS/test';
% seg_lesTESIS_dos ('/Users/orlando/Documents/MATLAB/TESIS/test','NE','^origWMs.*\.nii$')
% matlabroot = ruta ;



       
%             spc = '^rTPMxWM.*\.nii$';
    spc = '^origWMs.*\.nii$';
       

        filename = 'point_slice10.txt';
        fid2 = fopen(filename, 'w');

    
%% elegir varias poblaciones
poblacion = {'HC', 'LPD', 'RPD'};
for pobl = 1 : length (poblacion)

    [sb_files , subjects] = spm_select('List',fullfile(matlabroot,poblacion(pobl)));
    subjects = cellstr(subjects)'; % escojo todos los sujetos del estudio

%% 
for i=1:length(subjects)

fnm = spm_select('List', fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm'),spc);

wmflair = char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm',deblank(fnm(1,:))));

[pth bnm ext] = spm_fileparts(wmflair);
VI = spm_vol(wmflair);
VO = VI; % copy input info for output image
VO.fname = fullfile(pth, [bnm '_znew' ext]);
img = spm_read_vols(VI);
[s,j,k] = size(img);
img(isnan(img)) = 0; % use ~ isfinite instead of isnan to replace +/-inf with zero
imgout = zeros([s,j,k]);
imgout2 = zeros([s,j,k]);
imglog = zeros([s,j,k]);
img(img<=0) = 0;


%% 
for sl=1: k 
    I=img(:,:,sl);
    
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
% % % %         otsu
        IDX = otsu(ICJ,4);
        IDX(IDX<=3) = 0;
        imgout2 (:,:,sl) = IDX;
% % % %         otsu
%         figure,imagesc(I),colormap(gray), title('Image menos la media'), axis off;axis equal 
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
%       figure ; plot(x,n),title('Histograma menos la media')
        ceros=find(n==0);
        ICJ=I;
        ICJ(ICJ==0) = [];
        media = mean(ICJ(:));
        tresholdianmico = 3.3 * media; % treshol dinamico 
%         disp(['Slice #: ',num2str(sl),' treshold = ',num2str(tresholdianmico), ' max = ',num2str(mx)]);
        I(I<=tresholdianmico) = 0;
        imgout(:,:,sl) = I;
    end
end
%  spm_write_vol(VO,imgout);

%% 

indices = find(imgout>0);
% newdata = extentThreshold(data, indices, 20);

% function result = extentThreshold(image, indices, k)
% % function result = extentThreshold(image, indices, k)
% % Applies the extent threshold function of SPM5 on 'image' with given
% % 'indices' and cluster size 'k' 
k = 15;
[x1, y1, z1] = ind2sub(size(imgout), indices);

XYZ = [x1 y1 z1];

% from spm_getSPM line 676:

%-Calculate extent threshold filtering (from spm_getSPM, line 676)
%-------------------------------------------------------------------
A     = spm_clusters(XYZ');
Q     = [];
for i1 = 1:max(A)
    j1 = find(A == i1);
    if length(j1) >= k; Q = [Q j1]; end
end

% ...eliminate voxels
%-------------------------------------------------------------------
XYZ   = XYZ(Q,:);

result = zeros(size(imgout));
inds = sub2ind(size(imgout), XYZ(:,1), XYZ(:,2), XYZ(:,3));
result(inds) = imgout(inds);
% % % % % % % % % % % % % 
figNumber=figure;
colordef(figNumber,'white');
set(gcf,'InvertHardcopy','off')

cla
LZ=img;
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

LZ=result;
%  LZ(:,:,1:30)=[];
%  LZ(:,:,100:130)=[];
% imgreshape = reshape(LZ,192,2304);
D=LZ;
D = squeeze(D);
[x, y, z, D] = subvolume(D, [nan nan nan nan nan nan]);
p = patch(isosurface(x,y,z,D, 5), 'FaceColor', 'red', 'EdgeColor', 'none');
patch(isocaps(x,y,z,D, 5), 'FaceColor', 'interp', 'EdgeColor', 'none');
isonormals(x,y,z,D,p);
view(3)
daspect([1 1 1])
colormap(gray(100))
camva(9)
box on
camlight(40, 40)
camlight(-20,-10)
lighting gouraud


    sumaoflesion = 0;
    for slic = 1 : 36 
%         se = strel('ball',3,3);
        X = result(:,:,slic);
%         figure, imshow(XL);
%         figure,imagesc(X),colormap(gray)
%         I2 = imdilate(X,se);
%           figure,imagesc(I2),colormap(gray)
%         I2(I2<3) = 0;
        LO = logical(X);% I convert my lessions matrix, matrix logic of lessions
%         L=bwareaopen(LO,4); % elimina volumenes menores que 4 voxels
        [LA, NUM] = bwlabeln(LO); % etiqueta volumenes con identificadores y guarda el numero de etiquetas en NUM  
%         figure, imshow(LA)
        sumaoflesion = sumaoflesion + NUM;
        imglog (:,:,slic) = LA;
    end
    fprintf(fid2, '%s %s %s %s %s %s %s\n', 'pobl ',num2str(pobl),' SUJETO#',num2str(i),' con ',num2str(sumaoflesion),' puntos');
    VO.fname = fullfile(pth, [bnm 'Slc_etq' ext]);
    spm_write_vol(VO,imglog); % guardo volumen logico como .nii
%     LA = imglog;



% %% 
% 
% 
% 
%  %% 
% % if nVarargs == 0;
% 
% % %    figure, imshow(L)
% %      L=bwareaopen(L,4);
% %      figure, imshow(L) % i
% % L = logical(imgout);% I convert my lessions matrix, matrix logic of lessions
% % L=bwareaopen(L,8); % elimina volumenes menores que 4 voxels
% % [LA, NUM] = bwlabeln(L); % etiqueta volumenes con identificadores y guarda el numero de etiquetas en NUM       
% %     VO.fname = fullfile(pth, [bnm 'Vol_ETiquetdo' ext]);
% %     spm_write_vol(VO,LA); % guardo volumen logico como .nii
% % end
% % %% 
% % if nVarargs == 1;
% 
%     sumaoflesion = 0
%     for slic = 1 : 36 
% %         se = strel('ball',3,3);
%         X = imgout(:,:,slic);
% %         figure, imshow(XL);
% %         figure,imagesc(X),colormap(gray)
% %         I2 = imdilate(X,se);
% %           figure,imagesc(I2),colormap(gray)
% %         I2(I2<3) = 0;
%         LO = logical(X);% I convert my lessions matrix, matrix logic of lessions
%         L=bwareaopen(LO,4); % elimina volumenes menores que 4 voxels
%         [LA, NUM] = bwlabeln(L); % etiqueta volumenes con identificadores y guarda el numero de etiquetas en NUM  
% %         figure, imshow(LA)
%         sumaoflesion = sumaoflesion + NUM;
%         imglog (:,:,slic) = LA;
%     end
%     fprintf(fid2, '%s %s %s %s %s %s %s\n', 'pobl ',num2str(pobl),' SUJETO#',num2str(i),' con ',num2str(sumaoflesion),' puntos');
%     VO.fname = fullfile(pth, [bnm 'Slc_etq' ext]);
%     spm_write_vol(VO,imglog); % guardo volumen logico como .nii
%     LA = imglog;
% % end
%     
%     
%     
% %% imrimir lesiones en vlumen
% figNumber=figure;
% colordef(figNumber,'black');
% set(gcf,'InvertHardcopy','off')
% 
% cla
% LZ=LA;
% %  LZ(:,:,1:30)=[];
% %  LZ(:,:,100:130)=[];
% % imgreshape = reshape(LZ,192,2304);
% D=LZ;
% D = squeeze(D);
% [x, y, z, D] = subvolume(D, [nan nan nan nan nan nan]);
% p = patch(isosurface(x,y,z,D, 5), 'FaceColor', 'red', 'EdgeColor', 'none');
% patch(isocaps(x,y,z,D, 5), 'FaceColor', 'interp', 'EdgeColor', 'none');
% isonormals(x,y,z,D,p);
% view(3)
% daspect([1 1 1])
% colormap(gray(100))
% camva(9)
% box on
% camlight(40, 40)
% camlight(-20,-10)
% lighting gouraud
%%    
close all
end
end
fclose(fid2);
% type 'point_slice2.txt';
toc