function bodyLengthPercentage = calculateBodyLengthPercentage(skeletonX, skeletonY, bodyLength)
    bodyLengthPercentage = 0; % initialize body length to be zero
    bodyLengthSoFar = 0;
    for i = 2:length(skeletonX)
        bodyLengthSoFar = bodyLengthSoFar + calculateDistance(skeletonX(i-1), skeletonX(i), ...
            skeletonY(i-1),skeletonY(i)); 
        bodyLengthPercentage(i) = bodyLengthSoFar/bodyLength;
    end
end

function distance = calculateDistance(x1, x2, y1, y2)
    distance = sqrt((x1-x2)^2+(y1-y2)^2);

end