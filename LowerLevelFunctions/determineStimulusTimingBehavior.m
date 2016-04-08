%%%% Function: Determine Stimulus Timing for Behavior mode
%  Determines the important time points during the stimulus. In behavior
%  mode, we only need to know time of first and last frame 
%
%  param {TrackingData} struct, contains all the tracking information from
%  the YAML file
%  param {StimulusData} struct, contains information about the data sent to
%  the FPGA
%  param {Stimulus} struct, contains experiment data organized by stimulus
%  param {numStims} int, the number of stimulus in this experiment.
%
%  returns {Stimulus} struct,  contains experiment data organized by
%  stimulus, modifyed to include the sorted frames.
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%
%%%%%


function Stimulus = determineStimulusTimingBehavior(Stimulus,numStims)
     for stim = 1:numStims
        ind = find(Stimulus(stim).StimulusActivity==1,1,'first');
        Stimulus(stim).StimulusTiming.stimAppliedTime = Stimulus(stim).timeData(ind,8);
        ind = find(diff(Stimulus(stim).StimulusActivity) == -1, 1, 'first');
        Stimulus(stim).StimulusTiming.stimEndTime = Stimulus(stim).timeData(ind,8);    
     end
end
