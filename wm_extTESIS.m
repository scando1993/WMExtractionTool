%% WM EXTRACTION
clc 
clear all 
disp('******** beginning WM EXTRACTION ********');
tic
%% 
subjects={'sb1', 'sb2', 'sb3', 'sb4', 'sb5', 'sb6', 'sb7', 'sb8', 'sb9', 'sb10' };
matlabroot='/Users/orlando/Documents/MATLAB/TESIS/test';

%% 
for i=1:length(subjects)
    wm = spm_select('List', fullfile(matlabroot,subjects{i},'TEMP6'),'^c2ss.*\.nii$'); % select images for the smooth
    rs = spm_select('List', fullfile(matlabroot,subjects{i},'TEMP6'),'^rs.*\.nii$'); % select images for the smooth
    wmT1 = fullfile(matlabroot,subjects{i},'TEMP6',deblank(wm));
    resflair = fullfile(matlabroot,subjects{i},'TEMP6',deblank(rs));  % image(s) to be smoothed (or 3D array)
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
disp('********* done WM EXTRACTION ************')
toc