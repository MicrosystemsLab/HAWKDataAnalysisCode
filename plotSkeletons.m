skeleton = Stimulus(stim).SkeletonSmooth(frame);
delta_y = skeleton.y(1) - skeleton.y(end);
delta_x = skeleton.x(1) - skeleton.x(end);
m = delta_y/delta_x;
b = skeleton.y(1) - m*skeleton.x(1);
f = fittype('a*x+b');
line = fit(skeleton.x, skeleton.y,f,'StartPoint',[m b]);
xPoints = [350:750];
yPoints = xPoints.*line.a + line.b;

theta = findRotationAngle(skeleton);

numPoints = 100;


x = skeleton.x;
y = skeleton.y;
xx = x';
yy = y';

npts = length(xx);
nintervals = npts - 1;

w = [xx; yy];   % Matrix of x's & y's
w(3,:) = 1;     % Bottom row of 1's


%----TRACK AMPLITUDE--------------------------------------
% Establish velocity direction as centerline
midptx = mean(xx);      % Reference point at ~middle of worm
midpty = mean(yy);


% Translation transform
A = [1   0   -midptx;
     0   1   -midpty;
     0   0    1];

% Rotation transform
B = [cos(-theta)  -sin(-theta)   0;   
     sin(-theta)   cos(-theta)   0;
     0            0            1];

  % Combined transform
C = B*A;

% Do the transformations
ww = C*w;

wwx = ww(1,:);  % x&y coordinate vectors
wwy = ww(2,:);

%%

figure(1)
plot(skeleton.x,skeleton.y,'LineWidth',3)
hold on
plot(skeleton.x(1),skeleton.y(1),'ro','MarkerSize',20)
hold on
plot(xPoints, yPoints,'k--','LineWidth',2)
plot(xPoints, yPoints(1).*ones(size(yPoints)),'k:','LineWidth',2)
axis('equal');
set(gca, 'FontSize',14)

figure(2)
plot(wwx,wwy,'LineWidth',3)
hold on
plot(wwx(1),wwy(1),'ro','MarkerSize',20)
axis('equal')
set(gca, 'FontSize',14)