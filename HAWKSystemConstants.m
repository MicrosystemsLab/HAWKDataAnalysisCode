
%%%% HAWK System Constants
%  This is a list of the relevant system paramters necessary for analyzing
%  the tracking data.
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%
%%%%%

% properties of the Zaber controller:
UM_PER_MICROSTEP = 0.15625 ; 
MICROSTEP_PER_UM = 1/UM_PER_MICROSTEP;
%properties of the camera and optics:
PIXEL_PER_UM = 0.567369167;
UM_PER_PIXEL = 1/PIXEL_PER_UM;
IMAGE_WIDTH_PIXELS = 1024;
IMAGE_HEIGHT_PIXELS = 768;
PIXEL_SCALE = 1;