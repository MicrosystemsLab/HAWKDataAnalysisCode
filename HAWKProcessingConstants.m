

%Percentage of body length average to use as threshold for filtering
%frames.
BODY_LENGTH_PERCENT_THRESHOLD = 0.85;
NUM_FAILED_FRAMES_DURING_STIM = 5;
PHASE_SHIFT_RESIDUAL_LIMIT = 10^-2;
WIDTH_AT_TARGET_LIMIT = 125;
FRAME_SCORE_THRESHOLD = 1;
metricWeights = [0.6; 0.8; 1; 0.6];

%Number of points to use for spline in curvature determination:
NUMCURVPTS = 50;
%How much to filter the skeleton before fitting the smooth spline:
CURVATURE_FILTERING_SIGMA = 1;
