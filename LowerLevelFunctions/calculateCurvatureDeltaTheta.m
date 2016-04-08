%%%% Function: calculate curvature 
%  This function finds the curvature of a single spline by using the
%  deltaTheta/deltaS method 
%
%  params {xy} 2D vector, vector of points x,y that coorespond to the
%  spline
%  returns {kappa} 1D vector containing the curvature at each point.
%  returns {distanceBetweenPoints}, double, the distance, in pixels between
%  each point for which a curvature is calculated.
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%
%  This was adapted from the methods orginally written by C. Fang-Yen and
%  modified by A. Leifer.
%%%%%

function [kappa, distanceBetweenPoints] = calculateCurvatureDeltaTheta(xy)
    
    %Calculate the differences between each point in x vector and each
    %point in y vector:
    df = diff(xy',1,2);
    
    %Need to know number of points and length of worm to determine dS
    numcurvpts = length(xy);
    lengthOfWorm = sum(sqrt([1 1]*(df.*df)));
    
    %Calculate the change in angle for each set of points:
    atdf2 = unwrap(atan2(-df(2,:), df(1,:)));
    %Determine difference between consecutive points:
    deltaTheta = unwrap(diff(atdf2,1));
    %Kappa is deltaTheta/dS:
    kappa = deltaTheta*numcurvpts/lengthOfWorm;
    distanceBetweenPoints = lengthOfWorm/numcurvpts;
end