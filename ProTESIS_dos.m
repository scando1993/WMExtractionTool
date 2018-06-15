%% Dicom
function ProTESIS_dos (ruta,nombresdepoblacion)
%% 
% funcion que convierte las imagenes DICOM a formato .nii
% Útil porque muchos escáneres exportan sus datos en formato DICOM. 
% Esta rutina convierte los ficheros DICOM en volúmenes de imagen 
% compatibles con SPM
%%
% 
% * ESPOL     FIEC & FIMCP    NBL"Neuroimaging & Bioengineering Laboratory"
% * Orlando Chancay
% * $Id: organizarfoldersTESIS.m  23-Nov-2013  9:48:13z$
%
%% Descripcion
% Esta funcion seleciona todas los cortes de una imagen y los convierte en
% unico volumen.
% se usa las funciones para selecionar ficheros como 'spm_select', una
% funcion para obtener las cabezeras de las imagenes DICOM
% 'spm_dicom_headers', y la funcion 'spm_dicom_convert' que nos ayuda a
% convertir las imagenes a .nii
%% Código
% la ruta de la carpeta de trabajo es enviada desde el programa principal
% y los nombre de los grupos.
% en las variable *ruta* , *nombresdepoblacion* 





fprintf('ACL Working in DICOM converter\n');
tic
% matlabroot='/Users/orlando/Documents/MATLAB/TESIS/test';
matlabroot = ruta;
%% elegir varias poblaciones
poblacion = nombresdepoblacion;% {'HC', 'LPD', 'RPD'};

for pobl = 1 : length (poblacion)

    [sb_files , subjects] = spm_select('List',fullfile(matlabroot,poblacion(pobl)));
    subjects = cellstr(subjects)'; % escojo todos los sujetos del estudio

    %% create folder temporal
    for  i=1: length(subjects)
        [status,message,messageid] = mkdir(char(fullfile(matlabroot,poblacion(pobl),subjects{i})),'TEMP6');
    end
    % %% create folder DICOM
    % for  i=1: length(subjects)
    %     [status,message,messageid] = mkdir(char(fullfile(matlabroot,poblacion(pobl),subjects{i})),'DICOM');
    % end
    %% delete folder temporal
%     
%     for  i=1: length(subjects)
%         [status,message,messageid] = rmdir(char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6')),'s');
%     end

    %% escojo los DICOM

    for i=1: length(subjects)


        [files,dirsDICOM] = spm_select('List',fullfile(matlabroot,poblacion(pobl),subjects{i},'DICOM'));
        [fd cds] = size(dirsDICOM);
        for d = 1 : fd
            [filesDICOM,dirs] = spm_select('List',fullfile(matlabroot,poblacion(pobl),subjects{i},'DICOM', deblank(dirsDICOM(d,:))),'\.dcm');
    %         [filesFLAIR,dirsFLAIR] = spm_select('List',fullfile(matlabroot,subjects{i},'DICOM',dirsDICOM(2,:)),'\.dcm');
            if filesDICOM > 0 % confirm which exist DICON files
                for j = 1 : 1%lfil % get informations of field
                    if isdicom(char(fullfile(matlabroot,poblacion(pobl),subjects{i},'DICOM', deblank(dirsDICOM(d,:)),deblank(filesDICOM(j,:)))));
    %                 if isdicom(fullfile(matlabroot,'forg',deblank(dirsA(sub,:)),deblank(dirsB(lp,:)),deblank(filesDICOM(j,:))))
                        X =  dicominfo(char(fullfile(matlabroot,poblacion(pobl),subjects{i},'DICOM', deblank(dirsDICOM(d,:)),deblank(filesDICOM(j,:)))));
    %                     X =  dicominfo(fullfile(matlabroot,'forg',deblank(dirsA(sub,:)),deblank(dirsB(lp,:)),deblank(filesDICOM(j,:))));
                        name = X.PatientName;
                        secuencia = X.SeriesDescription;
                    end
                end 
            
            end
            %spm_my_defauls;
            spm('Defaults','FMRI');
            [ff,cf] =  size(filesDICOM);
            clear hdr;
            for ft=1 : ff
            hdr(ft,1) = spm_dicom_headers(char(fullfile(matlabroot,poblacion(pobl),subjects{i},'DICOM',deblank(dirsDICOM(d,:))...
                ,deblank(filesDICOM(ft,:)))));
            end
%             if strcmp( secuencia , 't1_mprage_TRA_1x1x1')
%                 for ft=1 : ff
%                     hdr{ft,1}.StudyID = 'T1'
%                 end
%             else
%                 for ft=1 : ff
%                     hdr{ft,1}.StudyID = 'FLAIR'
%                 end
%             end
            [status,message,messageid] = mkdir(char(fullfile(matlabroot,poblacion(pobl),subjects{i},'TEMP6')),secuencia);
            cd(char(fullfile(matlabroot,poblacion{pobl},deblank(subjects{i}),'TEMP6',secuencia)));
%             cd('/Users/orlando/Documents/MATLAB/TESIS/test')
             spm_dicom_convert(hdr,'all','flat','nii');
             

        end
    end



end
fprintf('ACL Done DICOM converter\n');
toc