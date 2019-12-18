%% main for color
clear;
close;
%vid = VideoReader('C:\Users\Alexa\Desktop\KTH\�rskurs_5\Applied Estimation\Project\sample4.mp4');
addpath('indata');
%vid = VideoReader('C:\Users\Alexa\Desktop\KTH\�rskurs_5\Applied Estimation\Project\sample4.MP4');
vid = VideoReader('sample4.mp4');


noVideoFrams = vid.NumberOfFrames;
timeStepSkip = 5;

M = 100;
alpha=0.1;


sigmaY = 1000;
sigmaX = 1500;
sigmaNoise = [sigmaY sigmaX];
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

% create the video writer with 1 fps
writerObj = VideoWriter('myVideo2.avi');
writerObj.FrameRate = 10;
open(writerObj);

for t = 1 : timeStepSkip : noVideoFrams %noVideoFrams
    image = read(vid, t);
    imageSize = size(image);
    
    % Vis image

    
    if t ==1
        [stateVector, boundingBox] = viola(image);
        w = size(image,2);
        h = size(image,1);
        particles = initParticles([stateVector, boundingBox], M);
        %particles = initParticlesGlobal([w h]-boundingBox/2, M);
        dBB = initDBB(cornerToCenter([stateVector, boundingBox]),particles);
        %[boundingBox, dBB]  = initStateVector(boundingBox);
        
        % Crop the image according to the bounding box.
        cropped = cropImage(image, [stateVector, boundingBox]);
        qC = createColorHist(cropped);
        qE = createGradientOrientationHist( cropped );

        
    else
        % predict
        [boundingBox, dBB] = predictBoundingBox(cornerToCenter([stateVector, boundingBox]), boundingBox, dBB, particles);
       
%         a =[stateVector(1) stateVector(1)+boundingBox(1)]; % start end x coord of line 1
%         b = [stateVector(2) stateVector(2)]; % start end y coord of line 1
%         c = [stateVector(1) stateVector(1)];% start end x coord of line 2
%         d = [stateVector(2) stateVector(2)+boundingBox(2)];% start end y coord of line 2
%         e = [stateVector(1)+boundingBox(1) stateVector(1)+boundingBox(1)];% start end x coord of line 2
%         f = [stateVector(2) stateVector(2)+boundingBox(2)];% start end y coord of line 2
%         g =[stateVector(1) stateVector(1)+boundingBox(1)]; % start end x coord of line 1
%         h = [stateVector(2)+boundingBox(2) stateVector(2)+boundingBox(2)]; % start end y coord of line 1
        
        boundInc = 0;
        a =[stateVector(1)-boundInc stateVector(1)+boundingBox(1)+boundInc]; % start end x coord of line 1
        b = [stateVector(2)-boundInc stateVector(2)-boundInc]; % start end y coord of line 1
        c = [stateVector(1)-boundInc stateVector(1)-boundInc];% start end x coord of line 2
        d = [stateVector(2)-boundInc stateVector(2)+boundingBox(2)+boundInc];% start end y coord of line 2
        e = [stateVector(1)+boundingBox(1)+boundInc stateVector(1)+boundingBox(1)+boundInc];% start end x coord of line 2
        f = [stateVector(2)-boundInc stateVector(2)+boundingBox(2)+boundInc];% start end y coord of line 2
        g =[stateVector(1)-boundInc stateVector(1)+boundingBox(1)+boundInc]; % start end x coord of line 1
        h = [stateVector(2)+boundingBox(2)+boundInc stateVector(2)+boundingBox(2)+boundInc]; % start end y coord of line 1
        plot(a,b,'green', c,d,'green',e,f,'green',g,h,'green');
        hold on;
        
        

        hold off
        drawnow
        writeVideo(writerObj, getframe(gcf));
    end
    
    
    % Propagate the particles.
    particles = propagate(particles, sigmaNoise, imageSize);
    
    % Weight update.
    
    for p = 1:M
        cornerP = centerToCorner(particles(p, 1:2), boundingBox);
        croppedImg = cropImage(image, [cornerP, boundingBox]); % Obs os�ker p� om w h eller h w.
        colorHist = createColorHist(croppedImg);
        liklihoodsColor(p, :) = colorHist;
        
        gradientOrientationHist = createGradientOrientationHist( croppedImg );
        liklihoodsGradient(p, :) = gradientOrientationHist;
        
    end
    
       
    dC = bhattacharyya(liklihoodsColor, qC);
    dE = bhattacharyya(liklihoodsGradient, qE');
    
    wC = calculateWeights(dC, sigmaColor);
    wE = calculateWeights(dE, sigmaGrad);
    wTotal = wC*0.5 + wE*0.5;
    
    particles = setWeights(particles, wTotal);
    
    particles = normalizeWeights(particles);
    
    imshow(image);
    hold on;

    scatter(particles(:,1), particles(:,2)); %, size, color, 'filled');
    hold on;
    
    centeredStateVector = estimateMeanState(particles);
    stateVector = centerToCorner(centeredStateVector, boundingBox);

    % Now, create mean state histogram p_ES_t
    cropped = cropImage(image, [stateVector, boundingBox]);
    pESt = createColorHist(cropped);
    
    
    
    % Update target model qC
    qC = updateTargetModel(alpha,qC,pESt);
    
    particles = systematicResample(particles);

end
close(writerObj);