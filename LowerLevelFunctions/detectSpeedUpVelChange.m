
%%%% Function: SpeedUp Vel Change
%  Detect speed up response with velocity window threshold - checks for a
%  window of four frames where the velocity is always larger than the
%  threshold. If found, the score returns as 2, indicating a speed up.
%
%  params {velocity} vector<double>, entries correspond to the velocity of
%  the animal. 
%  params {stimStartIndex} vector<double>, entries correspond to the time
%  of sampling each entry in {velocity}
%  params {stimEndIndex} int, the index which corresponds to the last frame
%  before the end of the stimulus
%  params {THRESHOLD} double, the velocity change threshold 
%   
%  returns {score} int, is 2 if a speed up is detected. Otherwise, it
%  returns 4.
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%%%%%

function score = detectSpeedUpVelChange( velocity, stimStartIndex, stimEndIndex, THRESHOLD )


    frameWidth = 4; 
    score = 4; %initialize with no response
    
    velocityThreshold = velocity<THRESHOLD;
    
    for frame = stimStartIndex:stimEndIndex-frameWidth-1
        test =  velocityThreshold(frame:frame+frameWidth);
        if sum(test)>4
            score = 2;
        end
    end
    
end

