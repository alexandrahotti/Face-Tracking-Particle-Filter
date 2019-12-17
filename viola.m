function [stateVector, bBox] = viola(image)
%Does Viola to get bounding box
FDetect = vision.CascadeObjectDetector;
allTheThings = step(FDetect, image);
stateVector = allTheThings(1:2);
bBox= allTheThings(3:4);

end

