function stateEstimate = estimateMeanState(particles)
% Estimate mean state
%INPUT  - particles     Mx3
%OUTPUT - stateEstimate 1x2
stateEstimate = round(sum(particles(:,1:2).*particles(:,3)));
end

