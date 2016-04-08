
%%%%% 
% This function calculates the moving the moving average of a set of data,
% x, y of window size width. width and x have the same unit. Function
% returns two new vectors, x_out, y_out, which is the resampled, averaged
% data.
% 
% Copyright 2016, Eileen Mazzochette. 
%%%%% 
function [x_out, y_out] = movingAverageResampling(x,y,width)

    %Determine x vector output based on the width of the averaging window
    startPoint = x(1)+width/2;
    endPoint = x(end)-width/2;
    x_out = linspace(startPoint,endPoint, length(x)-width)';
    y_out = NaN(size(x_out));

    %Scan window across x_out, averaging y data inside window.
    for now = 1:length(x_out)
        %Find all the points in x that span current window
       points = find(x > x_out(now)-width/2 & x < x_out(now)+width/2);
       %if more than one point inside window, calculate average of data
       %across that window:
       if length(points)>1
           y_out(now) = findAverageSpeed(x(points)',y(points));
       %If only one point in window, average is just that data point.
       elseif length(points) == 1
           y_out(now) = y(points);
       % If no data in window, pass NaN.
       else 
           y_out(now) = NaN;
       end


    end
end