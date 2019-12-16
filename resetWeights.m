function particles = resetWeights(particles)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
M=size(particles,1);
particles(:,3) = 1/M;
end

