function stateVector = cornerToCenter(boundingBox)
stateVector = [boundingBox(1) + round(boundingBox(3)/2), boundingBox(2) + round(boundingBox(4)/2)]; 
end

