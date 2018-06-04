% Batch que sirve para segementar lesiones, tomando encuenta el histograma
% encontrando la moda y la media
% donde cada paciente necesita tener segementada la materia Blanca de la
% FLAIR.
%__________________________________________________________________________
% ESPOL     FIEC & FIMCP    NBL"Neuroimaging & Bioengineering Laboratory"

% Orlando Chancay
% $Id: seg_lesTESIS.m  25-Nov-2013  9:48:13z$

%% Example to read a volume (an .img image)
%% 
clc 
disp('******** beginning SEGMENTATION OF LESSIONS ********');
tic
subjects={'sb1', 'sb2', 'sb3', 'sb4', 'sb5', 'sb6', 'sb7', 'sb8', 'sb9', 'sb10' };
matlabroot='/Users/orlando/Documents/MATLAB/TESIS/test';
%% 
for i=1:length(subjects)
    
fnm = spm_select('List', fullfile(matlabroot,subjects{i},'TEMP6'),'^wWMrs.*\.nii$');

wmflair = fullfile(matlabroot,subjects{i},'TEMP6',deblank(fnm(1,:)));

[pth bnm ext] = spm_fileparts(wmflair);
VI = spm_vol(wmflair);
VO = VI; % copy input info for output image
VO.fname = fullfile(pth, [bnm '_znew' ext]);
img = spm_read_vols(VI);
[i,j,k] = size(img);
img(isnan(img)) = 0; % use ~ isfinite instead of isnan to replace +/-inf with zero
imgout = zeros([i,j,k]);
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
        disp(['Slice #: ',num2str(sl),' treshold = ',num2str(tresholdianmico), ' max = ',num2str(mx)]);
        I(I<=tresholdianmico) = 0;
        imgout(:,:,sl) = I;
    end
end
%  spm_write_vol(VO,imgout);
 %% 


% %    figure, imshow(L)
%      L=bwareaopen(L,4);
%      figure, imshow(L) % i
L = logical(imgout);% I convert my lessions matrix, matrix logic of lessions
L=bwareaopen(L,8); % elimina volumenes menores que 4 voxels
[LA, NUM] = bwlabeln(L); % etiqueta volumenes con identificadores y guarda el numero de etiquetas en NUM       
    VO.fname = fullfile(pth, [bnm 'Vol_ETiquetdo' ext]);
    spm_write_vol(VO,LA); % guardo volumen logico como .nii
%% imrimir lesiones en vlumen
figNumber=figure;
colordef(figNumber,'black');
set(gcf,'InvertHardcopy','off')

cla
LZ=LA;
%  LZ(:,:,1:30)=[];
%  LZ(:,:,100:130)=[];
% imgreshape = reshape(LZ,192,2304);
D=LZ;
D = squeeze(D);
[x, y, z, D] = subvolume(D, [nan nan nan nan nan 160]);
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
%%    
end
toc