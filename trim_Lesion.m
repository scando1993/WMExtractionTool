% Recorta la matriz general que contiene la lesion y solo deja matriz 
% mas pequeña que contiene la lesion y la invierte
function [Mtrim] = trim_Lesion ( RED )

[sx, sy, sz] = size(RED);
for u =1 : sz
    axial_image = RED(:,:,sz);
    [r,c] = size(axial_image);	%dim1=rows, dim2=columns, dim3=# of anatomical %slices, dim4=# of temporal repetitions
    mxs = max(max(axial_image))	;		%Calculate mean for 4-D array
        if mxs == 0
        %     ICJ(ICJ==0) = [];

        RED(:,:,sz) = [];

        [sx, sy, sz] = size(RED);
        end
end
  
     RED = flipdim(RED,3);
     [sx, sy, sz] = size(RED);
for u =1 : sz
    axial_image = RED(:,:,sz);
    [r,c] = size(axial_image);	%dim1=rows, dim2=columns, dim3=# of anatomical %slices, dim4=# of temporal repetitions
    mxs = max(max(axial_image))	;		%Calculate mean for 4-D array
        if mxs == 0
        %     ICJ(ICJ==0) = [];

        RED(:,:,sz) = [];

        [sx, sy, sz] = size(RED);
        end
end

%% 
  

 [sx2, sy2, sz2] = size(RED);
 
 
  
  %
  %
  for u =1 : sy2
    axial_image2 = RED(:,sy2,:);
    [r,c] = size(axial_image2);	%dim1=rows, dim2=columns, dim3=# of anatomical %slices, dim4=# of temporal repetitions
    mxs2 = max(max(axial_image2));			%Calculate mean for 4-D array
        if mxs2 == 0
%         %     ICJ(ICJ==0) = [];
% 
        RED(:,sy2,:) = [];
% 
        [sx2, sy2, sz2] = size(RED);
        end
  end
  
   RED = flipdim(RED,2);
   
   [sx2, sy2, sz2] = size(RED);
 
 
  
  %
  %
  for u =1 : sy2
    axial_image2 = RED(:,sy2,:);
    [r,c] = size(axial_image2);	%dim1=rows, dim2=columns, dim3=# of anatomical %slices, dim4=# of temporal repetitions
    mxs2 = max(max(axial_image2));			%Calculate mean for 4-D array
        if mxs2 == 0
%         %     ICJ(ICJ==0) = [];
% 
        RED(:,sy2,:) = [];
% 
        [sx2, sy2, sz2] = size(RED);
        end
  end
   
  %% 

 [sx3, sy3, sz3] = size(RED);

  for u =1 : sx3
    axial_image3 = RED(sx3,:,:);
    [r,c] = size(axial_image3);	%dim1=rows, dim2=columns, dim3=# of anatomical %slices, dim4=# of temporal repetitions
    mxs3 = max(max(axial_image3));			%Calculate mean for 4-D array
        if mxs3 == 0
%         %     ICJ(ICJ==0) = [];
% 
        RED(sx3,:,:) = [];
% 
        [sx3, sy3, sz3] = size(RED);
        end
  end
  
   RED = flipdim(RED,1);
   
   [sx3, sy3, sz3] = size(RED);

  for u =1 : sx3
    axial_image3 = RED(sx3,:,:);
    [r,c] = size(axial_image3);	%dim1=rows, dim2=columns, dim3=# of anatomical %slices, dim4=# of temporal repetitions
    mxs3 = max(max(axial_image3));			%Calculate mean for 4-D array
        if mxs3 == 0
%         %     ICJ(ICJ==0) = [];
% 
        RED(sx3,:,:) = [];
% 
        [sx3, sy3, sz3] = size(RED);
        end
  end 
  Mtrim = RED; 
  return;
 
 