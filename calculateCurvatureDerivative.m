%%%% Function: calculate curvature derviative method
%  This function finds the curvature of a single spline by using the
%  derivative method
%
%  params {x} 1D vector, vector of points x that coorespond to the
%  spline
%  params {y} 1D vector, vector of points y that coorespond to the
%  spline
%  returns {curvature} 1D vector containing the curvature at each point.
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.

%%%%%

function curvature = calculateCurvatureDerivative(x,y)
    %find first and sectond derivative of each vector:
    x1 = diff(x);
    x2 = diff(x1);
    y1 = diff(y);
    y2 = diff(y1);
    
    curvature = -(x1(2:length(x1)).*y2 - y1(2:length(x1)).*x2)./(x1(2:length(x1)).^2 + y1(2:length(x1)).^2).^(3/2);
end