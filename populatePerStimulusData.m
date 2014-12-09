function [data, firstColumn] = populatePerStimulusData( Stimulus, titles, numStims)
    firstColumn = strmatch('Stimulus Number',titles,'exact');
   
    for stim = 1:numStims
        data(stim, strmatch('Stimulus Number',titles,'exact')-firstColumn+1) = stim;
        data(stim, strmatch('Average Body length (um)', titles, 'exact')-firstColumn+1) = Stimulus(stim).averageBodyLengthGoodFrames;
        data(stim, strmatch('STD Body Length', titles, 'exact')-firstColumn+1) = Stimulus(stim).stdBodyLengthGoodFrames;
    end
   
    
end