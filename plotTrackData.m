function plotTrackData(Stimulus, numStims, directory)
    acquisitionInterval = 0.001;
    transmitInterval = 0.001;
    timeBounds = [-0.5 30.5]; 
    vertBounds = [-Inf Inf];
    for stim = 1:numStims
        figHandle = figure(stim);
        set(figHandle, 'Position', [100, 100, 1500, 895]);

        timeTracking = Stimulus(stim).timeData(:,8) - Stimulus(stim).StimulusTiming.stimAppliedTime;
        if  isempty(find(timeTracking>timeBounds(2), 1))
            framesTracking = [find(timeTracking>timeBounds(1),1) : length(timeTracking)];
        else
            framesTracking = [find(timeTracking>timeBounds(1),1) :  find(timeTracking>timeBounds(2), 1)];
        end
        %Trajectory plot:

        subplot('position',[0.1 0.55 0.35 0.35])  
        plot(Stimulus(stim).CurvatureAnalysis.velocitySmoothed,Stimulus(stim).Trajectory.amplitude,'.')
        title(['Velocity vs. Amplitude'], 'FontSize' , 18)
        axis equal;
        ylabel('Amplitude (um)', 'FontSize' , 16)
        xlabel('Velocity (um/s)', 'FontSize' , 16)
        set(gca, 'FontSize',14)



        subplot('position',[0.55 0.55 0.35 0.35])
        plot(Stimulus(stim).CurvatureAnalysis.velocitySmoothed,Stimulus(stim).Trajectory.wavelength,'.')
        title(['Velocity vs. Wavelength'], 'FontSize' , 18)
        ylabel('Wavelength (um)', 'FontSize', 16)
        xlabel('Velocity (um/s)', 'FontSize' , 16)
        set(gca, 'FontSize',14)

        subplot('position',[0.1 0.1 0.35 0.35])   
        plot(Stimulus(stim).CurvatureAnalysis.acceleration,Stimulus(stim).Trajectory.amplitude(2:end),'.')
        title(['Acceleration vs. Amplitude'], 'FontSize' , 18)
        ylabel('Amplitude (um)', 'FontSize' , 16)
        xlabel('Acceleration (um/s^2)', 'FontSize' , 16)
        set(gca, 'FontSize',14)
        
        subplot('position',[0.55 0.1 0.35 0.35])
        plot(Stimulus(stim).CurvatureAnalysis.acceleration,Stimulus(stim).Trajectory.wavelength(2:end),'.')
        title(['Acceleration vs. Wavelength'], 'FontSize' , 18)
        ylabel('Wavelength (um)', 'FontSize', 16)
        xlabel('Accerelation (um/s^2)', 'FontSize' , 16)
        set(gca, 'FontSize',14)

        aspectRatio = 1500/895; %width/height
        width = 50;
        experimentTitle = getExperimentTitle(directory);
        filename = strcat(experimentTitle,'_Stimulus_TrackData',num2str(stim),'.png');
        set(gcf, 'PaperUnits', 'centimeters');
        set(gcf, 'PaperPosition', [0 0 width width/aspectRatio]); %x_width=10cm y_width=15cm

        saveas(gcf,fullfile(directory,filename));
    end

 
    close all
end