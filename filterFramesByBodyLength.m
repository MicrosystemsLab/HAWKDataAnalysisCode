%%%%% Function: Filter Frames By Body Length
% This function prepares a matrix to  be written to the experiment log,
% extracting all the relevant information for a series of stimulus and
% placing it in the correct columns. This is specific to behavior
% experimeent 
% 
%  param {Stimulus} struct,  contains experiment data organized by
%  stimulus
%  param {numStims} int, the number of stimulus in this experiment.
%  
%  returns {Stimulus} struct, contains experiment data organized by
%  stimulus, includes good frames, bad frames filtered by body length
%  statistics.
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%
%%%%%


function Stimulus = filterFramesByBodyLength(Stimulus,numStims)
    clear Stimulus.droppedFrames;
    clear Stimulus.goodFrames;

    for stim = 1:numStims
        %Figure out dropped frames:
        droppedFrameCounter = 1;
        goodFrameCounter = 1;
        % For each frame in the stimulus, if body length is inside 1 std of
        % the original body length statistics, it is classified as a good
        % frame, otherwise it's a bad frame.
        for frameParser = 1:Stimulus(stim).numFrames; 
            if (Stimulus(stim).bodyLength(frameParser) < Stimulus(stim).averageBodyLength-Stimulus(stim).stdBodyLength || ...
                Stimulus(stim).bodyLength(frameParser) > Stimulus(stim).averageBodyLength+Stimulus(stim).stdBodyLength)
                Stimulus(stim).droppedFrames(droppedFrameCounter) = frameParser;
                droppedFrameCounter = droppedFrameCounter + 1;
            else
                Stimulus(stim).goodFrames(goodFrameCounter) = frameParser;
                goodFrameCounter = goodFrameCounter + 1;      
            end

        end
        
        %Save new statistics:
        Stimulus(stim).averageBodyLengthGoodFrames = mean(Stimulus(stim).bodyLength(Stimulus(stim).goodFrames)); 
        Stimulus(stim).stdBodyLengthGoodFrames = std(Stimulus(stim).bodyLength(Stimulus(stim).goodFrames));
        Stimulus(stim).averageBodyWidthGoodFrames = mean(Stimulus(stim).widthAtTarget(Stimulus(stim).goodFrames)); 
        Stimulus(stim).stdBodyWidthGoodFrames = std(Stimulus(stim).widthAtTarget(Stimulus(stim).goodFrames));
    end

end