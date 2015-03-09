% This script is set up to semi-automate the calculation of the spatial
% targeting resolution of HAWK.

% Created by: Eileen Mazzochette
% Created: January 27, 2015


function Stimulus = SpatialResolutionScript(directory, Stimulus, TrackingData, numStims, videoPresent)

    if (ispc) %if on PC workstation in MERL 223
        slash = '\';
    elseif (ismac) % if on Eileen's personal computer
        slash = '/';
    end
    %determine experiment title based on file name:
    for index = length(directory):-1:1
        if (directory(index) == slash)
            startTitleIndex = index+1;
            break;
        end
    end
    experimentTitle = directory(startTitleIndex:length(directory));
    % find frame  where the cantilever contacts the worm
    stim = 1;
    clear numFrames;
    for (stim = 1:numStims)
        numFrames(stim) = length(Stimulus(stim).ProcessedFrameNumber);

        if (stim == 1)
            firstFrame = 1;
        else 
            firstFrame = runningSumNumFrames;
        end

        runningSumNumFrames = sum(numFrames);

        approachDuration = Stimulus(stim).stimOnStartTime - Stimulus(stim).approachStartTime;
        frameProcessingTime = mean(Stimulus(stim).timeData(:,9));
        numberOfApproachFrames = ceil(approachDuration/frameProcessingTime);
        if(numberOfApproachFrames <= length(Stimulus(stim).DuringStimFrames))
            testFrameStim(stim) = Stimulus(stim).DuringStimFrames(numberOfApproachFrames);
            
        else
             testFrameStim(stim) = Stimulus(stim).DuringStimFrames(1);
        end
        skeleton(stim).points = Stimulus(stim).Skeleton(testFrameStim(stim));
        testFrameVideo(stim) = testFrameStim(stim) + firstFrame;

    end

       
   
      
    if (ismember('CantileverPosition',fieldnames(TrackingData.CantileverProperties)))
        x([1:numStims]) = TrackingData.CantileverProperties.CantileverPosition.x;
        y([1:numStims]) = TrackingData.CantileverProperties.CantileverPosition.y;
    elseif (videoPresent == true) % ask user to select where cantilever acutally contacted work by clicking
        % on the frame
        % import video
        obj = VideoReader(fullfile(directory,strcat(experimentTitle,'_video.avi')));
        figure;
         for stim = 1:numStims
            frame = read(obj,testFrameVideo(stim));
            imshow(frame)
            [x(stim), y(stim)] = ginput(1);
            x(stim) = x(stim)*2;
            y(stim) = y(stim)*2;
         end
    else
        x([1:numStims]) = 0;
        y([1:numStims]) = 0;
    end

    % find distance between target and contact location
    PIXEL_PER_UM = 0.567369167;
    UM_PER_PIXEL = 1/PIXEL_PER_UM;
    for stim = 1:numStims
        if (ismember('target',fieldnames(Stimulus)))
           distance(stim) = distanceCalc(Stimulus(stim).target.x(testFrameStim(stim)),Stimulus(stim).target.y(testFrameStim(stim)), x(stim), y(stim));
        else
            target_x = TrackingData.(['WormInfo' num2str(testFrameVideo(stim))]).Target.x;
            target_y = TrackingData.(['WormInfo' num2str(testFrameVideo(stim))]).Target.y;
            distance(stim) = distanceCalc(target_x, target_y,x(stim),y(stim));
            
        end
        distanceUM(stim) = distance(stim)*UM_PER_PIXEL;
    %end

     % Find point on skeleton closest to contact points
    %for stim = 1:length(Stimulus)
        skeletonPoints = length(skeleton(stim).points.x);
        for point = 1:skeletonPoints
            minDistanceVector(point) = distanceCalc(skeleton(stim).points.x(point), skeleton(stim).points.y(point), x(stim),y(stim));
        end
        [minDistance, indDistance] = sort(minDistanceVector);
        closestTwoPoints(stim,:) = indDistance(1:2);
        %how far from skeleton?
        [x3(stim), y3(stim), dist(stim)] = pointClosestToSegment(skeleton(stim).points.x(closestTwoPoints(stim,1)), skeleton(stim).points.y(closestTwoPoints(stim,1)),...
            skeleton(stim).points.x(closestTwoPoints(stim,2)), skeleton(stim).points.y(closestTwoPoints(stim,2)), ...
            x(stim),y(stim));
        %closest to point to skeleton is how far down the body?
        percent(stim) = findPercentDownBody(skeleton(stim).points, min(closestTwoPoints(stim,:)), x3(stim) ,y3(stim));
        
        clear minDistanceVector;
        clear minDistance;
        clear indDistance;
    end

    for stim = 1:numStims
    Stimulus(stim).distanceFromTarget = distanceUM(stim); % spatialResolutionData(stim,1);
    Stimulus(stim).percentDownBodyHit = percent(stim); %spatialResolutionData(stim,2);
    Stimulus(stim).distanceFromSketelon = dist(stim)*UM_PER_PIXEL;%spatialResolutionData(stim,3);
    end
    
    % returns: distance from target, percent along body it was closest to,
    % shortest distance from the skeleton 
   % spatialResolutionData = [distanceUM' percent' dist'.*UM_PER_PIXEL];
end
%% record information to excel spreadsheet



