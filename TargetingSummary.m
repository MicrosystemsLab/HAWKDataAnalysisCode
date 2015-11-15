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
    DestinationFolder = '/Volumes/home/HAWK Data/Force Response Data/';
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


 fileID = fopen('/Users/emazzochette/Desktop/ErrorList.txt','a');
%asks user for the directory where all the files are:
%directory = uigetdir(DestinationFolder,'Choose the folder where the data if located');
directories = uipickfiles( 'FilterSpec',DestinationFolder);

count25 = 0;
count35 = 0;
count45 = 0;

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
%         FPGAData = getFPGADataFromYAML(directory, experimentTitle);
%         StimulusData = getStimulusDataFromYAML(directory,experimentTitle);
        load(mat_file);
        
        try
            target = TrackingData.TargetLocation;

            for stim = 1:TrackingData.NumberOfStimulus
                if Stimulus(stim).TrialScoring.trialSuccess == 1
                    if target == 25
                        count25 = count25 + 1;
                        counter = count25;
                    elseif target == 35
                        count35 = count35 + 1;
                        counter = count35;
                    elseif target == 45
                        count45 = count45 + 1;
                        counter = count45;
                    end

%                     H = Stimulus(stim).SpatialResolution.distanceFromTarget;
                    y = Stimulus(stim).SpatialResolution.distanceFromSkeleton;
%                     x = sqrt(H^2 - y^2);
%                     if Stimulus(stim).SpatialResolution.percentDownBodyHit*100<target
%                         x=-1*x;
%                     end
                    
                    testFrameStim =  find(Stimulus(stim).timeData(:,8)>Stimulus(stim).StimulusTiming.stimOnStartTime,1)-1;
                    bodyLength = Stimulus(stim).BodyMorphology.bodyLength(testFrameStim);
                    x = bodyLength*(Stimulus(stim).SpatialResolution.percentDownBodyHit - TrackingData.TargetLocation/100);
                    
                    TrackingNormalization.(['Target_' num2str(target)]).x(counter) = x; 
                    TrackingNormalization.(['Target_' num2str(target)]).y(counter) = y;
                    TrackingNormalization.(['Target_' num2str(target)]).x_percent(counter) = 100*Stimulus(stim).SpatialResolution.percentDownBodyHit - TrackingData.TargetLocation;
                    TrackingNormalization.(['Target_' num2str(target)]).DistanceMovedDuringApproach(counter) = Stimulus(stim).StimulusTiming.stimulusAnalysis.approachPoints.duration*Stimulus(stim).Response.preStimSpeed;
                end
            end
        catch
         disp(strcat('Error with: ',experimentTitle));
          fprintf(fileID,'%s\n',experimentTitle);
        end
            
    end
end
 save('/Users/emazzochette/Desktop/TrackingNormalization.mat', 'TrackingNormalization');
fclose(fileID);


%%

figure(1)
plot(TrackingNormalization.Target_25.x, TrackingNormalization.Target_25.y,'bx','MarkerSize',15)
hold on
plot([min(TrackingNormalization.Target_25.x) max(TrackingNormalization.Target_25.x)], [0 0],'k:')
plot([0 0], [-10 30],'k:')
xlabel('Distance along skeleton (um)','FontSize',16)
ylabel('Distance from skeleton (um)','FontSize',16)
title('Targeting at 25%','FontSize',16)
axis([-inf inf -10 30])
set(gca, 'FontSize',16)

figure(2)
plot(TrackingNormalization.Target_35.x, TrackingNormalization.Target_35.y,'bx','MarkerSize',15)
hold on
plot([min(TrackingNormalization.Target_35.x) max(TrackingNormalization.Target_35.x)], [0 0],'k:')
plot([0 0], [-10 30],'k:')
xlabel('Distance along skeleton (um)','FontSize',16)
ylabel('Distance from skeleton (um)','FontSize',16)
title('Targeting at 35%','FontSize',16)
axis([-inf inf -10 30])
set(gca, 'FontSize',16)

