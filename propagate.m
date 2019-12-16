function particles = propagate(particles,sigma)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
M = size(particles,1);
noise = mvnrnd(zeros(size(sigma)), sigma, M);
particles(:,1:2) = round(particles(:,1:2) + noise);
end

