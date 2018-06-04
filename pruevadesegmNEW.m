%% 

matlabroot='/Users/orlando/Documents/MATLAB/TESIS/test';
poblacion = {'HC', 'LPD', 'RPD'};
pobl = 1;
[sb_files , subjects] = spm_select('List',fullfile(matlabroot,poblacion(pobl)));
subjects = cellstr(subjects)';
i=1;

fnm = spm_select('List', fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm'),'^WMms.*\.nii$');
wmflair = char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm',deblank(fnm(3,:))));
wm = char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm',deblank(fnm(1,:))));
VI = spm_vol(wmflair);
img = spm_read_vols(VI);

VI2 = spm_vol(wm);
imgf = spm_read_vols(VI2);
%% 
fnm = spm_select('List', fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm'),'^s.*\.nii$');
wmflair = char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm',deblank(fnm(1,:))));
% wm = char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm',deblank(fnm(1,:))));
VI = spm_vol(wmflair);
imgor = spm_read_vols(VI);

%% imrimir lesiones en vlumen
      
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
 %% imrimir lesiones en vlumen
% figNumber=figure;
% colordef(figNumber,'black');
% set(gcf,'InvertHardcopy','off')
% 
% cla
LZ=img;
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

%% 
indices = find(img>0);
% newdata = extentThreshold(data, indices, 20);

% function result = extentThreshold(image, indices, k)
% % function result = extentThreshold(image, indices, k)
% % Applies the extent threshold function of SPM5 on 'image' with given
% % 'indices' and cluster size 'k' 
k = 20;
[x, y, z] = ind2sub(size(img), indices);

XYZ = [x y z];

% from spm_getSPM line 676:

%-Calculate extent threshold filtering (from spm_getSPM, line 676)
%-------------------------------------------------------------------
A     = spm_clusters(XYZ');
Q     = [];
for i = 1:max(A)
    j = find(A == i);
    if length(j) >= k; Q = [Q j]; end
end

% ...eliminate voxels
%-------------------------------------------------------------------
XYZ   = XYZ(Q,:);

result = zeros(size(img));
inds = sub2ind(size(img), XYZ(:,1), XYZ(:,2), XYZ(:,3));
result(inds) = img(inds);
% % % % % % % % % % % % % 
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


%% 
%   load clown
X = imgor(:,:,16);
  figure;
  
  
  subplot(221)
   imagesc(X),colormap(gray)
  title('Original','FontWeight','bold')
  for n = 2:4
    IDX = otsu(X,n);
    subplot(2,2,n)
    imagesc(IDX), axis image off
    title(['n = ' int2str(n)],'FontWeight','bold')
  end
  colormap(gray)




