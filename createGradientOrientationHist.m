
function gradientOrientationHist = createGradientOrientationHist( croppedImage )
% Input: A bounding box centered on a particles.
% Output: Color histograms for the bounding box from the R, G & B channels.

%% Debugging code
% vid = VideoReader('C:\Users\Alexa\Desktop\KTH\årskurs_5\Applied Estimation\Project\sample4.mp4');
% nFrames = vid.NumberOfFrames;
% startFrame = 1;
% step = 4;
% 
% img = read(vid, startFrame);
% croppedImage = img(342:342+145,191:191+145,:);

%% Parameter init
no_bins = 8;
gradientOrientationHist = zeros(no_bins,1);

% Bounding box dimensions.
[windowWidth, windowHeight, ~ ] = size(croppedImage);

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
% croppedImagees could have different sizes.
normCenterDists = centerDists/a;

% Use a threshold so that only pixels within the bounding box are used
% to update the color histogram.
removedPixelCoords = normCenterDists >= 1;
centerDistWeights = 1-normCenterDists.^2;
centerDistWeights(removedPixelCoords) = 0;

grayScaleImg = rgb2gray(croppedImage);
[Gmag, Gdir] = imgradient(grayScaleImg, 'sobel');

% weight the bin pixel weigts by the imgae gradient magnitude.
centerDistWeights = centerDistWeights .* Gmag;

% Map the croppedImage RGB values to closest bin. 
binInterval = linspace(0, 180, 9);
[~,~, imgBins] = histcounts(reshape(Gdir, [windowWidth, windowHeight]), binInterval);

%% 
for bin = 1 : no_bins
    gradientBins = imgBins == bin;
   
    weightedImage = imgBins .* centerDistWeights;
    
    weightedImageBins = weightedImage(gradientBins);
    
    gradientOrientationHist(bin) = sum(sum(weightedImageBins));
end

%% Normalize the histogram so that the histogram sums to 1.
gradientOrientationHist = gradientOrientationHist/sum(gradientOrientationHist);

end
