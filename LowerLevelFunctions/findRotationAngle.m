%%%% Function: Find Rotation Angle
%  Finds the correct rotation angle for the skeleton by fitting a line to
%  the skeleton and finding the angle of that line with respect to the
%  horizontal
%
%  params {skeleton} struct, contains two vectors for x and y containing the pixels
%  locations of each point along the skeleton.
%
%  returns {theta} <double>, The angle of rotation for the skeleton
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%
%%%%%

function theta = findRotationAngle(skeleton)
warning('off', 'curvefit:fit:noStartPoint')
    
    %Calculate slope and intercept using just the head and tail as initial
    %guess for the fit:
    delta_y = skeleton.y(1) - skeleton.y(end);
    delta_x = skeleton.x(1) - skeleton.x(end);
    m = delta_y/delta_x;
    b = skeleton.y(1) - m*skeleton.x(1);

    %Set up linear fit:
    f = fittype('a*x+b');
    line = fit(skeleton.x, skeleton.y,f,'StartPoint',[m b]);
    
    %Calculate angle:
    theta = atan(line.a);
    if (line.a>0 & delta_y<0)
        theta = theta-pi;
    elseif (line.a<0 & delta_y>0)
        theta = theta + pi;
        
    end
        
end