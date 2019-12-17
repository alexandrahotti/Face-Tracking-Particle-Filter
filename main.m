%% initial setup
%vid = VideoReader('C:\Users\Alexa\Desktop\KTH\�rskurs_5\Applied Estimation\Project\sample4.mp4');
noVideoFrams = vid.NumberOfFrames;
timeStepSkip = 4;

M = 100;
alpha=0.7;
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
        [stateVector, boundingBox] = viola(image);
        particles = initParticles([stateVector, boundingBox], M);
        %[boundingBox, dBB]  = initStateVector(boundingBox);
        
        % Crop the image according to the bounding box.
        cropped = cropImage(image, [stateVector, boundingBox]);
        
        qC = createColorHist( cropped );
        
    else
        % predict
        [boundingBox, dBB] = predictBoundingBox(stateVector, boundingBox, dBB, particles);
    end
    
    
    % Proagate the particles.
    particles = propagate(particles, sigmaNoise);
    
    % Weight update.
    
    for p = 1:M
        croppedImg = cropImage(image, [particles(p, 1:2), boundingBox]); % Obs os�ker p� om w h eller h w.
        colorHist = createColorHist(croppedImg);
        liklihoodsColor(p, :) = colorHist;
        
    end
    
    dC = bhattacharyya(liklihoodsColor, qC);
    
    wC = calculateWeights(dC, sigmaColor);
    
    
    wTotal = wC;
    particles = setWeights(particles, wTotal);
    
    particles = normalizeWeights(particles);
    
    stateVector = estimateMeanState(particles);

    % Now, create mean state histogram p_ES_t
        cropped = cropImage(image, [stateVector, boundingBox]);
        pESt = createColorHist(cropped);
    
    % Update target model qC
    qC = updateTargetModel(alpha,qC,PESt);
    
    particles = systematicResample(particles);

end