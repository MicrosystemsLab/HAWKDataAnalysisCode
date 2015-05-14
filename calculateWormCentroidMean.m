%%%% Function: calculate Worm Centroid and Mean
%  Calculates the centroid and mean of the worm based on the skeleton. 
%  The centroid is the midpoint of the skeleton
%  The mean is the average of the x and y coordinates of middle of the worm
%
%  param {Stimulus} struct,  contains experiment data organized by
%  stimulus
%  param {numStims} int, the number of stimulus in this experiment.
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%
%%%%%


function [Stimulus] = calculateWormCentroidMean(Stimulus,numStims)

    for stim = 1:numStims
        for frame = 1:Stimulus(stim).numFrames
        %Find the mid-skeleton point, mean skeleton point
            Stimulus(stim).PixelPositions.centroid.x(frame) = Stimulus(stim).Skeleton(frame).x(floor(length(Stimulus(stim).Skeleton(frame).x)/2));
            Stimulus(stim).PixelPositions.centroid.y(frame) = Stimulus(stim).Skeleton(frame).y(floor(length(Stimulus(stim).Skeleton(frame).y)/2));
            
            numSkeletonPoints = length(Stimulus(stim).Skeleton(frame).x);
            antTrunc = 0.25;
            postTrunc = 0.1;
            anteriorPointsToEliminate = floor(antTrunc*numSkeletonPoints);
            posteriorPointsToEliminate = floor(postTrunc*numSkeletonPoints);
            
            Stimulus(stim).PixelPositions.mean.x(frame) = mean(Stimulus(stim).Skeleton(frame).x([anteriorPointsToEliminate:numSkeletonPoints-posteriorPointsToEliminate]));
            Stimulus(stim).PixelPositions.mean.y(frame) = mean(Stimulus(stim).Skeleton(frame).y([anteriorPointsToEliminate:numSkeletonPoints-posteriorPointsToEliminate]));
        end
    end         
end