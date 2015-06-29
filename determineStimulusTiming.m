%%%% Function: Sort Frames Based on Stimulus
%  Sorts frames in each stimulus into before, during, and after stimulus
%  periods

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

function Stimulus = determineStimulusTiming(TrackingData, StimulusData, Stimulus, numStims)
    % Get the timing interval between points reported from FPGA:
    acquisitionInterval = TrackingData.ReportedFPGAParameters.AcquisitionFrequency*0.00001;
    for stim = 1:numStims
        %First get time references in tracking clock:
        %Get frame time when stimulus button was hit:
        ind = find(Stimulus(stim).StimulusActivity==1,1,'first');
        Stimulus(stim).StimulusTiming.stimAppliedTime = Stimulus(stim).timeData(ind,8);
        %Get frame time when stimulus was over:
        ind = find(diff(Stimulus(stim).StimulusActivity) == -1, 1, 'first');
        Stimulus(stim).StimulusTiming.stimEndTime = Stimulus(stim).timeData(ind,8);    

        %Evaluate FPGA timing:
        % setup time vectors:
        timeFPGA = 0:length(Stimulus(stim).FPGAData.DesiredSignal)-1;
        timeFPGA = timeFPGA*acquisitionInterval;
        % find approach, stim on start time
        approachOnIndex = find(Stimulus(stim).FPGAData.DesiredSignal>0,1,'first');
        approachOnTime = timeFPGA(approachOnIndex);
        stimOnIndex =  find(diff(diff(Stimulus(stim).FPGAData.DesiredSignal))>0.0001,3,'first');
        stimOnIndex = stimOnIndex(length(stimOnIndex))+1;
        stimOnTime = timeFPGA(stimOnIndex);
        %Save those indices in case we need to reference later:
        Stimulus(stim).StimulusTiming.approachOnFPGAIndex = approachOnIndex;
        Stimulus(stim).StimulusTiming.stimOnFPGAIndex = stimOnIndex;
        approachDuration = stimOnTime - approachOnTime;
        
        %determine times relative to tracking clock (not FPGA clock)
        Stimulus(stim).StimulusTiming.approachStartTime = Stimulus(stim).StimulusTiming.stimAppliedTime;% + approachOnTime;
        Stimulus(stim).StimulusTiming.stimOnStartTime = Stimulus(stim).StimulusTiming.stimAppliedTime + approachDuration;
        %Compare stimulus to desired stimulus, get some statistics:
        Stimulus(stim).StimulusTiming.stimulusAnalysis = calculateStimulusStatistics(Stimulus(stim), StimulusData);
    end
end