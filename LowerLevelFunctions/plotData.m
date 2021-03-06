%%%% Function: plotData
%  Creates a set of plots describing the behavior and stimulus information
%  for each stimulus in the experiment. The plots are saved to the
%  directory.
%
%  param {Stimulus} struct, contains experiment data organized by stimulus
%  param {TrackingData} struct, contains experiment data
%  param {numStims} int, the number of stimulus in this experiment.
%  param {directory} string, the location of the data files
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%%%%%

function plotData(Stimulus, TrackingData, numStims, directory)
    HAWKProcessingConstants;
    acquisitionInterval = 0.001;
    transmitInterval = 0.001;
    
    vertBounds = [-Inf Inf];
    for stim = 1:numStims
        
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
        
        
        figHandle = figure(stim);
        set(figHandle, 'Position', [100, 100, 1500, 895]);

        % stimulus plot (need to do this first so that plot can be nested):       
        timeFPGA = [0:length(Stimulus(stim).FPGAData.PiezoSignal)-1] - Stimulus(stim).StimulusTiming.approachOnFPGAIndex;
        timeFPGA = timeFPGA*acquisitionInterval;
        timeFPGA = timeFPGA(1:find(timeFPGA>2,1));

        timeStim = [0:length(Stimulus(stim).FPGAData.VoltagesSentToFPGA)-1] + length(Stimulus(stim).StimulusTiming.stimulusAnalysis.approachPoints.data);
        timeStim = timeStim*transmitInterval;

        timeTracking = Stimulus(stim).timeData(:,8) - Stimulus(stim).StimulusTiming.stimAppliedTime;
        framesTracking = [find(timeTracking>timeBounds(1),1) : find(timeTracking>timeBounds(2), 1)];

        %Trajectory plot:
        subplot('position',[0.1 0.5 0.3 0.38])  
        goodFrames = Stimulus(stim).FrameScoring.GoodFrames;
        numGoodFrames = length(goodFrames);
        %pre stim:
        hold on 
        plot(Stimulus(stim).Trajectory.centroidPosition.x(Stimulus(stim).FramesByStimulus.PreStimFrames), Stimulus(stim).Trajectory.centroidPosition.y(Stimulus(stim).FramesByStimulus.PreStimFrames), 'r-', 'LineWidth',2);  
        plot(Stimulus(stim).Trajectory.meanPosition.x(Stimulus(stim).FramesByStimulus.PreStimFrames), Stimulus(stim).Trajectory.meanPosition.y(Stimulus(stim).FramesByStimulus.PreStimFrames), 'r:', 'LineWidth',2);  
        %during stim:
        hold on
        plot(Stimulus(stim).Trajectory.centroidPosition.x(Stimulus(stim).FramesByStimulus.DuringStimFrames), Stimulus(stim).Trajectory.centroidPosition.y(Stimulus(stim).FramesByStimulus.DuringStimFrames), 'b-', 'LineWidth',2); 
        plot(Stimulus(stim).Trajectory.meanPosition.x(Stimulus(stim).FramesByStimulus.DuringStimFrames), Stimulus(stim).Trajectory.meanPosition.y(Stimulus(stim).FramesByStimulus.DuringStimFrames), 'b:', 'LineWidth',2); 
        %post stim:
        hold on
        plot(Stimulus(stim).Trajectory.centroidPosition.x(Stimulus(stim).FramesByStimulus.PostStimFrames), Stimulus(stim).Trajectory.centroidPosition.y(Stimulus(stim).FramesByStimulus.PostStimFrames), 'k-', 'LineWidth',2); 
        plot(Stimulus(stim).Trajectory.meanPosition.x(Stimulus(stim).FramesByStimulus.PostStimFrames), Stimulus(stim).Trajectory.meanPosition.y(Stimulus(stim).FramesByStimulus.PostStimFrames), 'k:', 'LineWidth',2); 
        %first position:
        hold on
        plot(Stimulus(stim).Trajectory.centroidPosition.x(goodFrames(1)), Stimulus(stim).Trajectory.centroidPosition.y(goodFrames(1)), 'ro', 'MarkerSize',14);
        %last position:
        hold on
        plot(Stimulus(stim).Trajectory.centroidPosition.x(goodFrames( numGoodFrames)), Stimulus(stim).Trajectory.centroidPosition.y(goodFrames( numGoodFrames)), 'kx', 'MarkerSize',14);
        
        title(['Mid-Skeleton Position'], 'FontSize' , 18)
        axis equal;
        xlabel('x position (um)', 'FontSize' , 16)
        ylabel('y position (um)', 'FontSize' , 16)
