function particles= normalizeWeights(particles)
%Normalize weights;
%INPUT  - particles M*3
%OUTPUT - particles M*3
particles(:,3) = particles(:,3)/sum(particles(:,3));
end

