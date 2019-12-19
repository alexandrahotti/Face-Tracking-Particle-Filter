function particles = propagate(particles, sigma, imgSize, velocityMax)


M = size(particles,1);

noiseY = mvnrnd(0, sigma(1), M);
noiseX = mvnrnd(0, sigma(2), M);

noisedY = mvnrnd(0, sigma(3), M);
noisedX = mvnrnd(0, sigma(4), M);

w = imgSize(2);
h = imgSize(1);

% Propagating the position.
particles(:,1) = round(particles(:,1) + noiseY );
particles(:,2) = round(particles(:,2) + noiseX );

particles(:,1) = min(max(particles(:,1), 1), w);
particles(:,2) = min(max(particles(:,2), 1), h);

% Propagating the velocity.
particles(:,4) = round(particles(:,4) + noisedY ); % bra n�r 
particles(:,5) = round(particles(:,5) + noisedX );

particles(:,4) = min(max(particles(:,4), -velocityMax(1)), velocityMax(1));
particles(:,5) = min(max(particles(:,5), -velocityMax(2)), velocityMax(2));

% Add the extra velocity to the position: x+dx, y+dy
particles(:,1) = particles(:,1) + particles(:,4);
particles(:,2) = particles(:,2) + particles(:,5);

end

