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

