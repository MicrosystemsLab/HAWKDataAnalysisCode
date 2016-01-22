txtFile_expNames = '/Users/emazzochette/Desktop/experimentNames.txt';
txtFile_stimNums = '/Users/emazzochette/Desktop/stimNumbers.txt';
txtFile_trialScore = '/Users/emazzochette/Desktop/finalTrialScores.txt';

expNames = textscan(fopen(txtFile_expNames),'%s');
stimNums = textscan(fopen(txtFile_stimNums),'%d');
trialScore = textscan(fopen(txtFile_trialScore),'%s');

totalTrials = length(expNames{1,1});
directory = '/Volumes/Backup Disc Celegans/HAWKData/Force Clamp/DataSet3/N2';

%%
Forces = [50 100 500 1000 5000 10000];
numForces = length(Forces);
interval = 0.001;
time = -0.1:interval:0.50;
prePoints = length(find(time<0));
%%
for force = 1:length(Forces)
    Profiles.(['Force_',num2str(Forces(force))]) = [];
end

%% 
for trial = 1:totalTrials
    if (trial<2 || ~strcmp(expNames{1,1}{trial,1},expNames{1,1}{trial-1,1}))
        filenameStim = strcat(expNames{1,1}{trial,1},'_DataByStimulus.mat');
        filenameTracking = strcat(expNames{1,1}{trial,1},'_tracking_parsedData.mat');
        filenameStimData = strcat(expNames{1,1}{trial,1},'_stimulus_parsedData.mat');
        load(fullfile(directory,expNames{1,1}{trial,1},filenameStim));
        load(fullfile(directory,expNames{1,1}{trial,1},filenameTracking));
        load(fullfile(directory,expNames{1,1}{trial,1},filenameStimData));
             
        
        cantileverSensitivity = TrackingData.CantileverProperties.Sensitivity;
        if strcmp(TrackingData.CantileverProperties.SerialNumber,'EM10A1306')
            cantileverSensitivity = 8.9781;
        end
        % Cantilever Stiffness = N/m
        cantileverStiffness = TrackingData.CantileverProperties.Stiffness;

    end

    force = find(Forces == StimulusData.Magnitude,1);
    if isempty(force)
       continue;
    end
    if strcmp(trialScore{1,1}{trial,1},'TRUE')
        
        stim = stimNums{1,1}(trial);

        startIndex = Stimulus(stim).StimulusTiming.stimOnFPGAIndex;
        endIndex = startIndex + length(time);
        piezoData = [Stimulus(stim).FPGAData.PiezoSignal(startIndex-prePoints:endIndex)];
        softBalanceValue = Stimulus(stim).StimulusTiming.stimulusAnalysis.preApproachPoints.average;
        %Cantilever deflection = sensitivity * piezo signal = um
        cantileverDeflection = (piezoData-softBalanceValue) .* cantileverSensitivity;
        cantileverForce = cantileverDeflection .* cantileverStiffness ./ 1e6; %um .* N/m * m/um = N
        
        Profiles.(['Force_',num2str(Forces(force))]) =  [Profiles.(['Force_',num2str(Forces(force))]) ; cantileverForce] ;
        
        
    end

    
    
end
%%
Profiles.Ave_50 = mean(Profiles.Force_50,1);
Profiles.Ave_100 = mean(Profiles.Force_100,1);
Profiles.Ave_500 = mean(Profiles.Force_500,1);
Profiles.Ave_1000 = mean(Profiles.Force_1000,1);
Profiles.Ave_5000 = mean(Profiles.Force_5000,1);
Profiles.Ave_10000 = mean(Profiles.Force_10000,1);

%% 

figure(1) 
semilogy([time 0.5+interval:interval:601*0.001],Profiles.Ave_50*10^9,'LineWidth',3,'Color', [228/255 26/255 28/255])
hold on
semilogy([time 0.5+interval:interval:601*0.001],Profiles.Ave_100*10^9,'LineWidth',3,'Color', [55/255 126/255 184/255])
semilogy([time 0.5+interval:interval:601*0.001],Profiles.Ave_500*10^9,'LineWidth',3,'Color', [77/255 175/255 74/255])
semilogy([time 0.5+interval:interval:601*0.001],Profiles.Ave_1000*10^9,'LineWidth',3,'Color', [152/255 78/255 163/255])
semilogy([time 0.5+interval:interval:601*0.001],Profiles.Ave_5000*10^9,'LineWidth',3,'Color', [255/255 127/255 0/255])
semilogy([time 0.5+interval:interval:601*0.001],Profiles.Ave_10000*10^9,'LineWidth',3,'Color', [255/255 255/255 51/255])
axis([-0.03 0.1 10^-1 3e4])

legendCaptions = {strcat('\tau_{50} = ', num2str(19.93), ' s'); ...
strcat('\tau_{100} = ', num2str(23.29), ' s'); ...
strcat('\tau_{500} = ', num2str(4.952), ' s'); ...
strcat('\tau_{1,000} = ', num2str(13.04), ' s'); ...
strcat('\tau_{5,000} = ', num2str(30.27), ' s'); ...
strcat('\tau_{10,000} = ', num2str(33.89), ' s')};

legend(legendCaptions,'Location','SouthEast','FontSize',16)
set(gca,'FontSize',14,'FontWeight','Bold')

%%
ind = find(time>0.135,1,'first');
ind2 = find(time>0.207,1,'first');
timeVector = [time 0.5+interval:interval:601*0.001];
figure(2) 
semilogy(timeVector(1:ind),Profiles.Force_50(100,1:ind)*10^9,'LineWidth',3,'Color', [228/255 26/255 28/255])
hold on
semilogy(timeVector(1:ind),Profiles.Force_100(100,1:ind)*10^9,'LineWidth',3,'Color', [55/255 126/255 184/255])
semilogy(timeVector(1:ind),Profiles.Force_500(249,1:ind)*10^9,'LineWidth',3,'Color', [77/255 175/255 74/255])
semilogy(timeVector(1:ind),Profiles.Force_1000(100,1:ind)*10^9,'LineWidth',3,'Color', [152/255 78/255 163/255])
semilogy(timeVector(1:ind2),Profiles.Force_5000(100,1:ind2)*10^9,'LineWidth',3,'Color', [255/255 127/255 0/255])
semilogy(timeVector(1:ind2),Profiles.Force_10000(100,1:ind2)*10^9,'LineWidth',3,'Color', [255/255 255/255 51/255])
 axis([-0.01 0.22 10^-1 3e4])

legendCaptions = {strcat('\tau_{50} = ', num2str(19.93), ' ms'); ...
strcat('\tau_{100} = ', num2str(23.29), ' ms'); ...
strcat('\tau_{500} = ', num2str(4.952), ' ms'); ...
strcat('\tau_{1,000} = ', num2str(13.04), ' ms'); ...
strcat('\tau_{5,000} = ', num2str(30.27), ' ms'); ...
strcat('\tau_{10,000} = ', num2str(33.89), ' ms')};

legend(legendCaptions,'Location','SouthEast','FontSize',20)
set(gca,'FontSize',20,'FontWeight','Bold')
[newXAxis, newYAxis]= MiriamAxes(gca,'xy')
set(newYAxis,'yScale','log')
 axis([-0.01 0.22 10^-1 3e4])