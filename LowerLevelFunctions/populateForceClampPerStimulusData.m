%%%%% Function: Populate Force Clamp Per Stimulus Data
% This function prepares a matrix to  be written to the experiment log,
% extracting all the relevant information for a series of stimulus and
% placing it in the correct columns. This is specific to behavior
% experimeent 
% 
%  param {Stimulus} struct,  contains experiment data organized by
%  stimulus
%  params {titles} array<strings>, column titles of the excel spreadsheet
%  for matching
%  param {numStims} int, the number of stimulus in this experiment.
%  
%  returns {data} martix, the data to be written to the excel spreadsheet
%  organized correctly
%  returns {firstColumn} int, the column index in the excel spreadsheet 
%  where the matrix shold be written.
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%
%%%%%


function [data, firstColumn] = populateForceClampPerStimulusData( Stimulus, titles, numStims)
    firstColumn = strmatch('Stimulus Number',titles,'exact');
    for stim = 1:numStims
        time = Stimulus(stim).timeData(1,[1:6]);
        data(stim, strmatch('Stimulus First Frame Time',titles,'exact')-firstColumn+1) = Stimulus(stim).firstFrameTime;
        data(stim, strmatch('Stimulus Approach On Time',titles,'exact')-firstColumn+1) = Stimulus(stim).StimulusTiming.approachStartTime;
        data(stim, strmatch('Stimulus Start Time',titles,'exact')-firstColumn+1) = Stimulus(stim).StimulusTiming.stimOnStartTime;
        data(stim, strmatch('Stimulus End Time',titles,'exact')-firstColumn+1) = Stimulus(stim).StimulusTiming.stimEndTime;
        data(stim, strmatch('Stimulus Number',titles,'exact')-firstColumn+1) = stim;
        
        %Body Morphology:
        data(stim, strmatch('Average Body length (um)', titles, 'exact')-firstColumn+1) = Stimulus(stim).BodyMorphology.averageBodyLength;
        data(stim, strmatch('STD Body Length (um)', titles, 'exact')-firstColumn+1) = Stimulus(stim).BodyMorphology.stdBodyLength;
        data(stim, strmatch('Average Body Width (um)', titles, 'exact')-firstColumn+1) = Stimulus(stim).BodyMorphology.averageBodyWidth;
        data(stim, strmatch('STD Body Width (um)', titles, 'exact')-firstColumn+1) = Stimulus(stim).BodyMorphology.stdBodyWidth;
        data(stim, strmatch('Filtered Average Body length (um)', titles, 'exact')-firstColumn+1) = Stimulus(stim).BodyMorphology.averageBodyLengthGoodFrames;
        data(stim, strmatch('Filtered STD Body Length (um)', titles, 'exact')-firstColumn+1) = Stimulus(stim).BodyMorphology.stdBodyLengthGoodFrames;
        data(stim, strmatch('Filtered Average Body Width (um)', titles, 'exact')-firstColumn+1) = Stimulus(stim).BodyMorphology.averageBodyWidthGoodFrames;
        data(stim, strmatch('Filtered STD Body Width (um)', titles, 'exact')-firstColumn+1) = Stimulus(stim).BodyMorphology.stdBodyWidthGoodFrames;
        
        %Stimulus Statistics:
        data(stim, strmatch('Soft Balance Value (V)', titles, 'exact')-firstColumn+1) = Stimulus(stim).StimulusTiming.stimulusAnalysis.preApproachPoints.average;
        data(stim, strmatch('Approach Duration (s)', titles, 'exact')-firstColumn+1) = Stimulus(stim).StimulusTiming.stimulusAnalysis.approachPoints.duration;
        data(stim, strmatch('Stimulus RMS Error', titles, 'exact')-firstColumn+1) = Stimulus(stim).StimulusTiming.stimulusAnalysis.stimulusPoints.rmsError;
        data(stim, strmatch('Stimulus Rise Time (s)', titles, 'exact')-firstColumn+1) = Stimulus(stim).StimulusTiming.stimulusAnalysis.stimulusPoints.response.RiseTime;
        data(stim, strmatch('Stimulus Settling Time (s)', titles, 'exact')-firstColumn+1) = Stimulus(stim).StimulusTiming.stimulusAnalysis.stimulusPoints.response.SettlingTime;
        data(stim, strmatch('Stimulus Value (V)', titles, 'exact')-firstColumn+1) = (Stimulus(stim).StimulusTiming.stimulusAnalysis.stimulusPoints.response.SettlingMin +Stimulus(stim).StimulusTiming.stimulusAnalysis.stimulusPoints.response.SettlingMax)/2;
        data(stim, strmatch('Zero Pulse Duration (s)', titles, 'exact')-firstColumn+1) = Stimulus(stim).StimulusTiming.stimulusAnalysis.zeroPulsePoints.duration;
        data(stim, strmatch('Zero Pulse Average (V)', titles, 'exact')-firstColumn+1) = Stimulus(stim).StimulusTiming.stimulusAnalysis.zeroPulsePoints.average;
        data(stim, strmatch('Zero Pulse RMS Error', titles, 'exact')-firstColumn+1)	= Stimulus(stim).StimulusTiming.stimulusAnalysis.zeroPulsePoints.rmsError;
        data(stim, strmatch('Pull off Voltage (V)', titles, 'exact')-firstColumn+1) = Stimulus(stim).StimulusTiming.stimulusAnalysis.postPulsePoints.min;
       
        %Spatial Resolution Data:
        data(stim, strmatch('Distance from Target (um)', titles, 'exact')-firstColumn+1) = Stimulus(stim).SpatialResolution.distanceFromTarget;
        data(stim, strmatch('Percent Down Body Hit (%)', titles, 'exact')-firstColumn+1) = Stimulus(stim).SpatialResolution.percentDownBodyHit;
        data(stim, strmatch('Distance from Skeleton (um)', titles, 'exact')-firstColumn+1) = Stimulus(stim).SpatialResolution.distanceFromSkeleton;
        data(stim, strmatch('Percent Across Body Hit (%)', titles, 'exact')-firstColumn+1) = Stimulus(stim).SpatialResolution.percentAcrossBodyHit;
    end
   
    
end


	

