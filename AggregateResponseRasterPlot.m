
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
for i = 1:length(directories)
    directory = directories{i};
    location(i) = str2num(directory(end-1:end));
    [values indices] = sort(location,'ascend');
end


% stim = 1;
% numStims = 6;
stimCount = 0;

currentTarget = values(1);

for dir = 1:length(directories)
      %Select next directory:
    directoryCell = directories(:,indices(dir));
    directory = directoryCell{1};
    
    previousTarget = currentTarget;
    currentTarget = values(dir);
    if previousTarget~=currentTarget
        stimCount = stimCount + 1;
        plot([min(time) max(time)],[stimCount-0.5 stimCount-0.5],'LineWidth',3,'Color','black');
    end
    %determine experiment title based on file name:
    experimentTitle = getExperimentTitle(directory);
      
    % mat file name for the per stimulus data structure.
    mat_file = fullfile(directory,strcat(experimentTitle,'_DataByStimulus.mat'));
  
    %Check that the mat file exists:
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

        if (numStims>0)
            for stim = 1:numStims
%                 if length(Stimulus(stim).computerScoredBadFrames)>0.33*Stimulus(stim).numFrames
%                     break;
%                 end
                speed = Stimulus(stim).CurvatureAnalysis.velocity;
                speed_smoothed = lowpass1D(speed,2);
                maxSpeed = max(abs(speed_smoothed));
                aveSpeed = abs(Stimulus(stim).Response.preStimSpeed);
                if isnan(aveSpeed)
                    break
                end
                direction_smoothed = sign(speed_smoothed);

                time = Stimulus(stim).timeData(:,8)-Stimulus(stim).StimulusTiming.stimOnStartTime;

                forward = sign(Stimulus(stim).Response.preStimSpeed);

                for frame = 1:length(speed_smoothed)
                   if ~isnan(speed_smoothed(frame))
                        if (sign(speed_smoothed(frame)) == forward)
%                                 blueAmount = abs(speed_smoothed(frame))/maxSpeed;
                            blueAmount = abs(speed_smoothed(frame))*0.5/aveSpeed;
                            if blueAmount>1
                                blueAmount = 1;
                            end
                            color = [0, 0, 1-blueAmount];
                        else 
%                                 redAmount = abs(speed_smoothed(frame))/maxSpeed;
                            redAmount = abs(speed_smoothed(frame))*0.5/aveSpeed;
                            if redAmount > 1
                                redAmount = 1;
                            end
                            color = [1-redAmount, 0, 0 ];
                        end
                        
                        plot([time(frame) time(frame)],[stimCount stimCount+0.9],'Color',color,'LineWidth',3)

                        hold on
                   end
                end
                stimCount = stimCount + 1;
               
            end
        end
        
    end
end
title('Raster plot of Responses','FontSize',20,'FontWeight','bold')
xlabel('Time (s), t=0 @ Stimulus Application','FontSize',16,'FontWeight','bold')
ylabel('Trial','FontSize',16,'FontWeight','bold')
axis([-12 15 0 stimCount])
set(gca,'ytick',[])
set(gca,'yticklabel',[])
set(gca, 'FontSize',16)
red = [0:0.02:1];
blue = [1:-0.02:0];
map = [(1-red)' zeros(size(red')) zeros(size(red')); ...
    zeros(size(blue')) zeros(size(blue')) (1-blue')];
colormap(map);
cbh = colorbar('YTickLabel',{'Forward','Pause','Reverse'}, ...
'YTick', [102 51 1],'FontSize',14);




