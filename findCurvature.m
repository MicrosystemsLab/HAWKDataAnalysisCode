%%%% Function: find curvature
% This function takes a series of skeletons and finds the curvature of each
% one.
%
%  params {skeleton} struct, contains the smoothed, fit skeleton to be
%  analyzed for curvature.
% 
%  returns {curvature_smooth} matrix containing the curvature at each point
%  for each skeleton.
%  returns {distanceBetweenPoints}, 
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%  This method is compilation of adapted methods written by C. Fang-Yen and A.
%  Leifer. 
%%%%%


function [Stimulus]= findCurvature(Stimulus, numStims)%, sigma, numcurvpts)
    HAWKProcessingConstants;
    
    for stim = 1:numStims
        skeleton = Stimulus(stim).SkeletonSmooth;

        numFrames = length(skeleton);
       % [, distanceBetweenPoints] = findCurvature(skeleton);%,CURVATURE_FILTERING_SIGMA,NUMCURVPTS);
        
        %Create structures to hold data:
        curvature_smooth = zeros(NUMCURVPTS,length(skeleton));
        distanceBetweenPoints = zeros(1,NUMCURVPTS);
        %for each skeleton spline, do the following:
        for frame = 1:length(skeleton)

            %Calculate the curvature based on the delta Theta method:
            [curvature, distanceBetweenPoints(1,frame) ] = calculateCurvatureDeltaTheta([skeleton(frame).x skeleton(frame).y]);
            %Use filter again to smooth the curvature:
            
            if (sign(Stimulus(stim).SkeletonSmooth(frame).cutoff) == 1)
                zeroPad = NaN(1,NUMCURVPTS - length(curvature));
                try
                    curvature_smooth(:,frame) = [zeroPad lowpass1D(curvature, 1.5)];
                catch
                    curvature_smooth(:,frame) = [zeroPad curvature];
                end
                
            elseif (sign(Stimulus(stim).SkeletonSmooth(frame).cutoff) == -1);
                zeroPad = NaN(1,NUMCURVPTS - length(curvature));
                try
                    curvature_smooth(:,frame) = [lowpass1D(curvature, 1.5) zeroPad];
                catch
                     curvature_smooth(:,frame) = [curvature zeroPad];
                end
            else
                curvature_smooth(:,frame) = lowpass1D(curvature, 1.5);
            end
        end
       
       Stimulus(stim).CurvatureAnalysis.curvature = curvature_smooth;
       
       
       
        Stimulus(stim).CurvatureAnalysis.curvatureimage = curvaturePlot(Stimulus(stim).CurvatureAnalysis.curvature',NUMCURVPTS, 0.035, -0.035);
   
    end

end