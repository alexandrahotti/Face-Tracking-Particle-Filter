function particles = propagate(particles,sigma, imgSize)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
M = size(particles,1);

noiseY = mvnrnd(0, sigma(1), M);
noiseX = mvnrnd(0, sigma(2), M);
%particles(:,1:2) = round(particles(:,1:2) + noise);


w = imgSize(1);
h = imgSize(2);


particles(:,1) = round(particles(:,1) + noiseY );%+ velx);
particles(:,2) = round(particles(:,2) + noiseX );%+ vely);

particles(:,1) = min(max(particles(:,1), 1), w);
particles(:,2) = min(max(particles(:,2), 1), h);
end

