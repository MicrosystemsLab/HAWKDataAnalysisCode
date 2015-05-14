
function Stimulus = manualHeadTailSwapID(Stimulus,numStims, directory)

    obj = importVideoFile(directory);


    disp(strcat('Starting file: ',directory));
    yellow = uint8([255 255 0]); % [R G B]; class of yellow must match class of I
    shapeInserter = vision.ShapeInserter('Shape','Circles','BorderColor','Custom','CustomBorderColor',yellow);


    videoFrameRunningSum = 0;
    for stim = 1:numStims
        disp(strcat('Start, Stimulus: ',num2str(stim)));

        Stimulus(stim).framesToSwap = [];
        stimIndStart(stim) = find(Stimulus(stim).StimulusActivity==1,1,'first') - 15;
        stimIndEnd(stim) = find(diff(Stimulus(stim).StimulusActivity) == -1, 1, 'first') + 30;
        videoIndStart(stim) =  stimIndStart(stim) + videoFrameRunningSum;
        videoIndEnd(stim) = stimIndEnd(stim) + videoFrameRunningSum;



        for videoFrame = videoIndStart(stim) :  videoIndEnd(stim)
            currentFrame =   read(obj,videoFrame);
            frame = videoFrame - videoFrameRunningSum;
            %Create overlay:
            circles = int32([Stimulus(stim).PixelPositions.head.x(frame)/2,Stimulus(stim).PixelPositions.head.y(frame)/2 10;...
                Stimulus(stim).PixelPositions.tail.x(frame)/2,Stimulus(stim).PixelPositions.tail.y(frame)/2 5]); %  [x1 y1 radius1;x2 y2 radius2]
            J = step(shapeInserter, currentFrame, circles);
            imshow(J)
            x = input('Swap frame? 1 if yes, 0 if no:  ');
            if x == 1
                Stimulus(stim).framesToSwap = [Stimulus(stim).framesToSwap frame];
            end
        end

        videoFrameRunningSum = videoFrameRunningSum + Stimulus(stim).numFrames;

        Stimulus = swapHeadTail(Stimulus, stim, Stimulus(stim).framesToSwap);
        
    end

    
    
end