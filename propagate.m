function particles = propagate(particles,sigma)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
M = size(particles,1);
noiseY = mvnrnd(zeros(size(sigma(1))), sigma(1), M);
noiseX = mvnrnd(zeros(size(sigma(1))), sigma(2), M);
%particles(:,1:2) = round(particles(:,1:2) + noise);

particles(:,1) = round(particles(:,1) + noiseY);
particles(:,2) = round(particles(:,2) + noiseX);

end

