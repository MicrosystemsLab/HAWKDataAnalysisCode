%% Function Swap Head, Tail 
% This function will swap the pixel coordinates of a worm if the head and
% tail need to be flipped. 
%
%  params {Stimulus} struct, Data organized by stimulus 
%  params {stim}, int, which stimulus in which to flip the frames
%  params {framesToSwap}, vector, a list of frames that need to be flipped
%  returns {Stimulus} struct, Data organized by stimulus 
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%
%%%%

function Stimulus = swapHeadTail(Stimulus,stim, framesToSwap)

    
    for frame =1:length(framesToSwap)
        tempPoint.x = Stimulus(stim).PixelPositions.head.x(frame);
        tempPoint.y = Stimulus(stim).PixelPositions.head.y(frame);
        Stimulus(stim).PixelPositions.head.x(frame) = Stimulus(stim).PixelPositions.tail.x(frame);
        Stimulus(stim).PixelPositions.head.y(frame) = Stimulus(stim).PixelPositions.tail.y(frame);
        Stimulus(stim).PixelPositions.tail.x(frame) = tempPoint.x;
        Stimulus(stim).PixelPositions.tail.y(frame) = tempPoint.y;
        Stimulus(stim).Skeleton(frame).x = fliplr(Stimulus(stim).Skeleton(frame).x);
        Stimulus(stim).Skeleton(frame).y = fliplr(Stimulus(stim).Skeleton(frame).y);
    end
end