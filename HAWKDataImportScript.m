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
    try
    %Extract tracking, FPGA, stimulus data from YAML files: 
    TrackingData = getTrackingDataFromYAML(directory,experimentTitle);
    %Only need FPGA data if not in behavior mode
    if ( ~strcmp(TrackingData.ExperimentMode, 'Behavior Mode'))
          FPGAData = getFPGADataFromYAML(directory, experimentTitle);
    end
    % Extract Stimulus Data from the yaml file:
    StimulusData = getStimulusDataFromYAML(directory,experimentTitle);
    %Start sorting by stimulus now to help later.
    mat_file = fullfile(directory,strcat(experimentTitle,'_DataByStimulus.mat'));
    %Extract behavior information from Tracking Data
    [Stimulus, numStims] = extractBehaviorDataFromTracking(TrackingData);
    %Extract stimulus data from FPGA and Stimulus files:
    if ( ~strcmp(TrackingData.ExperimentMode, 'Behavior Mode'))    
        Stimulus = extractFPGADataFromFPGAData(FPGAData, StimulusData, Stimulus, numStims);
    end
    %Save stimulus to mat file
    save(mat_file, 'Stimulus');
    catch
       disp(strcat('Experiment read error: ', experimentTitle));
    end
end