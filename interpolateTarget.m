
function [Point3] = interpolateTarget(Point1, Point2, t, t_a)
    v_x = (Point2.x - Point1.x)/t;
    v_y = (Point2.y - Point1.y)/t;

    Point3.x = v_x*t_a + Point2.x;
    Point3.y = v_y*t_a + Point2.y;
end
