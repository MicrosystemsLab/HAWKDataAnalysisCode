function Stimulus = findOmegaTurnsBasedOnConsecutiveDroppedFrames(Stimulus,numStims)

    clear Stimulus.omegaTurnRanges;

    for stim = 1:numStims % Find Omega Turns
    if (length(Stimulus(stim).droppedFrames)>=3)
        bodyLengthDiff = diff(Stimulus(stim).droppedFrames);
        consecutiveCount = 0;
        blockCount = 1;
        for i = 1:length(bodyLengthDiff)
            if bodyLengthDiff(i) < 3
               consecutiveCount = consecutiveCount+1; 
            else
                block(blockCount,1) = consecutiveCount;
                block(blockCount,2) = i;
                blockCount = blockCount + 1;
               consecutiveCount = 0;
            end

            if (i == length(bodyLengthDiff))
                block(blockCount,1) = consecutiveCount;
                block(blockCount,2) = i;
                blockCount = blockCount + 1;
               consecutiveCount = 0;
            end

        end
        ind = find(block(:,1)>20);
        omegaTurnIndices = block(ind,2);
        Stimulus(stim).omegaTurnRanges = [Stimulus(stim).droppedFrames(omegaTurnIndices-block(ind,1)+1)' Stimulus(stim).droppedFrames(omegaTurnIndices)'];
        dimensions = size(Stimulus(stim).omegaTurnRanges);
        for i = 1:dimensions(1)
            Stimulus(stim).omegaTurnFrames = Stimulus(stim).omegaTurnRanges(i,1):Stimulus(stim).omegaTurnRanges(i,2);
        end
    end
    clear ind;
    clear block;
    clear omegaTurnIndices;
    clear dimensions;


end