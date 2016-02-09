

Forces = [50 100 500 1000 5000 10000];
Targets = [25 35 45 55 75];
Strains = [{'n2'} {'spc1'}];

txtFile_expNames = '/Users/emazzochette/Desktop/experimentNames.txt';
txtFile_stimNums = '/Users/emazzochette/Desktop/stimNumbers.txt';
txtFile_trialScore = '/Users/emazzochette/Desktop/finalTrialScores.txt';
txtFile_responseScore = '/Users/emazzochette/Desktop/finalResponseScores.txt';

expNames = textscan(fopen(txtFile_expNames),'%s');
stimNums = textscan(fopen(txtFile_stimNums),'%d');
trialScore = textscan(fopen(txtFile_trialScore),'%s');
responseScore = textscan(fopen(txtFile_responseScore),'%d');

txtFile_expNames_spc1 = '/Users/emazzochette/Desktop/experimentNames_spc1.txt';
txtFile_stimNums_spc1 = '/Users/emazzochette/Desktop/stimNumbers_spc1.txt';
txtFile_trialScore_spc1 = '/Users/emazzochette/Desktop/finalTrialScores_spc1.txt';
txtFile_responseScore_spc1 = '/Users/emazzochette/Desktop/finalResponseScores_spc1.txt';

expNames_spc1 = textscan(fopen(txtFile_expNames_spc1),'%s');
stimNums_spc1 = textscan(fopen(txtFile_stimNums_spc1),'%d');
trialScore_spc1 = textscan(fopen(txtFile_trialScore_spc1),'%s');
responseScore_spc1 = textscan(fopen(txtFile_responseScore_spc1),'%d');

totalTrials_N2 = length(expNames{1,1});
totalTrials_spc1 = length(expNames_spc1{1,1});
directoryN2 = '/Volumes/Backup Disc Celegans/HAWKData/Force Clamp/DataSet3/N2';
directoryspc1 = '/Volumes/Backup Disc Celegans/HAWKData/Force Clamp/DataSet3/spc1';

load('/Users/emazzochette/Desktop/DeltaVTraces2.mat')
%% Initialize Vectors:

n2_50_25 = [];
n2_100_25 = [];
n2_500_25 = [];
n2_1000_25 = [];
n2_5000_25 = [];
n2_10000_25 = [];

n2_50_35 = [];
n2_100_35 = [];
n2_500_35 = [];
n2_1000_35 = [];
n2_5000_35 = [];
n2_10000_35 = [];

spc1_50_25 = [];
spc1_100_25 = [];
spc1_500_25 = [];
spc1_1000_25 = [];
spc1_5000_25 = [];
spc1_10000_25 = [];

