function wTotal = fuseWeights(wC,wE)
%add color weights and edge weights together
%INPUT  - wE Mx1
%       - wC Mx1
%OUTPUT - wTotal Mx1
wTotal = wE + wC;
end

