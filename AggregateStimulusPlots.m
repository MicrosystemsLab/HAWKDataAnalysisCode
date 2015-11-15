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

Forces = [50 100 500 1000 5000 10000];
numForces = length(Forces);

interval = 0.001;
time = -0.1:interval:0.250;
prePoints = length(find(time<0));
count = zeros(numForces,1);
sum = zeros(numForces,length(time));


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
        StimulusData = getStimulusDataFromYAML(directory,experimentTitle);
        
         force = find(Forces == StimulusData.Magnitude,1);
        if isempty(force)
            break;
        end

        %Also need to extract the number of stimulus 
        if (ismember('NumberOfStimulus',fieldnames(TrackingData)))
            numStims = TrackingData.NumberOfStimulus;
        else
            numStims =  min(length(Stimulus), length(fieldnames(FPGAData)));
        end
        
        if (numStims>0)
            for stim = 1:numStims
                if (Stimulus(stim).TrialScoring.trialSuccess == 1)
                    count(force) = count(force) + 1;
                    startIndex = Stimulus(stim).StimulusTiming.stimOnFPGAIndex;
                    endIndex = startIndex + length(time);
                    stimulus = Stimulus(stim).FPGAData.PiezoSignal;
                    softBalanceValue = Stimulus(stim).StimulusTiming.stimulusAnalysis.preApproachPoints.average;

%                     stimulus = stimulus-biasValue;
                    
                    
                    cantileverSensitivity = TrackingData.CantileverProperties.Sensitivity;
                    if strcmp(TrackingData.CantileverProperties.SerialNumber,'EM10A1306')
                        cantileverSensitivity = 8.9781;
                    end
                    % Cantilever Stiffness = N/m
                    cantileverStiffness = TrackingData.CantileverProperties.Stiffness;
                    
                    %Cantilever deflection = sensitivity * piezo signal = um
                    cantileverDeflection = (Stimulus(stim).FPGAData.PiezoSignal-softBalanceValue) .* cantileverSensitivity;
                    cantileverForce = cantileverDeflection .* cantileverStiffness ./ 1e6; %um .* N/m * m/um = N
                    
                    
%                     figure(force)
                    subplot(3,2,force);
                    hold on
                    plot(time,cantileverForce(startIndex-prePoints:endIndex-prePoints-1).*1e9,'Color',[ 0 0.6 1],'LineWidth',1);
                    sum(force,:) = sum(force,:)+cantileverForce(startIndex-prePoints:endIndex-prePoints-1);
                end
            end
           
        else 
            disp(experimentTitle);
        end
    
    end

    
    
end
%%
for force = 1:numForces
%     figure(force)
    subplot(3,2,force);
    hold on
    plot(time,sum(force,:).*1e9./count(force),'Color',[ 0 0 0.75 ],'LineWidth',3)
    if force >4
     xlabel('Time (s)','FontSize',16,'FontWeight','bold');
    end
    if mod(force,2)
        ylabel('Force (nN)','FontSize',16,'FontWeight','bold');
    end
    axis([-0.1 .250 -10 Forces(force)*1.5])
    title(strcat( num2str(Forces(force)),' nN'),'FontSize',20,'FontWeight','bold');
    axis([min(time) max(time) -Inf Inf])
end
