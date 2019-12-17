function d = bhattacharyya(p,q)
% Bhattacharyya distance
%INPUT  - p Mx24 if color, else Mx8
%       - q 1x24 if color, else 1x8
%OUTPUT - d Mx1 if color, else Mx1
rho=sum(sqrt(p.*q),2);
d=sqrt(1-rho);

end

