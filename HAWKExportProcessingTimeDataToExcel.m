clear all;
close all;
% Get Folder where all the files are:
clear all
if (ispc) %if on PC workstation in MERL 223
    DestinationFolder = 'C:\Users\HAWK\Documents\HAWKData';
    addpath(genpath('C:\Users\HAWK\Documents\HAWKDataAnalysisCode\YAMLMatlab_0.4.3'));
    excelFile = 'C:\Users\HAWK\Dropbox\HAWK\HAWKExperimentLog.xls';
    addpath('C:\Users\HAWK\Documents\HAWKDataAnalysisCode\20130227_xlwrite');s
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
%     DestinationFolder = '/Volumes/home/HAWK Data/Force Response Data/';
    DestinationFolder = '/Volumes/Backup Disc Celegans/HAWKData/';
    addpath(genpath('/Users/emazzochette/Documents/MicrosystemsResearch/HAWK/HAWKDataAnalysisCode/HAWKDataAnalysisCode/YAMLMatlab_0.4.3'));
%     excelFile = '/Users/emazzochette/Box Sync/HAWK/HAWKExperimentLog.xls';
    excelFile = '/Users/emazzochette/Documents/MicrosystemsResearch/HAWK/Experiments/Force Position Response Assay/DataDrop.xls';
    addpath('/Users/emazzochette/Documents/MicrosystemsResearch/HAWK/HAWKDataAnalysisCode/HAWKDataAnalysisCode/20130227_xlwrite');
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
   
    %Extract General Properties:
    % mat file name for the per stimulus data structure.
    mat_file = fullfile(directory,strcat(experimentTitle,'_ProcessingTimeData.mat'));
    %if the data has already been read from the .yaml file, just load the mat
    %file created last time:
    if (exist(mat_file, 'file')==2)
        load(mat_file);
%         TrackingData = getTrackingDataFromYAML(directory,experimentTitle);
        
        [NUM,TXT,RAW]=xlsread(excelFile,'Sheet1');
        [rowCount, columnCount] = size(RAW);
        experimentRow = rowCount+1;

        xlwrite(excelFile, {experimentTitle}, 'Sheet1', strcat('A',num2str(experimentRow)));

        try
            data = [TimingData.FindWorm.nCalls, TimingData.FindWorm.totalTime , TimingData.FindWorm.maxTime, TimingData.FindWorm.minTime, TimingData.FindWorm.avgTime,...
                TimingData.ImageAcqusition.nCalls, TimingData.ImageAcqusition.totalTime , TimingData.ImageAcqusition.maxTime, TimingData.ImageAcqusition.minTime, TimingData.ImageAcqusition.avgTime,...
                TimingData.MoveStage.nCalls, TimingData.MoveStage.totalTime , TimingData.MoveStage.maxTime, TimingData.MoveStage.minTime, TimingData.MoveStage.avgTime,...
                TimingData.SingleWormTrackLoop.nCalls, TimingData.SingleWormTrackLoop.totalTime , TimingData.SingleWormTrackLoop.maxTime, TimingData.SingleWormTrackLoop.minTime, TimingData.SingleWormTrackLoop.avgTime,...
                TimingData.WaitForStage.nCalls, TimingData.WaitForStage.totalTime , TimingData.WaitForStage.maxTime, TimingData.WaitForStage.minTime, TimingData.WaitForStage.avgTime,...
                TimingData.WholeWormTrackLoop.nCalls, TimingData.WholeWormTrackLoop.totalTime , TimingData.WholeWormTrackLoop.maxTime, TimingData.WholeWormTrackLoop.minTime, TimingData.WholeWormTrackLoop.avgTime,...
                TimingData.WriteToDisk.nCalls, TimingData.WriteToDisk.totalTime , TimingData.WriteToDisk.maxTime, TimingData.WriteToDisk.minTime, TimingData.WriteToDisk.avgTime];
            xlwrite(excelFile,data, 'Sheet1', strcat('B',num2str(experimentRow)));  
        end
    end
end
