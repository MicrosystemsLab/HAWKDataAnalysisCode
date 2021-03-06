
%%%% Function: Score Behavior Responses
%  This function looks at the velocity of the worm before and after the
%  stimulus begin and determines the type of response. It adds a struct to
%  that includes a string specifying the type of response, the
%  response latency defined as the difference between the time the stimulus
%  was applied and the time of the frame in which the response began. The
%  structure also includes the average speed in the frames before the
%  stimulus and the 12 frames after the stimulus. 
%
%  A reversal is detected first by checking for a change in direction. If a
%  change in direction is not found, we then compare the pre stimulus speed
%  with the post stimulus speed, averaged over about 12 frames on either
%  side of the stimulus start time. 
%
%  param {Stimulus} struct,  contains experiment data organized by
%  stimulus
%  param {numStims} int, the number of stimulus in this experiment.
%
%  returns {Stimulus} struct,  contains experiment data organized by
%  stimulus including the determined response.
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%%%%%

function Stimulus = scoreBehaviorResponse(Stimulus, numStims)
    
    HAWKProcessingConstants;
    for stim = 1:numStims
        %Filter the speed to analysze it
        speed = Stimulus(stim).CurvatureAnalysis.velocity;
        speed_smoothed = Stimulus(stim).CurvatureAnalysis.velocitySmoothed;
        direction_smoothed = sign(speed_smoothed);
        direction = sign(Stimulus(stim).CurvatureAnalysis.velocity);
        preStimCount= length(Stimulus(stim).FramesByStimulus.PreStimFrames);
        
        %Get time the stimulus started:
        stimOnFrame =  Stimulus(stim).StimulusTiming.stimOnStartFrame;
        stimOffFrame = Stimulus(stim).StimulusTiming.stimOffFrame;
