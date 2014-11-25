%% Worm Tracker Data Analysis Script
% This script brings in the data from the yaml file generated by HAWK and
% analysizes the data.

% Written by: Eileen Mazzochette
% Created: October 20, 2014
%
%%%%%
clear all;

%% Get Folder where all the files are:
DestinationFolder = '/Users/emazzochette/Desktop/WormTrackerDataAnalysis';
directory = uigetdir(DestinationFolder,'Choose the folder where the data if located');


for index = length(directory):-1:1
    if directory(index) == '/'
        startTitleIndex = index+1;
        break;
    end
end
experimentTitle = directory(startTitleIndex:length(directory));

trackingDataFilename = strcat(experimentTitle, '_tracking.yaml');
fpgaDataFilename = strcat(experimentTitle, '_FPGAdata.yaml');
stimulusDataFilename = strcat(experimentTitle, '_stimulus.yaml');


%path to Matlab YAML folder
addpath(genpath('YAMLMatlab_0.4.3'));

% Get Tracking Data:
%file to parse name (must be structured correctly)
tracking_file = fullfile(directory, trackingDataFilename);
%If necessary, remove the first line of the yaml file.
fid = fopen(tracking_file);
firstLine = fgetl(fid);
if (firstLine(1:9) == '%YAML:1.0')
    buffer = fread(fid, Inf);
    fclose(fid);
    delete(tracking_file)
    fid = fopen(tracking_file, 'w')  ;   % Open destination file.
    fwrite(fid, buffer) ;                         % Save to file.
    fclose(fid) ;
else
    fclose(fid);
end
%parse
TrackingData = ReadYaml(tracking_file);
%write file to .mat
mat_file = fullfile(directory,strcat(experimentTitle,'_tracking_parsedData.mat'));
save(mat_file, 'TrackingData');


% Get FPGA Data:
%file to parse name (must be structured correctly)
fpga_file = fullfile(directory, fpgaDataFilename);
%If necessary, remove the first line of the yaml file.
fid = fopen(fpga_file);
firstLine = fgetl(fid);
if (firstLine(1:9) == '%YAML:1.0')
    buffer = fread(fid, Inf);
    fclose(fid);
    delete(fpga_file)
    fid = fopen(fpga_file, 'w')  ;   % Open destination file.
    fwrite(fid, buffer) ;                         % Save to file.
    fclose(fid) ;
else
    fclose(fid);
end
%parse
FPGAData = ReadYaml(fpga_file);
%write file to .mat
mat_file = fullfile(directory,strcat(experimentTitle,'_FPGAdata_parsedData.mat'));
save(mat_file, 'FPGAData');
% Get Stimulus Data:

%file to parse name (must be structured correctly)
stimulus_file = fullfile(directory, stimulusDataFilename);
%If necessary, remove the first line of the yaml file.
fid = fopen(stimulus_file);
firstLine = fgetl(fid);
if (firstLine(1:9) == '%YAML:1.0')
    buffer = fread(fid, Inf);
    fclose(fid);
    delete(stimulus_file)
    fid = fopen(stimulus_file, 'w')  ;   % Open destination file.
    fwrite(fid, buffer) ;                         % Save to file.
    fclose(fid) ;
else
    fclose(fid);
end
%parse
StimulusData = ReadYaml(fpga_file);
%write file to .mat
mat_file = fullfile(directory,strcat(experimentTitle,'_stimulus_parsedData.mat'));
save(mat_file, 'StimulusData');

%% Constants
UM_PER_MICROSTEP = 0.15625 ;
MICROSTEP_PER_UM = 1/UM_PER_MICROSTEP;

PIXEL_PER_UM = 0.567369167;
UM_PER_PIXEL = 1/PIXEL_PER_UM;

IMAGE_WIDTH_PIXELS = 1024;
IMAGE_HEIGHT_PIXELS = 768;

PIXEL_SCALE = 1;

%% Extract General Properties:

fields = fieldnames(TrackingData);
k = strfind(fields,'WormInfo');

