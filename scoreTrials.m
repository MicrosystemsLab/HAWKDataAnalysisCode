
%%%%% Function: Score trials
%  Determines if trial was viable by checking three parameters:
%  1) number of dropped frames during the stimulus
%  2) that the stimulus was applied within 7.5% of the target
%  3) that the stimulus applied was within spec.
%
%  param {Stimulus} struct,  contains experiment data organized by
%  stimulus
%  param {numStims} int, the number of stimulus in this experiment.
%  
%  returns {Stimulus} struct, returns the same Stimulus with an added list
%  of the computer determined bad frames.
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%
%%%%%

function Stimulus = scoreTrials(TrackingData, Stimulus, numStims)
    HAWKProcessingConstants;
    
    
   
    for stim = 1:numStims
        %Check number of frames lost during stimulus
        droppedFramesCheck = sum(ismember( Stimulus(stim).FramesByStimulus.DuringStimFrames, Stimulus(stim).FrameScoring.BadFrames))<DROPPED_FRAMES_DURING_STIMULUS;
        
        %Check within 7.5% of target and 15% of body width
        stimulusLocationCheck = (abs(TrackingData.TargetLocation - Stimulus(stim).SpatialResolution.percentDownBodyHit*100) < PERCENT_DOWN_BODY_DIFFERENCE) & ...
            (Stimulus(stim).SpatialResolution.percentAcrossBodyHit*100 < PERCENT_ACROSS_BODY_DIFFERENCE) ;
        
        %Check stimulus
        stimulusApplicationCheck = true;
        
        Stimulus(stim).TrialScoring.trialSuccessScoring = [droppedFramesCheck   stimulusLocationCheck   stimulusApplicationCheck];
        if (droppedFramesCheck && stimulusLocationCheck && stimulusApplicationCheck)
            Stimulus(stim).TrialScoring.trialSuccess = 1;
        else
            Stimulus(stim).TrialScoring.trialSuccess = 0;
        end    
    end
end




