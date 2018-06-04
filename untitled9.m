%% 

for  j =1 : med(1)
    for k = 1 : 
    
B(j,k) = Arch{j,k}
    end

Arch{1,1}(1)
%% 

f = figure('Position',[200 200 600 550]);
dat = rand(3); 
cnames = {'X-Data','Y-Data','Z-Data'};
rnames = {'First','Second','Third'};
t = uitable('Parent',f,'Data',B,'ColumnName',cnames,... 
            'RowName',rnames,'Position',[20 20 560 530]);