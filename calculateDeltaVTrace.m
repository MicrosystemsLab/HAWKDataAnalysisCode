function [ deltaVNorm ] = calculateDeltaVTrace( velocity, time, stimOnFrame )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


    if stimOnFrame>15
        startFrame = stimOnFrame-15;
    else
        startFrame = 1;
    end
    avePreVelocity = findAverageSpeed(time(startFrame:stimOnFrame-1)', -1.*velocity(startFrame: stimOnFrame-1));
    deltaV = (avePreVelocity-(-1.*velocity));
    deltaVNorm = deltaV./avePreVelocity;
end