frameCount = 1;
frameCountInsideStim = 1;
stimCount = 1;
for fieldsParser = 1:length(fields)
   
   if  k{fieldsParser} == 1;
        if stimCount ~= TrackingData.(['WormInfo',num2str(frameCount)]).StimulusNumber
            stimCount = stimCount+1;
            frameCountInsideStim = 1;
        end
        Stimulus(stimCount).ProcessedFrameNumber(frameCountInsideStim) = TrackingData.(['WormInfo' num2str(frameCount)]).ProcessedFrameNumber;
        Stimulus(stimCount).timeData(frameCountInsideStim,1:6) = datevec(TrackingData.(['WormInfo',num2str(frameCount)]).Time);
        Stimulus(stimCount).head.x(frameCountInsideStim) = TrackingData.(['WormInfo' num2str(frameCount)]).Head.x/PIXEL_SCALE;
        Stimulus(stimCount).head.y(frameCountInsideStim) = TrackingData.(['WormInfo' num2str(frameCount)]).Head.y/PIXEL_SCALE;
        Stimulus(stimCount).tail.x(frameCountInsideStim) = TrackingData.(['WormInfo' num2str(frameCount)]).Tail.x/PIXEL_SCALE;
        Stimulus(stimCount).tail.y(frameCountInsideStim) = TrackingData.(['WormInfo' num2str(frameCount)]).Tail.y/PIXEL_SCALE; 
        Stimulus(stimCount).stageMovement.x(frameCountInsideStim) = TrackingData.(['WormInfo' num2str(frameCount)]).StageMovement.x0x2Daxis; %*UM_PER_MICROSTEP;
        Stimulus(stimCount).stageMovement.y(frameCountInsideStim) = TrackingData.(['WormInfo' num2str(frameCount)]).StageMovement.y0x2Daxis; %*UM_PER_MICROSTEP;
        Stimulus(stimCount).StimulusActivity(frameCountInsideStim) = TrackingData.(['WormInfo' num2str(frameCount)]).StimulusActive;
        Stimulus(stimCount).headTailToggle(frameCountInsideStim) = TrackingData.(['WormInfo' num2str(frameCount)]).Toggled;
        
        for skeletonParser = 0:length(fieldnames(TrackingData.(['WormInfo' num2str(frameCount)]).Skeleton))-1
           Stimulus(stimCount).Skeleton(frameCountInsideStim).x(skeletonParser+1) = TrackingData.(['WormInfo' num2str(frameCount)]).Skeleton.(['Point' num2str(skeletonParser)]).x/PIXEL_SCALE;
           Stimulus(stimCount).Skeleton(frameCountInsideStim).y(skeletonParser+1) = TrackingData.(['WormInfo' num2str(frameCount)]).Skeleton.(['Point' num2str(skeletonParser)]).y/PIXEL_SCALE;
            
        end
        
        Stimulus(stimCount).centroid.x(frameCountInsideStim) = Stimulus(stimCount).Skeleton(frameCountInsideStim).x(floor(length(Stimulus(stimCount).Skeleton(frameCountInsideStim).x)/2));
        Stimulus(stimCount).centroid.y(frameCountInsideStim) = Stimulus(stimCount).Skeleton(frameCountInsideStim).y(floor(length(Stimulus(stimCount).Skeleton(frameCountInsideStim).y)/2));
        
        frameCount = frameCount + 1;
        frameCountInsideStim = frameCountInsideStim + 1;
   end
   
end
frameCount = frameCount-1;
numStims = length(Stimulus);

