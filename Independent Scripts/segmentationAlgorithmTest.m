
clear all;

% testImage = imread('/Users/emazzochette/Documents/MicrosystemsResearch/Images/WormCantiDark.bmp');
testImage = imread('/Users/emazzochette/Desktop/WormTrackerDataAnalysis/WormTrackerTestImages/wormTestImage1.bmp');

G = fspecial('gaussian',[5 5],2);
%# Filter it
filteredImage = imfilter(testImage,G,'same');

level = graythresh(filteredImage);
bw = im2bw(filteredImage,level);
bw = imfill(bw,'holes');
properties = regionprops(bw,'all');
region = properties(3);

mask = false(size(bw));

for i=1:length(region.PixelList)
    mask(region.PixelList(i,2), region.PixelList(i,1)) = true;
    
end

figure(1), imshow(mask);

C = contourc(double(mask),1);

j=1;
for i=1:length(C)
    isInsideImage = ([floor(C(1,i)), floor(C(2,i))] > [0 0] & [floor(C(1,i)), floor(C(2,i))] <size(mask));
    if (sum(isInsideImage) == 2)% & mask(floor(C(1,i)), floor(C(2,i))))
        contour(j,:) = [C(1,i) C(2,i)];
        j = j+1;
    end
end

% figure(2), plot(contour([1:1988],2),contour([1:1988],1),'r-',contour(1,2),contour(1,1),'bx',contour(10,2), contour(10,1),'kx')
figure(2), plot(contour(:,1),-contour(:,2),'r-',contour(1,1),-contour(1,2),'bx',contour(10,1), -contour(10,2),'kx')

%plot(contour(1,2),contour(1,1),'bx',contour(10,2), contour(10,1),'kx');
wormOutline = contour(:,:);

%% 
j=1;
for i = 3:length(wormOutline)
    [K, V] = convhull(wormOutline(1:i,1), wormOutline(1:i,2));
    areaConvexHull(j) = V;
    numPointsConvexHull(j) = length(K);
    j=j+1;
end

figure(3), subplot(311), plot(areaConvexHull,'.');
subplot(312), plot(numPointsConvexHull,'.');

curvature = calculateCurvature(wormOutline(:,1),wormOutline(:,2));
subplot(313), plot(curvature);

%% 
plotArray = {'k-','b-','r-','g-','c-','m-'};
jumpArray = [ 10 50 100];
figure(4);
for k = 1:length(jumpArray)
    jump = jumpArray(k);
    j=1;
    for i = jump+1:length(wormOutline)-jump

       directionSum(j) = wormOutline(i-jump,2) * (wormOutline(i+jump,1) - wormOutline(i,1)) ...
           + wormOutline(i,2) * (wormOutline(i-jump,1) - wormOutline(i+jump,1)) ...
           + wormOutline(i+jump,2) * (wormOutline(i,1) - wormOutline(i-jump,1));
       j=j+1;

    % areaSum += x1 * (y3 - y2);
    % areaSum += x2 * (y1 - y3);
    % areaSum += x3 * (y2 - y1);

    end
   
    plot(1:length(directionSum),directionSum, plotArray{k});
    hold on
end

%% 
headX = 401;
headY = 155.5;
headIndex = 512;

tailX = 639;
tailY = 300.5;
tailIndex = 1086;

jumpBetweenSegments = 10;
pointSpan = 20;

currentIndex = headIndex;
matchingIndex = headIndex;

numberOfSegments = 10;

figure(3);
plot(wormOutline(:,1),wormOutline(:,2))
hold on;
plot(wormOutline(currentIndex,1), wormOutline(currentIndex,2), 'rx');

for segmentParser = 1:numberOfSegments
    currentIndex = floor(currentIndex + jumpBetweenSegments);  
    spanIndex = currentIndex + pointSpan;

    ax = wormOutline(spanIndex,1) - wormOutline(currentIndex,1);
    ay = wormOutline(spanIndex,2) - wormOutline(currentIndex,2);

    for i = 1:20     
        matchingIndex = matchingIndex - 1;

        bx = wormOutline(matchingIndex,1) - wormOutline(currentIndex,1);
        by = wormOutline(matchingIndex,2) - wormOutline(currentIndex,2);

        metric(i) = ax*bx + ay*by;

    end
    [value, idx] = min(metric);
    matchingIndex = matchingIndex - 20 + idx;
    segments(segmentParser,:) = [currentIndex, matchingIndex];
    plot(wormOutline(currentIndex,1),wormOutline(currentIndex,2),'gx');
    plot(wormOutline(matchingIndex,1),wormOutline(matchingIndex,2),'kx');
end

