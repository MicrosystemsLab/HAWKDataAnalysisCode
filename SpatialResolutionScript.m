% This script is set up to semi-automate the calculation of the spatial
% targetting resolution of HAWK.

% Created by: Eileen Mazzochette
% Created: January 27, 2015


%% import data
% clear all;
% close all;
% % Get Folder where all the files are:
% clear all
% if (ispc) %if on PC workstation in MERL 223
%     DestinationFolder = 'C:\Users\HAWK\Documents\HAWKData';
%     addpath(genpath('C:\Users\HAWK\Documents\HAWKDataAnalysisCode\YAMLMatlab_0.4.3'));
%     excelFile = 'C:\Users\HAWK\Dropbox\HAWK\HAWKExperimentLog.xls';
%     addpath('C:\Users\HAWK\Documents\HAWKDataAnalysisCode\20130227_xlwrite');
%     slash = '\';
%     % For excel writing, need these files linked:
%     % Initialisation of POI Libs
%     % Add Java POI Libs to matlab javapath
%     javaaddpath('20130227_xlwrite\20130227_xlwrite\poi_library\poi-3.8-20120326.jar');
%     javaaddpath('20130227_xlwrite\20130227_xlwrite\poi_library\poi-ooxml-3.8-20120326.jar');
%     javaaddpath('20130227_xlwrite\20130227_xlwrite\poi_library\poi-ooxml-schemas-3.8-20120326.jar');
%     javaaddpath('20130227_xlwrite\20130227_xlwrite\poi_library\xmlbeans-2.3.0.jar');
%     javaaddpath('20130227_xlwrite\20130227_xlwrite\poi_library\dom4j-1.6.1.jar');
%     javaaddpath('20130227_xlwrite\20130227_xlwrite\poi_library\stax-api-1.0.1.jar');
% elseif (ismac) % if on Eileen's personal computer
%     DestinationFolder = '/Volumes/home/HAWK Data/';
%     addpath(genpath('/Users/emazzochette/Documents/MicrosystemsResearch/HAWK/HAWKDataAnalysisCode/HAWKDataAnalysisCode/YAMLMatlab_0.4.3'));
%     excelFile = '/Users/emazzochette/Dropbox/HAWK/HAWKExperimentLog.xls';
%     addpath('/Users/emazzochette/Documents/MicrosystemsResearch/HAWK/HAWKDataAnalysisCode/HAWKDataAnalysisCode/20130227_xlwrite');
%     slash = '/';
%     % For excel writing, need these files linked:
%     % Initialisation of POI Libs
%     % Add Java POI Libs to matlab javapath
%     javaaddpath('20130227_xlwrite/20130227_xlwrite/poi_library/poi-3.8-20120326.jar');
%     javaaddpath('20130227_xlwrite/20130227_xlwrite/poi_library/poi-ooxml-3.8-20120326.jar');
%     javaaddpath('20130227_xlwrite/20130227_xlwrite/poi_library/poi-ooxml-schemas-3.8-20120326.jar');
%     javaaddpath('20130227_xlwrite/20130227_xlwrite/poi_library/xmlbeans-2.3.0.jar');
%     javaaddpath('20130227_xlwrite/20130227_xlwrite/poi_library/dom4j-1.6.1.jar');
%     javaaddpath('20130227_xlwrite/20130227_xlwrite/poi_library/stax-api-1.0.1.jar');
% end
% 
% %asks user for the directory where all the files are:
% directory = uigetdir(DestinationFolder,'Choose the folder where the data if located');

function spatialResolutionData = SpatialResolutionScript(directory, Stimulus, TrackingData, numStims)

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

    %extracts file name
%     load(fullfile(directory,strcat(experimentTitle,'_DataByStimulus.mat')));
%     load(fullfile(directory,strcat(experimentTitle,'_tracking_parsedData.mat')));
    
    % import video
        obj = VideoReader(fullfile(directory,strcat(experimentTitle,'_video.avi')));

        % find frame in video where the cantilever contacts the worm
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
            testFrameStim(stim) = Stimulus(stim).DuringStimFrames(numberOfApproachFrames);
            skeleton(stim).points = Stimulus(stim).Skeleton(testFrameStim(stim));
            testFrameVideo(stim) = testFrameStim(stim) + firstFrame;

        end

       
    if (TrackingData.CantileverProperties.CantileverPosition.x>0)
        x([1:numStims]) = TrackingData.CantileverProperties.CantileverPosition.x;
        y([1:numStims]) = TrackingData.CantileverProperties.CantileverPosition.y;
    else % ask user to select where cantilever acutally contacted work by clicking
        % on the frame
        figure;
         for stim = 1:numStims
            frame = read(obj,testFrameVideo(stim));
            imshow(frame)
            [x(stim), y(stim)] = ginput(1);
            x(stim) = x(stim)*2;
            y(stim) = y(stim)*2;
         end
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

    
    % returns: distance from target, percent along body it was closest to,
    % shortest distance from the skeleton 
    spatialResolutionData = [distanceUM' percent' dist'.*UM_PER_PIXEL];
end
%% record information to excel spreadsheet



