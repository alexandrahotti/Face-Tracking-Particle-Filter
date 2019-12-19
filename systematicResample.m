% This function performs systematic re-sampling
% From the EL2320 course, lab2. 
% Inputs:   
%           S_bar(t):       4XM
% Outputs:
%           S(t):           4XM
function resmpldP = systematicResample(particles)
    M = size(particles,1);  % number of particles 
    resmpldP = zeros(M,5);
    weight=1/M;
    r_0 = 0 + (weight-0)*rand;
    CDF = cumsum(particles(:, 3));
    for m=1:M
        argmin = find(CDF>=(r_0 + (m-1)/M),1);
        resmpldP(m,1:3) = [particles(argmin,1:2) weight];
    end
    resmpldP(:,4:5) = particles(:,4:5);
end