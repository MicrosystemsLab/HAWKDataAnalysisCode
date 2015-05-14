%%%%% Function: Filter Frames By Body Length
% Sort between good and back frame based on the body length measurements/
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
    HAWKProcessingConstants;

    for stim = 1:numStims
        %Figure out dropped frames:
        droppedFrameCounter = 1;
        goodFrameCounter = 1;
        % For each frame in the stimulus, if body length is inside 1 std of
        % the original body length statistics, it is classified as a good
        % frame, otherwise it's a bad frame.
        for frame = 1:Stimulus(stim).numFrames; 
            if (Stimulus(stim).BodyMorphology.bodyLength(frame) < Stimulus(stim).BodyMorphology.averageBodyLength*BODY_LENGTH_PERCENT_THRESHOLD || ...
                Stimulus(stim).BodyMorphology.bodyLength(frame) > Stimulus(stim).BodyMorphology.averageBodyLength*(1+(1-BODY_LENGTH_PERCENT_THRESHOLD)))

                Stimulus(stim).BodyMorphology.framesOutOfBodyLengthRange(droppedFrameCounter) = frame;
                droppedFrameCounter = droppedFrameCounter + 1;
            else
                Stimulus(stim).BodyMorphology.framesInsideBodyLengthRange(goodFrameCounter) = frame;
                goodFrameCounter = goodFrameCounter + 1;      
            end

        end
     
        %Save new statistics:
        Stimulus(stim).BodyMorphology.averageBodyLengthGoodFrames = mean(Stimulus(stim).BodyMorphology.bodyLength(Stimulus(stim).BodyMorphology.framesInsideBodyLengthRange)); 
        Stimulus(stim).BodyMorphology.stdBodyLengthGoodFrames = std(Stimulus(stim).BodyMorphology.bodyLength(Stimulus(stim).BodyMorphology.framesInsideBodyLengthRange));
        Stimulus(stim).BodyMorphology.averageBodyWidthGoodFrames = mean(Stimulus(stim).BodyMorphology.widthAtTarget(Stimulus(stim).BodyMorphology.framesInsideBodyLengthRange)); 
        Stimulus(stim).BodyMorphology.stdBodyWidthGoodFrames = std(Stimulus(stim).BodyMorphology.widthAtTarget(Stimulus(stim).BodyMorphology.framesInsideBodyLengthRange));
    end

end