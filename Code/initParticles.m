function particles = initParticles(bBox,noParticles)
% Init particles with x,y, weight
%INPUT  - noParticles   1x1
%       - bBox          1x4
%OUTPUT - particles 	Mx3
particles=zeros(noParticles, 5);

x = randi([bBox(1) bBox(1)+bBox(3)],1,noParticles);
y = randi([bBox(2) bBox(2)+bBox(4)],1,noParticles);
dx = 0;
dy = 0;
particles(:,1) = x;
particles(:,2) = y;
particles(:,3) = 1/noParticles;
particles(:,4) = dx;
particles(:,5) = dy;
end