%% N2 Data:
for trial = 1:totalTrials_N2
    if ismember(trial,[2943:2945])
        continue
    end
    
    if (trial<2 || ~strcmp(expNames{1,1}{trial,1},expNames{1,1}{trial-1,1}))
        filenameStim = strcat(expNames{1,1}{trial,1},'_DataByStimulus.mat');
        filenameTracking = strcat(expNames{1,1}{trial,1},'_tracking_parsedData.mat');
        filenameStimData = strcat(expNames{1,1}{trial,1},'_stimulus_parsedData.mat');
        load(fullfile(directoryN2,expNames{1,1}{trial,1},filenameStim));
        load(fullfile(directoryN2,expNames{1,1}{trial,1},filenameTracking));
        load(fullfile(directoryN2,expNames{1,1}{trial,1},filenameStimData));
    end

    force = find(Forces == StimulusData.Magnitude,1);
    target = find(Targets == TrackingData.TargetLocation,1);
    if isempty(force)
       continue;
    end
    if ~ismember(target,[1, 2])
        continue;
    end
    
    stim = stimNums{1,1}(trial);

    if (responseScore{1,1}(trial) == 1 && strcmp(trialScore{1,1}{trial,1},'TRUE'))
        [deltaVNorm ] = calculateDeltaVTrace(Stimulus(stim).CurvatureAnalysis.velocitySmoothed, Stimulus(stim).timeData(:,8), Stimulus(stim).StimulusTiming.stimOnFrame );
        maxDeltaVNorm = max(deltaVNorm(Stimulus(stim).StimulusTiming.stimOnFrame:Stimulus(stim).StimulusTiming.stimOffFrame));
  
        
        if (target == 1)
            if (force == 1)
                n2_50_25 = [ n2_50_25;  maxDeltaVNorm,  -1.*Stimulus(stim).Response.maxAcceleration2 ];
            elseif (force == 2)
                n2_100_25 = [n2_100_25; maxDeltaVNorm,  -1.*Stimulus(stim).Response.maxAcceleration2];
            elseif (force == 3) 
                n2_500_25 = [ n2_500_25; maxDeltaVNorm,  -1.*Stimulus(stim).Response.maxAcceleration2];
            elseif (force == 4)
                n2_1000_25 = [n2_1000_25; maxDeltaVNorm,  -1.*Stimulus(stim).Response.maxAcceleration2];
            elseif (force == 5)
                n2_5000_25 = [n2_5000_25; maxDeltaVNorm,  -1.*Stimulus(stim).Response.maxAcceleration2];
            elseif (force == 6)
                n2_10000_25 = [n2_10000_25; maxDeltaVNorm,  -1.*Stimulus(stim).Response.maxAcceleration2];
            end
        elseif (target == 2)
            if (force == 1)   
                n2_50_35 = [ n2_50_35;  maxDeltaVNorm,  -1.*Stimulus(stim).Response.maxAcceleration2];
            elseif (force == 2)
                n2_100_35 = [ n2_50_35; maxDeltaVNorm,  -1.*Stimulus(stim).Response.maxAcceleration2 ];
            elseif (force == 3)
                n2_500_35 = [n2_500_35; maxDeltaVNorm,  -1.*Stimulus(stim).Response.maxAcceleration2];
            elseif (force == 4)
                n2_1000_35 = [n2_1000_35; maxDeltaVNorm,  -1.*Stimulus(stim).Response.maxAcceleration2];
            elseif (force == 5)
                n2_5000_35 = [n2_5000_35; maxDeltaVNorm,  -1.*Stimulus(stim).Response.maxAcceleration2 ];
            elseif (force == 6)
                n2_10000_35 = [n2_10000_35; maxDeltaVNorm,  -1.*Stimulus(stim).Response.maxAcceleration2];
            end
        end
    
     end
    
end
    
%% spc1 Data
for trial = 1:totalTrials_spc1
   
    
    if (trial<2 || ~strcmp(expNames_spc1{1,1}{trial,1},expNames_spc1{1,1}{trial-1,1}))
        filenameStim = strcat(expNames_spc1{1,1}{trial,1},'_DataByStimulus.mat');
        filenameTracking = strcat(expNames_spc1{1,1}{trial,1},'_tracking_parsedData.mat');
        filenameStimData = strcat(expNames_spc1{1,1}{trial,1},'_stimulus_parsedData.mat');
        load(fullfile(directoryspc1,expNames_spc1{1,1}{trial,1},filenameStim));
        load(fullfile(directoryspc1,expNames_spc1{1,1}{trial,1},filenameTracking));
        load(fullfile(directoryspc1,expNames_spc1{1,1}{trial,1},filenameStimData));
    end

    force = find(Forces == StimulusData.Magnitude,1);
    target = find(Targets == TrackingData.TargetLocation,1);
    if (isempty(force) || ~ismember(target,[1, 2]))
       continue;
    end
    
    stim = stimNums_spc1{1,1}(trial);

    if (responseScore_spc1{1,1}(trial) == 1 && strcmp(trialScore_spc1{1,1}{trial,1},'TRUE'))
        [deltaVNorm ] = calculateDeltaVTrace(Stimulus(stim).CurvatureAnalysis.velocitySmoothed, Stimulus(stim).timeData(:,8), Stimulus(stim).StimulusTiming.stimOnFrame );
        maxDeltaVNorm = max(deltaVNorm(Stimulus(stim).StimulusTiming.stimOnFrame:Stimulus(stim).StimulusTiming.stimOffFrame));
        
        if (force == 1)
            spc1_50_25 = [ spc1_50_25;  maxDeltaVNorm,  -1.*Stimulus(stim).Response.maxAcceleration2 ];
        elseif (force == 2)
            spc1_100_25 = [spc1_100_25; maxDeltaVNorm,  -1.*Stimulus(stim).Response.maxAcceleration2];
        elseif (force == 3) 
           spc1_500_25 = [spc1_500_25; maxDeltaVNorm,  -1.*Stimulus(stim).Response.maxAcceleration2];
        elseif (force == 4)
            spc1_1000_25 = [spc1_1000_25; maxDeltaVNorm,  -1.*Stimulus(stim).Response.maxAcceleration2];
        elseif (force == 5)
            spc1_5000_25 = [spc1_5000_25; maxDeltaVNorm,  -1.*Stimulus(stim).Response.maxAcceleration2];
        elseif (force == 6)
            spc1_10000_25 = [spc1_10000_25; maxDeltaVNorm,  -1.*Stimulus(stim).Response.maxAcceleration2];
        end
       
    
     end
    
