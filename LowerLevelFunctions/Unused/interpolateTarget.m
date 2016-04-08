%%%% Function: interpolate target
%  
%
%  params {Point1} struct
%  params {Point2} struct
%  params {t} double
%  params {t_a} double
%
%  returns {Point3} struct
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%
%%%%%

function [Point3] = interpolateTarget(Point1, Point2, t, t_a)
    v_x = (Point2.x - Point1.x)/t;
    v_y = (Point2.y - Point1.y)/t;

    Point3.x = v_x*t_a + Point2.x;
    Point3.y = v_y*t_a + Point2.y;
end