for stim = 1:numStims
   for i = 0:size(fieldnames(FPGAData.(['Stimulus',num2str(stim)]).PiezoSignalMagnitudes))-1
       Stimulus(stim).PiezoSignal(i+1) = FPGAData.(['Stimulus',num2str(stim)]).PiezoSignalMagnitudes.(['Point', num2str(i)]);
       Stimulus(stim).ActuatorPosition(i+1) = FPGAData.(['Stimulus',num2str(stim)]).ActuatorPositionMagnitudes.(['Point', num2str(i)]);
       Stimulus(stim).ActuatorCommand(i+1) = FPGAData.(['Stimulus',num2str(stim)]).ActuatorCommandMagnitudes.(['Point', num2str(i)]);
       Stimulus(stim).DesiredSignal(i+1) = FPGAData.(['Stimulus',num2str(stim)]).DesiredSignalMagnitudes.(['Point', num2str(i)]);
       
    end
end




% calculate more timing data
%clean up, calculate more timing data:
for stim=1:numStims
    % seventh column of timing data is the seconds + minutes. 
    Stimulus(stim).timeData(:,7) =  Stimulus(stim).timeData(:,4).*60.*60+ Stimulus(stim).timeData(:,5).*60+ Stimulus(stim).timeData(:,6);
    % eighth column of timing data is the elapsed time from first frame in
    % seconds
     Stimulus(stim).timeData(:,8) =  Stimulus(stim).timeData(:,7) -  Stimulus(stim).timeData(1,7);
    %ninth column of timing data is the time since the last frame.
     Stimulus(stim).timeData(:,9) = [0; diff( Stimulus(stim).timeData(:,7))];
end

%% Measure body length
averageBodyLength = 0;

% suptitle('Body Length')
 for stim = 1:numStims
