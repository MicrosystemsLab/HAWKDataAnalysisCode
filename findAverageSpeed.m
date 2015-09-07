function [ average ] = findAverageSpeed(time, speed )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


%Find total distance: the integral of speed curve over time. uses the
%trapezoid approximation.
    sumSpeed = pairwiseSum(speed)./2;
    diffTime = diff(time);
    distance = sum(sumSpeed.*diffTime);

%Find total time 
    time = time(end)-time(1);
    
%Average speed is the total distance divided by the total time
    average = sum(distance)/time;


end


