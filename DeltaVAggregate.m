txtFile_expNames = '/Users/emazzochette/Desktop/experimentNames.txt';
txtFile_stimNums = '/Users/emazzochette/Desktop/stimNumbers.txt';
txtFile_trialScore = '/Users/emazzochette/Desktop/finalTrialScores.txt';
txtFile_responseScore = '/Users/emazzochette/Desktop/finalResponseScores.txt';

expNames = textscan(fopen(txtFile_expNames),'%s');
stimNums = textscan(fopen(txtFile_stimNums),'%d');
trialScore = textscan(fopen(txtFile_trialScore),'%s');
responseScore = textscan(fopen(txtFile_responseScore),'%d');

totalTrials = length(expNames{1,1});
directory = '/Volumes/Backup Disc Celegans/HAWKData/Force Clamp/DataSet3/N2';

Forces = [50 100 500 1000 5000 10000];
numForces = length(Forces);
for force = 1:length(Forces)
    Profiles.(['Force_',num2str(Forces(force))]) = [];
end


%%
for trial = 1:totalTrials
    if ismember(trial,[2943:2945])
        continue
    end
    
    if (trial<2 || ~strcmp(expNames{1,1}{trial,1},expNames{1,1}{trial-1,1}))
        filenameStim = strcat(expNames{1,1}{trial,1},'_DataByStimulus.mat');
        filenameTracking = strcat(expNames{1,1}{trial,1},'_tracking_parsedData.mat');
        filenameStimData = strcat(expNames{1,1}{trial,1},'_stimulus_parsedData.mat');
        load(fullfile(directory,expNames{1,1}{trial,1},filenameStim));
        load(fullfile(directory,expNames{1,1}{trial,1},filenameTracking));
        load(fullfile(directory,expNames{1,1}{trial,1},filenameStimData));
    end

    force = find(Forces == StimulusData.Magnitude,1);
    if isempty(force)
       continue;
    end
    
    if strcmp(trialScore{1,1}{trial,1},'TRUE')
        
        stim = stimNums{1,1}(trial);

       [ unit.deltaVNorm ] = calculateDeltaVTrace( Stimulus(stim).CurvatureAnalysis.velocitySmoothed, Stimulus(stim).timeData(:,8), Stimulus(stim).StimulusTiming.stimOnFrame );
       
       unit.positionApplied = Stimulus(stim).SpatialResolution.percentDownBodyHit*100;
       unit.wormID = strcat(TrackingData.ExperimentTime(1:2),'_',TrackingData.ExperimentTime(4:5),'_',num2str(TrackingData.SlideNumber),'_', TrackingData.WormProperties.WormStrain);
       if responseScore{1,1}(trial) == 1 
            unit.maxDeltaVNorm = max(unit.deltaVNorm(Stimulus(stim).StimulusTiming.stimOnFrame:Stimulus(stim).StimulusTiming.stimOffFrame));
       else 
            unit.maxDeltaVNorm = min(unit.deltaVNorm(Stimulus(stim).StimulusTiming.stimOnFrame:Stimulus(stim).StimulusTiming.stimOffFrame));
       end
       
       
        Profiles.(['Force_',num2str(Forces(force))]) =  [Profiles.(['Force_',num2str(Forces(force))]) unit];
        
        
    end

    
    
end

%%
markerSize = 8;

for trialPlot = 1:length(Profiles.Force_10000)
    plot(Profiles.Force_10000(trialPlot).positionApplied,Profiles.Force_10000(trialPlot).maxDeltaVNorm,'Marker','o','MarkerSize',markerSize,'MarkerFaceColor', [255/255 255/255 51/255],'MarkerEdgeColor','none')
    hold on

end

for trialPlot = 1:length(Profiles.Force_5000)
    plot(Profiles.Force_5000(trialPlot).positionApplied,Profiles.Force_5000(trialPlot).maxDeltaVNorm,'Marker','o','MarkerSize',markerSize,'MarkerFaceColor', [255/255 127/255 0/255],'MarkerEdgeColor','none')
    hold on

end

for trialPlot = 1:length(Profiles.Force_1000)
    plot(Profiles.Force_1000(trialPlot).positionApplied,Profiles.Force_1000(trialPlot).maxDeltaVNorm,'Marker','o','MarkerSize',markerSize,'MarkerFaceColor', [152/255 78/255 163/255],'MarkerEdgeColor','none')
    hold on

end

for trialPlot = 1:length(Profiles.Force_500)
    plot(Profiles.Force_500(trialPlot).positionApplied,Profiles.Force_500(trialPlot).maxDeltaVNorm,'Marker','o','MarkerSize',markerSize,'MarkerFaceColor', [77/255 175/255 74/255],'MarkerEdgeColor','none')
    hold on

end

for trialPlot = 1:length(Profiles.Force_100)
    plot(Profiles.Force_100(trialPlot).positionApplied,Profiles.Force_100(trialPlot).maxDeltaVNorm,'Marker','o','MarkerSize',markerSize,'MarkerFaceColor', [55/255 126/255 184/255],'MarkerEdgeColor','none')
    hold on

end

for trialPlot = 1:length(Profiles.Force_50)
    plot(Profiles.Force_50(trialPlot).positionApplied,Profiles.Force_50(trialPlot).maxDeltaVNorm,'Marker','o','MarkerSize',markerSize,'MarkerFaceColor', [228/255 26/255 28/255],'MarkerEdgeColor','none')
    hold on
end








%%
axis([0 100 -6 12])
set(gca,'FontSize',20)
[xNew yNew] = MiriamAxes(gca,'xy');