%         postStimFrame = find(Stimulus(stim).timeData(:,8)>Stimulus(stim).StimulusTiming.stimOnStartTime+POST_STIM_TIME,1);
        postStimFrame2 = find(Stimulus(stim).timeData(:,8)>Stimulus(stim).StimulusTiming.stimOnStartTime+POST_STIM_TIME2,1);
        
        %Grab frames of intered: 15 frames before stimulus (~1.5s), during stim
        %frames and 34 frames after stimulus (~3s)
        numPreStimFrames = length(Stimulus(stim).FramesByStimulus.PreStimFrames);
        if numPreStimFrames < PRE_STIM_FRAMES
            cutoff = numPreStimFrames - 1;
        else
            cutoff = PRE_STIM_FRAMES-1;
        end
         
        %determine speed delta
        time = Stimulus(stim).timeData(:,8);
        preStimAveSpeed = findAverageSpeed(time(stimOnFrame-cutoff:stimOnFrame-1)',...
            speed(stimOnFrame-cutoff:stimOnFrame-1));
        postStimAveSpeed = findAverageSpeed(time(stimOnFrame+1:stimOffFrame)',...
            speed(stimOnFrame+1:stimOffFrame));
        postStimAveSpeed2 = findAverageSpeed(time(stimOnFrame+1:postStimFrame2)',...
            speed(stimOnFrame+1:postStimFrame2));     
        postStimAcceleration = diff(speed_smoothed')./diff(time);
        
        %Compare before and after movement directions to determine delta:
        Hzerocross = dsp.ZeroCrossingDetector;
        NumZeroCross = step(Hzerocross,speed_smoothed(stimOnFrame-2:stimOffFrame)');
        if (NumZeroCross > 0 && ~isempty(find(diff(sign(direction_smoothed(stimOnFrame-3:stimOffFrame)))==2,1,'first')))
            deltaDirection = true;
        else
            deltaDirection = false;
        end
        
        
        
        %Compare before and after average speeds to determine delta speed:
        if ( abs(postStimAveSpeed2) < abs(preStimAveSpeed)*(SPEED_THRESHOLD_PAUSE))
            deltaSpeed = -1;
        elseif  (abs(postStimAveSpeed) > abs(preStimAveSpeed)*(SPEED_THRESHOLD_SPEEDUP))
            deltaSpeed = 1;
        else
            deltaSpeed = 0;
        end
            
        %Trying different methods for detecting speed up:
         %Detect speed up response with max acceleration threshold
         responseType2 = 'none';
         if any(postStimAcceleration(stimOnFrame+1:stimOffFrame) < ACCELERATION_THRESHOLD)
             responseType2 = 'speedup';
         end
         maxAcceleration2 = min(postStimAcceleration(stimOnFrame+1:stimOffFrame));
          Stimulus(stim).Response.Type2 = responseType2;
          
         %Detect speed up response with acceleration window threshold
         responseType3 = 'none';
         score = detectSpeedUpResponse(speed_smoothed, Stimulus(stim).timeData(:,8), stimOnFrame, stimOffFrame, ACCELERATION_THRESHOLD);
         if( score == 2)
             responseType3 = 'speedup';
         end
        Stimulus(stim).Response.Type3 = responseType3;         
                  
        %Detect speed up response with velocity window threshold
        responseType4 = 'none';
        score = detectSpeedUpVelChange( speed_smoothed, stimOnFrame, stimOffFrame, preStimAveSpeed*1.3 );
        if (score == 2)
            responseType4 = 'speedup';
        end
        Stimulus(stim).Response.Type4 = responseType4;
        
        %First check if there is a reversal by checking for a change in
        %direction:
        if (deltaDirection == 1)
            responseType = 'reversal';
            %Measure latency of reversal:
            ind = find(diff(sign(direction_smoothed(stimOnFrame-3:stimOffFrame)))==2,1,'first');
            reversalOnFrame = stimOnFrame-3+ind;
            reversalAcceleration = postStimAcceleration(reversalOnFrame);
            reversalTime = Stimulus(stim).timeData(reversalOnFrame,8);
            latency = reversalTime-Stimulus(stim).StimulusTiming.stimOnStartTime;
            
            reversalOffFrame = reversalOnFrame  - 1 + find(diff(sign(direction_smoothed(reversalOnFrame - 1:stimOffFrame+POST_STIM_FRAMES)))==-2,1,'first');
            if isempty(reversalOffFrame)
                reversalOffFrame = stimOffFrame+POST_STIM_FRAMES+1;
                Stimulus(stim).Response.durationEndFlag = true;
            else
                Stimulus(stim).Response.durationEndFlag = false;
            end
             Stimulus(stim).Response.duration = time(reversalOffFrame) - time(reversalOnFrame);
            %Get other info about reversal:
            maxSpeed = max(speed_smoothed(stimOnFrame:stimOffFrame));
            maxAcceleration = max(postStimAcceleration(stimOnFrame+1:stimOffFrame));
             Stimulus(stim).Response.reversalSpeed.before = findAverageSpeed(time(reversalOnFrame-cutoff:reversalOnFrame-1)',...
            speed(reversalOnFrame-cutoff:reversalOnFrame-1));
             Stimulus(stim).Response.reversalSpeed.after = findAverageSpeed(time(reversalOnFrame:reversalOffFrame)',...
            speed(reversalOnFrame:reversalOffFrame));
            Stimulus(stim).Response.reversalAcceleration = reversalAcceleration;
            Stimulus(stim).Response.Latency = latency;
            Stimulus(stim).Response.ReversalOnFrame = reversalOnFrame;
            Stimulus(stim).Response.ReversalOffFrame = reversalOffFrame;
        %If there is no significant change in speed, classify as "none"
        elseif (deltaSpeed == 0)
            responseType = 'none';
            maxSpeed = min(speed_smoothed(stimOnFrame:stimOffFrame));
            maxAcceleration = 0;
            
        %If there is a significant drop in speed, classify as a pause
        elseif (deltaSpeed == -1)
            responseType = 'pause';
            maxSpeed = min(speed_smoothed(stimOnFrame:stimOffFrame));
            maxAcceleration = max(postStimAcceleration(stimOnFrame+1:stimOffFrame));
            
        %If there is a significant increase in speed, classify as speed up
        elseif (deltaSpeed == 1)
            responseType = 'speedup';
            maxSpeed = min(speed_smoothed(stimOnFrame:stimOffFrame));
            maxAcceleration = min(postStimAcceleration(stimOnFrame+1:stimOffFrame));
            
        %Else classify as unknown:
        else 
            responseType = 'unknown';
            maxAcceleration = 0;
            maxSpeed = 0; 
           
        end
        
        %Save data to Stimulus:
        Stimulus(stim).Response.Type = responseType;
        Stimulus(stim).Response.preStimSpeed = preStimAveSpeed;
        Stimulus(stim).Response.postStimSpeed = postStimAveSpeed;
        Stimulus(stim).Response.postStimSpeed2 = postStimAveSpeed2;
        Stimulus(stim).Response.postStimAcceleration = postStimAcceleration;
        Stimulus(stim).Response.maxSpeed = maxSpeed;
        Stimulus(stim).Response.maxAcceleration = maxAcceleration;
        Stimulus(stim).Response.maxAcceleration2 = maxAcceleration2;
        
                %Plotting for debug:
%         stimOnFrames = find(Stimulus(stim).StimulusActivity(frames)==1);
%         figure(stim);
%         subplot(211), plot(frames,speed(frames),'LineStyle',':','LineWidth',6, 'Color','b','Marker','none');
%         hold on
%         plot(frames,speed_smoothed(frames),'LineStyle','-','LineWidth',6, 'Color','r','Marker','none');
%         legend('Speed','Smoothed Speed','Location','SouthEast');
%         title('Signed speed of worm during stimulus','FontSize', 24)
%         xlabel('Frame','FontSize', 20)
%         ylabel('Speed','FontSize', 20)
% %         axis([0 60 -Inf Inf])
%         subplot(212), plot(frames,sign(speed(frames)),'LineStyle',':','LineWidth',6, 'Color','b','Marker','none');
%          hold on
%         plot(frames,direction_smoothed(frames),'LineStyle','-','LineWidth',6, 'Color','r','Marker','none');
%         plot(frames(stimOnFrames),ones(size(stimOnFrames)).*1.3,'LineStyle','-','LineWidth',6, 'Color','g','Marker','none')
%         axis([-Inf Inf -1.5 1.5])
%         legend('Velocity Direction','Smoothed Velocity Direction','Stimulus On','Location','SouthEast');
%         title('Direction of worm during stimulus','FontSize', 24)
%         xlabel('Frame','FontSize', 20)
%         ylabel('Direction (binary)','FontSize', 20)
        
    end
end