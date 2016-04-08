%%%% Function: find percent down body
%  find the percent down the body length of a point along the skeleton.
%
%  params {Skeleton} struct, contains two vectors, x and y corresponding to
%  points on the skeleton
%  params {index}, of the two points on the skeleton closest to the point, 
%  the index of the skeleton closer to the head.
%  params {x}, x-coordinate of the point on the skeleton of interest
%  params {y}, y-coordinate of the point on the skeleton of interest
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%
%%%%%
function percent = findPercentDownBody(Skeleton, index, x ,y)
    
    portionLength = 0;
    wholeLength = 0;
    for i = 2:length(Skeleton.x)
        %calculate distance between current point and previous point
        distance = distanceCalc(Skeleton.x(i-1), Skeleton.y(i-1), Skeleton.x(i), Skeleton.y(i));
        %if we're at the index just before the point of interest, add to
        %portion length, continue
        if i <= index
            portionLength = portionLength + distance;
        % if we're at the index, calculate distance between point and
        % previous index, stop adding to portion length
        elseif i == index+1
            portionDistance = distanceCalc(x, y, Skeleton.x(i-1), Skeleton.y(i-1));
            portionLength = portionLength+portionDistance;
        end
        %add distance to whole length each iteration untilthe end of the
        %skeleton:
        wholeLength = wholeLength + distance;
    end
    %Calculate percent:
    percent = portionLength/wholeLength;


end