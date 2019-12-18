function particles = propagate(particles,sigma, imgSize)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
M = size(particles,1);
var_x = 1000;
var_y = 1500;


noiseX = mvnrnd(zeros(size(sigma)), var_x, M);
noiseY = mvnrnd(zeros(size(sigma)), var_y, M);
%particles(:,1:2) = round(particles(:,1:2) + noise);

velx = 2*randn(M, 1).*sqrt(2500);
vely = 1*randn(M, 1).*sqrt(2500);

w = imgSize(1);
h = imgSize(2);


particles(:,1) = round(particles(:,1) + noiseX );%+ velx);
particles(:,2) = round(particles(:,2) + noiseY );%+ vely);

particles(:,1) = min(max(particles(:,1), 1), w);
particles(:,2) = min(max(particles(:,2), 1), h);
end

