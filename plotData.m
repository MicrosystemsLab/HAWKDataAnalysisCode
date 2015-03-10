function plotData(Stimulus, numStims, plotByStim)

    if (~plotByStim)
        % Plot body length by frame:
        for stim = 1:numStims
            figure;
            plot(Stimulus(stim).ProcessedFrameNumber,Stimulus(stim).bodyLength,'r.',...
                [Stimulus(stim).ProcessedFrameNumber(1), Stimulus(stim).ProcessedFrameNumber(frameParser)],[Stimulus(stim).averageBodyLength, Stimulus(stim).averageBodyLength], 'r:',...
                [Stimulus(stim).ProcessedFrameNumber(1), Stimulus(stim).ProcessedFrameNumber(frameParser)],[Stimulus(stim).averageBodyLength+Stimulus(stim).stdBodyLength*1.75, Stimulus(stim).averageBodyLength+Stimulus(stim).stdBodyLength*1.75], 'k:',...
                [Stimulus(stim).ProcessedFrameNumber(1), Stimulus(stim).ProcessedFrameNumber(frameParser)],[Stimulus(stim).averageBodyLength-Stimulus(stim).stdBodyLength*1.75, Stimulus(stim).averageBodyLength-Stimulus(stim).stdBodyLength*1.75], 'b:', 'LineWidth', 3);
            title(['Body Length per Frame, Stimulus ', num2str(stim)], 'FontSize', 18);
            xlabel('Frame', 'FontSize', 16);
            ylabel('Body Length (um)', 'FontSize', 16);
            legend('Body Length','Average Body Length', 'STD*1.5','STD*1.5','Location','South')
            axis([Stimulus(stim).ProcessedFrameNumber(1), Stimulus(stim).ProcessedFrameNumber(frameParser), 150, 1000])

            
            % Plot Stimulus individually:
            figure;
            subplot(numDataFields+2,1,1), plot(Stimulus(stim).timeData(:,8),Stimulus(stim).StimulusActivity, 'LineWidth', 2);
            title('Stimulus Activity', 'FontSize', 18);
            xlabel('Time(s)', 'FontSize', 16);
            ylabel('On/Off', 'FontSize', 16);
            axis([0 25 0 1.5]);
            subplot(numDataFields+2,1,2), plot(adjustedTimeFPGA,Stimulus(stim).DesiredSignal, 'LineWidth', 2);
            hold on
            plot(adjustedTimeStim,Stimulus(stim).VoltagesSentToFPGA, 'MarkerSize',3, 'Color',[1 0 0]);
            title('Desired Stimulus', 'FontSize', 18);
            xlabel('Time (s)', 'FontSize', 16);
            ylabel('Voltage (V)', 'FontSize', 16); 
        %     axis([11 13.5 0 1.5]);
            subplot(numDataFields+2,1,3), plot(adjustedTimeFPGA,Stimulus(stim).PiezoSignal, 'LineWidth', 2);
            title('Piezo resistor signal', 'FontSize', 18);
            xlabel('Time (s)', 'FontSize', 16);
            ylabel('Voltage (V)', 'FontSize', 16);
