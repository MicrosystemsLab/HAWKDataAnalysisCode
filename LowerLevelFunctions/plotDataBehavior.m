%%%% Function: plotDataBehavior
%  Creates a set of plots describing the behavior information
%  for each behavior recording in the experiment. The plots are saved to the
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


function plotDataBehavior(Stimulus, TrackingData, numStims, directory)
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
        subplot('position',[0.1 0.1 0.4 0.8])  
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



        subplot('position',[0.6 0.6 0.35 0.3])
        imagesc(framesTracking-find(Stimulus(stim).StimulusActivity==1,1),[0:2:99],Stimulus(stim).CurvatureAnalysis.curvatureimage.img(:,framesTracking,:))
        xlabel('Frame', 'FontSize', 16)
        ylabel('% Body Length', 'FontSize', 16)
        set(gca, 'FontSize',14)
%             axis([timeBounds vertBounds])


        subplot('position',[0.6 0.1 0.35 0.3])   
        mult = sign(Stimulus(stim).CurvatureAnalysis.velocity(framesTracking(1)));
        plot(timeTracking(framesTracking), mult.*Stimulus(stim).CurvatureAnalysis.velocity(framesTracking),'LineWidth', 2,'Color', 'm','LineStyle', ':','Marker','none');
        hold on
        plot(timeTracking(framesTracking), mult.*Stimulus(stim).CurvatureAnalysis.velocitySmoothed(framesTracking), 'LineWidth', 2,'Color', 'k','LineStyle', '-','Marker','none');
%              title('Velocity', 'FontSize', 18);
        xlabel('Time (s)', 'FontSize', 16);
        ylabel('Velocity (um/s)', 'FontSize', 16);
        legend('Raw Velocity','Smoothed Velocity','Location','NorthWest');
        set(gca, 'FontSize',14)
        axis([timeBounds vertBounds])

        subplot('position',[0.6 0.4 0.35 0.05])
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