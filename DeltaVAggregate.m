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

%% colors:
color_50 = [228/255 26/255 28/255];
color_100 = [55/255 126/255 184/255];
color_500 = [77/255 175/255 74/255];
color_1000 = [152/255 78/255 163/255];
color_5000 = [255/255 127/255 0/255];
color_10000 = [255/255 255/255 51/255];

%% Plot all data points:

markerSize = 8;

maxTrials = max([length(Profiles.Force_50),length(Profiles.Force_100)]);
maxTrials2 = max([length(Profiles.Force_500),length(Profiles.Force_1000),length(Profiles.Force_5000),length(Profiles.Force_10000)]);
for trialPlot = maxTrials2+1:maxTrials
   % for trialPlot = 1:length(Profiles.Force_100)
    try plot(Profiles.Force_100(trialPlot).positionApplied,Profiles.Force_100(trialPlot).maxDeltaVNorm,'Marker','o','MarkerSize',markerSize,'MarkerFaceColor', color_100,'MarkerEdgeColor','none'); end
    hold on

% end
% 
% for trialPlot = 1:length(Profiles.Force_50)
    try plot(Profiles.Force_50(trialPlot).positionApplied,Profiles.Force_50(trialPlot).maxDeltaVNorm,'Marker','o','MarkerSize',markerSize,'MarkerFaceColor', color_50,'MarkerEdgeColor','none'); end
    hold on
end

for trialPlot = 1:maxTrials2
    
    % for trialPlot = 1:length(Profiles.Force_100)
    try plot(Profiles.Force_100(trialPlot).positionApplied,Profiles.Force_100(trialPlot).maxDeltaVNorm,'Marker','o','MarkerSize',markerSize,'MarkerFaceColor', color_100,'MarkerEdgeColor','none'); end
    hold on

% end
% 
% for trialPlot = 1:length(Profiles.Force_50)
    try plot(Profiles.Force_50(trialPlot).positionApplied,Profiles.Force_50(trialPlot).maxDeltaVNorm,'Marker','o','MarkerSize',markerSize,'MarkerFaceColor', color_50,'MarkerEdgeColor','none'); end
    hold on
    
    try plot(Profiles.Force_10000(trialPlot).positionApplied,Profiles.Force_10000(trialPlot).maxDeltaVNorm,'Marker','o','MarkerSize',markerSize,'MarkerFaceColor', color_10000,'MarkerEdgeColor','none'); end
    hold on

% end
% 
% for trialPlot = 1:length(Profiles.Force_5000)
    try plot(Profiles.Force_5000(trialPlot).positionApplied,Profiles.Force_5000(trialPlot).maxDeltaVNorm,'Marker','o','MarkerSize',markerSize,'MarkerFaceColor', color_5000,'MarkerEdgeColor','none'); end
    hold on

% end
% 
% for trialPlot = 1:length(Profiles.Force_1000)
    try plot(Profiles.Force_1000(trialPlot).positionApplied,Profiles.Force_1000(trialPlot).maxDeltaVNorm,'Marker','o','MarkerSize',markerSize,'MarkerFaceColor', color_1000,'MarkerEdgeColor','none'); end
    hold on

% end
% 
% for trialPlot = 1:length(Profiles.Force_500)
    try plot(Profiles.Force_500(trialPlot).positionApplied,Profiles.Force_500(trialPlot).maxDeltaVNorm,'Marker','o','MarkerSize',markerSize,'MarkerFaceColor', color_500,'MarkerEdgeColor','none'); end
    hold on

% end
% 

end

%%

axis([0 100 -6 12])
set(gca,'FontSize',20)
[xNew yNew] = MiriamAxes(gca,'xy');

%% rebin by target
markerSize = 10;
lineWidth = 4;
targetBins = [10:10:90];
for bin = 1:length(targetBins)
    Bins_50.(['TargetBin_',num2str(bin)]) = [];
	Bins_100.(['TargetBin_',num2str(bin)]) = [];
	Bins_500.(['TargetBin_',num2str(bin)]) = [];
	Bins_1000.(['TargetBin_',num2str(bin)]) = [];
	Bins_5000.(['TargetBin_',num2str(bin)]) = [];
	Bins_10000.(['TargetBin_',num2str(bin)]) = [];
    Bins_50.average = [];
    Bins_100.average = [];
    Bins_500.average = [];
    Bins_1000.average = [];
    Bins_5000.average = [];
    Bins_10000.average = [];
