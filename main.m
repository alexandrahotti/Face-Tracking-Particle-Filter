%% main for color
clear;
close;
%vid = VideoReader('C:\Users\Alexa\Desktop\KTH\�rskurs_5\Applied Estimation\Project\sample4.mp4');
addpath('indata');
%vid = VideoReader('C:\Users\Alexa\Desktop\KTH\�rskurs_5\Applied Estimation\Project\sample4.MP4');
%addpath('/home/jacob/Documents/EL2320/Projekt/filmer')

%vid = VideoReader('alex_vanlig_blå.MOV');
%vid = VideoReader('sample4.mp4');
vid = VideoReader('occ_480.mp4');

updateThreshold=0.3;
noVideoFrams = vid.NumberOfFrames;
timeStepSkip = 1;

M = 100;
alpha=0;

sigmaY = 500/5;
sigmaX = 700/4;

sigmadX = 1200/6;
sigmadY = 500/4;


sigmaNoise = [sigmaY sigmaX sigmadY sigmadX];
velocityMax = [40 40/5]; % y x
sigmaColor = 0.5;
sigmaGrad = 0.5;
no_bins = 8;

liklihoodsColor = zeros(M, no_bins*3);
liklihoodsGradient = zeros(M, no_bins);
dC = zeros(M, 1);
dE = zeros(M, 1);
wC = zeros(M, 1);
wE = zeros(M, 1);
wT = zeros(M, 1);


pEStObservationVector=zeros(1, noVideoFrams);

% create the video writer with 1 fps
writerObj = VideoWriter('jacob_occ2.avi');
writerObj.FrameRate = 30;
open(writerObj);

for t = 1 : timeStepSkip : noVideoFrams %noVideoFrams
    image = read(vid, t);
    imageSize = size(image);
    
    % Vis image

    
    if t ==1
        [stateVector, boundingBox] = viola(image);
        particles = initParticles([stateVector(1), stateVector(2), boundingBox], M);
        %particles = initParticlesGlobal([w h]-boundingBox/2, M);
        dBB = initDBB(cornerToCenter([stateVector(1), stateVector(2), boundingBox]),particles);
        %[boundingBox, dBB]  = initStateVector(boundingBox);
        %bb=[stateVector(1), stateVector(2)-15, boundingBox(1)-10 boundingBox(2)+15];
        % Crop the image according to the bounding box.
        cropped = cropImage(image, [stateVector(1), stateVector(2), boundingBox]);
        qC = createColorHist(cropped);
        qE = createGradientOrientationHist( cropped );

        
    else
        % predict
        if real(pEStObservationVector(t-1)) > updateThreshold
            [boundingBox, dBB] = predictBoundingBox(cornerToCenter([stateVector(1:2), boundingBox]), boundingBox, dBB, particles);
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
        else
            drawnow
            writeVideo(writerObj, getframe(gcf));
            
        end
        
        
     
    end
    
    
    % Propagate the particles.
    particles = propagate(particles, sigmaNoise, imageSize, velocityMax);
    
    % Weight update.
    
    for p = 1:M
        cornerP = centerToCorner(particles(p, 1:2), boundingBox);
        croppedImg = cropImage(image, [cornerP, boundingBox]); % Obs os�ker p� om w h eller h w.
        if size(croppedImg,1) ~= 0
            colorHist = createColorHist(croppedImg);
            liklihoodsColor(p, :) = colorHist;
        else
            liklihoodsColor(p, :) = 0;
        end
        
        %gradientOrientationHist = createGradientOrientationHist( croppedImg );
        %liklihoodsGradient(p, :) = gradientOrientationHist;
        
    end
    
       
    dC = bhattacharyya(liklihoodsColor, qC);
    %dE = bhattacharyya(liklihoodsGradient, qE');
    
    wC = calculateWeights(dC, sigmaColor);
    %wE = calculateWeights(dE, sigmaGrad);
    wTotal = wC;
    
    particles = setWeights(particles, wTotal);
    
    particles = normalizeWeights(particles);
    
    imshow(image);
    hold on;

    scatter(particles(:,1), particles(:,2),'red'); %, size, color, 'filled');
    hold on;
    
    centeredStateVector = estimateMeanState(particles);
    stateVector = centerToCorner(centeredStateVector, boundingBox);

    % Now, create mean state histogram p_ES_t
    cropped = cropImage(image, [stateVector(1:2), boundingBox]);
    pESt = createColorHist(cropped);
    qESt = createGradientOrientationHist(cropped);
    
    
    %Now calculate the observation prob of pESt
    
    pEStCroppedImg = cropImage(image, [stateVector, boundingBox]);
    pEStColorHist = createColorHist(pEStCroppedImg);
    pEStDC = bhattacharyya(pEStColorHist, qC);
    pEStColorObservationProbability = calculateWeights(pEStDC, sigmaColor);
    pEStObservationVector(t)=pEStColorObservationProbability;
    

    
    % Update target model qC if above threshold
%     if pEStColorObservationProbability > updateThreshold  
%         qC = updateTargetModel(alpha,qC,pESt);
%         qE = updateTargetModel(alpha,qE,qESt);
%     end

    
    particles = systematicResample(particles);
    t
end
close(writerObj);