% for stim =2:2
    for frameParser = 1:length(Stimulus(stim).head.x); 
       Stimulus(stim).bodyLength(frameParser) = calculateBodyLength(Stimulus(stim).Skeleton(frameParser).x, Stimulus(stim).Skeleton(frameParser).y)*UM_PER_PIXEL; 
    end
    Stimulus(stim).averageBodyLength = mean(Stimulus(stim).bodyLength);%.*UM_PER_PIXEL;
    Stimulus(stim).stdBodyLength = std(Stimulus(stim).bodyLength);%.*UM_PER_PIXEL;

    figure;
    plot(Stimulus(stim).ProcessedFrameNumber,Stimulus(stim).bodyLength,'r.',...
        [Stimulus(stim).ProcessedFrameNumber(1), Stimulus(stim).ProcessedFrameNumber(frameParser)],[Stimulus(stim).averageBodyLength, Stimulus(stim).averageBodyLength], 'r:',...
        [Stimulus(stim).ProcessedFrameNumber(1), Stimulus(stim).ProcessedFrameNumber(frameParser)],[Stimulus(stim).averageBodyLength+Stimulus(stim).stdBodyLength, Stimulus(stim).averageBodyLength+Stimulus(stim).stdBodyLength], 'k:',...
        [Stimulus(stim).ProcessedFrameNumber(1), Stimulus(stim).ProcessedFrameNumber(frameParser)],[Stimulus(stim).averageBodyLength-Stimulus(stim).stdBodyLength/2, Stimulus(stim).averageBodyLength-Stimulus(stim).stdBodyLength/2], 'b:', 'LineWidth', 3);
    title(['Body Length per Frame, Stimulus ', num2str(stim)], 'FontSize', 18);
    xlabel('Frame', 'FontSize', 16);
    ylabel('Body Length (um)', 'FontSize', 16);
    legend('Body Length','Average Body Length', 'STD','STD/2','Location','South')
    axis([Stimulus(stim).ProcessedFrameNumber(1), Stimulus(stim).ProcessedFrameNumber(frameParser), 150, 1000])
    
    
    %Figure out dropped frames:
    droppedFrameCounter = 1;
    goodFrameCounter = 1;
    for frameParser = 1:length(Stimulus(stim).head.x); 
        if (Stimulus(stim).bodyLength(frameParser)< Stimulus(stim).averageBodyLength-Stimulus(stim).stdBodyLength/2 || ...
            Stimulus(stim).bodyLength(frameParser) > Stimulus(stim).averageBodyLength+Stimulus(stim).stdBodyLength)
            Stimulus(stim).droppedFrames(droppedFrameCounter) = frameParser;
            droppedFrameCounter = droppedFrameCounter + 1;
        else
            Stimulus(stim).goodFrames(goodFrameCounter) = frameParser;
            goodFrameCounter = goodFrameCounter + 1;      
        end
        
        
    end
    
    Stimulus(stim).averageBodyLengthGoodFrames = mean(Stimulus(stim).bodyLength(Stimulus(stim).goodFrames)); 
    Stimulus(stim).stdBodyLengthGoodFrames = std(Stimulus(stim).bodyLength(Stimulus(stim).goodFrames));
    averageBodyLength = averageBodyLength + Stimulus(stim).averageBodyLengthGoodFrames;
    
    % Find Omega Turns
    bodyLengthDiff = diff(Stimulus(stim).droppedFrames);
    consecutiveCount = 0;
    blockCount = 1;
    for i = 1:length(bodyLengthDiff)
        if bodyLengthDiff(i) < 3
           consecutiveCount = consecutiveCount+1; 
        else
            block(blockCount,1) = consecutiveCount;
            block(blockCount,2) = i;
            blockCount = blockCount + 1;
           consecutiveCount = 0;
        end
        
        if (i == length(bodyLengthDiff))
            block(blockCount,1) = consecutiveCount;
            block(blockCount,2) = i;
            blockCount = blockCount + 1;
           consecutiveCount = 0;
        end
        
    end
    ind = find(block(:,1)>20);
    omegaTurnIndices = block(ind,2);
    Stimulus(stim).omegaTurnRanges = [Stimulus(stim).droppedFrames(omegaTurnIndices-block(ind,1)+1)' Stimulus(stim).droppedFrames(omegaTurnIndices)'];
    dimensions = size(Stimulus(stim).omegaTurnRanges);
    for i = 1:dimensions(1)
        Stimulus(stim).omegaTurnFrames = Stimulus(stim).omegaTurnRanges(i,1):Stimulus(stim).omegaTurnRanges(i,2);
    end
    clear ind;
    clear block;
    clear omegaTurnIndices;
    clear dimensions;

   % subplot(numStims,1,stim); 
   figure;
    plot(Stimulus(stim).ProcessedFrameNumber(Stimulus(stim).goodFrames),Stimulus(stim).bodyLength(Stimulus(stim).goodFrames),'r.',...
        Stimulus(stim).ProcessedFrameNumber(Stimulus(stim).droppedFrames),Stimulus(stim).bodyLength(Stimulus(stim).droppedFrames),'b.',...
        [Stimulus(stim).ProcessedFrameNumber(1), Stimulus(stim).ProcessedFrameNumber(frameParser)],[Stimulus(stim).averageBodyLengthGoodFrames, Stimulus(stim).averageBodyLengthGoodFrames], 'r:',...
        [Stimulus(stim).ProcessedFrameNumber(1), Stimulus(stim).ProcessedFrameNumber(frameParser)],[Stimulus(stim).averageBodyLengthGoodFrames+Stimulus(stim).stdBodyLengthGoodFrames/2, Stimulus(stim).averageBodyLengthGoodFrames+Stimulus(stim).stdBodyLengthGoodFrames/2], 'k:',...
        [Stimulus(stim).ProcessedFrameNumber(1), Stimulus(stim).ProcessedFrameNumber(frameParser)],[Stimulus(stim).averageBodyLengthGoodFrames-Stimulus(stim).stdBodyLengthGoodFrames/2, Stimulus(stim).averageBodyLengthGoodFrames-Stimulus(stim).stdBodyLengthGoodFrames/2], 'b:','LineWidth',3);%,...
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
    axis([Stimulus(stim).ProcessedFrameNumber(1), Stimulus(stim).ProcessedFrameNumber(frameParser), 150, 1000])
    
end
averageBodyLength = averageBodyLength/numStims;



%% Plot Stimulus

numDataFields = 1;
acquisitionInterval = 0.001;



