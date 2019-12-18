function particles = initParticles(bBox,noParticles)
% Init particles with x,y, weight
%INPUT  - noParticles   1x1
%       - bBox          1x4
%OUTPUT - particles 	Mx3
particles=zeros(noParticles, 3);

y = randi([bBox(1) bBox(1)+bBox(3)],1,noParticles);
x = randi([bBox(2) bBox(2)+bBox(4)],1,noParticles);
particles(:,1) = y;
particles(:,2) = x;
particles(:,3) = 1/noParticles;

end

