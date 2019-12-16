
function [colorHistR, colorHistG, colorHistB] = createColorHist( boundingBox )
% Input: A bounding box centered on a particles.
% Output: Color histograms for the bounding box from the R, G & B channels.

no_bins = 8;

colorHistR = zeros(no_bins,1);
colorHistG = zeros(no_bins,1);
colorHistB = zeros(no_bins,1);

% Bounding box dimensions.
[windowWidth, windowHeight] = size(boundingBox);

% Center coordinates.
targetX = windowWidth/2;
targetY = windowHeight/2;


%% The weighting based on distance from each pixel to the center.
% The normalization const.
a =  sqrt(windowWidth^2 + windowHeight^2);

% Create a coordinate system for the bounding boxes.
pixelCoordsX = repmat(1:windowWidth,[windowHeight,1]);
pixelCoordsY = repmat((1:windowHeight)',[1,windowWidth]);


% Threshold on distance to target center coordinate.
centerDists = sqrt((targetX - pixelCoordsX).^2 + (targetY - pixelCoordsY).^2) ;

% Normalize distance to target center to account for that different
% boundingboxes could have different sizes.
normCenterDists = centerDists/a;

% Use a threshold so that only pixels within the bounding box are used
% to update the color histogram.
removedPixelCoords = find(normCenterDists >= 1);
centerDistWeights = 1-normCenterDists.^2;
centerDistWeights(removedPixelCoords) = 0;

% Map the boundingBox RGB values to closest bin. 
binInterval = linspace(0, 255, 9);
[~,~, boundingBoxBinsR] = histcounts(reshape(boundingBox(:,:,1), [windowWidth, windowHeight]), binInterval);
[~,~, boundingBoxBinsG] = histcounts(reshape(boundingBox(:,:,2), [windowWidth, windowHeight]), binInterval);
[~,~, boundingBoxBinsB] = histcounts(reshape(boundingBox(:,:,3), [windowWidth, windowHeight]), binInterval);

%% 
for bin = 1 : no_bins
    redBinsInds = find(boundingBoxBinsR == bin);
    greenBinsInds = find(boundingBoxBinsG == bin);
    blueBinsInds = find(boundingBoxBinsB == bin);

    weightedRedboundingBox = boundingBoxBinsR .* centerDistWeights;
    weightedGreenboundingBox  = boundingBoxBinsG .* centerDistWeights;
    weightedBlueboundingBox  = boundingBoxBinsB .* centerDistWeights;

    redBins = weightedRedboundingBox(redBinsInds);
    greenBins = weightedGreenboundingBox(greenBinsInds);
    blueBins = weightedBlueboundingBox(blueBinsInds);

    colorHistR(bin) = sum(sum(redBins));
    colorHistG(bin) = sum(sum(greenBins));
    colorHistB(bin) = sum(sum(blueBins));

end

colorHistR = colorHistR/sum(colorHistR);
colorHistG = colorHistG/sum(colorHistG);
colorHistB = colorHistB/sum(colorHistB);

end
