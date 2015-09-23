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
    mat_file = fullfile(directory,strcat(experimentTitle,'_DataByStimulus.mat'));
    %if the data has already been read from the .yaml file, just load the mat
    %file created last time:
    if (exist(mat_file, 'file')==2)

        %Extract tracking, FPGA, stimulus data from YAML files: 
        TrackingData = getTrackingDataFromYAML(directory,experimentTitle);
        FPGAData = getFPGADataFromYAML(directory, experimentTitle);
        StimulusData = getStimulusDataFromYAML(directory,experimentTitle);
        load(mat_file);
        
        try
            if TrackingData.NumberOfStimulus>0
            
            
                [NUM,TXT,RAW]=xlsread(excelFile,'Sheet1');
                [rowCount, columnCount] = size(RAW);
                experimentRow = rowCount+1;
                [experimentData, stimulusData ]= getDataForExcel(TrackingData, StimulusData, Stimulus,TrackingData.NumberOfStimulus, experimentTitle);
                for stim = 1:TrackingData.NumberOfStimulus
                    xlwrite(excelFile, experimentData, 'Sheet1', strcat('A',num2str(experimentRow+stim-1)));
                end
                xlwrite(excelFile, stimulusData, 'Sheet1', strcat('AB',num2str(experimentRow)));
            end
        catch
                disp(strcat('Error with: ',experimentTitle));
%                 fprintf(fileID,'%s\n',experimentTitle);
        end
    end
end