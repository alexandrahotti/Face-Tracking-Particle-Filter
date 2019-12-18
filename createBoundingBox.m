function boundingBox = createBoundingBox(corneredPt,imageSize,meanStateBoundingBox)
% Creates a boundingbox for a cornered point.
% If the particle is close to the edge, the bounding box is cut off
boundingBox=zeros(1,4);
yMax = imageSize(2);
yMin = 1;
xMax = imageSize(1);
xMin = 1;
h=meanStateBoundingBox(1);
w=meanStateBoundingBox(2);


y=corneredPt(1);
x=corneredPt(2);

xL = min(max(x,1),xMax);
xR = min(max(x + w,1),xMax);

yL = min(max(y,1),yMax);
yR = min(max(y + h,1),yMax);

%check if outside the pic
if(xL == xMax || xR == xMin || yL == yMax || yR == yMin)
    return
end


boundingBox(1)=yL;
boundingBox(2)=xL;
boundingBox(3)=yR-yL; %width
boundingBox(4)=xR-xL; %height

end

