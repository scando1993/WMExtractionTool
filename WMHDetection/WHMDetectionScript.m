%%Inicio el cluster
if isempty(gcp('nocreate'))
    parpool;
end
%%Script para preprocesamiento
datadir = 'C:\WHconcurso data';
% load_data(pwd,'C:\WHconcurso data');
% core_slice(pwd,'grouped_data');
% segment_images(pwd, 'grouped_data', 'C:\Users\Kevin Cando\Documents\MATLAB\spm12\tpm');
% white_matter_extration(pwd,'grouped_data');
% create_template(pwd, 'grouped_data');
normalize_mni(pwd, 'grouped_data', 'C:\Users\Kevin Cando\Documents\MATLAB\spm12\tpm');
%%Llamada a Tensorflow en Python
%%Resultados temporales