clear;

vid = VideoReader('sample4.mp4');
nFrames = vid.NumberOfFrames;
startFrame = 1;
step = 4;
no_bins = 8;
targetColorHist = zeros(no_bins, no_bins, no_bins);

for i = startFrame : step : nFrames
    img = read(vid, i);
    
    
    windowWidth = size(img,2);
    windowHeight = size(img,1);
    
    % Temp dummy center
    targetX = 13;
    targetY = 13;
    
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
    removedPixelCoords = find((1 - normCenterDists.^2) >= 1); 
    normCenterDists(removedPixelCoords) = 0;
    
    centerDistWeights = normCenterDists;
    
    
    
    % ceil - Round up to the next integer
    % Map the img RGB values to closest bin. 
    %imgBins = ceil( img / 32 );
    
    imgBinsR = ceil( img(:,:,1) / 32 );
    imgBinsG = ceil( img(:,:,2) / 32 );
    imgBinsB = ceil( img(:,:,3) / 32 );
    
    
    
    for r = 1 : no_bins
        for g = 1 : no_bins
            for b = 1 : no_bins
                
                
                indR = find(imgBinsR == r);
                indG = find(imgBinsG == g);
                indB = find(imgBinsB == b);
                
                
                % Find common indicies for current r,g,b.
                binVoteInd = indR(ismember(indR, indG));
                binVoteInd = binVoteInd(ismember(binVoteInd,indB));
                
                % Check that there is a vote for this particular bin.
                % vector but indicies same side as window
                binContainsVotes = size(binVoteInd,1);
                
                if binContainsVotes
                    
                    votingMatrix = zeros(windowWidth, windowHeight);
                    
                    % Like using dirac
                    votingMatrix(binContainsVotes) = 1;
                    weightedBins = votingMatrix .* centerDistWeights';
                    
                    targetColorHist(r,g,b) = sum(sum(weightedBins));
                    
                end
                
            end
        end
    end
    
    norm_const = sum(sum(sum(targetColorHist)));
    
    targetColorHist = targetColorHist/norm_const;

end