%%%% Function: distanceCalc
%  Calculates the distance between two points using the distance formula
%
%  params {x1} double, x-coordinate of first point
%  params {y1} double, y-coordinate of first point
%  params {x2} double, x-coordinate of second point
%  params {y2} double, y-coordinate of second point
%
%  returns {disance} double, distance between the two points
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%%%%% 

function distance = distanceCalc(x1, y1, x2, y2)
    %Distance formula:
    distance = sqrt((x1-x2)^2+(y1-y2)^2);

end