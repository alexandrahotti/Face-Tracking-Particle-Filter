function cropped = cropImage(image, bBox)
%Crops img according to bBox
%INPUT  - image H*W*3
%       - bBox  1x4
%OUTPUT - cropped size of bBox

%cropped = image(bBox(1):bBox(1)+bBox(3)-1,bBox(2):bBox(2)+bBox(4)-1,:);
cropped=imcrop(image,bBox);
end

