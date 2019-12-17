function q = updateTargetModel(alpha,qOld,pESt)
%Update q
%INPUT      - alpha 1x1
%           - qOld  1x24 if color else 1x8
%           - pESt  1x24 if color else 1x8
%OUTPUT     - q 	1x24 if color else 1x8

q=(1-alpha)*qOld+alpha*pESt;
end

