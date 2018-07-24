%%Inicio el cluster
if isempty(gcp('nocreate'))
    parpool;
end
%%Script para preprocesamiento
datadir = 'E:\WHconcurso data';
output_data = 'E:\WMconcurso data preproceced\';
% load_data(output_data,'grouped_data','C:\WHconcurso data');
% core_slice(output_data,'grouped_data');
% segment_images(output_data, 'grouped_data', 'C:\Users\Kevin Cando\Documents\MATLAB\spm12\tpm');
% white_matter_extration(output_data,'grouped_data');
% create_template(output_data, 'grouped_data');
% normalize_mni(output_data, 'grouped_data', 'C:\Users\Kevin Cando\Documents\MATLAB\spm12\tpm');

%%Llamada a Tensorflow en Python
segmentation_lessions(output_data, 'grouped_data', 'NE');
segmentation_lessions(output_data, 'grouped_data', 'MNI');
%%Resultados temporales