function inBounds = inBounds(particleBoundingBox)
% Check if in bounds
if isequal(particleBoundingBox,[0 0 0 0])
    inBounds = false;
    return
end
inBounds = true;
end