%         legend('Pre Stimulus Mid-point Movement', 'Pre Stimulus Mean Movement', 'During Stimulus Mid-point Movement', 'During Stimulus Mean Movement', 'Post Stimulus Mid-point Movement', 'Post Stimulus Mean Movement','Start','End','Location','SouthWest');
        set(gca, 'FontSize',14)

        subplot('position',[0.6 0.7 0.3 0.2])   
        plot(timeFPGA,Stimulus(stim).FPGAData.DesiredSignal(1:find(timeFPGA>2,1)), 'LineWidth', 2);
            hold on
        plot(timeStim(1:length(Stimulus(stim).FPGAData.VoltagesSentToFPGA)),Stimulus(stim).FPGAData.VoltagesSentToFPGA, 'MarkerSize',3, 'Color',[1 0 0]);
        title('Desired Stimulus', 'FontSize', 18);
        xlabel('Time (s)', 'FontSize', 16);
        ylabel('Voltage (V)', 'FontSize', 16);
        set(gca, 'FontSize',14)

        subplot('position',[0.6 0.4 0.3 0.2])  
        plot(timeFPGA,Stimulus(stim).FPGAData.PiezoSignal(1:find(timeFPGA>2,1)), 'LineWidth', 2);
        title('Piezo resistor signal', 'FontSize', 18);
        xlabel('Time (s)', 'FontSize', 16);
        ylabel('Voltage (V)', 'FontSize', 16);
        set(gca, 'FontSize',14)
        %Add: statistics: rise time, others?

        subplot('position',[0.6 0.1 0.3 0.2])
        imagesc(framesTracking-find(Stimulus(stim).StimulusActivity==1,1),[0:2:99],Stimulus(stim).CurvatureAnalysis.curvatureimage.img(:,framesTracking,:))
        xlabel('Frame', 'FontSize', 16)
        ylabel('% Body Length', 'FontSize', 16)
        set(gca, 'FontSize',14)
%             axis([timeBounds vertBounds])

        subplot('position',[0.1 0.1 0.4 0.2])
%         mult = sign(Stimulus(stim).CurvatureAnalysis.velocity(framesTracking(1)));
        mult = -1;
        plot(timeTracking(framesTracking), mult.*Stimulus(stim).CurvatureAnalysis.velocity(framesTracking),'LineWidth', 2,'Color', 'm','LineStyle', ':','Marker','none');
        hold on
        plot(timeTracking(framesTracking), mult.*Stimulus(stim).CurvatureAnalysis.velocitySmoothed(framesTracking), 'LineWidth', 2,'Color', 'k','LineStyle', '-','Marker','none');
%              title('Velocity', 'FontSize', 18);
        plot([-preStimTime 0], mult.*[Stimulus(stim).Response.preStimSpeed Stimulus(stim).Response.preStimSpeed],'b:');
        plot([Stimulus(stim).timeData(stimOnFrame+1,9) postStimTime], mult.*[Stimulus(stim).Response.postStimSpeed Stimulus(stim).Response.postStimSpeed],'b:');
        xlabel('Time (s)', 'FontSize', 16);
        ylabel('Velocity (um/s)', 'FontSize', 16);
        legend('Raw Velocity','Smoothed Velocity','Location','SouthEast');
        set(gca, 'FontSize',14)
        axis([timeBounds vertBounds])

        subplot('position',[0.1 0.3 0.4 0.05])
        forward = -1;
        speed_smoothed = Stimulus(stim).CurvatureAnalysis.velocitySmoothed;
         for frame = framesTracking(1):framesTracking(end)
               if isnan(speed_smoothed(frame))
                   color = [0.5 , 0.5 , 0.5 ];
               elseif (sign(speed_smoothed(frame)) == forward)
                        color = [0, 0, 1];
               elseif (sign(speed_smoothed(frame)) == -1*forward)
                       color = [1, 0, 0 ];

               end

                    plot([timeTracking(frame) timeTracking(frame)],[0 1],'Color',color,'LineWidth',6)
                    hold on

         end
        title('Velocity and Direction', 'FontSize', 18);
        set(gca,'ytick',[])
        set(gca,'yticklabel',[])
        set(gca,'xtick',[])
        set(gca,'xticklabel',[])
        set(gca, 'FontSize',14)
        axis([timeBounds vertBounds])

        aspectRatio = 1500/895; %width/height
        width = 50;
        experimentTitle = getExperimentTitle(directory);
        filename = strcat(experimentTitle,'_Stimulus_',num2str(stim),'.png');
        set(gcf, 'PaperUnits', 'centimeters');
        set(gcf, 'PaperPosition', [0 0 width width/aspectRatio]); %x_width=10cm y_width=15cm

        saveas(gcf,fullfile(directory,filename));
    end

 
    close all
end