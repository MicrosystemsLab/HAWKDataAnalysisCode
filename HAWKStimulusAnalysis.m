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
%directory = uigetdir(DestinationFolder,'Choose the folder where the data if located');
directories = uipickfiles( 'FilterSpec',DestinationFolder);

for dir = 1:length(directories)
    %Select next directory:
    directoryCell = directories(:,dir);
    directory = directoryCell{1};
    
    %determine experiment title based on file name:
    experimentTitle = getExperimentTitle(directory);
    
    TrackingData = getTrackingDataFromYAML(directory,experimentTitle);
    FPGAData = getFPGADataFromYAML(directory, experimentTitle);
    StimulusData = getStimulusDataFromYAML(directory,experimentTitle);
    
    %Organize data by Stimulus, both behavior and FPGA data:
    [Stimulus, numStims, TrackingData] = extractBehaviorDataFromTracking(TrackingData);
    Stimulus = extractFPGADataFromFPGAData(FPGAData, StimulusData, Stimulus, TrackingData.NumberOfStimulus);
    
    if TrackingData.NumberOfStimulus > 0
        Stimulus = getTimingData(Stimulus,TrackingData.NumberOfStimulus, TrackingData);
        Stimulus = determineStimulusTiming(TrackingData, StimulusData, Stimulus, TrackingData.NumberOfStimulus);

        %Go through stimulus manually and swap head/tail misses:
        Stimulus = manualHeadTailSwapID(Stimulus,numStims, directory);

        %Save Stimulus file:
        mat_file = fullfile(directory,strcat(experimentTitle,'_DataByStimulus.mat'));
        save(mat_file, 'Stimulus');
    end
end
   