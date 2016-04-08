%%%% Function plot track data
%  Plots the relationship between velocity, track wavelength, and track amplitude 
%
%  param {Stimulus} struct, contains experiment data organized by stimulus
%  param {numStims} int, the number of stimulus in this experiment.
%  param {directory} string, the location of the data files.
%
%  returns {Stimulus} struct,  contains experiment data organized by
%  stimulus, modified to include the sorted frames.
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%
%%%%%


function plotTrackData(Stimulus, numStims, directory)
    acquisitionInterval = 0.001;
    transmitInterval = 0.001;
    timeBounds = [-0.5 30.5]; 
    vertBounds = [-Inf Inf];
    for stim = 1:numStims
        figHandle = figure(stim);
        set(figHandle, 'Position', [100, 100, 1500, 895]);

        delta_Amplitude = diff(Stimulus(stim).Trajectory.amplitude')./diff(Stimulus(stim).timeData(:,8));
        
        timeTracking = Stimulus(stim).timeData(:,8) - Stimulus(stim).StimulusTiming.stimAppliedTime;
        if  isempty(find(timeTracking>timeBounds(2), 1))
            framesTracking = [find(timeTracking>timeBounds(1),1) : length(timeTracking)];
        else
            framesTracking = [find(timeTracking>timeBounds(1),1) :  find(timeTracking>timeBounds(2), 1)];
        end

        subplot('position',[0.375 0.55 0.267 0.35])
        plot(Stimulus(stim).CurvatureAnalysis.velocitySmoothed,Stimulus(stim).Trajectory.wavelength,'.')
        title(['Velocity vs. Wavelength'], 'FontSize' , 18)
        ylabel('Wavelength (um)', 'FontSize', 16)
        xlabel('Velocity (um/s)', 'FontSize' , 16)
        set(gca, 'FontSize',14)

        
        subplot('position',[0.05 0.55 0.267 0.35])  
        plot(Stimulus(stim).CurvatureAnalysis.velocitySmoothed,Stimulus(stim).Trajectory.amplitude,'.')
        title(['Velocity vs. Amplitude'], 'FontSize' , 18)
        axis equal;
        ylabel('Amplitude (um)', 'FontSize' , 16)
        xlabel('Velocity (um/s)', 'FontSize' , 16)
        set(gca, 'FontSize',14)


        
        subplot('position',[0.05 0.1 0.267 0.35])   
        plot(Stimulus(stim).CurvatureAnalysis.acceleration,Stimulus(stim).Trajectory.amplitude(2:end),'.')
        title(['Acceleration vs. Amplitude'], 'FontSize' , 18)
        ylabel('Amplitude (um)', 'FontSize' , 16)
        xlabel('Acceleration (um/s^2)', 'FontSize' , 16)
        set(gca, 'FontSize',14)
        
        subplot('position',[0.375 0.1 0.267 0.35])
        plot(Stimulus(stim).CurvatureAnalysis.acceleration,Stimulus(stim).Trajectory.wavelength(2:end),'.')
        title(['Acceleration vs. Wavelength'], 'FontSize' , 18)
        ylabel('Wavelength (um)', 'FontSize', 16)
        xlabel('Accerelation (um/s^2)', 'FontSize' , 16)
        set(gca, 'FontSize',14)
        
        subplot('position',[0.71 0.55 0.267 0.35])
        plot(Stimulus(stim).CurvatureAnalysis.velocitySmoothed(2:end),delta_Amplitude,'.');
        title(['Velocity vs. Change in Amplitude'], 'FontSize' , 18)
        ylabel('Change in Amplitude (um/s)', 'FontSize', 16);
        xlabel('Velocity (um/s)', 'FontSize' , 16);
        set(gca, 'FontSize',14);

        subplot('position',[0.71 0.1 0.267 0.35])
        plot(Stimulus(stim).CurvatureAnalysis.acceleration, delta_Amplitude,'.');
        title(['Acceleration vs. Change in Amplitude'], 'FontSize' , 18)
        ylabel('Change in Amplitude (um/s)', 'FontSize', 16);
        xlabel('Accerelation (um/s^2)', 'FontSize' , 16);
        set(gca, 'FontSize',14);
        
        aspectRatio = 1400/895; %width/height
        width = 40;
        experimentTitle = getExperimentTitle(directory);
        filename = strcat(experimentTitle,'_Stimulus_TrackData',num2str(stim),'.png');
        set(gcf, 'PaperUnits', 'centimeters');
        set(gcf, 'PaperPosition', [0 0 width width/aspectRatio]); %x_width=10cm y_width=15cm

        saveas(gcf,fullfile(directory,filename));
    end

 
    close all
end