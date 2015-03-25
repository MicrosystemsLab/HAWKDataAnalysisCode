%%%% Function: calculate the phase shift of the curvature
%  This function calculates the phase shift of the curvature between
%  frames. 
%
%  params {curvature} maxtrix, each column is the smoothed curvature matrix
%  from a single frame. The first row is the head, the last row is the
%  tail.
%  returns {ps} 1D vector, contains the phase shift between frames.
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%  This was adapted from the methods orginally written by C. Fang-Yen and
%  modified by A. Leifer.
%
%%%%%
function [ps, ps_residual] = calculateCurvaturePhaseShift(curvature)

   
    %omit head and tail portion of the worm to discount foraging behavior:
    headCrop = 0.2;
    tailCrop = 0.05;
    %Create vector of indices:
    xs = 1:size(curvature,1);
    %Crop indice vector using tail and head portion cut offs:
    cinds = xs(floor(headCrop*length(xs)) : length(xs) - floor(tailCrop*length(xs)) );

    %Function returns the curvature data that corresponds to a shift of the indices
    %xs = indices
    %xdata = curvature data
    %cinds + x: shift indices by x
    %returns the data that corresponds to cinds+x, fit linearly.
    shiftfn = @(x, xdata) interp1(xs, xdata, cinds + x, 'linear');
    numberOfCurves = size(curvature,2);

    % Set up least squares fit:
    op = optimset('lsqcurvefit');
    op.Display = 'off';
    x = 0; 

    %initialize with the first curve:
    curveAccumulated = curvature(:,1)';
    for i = 1:numberOfCurves-1
        %select the next curve to compare:
        nextCurve = curvature(cinds,i+1)';
        %We find the "x" that will minimize the least squares error between
        %the next curve and shiftfn when evaulated at x and the current curve 
        [x, residual] = lsqcurvefit(shiftfn, x, curveAccumulated, nextCurve, -length(xs)*headCrop, length(xs)*tailCrop, op);
        %Adjust for next curve evaluation by moving next curve to current curve:
        curveAccumulated = curvature(:,i+1)';
        %Save phase shift value:
        ps(i) = x;
        ps_residual(i) = residual;
    end


end