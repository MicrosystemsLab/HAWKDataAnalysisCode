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


function [Stimulus, numStims] = extractBehaviorDataFromTracking(TrackingData)

    HAWKSystemConstants


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
                Stimulus(stimCount).numFrames = frameCountInsideStim;
                stimCount = stimCount+1;
                frameCountInsideStim = 1;
            end
            % Extract each of the following properties from the tracking
            % data:
            Stimulus(stimCount).ProcessedFrameNumber(frameCountInsideStim) = TrackingData.(['WormInfo' num2str(frameCount)]).ProcessedFrameNumber;
            Stimulus(stimCount).timeData(frameCountInsideStim,1:6) = datevec(TrackingData.(['WormInfo',num2str(frameCount)]).Time);
            Stimulus(stimCount).head.x(frameCountInsideStim) = TrackingData.(['WormInfo' num2str(frameCount)]).Head.x/PIXEL_SCALE;
            Stimulus(stimCount).head.y(frameCountInsideStim) = TrackingData.(['WormInfo' num2str(frameCount)]).Head.y/PIXEL_SCALE;
            Stimulus(stimCount).tail.x(frameCountInsideStim) = TrackingData.(['WormInfo' num2str(frameCount)]).Tail.x/PIXEL_SCALE;
            Stimulus(stimCount).tail.y(frameCountInsideStim) = TrackingData.(['WormInfo' num2str(frameCount)]).Tail.y/PIXEL_SCALE;
            Stimulus(stimCount).target.x(frameCountInsideStim) = TrackingData.(['WormInfo' num2str(frameCount)]).Target.x/PIXEL_SCALE;
            Stimulus(stimCount).target.y(frameCountInsideStim) = TrackingData.(['WormInfo' num2str(frameCount)]).Target.y/PIXEL_SCALE;
            Stimulus(stimCount).stageMovement.x(frameCountInsideStim) = TrackingData.(['WormInfo' num2str(frameCount)]).StageMovement.x0x2Daxis; 
            Stimulus(stimCount).stageMovement.y(frameCountInsideStim) = TrackingData.(['WormInfo' num2str(frameCount)]).StageMovement.y0x2Daxis; 
            Stimulus(stimCount).StimulusActivity(frameCountInsideStim) = TrackingData.(['WormInfo' num2str(frameCount)]).StimulusActive;
            Stimulus(stimCount).headTailToggle(frameCountInsideStim) = TrackingData.(['WormInfo' num2str(frameCount)]).Toggled;
            
            % Extract skeleton points:
            for skeletonParser = 0:length(fieldnames(TrackingData.(['WormInfo' num2str(frameCount)]).Skeleton))-1
               Stimulus(stimCount).Skeleton(frameCountInsideStim).x(skeletonParser+1) = TrackingData.(['WormInfo' num2str(frameCount)]).Skeleton.(['Point' num2str(skeletonParser)]).x/PIXEL_SCALE;
               Stimulus(stimCount).Skeleton(frameCountInsideStim).y(skeletonParser+1) = TrackingData.(['WormInfo' num2str(frameCount)]).Skeleton.(['Point' num2str(skeletonParser)]).y/PIXEL_SCALE;

            end
            %Find the mid-skeleton point
            Stimulus(stimCount).centroid.x(frameCountInsideStim) = Stimulus(stimCount).Skeleton(frameCountInsideStim).x(floor(length(Stimulus(stimCount).Skeleton(frameCountInsideStim).x)/2));
            Stimulus(stimCount).centroid.y(frameCountInsideStim) = Stimulus(stimCount).Skeleton(frameCountInsideStim).y(floor(length(Stimulus(stimCount).Skeleton(frameCountInsideStim).y)/2));
            %Also calculate body length based on skeleton length:
            Stimulus(stimCount).bodyLength(frameCountInsideStim) = calculateBodyLength(Stimulus(stimCount).Skeleton(frameCountInsideStim).x, Stimulus(stimCount).Skeleton(frameCountInsideStim).y)*UM_PER_PIXEL; 
            
            % Find worm body width if possible:
            if ismember('TargetSegment1',fieldnames(TrackingData.(['WormInfo',num2str(frameCount)])))
                Stimulus(stimCount).targetSegment1.x(frameCountInsideStim) = TrackingData.(['WormInfo',num2str(frameCount)]).TargetSegment1.x;
                Stimulus(stimCount).targetSegment1.y(frameCountInsideStim) = TrackingData.(['WormInfo',num2str(frameCount)]).TargetSegment1.y;
                Stimulus(stimCount).targetSegment2.x(frameCountInsideStim) = TrackingData.(['WormInfo',num2str(frameCount)]).TargetSegment2.x;
                Stimulus(stimCount).targetSegment2.y(frameCountInsideStim) = TrackingData.(['WormInfo',num2str(frameCount)]).TargetSegment2.y;
                %Width is distance between two segment points at target,
                %converted to um.
                Stimulus(stimCount).widthAtTarget(frameCountInsideStim) = UM_PER_PIXEL * distanceCalc(...
                     Stimulus(stimCount).targetSegment1.x(frameCountInsideStim), Stimulus(stimCount).targetSegment1.y(frameCountInsideStim), ...
                     Stimulus(stimCount).targetSegment2.x(frameCountInsideStim), Stimulus(stimCount).targetSegment2.y(frameCountInsideStim));
                %Worm fatness is defined as the width/length of the worm. 
                Stimulus(stimCount).fatness(frameCountInsideStim) = Stimulus(stimCount).widthAtTarget(frameCountInsideStim)/Stimulus(stimCount).bodyLength(frameCountInsideStim);
            end
            
            %Frame counters:
            frameCount = frameCount + 1;
            frameCountInsideStim = frameCountInsideStim + 1;
       end

    end
    frameCount = frameCount-1;
    
    % Determine the total number of stimulus to be analyzed:
    if (ismember('NumberOfStimulus',fieldnames(TrackingData)))
        numStims = TrackingData.NumberOfStimulus;
    else
        numStims =  length(Stimulus);
    end
  
    
    % calculate more timing data
    %clean up, calculate more timing data:
    for stim=1:numStims
        % seventh column of timing data is the seconds + minutes. 
        Stimulus(stim).timeData(:,7) =  Stimulus(stim).timeData(:,4).*60.*60+ Stimulus(stim).timeData(:,5).*60+ Stimulus(stim).timeData(:,6);
        % eighth column of timing data is the elapsed time from first frame in
        % seconds
         Stimulus(stim).timeData(:,8) =  Stimulus(stim).timeData(:,7) -  Stimulus(stim).timeData(1,7);
        %ninth column of timing data is the time since the last frame.
         Stimulus(stim).timeData(:,9) = [0; diff( Stimulus(stim).timeData(:,7))];
         timeDifference = Stimulus(stim).timeData(1,[1:6]) - datevec(TrackingData.ExperimentTime);
         Stimulus(stim).firstFrameTime = timeDifference(4)*60*60 + timeDifference(5)*60 + timeDifference(6);

    end
    % Extract beginning and end of stimulus based on frame data, also
    % calculate come body statistics.
    for stim=1:numStims
        ind = find(Stimulus(stim).StimulusActivity==1,1,'first');
        Stimulus(stim).stimAppliedTime = Stimulus(stim).timeData(ind,8);
        ind = find(diff(Stimulus(stim).StimulusActivity) == -1, 1, 'first');
        Stimulus(stim).stimEndTime = Stimulus(stim).timeData(ind,8);
        
        %Body Length Statistics:
        Stimulus(stim).averageBodyLength = mean(Stimulus(stim).bodyLength);
        Stimulus(stim).stdBodyLength = std(Stimulus(stim).bodyLength);
        %Body Width Statistics:
        if ismember('TargetSegment1',fieldnames(TrackingData.(['WormInfo',num2str(1)])))
            Stimulus(stim).averageBodyWidth = mean(Stimulus(stim).widthAtTarget);
            Stimulus(stim).stdBodyWidth = std(Stimulus(stim).widthAtTarget);
        end
       
    end


end