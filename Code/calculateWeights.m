function weights = calculateWeights(d,sigma)
%calculateWeights 
%INPUT  - d Mx1
%       - sigma 1x1
%OUTPUT - weights Mx1

weights= (1/sigma)*(2*pi)^(-1/2)*exp(-(1/2)*sigma^(-2)*d);
end

