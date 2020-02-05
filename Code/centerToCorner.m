function stateVector = centerToCorner(stateVector, boundingBox)
stateVector = [stateVector(1) - round(boundingBox(1)/2), stateVector(2) - round(boundingBox(2)/2)]; 
end