%%%% Function: find curvature
% This function takes a series of skeletons and finds the curvature of each
% one.
%
%  params {skeleton} struct, 
%  params {sigma} double, sigma used for creating the Gaussian kernel for
%  filtering the spline 
%  params {numcurvpts} int, the number of points to be used to make the
%  spline.
%  returns {curvature_smooth} matrix containing the curvature at each point
%  for each skeleton.
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%  This method is compilation of adapted methods written by C. Fang-Yen and A.
%  Leifer. 
%%%%%


function curvature_smooth = findCurvature(skeleton, sigma, numcurvpts)
    %Create structures to hold data:
    curvature = zeros(numcurvpts,length(skeleton));
    curvature_smooth = zeros(numcurvpts,length(skeleton));
    %for each skeleton spline, do the following:
    for frame = 1:length(skeleton)
        x = skeleton(frame).x;
        y = skeleton(frame).y;
        
        %Smooth the spline via a guassian filter:
        x_filtered =  lowpass1D(x,sigma);
        y_filtered =  lowpass1D(y,sigma);
        %create a smooth spline of equally spaced points:
        xy_smoothSpline = generateSmoothSpline([x_filtered; y_filtered],numcurvpts);
        %Calculate the curvature based on the delta Theta method:
        curvature(:,frame) = calculateCurvatureDeltaTheta(xy_smoothSpline);
        %Use filter again to smooth the curvature:
        curvature_smooth(:,frame) = lowpass1D(curvature(:,frame), 1.5);
      
    end


end