%%%% Function: Get Track Statistics
%  Calculates the average of the track wavelength and amplitude before and
%  after stimulus application
%
%  param {Stimulus} struct,  contains experiment data organized by
%  stimulus
%  param {numStims} int, the number of stimulus in this experiment.
%
%  returns {Stimulus} struct,  contains experiment data organized by
%  stimulus, now includes amplitude and wavelenght averages.
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%
%%%%%


function Stimulus = getTrackStatistics(Stimulus, numStims)

    for stim = 1:numStims
        %For this stimulus, set statistics on the track amplitude and wavelength before and
        %after the stimulus is applied:
        stimOnFrame = Stimulus(stim).StimulusTiming.stimOnFrame;
        numPreStimFrames = length(Stimulus(stim).FramesByStimulus.PreStimFrames);
        %Want at least 15 frames pre stimulus. If there are less than 15
        %frames, get as many as you can:
        if numPreStimFrames < 22
            cutoff = numPreStimFrames - 1;
        else
            cutoff = 21;
        end
        %Get stats:
       Stimulus(stim).Trajectory.amplitudePreStimAve = nanmean(Stimulus(stim).Trajectory.amplitude(stimOnFrame - cutoff:stimOnFrame-1));       
       Stimulus(stim).Trajectory.wavelengthPreStimAve = nanmean(Stimulus(stim).Trajectory.wavelength(stimOnFrame - cutoff:stimOnFrame-1));
       Stimulus(stim).Trajectory.amplitudePostStimAve = nanmean(Stimulus(stim).Trajectory.amplitude(stimOnFrame:stimOnFrame+55));
       Stimulus(stim).Trajectory.wavelengthPostStimAve = nanmean(Stimulus(stim).Trajectory.wavelength(stimOnFrame:stimOnFrame+55));
    end
end