end
    
%% Compile, Save Data:

rows_25 = max([length(n2_50_25),length(n2_100_25),...
    length(n2_500_25),length(n2_1000_25),...
    length(n2_5000_25),length(n2_10000_25)]);
data_25 = NaN(rows_25,12);
data_25(1:length(n2_50_25),1) = n2_50_25(:,1);
data_25(1:length(n2_100_25),2) = n2_100_25(:,1);
data_25(1:length(n2_500_25),3) = n2_500_25(:,1);
data_25(1:length(n2_1000_25),4) = n2_1000_25(:,1);
data_25(1:length(n2_5000_25),5) = n2_5000_25(:,1);
data_25(1:length(n2_10000_25),6) = n2_10000_25(:,1);
data_25(1:length(n2_50_25),7) = n2_50_25(:,2);
data_25(1:length(n2_100_25),8) = n2_100_25(:,2);
data_25(1:length(n2_500_25),9) = n2_500_25(:,2);
data_25(1:length(n2_1000_25),10) = n2_1000_25(:,2);
data_25(1:length(n2_5000_25),11) = n2_5000_25(:,2);
data_25(1:length(n2_10000_25),12) = n2_10000_25(:,2);


rows_35 = max([length(n2_50_35),length(n2_100_35),...
    length(n2_500_35),length(n2_1000_35),...
    length(n2_5000_35),length(n2_10000_35)]);
data_35 = NaN(rows_35,12);
data_35(1:length(n2_50_35),1) = n2_50_35(:,1);
data_35(1:length(n2_100_35),2) = n2_100_35(:,1);
data_35(1:length(n2_500_35),3) = n2_500_35(:,1);
data_35(1:length(n2_1000_35),4) = n2_1000_35(:,1);
data_35(1:length(n2_5000_35),5) = n2_5000_35(:,1);
data_35(1:length(n2_10000_35),6) = n2_10000_35(:,1);
data_35(1:length(n2_50_35),7) = n2_50_35(:,2);
data_35(1:length(n2_100_35),8) = n2_100_35(:,2);
data_35(1:length(n2_500_35),9) = n2_500_35(:,2);
data_35(1:length(n2_1000_35),10) = n2_1000_35(:,2);
data_35(1:length(n2_5000_35),11) = n2_5000_35(:,2);
data_35(1:length(n2_10000_35),12) = n2_10000_35(:,2);


rows_spc1 = max([length(spc1_50_25),length(spc1_100_25),...
    length(spc1_500_25),length(spc1_1000_25),...
    length(spc1_5000_25),length(spc1_10000_25)]);
data_spc1 = NaN(rows_spc1,12);
data_spc1(1:length(spc1_50_25),1) = spc1_50_25(:,1);
data_spc1(1:length(spc1_100_25),2) = spc1_100_25(:,1);
data_spc1(1:length(spc1_500_25),3) = spc1_500_25(:,1);
data_spc1(1:length(spc1_1000_25),4) = spc1_1000_25(:,1);
data_spc1(1:length(spc1_5000_25),5) = spc1_5000_25(:,1);
data_spc1(1:length(spc1_10000_25),6) = spc1_10000_25(:,1);
data_spc1(1:length(spc1_50_25),7) = spc1_50_25(:,2);
data_spc1(1:length(spc1_100_25),8) = spc1_100_25(:,2);
data_spc1(1:length(spc1_500_25),9) = spc1_500_25(:,2);
data_spc1(1:length(spc1_1000_25),10) = spc1_1000_25(:,2);
data_spc1(1:length(spc1_5000_25),11) = spc1_5000_25(:,2);
data_spc1(1:length(spc1_10000_25),12) = spc1_10000_25(:,2);    


