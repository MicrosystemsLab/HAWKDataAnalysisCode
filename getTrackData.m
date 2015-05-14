%%%% Function: Get Track Data
%  Extracts the amplitude and wavelength of the current worm skeleton. It
%  rotates the skeleton to the x-axis and then finds the amplide and
%  wavelength.
% 
%  param {xx} vector<int>,  the x coordinates of the skeleton
%  param {yy} vector<int>,  the y coordinates of the skeleton.
%  param {theta} double, the angle to rotate the skeleton.

%  returns {track} struct, contains the amplitude and wavelength vectors of
%  the skeleton
% 
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%  Method adapted from Cronin, et al, 2005
%
%%%%%


function [amplitude wavelength] = getTrackData(x, y, theta)
       HAWKSystemConstants;
       HAWKProcessingConstants;
       numPoints = 100;
        %Smooth the spline via a guassian filter:
        x_filtered =  lowpass1D(x,CURVATURE_FILTERING_SIGMA);
        y_filtered =  lowpass1D(y,CURVATURE_FILTERING_SIGMA);
        %create a smooth spline of equally spaced points:
        xy_smoothSpline = generateSmoothSpline([x_filtered; y_filtered],numPoints);
        
        xx = xy_smoothSpline(:,1)';
        yy = xy_smoothSpline(:,2)';
       
        npts = length(xx);
        nintervals = npts - 1;
        
        w = [xx; yy];   % Matrix of x's & y's
        w(3,:) = 1;     % Bottom row of 1's
    
 
%----TRACK AMPLITUDE--------------------------------------
        % Establish velocity direction as centerline
        midptx = mean(xx);      % Reference point at ~middle of worm
        midpty = mean(yy);
        
        
        % Translation transform
        A = [1   0   -midptx;
             0   1   -midpty;
             0   0    1];
    
        % Rotation transform
        B = [cos(-theta)  -sin(-theta)   0;   
             sin(-theta)   cos(-theta)   0;
             0            0            1];

          % Combined transform
        C = B*A;
        
        % Do the transformations
        ww = C*w;
    
        % Parse transformed worm-coordinate matrix 
        wwx = ww(1,:);  % x&y coordinate vectors
        wwy = ww(2,:);
        
        % Calculate track amplitude 
        amplitude = (max(wwy) - min(wwy)).*UM_PER_PIXEL;  % Width of bounding box
                                        %   aligned with x-axis
                                        %   (in pixels, then converted to um)
                                        
        % calculate track wavelength - TBD
        df2 = diff([wwx' wwy'],1,1); df2p = df2';
        splineLength =  cumsum([0, sqrt([1 1]*(df2p.*df2p))]);
        
        % Reference vector of equally distributed X-positions
        iwwx = [wwx(1) : (wwx(end)-wwx(1))/nintervals : wwx(end)];
        
        % Signal interpolated to reference vector
        iwwy = interp1(wwx, wwy, iwwx); 
        
        
        samplingFrequency = IMAGE_WIDTH_PIXELS/2;
        % Calculate spatial frequency of signal (cycles/PIXEL)
        iY = fft(iwwy, samplingFrequency);
        iPyy = iY.* conj(iY) /  samplingFrequency; % Power of constitutive 
                                        %   "frequency" components
                                        %   (From Matlab online 
                                        %   documentation for _fft [1]_)
                                        
         xlength = max(iwwx) - min(iwwx);    % Worm length (pixels)
        
          % Vector of "frequencies" (cycles/pixel), from 0 (steady 
            %   state factor) to Nyquist frequency (i.e. 0.5*sampling 
            %   frequency).  (In our case sampling frequency is 
            %   typically 12 samples per worm).  
            % (Nyquist frequency is the theoretical highest frequency
            %   that can be accurately detected for a given sampling 
            %   frequency.)
            %Not sure where 512 comes from
          f = (nintervals/xlength)*(0: samplingFrequency/2)/ samplingFrequency;
         % Find index(es) of maximum power measurement (for look-up 
            %   in frequency vector)
            indx = find( iPyy(1: samplingFrequency/2+1) == max(iPyy(1: samplingFrequency/2+1)) );
            
            if ( prod(size(indx)) == 1 ) & ( f(indx(1)) == 0 )
                wavelnth = NaN;     % Disregard the (expected-to-be- 
                                    %   rare) case where 0 Hz is the
                                    %   only maximum-power frequency
            else
                if f(indx(1)) == 0  % If the first element yields 0 Hz,
                    indx = indx(2:end); % take the next element
                end
            
                % Calculate wormtrack wavelength (finally...)
                wavelnth = 1/f(indx(1));     % In pixels/cycle
                
                wavelnth = wavelnth * UM_PER_PIXEL;   % Convert 
                                                    %   wavelength 
                                                    %   into um/cycle
                
            end
                                        
                                        
       
        wavelength = wavelnth;%getZeroCrossings(wwx, wwy);

end