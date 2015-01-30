function [x, y, dist] = pointClosestToSegment(x1,y1, x2,y2, x3,y3)% # x3,y3 is the point
    px = x2-x1;
    py = y2-y1;

    something = px*px + py*py;

    u =  ((x3 - x1) * px + (y3 - y1) * py) / something;
    
    if (u > 1)
        u = 1;
    elseif (u < 0)
        u = 0;
    end

    x = x1 + u * px;
    y = y1 + u * py;
    
    dx = x - x3;
    dy = y - y3;
    
    dist = sqrt(dx.^2 + dy.^2);
end