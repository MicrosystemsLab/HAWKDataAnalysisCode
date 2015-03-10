%%%%% Function: Spatial Resolution Behavior Experiment:
%  This script is set up to semi-automate the calculation of the spatial
%  targeting resolution of HAWK.
%
%  param {directory} string, location on disk where experiment data is
%  located.
%  param {Stimulus} struct,  contains experiment data organized by
%  stimulus
%  param {TrackingData}
%  param {numStims} int, the number of stimulus in this experiment.
%  param {videoPresent} logical, binary flag to indicate if the video is
%  present
%
%  reutns {Stimulus} struct,  contains experiment data organized by
%  stimulus, includes resolution information determined by this function.
% 
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%%%%% 


function Stimulus = spatialResolutionBehaviorExperiment(directory, Stimulus, TrackingData, numStims, videoPresent)
    %Need information about camera pixel to um conversion:
    HAWKSystemConstants;


    %Need to determine where in space desired target is. In force clamp
    %experiments this is the user indicated cantilever location. In
    %behavior experiments, this is the center of the frame. Either way,
    %this location is printed to the Tracking Data as "Cantliever
    %Position".
    if (ismember('CantileverPosition',fieldnames(TrackingData.CantileverProperties)))
        x([1:numStims]) = TrackingData.CantileverProperties.CantileverPosition.x;
        y([1:numStims]) = TrackingData.CantileverProperties.CantileverPosition.y;
    %If this experiment was performed before the updated HAWK data to
    %include the cantilever position, use the available video to ask user 
    %to select where cantilever acutally contacted work by clicking on
    %frames.
    elseif (videoPresent == true) 
        % on the frame
        % import video
        obj = importVideoFile(directory) ;
        %For each stimulus, show frame to user, request 
        figure;
         for stim = 1:numStims
            %Read in frame, show to user asking input:
            frame = read(obj,testFrameVideo(stim));
            imshow(frame)
            [x(stim), y(stim)] = ginput(1);
            % Video frames are saved at half the resolution, convert to
            % original pixel values:
            x(stim) = x(stim)*2;
            y(stim) = y(stim)*2;
         end
    %If there is not video and this is still prior to HAWK update, save 
    %desired target values to be zero. 
    else
        x([1:numStims]) = 0;
        y([1:numStims]) = 0;
    end
    
    % Find frame  where the cantilever contacts the worm
 
    clear numFrames;
    for (stim = 1:numStims)
        
        %Need to figure out the video frame that corresponds to the first
        %frame in each stimulus. That corresponds to the "TrackingData"
        %frame.
        numFrames(stim) = length(Stimulus(stim).ProcessedFrameNumber);
        if (stim == 1)
            firstVideoFrameInStim = 1;
        else 
            firstVideoFrameInStim = runningSumNumFrames;
        end
        runningSumNumFrames = sum(numFrames);

        %Loop over all the frames in the stimulus:
        for frame = 1:length(Stimulus(stim).DuringStimFrames)
            %Select frame to analyze:
            testFrameStim = Stimulus(stim).DuringStimFrames(frame);
            skeleton(stim).points = Stimulus(stim).Skeleton(testFrameStim);
            testFrameVideo = testFrameStim + firstVideoFrameInStim;

            %If experiment was performed after HAWK software was updated to
            %include target location in stimulus, use that:
            if (ismember('target',fieldnames(Stimulus)))
               distance(frame) = distanceCalc(Stimulus(stim).PixelPositions.target.x(testFrameStim),Stimulus(stim).PixelPositions.target.y(testFrameStim), x(stim), y(stim));
            %Other was look in in TrackingData information. 
            else
                target_x = TrackingData.(['WormInfo' num2str(testFrameVideo)]).Target.x;
                target_y = TrackingData.(['WormInfo' num2str(testFrameVideo)]).Target.y;
                distance(frame) = distanceCalc(target_x, target_y,x(stim),y(stim));
            end
            %Convert distance to microns:
            distanceFromTargetUM(frame) = distance(frame)*UM_PER_PIXEL;
           

            % Find point on skeleton closest to contact points
            skeletonPoints = length(skeleton(stim).points.x);
            for point = 1:skeletonPoints
                minDistanceVector(point) = distanceCalc(skeleton(stim).points.x(point), skeleton(stim).points.y(point), x(stim),y(stim));
            end
            [minDistance, indDistance] = sort(minDistanceVector);
            closestTwoPoints(stim,:) = indDistance(1:2);
            %how far from skeleton?
            [x3, y3, distFromSkeleton(frame)] = pointClosestToSegment(skeleton(stim).points.x(closestTwoPoints(stim,1)), skeleton(stim).points.y(closestTwoPoints(stim,1)),...
                skeleton(stim).points.x(closestTwoPoints(stim,2)), skeleton(stim).points.y(closestTwoPoints(stim,2)), ...
                x(stim),y(stim));
            %closest to point to skeleton is how far down the body?
            percentDownSkeleton(frame) = findPercentDownBody(skeleton(stim).points, min(closestTwoPoints(stim,:)), x3 ,y3);
            %Find percentage of the body the distance from skeleton makes
            %up:
            percentAcrossBody(frame) = distFromSkeleton(frame)*UM_PER_PIXEL/(Stimulus(stim).widthAtTarget(testFrameStim));
            
            clear minDistanceVector;
            clear minDistance;
            clear indDistance;
        end
       
        
        %For each stimulus, stave the average statistics, check if they exist first:
        if (exist('distanceFromTargetUM'))
            Stimulus(stim).SpatialResolution.distanceFromTarget = mean(distanceFromTargetUM);
        else 
            Stimulus(stim).SpatialResolution.distanceFromTarget = 1000; %dummy number
        end
        
        if (exist('percentDownSkeleton'))
            Stimulus(stim).SpatialResolution.percentDownBodyHit = mean(percentDownSkeleton); 
        else
            Stimulus(stim).SpatialResolution.percentDownBodyHit = 1000;
        end
        
        if (exist('distFromSkeleton'))
            Stimulus(stim).SpatialResolution.distanceFromSkeleton = mean(distFromSkeleton)*UM_PER_PIXEL;
        else
            Stimulus(stim).SpatialResolution.distanceFromSkeleton = 1000;
        end
        
        if (exist('percentAcrossBody'))
            Stimulus(stim).SpatialResolution.percentAcrossBodyHit = mean(percentAcrossBody);
        else
            Stimulus(stim).SpatialResolution.percentAcrossBodyHit = 1000;
        end
        
        clear distanceFromTargetUM
        clear percentDownSkeleton
        clear distFromSkeleton
        clear percentAcrossBody
    end
    
   
end



