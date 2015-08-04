
%%%%% Function: Get Velocity From Curvature 
%  This function calculates the curvature, the phase shift for each
%  curvature from frame to frame, and then extracts the velocity based on
%  the phase shift.
%  param {Stimulus} struct,  contains experiment data organized by
%  stimulus
%  param {numStims} int, the number of stimulus in this experiment.
%
%  returns {Stimulus}, struct, the input parameter with structure added 
%  that gives the speed and direction vector for each stimulus
% 
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%%%%% 
function [Stimulus] = getVelocityFromCurvature(Stimulus, numStims)
    HAWKSystemConstants;
    HAWKProcessingConstants;

    for stim = 1:numStims
        skeleton = Stimulus(stim).SkeletonSmooth;

        numFrames = length(skeleton);
         
        [Stimulus(stim).CurvatureAnalysis.phaseShift.ps, Stimulus(stim).CurvatureAnalysis.phaseShift.residual] = calculateCurvaturePhaseShift( Stimulus(stim).CurvatureAnalysis.curvature, stim, Stimulus(stim).FrameScoring.BadFrames);
        cumulativeTime = 0;                 
        Stimulus(stim).CurvatureAnalysis.velocity(1) =  0;
        for(frame = 2:numFrames)
            if (isnan(Stimulus(stim).CurvatureAnalysis.phaseShift.ps(frame-1)))
                 Stimulus(stim).CurvatureAnalysis.velocity(frame) =  NaN;
            else
                deltaX = Stimulus(stim).CurvatureAnalysis.phaseShift.ps(frame-1) .* (1/NUMCURVPTS) .* Stimulus(stim).BodyMorphology.bodyLength(frame);
                deltaT = Stimulus(stim).timeData(frame,8)-cumulativeTime;
                Stimulus(stim).CurvatureAnalysis.velocity(frame) =  deltaX./deltaT';
                cumulativeTime = Stimulus(stim).timeData(frame,8);
            end
        end
        Stimulus(stim).CurvatureAnalysis.velocitySmoothed = lowpass1D( Stimulus(stim).CurvatureAnalysis.velocity,2);

    end
    
end