end

for trialPlot = 1:length(Profiles.Force_50)
  bin = find(targetBins>Profiles.Force_50(trialPlot).positionApplied,1,'first')-1;
  Bins_50.(['TargetBin_',num2str(bin)]) = [Bins_50.(['TargetBin_',num2str(bin)]); Profiles.Force_50(trialPlot).positionApplied Profiles.Force_50(trialPlot).maxDeltaVNorm];
end

for trialPlot = 1:length(Profiles.Force_100)
  bin = find(targetBins>Profiles.Force_100(trialPlot).positionApplied,1,'first')-1;
  Bins_100.(['TargetBin_',num2str(bin)]) = [Bins_100.(['TargetBin_',num2str(bin)]); Profiles.Force_100(trialPlot).positionApplied Profiles.Force_100(trialPlot).maxDeltaVNorm];
end

for trialPlot = 1:length(Profiles.Force_500)
  bin = find(targetBins>Profiles.Force_500(trialPlot).positionApplied,1,'first')-1;
  Bins_500.(['TargetBin_',num2str(bin)]) = [Bins_500.(['TargetBin_',num2str(bin)]); Profiles.Force_500(trialPlot).positionApplied Profiles.Force_500(trialPlot).maxDeltaVNorm];
end

for trialPlot = 1:length(Profiles.Force_1000)
  bin = find(targetBins>Profiles.Force_1000(trialPlot).positionApplied,1,'first')-1;
  Bins_1000.(['TargetBin_',num2str(bin)]) = [Bins_1000.(['TargetBin_',num2str(bin)]); Profiles.Force_1000(trialPlot).positionApplied Profiles.Force_1000(trialPlot).maxDeltaVNorm];
end

for trialPlot = 1:length(Profiles.Force_5000)
  bin = find(targetBins>Profiles.Force_5000(trialPlot).positionApplied,1,'first')-1;
  Bins_5000.(['TargetBin_',num2str(bin)]) = [Bins_5000.(['TargetBin_',num2str(bin)]); Profiles.Force_5000(trialPlot).positionApplied Profiles.Force_5000(trialPlot).maxDeltaVNorm];
end

for trialPlot = 1:length(Profiles.Force_10000)
  bin = find(targetBins>Profiles.Force_10000(trialPlot).positionApplied,1,'first')-1;
  Bins_10000.(['TargetBin_',num2str(bin)]) = [Bins_10000.(['TargetBin_',num2str(bin)]); Profiles.Force_10000(trialPlot).positionApplied Profiles.Force_10000(trialPlot).maxDeltaVNorm];
