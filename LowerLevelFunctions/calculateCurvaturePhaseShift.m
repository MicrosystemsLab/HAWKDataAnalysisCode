%%%% Function: calculate the phase shift of the curvature
%  This function calculates the phase shift of the curvature between
%  frames. 
%
%  params {curvature} maxtrix, each column is the smoothed curvature matrix
%  from a single frame. The first row is the head, the last row is the
%  tail.
%  params {stim} int, the stimulus that this phase shift calculation
%  corresponds to.
%  params {badFrames} vector<int>, a list of the frames to ignore in the
%  calulation.
%  returns {ps} 1D vector, contains the phase shift between frames.
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%  This was adapted from the methods orginally written by C. Fang-Yen and
%  modified by A. Leifer.
%
%%%%%
function [ps, ps_residual] = calculateCurvaturePhaseShift(curvature, stim, badFrames)

   
    %omit head and tail portion of the worm to discount foraging behavior:
    headCrop = 0.15;
    tailCrop = 0.15;
    

    
    alpha_accum = 0.25;
    %Create vector of indices:
    xs = 1:size(curvature,1);
    lowerBound = -floor(length(xs)*headCrop);
    upperBound = floor(length(xs)*tailCrop);
    %Crop indice vector using tail and head portion cut offs:
    cinds = xs(floor(headCrop*length(xs)) : length(xs) - floor(tailCrop*length(xs)) );

    %Function returns the curvature data that corresponds to a shift of the indices
    %xs = indices
    %xdata = curvature data
    %cinds + x: shift indices by x
    %returns the data that corresponds to cinds+x, fit linearly.
%     shiftfn = @(x, xdata) interp1(xs, xdata, cinds + x, 'linear');
    numberOfCurves = size(curvature,2);

    % Set up least squares fit:
    op = optimset('lsqcurvefit');
    op.Display = 'off';
    op.MaxIter = 1000;
    x = 0; 

    %initialize with the first curve:
    curveAccumulated = curvature(:,1)';
    flipFlag = false;
    for i = 1:numberOfCurves-1
        if (ismember(i+1,badFrames))
%             x = 0;
            ps(i) = NaN;
            ps_residual(i) = NaN;
        else
            %select the next curve to compare:
            nextCurve = curvature(cinds,i+1)';
            %We find the "x" that will minimize the least squares error between
            %the next curve and shiftfn when evaluated at x and the current curve 
            try 
                shiftfn = @(x, xdata) interp1(xs, xdata, cinds(~isnan(nextCurve)) + x, 'linear');
                [x_new, residual] = lsqcurvefit(shiftfn, x, curveAccumulated, nextCurve(~isnan(nextCurve)), -length(xs)*headCrop*2, length(xs)*tailCrop*2, op);
               
            catch
                try 
                    %Maybe head, tail are flipped?
                    nextCurve = fliplr(nextCurve).*-1;
                    shiftfn = @(x, xdata) interp1(xs, xdata, cinds(~isnan(nextCurve)) + x, 'linear');
                    [x_new, residual] = lsqcurvefit(shiftfn, x, curveAccumulated, nextCurve(~isnan(nextCurve)), -length(xs)*headCrop*2, length(xs)*tailCrop*2, op);
                
                catch
                    x_new = 0; 
                    residual=NaN; 
                    disp([' Stimulus:  ' num2str(stim) ' Frame:  ' num2str(i) ': least squares curve fit failed!']);
                end
            end
   
            %Save phase shift value:
            if (x_new<0.97*lowerBound && sign(x) == 1) || (x_new>0.97*upperBound && sign(x) == -1)
                 ps(i) = -x_new;
                 x = -x_new*0.5;
                flipFlag(i) = true;
            else
                 ps(i) = x_new;
                 x = x_new;
                flipFlag(i) = false;
            end
            ps_residual(i) = residual;
            
            

                
%               %FOR DEBUG: DELETE ME
%             figure(1), plot(cinds+sum(ps),nextCurve)
%             hold on
%             figure(2), plot(xs, curveAccumulated, cinds + x, nextCurve)
            
            
            curveAccumulated = nansum(...
                [alpha_accum * interp1(xs,curveAccumulated,xs+x,'linear','extrap'); ...
                (1-alpha_accum) * curvature(:,i+1)']);

        end
    end


end