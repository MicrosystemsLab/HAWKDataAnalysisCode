
close all
clear all
PRE_STIM_FRAMES = 15;
mult = -1;
axisFontSize = 20;
plotWidth = 725;
plotHeight_small = 183;
plotHeight_tall = plotHeight_small*650/350;

directory = '/Users/emazzochette/Documents/MicrosystemsResearch/PaperSubmissions/HAWK Demonstration Manuscript/Figures/Figure2';

blueColor = [55/255 126/255 184/255];
purpleColor = [152/255 78/255 163/255];
% stimOnFrame = Stimulus(stim).StimulusTiming.stimOnFrame;
% stimOnTime = Stimulus(stim).timeData(stimOnFrame,8);
% stimOffFrame = Stimulus(stim).StimulusTiming.stimOffFrame;
% stimOffTime = Stimulus(stim).timeData(stimOffFrame,8);
% 
% if length(Stimulus(stim).FramesByStimulus.PreStimFrames) < PRE_STIM_FRAMES
%     cutoff = length(Stimulus(stim).FramesByStimulus.PreStimFrames) - 1;
% else
%     cutoff = PRE_STIM_FRAMES-1;
% end
% 
% preStimTime = stimOnTime - Stimulus(stim).timeData(stimOnFrame-cutoff,8);
% postStimTime = stimOffTime - stimOnTime;
% timeBounds = [-preStimTime 5]; %want to look at just 1.5 second before stim to 5 second after stim
% 
% timeTracking = Stimulus(stim).timeData(:,8) - Stimulus(stim).StimulusTiming.stimAppliedTime;
% framesTracking = [find(timeTracking>timeBounds(1),1) : find(timeTracking>timeBounds(2), 1)];



%% Reversal:
load('/Volumes/Backup Disc Celegans/HAWKData/Force Clamp/DataSet3/N2/2015_05_02__17_56_25__WT_FC_5000_25/2015_05_02__17_56_25__WT_FC_5000_25_DataByStimulus.mat')
stim = 2;

stimOnFrame = Stimulus(stim).StimulusTiming.stimOnFrame;
stimOnTime = Stimulus(stim).timeData(stimOnFrame,8);
stimOffFrame = Stimulus(stim).StimulusTiming.stimOffFrame;
stimOffTime = Stimulus(stim).timeData(stimOffFrame,8);

if length(Stimulus(stim).FramesByStimulus.PreStimFrames) < PRE_STIM_FRAMES
    cutoff = length(Stimulus(stim).FramesByStimulus.PreStimFrames) - 1;
else
    cutoff = PRE_STIM_FRAMES-1;
end

preStimTime = stimOnTime - Stimulus(stim).timeData(stimOnFrame-cutoff,8);
postStimTime = stimOffTime - stimOnTime;
timeBounds = [-preStimTime 5]; %want to look at just 1.5 second before stim to 5 second after stim

timeTracking = Stimulus(stim).timeData(:,8) - Stimulus(stim).StimulusTiming.stimAppliedTime;
framesTracking = [find(timeTracking>timeBounds(1),1) : find(timeTracking>timeBounds(2), 1)];


figure(1)
plot(timeTracking(framesTracking), mult.*Stimulus(stim).CurvatureAnalysis.velocitySmoothed(framesTracking), 'LineWidth', 3,'Color', 'k','LineStyle', '-','Marker','none');
hold on
plot([-preStimTime 0], mult.*[Stimulus(stim).Response.preStimSpeed Stimulus(stim).Response.preStimSpeed], 'LineWidth', 3,'Color', blueColor,'LineStyle', '-','Marker','none');
plot([0 timeTracking(framesTracking(end))], mult.*[Stimulus(stim).Response.preStimSpeed Stimulus(stim).Response.preStimSpeed], 'LineWidth', 3,'Color', blueColor,'LineStyle', ':','Marker','none');
set(gca,'yLim',[-300 350]);
[xNew yNew] = MiriamAxes(gca,'xy');
set(xNew,'FontSize',axisFontSize);
set(yNew,'FontSize',axisFontSize);

x0 = 50;
y0 = 50;
set(gcf,'units','points','position',[x0,y0,plotWidth,plotHeight_tall]);

% saveas(gcf,fullfile(directory,'VelocityTrace_Reversal.png'));

%% Speed Up:
load('/Volumes/Backup Disc Celegans/HAWKData/Force Clamp/DataSet3/N2/2015_08_19__15_37_27__WT_FC_10000_75/2015_08_19__15_37_27__WT_FC_10000_75_DataByStimulus.mat')
stim = 3;

stimOnFrame = Stimulus(stim).StimulusTiming.stimOnFrame;
stimOnTime = Stimulus(stim).timeData(stimOnFrame,8);
stimOffFrame = Stimulus(stim).StimulusTiming.stimOffFrame;
stimOffTime = Stimulus(stim).timeData(stimOffFrame,8);

