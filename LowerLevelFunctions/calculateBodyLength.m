
%%%% Function: calculate body length
%  Calculate the length of the animal based on the location of the pixels
%  in the skeleton.
%
%  param {skeletonX} vector<int>, list of x-coordinates of the pixels in
%  the skeleton
%  param {skeletonY} vector<int>, list of y-coordinates of the pixels in
%  the skeleton
% 
%  return {bodyLength} double, the length of the animal, defined as the sum
%  of the lengths between pixels along the skeleton.
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%
%%%%%



function bodyLength = calculateBodyLength(skeletonX, skeletonY)
    bodyLength = 0; % initialize body length to be zero
    %iterate to the end of the skeleton calculating the distance between
    %current pixel and next pixel. 
    for i = 2:length(skeletonX)
        bodyLength = bodyLength + calculateDistance(skeletonX(i-1), skeletonX(i), ...
            skeletonY(i-1),skeletonY(i)); 
    end
    

end

%Distance calculation function:
function distance = calculateDistance(x1, x2, y1, y2)
    distance = sqrt((x1-x2)^2+(y1-y2)^2);

end