for stim = 1:numStims
    time = 0:(size(fieldnames(FPGAData.(['Stimulus',num2str(stim)]).PiezoSignalMagnitudes))-1);
    time = time*acquisitionInterval;
    
    stimOnIndex = find(Stimulus(stim).DesiredSignal>0,1,'first');
    timeOnIndex = time(stimOnIndex);
    
    ind = find(Stimulus(stim).StimulusActivity==1,1,'first');
    Stimulus(stim).stimStartTime = Stimulus(stim).timeData(ind,8);
    ind = find(diff(Stimulus(stim).StimulusActivity) == -1, 1, 'first');
    Stimulus(stim).stimEndTime = Stimulus(stim).timeData(ind,8);
    
    
    adjustedTime = time+Stimulus(stim).stimStartTime;
    figure;
    
    subplot(numDataFields+2,1,1), plot(Stimulus(stim).timeData(:,8),Stimulus(stim).StimulusActivity, 'LineWidth', 2);
    title('Stimulus Activity', 'FontSize', 18);
    xlabel('Time(s)', 'FontSize', 16);
    ylabel('On/Off', 'FontSize', 16);
    axis([0 25 0 1.5]);
    subplot(numDataFields+2,1,2), plot(adjustedTime,Stimulus(stim).DesiredSignal, 'LineWidth', 2);
    title('Desired Stimulus', 'FontSize', 18);
    xlabel('Time (s)', 'FontSize', 16);
    ylabel('Voltage (V)', 'FontSize', 16); 
%     axis([11 13.5 0 1.5]);
    subplot(numDataFields+2,1,3), plot(adjustedTime,Stimulus(stim).PiezoSignal, 'LineWidth', 2);
    title('Piezo resistor signal', 'FontSize', 18);
    xlabel('Time (s)', 'FontSize', 16);
    ylabel('Voltage (V)', 'FontSize', 16);
%     subplot(numDataFields+1,1,1), plot(adjustedTime,Stimulus(stim).ActuatorPosition, 'LineWidth', 2);
%     title('Actuator Position Signal', 'FontSize', 18);
%     xlabel('Time (s)', 'FontSize', 16);
%     ylabel('Voltage (V)', 'FontSize', 16);
%     subplot(numDataFields+1,1,2), plot(adjustedTime,Stimulus(stim).ActuatorCommand, 'LineWidth', 2);
%     title('Actuator Command Signal', 'FontSize', 18);
%     xlabel('Time (s)', 'FontSize', 16);
%     ylabel('Voltage (V)', 'FontSize', 16);
 
end

%% Sort Frames based on Stimulus

for stim=1:numStims
    numGoodFrames = length(Stimulus(stim).goodFrames);
    preCount = 1;
    duringCount = 1;
    postCount = 1;
    for frame = 1:numGoodFrames
        if (Stimulus(stim).timeData(Stimulus(stim).goodFrames(frame),8) < Stimulus(stim).stimStartTime)
            Stimulus(stim).PreStimFrames(preCount) = Stimulus(stim).goodFrames(frame);
            preCount = preCount+1;
        elseif (Stimulus(stim).timeData(Stimulus(stim).goodFrames(frame),8) < Stimulus(stim).stimEndTime)
            Stimulus(stim).DuringStimFrames(duringCount) = Stimulus(stim).goodFrames(frame);
            duringCount = duringCount + 1;
        else
            Stimulus(stim).PostStimFrames(postCount) = Stimulus(stim).goodFrames(frame);
            postCount = postCount + 1;
        end
         
    end

end

%% Plot Head, Centroid position, direction vector

