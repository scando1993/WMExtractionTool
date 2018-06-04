% Batch que sirve para organizar las carpetas y obtener los nombres de los
% pacientes y controles, una vez organizados por nombre y comprobando que
% el paciente o control tiene las 2 imagenes T1 and FLIR, 
%__________________________________________________________________________
% ESPOL     FIEC & FIMCP    NBL"Neuroimaging & Bioengineering Laboratory"

% Orlando Chancay
% $Id: organizarfoldersTESIS.m  23-Nov-2013  9:48:13z$

clear all
clc
%--------------------------------------------------------------------------
matlabroot='/Users/orlando/Documents/MATLAB/TESIS/test';
%%
% if exist(fullfile(matlabroot,'forg')) 
%     [status, message, messageid] = rmdir(fullfile(matlabroot,'forg'),'s');
% end
if ~exist(fullfile(matlabroot,'forg'))
    [status, message, messageid] = mkdir(fullfile(matlabroot),'forg');
end

[filesA,dirsA] = spm_select('List', fullfile(matlabroot,'flair')); % select folders
%% 
filename = 'celldata.txt';
fid = fopen(filename, 'w');
%__________________________________________________________________________
for i=1  : length(dirsA)
    
    [filesB,dirsB] = spm_select('List', fullfile(matlabroot,'flair',deblank(dirsA(i,:)))); % select contenido of each folder
    
    [lfil,stfi] = size(filesB);
    [lfol,stfo] = size(dirsB);
