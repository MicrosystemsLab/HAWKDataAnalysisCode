%%%%% Function: Populate Behavior Per Stimulus Data
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


function [data, firstColumn] = populateBehaviorPerStimulusData( Stimulus, titles, numStims)
    firstColumn = strmatch('Stimulus Number',titles,'exact');
   
    
    for stim = 1:numStims
        time = Stimulus(stim).timeData(1,[1:6]);
        %Information about stimulus statistics:
        data(stim, strmatch('Stimulus Number',titles,'exact')-firstColumn+1) = stim;
        data(stim, strmatch('Stimulus First Frame Time',titles,'exact')-firstColumn+1) = Stimulus(stim).firstFrameTime;
        if (~isempty(Stimulus(stim).stimAppliedTime))
            data(stim, strmatch('Stimulus Start Time',titles,'exact')-firstColumn+1) = Stimulus(stim).stimAppliedTime;
        end
        if (~isempty(Stimulus(stim).stimEndTime))
            data(stim, strmatch('Stimulus End Time',titles,'exact')-firstColumn+1) = Stimulus(stim).stimEndTime;
        end
        
        %Body Morphology recording:
        data(stim, strmatch('Average Body length (um)', titles, 'exact')-firstColumn+1) = Stimulus(stim).averageBodyLength;
        data(stim, strmatch('STD Body Length (um)', titles, 'exact')-firstColumn+1) = Stimulus(stim).stdBodyLength;
        data(stim, strmatch('Average Body Width (um)', titles, 'exact')-firstColumn+1) = Stimulus(stim).averageBodyWidth;
        data(stim, strmatch('STD Body Width (um)', titles, 'exact')-firstColumn+1) = Stimulus(stim).stdBodyWidth;
        data(stim, strmatch('Filtered Average Body length (um)', titles, 'exact')-firstColumn+1) = Stimulus(stim).averageBodyLengthGoodFrames;
        data(stim, strmatch('Filtered STD Body Length (um)', titles, 'exact')-firstColumn+1) = Stimulus(stim).stdBodyLengthGoodFrames;
        data(stim, strmatch('Filtered Average Body Width (um)', titles, 'exact')-firstColumn+1) = Stimulus(stim).averageBodyWidthGoodFrames;
        data(stim, strmatch('Filtered STD Body Width (um)', titles, 'exact')-firstColumn+1) = Stimulus(stim).stdBodyWidthGoodFrames;
        
        % Targeting Characterization Parameters:
        data(stim, strmatch('Distance from Target (um)', titles, 'exact')-firstColumn+1) = Stimulus(stim).distanceFromTarget;
        data(stim, strmatch('Percent Down Body Hit (%)', titles, 'exact')-firstColumn+1) = Stimulus(stim).percentDownBodyHit;
        data(stim, strmatch('Distance from Skeleton (um)', titles, 'exact')-firstColumn+1) = Stimulus(stim).distanceFromSkeleton;
        data(stim, strmatch('Percent Across Body Hit (%)', titles, 'exact')-firstColumn+1) = Stimulus(stim).percentAcrossBodyHit;
    end
   
    
end


	