for stim = 1:numStims
    
    directionSmoothing = 15; %frames.

    for frame = 1:length(Stimulus(stim).head.x)
        Stimulus(stim).headRealSpace.x(frame) = (IMAGE_WIDTH_PIXELS - Stimulus(stim).head.x(frame)).*UM_PER_PIXEL;
        Stimulus(stim).headRealSpace.y(frame) = Stimulus(stim).head.y(frame).*UM_PER_PIXEL;
        Stimulus(stim).tailRealSpace.x(frame) = (IMAGE_WIDTH_PIXELS - Stimulus(stim).tail.x(frame)).*UM_PER_PIXEL;
        Stimulus(stim).tailRealSpace.y(frame) = Stimulus(stim).tail.y(frame).*UM_PER_PIXEL;
        Stimulus(stim).centroidRealSpace.x(frame) = (IMAGE_WIDTH_PIXELS - Stimulus(stim).centroid.x(frame)).*UM_PER_PIXEL;
        Stimulus(stim).centroidRealSpace.y(frame) = Stimulus(stim).centroid.y(frame).*UM_PER_PIXEL;

        if frame == 1
            Stimulus(stim).stagePosition.x(1) = 0;
            Stimulus(stim).stagePosition.y(1) = 0;
            Stimulus(stim).headPosition.x(1) = Stimulus(stim).stagePosition.x(1) + Stimulus(stim).headRealSpace.x(1);
            Stimulus(stim).headPosition.y(1) = Stimulus(stim).stagePosition.y(1) + Stimulus(stim).headRealSpace.y(1);
            Stimulus(stim).tailPosition.x(1) = Stimulus(stim).stagePosition.x(1) + Stimulus(stim).tailRealSpace.x(1);
            Stimulus(stim).tailPosition.y(1) = Stimulus(stim).stagePosition.y(1) + Stimulus(stim).tailRealSpace.y(1);
            Stimulus(stim).centroidPosition.x(1) = Stimulus(stim).stagePosition.x(1) + Stimulus(stim).centroidRealSpace.x(1);
            Stimulus(stim).centroidPosition.y(1) = Stimulus(stim).stagePosition.y(1) + Stimulus(stim).centroidRealSpace.y(1);
            Stimulus(stim).speed(1) = 0;

        else


            Stimulus(stim).stagePosition.x(frame) = Stimulus(stim).stagePosition.x(frame-1) + Stimulus(stim).stageMovement.x(frame-1);
            Stimulus(stim).stagePosition.y(frame) = Stimulus(stim).stagePosition.y(frame-1) + Stimulus(stim).stageMovement.y(frame-1);

            Stimulus(stim).headPosition.x(frame) = Stimulus(stim).stagePosition.x(frame) + Stimulus(stim).headRealSpace.x(frame);
            Stimulus(stim).headPosition.y(frame) = Stimulus(stim).stagePosition.y(frame) + Stimulus(stim).headRealSpace.y(frame);

            Stimulus(stim).tailPosition.x(frame) = Stimulus(stim).stagePosition.x(frame) + Stimulus(stim).tailRealSpace.x(frame);
            Stimulus(stim).tailPosition.y(frame) = Stimulus(stim).stagePosition.y(frame) + Stimulus(stim).tailRealSpace.y(frame);
            
            Stimulus(stim).centroidPosition.x(frame) = Stimulus(stim).stagePosition.x(frame) + Stimulus(stim).centroidRealSpace.x(frame);
            Stimulus(stim).centroidPosition.y(frame) = Stimulus(stim).stagePosition.y(frame) + Stimulus(stim).centroidRealSpace.y(frame);

            deltaX = Stimulus(stim).centroidPosition.x(frame)-Stimulus(stim).centroidPosition.x(frame-1);
            deltaY = Stimulus(stim).centroidPosition.y(frame)-Stimulus(stim).centroidPosition.y(frame-1);

            if Stimulus(stim).timeData(frame,9) <= 0.011
                Stimulus(stim).speed(frame) = 0;
            else
                Stimulus(stim).speed(frame) = sqrt(deltaX^2 + deltaY^2)/Stimulus(stim).timeData(frame,9);
            end

            if frame > directionSmoothing
                deltaX = Stimulus(stim).centroidPosition.x(frame)-Stimulus(stim).centroidPosition.x(frame-directionSmoothing);
                deltaY = Stimulus(stim).centroidPosition.y(frame)-Stimulus(stim).centroidPosition.y(frame-directionSmoothing);
                if deltaX == 0
                    Stimulus(stim).movementDirection(frame-directionSmoothing) = 90;
                elseif deltaX>0
                    Stimulus(stim).movementDirection(frame-directionSmoothing) = (180/pi) * atan(deltaY/deltaX);
                elseif deltaX<0 && deltaY>=0
                    Stimulus(stim).movementDirection(frame-directionSmoothing) = 180 - (180/pi) * (atan(deltaY/abs(deltaX)));
                elseif deltaX<0 && deltaY<0
                    Stimulus(stim).movementDirection(frame-directionSmoothing) = -(180 - (180/pi) * atan(abs(deltaY)/abs(deltaX))); 
                end
            end
        end
    end



    figure;
    numGoodFrames = length(Stimulus(stim).goodFrames);
    %subplot(311),plot(Stimulus(stim).centroidPosition.x, Stimulus(stim).centroidPosition.y, 'k-', 'MarkerSize',12);
    hold on 