directoryDesktop = '/Users/emazzochette/Desktop';
save(fullfile(directoryDesktop,'n2_25_data.mat'),'data_25');
save(fullfile(directoryDesktop,'n2_35_data.mat'),'data_35');
save(fullfile(directoryDesktop,'spc1_25_data.mat'),'data_spc1');

%% Make Plots

means_25 = nanmean(data_25,1);
means_35 = nanmean(data_35,1);
means_spc1 = nanmean(data_spc1,1);
samples_25 = sum(~isnan(data_25),1);
samples_35 = sum(~isnan(data_35),1);
samples_spc1 = sum(~isnan(data_spc1),1);

forceLabels = {'50 nN', '100 nN', '500 nN', '1000 nN', '5000 nN', '10,000 nN'};
close all
figure(1)
bp_25_deltaV = boxplot_pwhisker(data_25(:,1:6),{'labels',forceLabels,'colors','k'},10,90);
set(bp_25_deltaV,'LineWidth',2.5)
set(gca,'FontSize',16);
ylim([0 6]);
[xNew yNew] = MiriamAxes(gca,'xy');
set(xNew,'XTickLabel','');
for n = 1:6
    text(n-0.2, 90, sprintf('(%d)', samples_25(n)), 'FontSize',16);
end
% set(xNew,'XTickLabel',{num2str(sum(~isnan(data_25(:,1)))),...
%     num2str(sum(~isnan(data_25(:,2)))), num2str(sum(~isnan(data_25(:,3)))),...
%     num2str(sum(~isnan(data_25(:,4)))), num2str(sum(~isnan(data_25(:,5)))),...
%     num2str(sum(~isnan(data_25(:,6))))})

figure(2)
bp_25_revAcc = boxplot_pwhisker(data_25(:,7:12),{'labels',forceLabels,'colors','k'},10,90);
set(bp_25_revAcc,'LineWidth',2.5)
set(gca,'FontSize',16);
ylim([ 0 1100]);
[xNew yNew] = MiriamAxes(gca,'xy');
set(xNew,'XTickLabel','');
for n = 7:12
    text(n-6.2, 90, sprintf('(%d)', samples_25(n)), 'FontSize',16);
end
% set(xNew,'XTickLabel',{num2str(sum(~isnan(data_25(:,7)))),...
%     num2str(sum(~isnan(data_25(:,8)))), num2str(sum(~isnan(data_25(:,9)))),...
%     num2str(sum(~isnan(data_25(:,10)))), num2str(sum(~isnan(data_25(:,11)))),...
%     num2str(sum(~isnan(data_25(:,12))))});

figure(3)
bp_35_deltaV = boxplot_pwhisker(data_35(:,1:6),{'labels',forceLabels,'colors','k'},10,90);
set(bp_35_deltaV,'LineWidth',2.5)
set(gca,'FontSize',16);
ylim([ 0 6]);
[xNew yNew] = MiriamAxes(gca,'xy');
set(xNew,'XTickLabel','');
for n = 1:6
    text(n-0.2, 90, sprintf('(%d)', samples_35(n)), 'FontSize',16);
end
% set(xNew,'XTickLabel',{num2str(sum(~isnan(data_35(:,1)))),...
%     num2str(sum(~isnan(data_35(:,2)))), num2str(sum(~isnan(data_35(:,3)))),...
%     num2str(sum(~isnan(data_35(:,4)))), num2str(sum(~isnan(data_35(:,5)))),...
%     num2str(sum(~isnan(data_35(:,6))))})

figure(4)
bp_35_revAcc = boxplot_pwhisker(data_35(:,7:12),{'labels',forceLabels,'colors','k'},10,90);
set(bp_35_revAcc,'LineWidth',2.5)
set(gca,'FontSize',16);
ylim([ 0 1100]);
[xNew yNew] = MiriamAxes(gca,'xy');
set(xNew,'XTickLabel','');
for n = 7:12
    text(n-6.2, 90, sprintf('(%d)', samples_35(n)), 'FontSize',16);
