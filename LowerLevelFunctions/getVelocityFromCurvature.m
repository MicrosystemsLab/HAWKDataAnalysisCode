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
        Stimulus(stim).CurvatureAnalysis.velocity(1) =  0;
        counter = 1;
        counter2 = 2;
        lastGoodFrame = 1;
        time = [];
        velocity = [];
        skippedFrames = [];
        for(frame = 2:numFrames)
            if (isnan(Stimulus(stim).CurvatureAnalysis.phaseShift.ps(frame-1)))
                 Stimulus(stim).CurvatureAnalysis.velocity(frame) =  0;
                 skippedFrames(counter) = frame;
                 counter = counter+1;
            else
                deltaX = Stimulus(stim).CurvatureAnalysis.phaseShift.ps(frame-1) .* (1/NUMCURVPTS) .* Stimulus(stim).BodyMorphology.bodyLength(frame);
                deltaT = Stimulus(stim).timeData(frame,8)-Stimulus(stim).timeData(lastGoodFrame,8);
                Stimulus(stim).CurvatureAnalysis.velocity(frame) =  deltaX./deltaT';
                velocity(counter2) = deltaX./deltaT';
                time(counter2) = Stimulus(stim).timeData(frame,8);
                counter2 = counter2+1;
                lastGoodFrame = frame;
            end
        end
        
        %Go back and fix skipped frames by linearly interpolating across them.
        Stimulus(stim).CurvatureAnalysis.velocity(skippedFrames) = interp1(time, velocity,Stimulus(stim).timeData(skippedFrames,8));
                    
        %Smooth the velocity with a 1D filter. 
        Stimulus(stim).CurvatureAnalysis.velocitySmoothed = lowpass1D( Stimulus(stim).CurvatureAnalysis.velocity,2);

    end
    
end