end
minTrials = 5;
 for bin = 1:length(targetBins)


    if size(Bins_50.(['TargetBin_',num2str(bin)]),1)> minTrials
        Bins_50.average = [Bins_50.average; mean( Bins_50.(['TargetBin_',num2str(bin)]),1) std(Bins_50.(['TargetBin_',num2str(bin)]),1), length(Bins_50.(['TargetBin_',num2str(bin)]))]; 
        plot(Bins_50.average(:,1),Bins_50.average(:,2), 'Marker','o','MarkerSize',markerSize,'MarkerFaceColor', [228/255 26/255 28/255],'MarkerEdgeColor','none','Color', [228/255 26/255 28/255],'LineWidth',lineWidth);
        hold on
    end
    
    
    if size(Bins_100.(['TargetBin_',num2str(bin)]),1)> minTrials
        Bins_100.average = [Bins_100.average; mean( Bins_100.(['TargetBin_',num2str(bin)]),1) std(Bins_100.(['TargetBin_',num2str(bin)]),1), length(Bins_100.(['TargetBin_',num2str(bin)]))]; 
        plot(Bins_100.average(:,1),Bins_100.average(:,2), 'Marker','o','MarkerSize',markerSize,'MarkerFaceColor', [55/255 126/255 184/255],'MarkerEdgeColor','none','Color', [55/255 126/255 184/255],'LineWidth',lineWidth);
        hold on
    end
    

    if size(Bins_500.(['TargetBin_',num2str(bin)]),1)> minTrials
        Bins_500.average = [Bins_500.average; mean( Bins_500.(['TargetBin_',num2str(bin)]),1) std(Bins_500.(['TargetBin_',num2str(bin)]),1), length(Bins_500.(['TargetBin_',num2str(bin)]))]; 
        plot(Bins_500.average(:,1),Bins_500.average(:,2), 'Marker','o','MarkerSize',markerSize,'MarkerFaceColor', [77/255 175/255 74/255],'MarkerEdgeColor','none','Color', [77/255 175/255 74/255],'LineWidth',lineWidth);
        hold on
    end
    
    
    if size(Bins_1000.(['TargetBin_',num2str(bin)]),1)> minTrials
        Bins_1000.average = [Bins_1000.average; mean( Bins_1000.(['TargetBin_',num2str(bin)]),1) std(Bins_1000.(['TargetBin_',num2str(bin)]),1), length(Bins_1000.(['TargetBin_',num2str(bin)]))]; 
        plot(Bins_1000.average(:,1),Bins_1000.average(:,2), 'Marker','o','MarkerSize',markerSize,'MarkerFaceColor', [152/255 78/255 163/255],'MarkerEdgeColor','none','Color', [152/255 78/255 163/255],'LineWidth',lineWidth);
        hold on
    end
    

    if size(Bins_5000.(['TargetBin_',num2str(bin)]),1)> minTrials
        Bins_5000.average = [Bins_5000.average; mean( Bins_5000.(['TargetBin_',num2str(bin)]),1) std(Bins_5000.(['TargetBin_',num2str(bin)]),1), length(Bins_5000.(['TargetBin_',num2str(bin)]))]; 
        plot(Bins_5000.average(:,1),Bins_5000.average(:,2), 'Marker','o','MarkerSize',markerSize,'MarkerFaceColor', [255/255 127/255 0/255],'MarkerEdgeColor','none','Color', [255/255 127/255 0/255],'LineWidth',lineWidth);
        hold on
    end
    
    
    if size(Bins_10000.(['TargetBin_',num2str(bin)]),1)> minTrials
        Bins_10000.average = [Bins_10000.average; mean( Bins_10000.(['TargetBin_',num2str(bin)]),1) std(Bins_10000.(['TargetBin_',num2str(bin)]),1), length(Bins_10000.(['TargetBin_',num2str(bin)]))]; 
        plot(Bins_10000.average(:,1),Bins_10000.average(:,2), 'Marker','o','MarkerSize',markerSize,'MarkerFaceColor', [255/255 255/255 51/255],'MarkerEdgeColor','none','Color', [255/255 255/255 51/255],'LineWidth',lineWidth);
        hold on
    end
 
 end
 
axis([0 100 -3 3])
set(gca,'FontSize',20)
[xNew yNew] = MiriamAxes(gca,'xy');


%% Organize by Force, Create histograms:

for trial = 1:length(Profiles.Force_50)
   data_50(trial) =  Profiles.Force_50(trial).maxDeltaVNorm;
end
for trial = 1:length(Profiles.Force_100)
   data_100(trial) =  Profiles.Force_100(trial).maxDeltaVNorm;
end

for trial = 1:length(Profiles.Force_500)
   data_500(trial) =  Profiles.Force_500(trial).maxDeltaVNorm;
end

for trial = 1:length(Profiles.Force_1000)
   data_1000(trial) =  Profiles.Force_1000(trial).maxDeltaVNorm;
end

for trial = 1:length(Profiles.Force_5000)
   data_5000(trial) =  Profiles.Force_5000(trial).maxDeltaVNorm;
end

for trial = 1:length(Profiles.Force_10000)
   data_10000(trial) =  Profiles.Force_10000(trial).maxDeltaVNorm;
end

bins = [-6:0.5:8];
reversalThreshold = 0.75;
reversalBound = [reversalThreshold reversalThreshold];
speedUpThreshold = -1;
speedUpBound = [speedUpThreshold speedUpThreshold];

close all
xLim = [-5 7];
yLim = [0 0.6];
fontSize = 27;
lineWidth = 4;
lineStyle = '--';
displayStyle = {'bar'};
reversalLineColor = [0 0 0];%{'k'};
speedUpLineColor = [0 0 1];%{'b'};


