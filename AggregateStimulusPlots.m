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

interval = 0.001;
time = -0.2:interval:1;
prePoints = length(find(time<0));
count = 0;
sum = zeros(size(time));

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
        load(mat_file);
        TrackingData = getTrackingDataFromYAML(directory,experimentTitle);
        FPGAData = getFPGADataFromYAML(directory, experimentTitle);
        
        
        %Also need to extract the number of stimulus 
        if (ismember('NumberOfStimulus',fieldnames(TrackingData)))
            numStims = TrackingData.NumberOfStimulus;
        else
            numStims =  min(length(Stimulus), length(fieldnames(FPGAData)));
        end
        
        if (numStims>0)% && Stimulus(1).FPGAData.VoltagesSentToFPGA(1)>3)
            for stim = 1:numStims
                count = count + 1;
                startIndex = Stimulus(stim).StimulusTiming.stimOnFPGAIndex;
                endIndex = startIndex + length(time);
                stimulus = Stimulus(stim).FPGAData.PiezoSignal;
                biasValue = Stimulus(stim).StimulusTiming.stimulusAnalysis.preApproachPoints.average;

                stimulus = stimulus-biasValue;
                hold on
                plot(time,stimulus(startIndex-prePoints:endIndex-prePoints-1),'Color',[ 0 0.6 1],'LineWidth',1);
                sum = sum+stimulus(startIndex-prePoints:endIndex-prePoints-1);
            end
           
        else 
            disp(experimentTitle);
        end
    
    end

    
    
end
hold on
plot(time,sum./count,'Color',[ 0 0 0.75 ],'LineWidth',3)
xlabel('Time (s)','FontSize',16,'FontWeight','bold');
ylabel('Voltage (V)','FontSize',16,'FontWeight','bold');
title('Stimulus Profile','FontSize',20,'FontWeight','bold');
axis([min(time) max(time) -Inf Inf])
