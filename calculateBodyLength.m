function bodyLength = calculateBodyLength(skeletonX, skeletonY)
    bodyLength = 0; % initialize body length to be zero
    for i = 2:length(skeletonX)
        bodyLength = bodyLength + calculateDistance(skeletonX(i-1), skeletonX(i), ...
            skeletonY(i-1),skeletonY(i)); 
    end
    

end

function distance = calculateDistance(x1, x2, y1, y2)
    distance = sqrt((x1-x2)^2+(y1-y2)^2);

end