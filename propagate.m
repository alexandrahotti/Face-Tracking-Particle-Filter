function particles = propagate(particles,sigma, imgSize)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
M = size(particles,1);
noiseX = mvnrnd(zeros(size(sigma)), sigma, M);
noiseY = mvnrnd(zeros(size(sigma)), sigma, M);
%particles(:,1:2) = round(particles(:,1:2) + noise);

w = imgSize(1);
h = imgSize(2);

particles(:,1) = round(particles(:,1) + noiseX);
particles(:,2) = round(particles(:,2) + noiseY);

particles(:,1) = min(max(particles(:,1), 1), w);
particles(:,2) = min(max(particles(:,2), 1), h);
end

