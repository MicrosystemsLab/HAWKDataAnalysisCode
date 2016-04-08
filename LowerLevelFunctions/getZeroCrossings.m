%%%% Function: Get Zero Crossings
%  Determine if the vector crosses zero, determining the wavelength
%
%  params {x} vector<double>, x-coordinate of vecotor 
%  params {y} vector<double>, y-coordinate of vecotor 
%
%  return {guessPre} double, wavelength of vector as determined by the
%  space/time between zero crossings
% 
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%
%%%%%

function guessPre = getZeroCrossings(x, y)

    Hzerocross = dsp.ZeroCrossingDetector;
    NumZeroCross = step(Hzerocross,lowpass1D(y,10));
    NumZeroCrossHalf = double(NumZeroCross/2);
    range = abs(min(x)-max(x));
    guessPre = (range/NumZeroCrossHalf);

end