%     subplot(111);
    plot(Stimulus(stim).centroidPosition.x(Stimulus(stim).PreStimFrames), Stimulus(stim).centroidPosition.y(Stimulus(stim).PreStimFrames), 'r-', 'LineWidth',2);  
    hold on
%     subplot(111);
    plot(Stimulus(stim).centroidPosition.x(Stimulus(stim).DuringStimFrames), Stimulus(stim).centroidPosition.y(Stimulus(stim).DuringStimFrames), 'b-', 'LineWidth',2); 
    hold on
%     subplot(111);
    plot(Stimulus(stim).centroidPosition.x(Stimulus(stim).PostStimFrames), Stimulus(stim).centroidPosition.y(Stimulus(stim).PostStimFrames), 'k-', 'LineWidth',2); 
    hold on
%     subplot(111);
    plot(Stimulus(stim).centroidPosition.x(Stimulus(stim).goodFrames(1)), Stimulus(stim).centroidPosition.y(Stimulus(stim).goodFrames(1)), 'ro', 'MarkerSize',14);
    hold on
%     subplot(111);
    plot(Stimulus(stim).centroidPosition.x(Stimulus(stim).goodFrames( numGoodFrames)), Stimulus(stim).centroidPosition.y(Stimulus(stim).goodFrames( numGoodFrames)), 'kx', 'MarkerSize',14);

    title(['Mid-Skeleton Position, Stimulus ' num2str(stim)], 'FontSize' , 18)
    axis equal;
    xlabel('x position (um)', 'FontSize' , 16)
    ylabel('y position (um)', 'FontSize' , 16)
    legend('Pre Stimulus Movement', 'During Stimulus Movement', 'Post Stimulus Movement','Start','End','Location','SouthWest');
   

%     subplot(312), plot(Stimulus(stim).ProcessedFrameNumber,Stimulus(stim).speed)
%     title('Speed')
%     ylabel('Speed (um/s)');
    
%     subplot(212);
%     [AX,H1,H2] = plotyy(Stimulus(stim).timeData([directionSmoothing+1:length(Stimulus(stim).timeData(:,1))],8),Stimulus(stim).movementDirection,... 'k.', 'MarkerSize',12,...
%         Stimulus(stim).timeData(:,8),Stimulus(stim).StimulusActivity);
%   
%     title('Movement Angle', 'FontSize' , 20)
%     xlabel('Time (s)', 'FontSize' , 16)
%     set(get(AX(1),'Ylabel'),'String','Angle from x-axis (degrees)','FontSize' , 16) 
%     set(get(AX(2),'Ylabel'),'String','Stimulus Activity (on/off)') 
%     set(H1,'LineStyle','.')
%     set(H2,'LineStyle','-', 'LineWidth', 2)
% %     ylabel('Angle from x-axis (degrees)', 'FontSize' , 16);

end

