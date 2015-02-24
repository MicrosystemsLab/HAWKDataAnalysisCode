function [track] = getTrackData(xx, yy, theta)
        
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
        track.amplitude = max(wwy) - min(wwy);  % Width of bounding box
                                        %   aligned with x-axis
                                        %   (in pixels)
                                        
        % calculate track wavelength - TBD
        track.wavelength = 0;

end