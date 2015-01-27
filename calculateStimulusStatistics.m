%% Calculate Stimulus Statistics function
% This function looks the applied force in a series of trials and
% compares them to the desired signal. It breaks down the applied stimulus
% into its different parts, gathers the statistics and revelant information
% on each part and returns a data structure containing the data. 

% It requires two input parameters: Stimulus, where all the FPGA data is
% stored, and the Stimulus data from the Stimulus.yaml file created by the
% HAWK software at experiment set up.

% created by: Eileen Mazzochette
% January 26, 2015



function stats = calculateStimulusStatistics(Stimulus, StimulusData)
    numStims = length(Stimulus);
    interval = 0.001;
    
    for stim = 1:numStims;
        numPoints = length(Stimulus(stim).PiezoSignal);
        % Break Piezo data into five parts:
        % 1. Pre approach
        stats(stim).preApproachPoints.data = Stimulus(stim).PiezoSignal([1:Stimulus(stim).FPGAStats.approachOnIndex-1]);

        % for each part, calculate: min, max, average, duration.
        stats(stim).preApproachPoints.min = min(stats(stim).preApproachPoints.data);
        stats(stim).preApproachPoints.max = max(stats(stim).preApproachPoints.data);
        stats(stim).preApproachPoints.average = mean(stats(stim).preApproachPoints.data);
        stats(stim).preApproachPoints.std = std(stats(stim).preApproachPoints.data);



        % 2. Approach
        stats(stim).approachPoints.data = Stimulus(stim).DesiredSignal([Stimulus(stim).FPGAStats.approachOnIndex:Stimulus(stim).FPGAStats.stimOnIndex-1]);
        % for approach:
        stats(stim).approachPoints.min = min(stats(stim).approachPoints.data);
        stats(stim).approachPoints.max = max(stats(stim).approachPoints.data);
        stats(stim).approachPoints.duration = length(stats(stim).approachPoints.data)*interval;
        stats(stim).approachPoints.slope = (stats(stim).approachPoints.max - stats(stim).approachPoints.min)/stats(stim).approachPoints.duration;

        % 3. Stimulus
        numberOfStimulusPoints = StimulusData.ContactTime/interval;
        stats(stim).stimulusPoints.data = Stimulus(stim).PiezoSignal([Stimulus(stim).FPGAStats.stimOnIndex:Stimulus(stim).FPGAStats.stimOnIndex+numberOfStimulusPoints-1]);
        desiredPoints = Stimulus(stim).DesiredSignal([Stimulus(stim).FPGAStats.stimOnIndex:Stimulus(stim).FPGAStats.stimOnIndex+numberOfStimulusPoints-1]);
        desiredPoints = desiredPoints + stats(stim).preApproachPoints.average;
        % for stimulus, calculate: rise time, overshoot, rms error
        stats(stim).stimulusPoints.min = min(stats(stim).stimulusPoints.data);
        stats(stim).stimulusPoints.max = max(stats(stim).stimulusPoints.data);
        stats(stim).stimulusPoints.average = mean(stats(stim).stimulusPoints.data);
        stats(stim).stimulusPoints.std = std(stats(stim).stimulusPoints.data);
        stats(stim).stimulusPoints.rmsError = sqrt(mean((stats(stim).stimulusPoints.data - desiredPoints).^2));
        time = interval*[0:length(stats(stim).stimulusPoints.data)-1];
        stats(stim).stimulusPoints.response = stepinfo(stats(stim).stimulusPoints.data,time);

        % 4. Zero pulse
        numberOfZeroPulsePoints = StimulusData.ZeroPulseDuration/interval;
        stats(stim).zeroPulsePoints.data = Stimulus(stim).PiezoSignal([Stimulus(stim).FPGAStats.stimOnIndex+numberOfStimulusPoints:Stimulus(stim).FPGAStats.stimOnIndex+numberOfStimulusPoints+numberOfZeroPulsePoints-1]);
        % for zero pulse, calculate: rms error
        stats(stim).zeroPulsePoints.min = min(stats(stim).zeroPulsePoints.data);
        stats(stim).zeroPulsePoints.max = max(stats(stim).zeroPulsePoints.data);
        stats(stim).zeroPulsePoints.average = mean(stats(stim).zeroPulsePoints.data);
        stats(stim).zeroPulsePoints.std = std(stats(stim).zeroPulsePoints.data);
        stats(stim).zeroPulsePoints.rmsError = sqrt(mean((stats(stim).zeroPulsePoints.data - stats(stim).preApproachPoints.average).^2));
        stats(stim).zeroPulsePoints.duration = StimulusData.ZeroPulseDuration;
        % 5. Post pulse
        stats(stim).postPulsePoints.data = Stimulus(stim).PiezoSignal([Stimulus(stim).FPGAStats.stimOnIndex+numberOfStimulusPoints+numberOfZeroPulsePoints:numPoints]);
        stats(stim).postPulsePoints.min = min(stats(stim).postPulsePoints.data);
        stats(stim).postPulsePoints.max = max(stats(stim).postPulsePoints.data);
        stats(stim).postPulsePoints.average = mean(stats(stim).postPulsePoints.data);
        stats(stim).postPulsePoints.std = std(stats(stim).postPulsePoints.data);

    end
    %return: stimulusStatistics
  
 end