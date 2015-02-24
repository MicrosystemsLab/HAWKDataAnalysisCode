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
    
        directionSmoothing = 1; %frames.

        for frame = 1:Stimulus(stim).numFrames
            Stimulus(stim).headRealSpace.x(frame) = (IMAGE_WIDTH_PIXELS - Stimulus(stim).head.x(frame)).*UM_PER_PIXEL;
            Stimulus(stim).headRealSpace.y(frame) = Stimulus(stim).head.y(frame).*UM_PER_PIXEL;
            Stimulus(stim).tailRealSpace.x(frame) = (IMAGE_WIDTH_PIXELS - Stimulus(stim).tail.x(frame)).*UM_PER_PIXEL;
            Stimulus(stim).tailRealSpace.y(frame) = Stimulus(stim).tail.y(frame).*UM_PER_PIXEL;
            Stimulus(stim).centroidRealSpace.x(frame) = (IMAGE_WIDTH_PIXELS - Stimulus(stim).centroid.x(frame)).*UM_PER_PIXEL;
            Stimulus(stim).centroidRealSpace.y(frame) = Stimulus(stim).centroid.y(frame).*UM_PER_PIXEL;
            Stimulus(stim).meanRealSpace.x(frame) = (IMAGE_WIDTH_PIXELS - Stimulus(stim).meanPosition.x(frame)).*UM_PER_PIXEL;
            Stimulus(stim).meanRealSpace.y(frame) = Stimulus(stim).meanPosition.y(frame).*UM_PER_PIXEL;

            if frame == 1
                Stimulus(stim).stagePosition.x(1) = 0;
                Stimulus(stim).stagePosition.y(1) = 0;
                Stimulus(stim).headPosition.x(1) = Stimulus(stim).stagePosition.x(1) + Stimulus(stim).headRealSpace.x(1);
                Stimulus(stim).headPosition.y(1) = Stimulus(stim).stagePosition.y(1) + Stimulus(stim).headRealSpace.y(1);
                Stimulus(stim).tailPosition.x(1) = Stimulus(stim).stagePosition.x(1) + Stimulus(stim).tailRealSpace.x(1);
                Stimulus(stim).tailPosition.y(1) = Stimulus(stim).stagePosition.y(1) + Stimulus(stim).tailRealSpace.y(1);
                Stimulus(stim).centroidPosition.x(1) = Stimulus(stim).stagePosition.x(1) + Stimulus(stim).centroidRealSpace.x(1);
                Stimulus(stim).centroidPosition.y(1) = Stimulus(stim).stagePosition.y(1) + Stimulus(stim).centroidRealSpace.y(1);
                Stimulus(stim).meanPosition.x(1) = Stimulus(stim).stagePosition.x(1) + Stimulus(stim).meanRealSpace.x(1);
                Stimulus(stim).meanPosition.y(1) = Stimulus(stim).stagePosition.y(1) + Stimulus(stim).meanRealSpace.y(1);
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
                
                Stimulus(stim).meanPosition.x(frame) = Stimulus(stim).stagePosition.x(frame) + Stimulus(stim).meanRealSpace.x(frame);
                Stimulus(stim).meanPosition.y(frame) = Stimulus(stim).stagePosition.y(frame) + Stimulus(stim).meanRealSpace.y(frame);
                
                
                deltaX = Stimulus(stim).meanPosition.x(frame)-Stimulus(stim).meanPosition.x(frame-1);
                deltaY = Stimulus(stim).meanPosition.y(frame)-Stimulus(stim).meanPosition.y(frame-1);

                if Stimulus(stim).timeData(frame,9) <= 0.011
                    Stimulus(stim).speed(frame) = 0;
                else
                    Stimulus(stim).speed(frame) = sqrt(deltaX^2 + deltaY^2)/Stimulus(stim).timeData(frame,9);
                end
                
                %Find movement angle:
                if frame <= directionSmoothing
                    Stimulus(stim).movementDirection(frame) = 0;
                    Stimulus(stim).track(frame) = 0;
                elseif frame > directionSmoothing
                    
                    deltaX = Stimulus(stim).meanPosition.x(frame)-Stimulus(stim).meanPosition.x(frame-directionSmoothing);
                    deltaY = Stimulus(stim).meanPosition.y(frame)-Stimulus(stim).meanPosition.y(frame-directionSmoothing);
                    
                    %Calculate angle:
                    if deltaX == 0
                        Stimulus(stim).movementDirection(frame) = 90;
                    elseif deltaX>0
                        Stimulus(stim).movementDirection(frame) = (180/pi) * atan(deltaY/deltaX);
                    elseif deltaX<0 && deltaY>=0
                        Stimulus(stim).movementDirection(frame) = 180 - (180/pi) * (atan(deltaY/abs(deltaX)));
                    elseif deltaX<0 && deltaY<0
                        Stimulus(stim).movementDirection(frame) = -(180 - (180/pi) * atan(abs(deltaY)/abs(deltaX))); 
                    end
                    
                    
                    Stimulus(stim).track(frame) = getTrackData(Stimulus(stim).Skeleton(frame).x, Stimulus(stim).Skeleton(frame).y, Stimulus(stim).movementDirection(frame));
                end
                
               
            end
        end
    end

end