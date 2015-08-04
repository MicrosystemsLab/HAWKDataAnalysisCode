

% Aggregate velocity responses (reversals)

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
Forces2 = [50 100 550 1100 5500 11000];
Targets = [25 35 45];
classes = [1 2 3 4 5 6; 7 8 9 10 11 12; 13 14 15 16 17 18];
classCount = zeros(size(classes));
percentChangeClass = zeros(size(classes));

for dir = 1:length(directories)
      %Select next directory:
    directoryCell = directories(:,dir);
    directory = directoryCell{1};
    
   
    %determine experiment title based on file name:
    experimentTitle = getExperimentTitle(directory);
      
    % mat file name for the per stimulus data structure.
    mat_file = fullfile(directory,strcat(experimentTitle,'_DataByStimulus.mat'));
   
    %Check that the mat file exists:
    if (exist(mat_file, 'file')==2)
        load(mat_file);
        TrackingData = getTrackingDataFromYAML(directory,experimentTitle);
        FPGAData = getFPGADataFromYAML(directory, experimentTitle);
        StimulusData = getStimulusDataFromYAML(directory,experimentTitle);
        numStims = TrackingData.NumberOfStimulus;
        for stim = 1:numStims
            if (Stimulus(stim).TrialScoring.trialSuccess ==1  && strcmp(Stimulus(stim).Response.Type, 'reversal')==1) 
                    
                target = find(Targets == TrackingData.TargetLocation,1);
                force = find(Forces == StimulusData.Magnitude,1);

                time = Stimulus(stim).timeData(:,8)-Stimulus(stim).StimulusTiming.stimAppliedTime;
                frames = (find(time>-1.5,1):find(time>5,1));
                speed = Stimulus(stim).CurvatureAnalysis.velocitySmoothed(frames);
                timePlot = time(frames);

                percentChangeClass(target,force) = percentChangeClass(target,force) + (abs(Stimulus(stim).Response.postStimSpeed4) - abs(Stimulus(stim).Response.preStimSpeed))/abs(Stimulus(stim).Response.preStimSpeed);

                classCount(target,force) = classCount(target,force) + 1;
                subplot(3,6,classes(target,force))
                plot(timePlot,speed,'LineWidth',2);
                hold on
            end
            
        end
    end
end

percentChangeAverage = percentChangeClass./classCount;
%%


for force = 1:6
    for target = 1:3
       
    
        subplot(3,6,classes(target,force))
        axis([-2 6 -600 600])
        set(gca, 'FontSize',16)
        if classes(target,force)<=6
            title(strcat('Force Applied: ',num2str(Forces2(force)), ' nN'),'FontSize', 16);
        end
        if classes(target,force)>12
          xlabel('Time (s)','FontSize', 14);
        else 
%             set(gca,'xtick',[])
            set(gca,'xticklabel',[])
        end
        if classes(target,force) == 1
            ylabel('Velocity @ 25% Target (um/s)', 'FontSize',14)
        elseif classes(target,force) == 7
            ylabel('Velocity @ 35% Target (um/s)', 'FontSize',14)
        elseif classes(target,force) == 13
            ylabel('Velocity @ 45% Target (um/s)', 'FontSize',14)
        else
%             set(gca,'ytick',[])
            set(gca,'yticklabel',[])
        end
        
%         text(0.5,-400,strcat('Ave % Change = ', num2str( percentChangeClass(target,force)*100)),'FontSize',14); 
%         text(0.5,-500,strcat('n Reversals = ', num2str( classCount(target,force)*100)),'FontSize',14); 
    end
end