%% Determine Forward, Backward, other movement
markers ={'r-','b-','k-','y-','g-'};
gap = 10;
figure;
for stim = 1:numStims
    numGoodFrames = length(Stimulus(stim).goodFrames);
    forwardCounter = 1;
    backwardCounter = 1;
    smallerCounter = 1;
    biggerCounter = 1;
    for frame = gap+1:numGoodFrames
       currentFrame = Stimulus(stim).goodFrames(frame);
       previousFrame = Stimulus(stim).goodFrames(frame-gap);
       distanceRefHead = distanceCalc(Stimulus(stim).centroidPosition.x(currentFrame), Stimulus(stim).centroidPosition.y(currentFrame), Stimulus(stim).headPosition.x(currentFrame), Stimulus(stim).headPosition.y(currentFrame));
       distanceRefPrevHead = distanceCalc(Stimulus(stim).centroidPosition.x(currentFrame), Stimulus(stim).centroidPosition.y(currentFrame), Stimulus(stim).headPosition.x(previousFrame), Stimulus(stim).headPosition.y(previousFrame));
       distanceRefTail = distanceCalc(Stimulus(stim).centroidPosition.x(currentFrame), Stimulus(stim).centroidPosition.y(currentFrame), Stimulus(stim).tailPosition.x(currentFrame), Stimulus(stim).tailPosition.y(currentFrame));
       distanceRefPrevTail = distanceCalc(Stimulus(stim).centroidPosition.x(currentFrame), Stimulus(stim).centroidPosition.y(currentFrame), Stimulus(stim).tailPosition.x(previousFrame), Stimulus(stim).tailPosition.y(previousFrame));
        % check if moving forward
        if ((distanceRefPrevHead > distanceRefHead) && (distanceRefPrevTail < distanceRefTail))
            Stimulus(stim).forwardFrames(forwardCounter) = currentFrame;
            plot([currentFrame currentFrame],[stim stim+0.5], markers{1},'LineWidth',2);
            forwardCounter = forwardCounter + 1;
            % check if moving backward
        elseif ((distanceRefPrevHead < distanceRefHead) && (distanceRefPrevTail > distanceRefTail))
            Stimulus(stim).backwardFrames(backwardCounter) = currentFrame;
            plot([currentFrame currentFrame],[stim stim+0.5], markers{2},'LineWidth',2);
            backwardCounter = backwardCounter + 1;
%         elseif ((distanceRefPrevHead < distanceRefHead) && (distanceRefPrevTail < distanceRefTail))
%             Stimulus(stim).unknownMovementFrames(otherCounter) = currentFrame;
%             plot([currentFrame currentFrame],[stim stim+0.5], markers{3},'LineWidth',2);
%             smallerCounter = smallerCounter + 1;
%         elseif ((distanceRefPrevHead > distanceRefHead) && (distanceRefPrevTail > distanceRefTail))
%              Stimulus(stim).unknownMovementFrames(otherCounter) = currentFrame;
%             plot([currentFrame currentFrame],[stim stim+0.5], markers{4},'LineWidth',2);
%             smallerCounter = smallerCounter + 1;
        else
            Stimulus(stim).unknownMovementFrames(smallerCounter) = currentFrame;
            plot([currentFrame currentFrame],[stim stim+0.5], markers{3},'LineWidth',2);
            smallerCounter = smallerCounter + 1;
        end
        hold on
       
    end
    
    
   %plot omega turns
    if (length(Stimulus(stim).omegaTurnFrames)>1)
        for i = 1:length(Stimulus(stim).omegaTurnFrames)
            plot([Stimulus(stim).omegaTurnFrames(i) Stimulus(stim).omegaTurnFrames(i)], [stim stim+0.5], markers{5},'LineWidth', 2);
        end
    end
    
    
    plot(stim+Stimulus(stim).headTailToggle*0.4-0.45, 'r-','LineWidth',2)
    plot(stim+Stimulus(stim).StimulusActivity*0.4-0.45, 'b-', 'LineWidth',2)
    
    hold on;
  
   

end
 xlabel('Frame Number','FontSize', 20);
 ylabel('Stimulus','FontSize', 20);

