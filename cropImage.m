function cropped = cropImage(image, bBox)
%Crops img according to bBox
%INPUT  - image H*W*3
%       - bBox  1x4
%OUTPUT - cropped size of bBox

cropped=imcrop(image,bBox);
end

