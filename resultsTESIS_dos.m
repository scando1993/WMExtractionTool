function resultsTESIS_dos
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%% Initialize variables.
matlabroot= fullfile(spm('Dir'),'toolbox','ACL');
files = cellstr(spm_select('List',matlabroot,'^15jul_.*\.txt$'));
med = size(files);
for i = 1 :  med (1)
    rc2{i} = char(fullfile(matlabroot,deblank(files(i,:))))
end

%% 
for i = 1 :  med (1)
    Arch{i}  = importfileTESIS_dos(rc2{i});
end
 Arch = Arch';
%% 

patol = importfileTESIS_dos('/Users/orlando/Documents/MATLAB/spm12b/toolbox/ACL/PATOLOGIAS.txt');
edad = importfileTESIS_dos('/Users/orlando/Documents/MATLAB/spm12b/toolbox/ACL/EDAD.txt');
%% Open the text file.
fileID = fopen('/Users/orlando/Documents/MATLAB/spm12b/toolbox/ACL/SEXO.txt','r');
% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
sexo = textscan(fileID, '%s%[^\n\r]', 'Delimiter', '',  'ReturnOnError', false);
% Close the text file.
fclose(fileID);
SEX = cellstr(sexo{1,1})
for k =1 : length (SEX)
    if SEX{k} == 'M'
    SEXO_N(k) = 1;
    else
        SEXO_N(k) = 0;
    end
end
SEXO_N = SEXO_N';
%% 
for i = 1 :  length(SEX)
Sujeto (i)= i;
end
Sujeto = Sujeto';
%% 
 dat = [edad,patol,Arch{1},Arch{2},Arch{3},Arch{4},Arch{5},Arch{6},Arch{7},Arch{8},Arch{9},Arch{10},Arch{11},Arch{12},Arch{13},Arch{14},Arch{15}]

%% 
cnames = {'Edad','Patologia','<html>Volumen<br />Espacio Nativo</html>' ,'<html>Cantida<br />Espacio Nativo</html>','<html>Fractalidad<br />Espacio Nativo</html>',...
    '<html>Intensidad <br />Espacio Nativo</html>','<html>Volumen<br />Espacio MNI</html>','<html>Cantida<br />Espacio MNI</html>','<html>Fractalidad<br />Espacio MNI</html>',...
    '<html>region1<br />cerebellum','<html>region2<br />frontal lobe','<html>region3<br />lt hemisphere','<html>region4<br />occipital lobe'...
    '<html>region5<br />parietal lobe</html>','<html>region6<br />rt hemisphere</html>','<html>region7<br />sub lobar</html>','<html>region8<br />temporal lobe</html>'}

%% 

f = figure('Position',[200 200 1200 700]);
%dat = rand(36,18); 
% cnames = {'X-Data','Y-Data'};
rnames = Sujeto;
tablet = uitable('Parent',f,'Data',dat,'ColumnName',cnames,... 
            'RowName',rnames,'Position',[20 20 1150 650]);

end





