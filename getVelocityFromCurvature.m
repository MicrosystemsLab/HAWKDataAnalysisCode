
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
function [Stimulus] = getVelocityFromCurvature(Stimulus, numStims)
    HAWKSystemConstants;
    HAWKProcessingConstants;

    for stim = 1:numStims
        skeleton = Stimulus(stim).Skeleton;

        numFrames = length(skeleton);
        [Stimulus(stim).curvature, distanceBetweenPoints] = findCurvature(skeleton,CURVATURE_FILTERING_SIGMA,NUMCURVPTS);
        [Stimulus(stim).phaseShift.ps, Stimulus(stim).phaseShift.residual] = calculateCurvaturePhaseShift( Stimulus(stim).curvature, stim);

        Stimulus(stim).velocity.speed =  Stimulus(stim).phaseShift.ps.*(1/NUMCURVPTS).*Stimulus(stim).timeData(2:numFrames,9)';
        Stimulus(stim).velocity.direction = sign( Stimulus(stim).phaseShift.ps);

    end
    
end