end
% set(xNew,'XTickLabel',{num2str(sum(~isnan(data_35(:,7)))),...
%     num2str(sum(~isnan(data_35(:,8)))), num2str(sum(~isnan(data_35(:,9)))),...
%     num2str(sum(~isnan(data_35(:,10)))), num2str(sum(~isnan(data_35(:,11)))),...
%     num2str(sum(~isnan(data_35(:,12))))});


figure(5)
bp_spc1_deltaV = boxplot_pwhisker(data_spc1(:,1:6),{'labels',forceLabels,'colors','k'},10,90);
hold on
plot([1:6],means_25(1:6),'Color',[225/225 0 0 ],'LineStyle','none','Marker','*','MarkerSize',10)
set(bp_spc1_deltaV,'LineWidth',2.5)
set(gca,'FontSize',16);
ylim([ 0 6]);
[xNew yNew] = MiriamAxes(gca,'xy');
set(xNew,'XTickLabel','');
for n = 1:6
    text(n-0.2, 90, sprintf('(%d)', samples_spc1(n)), 'FontSize',16);
end
% set(xNew,'XTickLabel',{num2str(sum(~isnan(data_spc1(:,1)))),...
%     num2str(sum(~isnan(data_spc1(:,2)))), num2str(sum(~isnan(data_spc1(:,3)))),...
%     num2str(sum(~isnan(data_spc1(:,4)))), num2str(sum(~isnan(data_spc1(:,5)))),...
%     num2str(sum(~isnan(data_spc1(:,6))))})

figure(6)
bp_spc1_revAcc = boxplot_pwhisker(data_spc1(:,7:12),{'labels',forceLabels,'colors','k'},10,90);
hold on
plot([1:6],means_25(7:12),'Color',[225/225 0 0 ],'LineStyle','none','Marker','*','MarkerSize',10)
set(bp_spc1_revAcc,'LineWidth',2.5)
set(gca,'FontSize',16);
ylim([ 0 2000]);
[xNew yNew] = MiriamAxes(gca,'xy');
set(xNew,'XTickLabel','');
for n = 7:12
    text(n-6.2, 90, sprintf('(%d)', samples_spc1(n)), 'FontSize',16);
end
% set(xNew,'XTickLabel',{num2str(sum(~isnan(data_spc1(:,7)))),...
%     num2str(sum(~isnan(data_spc1(:,8)))), num2str(sum(~isnan(data_spc1(:,9)))),...
%     num2str(sum(~isnan(data_spc1(:,10)))), num2str(sum(~isnan(data_spc1(:,11)))),...
%     num2str(sum(~isnan(data_spc1(:,12))))});

%% Anova analysis

directoryDesktop = '/Users/emazzochette/Desktop';
load(fullfile(directoryDesktop,'n2_25_data.mat'),'data_25');
load(fullfile(directoryDesktop,'n2_35_data.mat'),'data_35');
load(fullfile(directoryDesktop,'spc1_25_data.mat'),'data_spc1');


treatments = {'Force','Target'};
% deltaV metric:
totalRows = max( size(data_25(:,1:6),1), size(data_35(:,1:6),1));
forceLabels_25(1:size(data_25(:,1:6),1),1) =  {'50'};
forceLabels_25(1*size(data_25(:,1:6),1)+1:2*size(data_25(:,1:6),1),1) =  {'100'};
forceLabels_25(2*size(data_25(:,1:6),1)+1:3*size(data_25(:,1:6),1),1) =  {'500'};
forceLabels_25(3*size(data_25(:,1:6),1)+1:4*size(data_25(:,1:6),1),1) =  {'1000'};
forceLabels_25(4*size(data_25(:,1:6),1)+1:5*size(data_25(:,1:6),1),1) =  {'5000'};
forceLabels_25(5*size(data_25(:,1:6),1)+1:6*size(data_25(:,1:6),1),1) =  {'10000'};
forceLabels_35(1:size(data_35(:,1:6),1),1) =  {'50'};
forceLabels_35(1*size(data_35(:,1:6),1)+1:2*size(data_35(:,1:6),1),1) =  {'100'};
forceLabels_35(2*size(data_35(:,1:6),1)+1:3*size(data_35(:,1:6),1),1) =  {'500'};
forceLabels_35(3*size(data_35(:,1:6),1)+1:4*size(data_35(:,1:6),1),1) =  {'1000'};
forceLabels_35(4*size(data_35(:,1:6),1)+1:5*size(data_35(:,1:6),1),1) =  {'5000'};
forceLabels_35(5*size(data_35(:,1:6),1)+1:6*size(data_35(:,1:6),1),1) =  {'10000'};
forceLabels = [forceLabels_25; forceLabels_35];

