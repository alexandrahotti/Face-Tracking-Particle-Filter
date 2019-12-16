function particles = setWeights(particles, wTotal)
%set particle weights
%INPUT  - particles Mx3
%       - wTotal Mx1
%OUTPUT - particles Mx3
particles(:,3) = wTotal;
end


