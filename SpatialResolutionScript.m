% This script is set up to semi-automate the calculation of the spatial
% targetting resolution of HAWK.

% Created by: Eileen Mazzochette
% Created: January 27, 2015


%% import data
clear all;
close all;
% Get Folder where all the files are:
clear all
if (ispc) %if on PC workstation in MERL 223
    DestinationFolder = 'C:\Users\HAWK\Documents\HAWKData';
    addpath(genpath('C:\Users\HAWK\Documents\HAWKDataAnalysisCode\YAMLMatlab_0.4.3'));
    excelFile = 'C:\Users\HAWK\Dropbox\HAWK\HAWKExperimentLog.xls';
    addpath('C:\Users\HAWK\Documents\HAWKDataAnalysisCode\20130227_xlwrite');
    slash = '\';
    % For excel writing, need these files linked:
    % Initialisation of POI Libs
    % Add Java POI Libs to matlab javapath
    javaaddpath('20130227_xlwrite\20130227_xlwrite\poi_library\poi-3.8-20120326.jar');
    javaaddpath('20130227_xlwrite\20130227_xlwrite\poi_library\poi-ooxml-3.8-20120326.jar');
    javaaddpath('20130227_xlwrite\20130227_xlwrite\poi_library\poi-ooxml-schemas-3.8-20120326.jar');
    javaaddpath('20130227_xlwrite\20130227_xlwrite\poi_library\xmlbeans-2.3.0.jar');
    javaaddpath('20130227_xlwrite\20130227_xlwrite\poi_library\dom4j-1.6.1.jar');
    javaaddpath('20130227_xlwrite\20130227_xlwrite\poi_library\stax-api-1.0.1.jar');
elseif (ismac) % if on Eileen's personal computer
    DestinationFolder = '/Volumes/home/HAWK Data/';
    addpath(genpath('/Users/emazzochette/Documents/MicrosystemsResearch/HAWK/HAWKDataAnalysisCode/HAWKDataAnalysisCode/YAMLMatlab_0.4.3'));
    excelFile = '/Users/emazzochette/Dropbox/HAWK/HAWKExperimentLog.xls';
    addpath('/Users/emazzochette/Documents/MicrosystemsResearch/HAWK/HAWKDataAnalysisCode/HAWKDataAnalysisCode/20130227_xlwrite');
    slash = '/';
    % For excel writing, need these files linked:
    % Initialisation of POI Libs
    % Add Java POI Libs to matlab javapath
    javaaddpath('20130227_xlwrite/20130227_xlwrite/poi_library/poi-3.8-20120326.jar');
    javaaddpath('20130227_xlwrite/20130227_xlwrite/poi_library/poi-ooxml-3.8-20120326.jar');
    javaaddpath('20130227_xlwrite/20130227_xlwrite/poi_library/poi-ooxml-schemas-3.8-20120326.jar');
    javaaddpath('20130227_xlwrite/20130227_xlwrite/poi_library/xmlbeans-2.3.0.jar');
    javaaddpath('20130227_xlwrite/20130227_xlwrite/poi_library/dom4j-1.6.1.jar');
    javaaddpath('20130227_xlwrite/20130227_xlwrite/poi_library/stax-api-1.0.1.jar');
end

%asks user for the directory where all the files are:
directory = uigetdir(DestinationFolder,'Choose the folder where the data if located');

%determine experiment title based on file name:
for index = length(directory):-1:1
    if (directory(index) == slash)
        startTitleIndex = index+1;
        break;
    end
end
experimentTitle = directory(startTitleIndex:length(directory));

%extracts file name
load(fullfile(directory,strcat(experimentTitle,'_DataByStimulus.mat')));
load(fullfile(directory,strcat(experimentTitle,'_tracking_parsedData.mat')));
%% import video

obj = VideoReader(fullfile(directory,strcat(experimentTitle,'_video.avi')));

%% find frame in video where the cantilever contacts the worm
stim = 1;
clear numFrames;
for (stim = 1:length(Stimulus))
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
    testFrame(stim) = Stimulus(stim).DuringStimFrames(numberOfApproachFrames);
    skeleton(stim).points = Stimulus(stim).Skeleton(testFrame(stim));
    testFrame(stim) = testFrame(stim) + firstFrame;
    
end

%% ask user to select where cantilever acutally contacted work by clicking
% on the frame
figure(1);
 for stim = 1:length(Stimulus)
    frame = read(obj,testFrame(stim));
    imshow(frame)
    [x(stim), y(stim)] = ginput(1);
 end

%% find distance between target and contact location
PIXEL_PER_UM = 0.567369167;
UM_PER_PIXEL = 1/PIXEL_PER_UM;
for stim = 1:length(Stimulus)
    if (ismember('target',fieldnames(Stimulus)))
       distance(stim) = distanceCalc(Stimulus(stim).target.x,Stimulus(stim).target.y, x(stim)*2, y(stim)*2);
    else
        target_x = TrackingData.(['WormInfo' num2str(testFrame(stim))]).Target.x;
        target_y = TrackingData.(['WormInfo' num2str(testFrame(stim))]).Target.y;
        distance(stim) = distanceCalc(target_x, target_y,x(stim)*2,y(stim)*2);
        distanceUM(stim) = distance(stim)*UM_PER_PIXEL;
    end
end

%% Find point on skeleton closest to contact points
for stim = 1:length(Stimulus)
    skeletonPoints = length(skeleton(stim).points.x);
    for point = 1:skeletonPoints
        minDistanceVector(point) = distanceCalc(skeleton(stim).points.x(point), skeleton(stim).points.y(point), x(stim)*2,y(stim)*2);
    end
    [minDistance(stim), indDistace(stim)] = min(minDistanceVector);

end
 
%how far from skeleton?
%closest to point to skeleton is how far down the body?

%% record information to excel spreadsheet



