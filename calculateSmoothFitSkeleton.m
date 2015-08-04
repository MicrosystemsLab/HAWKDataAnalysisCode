
%%%% Function: calculate smooth fit skeleton
% This function take the original skeleton found by the tracking software,
% smooths and fits it so that all the points are equally spaced from each
% other.
%
%  params {Stimulus} struct, contains all the data for each stimulus
%  params {numStims} int, number of stimulus in this experiment
%  
%  returns {Stimulus} struct, contains all the data for each stimulus,
%  including SkeletonSmooth found in this function
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%  This method is compilation of adapted methods written by C. Fang-Yen and A.
%  Leifer. 
%%%%%


function Stimulus = calculateSmoothFitSkeleton(Stimulus, numStims)
HAWKProcessingConstants;


    for stim = 1:numStims
        skeleton = Stimulus(stim).Skeleton;
    
        for frame = 1:length(skeleton)
            x = skeleton(frame).x;
            y = skeleton(frame).y;

            %Smooth the spline via a guassian filter:
            x_filtered =  lowpass1D(x,CURVATURE_FILTERING_SIGMA);
            y_filtered =  lowpass1D(y,CURVATURE_FILTERING_SIGMA);
            %create a smooth spline of equally spaced points:
            xy_smoothSpline = generateSmoothSpline([x_filtered; y_filtered],NUMCURVPTS);
            
            Stimulus(stim).SkeletonSmooth(frame).x = xy_smoothSpline(:,1);
            Stimulus(stim).SkeletonSmooth(frame).y = xy_smoothSpline(:,2);
        end
    end

end
