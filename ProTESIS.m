%% 
subjects={'sb1', 'sb2', 'sb3', 'sb4', 'sb5', 'sb6', 'sb7', 'sb8', 'sb9', 'sb10' };
matlabroot='/Users/orlando/Documents/MATLAB/TESIS/test';

%% 

for  i=1: length(subjects)
    [status,message,messageid] = mkdir(fullfile(matlabroot,subjects{i}),'TEMP6');
end
%% 

% for  i=1: length(subjects)
%     [status,message,messageid] = rmdir(fullfile(matlabroot,subjects{i},'TEMP4'),'s')
%  end
%% 
for i=1: length(subjects)
    
    [filesDICOM,dirsDICOM] = spm_select('List',fullfile(matlabroot,subjects{i},'DICOM'));
    [filesT1,dirsT1] =       spm_select('List',fullfile(matlabroot,subjects{i},'DICOM',dirsDICOM(1,:)),'\.dcm');
    [filesFLAIR,dirsFLAIR] = spm_select('List',fullfile(matlabroot,subjects{i},'DICOM',dirsDICOM(2,:)),'\.dcm');
    spm_my_defauls;
    
    [ffT1,cfT1] =  size(filesT1);
%     filesT1=       cellstr(filesT1);
    
%      hdrT1 = cell(ffT1,1);
     for ft1=1 : ffT1
          hdrT1(ft1,1) = spm_dicom_headers(fullfile(matlabroot,subjects{i},'DICOM',strrep(dirsDICOM(1,:),' ','')...
              ,strrep(filesT1(ft1,:),' ','')));
     end
     
     [ffFLAIR,cfFLAIR] = size(filesFLAIR);
     
     hdrFLAIR = cell(ffFLAIR,1);
     for fflair=1 : ffFLAIR
          hdrFLAIR(fflair,1) = spm_dicom_headers(fullfile(matlabroot,subjects{i},'DICOM',strrep(dirsDICOM(2,:),' ','')...
              ,strrep(filesFLAIR(fflair,:),' ','')));
     end
     
%      cd(fullfile(matlabroot,subjects{i},'DICOM',strrep(dirsDICOM(1,:),' ','')));
%      filesT1 = spm_select('List',pwd,'\.dcm');
%      hdrT1   = spm_dicom_headers(filesT1);
%      
%      cd(fullfile(matlabroot,subjects{i},'DICOM',strrep(dirsDICOM(2,:),' ','')));
%      filesFLAIR = spm_select('List',pwd,'\.dcm');
%      hdrFLAIR  = spm_dicom_headers(filesFLAIR);
%      
     cd(fullfile(matlabroot,subjects{i},'TEMP6'));
     spm_dicom_convert(hdrT1,'all','flat','nii');
     spm_dicom_convert(hdrFLAIR,'all','flat','nii');

end
fprintf('Done\n');
%% 