figure(3)
plot(TrackingNormalization.Target_45.x, TrackingNormalization.Target_45.y,'bx','MarkerSize',15)
hold on
plot([min(TrackingNormalization.Target_45.x) max(TrackingNormalization.Target_45.x)], [0 0],'k:')
plot([0 0], [-10 30],'k:')
xlabel('Distance along skeleton (um)','FontSize',16)
ylabel('Distance from skeleton (um)','FontSize',16)
title('Targeting at 45%','FontSize',16)
axis([-inf inf -10 30])
set(gca, 'FontSize',16)


figure(4)
plot(TrackingNormalization.Target_25.x_percent, TrackingNormalization.Target_25.y,'bx','MarkerSize',15)
hold on
plot([min(TrackingNormalization.Target_25.x_percent) max(TrackingNormalization.Target_25.x_percent)], [0 0],'k:')
plot([0 0], [-10 30],'k:')
xlabel('% Body Length along skeleton (um)','FontSize',16)
ylabel('Distance from skeleton (um)','FontSize',16)
title('Targeting at 25% by % Body Length','FontSize',16)
axis([-inf inf -10 30])
set(gca, 'FontSize',16)

figure(5)
plot(TrackingNormalization.Target_35.x_percent, TrackingNormalization.Target_35.y,'bx','MarkerSize',15);
hold on
plot([min(TrackingNormalization.Target_35.x_percent) max(TrackingNormalization.Target_35.x_percent)], [0 0],'k:')
plot([0 0], [-10 30],'k:')
xlabel('% Body Length along skeleton (um)','FontSize',16)
ylabel('Distance from skeleton (um)','FontSize',16)
title('Targeting at 35% by % Body Length','FontSize',16)
axis([-inf inf -10 30])
set(gca, 'FontSize',16)

figure(6)
plot(TrackingNormalization.Target_45.x_percent, TrackingNormalization.Target_45.y,'bx','MarkerSize',15)
hold on
plot([min(TrackingNormalization.Target_45.x_percent) max(TrackingNormalization.Target_45.x_percent)], [0 0],'k:')
plot([0 0], [-10 30],'k:')
xlabel('% Body Length along skeleton (um)','FontSize',16)
ylabel('Distance from skeleton (um)','FontSize',16)
title('Targeting at 45% by % Body Length','FontSize',16)
axis([-inf inf -10 30])
set(gca, 'FontSize',16)
%%
figure(7)
plot(TrackingNormalization.Target_25.x, -TrackingNormalization.Target_25.DistanceMovedDuringApproach,'b+')
hold on
plot(TrackingNormalization.Target_35.x, -TrackingNormalization.Target_35.DistanceMovedDuringApproach,'r+')
plot(TrackingNormalization.Target_45.x, -TrackingNormalization.Target_45.DistanceMovedDuringApproach,'g+')
plot([-10 60],[-10 60],'k:')
xlabel('Distance Skeleton Moved During Approach (um)','FontSize',16)
ylabel('Targeting Error Along Skeleton (um)','FontSize',16)
title('Skeleton Movement vs. Targeting Error','FontSize',16)
legend('25%','35%','45%','Location','SouthWest')
set(gca, 'FontSize',16)
axis('equal')

%% 
figure(1)
plot(TrackingNormalization.Target_25.x_percent+25, TrackingNormalization.Target_25.y,'b.','MarkerSize',15)
hold on
plot(TrackingNormalization.Target_35.x_percent+35, TrackingNormalization.Target_35.y,'r.','MarkerSize',15)
plot(TrackingNormalization.Target_45.x_percent+45, TrackingNormalization.Target_45.y,'g.','MarkerSize',15)
% xlabel('% Body Length along skeleton (um)','FontSize',16)
% ylabel('Distance from skeleton (um)','FontSize',16)
set(gca, 'FontSize',16)
axis([0 60 0 25]);
aspectRatio = 5; %width/height
width = 10;
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperPosition', [1 1 width width/aspectRatio]); %x_width=10cm y_width=15cm
