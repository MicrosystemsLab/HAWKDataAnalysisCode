%%%% Script: Perform the conversion of yaml data to mat data files in bulk
%  Prompts user for a selection of folders containing data from HAWK. It
%  then serially evaluates each folder, converting the yaml files into
%  useable mat files for Matlab.
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%
%%%%%
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
    DestinationFolder = '/Volumes/Backup Disc Celegans/HAWKData/';
    addpath(genpath('/Users/emazzochette/Documents/MicrosystemsResearch/HAWK/HAWKDataAnalysisCode/HAWKDataAnalysisCode/YAMLMatlab_0.4.3'));
    excelFile = '/Users/emazzochette/Box Sync/HAWK/HAWKExperimentLog.xls';
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
%directory = uigetdir(DestinationFolder,'Choose the folder where the data if located');
directories = uipickfiles( 'FilterSpec',DestinationFolder);
fileID = fopen('/Users/emazzochette/Documents/MicrosystemsResearch/HAWK/Experiments/ErrorList.txt','a');
dealWithOldData = true;

for dir = 1:length(directories)
    %Select next directory:
    directoryCell = directories(:,dir);
    directory = directoryCell{1};
    
    %determine experiment title based on file name:
    experimentTitle = getExperimentTitle(directory);
    
    %Save Stimulus file:
    mat_file = fullfile(directory,strcat(experimentTitle,'_DataByStimulus.mat'));
    if (exist(mat_file, 'file')==2)
        try
            TrackingData = getTrackingDataFromYAML(directory,experimentTitle);
            FPGAData = getFPGADataFromYAML(directory, experimentTitle);
            StimulusData = getStimulusDataFromYAML(directory,experimentTitle);
            if TrackingData.NumberOfStimulus > 0
                load(mat_file);
                disp(strcat('Starting file: ',directory)); 
                %Deal with old analysis:
                if dealWithOldData == 1
%                     moveOldData(directory,TrackingData.NumberOfStimulus);
%                     try  Stimulus = rmfield(Stimulus, 'StimulusTiming'); end 
                    try  Stimulus = rmfield(Stimulus, 'BodyMorphology'); end
                    try  Stimulus = rmfield(Stimulus, 'FramesByStimulus'); end
                    try  Stimulus = rmfield(Stimulus, 'computerScoredBadFrames'); end
                    try  Stimulus = rmfield(Stimulus, 'Trajectory'); end
                    try  Stimulus = rmfield(Stimulus, 'SpatialResolution'); end
                    try  Stimulus = rmfield(Stimulus, 'TrialScoring'); end
                    try  Stimulus = rmfield(Stimulus, 'CurvatureAnalysis'); end
                    try  Stimulus = rmfield(Stimulus, 'FrameScoring'); end
                    try  Stimulus = rmfield(Stimulus, 'AppliedStimulus'); end
                    try  Stimulus = rmfield(Stimulus, 'Response'); end
                end
                
%                 Stimulus = determineStimulusTiming(TrackingData, StimulusData, Stimulus, TrackingData.NumberOfStimulus);


                Stimulus = calculateBodyMorphology(Stimulus,TrackingData.NumberOfStimulus);
                Stimulus = filterFramesByBodyLength(Stimulus,TrackingData.NumberOfStimulus);
                Stimulus = calculateWormCentroidMean(Stimulus,TrackingData.NumberOfStimulus);
               
                Stimulus = calculateSmoothFitSkeleton(Stimulus, TrackingData.NumberOfStimulus);
%                 try  Stimulus = rmfield(Stimulus, 'BodyMorpholoy'); end
               
                
                Stimulus = sortFramesBasedOnStimulus(Stimulus, TrackingData.NumberOfStimulus);
                
                Stimulus = findCurvature(Stimulus, TrackingData.NumberOfStimulus);
                Stimulus = scoreFrames(Stimulus, TrackingData.NumberOfStimulus);
% %  
%                 Stimulus = getWormIndentation(Stimulus, TrackingData, StimulusData, TrackingData.NumberOfStimulus);
%  
                Stimulus = determineWormTrajectory(Stimulus, TrackingData.NumberOfStimulus);
% % %                 createSkeletonRotationGIF(Stimulus, TrackingData.NumberOfStimulus, directory)
% %  
                videoPresent = true;
                Stimulus = spatialResolutionForceClamp(directory, Stimulus, TrackingData, TrackingData.NumberOfStimulus, videoPresent);
% % % 
                Stimulus = scoreTrials(TrackingData,Stimulus,TrackingData.NumberOfStimulus);
% %  
                Stimulus = getVelocityFromCurvature(Stimulus, TrackingData.NumberOfStimulus);
%                 Stimulus = calculateCurvatureParameters(Stimulus,TrackingData.NumberOfStimulus);
% 
                Stimulus = scoreBehaviorResponse(Stimulus, TrackingData.NumberOfStimulus);
% % 
                plotData(Stimulus, TrackingData, TrackingData.NumberOfStimulus, directory)
%                 [NUM,TXT,RAW]=xlsread(excelFile,'ForceTouchAssay DataSet 3');
%                 [rowCount, columnCount] = size(RAW);
%                 experimentRow = rowCount+1;
%                 [experimentData, stimulusData ]= getDataForExcel(TrackingData, StimulusData, Stimulus,TrackingData.NumberOfStimulus, experimentTitle);
%                 for stim = 1:TrackingData.NumberOfStimulus
%                     xlwrite(excelFile, experimentData, 'ForceTouchAssay DataSet 3', strcat('A',num2str(experimentRow+stim-1)));
%                 end
%                 xlwrite(excelFile, stimulusData, 'ForceTouchAssay DataSet 3', strcat('AA',num2str(experimentRow)));


                save(mat_file, 'Stimulus');
                close all;
            end
        catch
            disp(strcat('Error with: ',experimentTitle));
            fprintf(fileID,'%s\n',experimentTitle);
        end
    end
end
fclose(fileID);
   