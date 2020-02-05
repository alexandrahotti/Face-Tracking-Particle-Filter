function d= initDBB(stateVector,particles)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
M=size(particles,1);
d = (1/M)*sum(sum(sqrt((stateVector-particles(:,1:2)).^2)));
end

