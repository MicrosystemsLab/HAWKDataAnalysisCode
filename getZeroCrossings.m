function guessPre = getZeroCrossings(x, y)

    Hzerocross = dsp.ZeroCrossingDetector;
    NumZeroCross = step(Hzerocross,lowpass1D(y,10));
    NumZeroCrossHalf = double(NumZeroCross/2);
    range = abs(min(x)-max(x));
    guessPre = (range/NumZeroCrossHalf);

end
