

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

load('/Users/emazzochette/Desktop/DeltaVTraces.mat')
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
for trial = 1:10 %totalTrials_N2
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
    if (isempty(force) || ~ismember(target,[1, 2]))
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
for trials = 1:10 %totalTrials_spc1
   
    
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
    
    