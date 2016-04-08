%%%% Function: getTimingData
%  Organizes timing data of each stimulus. 
% 
%  Appends three new columns to "Time Data" structure within Stimulus 
%  First column is the timding data in seconds + minutes
%  Second column is the elasped time since the first frame.
%  Third column is the time since the last frame
%  Also extracts the time of the first frame relative to the beginning of
%  the experiment
%
%  param {Stimulus} struct,  contains experiment data organized by
%  stimulus
%  param {numStims} int, the number of stimulus in this experiment.
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%
%%%%%



function Stimulus = getTimingData(Stimulus,numStims, TrackingData)
      for stim=1:numStims
        % seventh column of timing data is the seconds + minutes. 
        Stimulus(stim).timeData(:,7) =  Stimulus(stim).timeData(:,4).*60.*60+ Stimulus(stim).timeData(:,5).*60+ Stimulus(stim).timeData(:,6);
        % eighth column of timing data is the elapsed time from first frame in
        % seconds
        Stimulus(stim).timeData(:,8) =  Stimulus(stim).timeData(:,7) -  Stimulus(stim).timeData(1,7);
        %ninth column of timing data is the time since the last frame.
        Stimulus(stim).timeData(:,9) = [0; diff( Stimulus(stim).timeData(:,7))];
        %time of the first frame relative to the beginning of the experiment
        timeDifference = Stimulus(stim).timeData(1,[1:6]) - datevec(TrackingData.ExperimentTime);
        Stimulus(stim).firstFrameTime = timeDifference(4)*60*60 + timeDifference(5)*60 + timeDifference(6);

      end  
end