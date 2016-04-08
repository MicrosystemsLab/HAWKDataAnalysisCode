%%%% Function: get beahvior velocity statistics:
%  Function analyzes the velocity and acceleration traces and extracts
%  statistics from them. 
%
%  param {Stimulus} struct, contains experiment data organized by stimulus
%  param {numStims} int, the number of stimulus in this experiment.
%
%  returns {Stimulus} struct,  contains experiment data organized by
%  stimulus, modified to include the statistics.
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%
%%%%%


function Stimulus = getBehaviorVelocityStatistics(Stimulus, numStims)

    for stim = 1:numStims
        startTime = Stimulus(stim).StimulusTiming.stimAppliedTime;
        endTime = Stimulus(stim).StimulusTiming.stimEndTime;
        time = Stimulus(stim).timeData(:,8);
         speed_smoothed = Stimulus(stim).CurvatureAnalysis.velocitySmoothed;
         acceleration = diff(speed_smoothed')./diff(time);
         
         Stimulus(stim).CurvatureAnalysis.acceleration = acceleration;
         Stimulus(stim).CurvatureAnalysis.accelerationAverage = mean(acceleration(find(time>startTime,1) : find(time>endTime,1)));
         Stimulus(stim).CurvatureAnalysis.accelerationSTD = std(acceleration(find(time>startTime,1) : find(time>endTime,1)));
         
         Stimulus(stim).CurvatureAnalysis.velocityAverage = mean(speed_smoothed(find(time>startTime,1) : find(time>endTime,1)));
         Stimulus(stim).CurvatureAnalysis.velocitySTD = std(speed_smoothed(find(time>startTime,1) : find(time>endTime,1)));
    end
end