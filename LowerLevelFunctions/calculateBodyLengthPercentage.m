
%%%% Function: calculate body length
%  Calculate the length of the animal based on the location of the pixels
%  in the skeleton.
%
%  param {skeletonX} vector<int>, list of x-coordinates of the pixels in
%  the skeleton
%  param {skeletonY} vector<int>, list of y-coordinates of the pixels in
%  the skeleton
%  param {bodyLength} the total length of the animal's body length
% 
%  return {bodyLengthPercentage} vector<double>, same length as
%  skeletonX,skeletonY. Each entry corresponds to the percentage of the
%  body length at the respective entry in skeletonX, skeletonY.
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%
%%%%%




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