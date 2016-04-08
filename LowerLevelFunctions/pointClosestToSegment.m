
%%%% Function: point closest to segment
%  Finds the point (x,y) on a segment defined by (x1,y1) and (x2, y2) that 
%  is closest to a point not on the segment (x3,y3).
%  
%  params {x1} double, x-coordinate of one end of the segment
%  params {y1} double, y-coordinate of one end of the segment
%  params {x2} double, x-coordinate of one other end of the segment
%  params {y2} double, y-coordinate of one other end of the segment
%  params {x3} double, x-coordinate of point 
%  params {y3} double, y-coordinate of point 
%
%  returns {x} double, x-coordinate of the point on the segment closest to
%  the point (x3,y3)
%  returns {y} double, y-coordinate of the point on the segment closest to
%  the point (x3,y3)
%  returns {dist} double, the distance between the point point on the
%  segment (x,y) and (x3, y3).
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%%%%%

function [x, y, dist] = pointClosestToSegment(x1,y1, x2,y2, x3,y3)% # x3,y3 is the point
    % calculate the difference in x, difference in y
    px = x2-x1;
    py = y2-y1;

    %calculate length of segment:
    something = px*px + py*py;

    % Find the component of (x3,y3) parallel to the segment:
    u =  ((x3 - x1) * px + (y3 - y1) * py) / something;
    
    % if u is negative or greater than one, then segment endpoints (x1,y1) 
    % or (x2,y2) are the closest to the point 
    if (u > 1)
        u = 1;
    elseif (u < 0)
        u = 0;
    end
    
    %calculate projection of u onto segment to determine (x,y)
    x = x1 + u * px;
    y = y1 + u * py;
    
    %Calculate distance between point on segment to point. 
    dx = x - x3;
    dy = y - y3;
    dist = sqrt(dx.^2 + dy.^2);
end