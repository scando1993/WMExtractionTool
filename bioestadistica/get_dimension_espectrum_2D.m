%the input object is a probabilistic cube coming from a sliding cube strategy of size [width_i,width_k,width_k]

function [D0,D1,D2,L,V,RD1] = get_dimension_espectrum_2D(object,r)

nnz_object = nnz(object(:)); %the volume of the probabilistic object is the sum of its voxel-probabilities
[width_i,width_j]=size(object);
        
D0_num = zeros(numel(r),1);
D1_num = zeros(numel(r),1);
D2_num = zeros(numel(r),1);
L_points = zeros(numel(r),1);
%M = width_min./r; %vector containing the number of boxes for each size r

for index_size = 1:numel(r)
    cell_size = r(index_size);
    N = nan(width_i/cell_size,width_j/cell_size); %counting elements grid of the image with size depending on cell_size

    if (cell_size == 1) %max resolution: box is pixel-size
        Ncum = nnz_object;
        D0_num(index_size) = nnz_object;
        D1_num(index_size) = -log(1/nnz_object); %simplified equation
        D2_num(index_size) = 1/nnz_object; %num_points_object*((1/num_points_object)^2);
        L_points(index_size) = std(object(:))^2/mean(object(:))^2;
    else
        Ncum = 0;
        for i=1:cell_size:width_i-cell_size+1    
            for j=1:cell_size:width_j-cell_size+1
                
                current_cell = object(i:i+cell_size-1,j:j+cell_size-1);

                current_N = nnz(current_cell(:)); %sum of voxel-prob in current cell
                current_p = current_N/nnz_object; %relative frequency respect to points covered by current grid
                Ncum = Ncum + current_N; %store current N
                N(1+((i-1)/cell_size),1+((j-1)/cell_size)) = current_N; %store N value

                if (current_p > 0) %if current_cell covered part of the probabilistic object
                    D0_num(index_size) = D0_num(index_size) + 1;
                    if current_p < 1 %no entropy for extreme cases of p=0 or p=1
                        D1_num(index_size) = D1_num(index_size) - current_p*log(current_p);
                    elseif (current_p > 1)
                        error('current_p cannot be greater than one')
                    end
                    D2_num(index_size) = D2_num(index_size) + (current_p^2);
                end
            end
        end
     
        L_points(index_size) = std(N(:))^2/(mean(N(:))^2); %lacunarity value for current cell_size
        
    end
    if (nnz_object - Ncum)>10^(-6)
        error('incoherence in the number of points for r=%d',r(index_size))
    end
end   

values = polyfit(log(1./r),log(D0_num),1);
D0 = values(1);

values = polyfit(log(1./r),D1_num,1);
D1 = values(1);
RD1 = corr(log(1./r),D1_num)^2; %R-square of the D1 fractal dimension

values = polyfit(log(1./r),log(D2_num),1);
D2 = -values(1);

values = polyfit(log(1./r),log(L_points),1);
L = values(1);

V = nnz_object/numel(object);