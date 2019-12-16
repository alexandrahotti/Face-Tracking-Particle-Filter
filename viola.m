function bBox = viola(image)
%Does Viola to get bounding box
FDetect = vision.CascadeObjectDetector;
bBox = step(FDetect, image);

end

