%% WM EXTRACTION
function wm_extTESIS_dos (ruta,nombresdepoblacion,varargin)
%% 
% Función que realiza manipulacion algebraica de imagenes que consiste en 
% extraer las sustancia Blanca de la imagen FALIR.
%%
%-----------------------------------------------------------------------
% 
% * ESPOL     FIEC & FIMCP    NBL"Neuroimaging & Bioengineering Laboratory"
% spm SPM - SPM12b (5616)
% cfg_basicio BasicIO - Unknown
%
%% Descripcion
% Esta funcion seleciona todas las imagenes SB_T1 con *spm_selec*
% de la imagen T1 y las multiplica con la imagen Fliar
% mediante la ayuda de la funcion de SPM *spm_imcalc*.
%% Código
% La funcion necesita ruta de la carpeta de trabajo la cual debe ser
% enviada desde el programa principal y los nombre de los grupos que
% creamos. 
% en las variable *ruta* , *nombresdepoblacion*  
disp('******** beginning WM EXTRACTION ********');
tic
%% 
% matlabroot='/Users/orlando/Documents/MATLAB/TESIS/test';
% wm_extTESIS_dos ('/Users/orlando/Documents/MATLAB/TESIS/test',{'HC', 'LPD', 'RPD'},'^rhc2ss.*\.nii$','^ms.*\.nii$')
matlabroot = ruta ;
nVarargs = length(varargin);
if nVarargs == 0;
    imag1 = '^c2ss.*\.nii$' ;
    imag2 = '^rs.*\.nii$' ;
end
if nVarargs == 2;
    imag1 = varargin{1} ;
    imag2 = varargin{2} ;
end
if nVarargs == 1 || nVarargs >2 ;
    error('myApp:argChk', 'ACL: Wrong number of input arguments')
end
%% elegir varias poblaciones
poblacion = nombresdepoblacion;%{'HC', 'LPD', 'RPD'};
for pobl = 1 : length (poblacion)

    [sb_files , subjects] = spm_select('List',fullfile(matlabroot,poblacion(pobl)));
    subjects = cellstr(subjects)'; % escojo todos los sujetos del estudio


%% 

for i=1: length(subjects)
    wm = spm_select('List', fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t1_mprage_TRA_1x1x1'),imag1); % select images for the smooth
    rs = spm_select('List', fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm'),imag2); % select images for the smooth
    wmT1 = char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t1_mprage_TRA_1x1x1',deblank(wm)));
    resflair = char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm',deblank(rs)));  % image(s) to be smoothed (or 3D array)
    [p, nm, e v] = spm_fileparts(resflair) ;
    outfilename = [p filesep 'WM' nm e]; %filename for smoothed image (or 3D array
    Vi = {resflair wmT1};
    flags = struct('dmtx',0,'mask',0,'interp',4,'dtype',4); %       dmtx     - Read images into data matrix?
                                                            %                   [defaults (missing or empty) to 0 - no]
                                                            %        mask     - implicit zero mask?
                                                            %                   [defaults (missing or empty) to 0]
                                                            %                    ( negative value implies NaNs should be zeroed )
                                                            %        interp   - interpolation hold (see spm_slice_vol)
                                                            %                   [defaults (missing or empty) to 0 - nearest neighbour]
                                                            %        dtype    - data type for output image (see spm_type)
                                                            %                   [defaults (missing or empty) to 4 - 16 bit signed shorts]
    Vo = spm_imcalc(Vi, outfilename, 'i1.*i2' ,flags );
    
    
    
end
end
disp('********* done WM EXTRACTION ************')
toc