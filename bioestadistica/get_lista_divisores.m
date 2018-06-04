function lista_div = get_lista_divisores(N)
lista_div=[];
for i=1:floor(N/2)
    if mod(N,i)==0
        lista_div(end+1,1)=i;
    end
end