%             subplot(numDataFields+2,1,4), plot(adjustedTimeFPGA,Stimulus(stim).ActuatorPosition, 'LineWidth', 2);
%             title('Actuator Position Signal', 'FontSize', 18);
%             xlabel('Time (s)', 'FontSize', 16);
%             ylabel('Voltage (V)', 'FontSize', 16);
%             subplot(numDataFields+2,1,5), plot(adjustedTimeFPGA,Stimulus(stim).ActuatorCommand, 'LineWidth', 2);
%             title('Actuator Command Signal', 'FontSize', 18);
%             xlabel('Time (s)', 'FontSize', 16);
%             ylabel('Voltage (V)', 'FontSize', 16);


            %Plot trajectory:
            figure;
            numGoodFrames = length(Stimulus(stim).goodFrames);
            %subplot(311),plot(Stimulus(stim).centroidPosition.x, Stimulus(stim).centroidPosition.y, 'k-', 'MarkerSize',12);
            hold on 
        %     subplot(111);
            plot(Stimulus(stim).Trajectory.centroidPosition.x(Stimulus(stim).PreStimFrames), Stimulus(stim).Trajectory.centroidPosition.y(Stimulus(stim).PreStimFrames), 'r-', 'LineWidth',2);  
            hold on
        %     subplot(111);
            plot(Stimulus(stim).Trajectory.centroidPosition.x(Stimulus(stim).DuringStimFrames), Stimulus(stim).Trajectory.centroidPosition.y(Stimulus(stim).DuringStimFrames), 'b-', 'LineWidth',2); 
            hold on
        %     subplot(111);
            plot(Stimulus(stim).Trajectory.centroidPosition.x(Stimulus(stim).PostStimFrames), Stimulus(stim).Trajectory.centroidPosition.y(Stimulus(stim).PostStimFrames), 'k-', 'LineWidth',2); 
            hold on
        %     subplot(111);
            plot(Stimulus(stim).Trajectory.centroidPosition.x(Stimulus(stim).goodFrames(1)), Stimulus(stim).Trajectory.centroidPosition.y(Stimulus(stim).goodFrames(1)), 'ro', 'MarkerSize',14);
            hold on
        %     subplot(111);
            plot(Stimulus(stim).Trajectory.centroidPosition.x(Stimulus(stim).goodFrames( numGoodFrames)), Stimulus(stim).Trajectory.centroidPosition.y(Stimulus(stim).goodFrames( numGoodFrames)), 'kx', 'MarkerSize',14);

            title(['Mid-Skeleton Position, Stimulus ' num2str(stim)], 'FontSize' , 18)
            axis equal;
            xlabel('x position (um)', 'FontSize' , 16)
            ylabel('y position (um)', 'FontSize' , 16)
            legend('Pre Stimulus Movement', 'During Stimulus Movement', 'Post Stimulus Movement','Start','End','Location','SouthWest');

        end
    
    else
        for stim = 1:numStims
            figure;


            % stimulus plot (need to do this first so that plot can be nested):       
            timeFPGA = 0:(size(fieldnames(FPGAData.(['Stimulus',num2str(stim)]).PiezoSignalMagnitudes))-1);
            timeFPGA = timeFPGA*acquisitionInterval;
            timeStim = 0:(size(fieldnames(StimulusData.Voltages))-1);
            timeStim = timeStim*transmitInterval;
            adjustedTimeFPGA = timeFPGA+Stimulus(stim).stimAppliedTime;
            adjustedTimeStim = timeStim+Stimulus(stim).stimOnStartTime;

            subplot(3,2,2), 
            plot(Stimulus(stim).timeData(:,8),Stimulus(stim).StimulusActivity, 'LineWidth', 2);
            title('Stimulus Activity', 'FontSize', 18);
            xlabel('Time(s)', 'FontSize', 16);
            ylabel('On/Off', 'FontSize', 16);
            axis([0 25 0 1.5]);
            subplot(3,2,4), 
            %plot(adjustedTime,Stimulus(stim).DesiredSignal, 'LineWidth', 2);
            plot(adjustedTimeFPGA(1:length(Stimulus(stim).DesiredSignal)),Stimulus(stim).DesiredSignal, 'LineWidth', 2);
                hold on
            plot(adjustedTimeStim(1:length(Stimulus(stim).VoltagesSentToFPGA)),Stimulus(stim).VoltagesSentToFPGA, 'MarkerSize',3, 'Color',[1 0 0]);
            title('Desired Stimulus', 'FontSize', 18);
            xlabel('Time (s)', 'FontSize', 16);
            ylabel('Voltage (V)', 'FontSize', 16); 
            subplot(3,2,6), 
            plot(adjustedTimeFPGA(1:length(Stimulus(stim).PiezoSignal)),Stimulus(stim).PiezoSignal, 'LineWidth', 2);
            title('Piezo resistor signal', 'FontSize', 18);
            xlabel('Time (s)', 'FontSize', 16);
            ylabel('Voltage (V)', 'FontSize', 16);

            % body length plot pre analysis:
    %         subplot(3,2,1)
    %         plot(Stimulus(stim).ProcessedFrameNumber,Stimulus(stim).bodyLength,'r.',...
    %             [Stimulus(stim).ProcessedFrameNumber(1), Stimulus(stim).ProcessedFrameNumber(frameParser)],[Stimulus(stim).averageBodyLength, Stimulus(stim).averageBodyLength], 'r:',...
    %             [Stimulus(stim).ProcessedFrameNumber(1), Stimulus(stim).ProcessedFrameNumber(frameParser)],[Stimulus(stim).averageBodyLength+Stimulus(stim).stdBodyLength, Stimulus(stim).averageBodyLength+Stimulus(stim).stdBodyLength], 'k:',...
    %             [Stimulus(stim).ProcessedFrameNumber(1), Stimulus(stim).ProcessedFrameNumber(frameParser)],[Stimulus(stim).averageBodyLength-Stimulus(stim).stdBodyLength/2, Stimulus(stim).averageBodyLength-Stimulus(stim).stdBodyLength/2], 'b:', 'LineWidth', 3);
    %         title(['Body Length per Frame, Stimulus ', num2str(stim)], 'FontSize', 18);
    %         xlabel('Frame', 'FontSize', 16);
    %         ylabel('Body Length (um)', 'FontSize', 16);
    %         legend('Body Length','Average Body Length', 'STD','STD/2','Location','South')
    %         axis([Stimulus(stim).ProcessedFrameNumber(1), Stimulus(stim).ProcessedFrameNumber(frameParser), 150, 1000])


            % body length plot post analysis:
            subplot(3,2,1);
            totalFrameNum = length(Stimulus(stim).ProcessedFrameNumber);
            plot(Stimulus(stim).ProcessedFrameNumber(Stimulus(stim).goodFrames),Stimulus(stim).bodyLength(Stimulus(stim).goodFrames),'r.',...
                Stimulus(stim).ProcessedFrameNumber(Stimulus(stim).droppedFrames),Stimulus(stim).bodyLength(Stimulus(stim).droppedFrames),'b.',...
                [Stimulus(stim).ProcessedFrameNumber(1), Stimulus(stim).ProcessedFrameNumber(totalFrameNum)],[Stimulus(stim).averageBodyLengthGoodFrames, Stimulus(stim).averageBodyLengthGoodFrames], 'r:',...
                [Stimulus(stim).ProcessedFrameNumber(1), Stimulus(stim).ProcessedFrameNumber(totalFrameNum)],[Stimulus(stim).averageBodyLengthGoodFrames+Stimulus(stim).stdBodyLengthGoodFrames/2, Stimulus(stim).averageBodyLengthGoodFrames+Stimulus(stim).stdBodyLengthGoodFrames/2], 'k:',...
                [Stimulus(stim).ProcessedFrameNumber(1), Stimulus(stim).ProcessedFrameNumber(totalFrameNum)],[Stimulus(stim).averageBodyLengthGoodFrames-Stimulus(stim).stdBodyLengthGoodFrames/2, Stimulus(stim).averageBodyLengthGoodFrames-Stimulus(stim).stdBodyLengthGoodFrames/2], 'b:','LineWidth',3);%,...
               % Stimulus(stim).ProcessedFrameNumber, Stimulus(stim).headTailToggle*(Stimulus(stim).averageBodyLengthGoodFrames/2), 'b-');
            if (any(Stimulus(stim).ProcessedFrameNumber(Stimulus(stim).omegaTurnRanges)))
                hold on 
                plot(Stimulus(stim).ProcessedFrameNumber(Stimulus(stim).omegaTurnRanges(:,1)),Stimulus(stim).bodyLength(Stimulus(stim).omegaTurnRanges(:,1)),'g+',...
                Stimulus(stim).ProcessedFrameNumber(Stimulus(stim).omegaTurnRanges(:,2)),Stimulus(stim).bodyLength(Stimulus(stim).omegaTurnRanges(:,2)),'g+','LineWidth',5);
            end
            title(['Body Length per Frame, Stimulus ', num2str(stim)], 'FontSize', 18);
            xlabel('Frame', 'FontSize', 16);
            ylabel('Body Length (um)', 'FontSize', 16);
            legend('Body Length Good Frames','Body Length Dropped Frames','Average Body Length', 'STD/2','STD/2','Beginning, End Omega Turn','Location','South')
            axis([Stimulus(stim).ProcessedFrameNumber(1), Stimulus(stim).ProcessedFrameNumber(totalFrameNum), 150, 1000])

            %Trajectory plot:
            subplot(3,2,[3,5]);
            numGoodFrames = length(Stimulus(stim).goodFrames);
            %pre stim:
            hold on 
            plot(Stimulus(stim).centroidPosition.x(Stimulus(stim).PreStimFrames), Stimulus(stim).centroidPosition.y(Stimulus(stim).PreStimFrames), 'r-', 'LineWidth',2);  
            %during stim:
            hold on
            plot(Stimulus(stim).centroidPosition.x(Stimulus(stim).DuringStimFrames), Stimulus(stim).centroidPosition.y(Stimulus(stim).DuringStimFrames), 'b-', 'LineWidth',2); 
            %post stim:
            hold on
            plot(Stimulus(stim).centroidPosition.x(Stimulus(stim).PostStimFrames), Stimulus(stim).centroidPosition.y(Stimulus(stim).PostStimFrames), 'k-', 'LineWidth',2); 
            %first position:
            hold on
            plot(Stimulus(stim).centroidPosition.x(Stimulus(stim).goodFrames(1)), Stimulus(stim).centroidPosition.y(Stimulus(stim).goodFrames(1)), 'ro', 'MarkerSize',14);
            %last position:
            hold on
            plot(Stimulus(stim).centroidPosition.x(Stimulus(stim).goodFrames( numGoodFrames)), Stimulus(stim).centroidPosition.y(Stimulus(stim).goodFrames( numGoodFrames)), 'kx', 'MarkerSize',14);

            title(['Mid-Skeleton Position, Stimulus ' num2str(stim)], 'FontSize' , 18)
            axis equal;
            xlabel('x position (um)', 'FontSize' , 16)
            ylabel('y position (um)', 'FontSize' , 16)
            legend('Pre Stimulus Movement', 'During Stimulus Movement', 'Post Stimulus Movement','Start','End','Location','SouthWest');
        end
        

    end

 

end