%     disp(['carpeta # ',num2str(i), ' long archi ',num2str(lfil),' long carp ',num2str(lfol)]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% caso 1 cuando el subfolder contiene los archivos dicom
    if lfil > 0 && lfol == 0
        [filesB,dirsB] = spm_select('List', fullfile(matlabroot,'flair',deblank(dirsA(i,:))),'\.dcm'); % tomo nuevamnte los archivos pero solo .nii
        for j = 1 : 1%lfil
%           [filesC,dirsC] = spm_select('List', fullfile(matlabroot,'flair',deblank(dirsA(i,:)))) 
            if isdicom(fullfile(matlabroot,'flair',deblank(dirsA(i,:)),deblank(filesB(j,:))))
                X =  dicominfo(fullfile(matlabroot,'flair',deblank(dirsA(i,:)),deblank(filesB(j,:)) ));
                name = X.PatientName;

            end
        end
                  campos=numel(fields(name));
                if campos == 2
                    [status, message, messageid] = mkdir(fullfile(matlabroot,'forg'), strcat(name.FamilyName,'-',name.GivenName) );
                     if status
                         fprintf(fid, '%s\n', strcat(name.FamilyName,'-',name.GivenName));  % escribo los nombres en el archivo
                     end
                     %____________________________ copy folders____________
                     [status, message, messageid] = mkdir(fullfile(matlabroot,'forg',strcat(name.FamilyName,name.GivenName)),deblank(dirsA(i,:)));
                     [status, message, messageid] = copyfile(fullfile(matlabroot,'flair',deblank(dirsA(i,:))),...
                         fullfile(matlabroot,'forg', strcat(name.FamilyName,name.GivenName),deblank(dirsA(i,:))));
                     %_____________________________________________________
                else
                    [status, message, messageid] = mkdir(fullfile(matlabroot,'forg'), name.FamilyName);
                    if status
                        fprintf(fid, '%s\n', name.FamilyName); % escribo los nombres en el archivo
                    end
                    %____________________________ copy folders_____________
                    [status, message, messageid] = mkdir(fullfile(matlabroot,'forg',name.FamilyName),deblank(dirsA(i,:)));
                    [status, message, messageid] = copyfile(fullfile(matlabroot,'flair',deblank(dirsA(i,:))),...
                         fullfile(matlabroot,'forg', name.FamilyName,deblank(dirsA(i,:))));
                     %_____________________________________________________
                end
                    
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% caso 2: cuando el subfolder contiene 1 subfolder
    if  lfol == 1 %& lfil == 0 
%         disp(['long folder = ',num2str(i)]);
        [filesC,dirsC] = spm_select('List', fullfile(matlabroot,'flair',deblank(dirsA(i,:))));
        
%         if ~isempty(fullfile(matlabroot,'flair',deblank(dirsA(i,:)),deblank(dirsC)))
            [filesD,dirsD] = spm_select('List', fullfile(matlabroot,'flair',deblank(dirsA(i,:)),deblank(dirsC)),'\.dcm');
            if ~isempty(filesD)
            for j = 1 : 1%lfil
% %           [filesC,dirsC] = spm_select('List', fullfile(matlabroot,'flair',deblank(dirsA(i,:)))) 
                if isdicom(fullfile(matlabroot,'flair',deblank(dirsA(i,:)),deblank(dirsC),deblank(filesD(j,:))))
                X =  dicominfo(fullfile(matlabroot,'flair',deblank(dirsA(i,:)),deblank(dirsC),deblank(filesD(j,:))));
                name = X.PatientName;          
                end
            end
                campos=numel(fields(name));
                if campos == 2
                    [status, message, messageid] = mkdir(fullfile(matlabroot,'forg'), strcat(name.FamilyName,'-',name.GivenName) );
                    if status
                        fprintf(fid, '%s\n', strcat(name.FamilyName,'-',name.GivenName)); 
                    end
                    %____________________________ copy folders_____________
                    [status, message, messageid] = mkdir(fullfile(matlabroot,'forg',strcat(name.FamilyName,name.GivenName)),deblank(dirsC));
                    [status, message, messageid] = copyfile(fullfile(matlabroot,'flair',deblank(dirsA(i,:)),deblank(dirsC)),...
                        fullfile(matlabroot,'forg', strcat(name.FamilyName,name.GivenName),deblank(dirsC)));
                    %______________________________________________________
                else 
                [status, message, messageid] = mkdir(fullfile(matlabroot,'forg'), name.FamilyName);
                    if status
                        fprintf(fid, '%s\n', name.FamilyName); % escribo los nombres en el archivo
                    end
                    %____________________________ copy folders_____________
                    [status, message, messageid] = mkdir(fullfile(matlabroot,'forg',name.FamilyName),deblank(dirsC));
                    [status, message, messageid] = copyfile(fullfile(matlabroot,'flair',deblank(dirsA(i,:)),deblank(dirsC)),...
                        fullfile(matlabroot,'forg', name.FamilyName,deblank(dirsC)));
                    %______________________________________________________
                end
            
            else
                disp(['capeta vacia # ',num2str(i)]);
            end
        
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% caso 3: cuando el subfolder contiene 2 subfolder
    if  lfol == 2
        [filesC,dirsC] = spm_select('List', fullfile(matlabroot,'flair',deblank(dirsA(i,:))));
        [filesDA,dirsDA] = spm_select('List', fullfile(matlabroot,'flair',deblank(dirsA(i,:)),deblank(dirsC(1,:))),'\.dcm');
        [filesDB,dirsDB] = spm_select('List', fullfile(matlabroot,'flair',deblank(dirsA(i,:)),deblank(dirsC(2,:))),'\.dcm');
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
        if ~isempty(filesDA)
            for j = 1 : 1%lfil
                if isdicom(fullfile(matlabroot,'flair',deblank(dirsA(i,:)),deblank(dirsC(1,:)),deblank(filesDA(j,:))))
                X =  dicominfo(fullfile(matlabroot,'flair',deblank(dirsA(i,:)),deblank(dirsC(1,:)),deblank(filesDA(j,:))));
                name = X.PatientName;         
                end
            end
                campos=numel(fields(name));
                if campos == 2
                    [status, message, messageid] = mkdir(fullfile(matlabroot,'forg'), strcat(name.FamilyName,'-',name.GivenName) );
                    if status
                        fprintf(fid, '%s\n', strcat(name.FamilyName,'-',name.GivenName)); 
                    end
                    %____________________________ copy folders_____________
                    [status, message, messageid] = mkdir(fullfile(matlabroot,'forg',strcat(name.FamilyName,name.GivenName)),deblank(dirsC(1,:)));
                    [status, message, messageid] = copyfile(fullfile(matlabroot,'flair',deblank(dirsA(i,:)),deblank(dirsC(1,:))),...
                        fullfile(matlabroot,'forg', strcat(name.FamilyName,name.GivenName),deblank(dirsC(1,:))));
                    %______________________________________________________
                else 
                    [status, message, messageid] = mkdir(fullfile(matlabroot,'forg'), name.FamilyName);
                    if status
                        fprintf(fid, '%s\n', name.FamilyName); % escribo los nombres en el archivo
                    end
                    %____________________________ copy folders_____________
                    [status, message, messageid] = mkdir(fullfile(matlabroot,'forg',name.FamilyName),deblank(dirsC(1,:)));
                    [status, message, messageid] = copyfile(fullfile(matlabroot,'flair',deblank(dirsA(i,:)),deblank(dirsC(1,:))),...
                        fullfile(matlabroot,'forg', name.FamilyName,deblank(dirsC(1,:))));
                    %______________________________________________________
                end
            
            else
                disp(['capeta vacia # ',num2str(i)]);
            end
   %%%%%%%%%%%%%%%%%%         
            if ~isempty(filesDB)
            for j = 1 : 1%lfil
                if isdicom(fullfile(matlabroot,'flair',deblank(dirsA(i,:)),deblank(dirsC(2,:)),deblank(filesDB(j,:))))
                X =  dicominfo(fullfile(matlabroot,'flair',deblank(dirsA(i,:)),deblank(dirsC(2,:)),deblank(filesDB(j,:))));
                name = X.PatientName;          
                end
            end
            campos=numel(fields(name));
                if campos == 2
                    [status, message, messageid] = mkdir(fullfile(matlabroot,'forg'), strcat(name.FamilyName,'-',name.GivenName) );
                    if status
                        fprintf(fid, '%s\n', strcat(name.FamilyName,'-',name.GivenName)); 
                    end
                    %____________________________ copy folders_____________
                    [status, message, messageid] = mkdir(fullfile(matlabroot,'forg',strcat(name.FamilyName,name.GivenName)),deblank(dirsC(2,:)));
                    [status, message, messageid] = copyfile(fullfile(matlabroot,'flair',deblank(dirsA(i,:)),deblank(dirsC(2,:))),...
                        fullfile(matlabroot,'forg', strcat(name.FamilyName,name.GivenName),deblank(dirsC(2,:))));
                    %______________________________________________________
                else 
                    [status, message, messageid] = mkdir(fullfile(matlabroot,'forg'), name.FamilyName);
                    if status
                        fprintf(fid, '%s\n', name.FamilyName); % escribo los nombres en el archivo
                    end
                    %____________________________ copy folders_____________
                    [status, message, messageid] = mkdir(fullfile(matlabroot,'forg',name.FamilyName),deblank(dirsC(2,:)));
                    [status, message, messageid] = copyfile(fullfile(matlabroot,'flair',deblank(dirsA(i,:)),deblank(dirsC(2,:))),...
                        fullfile(matlabroot,'forg', name.FamilyName,deblank(dirsC(2,:))));
                    %______________________________________________________
                end
            
            else
                disp(['capeta vacia # ',num2str(i)]);
            end
    end
        
end

fclose(fid);
%clc

%% base de datos desde carpetas
%clc
[filesSUBJ,dirsSUBJ] = spm_select('List', fullfile(matlabroot,'forg')); % select images for the smooth
[nrows,ncols]= size(dirsSUBJ);

filename = 'celldata2.txt';
fid2 = fopen(filename, 'w');

for row=1:nrows
    fprintf(fid2, '%s \n', dirsSUBJ(row,:));
end

fclose(fid2);

type celldata2.txt
%% 
type celldata.txt


   