%%%% Function: Sort Frames Based on Stimulus
%  Sorts frames in each stimulus into before, during, and after stimulus
%  periods
% 
%  param {Stimulus} struct, contains experiment data organized by stimulus
%  param {numStims} int, the number of stimulus in this experiment.
%  returns {Stimulus} struct,  contains experiment data organized by
%  stimulus, modifyed to include the sorted frames.
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%
%%%%%


function Stimulus = sortFramesBasedOnStimulus(Stimulus, numStims)

    for stim=1:numStims
      
        preCount = 1;
        duringCount = 1;
        postCount = 1;
        
        for frame = 1:Stimulus(stim).numFrames;
            if (Stimulus(stim).timeData(frame,8) < Stimulus(stim).stimAppliedTime)
                Stimulus(stim).PreStimFrames(preCount) = frame;
            elseif (Stimulus(stim).timeData(frame,8) < Stimulus(stim).stimEndTime)
                Stimulus(stim).DuringStimFrames(duringCount) = frame;
                duringCount = duringCount + 1;
            else
                Stimulus(stim).PostStimFrames(postCount) = frame;
                postCount = postCount + 1;
            end

        end

    end
end