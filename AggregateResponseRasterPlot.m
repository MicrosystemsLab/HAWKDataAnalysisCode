
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


% 
% %asks user for the directory where all the files are:
% %directory = uigetdir(DestinationFolder,'Choose the folder where the data if located');
directories = uipickfiles( 'FilterSpec',DestinationFolder);
% for i = 1:length(directories)
%     directory = directories{i};
%     location(i) = str2num(directory(end-1:end));
%     [values indices] = sort(location,'ascend');
% end


% stim = 1;
% numStims = 6;
% stimCount = 0;

% currentTarget = values(1);

% directoryCell = directories(:,indices(dir));

Forces = [500 1000 5000 10000];
Forces2 = [650 1300 6500 13000];
Targets = [25 35 45];
classes = [1 2 3 4; 5 6 7 8; 9 10 11 12];
classCount = zeros(size(classes));


for dir = 1:length(directories)
      %Select next directory:
%     directoryCell = directories(:,indices(dir));
    directoryCell = directories(:,dir);
    directory = directoryCell{1};
    
%     previousTarget = currentTarget;
%     currentTarget = values(dir);
%     if previousTarget~=currentTarget
%         stimCount = stimCount + 1;
%         plot([min(time) max(time)],[stimCount-0.5 stimCount-0.5],'LineWidth',3,'Color','black');
%     end
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
        
        %Also need to extract the number of stimulus 
%         if (ismember('NumberOfStimulus',fieldnames(TrackingData)))
            numStims = TrackingData.NumberOfStimulus;
%         else
%             numStims =  min(length(Stimulus), length(fieldnames(FPGAData)));
%         end

        if (numStims>0)
            for stim = 1:numStims
                if (Stimulus(stim).TrialScoring.trialSuccess == 1)
                    target = find(Targets == TrackingData.TargetLocation,1);
                    force = find(Forces == StimulusData.Magnitude,1);


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
                       if isnan(speed_smoothed(frame)) 
                           color = [0.5 0.5 0.5];
%                             subplot(3,4,classes(target,force))
                            figure(classes(target,force));
                            plot([time(frame) time(frame)],[classCount(target,force) classCount(target,force)+0.8],'Color',color,'LineWidth',3)
                         hold on
                       elseif (sign(speed_smoothed(frame)) == forward)
    %                                 blueAmount = abs(speed_smoothed(frame))/maxSpeed;
    %                             blueAmount = abs(speed_smoothed(frame))*0.5/aveSpeed;
    %                             if blueAmount>1
    %                                 blueAmount = 1;
    %                             end
    %                             color = [0, 0, 1-blueAmount];
                           color = [0 0 1];
%                             subplot(3,4,classes(target,force))
                            figure(classes(target,force));
                            plot([time(frame) time(frame)],[classCount(target,force) classCount(target,force)+0.8],'Color',color,'LineWidth',3)
                            hold on
                       elseif (-1*sign(speed_smoothed(frame)) == forward)
    %                                 redAmount = abs(speed_smoothed(frame))/maxSpeed;
    %                             redAmount = abs(speed_smoothed(frame))*0.5/aveSpeed;
    %                             if redAmount > 1
    %                                 redAmount = 1;
    %                             end
    %                             color = [1-redAmount, 0, 0 ];
                           color = [1 0 0];
%                             subplot(3,4,classes(target,force))
                            figure(classes(target,force));
                            plot([time(frame) time(frame)],[classCount(target,force) classCount(target,force)+0.8],'Color',color,'LineWidth',3)
                            hold on
                        end

                    end
                    classCount(target,force) = classCount(target,force) + 1;
               
                end
            end
        end
        
    end
end



%%
Forces2 = [650 1300 6500 13000];
for force = 1:4
    for target = 1:3
       
    
        figure(classes(target,force))
        axis([-2 6 -Inf Inf])
        set(gca, 'FontSize',16)
%         if classes(target,force)<=4
            title(strcat('Force Applied: ',num2str(Forces2(force)), ' nN'),'FontSize', 16);
%         end
%         if classes(target,force)>8
          xlabel('Time (s)','FontSize', 16);
%         else 
% %             set(gca,'xtick',[])
%             set(gca,'xticklabel',[])
%         end
        if classes(target,force) >= 1 && classes(target,force) <=4
            ylabel('Trials @ 25% Target', 'FontSize',14)
        elseif classes(target,force) >= 5 && classes(target,force) <=8
            ylabel('Trials @ 35% Target', 'FontSize',14)
        elseif  classes(target,force) >= 9 && classes(target,force) <=12
            ylabel('Trials @ 45% Target', 'FontSize',14)
%         else
% %             set(gca,'ytick',[])
%             set(gca,'yticklabel',[])
        end
        
    
    end
end


% title('Raster plot of Responses for 1000 nN','FontSize',20,'FontWeight','bold')
% xlabel('Time (s), t=0 @ Stimulus Application','FontSize',16,'FontWeight','bold')
% ylabel('Trial','FontSize',16,'FontWeight','bold')
% axis([-1.5 5 0 stimCount])
% set(gca,'ytick',[])
% set(gca,'yticklabel',[])
% set(gca, 'FontSize',16)
% red = [0:0.02:1];
% blue = [1:-0.02:0];
% map = [(1-red)' zeros(size(red')) zeros(size(red')); ...
%     zeros(size(blue')) zeros(size(blue')) (1-blue')];
% colormap(map);
% cbh = colorbar('YTickLabel',{'Forward','Pause','Reverse'}, ...
% 'YTick', [102 51 1],'FontSize',14);




