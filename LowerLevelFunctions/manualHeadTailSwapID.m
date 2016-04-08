%%%% Function: manual head tail swap ID
%  Helper function to identify frames where the head and tail were flipped 
%  and reverse the skeleton. The function loads the video into the local
%  memory and then shows the video to the user, frame-by-frame, asking if 
%  the skeleton needs to be flipped. If the user indicates yes, then it
%  reverses the skeleton.
%
%  param {Stimulus} struct, contains experiment data organized by stimulus
%  param {numStims} int, the number of stimulus in this experiment.
%  param {directory} string, location of the experiment data files. 
% 
%  returns {Stimulus} struct,  contains experiment data organized by
%  stimulus, modified with flipped skeletons and a list of the frames in
%  which the skeleton was flipped.
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%%%%%



function Stimulus = manualHeadTailSwapID(Stimulus,numStims, directory)
    disp(strcat('Starting file: ',directory));   
%     try
        obj = importVideoFile(directory);


       
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

%     catch
%         disp('No video');
%     end
    disp('End file');
end