figure(1)
histogram(data_50, bins, 'Normalization', 'probability' ,'DisplayStyle',displayStyle,'FaceColor',color_50, 'EdgeColor','none');
hold on
plot(reversalBound,yLim,'LineWidth',lineWidth,'Color',reversalLineColor,'LineStyle',lineStyle);
plot(speedUpBound,yLim,'LineWidth',lineWidth,'Color',speedUpLineColor,'LineStyle',lineStyle);
set(gca,'FontSize',fontSize)
set(gca,'ylim', yLim);
set(gca,'xlim', xLim);
[xNew yNew] = MiriamAxes(gca,'xy');

figure(2)
histogram(data_100, bins, 'Normalization', 'probability','DisplayStyle',displayStyle,'FaceColor',color_100, 'EdgeColor','none')
hold on
plot(reversalBound,yLim,'LineWidth',lineWidth,'Color',reversalLineColor,'LineStyle',lineStyle);
plot(speedUpBound,yLim,'LineWidth',lineWidth,'Color',speedUpLineColor,'LineStyle',lineStyle);
set(gca,'FontSize',fontSize)
set(gca,'ylim', yLim);
set(gca,'xlim', xLim);
[xNew yNew] = MiriamAxes(gca,'xy');

figure(3)
histogram(data_500, bins, 'Normalization', 'probability','DisplayStyle',displayStyle,'FaceColor',color_500, 'EdgeColor','none')
hold on
plot(reversalBound,yLim,'LineWidth',lineWidth,'Color',reversalLineColor,'LineStyle',lineStyle);
plot(speedUpBound,yLim,'LineWidth',lineWidth,'Color',speedUpLineColor,'LineStyle',lineStyle);
set(gca,'FontSize',fontSize)
set(gca,'ylim', yLim);
set(gca,'xlim', xLim);
[xNew yNew] = MiriamAxes(gca,'xy');

figure(4)
histogram(data_1000, bins, 'Normalization', 'probability','DisplayStyle',displayStyle,'FaceColor',color_1000, 'EdgeColor','none')
hold on
plot(reversalBound,yLim,'LineWidth',lineWidth,'Color',reversalLineColor,'LineStyle',lineStyle);
plot(speedUpBound,yLim,'LineWidth',lineWidth,'Color',speedUpLineColor,'LineStyle',lineStyle);
set(gca,'FontSize',fontSize)
set(gca,'ylim', yLim);
set(gca,'xlim', xLim);
[xNew yNew] = MiriamAxes(gca,'xy');

figure(5)
histogram(data_5000, bins, 'Normalization', 'probability','DisplayStyle',displayStyle,'FaceColor',color_5000, 'EdgeColor','none')
hold on
plot(reversalBound,yLim,'LineWidth',lineWidth,'Color',reversalLineColor,'LineStyle',lineStyle);
plot(speedUpBound,yLim,'LineWidth',lineWidth,'Color',speedUpLineColor,'LineStyle',lineStyle);
set(gca,'FontSize',fontSize)
set(gca,'ylim', yLim);
set(gca,'xlim', xLim);
[xNew yNew] = MiriamAxes(gca,'xy');

figure(6)
histogram(data_10000, bins, 'Normalization', 'probability','DisplayStyle',displayStyle,'FaceColor',color_10000, 'EdgeColor','none')
hold on
plot(reversalBound,yLim,'LineWidth',lineWidth,'Color',reversalLineColor,'LineStyle',lineStyle);
plot(speedUpBound,yLim,'LineWidth',lineWidth,'Color',speedUpLineColor,'LineStyle',lineStyle);
set(gca,'FontSize',fontSize)
set(gca,'ylim', yLim);
set(gca,'xlim', xLim);
[xNew yNew] = MiriamAxes(gca,'xy');

%% Plot filtered out points based on thresholds, plot:

figure(7)
markerSize = 8;

