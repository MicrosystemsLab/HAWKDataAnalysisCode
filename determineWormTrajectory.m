%%%% Function: Determine Worm Trajectory
%  Uses movement of stage and the real space positions of the worm markers
%  to determine the trajectory of the worm
% 
%  param {Stimulus} struct,  contains experiment data organized by
%  stimulus
%  param {numStims} int, the number of stimulus in this experiment.
%
%  reutns {Stimulus} struct,  contains experiment data organized by
%  stimulus, includes trajectory information determined by this function.
% 
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%
%%%%%

function [Stimulus] = determineWormTrajectory(Stimulus, numStims)
    
    HAWKSystemConstants;
    
    for stim = 1:numStims
    
        directionSmoothing = 4; %frames.

        for frame = 1:Stimulus(stim).numFrames
            headRealSpace.x(frame) = (IMAGE_WIDTH_PIXELS - Stimulus(stim).PixelPositions.head.x(frame)).*UM_PER_PIXEL;
            headRealSpace.y(frame) = Stimulus(stim).PixelPositions.head.y(frame).*UM_PER_PIXEL;
            tailRealSpace.x(frame) = (IMAGE_WIDTH_PIXELS - Stimulus(stim).PixelPositions.tail.x(frame)).*UM_PER_PIXEL;
            tailRealSpace.y(frame) = Stimulus(stim).PixelPositions.tail.y(frame).*UM_PER_PIXEL;
            centroidRealSpace.x(frame) = (IMAGE_WIDTH_PIXELS - Stimulus(stim).PixelPositions.centroid.x(frame)).*UM_PER_PIXEL;
            centroidRealSpace.y(frame) = Stimulus(stim).PixelPositions.centroid.y(frame).*UM_PER_PIXEL;
            meanRealSpace.x(frame) = (IMAGE_WIDTH_PIXELS - Stimulus(stim).PixelPositions.mean.x(frame)).*UM_PER_PIXEL;
            meanRealSpace.y(frame) = Stimulus(stim).PixelPositions.mean.y(frame).*UM_PER_PIXEL;

            if frame == 1
                Stimulus(stim).Trajectory.stagePosition.x(1) = 0;
                Stimulus(stim).Trajectory.stagePosition.y(1) = 0;
                Stimulus(stim).Trajectory.headPosition.x(1) = Stimulus(stim).Trajectory.stagePosition.x(1) - headRealSpace.x(1);
                Stimulus(stim).Trajectory.headPosition.y(1) = Stimulus(stim).Trajectory.stagePosition.y(1) - headRealSpace.y(1);
                Stimulus(stim).Trajectory.tailPosition.x(1) = Stimulus(stim).Trajectory.stagePosition.x(1) - tailRealSpace.x(1);
                Stimulus(stim).Trajectory.tailPosition.y(1) = Stimulus(stim).Trajectory.stagePosition.y(1) - tailRealSpace.y(1);
                Stimulus(stim).Trajectory.centroidPosition.x(1) = Stimulus(stim).Trajectory.stagePosition.x(1) - centroidRealSpace.x(1);
                Stimulus(stim).Trajectory.centroidPosition.y(1) = Stimulus(stim).Trajectory.stagePosition.y(1) - centroidRealSpace.y(1);
                Stimulus(stim).Trajectory.meanPosition.x(1) = Stimulus(stim).Trajectory.stagePosition.x(1) - meanRealSpace.x(1);
                Stimulus(stim).Trajectory.meanPosition.y(1) = Stimulus(stim).Trajectory.stagePosition.y(1) - meanRealSpace.y(1);
                Stimulus(stim).Trajectory.speed(1) = 0;

            else


                Stimulus(stim).Trajectory.stagePosition.x(frame) = Stimulus(stim).Trajectory.stagePosition.x(frame-1) + Stimulus(stim).stageMovement.x(frame-1);
                Stimulus(stim).Trajectory.stagePosition.y(frame) = Stimulus(stim).Trajectory.stagePosition.y(frame-1) + Stimulus(stim).stageMovement.y(frame-1);

                Stimulus(stim).Trajectory.headPosition.x(frame) = Stimulus(stim).Trajectory.stagePosition.x(frame) - headRealSpace.x(frame);
                Stimulus(stim).Trajectory.headPosition.y(frame) = Stimulus(stim).Trajectory.stagePosition.y(frame) - headRealSpace.y(frame);

                Stimulus(stim).Trajectory.tailPosition.x(frame) = Stimulus(stim).Trajectory.stagePosition.x(frame) - tailRealSpace.x(frame);
                Stimulus(stim).Trajectory.tailPosition.y(frame) = Stimulus(stim).Trajectory.stagePosition.y(frame) - tailRealSpace.y(frame);

                Stimulus(stim).Trajectory.centroidPosition.x(frame) = Stimulus(stim).Trajectory.stagePosition.x(frame) - centroidRealSpace.x(frame);
                Stimulus(stim).Trajectory.centroidPosition.y(frame) = Stimulus(stim).Trajectory.stagePosition.y(frame) - centroidRealSpace.y(frame);
                
                Stimulus(stim).Trajectory.meanPosition.x(frame) = Stimulus(stim).Trajectory.stagePosition.x(frame) - meanRealSpace.x(frame);
                Stimulus(stim).Trajectory.meanPosition.y(frame) = Stimulus(stim).Trajectory.stagePosition.y(frame) - meanRealSpace.y(frame);
                
            end
        end
        
        for frame = 2:Stimulus(stim).numFrames
                
                deltaX = Stimulus(stim).Trajectory.meanPosition.x(frame)-Stimulus(stim).Trajectory.meanPosition.x(frame-1);
                deltaY = Stimulus(stim).Trajectory.meanPosition.y(frame)-Stimulus(stim).Trajectory.meanPosition.y(frame-1);

                if Stimulus(stim).timeData(frame,9) <= 0.011
                    Stimulus(stim).Trajectory.speed(frame) = 0;
                else
                    Stimulus(stim).Trajectory.speed(frame) = sqrt(deltaX^2 + deltaY^2)/Stimulus(stim).timeData(frame,9);
                end
                
                %Find movement angle:
                if frame <= directionSmoothing
                    Stimulus(stim).Trajectory.movementDirection(frame) = 0;
                    Stimulus(stim).Trajectory.track(frame).amplitude = 0;
                    Stimulus(stim).Trajectory.track(frame).wavelength = 0;
                elseif (frame > directionSmoothing && frame <= Stimulus(stim).numFrames-directionSmoothing)
                    
                    deltaX = Stimulus(stim).Trajectory.meanPosition.x(frame+directionSmoothing)-Stimulus(stim).Trajectory.meanPosition.x(frame-directionSmoothing);
                    deltaY = Stimulus(stim).Trajectory.meanPosition.y(frame+directionSmoothing)-Stimulus(stim).Trajectory.meanPosition.y(frame-directionSmoothing);
                    
                    %Calculate angle:
                    if deltaX == 0
                        Stimulus(stim).Trajectory.movementDirection(frame) = 90;
                    elseif deltaX>0
                        Stimulus(stim).Trajectory.movementDirection(frame) = (180/pi) * atan(deltaY/deltaX);
                    elseif deltaX<0 && deltaY>=0
                        Stimulus(stim).Trajectory.movementDirection(frame) = 180 - (180/pi) * (atan(deltaY/abs(deltaX)));
                    elseif deltaX<0 && deltaY<0
                        Stimulus(stim).Trajectory.movementDirection(frame) = -(180 - (180/pi) * atan(abs(deltaY)/abs(deltaX))); 
                    end
                    
                    
                    [Stimulus(stim).Trajectory.amplitude(frame), Stimulus(stim).Trajectory.wavelength(frame)] = getTrackData(Stimulus(stim).Skeleton(frame).x, Stimulus(stim).Skeleton(frame).y, Stimulus(stim).Trajectory.movementDirection(frame)*pi/180);
                else 
                    Stimulus(stim).Trajectory.movementDirection(frame) = 0;
                    Stimulus(stim).Trajectory.track(frame).amplitude = 0;
                    Stimulus(stim).Trajectory.track(frame).wavelength = 0;
                end  
               
        end
           %Calculate trajectory statistics:
            stimOnFrame = find(Stimulus(stim).StimulusActivity == 1, 1);
            numPreStimFrames = length(Stimulus(stim).FramesByStimulus.PreStimFrames);
            if numPreStimFrames < 15
                cutoff = numPreStimFrames - 1;
            else
                cutoff = 15;
            end
           Stimulus(stim).Trajectory.amplitudePreStimAve = nanmean(Stimulus(stim).Trajectory.amplitude(stimOnFrame - cutoff:stimOnFrame));       
           Stimulus(stim).Trajectory.wavelengthPreStimAve = nanmean(Stimulus(stim).Trajectory.wavelength(stimOnFrame - cutoff:stimOnFrame));
           Stimulus(stim).Trajectory.amplitudePostStimAve = nanmean(Stimulus(stim).Trajectory.amplitude(stimOnFrame:stimOnFrame+55));
           Stimulus(stim).Trajectory.wavelengthPostStimAve = nanmean(Stimulus(stim).Trajectory.wavelength(stimOnFrame:stimOnFrame+55));
        end
end

