%% main for color
%vid = VideoReader('C:\Users\Alexa\Desktop\KTH\�rskurs_5\Applied Estimation\Project\sample4.mp4');
addpath('indata');
vid = VideoReader('sample4.mp4');

noVideoFrams = vid.NumberOfFrames;
timeStepSkip = 5;

M = 100;
alpha=0.1;
%sigmaNoise = 2000;
sigmaNoiseY = 1000;
sigmaNoiseX = 1500;
sigmaNoise = [sigmaNoiseY, sigmaNoiseX];
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
        [corneredStateVector, boundingBox] = viola(image);
        w = size(image,2);
        h = size(image,1);
        particles = initParticles([corneredStateVector, boundingBox], M);
        %particles = initParticlesGlobal([w h]-boundingBox/2, M);
        dBB = initDBB(cornerToCenter([corneredStateVector, boundingBox]),particles);
        %[boundingBox, dBB]  = initStateVector(boundingBox);
        
        % Crop the image according to the bounding box.
        cropped = cropImage(image, [corneredStateVector, boundingBox]);
        qC = createColorHist(cropped);
        
    else
        % predict
        [boundingBox, dBB] = predictBoundingBox(cornerToCenter([corneredStateVector, boundingBox]), boundingBox, dBB, particles);
        a = [corneredStateVector(1) corneredStateVector(1)+boundingBox(1)]; % start end x coord of line 1
        b = [corneredStateVector(2) corneredStateVector(2)]; % start end y coord of line 1
        c = [corneredStateVector(1) corneredStateVector(1)];% start end x coord of line 2
        d = [corneredStateVector(2) corneredStateVector(2)+boundingBox(2)];% start end y coord of line 2
        e = [corneredStateVector(1)+boundingBox(1) corneredStateVector(1)+boundingBox(1)];% start end x coord of line 2
        f = [corneredStateVector(2) corneredStateVector(2)+boundingBox(2)];% start end y coord of line 2
        g = [corneredStateVector(1) corneredStateVector(1)+boundingBox(1)]; % start end x coord of line 1
        h = [corneredStateVector(2)+boundingBox(2) corneredStateVector(2)+boundingBox(2)]; % start end y coord of line 1
        plot(a,b,'green', c,d,'green',e,f,'green',g,h,'green');
        hold on;
    end
    
    
    % Propagate the particles.
    particles = propagate(particles, sigmaNoise);
    
    % Weight update.
    
    for p = 1:M
        cornerP = centerToCorner(particles(p, 1:2), boundingBox);
        croppedImg = cropImage(image, [cornerP boundingBox]); % Obs os�ker p� om w h eller h w.
        %colorHist = createColorHist(croppedImg);
        %particleBoundingBox = createBoundingBox(cornerP,imageSize,boundingBox);
        %croppedImg = cropImage(image, particleBoundingBox);
        colorHist = createColorHist(croppedImg);
%         
%         if inBounds(particleBoundingBox)
%             croppedImg = cropImage(image, particleBoundingBox); % Obs os�ker p� om w h eller h w.
%             colorHist = createColorHist(croppedImg);
%         else
%             colorHist = zeroLikelihood(qC);
%         end
        
        liklihoodsColor(p, :) = colorHist;
        
    end
    
    dC = bhattacharyya(liklihoodsColor, qC);
    
    wC = calculateWeights(dC, sigmaColor);
    wTotal = wC;
    particles = setWeights(particles, wTotal);
    
    particles = normalizeWeights(particles);
    
    imshow(image);
    hold on;

    scatter(particles(:,1), particles(:,2)); %, size, color, 'filled');
    hold on;
    
    centeredStateVector = estimateMeanState(particles);
    corneredStateVector = centerToCorner(centeredStateVector, boundingBox);

    % Now, create mean state histogram p_ES_t
    cropped = cropImage(image, [corneredStateVector, boundingBox]);
    pESt = createColorHist(cropped);
    
    % Update target model qC
    qC = updateTargetModel(alpha,qC,pESt);
    
    particles = systematicResample(particles);


end