maxTrials = max([length(Profiles.Force_50),length(Profiles.Force_100)]);
maxTrials2 = max([length(Profiles.Force_500),length(Profiles.Force_1000),length(Profiles.Force_5000),length(Profiles.Force_10000)]);
for trialPlot = maxTrials2+1:maxTrials
 
    try 
        if (Profiles.Force_100(trialPlot).maxDeltaVNorm > reversalBound | Profiles.Force_100(trialPlot).maxDeltaVNorm < speedUpBound)
            plot(Profiles.Force_100(trialPlot).positionApplied,Profiles.Force_100(trialPlot).maxDeltaVNorm,'Marker','o','MarkerSize',markerSize,'MarkerFaceColor', color_100,'MarkerEdgeColor','none'); 
        end
    end
    hold on

    try 
        if (Profiles.Force_50(trialPlot).maxDeltaVNorm > reversalBound | Profiles.Force_50(trialPlot).maxDeltaVNorm < speedUpBound)
            plot(Profiles.Force_50(trialPlot).positionApplied,Profiles.Force_50(trialPlot).maxDeltaVNorm,'Marker','o','MarkerSize',markerSize,'MarkerFaceColor', color_50,'MarkerEdgeColor','none');
        end
    end
    hold on
end

for trialPlot = 1:maxTrials2
    
    try 
        if (Profiles.Force_100(trialPlot).maxDeltaVNorm > reversalBound | Profiles.Force_100(trialPlot).maxDeltaVNorm < speedUpBound)
            plot(Profiles.Force_100(trialPlot).positionApplied,Profiles.Force_100(trialPlot).maxDeltaVNorm,'Marker','o','MarkerSize',markerSize,'MarkerFaceColor', color_100,'MarkerEdgeColor','none'); 
        end
    end
    hold on


    try 
        if (Profiles.Force_50(trialPlot).maxDeltaVNorm > reversalBound | Profiles.Force_50(trialPlot).maxDeltaVNorm < speedUpBound)
            plot(Profiles.Force_50(trialPlot).positionApplied,Profiles.Force_50(trialPlot).maxDeltaVNorm,'Marker','o','MarkerSize',markerSize,'MarkerFaceColor', color_50,'MarkerEdgeColor','none'); 
        end
    end
    hold on
    
    try 
        if (Profiles.Force_10000(trialPlot).maxDeltaVNorm > reversalBound | Profiles.Force_10000(trialPlot).maxDeltaVNorm < speedUpBound)
            plot(Profiles.Force_10000(trialPlot).positionApplied,Profiles.Force_10000(trialPlot).maxDeltaVNorm,'Marker','o','MarkerSize',markerSize,'MarkerFaceColor', color_10000,'MarkerEdgeColor','none'); 
        end
    end
    hold on


    try 
        if (Profiles.Force_5000(trialPlot).maxDeltaVNorm > reversalBound | Profiles.Force_5000(trialPlot).maxDeltaVNorm < speedUpBound)
            plot(Profiles.Force_5000(trialPlot).positionApplied,Profiles.Force_5000(trialPlot).maxDeltaVNorm,'Marker','o','MarkerSize',markerSize,'MarkerFaceColor', color_5000,'MarkerEdgeColor','none'); 
        end
    end
    hold on

    try 
        if (Profiles.Force_1000(trialPlot).maxDeltaVNorm > reversalBound | Profiles.Force_1000(trialPlot).maxDeltaVNorm < speedUpBound)
            plot(Profiles.Force_1000(trialPlot).positionApplied,Profiles.Force_1000(trialPlot).maxDeltaVNorm,'Marker','o','MarkerSize',markerSize,'MarkerFaceColor', color_1000,'MarkerEdgeColor','none'); 
        end
    end
    hold on

    try 
        if (Profiles.Force_500(trialPlot).maxDeltaVNorm > reversalBound | Profiles.Force_500(trialPlot).maxDeltaVNorm < speedUpBound)
            plot(Profiles.Force_500(trialPlot).positionApplied,Profiles.Force_500(trialPlot).maxDeltaVNorm,'Marker','o','MarkerSize',markerSize,'MarkerFaceColor', color_500,'MarkerEdgeColor','none'); 
        end
    end
    hold on

end

set(gca,'FontSize',fontSize)
set(gca,'ylim', [-6 12]);
set(gca,'xlim', [0 100]);
[xNew yNew] = MiriamAxes(gca,'xy');
