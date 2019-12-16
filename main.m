%% initial setup
vid = VideoReader('C:\Users\Alexa\Desktop\KTH\�rskurs_5\Applied Estimation\Project\sample4.mp4');
noVideoFrams = vid.NumberOfFrames;
timeStepSkip = 4;

M = 100;
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
    
    if t ==1
        boundingBox = viola(image);
        particles = initParticles(boundingBox, M);
        stateVector = initStateVector(boundingBox);
        
        % Crop the image according to the bounding box.
        cropped = cropImage(image, boundingBox);
        
        qC = createColorHist( cropped );
        
    else
        % predict
        [boundingBox, dBB] = predictBoundingBox(stateVector, boundingBox, dBB, particles);
    end
    
    
    % Proagate the particles.
    particles = propagate(particles, sigmaNoise);
    
    % Weight update.
    
    for p = 1:M
        w = boundingBox(3);
        h = boundingBox(4);
        croppedImg = cropImage(image, [particles(p, 1:2), w, h]); % Obs os�ker p� om w h eller h w.
        colorHist = createColorHist( boundingBox );
        liklihoodsColor(p, :) = colorHist;
        
    end
    
    dC = bhattacharyya(liklihoodsColor, qC);
    
    wC = calculateWeights(dC, sigmaColor);
    
    
    wTotal = wC;
    particles = setWeights(particles, wTotal);
    
    particles = normalizeWeights(particles);
    
    stateVector = estimateMeanState(particles);
    
    particles = systematicResample(particles);

end