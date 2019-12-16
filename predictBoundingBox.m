function [bBox,d] = predictBoundingBox(stateVector,bBoxOld,dOld, particles)
%Predict new bounding box (step2 in the paper)

M=size(particles,1);
dNew = (1/M)*sum(sum(sqrt((stateVector-particles(:,1:2)).^2)));
bBox=round(bBoxOld*dNew/dOld); %round to integer

d=dNew;
end

