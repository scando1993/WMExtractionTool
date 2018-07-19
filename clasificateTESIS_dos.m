%% Classify
function clasificateTESIS_dos(ruta,tabla,nombredegrupos)
%%
% Funcion de ACL para clasificar las imagenes en diferentes patologias
% en nuestro caso tenemos que crear 3 Grupos 'HC' controles sanos, 'LPD'
% Parkinsons Izquierdos, 'RPD' Parkinsons Derechos.
% Al utilizar esta opcion tenemos que ingresar en numero y los nombres de 
% los grupos que queremos crear.
% Tambien tenemos que selecionar en una tabla mediante un check a que grupo
% queremos que pertenesca nuestras imágenes.
%%
% 
% * ESPOL     FIEC & FIMCP    NBL"Neuroimaging & Bioengineering Laboratory"
%% Descripcion
% Crea carpetas las que el usuario selecion en nuestro caso crearemos 3
% carpetas 'HC', 'LPD', 'RPD.
% Se crea una tabla con los nombres de los sujetos en la cual tenemos que
% selecionar a que Grupo de paciente queremos que pertenesca, una vez
% selecionado y presionado el boton Save&OK las imagenes son desplazadas a
% las carpetas selecionadas.
% se usa las funciones 'spm_select', funciones de archivo como 'fopen' y
% funciones de tablas 'uitable'.
%% Código
% la ruta de la carpeta de trabajo es enviada desde el programa principal
% como la tabla y los nombre de los grupos.
% en las variable *ruta*  , *tabla*, *nombredegrupos*      

        
        for i = 1 : length (nombredegrupos)
            
        if exist(fullfile(ruta,nombredegrupos{i}))
            h = msgbox(strcat('La carpeta ',nombredegrupos{i} ,' ya existe'),'!! Warning !!','warn');
        else
        [status,message,messageid] = mkdir(char(fullfile(ruta)),nombredegrupos{i});
        end
        
        [f1 c1]= size(tabla);
        for h = 1: f1
         if cell2mat(tabla(h,2))==1
             
            if strcmp(tabla(h,3) , nombredegrupos{i})
            mkdir(char(fullfile(ruta,nombredegrupos{i})),char(tabla(h,1)));
            copyfile(fullfile(ruta,'forg2',char(tabla(h,1))),fullfile(ruta,nombredegrupos{i},char(tabla(h,1))));
            end
%             if strcmp(tabla(h,3) , 'HC')
%             mkdir(char(fullfile(ruta,'HC')),char(tabla(h,1)));
%             copyfile(fullfile(ruta,'forg2',char(tabla(h,1))),fullfile(ruta,'HC',char(tabla(h,1))));
%             end
%             if strcmp(tabla(h,3) , 'RPD')
%             mkdir(char(fullfile(ruta,'RPD')),char(tabla(h,1)));
%             copyfile(fullfile(ruta,'forg2',char(tabla(h,1))),fullfile(ruta,'RPD',char(tabla(h,1))));
%             end
         end
        end
        end
       
