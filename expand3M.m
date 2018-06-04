% funcion que me ayuda a expandir una matriz en 3 dimensiones
% 3 veces su tamosño original.
function Mexpand = expand3M(Matrix)

[x1 y1 z1] = size(Matrix);
Mexpand = zeros(3*size(Matrix));

if ndims(Matrix) == 3
    for i = 1 : x1
        for j = 1 : y1
            for k = 1 : z1
                Mexpand (3*i,3*j,3*k) = Matrix(i,j,k) ;
                Mexpand ((3*i)-1,3*j,3*k) = Matrix(i,j,k) ;
                Mexpand ((3*i)-2,3*j,3*k) = Matrix(i,j,k) ;
                Mexpand (3*i,(3*j)-1,3*k) = Matrix(i,j,k) ;
                Mexpand ((3*i)-1,(3*j)-1,3*k) = Matrix(i,j,k) ;
                Mexpand ((3*i)-2,(3*j)-1,3*k) = Matrix(i,j,k) ;
                Mexpand (3*i,(3*j)-2,3*k) = Matrix(i,j,k) ;
                Mexpand ((3*i)-1,(3*j)-2,3*k) = Matrix(i,j,k) ;
                Mexpand ((3*i)-2,(3*j)-2,3*k) = Matrix(i,j,k) ;

                Mexpand (3*i,3*j,(3*k)-1) = Matrix(i,j,k) ;
                Mexpand ((3*i)-1,3*j,(3*k)-1) = Matrix(i,j,k) ;
                Mexpand ((3*i)-2,3*j,(3*k)-1) = Matrix(i,j,k) ;
                Mexpand (3*i,(3*j)-1,(3*k)-1) = Matrix(i,j,k) ;
                Mexpand ((3*i)-1,(3*j)-1,(3*k)-1) = Matrix(i,j,k) ;
                Mexpand ((3*i)-2,(3*j)-1,(3*k)-1) = Matrix(i,j,k) ;
                Mexpand (3*i,(3*j)-2,(3*k)-1) = Matrix(i,j,k) ;
                Mexpand ((3*i)-1,(3*j)-2,(3*k)-1) = Matrix(i,j,k) ;
                Mexpand ((3*i)-2,(3*j)-2,(3*k)-1) = Matrix(i,j,k) ;
                
                Mexpand (3*i,3*j,(3*k)-2) = Matrix(i,j,k) ;
                Mexpand ((3*i)-1,3*j,(3*k)-2) = Matrix(i,j,k) ;
                Mexpand ((3*i)-2,3*j,(3*k)-2) = Matrix(i,j,k) ;
                Mexpand (3*i,(3*j)-1,(3*k)-2) = Matrix(i,j,k) ;
                Mexpand ((3*i)-1,(3*j)-1,(3*k)-2) = Matrix(i,j,k) ;
                Mexpand ((3*i)-2,(3*j)-1,(3*k)-2) = Matrix(i,j,k) ;
                Mexpand (3*i,(3*j)-2,(3*k)-2) = Matrix(i,j,k) ;
                Mexpand ((3*i)-1,(3*j)-2,(3*k)-2) = Matrix(i,j,k) ;
                Mexpand ((3*i)-2,(3*j)-2,(3*k)-2) = Matrix(i,j,k) ;

              

                
            end
        end
    end
end
          