function [ output_args ] = white_matter_extration( route, data_folder, varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

disp('******** beginning WM EXTRACTION ********');
tic
%%
matlabroot = route ;
nVarargs = length(varargin);
if nVarargs == 0
    imag1 = '^c2sT.*\.nii$' ;
    imag2 = '^rF.*\.nii$' ;
end
if nVarargs == 2
    imag1 = varargin{1} ;
    imag2 = varargin{2} ;
end
if nVarargs == 1 || nVarargs >2 
    error('myApp:argChk', 'ACL: Wrong number of input arguments')
end

dat_dir = fullfile(matlabroot,data_folder);
[sb_files , subjects] = spm_select('List', dat_dir);
parfor i= 1: length(subjects(:,1))
    wm = spm_select('List', fullfile(dat_dir,deblank(subjects(i,:))),imag1); % select images for the smooth
    rs = spm_select('List', fullfile(dat_dir,deblank(subjects(i,:))),imag2); % select images for the smooth
    wmT1 = char(fullfile(dat_dir,deblank(subjects(i,:)),deblank(wm)));
    resflair = char(fullfile(dat_dir,deblank(subjects(i,:)),deblank(rs)));  % image(s) to be smoothed (or 3D array)
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
    spm_imcalc(Vi, outfilename, 'i1.*i2' ,flags );
    
end

disp('********* done WM EXTRACTION ************')
toc
end

