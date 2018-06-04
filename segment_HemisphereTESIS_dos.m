function segment_HemisphereTESIS_dos (rut,gr)
%% 
clc  
disp('******** beginning SEGMENT BY HEMISPHERE ********');
%segment_HemisphereTESIS_dos(fullfile(spm('Dir'),'toolbox','ACL','Study'),{'Grupo#1', 'Grupo#2', 'Grupo#3'});
tic
%% 
matlabroot= rut;%fullfile(spm('Dir'),'toolbox','ACL','Study'); %'/Users/orlando/Documents/MATLAB/TESIS/test';

%% elegir mascaras de tijidos en ACL
fnmHI = spm_select('List', '/Users/orlando/Documents/MATLAB/spm12b/toolbox/ACL','^r.*\.nii$');
mask = cellstr(fnmHI)';
%% 

poblacion = gr;             %{'HC', 'LPD', 'RPD'};
for pobl = 1 : length (poblacion)

    [sb_files , subjects] = spm_select('List',fullfile(matlabroot,poblacion(pobl)));
    subjects = cellstr(subjects)'; % escojo todos los sujetos del estudio
    
    
for i=1 : length(subjects)
    fnm1 = spm_select('List', fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm'),'^wnormWMrs.*\.nii$'); % select images for the smooth
    WMflair = char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm',deblank(fnm1(1,:))));  % image(s) to be smoothed (or 3D array)
%     VolEtiq = char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6','t2_tirm_TRA_dark-fluid_3mm',deblank(fnm1(2,:))));  % image(s) to be smoothed (or 3D array)
%      Vf = spm_vol(WMflair);
%      imgf = spm_read_vols(Vf);
%      V = spm_vol(VolEtiq);
%      img = spm_read_vols(V);
for j = 1 : length ( mask)
    
    path_HI = char(fullfile('/Users/orlando/Documents/MATLAB/spm12b/toolbox/ACL',deblank(fnmHI(j,:))));
    [p, nm, e v] = spm_fileparts(WMflair) ;
    [pw, nmw, ew vw] = spm_fileparts(fnmHI(j,1:3)) ; % solo escojo las 3 primeras iniciales en nmw
    
    
    outfilename = [p filesep 'region_' nmw '_' nm e]; %filename for smoothed image (or 3D array
    Vi = {WMflair  path_HI};
    flags = struct('dmtx',0,'mask',0,'interp',4,'dtype',4); %       dmtx     - Read images into data matrix?
                                                            %                   [defaults (missing or empty) to 0 - no]
                                                            %        mask     - implicit zero mask?
                                                            %                   [defaults (missing or empty) to 0]
                                                            %                    ( negative value implies NaNs should be zeroed )
                                                            %        interp   - interpolation hold (see spm_slice_vol)
                                                            %                   [defaults (missing or empty) to 0 - nearest neighbour]
                                                            %        dtype    - data type for output image (see spm_type)
                                                            %                   [defaults (missing or empty) to 4 - 16 bit signed shorts]
     Vo = spm_imcalc(Vi, outfilename, '(i1.*i2)' ,flags );

    
    
end







end
end
toc



