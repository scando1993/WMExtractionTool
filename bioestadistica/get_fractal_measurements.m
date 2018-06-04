%function [D0,D1,D2,L,XD0,XD1,XD2,XL,YD0,YD1,YD2,YL]=get_fractal_measurements(walk)
%computes 4 descriptors of dimension espectrum for 2D coords and for each
%coord separately
%D0=fractal dimension
%D1=information dimension,
%D2=correlation dimension
%L=lacunarity
%X refers to X-axis coordinates only 
%Y refers to Y-axis coordinates only
function R=get_fractal_measurements(walk)

aux = minmax(walk');
minX=aux(1,1); maxX=aux(1,2);minY=aux(2,1); maxY=aux(2,2);

width = maxX - minX + 1;
height = maxY - minY + 1;

width_extra = 12 - mod(width,12);
height_extra = 12 - mod(height,12);

walk_mod=walk;
walk_mod(:,1) = walk_mod(:,1) - minX + 1 + floor(width_extra/2);
walk_mod(:,2) = walk_mod(:,2) - minY + 1 + floor(height_extra/2);

object = zeros(width+width_extra,height+height_extra);
objectX = zeros(width+width_extra,1);
objectY = zeros(height+height_extra,1);

for i=1:size(walk_mod,1)
    object(floor(walk_mod(i,1)),floor(walk_mod(i,2)))=1;
    objectX(floor(walk_mod(i,1)),1)=1;
    objectY(floor(walk_mod(i,2)),1)=1;

end

divisores = intersect(get_lista_divisores(size(object,1)),get_lista_divisores(size(object,2)));

[D0,D1,D2,L] = get_dimension_espectrum_2D(object,divisores);
[XD0,XD1,XD2,XL] = get_dimension_espectrum_1D(objectX,divisores);
[YD0,YD1,YD2,YL] = get_dimension_espectrum_1D(objectY,divisores);
R=[D0,D1,D2,L,XD0,XD1,XD2,XL,YD0,YD1,YD2,YL];