if length(Stimulus(stim).FramesByStimulus.PreStimFrames) < PRE_STIM_FRAMES
    cutoff = length(Stimulus(stim).FramesByStimulus.PreStimFrames) - 1;
else
    cutoff = PRE_STIM_FRAMES-1;
end

preStimTime = stimOnTime - Stimulus(stim).timeData(stimOnFrame-cutoff,8);
postStimTime = stimOffTime - stimOnTime;
timeBounds = [-preStimTime 5]; %want to look at just 1.5 second before stim to 5 second after stim

timeTracking = Stimulus(stim).timeData(:,8) - Stimulus(stim).StimulusTiming.stimAppliedTime;
framesTracking = [find(timeTracking>timeBounds(1),1) : find(timeTracking>timeBounds(2), 1)];

figure(2)
plot(timeTracking(framesTracking), mult.*Stimulus(stim).CurvatureAnalysis.velocitySmoothed(framesTracking), 'LineWidth', 3,'Color', 'k','LineStyle', '-','Marker','none');
hold on
plot([-preStimTime 0], mult.*[Stimulus(stim).Response.preStimSpeed Stimulus(stim).Response.preStimSpeed], 'LineWidth', 3,'Color', blueColor,'LineStyle', '-','Marker','none');
plot([0 timeTracking(framesTracking(end))], mult.*[Stimulus(stim).Response.preStimSpeed Stimulus(stim).Response.preStimSpeed], 'LineWidth', 3,'Color', blueColor,'LineStyle', ':','Marker','none');
set(gca,'yLim',[0 350]);
[xNew yNew] = MiriamAxes(gca,'xy');
set(xNew,'FontSize',axisFontSize);
set(yNew,'FontSize',axisFontSize);
set(yNew,'YTick',[0:100:300])
x0 = 600;
y0 = 50;
set(gcf,'units','points','position',[x0,y0,plotWidth,plotHeight_small]);
% saveas(gcf,fullfile(directory,'VelocityTrace_SpeedUp.png'));
%% Pause:
load('/Volumes/Backup Disc Celegans/HAWKData/Force Clamp/DataSet3/N2/2015_07_30__17_39_47__WT_FC_100_25/2015_07_30__17_39_47__WT_FC_100_25_DataByStimulus.mat')
stim = 3;

stimOnFrame = Stimulus(stim).StimulusTiming.stimOnFrame;
stimOnTime = Stimulus(stim).timeData(stimOnFrame,8);
stimOffFrame = Stimulus(stim).StimulusTiming.stimOffFrame;
stimOffTime = Stimulus(stim).timeData(stimOffFrame,8);

if length(Stimulus(stim).FramesByStimulus.PreStimFrames) < PRE_STIM_FRAMES
    cutoff = length(Stimulus(stim).FramesByStimulus.PreStimFrames) - 1;
else
    cutoff = PRE_STIM_FRAMES-1;
end

preStimTime = stimOnTime - Stimulus(stim).timeData(stimOnFrame-cutoff,8);
postStimTime = stimOffTime - stimOnTime;
timeBounds = [-preStimTime 5]; %want to look at just 1.5 second before stim to 5 second after stim

timeTracking = Stimulus(stim).timeData(:,8) - Stimulus(stim).StimulusTiming.stimAppliedTime;
framesTracking = [find(timeTracking>timeBounds(1),1) : find(timeTracking>timeBounds(2), 1)];

figure(3)
plot(timeTracking(framesTracking), mult.*Stimulus(stim).CurvatureAnalysis.velocitySmoothed(framesTracking), 'LineWidth', 3,'Color', 'k','LineStyle', '-','Marker','none');
hold on
plot([-preStimTime 0], mult.*[Stimulus(stim).Response.preStimSpeed Stimulus(stim).Response.preStimSpeed], 'LineWidth', 3,'Color', blueColor,'LineStyle', '-','Marker','none');
plot([0 timeTracking(framesTracking(end))], mult.*[Stimulus(stim).Response.preStimSpeed Stimulus(stim).Response.preStimSpeed], 'LineWidth', 3,'Color',blueColor,'LineStyle', ':','Marker','none');
plot([Stimulus(stim).timeData(stimOnFrame+1,9) postStimTime], mult.*[Stimulus(stim).Response.postStimSpeed Stimulus(stim).Response.postStimSpeed],'LineWidth', 3,'Color', purpleColor,'LineStyle', ':','Marker','none');
set(gca,'yLim',[0 350]);
[xNew yNew] = MiriamAxes(gca,'xy');
set(xNew,'FontSize',axisFontSize);
set(yNew,'FontSize',axisFontSize);
set(yNew,'YTick',[0:100:300])
x0 = 1200;
y0 = 50;
set(gcf,'units','points','position',[x0,y0,plotWidth,plotHeight_small]);
% saveas(gcf,fullfile(directory,'VelocityTrace_Pause.png'));