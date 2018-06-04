% funcion que ayuda a expandir una matriz 2 veces el tamaño original
%solo 3D
function Mexpand = expandM(Matrix)

[x1 y1 z1] = size(Matrix);
Mexpand = zeros(2*size(Matrix));

if ndims(Matrix) == 3
    for i = 1 : x1
        for j = 1 : y1
            for k = 1 : z1
                Mexpand (2*i,2*j,2*k) = Matrix(i,j,k) ;
                Mexpand (2*i,2*j,(2*k)-1) = Matrix(i,j,k);
                Mexpand (2*i,(2*j)-1,2*k) = Matrix(i,j,k);
                Mexpand ((2*i)-1,2*j,2*k) = Matrix(i,j,k);
                Mexpand ((2*i)-1,(2*j)-1,2*k) = Matrix(i,j,k);
                Mexpand ((2*i)-1,2*j,(2*k)-1) = Matrix(i,j,k);
                Mexpand (2*i,(2*j)-1,(2*k)-1) = Matrix(i,j,k);
                Mexpand ((2*i)-1,(2*j)-1,(2*k)-1) = Matrix(i,j,k);

                
            end
        end
    end
end
                