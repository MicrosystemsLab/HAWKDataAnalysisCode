
%%%%% Function: Get Velocity From Curvature 
%  This function calculates the curvature, the phase shift for each
%  curvature from frame to frame, and then extracts the velocity based on
%  the phase shift.
%  param {Stimulus} struct,  contains experiment data organized by
%  stimulus
%  param {numStims} int, the number of stimulus in this experiment.
%
%  returns {velocity}, struct, a speed and direction vector for each
%  stimulus
% 
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%%%%% 
function [velocity] = getVelocityFromCurvature(Stimulus, numStims)
    HAWKSystemConstants;
    numcurvpts = 50;
    colors = {'r','b','k','g','m','y'};
    for stim = 1:numStims
        skeleton = Stimulus(stim).Skeleton;

        numFrames = length(skeleton);
        [curvature, distanceBetweenPoints] = findCurvature(skeleton,1,numcurvpts);
        ps = calculateCurvaturePhaseShift(curvature);

%         averageDistances = [distanceBetweenPoints 1] + [1 distanceBetweenPoints];
%         averageDistances = 0.5*averageDistances(2:numFrames);
%         distanceMoved = ps.*averageDistances.*UM_PER_PIXEL;
%         velocity(stim).speed = distanceMoved.*Stimulus(stim).timeData(2:numFrames,9)';

        velocity(stim).speed = ps.*(1/numcurvpts).*Stimulus(stim).timeData(2:numFrames,9)';
        velocity(stim).direction = sign(ps);
        
        plot(1:numFrames-1,velocity(stim).speed, colors{stim});
        hold on
    end
    
end