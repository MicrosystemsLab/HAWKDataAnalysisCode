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