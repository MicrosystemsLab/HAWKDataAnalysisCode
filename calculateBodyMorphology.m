%%%% Function: calculate body morpholoy
%  Calculated the length and width of the animal, and calculates statistics
%  by stimulus
%
%  param {Stimulus} struct,  contains experiment data organized by
%  stimulus
%  param {numStims} int, the number of stimulus in this experiment.
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%
%%%%%


function [Stimulus] = calculateBodyMorphology(Stimulus, numStims)
    HAWKSystemConstants;
   for stim = 1:numStims
       for frame = 1:Stimulus(stim).numFrames
           %Also calculate body length based on skeleton length:
            Stimulus(stim).BodyMorphology.bodyLength(frame) = calculateBodyLength(Stimulus(stim).Skeleton(frame).x, Stimulus(stim).Skeleton(frame).y)*UM_PER_PIXEL; 

            % Find worm body width if possible:
           
            %Width is distance between two segment points at target,
            %converted to um.
            Stimulus(stim).BodyMorphology.widthAtTarget(frame) = UM_PER_PIXEL * distanceCalc(...
                         Stimulus(stim).PixelPositions.targetSegment1.x(frame), Stimulus(stim).PixelPositions.targetSegment1.y(frame), ...
                         Stimulus(stim).PixelPositions.targetSegment2.x(frame), Stimulus(stim).PixelPositions.targetSegment2.y(frame));
            %Worm fatness is defined as the width/length of the worm. 
            Stimulus(stim).BodyMorphology.widthToLengthRatio(frame) = Stimulus(stim).BodyMorphology.widthAtTarget(frame)/Stimulus(stim).BodyMorphology.bodyLength(frame);
           
        end
        
         %Body Length Statistics:
        Stimulus(stim).BodyMorphology.averageBodyLength = mean(Stimulus(stim).BodyMorphology.bodyLength);
        Stimulus(stim).BodyMorphology.stdBodyLength = std(Stimulus(stim).BodyMorphology.bodyLength);
        %Body Width Statistics:
        Stimulus(stim).BodyMorphology.averageBodyWidth = mean(Stimulus(stim).BodyMorphology.widthAtTarget);
        Stimulus(stim).BodyMorphology.stdBodyWidth = std(Stimulus(stim).BodyMorphology.widthAtTarget);
       
        
    end
       
end