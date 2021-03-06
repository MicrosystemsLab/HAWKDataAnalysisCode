%% Populate data by stimulus 
% This function prepares a matrix to  be written to the experiment log,
% extracting all the relevant information for a series of stimulus and
% placing it in the correct columns. 

function [data, firstColumn] = populateBehaviorPerStimulusData( Stimulus, titles, numStims)
    firstColumn = strmatch('Stimulus Number',titles,'exact');
   
    
    for stim = 1:numStims
        time = Stimulus(stim).timeData(1,[1:6]);
        data(stim, strmatch('Stimulus First Frame Time',titles,'exact')-firstColumn+1) = Stimulus(stim).firstFrameTime;
        data(stim, strmatch('Stimulus Approach On Time',titles,'exact')-firstColumn+1) = Stimulus(stim).approachStartTime;
        data(stim, strmatch('Stimulus Start Time',titles,'exact')-firstColumn+1) = Stimulus(stim).stimOnStartTime;
        data(stim, strmatch('Stimulus End Time',titles,'exact')-firstColumn+1) = Stimulus(stim).stimEndTime;
        data(stim, strmatch('Stimulus Number',titles,'exact')-firstColumn+1) = stim;
        data(stim, strmatch('Average Body length (um)', titles, 'exact')-firstColumn+1) = Stimulus(stim).averageBodyLengthGoodFrames;
        data(stim, strmatch('STD Body Length', titles, 'exact')-firstColumn+1) = Stimulus(stim).stdBodyLengthGoodFrames;
        data(stim, strmatch('Soft Balance Value (V)', titles, 'exact')-firstColumn+1) = Stimulus(stim).stimulusAnalysis.preApproachPoints.average;
        data(stim, strmatch('Approach Duration (s)', titles, 'exact')-firstColumn+1) = Stimulus(stim).stimulusAnalysis.approachPoints.duration;
        data(stim, strmatch('Stimulus RMS Error', titles, 'exact')-firstColumn+1) = Stimulus(stim).stimulusAnalysis.stimulusPoints.rmsError;
        data(stim, strmatch('Stimulus Rise Time (s)', titles, 'exact')-firstColumn+1) = Stimulus(stim).stimulusAnalysis.stimulusPoints.response.RiseTime;
        data(stim, strmatch('Stimulus Settling Time (s)', titles, 'exact')-firstColumn+1) = Stimulus(stim).stimulusAnalysis.stimulusPoints.response.SettlingTime;
        data(stim, strmatch('Stimulus Value (V)', titles, 'exact')-firstColumn+1) = (Stimulus(stim).stimulusAnalysis.stimulusPoints.response.SettlingMin +Stimulus(stim).stimulusAnalysis.stimulusPoints.response.SettlingMax)/2;
        data(stim, strmatch('Zero Pulse Duration (s)', titles, 'exact')-firstColumn+1) = Stimulus(stim).stimulusAnalysis.zeroPulsePoints.duration;
        data(stim, strmatch('Zero Pulse Average (V)', titles, 'exact')-firstColumn+1) = Stimulus(stim).stimulusAnalysis.zeroPulsePoints.average;
        data(stim, strmatch('Zero Pulse RMS Error', titles, 'exact')-firstColumn+1)	= Stimulus(stim).stimulusAnalysis.zeroPulsePoints.rmsError;
        data(stim, strmatch('Pull off Voltage (V)', titles, 'exact')-firstColumn+1) = Stimulus(stim).stimulusAnalysis.postPulsePoints.min;
        data(stim, strmatch('Distance from Target (um)', titles, 'exact')-firstColumn+1) = Stimulus(stim).distanceFromTarget;
        data(stim, strmatch('Percent Down Body Hit (%)', titles, 'exact')-firstColumn+1) = Stimulus(stim).percentDownBodyHit;
        data(stim, strmatch('Distance from Skeleton (um)', titles, 'exact')-firstColumn+1) = Stimulus(stim).distanceFromSketelon;
    end
   
    
end


	

