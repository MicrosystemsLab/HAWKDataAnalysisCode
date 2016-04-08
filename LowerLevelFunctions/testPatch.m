lowerBound = -floor(length(xs)*headCrop);
upperBound = floor(length(xs)*tailCrop);

x_signGuess = sign(x);


% i = 122;
% while abs(x_new) > 0.95*abs(lowerBound)
    %Re-truncate nextCurve
    lowerBound = lowerBound - 1;
    upperBound = upperBound + 1;
    cinds = xs(abs(lowerBound) : length(xs) - upperBound );
    nextCurve = curvature(cinds,i+1)';
    
    %New guess at x0:
    x0 = (x+lowerBound)/2;
    shiftfn = @(x, xdata) interp1(xs, xdata, cinds(~isnan(nextCurve)) + x, 'linear');
    [x_new, residual] = lsqcurvefit(shiftfn, x0, curveAccumulated, nextCurve(~isnan(nextCurve)), -length(xs)*headCrop*2, length(xs)*tailCrop*2, op);
                
    
    
% end


