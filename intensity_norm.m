function intensity_norm (ruta,nombresdepoblacion)

% matlabroot = '/Users/orlando/Documents/MATLAB/TESIS/test';
% intensity_norm (fullfile(spm('Dir'),'toolbox','ACL','Study'),{'Grupo#1','Grupo#2','Grupo#3'})
matlabroot = ruta; 
%% elegir varias poblaciones
%     nVarargs = length(varargin)
%     if nVarargs == 0;
        spc = '^rs.*\.nii$';
%     end
%     if nVarargs == 1;
%         spc = varargin{1};
%     else
%         error('myApp:argChk', 'ACL: Wrong number of input arguments')
%     end
    
poblacion = nombresdepoblacion;%{'HC', 'LPD', 'RPD'};
for pobl = 1 : length (poblacion)

    [sb_files , subjects] = spm_select('List',char(fullfile(matlabroot,poblacion(pobl))));
    subjects = cellstr(subjects)'; % escojo todos los sujetos del estudio
    
    
for i=1 : length(subjects)
    fnm = spm_select('List', fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm'),spc); % select images for the smooth
    V = char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm',deblank(fnm(1,:))));  % image(s) to be smoothed (or 3D array)
     %% scale image for range 0..1
%         nii_unity(V)
        fnm = deblank(V(1,:));
  [pth bnm ext] = spm_fileparts(fnm);
    VI = spm_vol(fnm);
    VO = VI; % copy input info for output image
    VO.fname = fullfile(pth, ['u' bnm ext]);  
    img = spm_read_vols(VI);
    
    [n, x]=histvol(VI, 256);
%     figure,plot(x,n)
    
    percentage = 0.98 * sum (n);
    mk = 1;
    suma = 0;
    while suma < percentage
      suma = suma + n(mk);
      mk = mk + 1;
    end
    
    img(img >= x(mk)) = x(mk);
    img(img <= 0) = 0;
    mx = max(img(:));
    mn = min(img(:));
%     fprintf('%s has range of %f..%f, and will be rescaled to 0..1\n',fnm,mn,mx);   
    img = 100*(img-mn)/mx;
%     img = img.*img; % <- sqr function emphasizes edges
    
    spm_write_vol(VO,int16(img));
    
     
end
end

     
