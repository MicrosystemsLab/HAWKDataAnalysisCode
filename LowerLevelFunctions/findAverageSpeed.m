%%%% Function: find average speed
%  finds the average speed using integration. To be used for functions when
%  the time delta between samples is not the same.
%
%  params {speed} vector<double>, the speed values to average over
%  params {time} vector<double>, the time vector to average over. 
% 
%  returns {average} double, the average speed over the time 
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%%%%% 

function [ average ] = findAverageSpeed(time, speed )

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