targetLabels(1:length(forceLabels_25),1) = {'25'};
targetLabels(length(forceLabels_25)+1:length(forceLabels_25)+length(forceLabels_35),1) = {'35'};

deltaVData = [data_25(:,1); data_25(:,2); data_25(:,3);...
    data_25(:,4); data_25(:,5); data_25(:,6);...
    data_35(:,1); data_35(:,2); data_35(:,3);...
    data_35(:,4); data_35(:,5); data_35(:,6)];

[P,T,STATS,TERMS] = anovan(deltaVData,{forceLabels targetLabels},'model',2,'varnames',treatments,'sstype',3);


%%
treatments_strain = {'Force','Strain'};
% deltaV metric:
totalRows = max( size(data_25(:,1:6),1), size(data_spc1(:,1:6),1));
forceLabels_25(1:size(data_25(:,1:6),1),1) =  {'50'};
forceLabels_25(1*size(data_25(:,1:6),1)+1:2*size(data_25(:,1:6),1),1) =  {'100'};
forceLabels_25(2*size(data_25(:,1:6),1)+1:3*size(data_25(:,1:6),1),1) =  {'500'};
forceLabels_25(3*size(data_25(:,1:6),1)+1:4*size(data_25(:,1:6),1),1) =  {'1000'};
forceLabels_25(4*size(data_25(:,1:6),1)+1:5*size(data_25(:,1:6),1),1) =  {'5000'};
forceLabels_25(5*size(data_25(:,1:6),1)+1:6*size(data_25(:,1:6),1),1) =  {'10000'};
forceLabels_spc1(1:size(data_spc1(:,1:6),1),1) =  {'50'};
forceLabels_spc1(1*size(data_spc1(:,1:6),1)+1:2*size(data_spc1(:,1:6),1),1) =  {'100'};
forceLabels_spc1(2*size(data_spc1(:,1:6),1)+1:3*size(data_spc1(:,1:6),1),1) =  {'500'};
forceLabels_spc1(3*size(data_spc1(:,1:6),1)+1:4*size(data_spc1(:,1:6),1),1) =  {'1000'};
forceLabels_spc1(4*size(data_spc1(:,1:6),1)+1:5*size(data_spc1(:,1:6),1),1) =  {'5000'};
forceLabels_spc1(5*size(data_spc1(:,1:6),1)+1:6*size(data_spc1(:,1:6),1),1) =  {'10000'};
forceLabels = [forceLabels_25; forceLabels_spc1];

strainLabels(1:length(forceLabels_25),1) = {'N2'};
strainLabels(length(forceLabels_25)+1:length(forceLabels_25)+length(forceLabels_spc1),1) = {'spc1'};

deltaVData_strain = [data_25(:,1); data_25(:,2); data_25(:,3);...
    data_25(:,4); data_25(:,5); data_25(:,6);...
    data_spc1(:,1); data_spc1(:,2); data_spc1(:,3);...
    data_spc1(:,4); data_spc1(:,5); data_spc1(:,6)];

[P,T,STATS,TERMS] = anovan(deltaVData_strain,{forceLabels strainLabels},'model',2,'varnames',treatments_strain,'sstype',3);

%%

