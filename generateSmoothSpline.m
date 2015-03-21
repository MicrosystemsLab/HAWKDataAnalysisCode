%%%% Function: Generate Smooth Spline
%  this function fits a spline to curve data, x,y, and generates a set of
%  equally spaced spline points along the fit
%
%  params {xy} 2-D vector, 2 dimension vector or x-points and y-points
%  params {numcrvpts} int, desired number of points along the curve.
%  returns {smoothSpline} 2-D vector, vector of same format as xy, contains
%  x,y coordinates of each point on the spline.
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%  This was adapted from the methods orginally written by C. Fang-Yen and
%  modified by A. Leifer.
%
%%%%%


function smoothSpline = generateSmoothSpline(xy, numcurvpts)

    spline_p=0.001;
   
    df = diff(xy,1,2); % vector segments along centerline
    t = cumsum([0, sqrt([1 1]*(df.*df))]); % cumulative path length along centerline
    cv = csaps(t,xy,spline_p); % find cubic smoothing spline parameterized by path length
    cv2 =  fnval(cv, t)'; % resample spline along centerline coordinates
    df2 = diff(cv2,1,1); df2p = df2'; % calculate vector segments along sampled spline
    splen = cumsum([0, sqrt([1 1]*(df2p.*df2p))]); % cumulative path length along resampled spline

  
    cv2i = interp1(splen+.00001*[0:length(splen)-1],cv2, [0:(splen(end)-1)/(numcurvpts+1):(splen(end)-1)]);
    smoothSpline = cv2i;

end