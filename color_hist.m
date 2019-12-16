%clear;

vid = VideoReader('sample4.mp4');
nFrames = vid.NumberOfFrames;
startFrame = 1;
step = 4;
no_bins = 8;

colorHistR = zeros(no_bins,1);
colorHistG = zeros(no_bins,1);
colorHistB = zeros(no_bins,1);


for i = startFrame : step : nFrames
    %img = read(vid, i);
    
    
    windowWidth = 146;%size(img,2);
    windowHeight = 146;%size(img,1);
    
    % Temp dummy center
    targetX = windowWidth/2;
    targetY = windowHeight/2;
    
   % img = img(342:342+145,191:191+145,:);
    
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
    
    
    % ceil - Round up to the next integer
    % Map the img RGB values to closest bin. 
    
%     imgBinsR = double(ceil( img(:,:,1) / 32 ));
%     imgBinsG = double(ceil( img(:,:,2) / 32 ));
%     imgBinsB = double(ceil( img(:,:,3) / 32 ));
    
    binInterval = linspace(0, 255, 9);
    [~,~, imgBinsR] = histcounts(reshape(img(:,:,1), [146, 146]), binInterval);
    [~,~, imgBinsG] = histcounts(reshape(img(:,:,2), [146, 146]), binInterval);
    [~,~, imgBinsB] = histcounts(reshape(img(:,:,3), [146, 146]), binInterval);
     
    aaaa = imgBinsR';
for bin = 1 : no_bins
    redBinsInds = find(imgBinsR == bin);
    greenBinsInds = find(imgBinsG == bin);
    blueBinsInds = find(imgBinsB == bin);
    
    weightedRedImg = imgBinsR .* centerDistWeights;
    weightedGreenImg  = imgBinsG .* centerDistWeights;
    weightedBlueImg  = imgBinsB .* centerDistWeights;
    
    redBins = weightedRedImg(redBinsInds);
    greenBins = weightedGreenImg(greenBinsInds);
    blueBins = weightedBlueImg(blueBinsInds);
    
    colorHistR(bin) = sum(sum(redBins));
    colorHistG(bin) = sum(sum(greenBins));
    colorHistB(bin) = sum(sum(blueBins));
    
end
                       
    colorHistR = colorHistR/sum(colorHistR);
    colorHistG = colorHistG/sum(colorHistG);
    colorHistB = colorHistB/sum(colorHistB);

end