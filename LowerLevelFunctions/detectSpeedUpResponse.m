%%%% Function: Detect Speed Up Response
%  Detect speed up response with acceleration window threshold - checks
%  inside windows 4 frames wide to see if there are three or more frames
%  with an acceleration greater than the threshold.
%
%  params {velocity} vector<double>, entries correspond to the velocity of
%  the animal. 
%  params {stimStartIndex} vector<double>, entries correspond to the time
%  of sampling each entry in {velocity}
%  params {stimEndIndex} int, the index which corresponds to the last frame
%  before the end of the stimulus
%  params {THRESHOLD} double, the velocity change threshold 
% 
%  returns {score} int,
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%%%%%



function score = detectSpeedUpResponse(velocity, time, stimStartIndex, stimEndIndex, THRESHOLD)
    frameWidth = 4; 
    score = 4; %initialize with no response
    
    acceleration = diff(velocity')./diff(time);
    accelerationThreshold = -1*(sign(THRESHOLD + acceleration)-1)./2;
    
    for frame = stimStartIndex:stimEndIndex-frameWidth-1
        test = accelerationThreshold(frame:frame+frameWidth);
        if sum(test)>=3
            score = 2;
        end
    end
end