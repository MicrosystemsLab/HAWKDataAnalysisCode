function trajectory = interpolateTrajectory(centroid_x, centroid_y, gain, smooth)

    trajectory.x = csapi(1:length(centroid_x), centroid_x, 1:1/gain:length(centroid_x));
    trajectory.y = csapi(1:length(centroid_y), centroid_y, 1:1/gain:length(centroid_y));
    
    
    for i = smooth+1:length(trajectory.x)-smooth
 
        deltaX = trajectory.x(i-smooth)-trajectory.x(i+smooth);
        deltaY = trajectory.y(i-smooth)-trajectory.y(i+smooth);
        theta = atan(abs(deltaY)/abs(deltaX))*(180/pi);
        if abs(deltaX) == 0 
            trajectory.movementDirection(i-smooth+1) = 90;
        elseif deltaX>0 && deltaY>0
            trajectory.movementDirection(i-smooth+1) = theta;
        elseif deltaX<0 && deltaY>=0
            trajectory.movementDirection(i-smooth+1) = 180 - theta;
        elseif deltaX>0 && deltaY<=0
            trajectory.movementDirection(i-smooth+1) = -theta;
        elseif deltaX<0 && deltaY<0
            trajectory.movementDirection(i-smooth+1) = -180 + theta; 
        end
    
    
    end
    
    
    
end