treatments = {'Force','Target'};
% deltaV metric:
totalRows = max( size(data_25(:,1:6),1), size(data_35(:,1:6),1));
forceLabels_25(1:size(data_25(:,1:6),1),1) =  {'50'};
forceLabels_25(1*size(data_25(:,1:6),1)+1:2*size(data_25(:,1:6),1),1) =  {'100'};
forceLabels_25(2*size(data_25(:,1:6),1)+1:3*size(data_25(:,1:6),1),1) =  {'500'};
forceLabels_25(3*size(data_25(:,1:6),1)+1:4*size(data_25(:,1:6),1),1) =  {'1000'};
forceLabels_25(4*size(data_25(:,1:6),1)+1:5*size(data_25(:,1:6),1),1) =  {'5000'};
forceLabels_25(5*size(data_25(:,1:6),1)+1:6*size(data_25(:,1:6),1),1) =  {'10000'};
forceLabels_35(1:size(data_35(:,1:6),1),1) =  {'50'};
forceLabels_35(1*size(data_35(:,1:6),1)+1:2*size(data_35(:,1:6),1),1) =  {'100'};
forceLabels_35(2*size(data_35(:,1:6),1)+1:3*size(data_35(:,1:6),1),1) =  {'500'};
forceLabels_35(3*size(data_35(:,1:6),1)+1:4*size(data_35(:,1:6),1),1) =  {'1000'};
forceLabels_35(4*size(data_35(:,1:6),1)+1:5*size(data_35(:,1:6),1),1) =  {'5000'};
forceLabels_35(5*size(data_35(:,1:6),1)+1:6*size(data_35(:,1:6),1),1) =  {'10000'};
forceLabels = [forceLabels_25; forceLabels_35];

targetLabels(1:length(forceLabels_25),1) = {'25'};
targetLabels(length(forceLabels_25)+1:length(forceLabels_25)+length(forceLabels_35),1) = {'35'};
revAccData = [data_25(:,7); data_25(:,8); data_25(:,9);...
    data_25(:,10); data_25(:,11); data_25(:,12);...
    data_35(:,7); data_35(:,8); data_35(:,9);...
    data_35(:,10); data_35(:,11); data_35(:,12)];

[P,T,STATS,TERMS] = anovan(revAccData,{forceLabels targetLabels},'model',2,'varnames',treatments,'sstype',3);


%%
treatments_strain = {'Force','Strain'};
% deltaV metric:
totalRows = max( size(data_25(:,1:6),1), size(data_spc1(:,1:6),1));
forceLabels_25(1:size(data_25(:,1:6),1),1) =  {'50'};
forceLabels_25(1*size(data_25(:,1:6),1)+1:2*size(data_25(:,1:6),1),1) =  {'100'};
forceLabels_25(2*size(data_25(:,1:6),1)+1:3*size(data_25(:,1:6),1),1) =  {'500'};
forceLabels_25(3*size(data_25(:,1:6),1)+1:4*size(data_25(:,1:6),1),1) =  {'1000'};
forceLabels_25(4*size(data_25(:,1:6),1)+1:5*size(data_25(:,1:6),1),1) =  {'5000'};
forceLabels_25(5*size(data_25(:,1:6),1)+1:6*size(data_25(:,1:6),1),1) =  {'10000'};
forceLabels_spc1(1:size(data_spc1(:,1:6),1),1) =  {'50'};
forceLabels_spc1(1*size(data_spc1(:,1:6),1)+1:2*size(data_spc1(:,1:6),1),1) =  {'100'};
forceLabels_spc1(2*size(data_spc1(:,1:6),1)+1:3*size(data_spc1(:,1:6),1),1) =  {'500'};
forceLabels_spc1(3*size(data_spc1(:,1:6),1)+1:4*size(data_spc1(:,1:6),1),1) =  {'1000'};
forceLabels_spc1(4*size(data_spc1(:,1:6),1)+1:5*size(data_spc1(:,1:6),1),1) =  {'5000'};
forceLabels_spc1(5*size(data_spc1(:,1:6),1)+1:6*size(data_spc1(:,1:6),1),1) =  {'10000'};
forceLabels = [forceLabels_25; forceLabels_spc1];

strainLabels(1:length(forceLabels_25),1) = {'N2'};
strainLabels(length(forceLabels_25)+1:length(forceLabels_25)+length(forceLabels_spc1),1) = {'spc1'};

revAccData_strain = [data_25(:,7); data_25(:,8); data_25(:,9);...
    data_25(:,10); data_25(:,11); data_25(:,12);...
    data_spc1(:,7); data_spc1(:,8); data_spc1(:,9);...
    data_spc1(:,10); data_spc1(:,11); data_spc1(:,12)];

[P,T,STATS,TERMS] = anovan(revAccData_strain,{forceLabels strainLabels},'model',2,'varnames',treatments_strain,'sstype',3);



