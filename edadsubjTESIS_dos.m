function edadsubjTESIS_dos
% Funcion que calcula la edad de los sujetos de todo el estudio
%__________________________________________________________________________
% ESPOL     FIEC & FIMCP    NBL"Neuroimaging & Bioengineering Laboratory"

% Orlando Chancay
% $Id: seg_lesTESIS.m  25-Nov-2013  9:48:13z$
%% Edades y otros campos
%% 
clc 
clear all 
close all
disp('******** beginning CALCULOS DE EDADES DE SUBJECTS ********');
tic
%%  
filename = 'Datos_sujetos_estudio.txt';
fid2 = fopen(filename, 'w');
%% root
matlabroot='/Users/orlando/Documents/MATLAB/TESIS/test';

%% elegir varias poblaciones
poblacion = {'HC', 'LPD', 'RPD'};
for pobl = 1 : length (poblacion)

    [sb_files , subjects] = spm_select('List',char(fullfile(matlabroot,poblacion(pobl))));
    subjects = cellstr(subjects)'; % escojo todos los sujetos del estudio
    
    
    for i=1 : length(subjects)
        
          [files,folders]       = spm_select('List', char(fullfile(matlabroot,poblacion(pobl),subjects{i},'DICOM'))); % select images for the smooth
          [filesDCM,dirsDCM]    = spm_select('List', char(fullfile(matlabroot,poblacion(pobl),subjects{i},'DICOM',deblank(folders(1,:)))),'\.dcm');  
                    X =  dicominfo(char(fullfile(matlabroot,poblacion(pobl),subjects{i},'DICOM',deblank(folders(1,:)),deblank(filesDCM(1,:)))));
                    name = X.PatientName;
                    

                
                        %% 
     
     fprintf(fid2, '%s %s %s %s %s %s %s %s\n', 'SUJETO# ',num2str(i),'NOMBRE  ',name.FamilyName,' SEXO  ',X.PatientSex,' AÑOS ',X.PatientAge);

    end
end
toc
fclose(fid2);
disp('done Datos de Sujetos')

    %% 