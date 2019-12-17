%% main for color
%vid = VideoReader('C:\Users\Alexa\Desktop\KTH\�rskurs_5\Applied Estimation\Project\sample4.mp4');
addpath('indata');
vid = VideoReader('sample4.mp4');

noVideoFrams = vid.NumberOfFrames;
timeStepSkip = 4;

M = 100;
alpha=0.1;
sigmaNoise = 0.2;
sigmaColor = 0.3;
sigmaGrad = 0.3;
no_bins = 8;

liklihoodsColor = zeros(M, no_bins*3);
liklihoodsGradient = zeros(M, no_bins);
dC = zeros(M, 1);
dE = zeros(M, 1);
wC = zeros(M, 1);
wE = zeros(M, 1);
wT = zeros(M, 1);


for t = 1 : timeStepSkip : noVideoFrams
    image = read(vid, t);
    imageSize = size(image);
    
    if t ==1
        [stateVector, boundingBox] = viola(image);
        w = size(image,1);
        h = size(image,2);
        %particles = initParticles([stateVector, boundingBox], M);
        particles = initParticlesGlobal([w h]-boundingBox/2, M);
        dBB = initDBB(cornerToCenter([stateVector, boundingBox]),particles);
        %[boundingBox, dBB]  = initStateVector(boundingBox);
        
        % Crop the image according to the bounding box.
        cropped = cropImage(image, [stateVector, boundingBox]);
        qC = createColorHist(cropped);
        
    else
        % predict
        [boundingBox, dBB] = predictBoundingBox(cornerToCenter([stateVector, boundingBox]), boundingBox, dBB, particles);
    end
    
    
    % Propagate the particles.
    particles = propagate(particles, sigmaNoise, imageSize);
    
    % Weight update.
    
    for p = 1:M
        cornerP = centerToCorner(particles(p, 1:2), boundingBox);
        croppedImg = cropImage(image, [cornerP, boundingBox]); % Obs os�ker p� om w h eller h w.
        colorHist = createColorHist(croppedImg);
        liklihoodsColor(p, :) = colorHist;
        
    end
    
    dC = bhattacharyya(liklihoodsColor, qC);
    
    wC = calculateWeights(dC, sigmaColor);
    wTotal = wC;
    particles = setWeights(particles, wTotal);
    
    particles = normalizeWeights(particles);
    
    centeredStateVector = estimateMeanState(particles);
    stateVector = centerToCorner(centeredStateVector, boundingBox);

    % Now, create mean state histogram p_ES_t
    cropped = cropImage(image, [stateVector, boundingBox]);
    pESt = createColorHist(cropped);
    
    % Update target model qC
    qC = updateTargetModel(alpha,qC,pESt);
    
    particles = systematicResample(particles);

end