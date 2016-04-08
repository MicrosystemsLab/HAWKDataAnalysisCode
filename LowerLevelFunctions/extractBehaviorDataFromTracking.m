%%%% Function: Extract Behavior Data From Tracking
%  Sorts Tracking data by stimulus application for analysis
% 
%  param {TrackingData} struct, contains all the tracking information from
%  the YAML file
%  
%  returns {Stimulus} struct,  contains experiment data organized by
%  stimulus, modifyed to include the sorted frames.
%  returns {numStims} int, the number of stimulus in this experiment.
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%
%%%%%


function [Stimulus, numStims, TrackingData] = extractBehaviorDataFromTracking(TrackingData)

    HAWKSystemConstants;

    fields = fieldnames(TrackingData);
    k = strfind(fields,'WormInfo');

    frameCount = 1;
    frameCountInsideStim = 1;
    stimCount = 1;
    for fieldsParser = 1:length(fields)

       if  k{fieldsParser} == 1;
           %Check if you've moved onto the next Stimulus yet by comparing
           %the stimulus count number from the last one. If if it a new
           %one, advanced counter and move to next Stimulus.
            if stimCount ~= TrackingData.(['WormInfo',num2str(frameCount)]).StimulusNumber
                Stimulus(stimCount).numFrames = frameCountInsideStim-1;
                stimCount = stimCount+1;
                frameCountInsideStim = 1;
            end
            % Extract each of the following properties from the tracking
            % data:
            Stimulus(stimCount).ProcessedFrameNumber(frameCountInsideStim) = TrackingData.(['WormInfo' num2str(frameCount)]).ProcessedFrameNumber;
            Stimulus(stimCount).timeData(frameCountInsideStim,1:6) = datevec(TrackingData.(['WormInfo',num2str(frameCount)]).Time);
            Stimulus(stimCount).PixelPositions.head.x(frameCountInsideStim) = TrackingData.(['WormInfo' num2str(frameCount)]).Head.x/PIXEL_SCALE;
            Stimulus(stimCount).PixelPositions.head.y(frameCountInsideStim) = TrackingData.(['WormInfo' num2str(frameCount)]).Head.y/PIXEL_SCALE;
            Stimulus(stimCount).PixelPositions.tail.x(frameCountInsideStim) = TrackingData.(['WormInfo' num2str(frameCount)]).Tail.x/PIXEL_SCALE;
            Stimulus(stimCount).PixelPositions.tail.y(frameCountInsideStim) = TrackingData.(['WormInfo' num2str(frameCount)]).Tail.y/PIXEL_SCALE;
            Stimulus(stimCount).PixelPositions.target.x(frameCountInsideStim) = TrackingData.(['WormInfo' num2str(frameCount)]).Target.x/PIXEL_SCALE;
            Stimulus(stimCount).PixelPositions.target.y(frameCountInsideStim) = TrackingData.(['WormInfo' num2str(frameCount)]).Target.y/PIXEL_SCALE;
            Stimulus(stimCount).stageMovement.x(frameCountInsideStim) = TrackingData.(['WormInfo' num2str(frameCount)]).StageMovement.x0x2Daxis; 
            Stimulus(stimCount).stageMovement.y(frameCountInsideStim) = TrackingData.(['WormInfo' num2str(frameCount)]).StageMovement.y0x2Daxis; 
            Stimulus(stimCount).StimulusActivity(frameCountInsideStim) = TrackingData.(['WormInfo' num2str(frameCount)]).StimulusActive;
            Stimulus(stimCount).headTailToggle(frameCountInsideStim) = TrackingData.(['WormInfo' num2str(frameCount)]).Toggled;
            
            if ismember('TargetSegment1',fieldnames(TrackingData.(['WormInfo',num2str(frameCount)])))
                Stimulus(stimCount).PixelPositions.targetSegment1.x(frameCountInsideStim) = TrackingData.(['WormInfo',num2str(frameCount)]).TargetSegment1.x;
                Stimulus(stimCount).PixelPositions.targetSegment1.y(frameCountInsideStim) = TrackingData.(['WormInfo',num2str(frameCount)]).TargetSegment1.y;
                Stimulus(stimCount).PixelPositions.targetSegment2.x(frameCountInsideStim) = TrackingData.(['WormInfo',num2str(frameCount)]).TargetSegment2.x;
                Stimulus(stimCount).PixelPositions.targetSegment2.y(frameCountInsideStim) = TrackingData.(['WormInfo',num2str(frameCount)]).TargetSegment2.y;
            end
            
            % Extract skeleton points:
            for skeletonParser = 0:length(fieldnames(TrackingData.(['WormInfo' num2str(frameCount)]).Skeleton))-1
               Stimulus(stimCount).Skeleton(frameCountInsideStim).x(skeletonParser+1) = TrackingData.(['WormInfo' num2str(frameCount)]).Skeleton.(['Point' num2str(skeletonParser)]).x/PIXEL_SCALE;
               Stimulus(stimCount).Skeleton(frameCountInsideStim).y(skeletonParser+1) = TrackingData.(['WormInfo' num2str(frameCount)]).Skeleton.(['Point' num2str(skeletonParser)]).y/PIXEL_SCALE;

            end
                      
            %Frame counters:
            frameCount = frameCount + 1;
            frameCountInsideStim = frameCountInsideStim + 1;
       end
        
    end
    % need to catch the frame count for the last stimulus 
    Stimulus(stimCount).numFrames = frameCountInsideStim-1;
    
    % Determine the total number of stimulus to be analyzed:
    if (ismember('NumberOfStimulus',fieldnames(TrackingData)))
        numStims = TrackingData.NumberOfStimulus;
    else
        numStims =  length(Stimulus)-1;
        TrackingData.NumberOfStimulus = numStims;
    end
  
    
 end