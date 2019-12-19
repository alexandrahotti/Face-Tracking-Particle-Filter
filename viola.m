function [stateVector, bBox] = viola(image)
%Does Viola to get bounding box
stateVector = zeros(1,4);

FDetect = vision.CascadeObjectDetector;
allTheThings = step(FDetect, image);

stateVector(1:2) = allTheThings(1:2);
bBox= allTheThings(3:4);
end

