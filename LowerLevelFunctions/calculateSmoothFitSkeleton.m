
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
HAWKSystemConstants;

    for stim = 1:numStims
        skeleton = Stimulus(stim).Skeleton;
    
        for frame = 1:length(skeleton)
            x = skeleton(frame).x;
            y = skeleton(frame).y;
            skeletonPointsCount = length(skeleton(frame).x);
            
            %determine number of points 
            %if the worm cut off and how many points are on the edge of the
            %frame:
            Stimulus(stim).SkeletonSmooth(frame).cutoff = isWormCutOff(skeleton(frame));
            
            if (Stimulus(stim).SkeletonSmooth(frame).cutoff == 0)
                numPoints = NUMCURVPTS;
            elseif (sign(Stimulus(stim).SkeletonSmooth(frame).cutoff) == 1)
                %if head cut off, truncate front of skeleton
                x = x(Stimulus(stim).SkeletonSmooth(frame).cutoff: skeletonPointsCount);
                y = y(Stimulus(stim).SkeletonSmooth(frame).cutoff: skeletonPointsCount);
                bodyLength = calculateBodyLength(x, y)*UM_PER_PIXEL; 
                numPoints = min(round(bodyLength/Stimulus(stim).BodyMorphology.averageBodyLengthGoodFrames * NUMCURVPTS), NUMCURVPTS);
            elseif (sign(Stimulus(stim).SkeletonSmooth(frame).cutoff) == -1)
                % if tail cut off, truncate end of skeleton
                x = x(1:skeletonPointsCount-abs(Stimulus(stim).SkeletonSmooth(frame).cutoff)+1);
                y = y(1:skeletonPointsCount-abs(Stimulus(stim).SkeletonSmooth(frame).cutoff)+1); 
                bodyLength = calculateBodyLength(x, y)*UM_PER_PIXEL; 
                numPoints = min(round(bodyLength/Stimulus(stim).BodyMorphology.averageBodyLengthGoodFrames * NUMCURVPTS), NUMCURVPTS);
            end
            
           %Smooth the spline via a guassian filter:
           try
               x_filtered =  lowpass1D(x,CURVATURE_FILTERING_SIGMA);
               y_filtered =  lowpass1D(y,CURVATURE_FILTERING_SIGMA);
           catch  % If the skeleton is too short, don't bother filtering:
               x_filtered = x;
               y_filtered = y;
           end
            %create a smooth spline of equally spaced points:
            xy_smoothSpline = generateSmoothSpline([x_filtered; y_filtered],numPoints);
            
            %save the truncated skeleton, smoothed skeleton
            Stimulus(stim).SkeletonTruncate(frame).x = x;
            Stimulus(stim).SkeletonTruncate(frame).y = y;
            Stimulus(stim).SkeletonSmooth(frame).x = xy_smoothSpline(:,1);
            Stimulus(stim).SkeletonSmooth(frame).y = xy_smoothSpline(:,2);
        end
    end

end
