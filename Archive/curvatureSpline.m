function curve = curvatureSpline(spinex, spiney, gain)%, numberofpoly)

    %sung-jin park 2010 Jan curvature and interpolation of midline of worm.
    %Eileen Mazzochette 2014 modified for HAWK.
    
    %truncate skeleton for analysis
    anteriorTruncate = 0.25;
    posteriorTruncate = 0.1;
    
    
   
    
    truncSpinex = spinex;%([anteriorPointsToEliminate:numSkeletonPoints-posteriorPointsToEliminate]);
    truncSpiney = spiney;%([anteriorPointsToEliminate:numSkeletonPoints-posteriorPointsToEliminate]);
    
    interpolatedx = csapi(1:length(truncSpinex), truncSpinex, 1:1/gain:length(truncSpinex));
    interpolatedy = csapi(1:length(truncSpiney), truncSpiney, 1:1/gain:length(truncSpiney));

    
    x1 = diff(interpolatedx,1);
    x2 = diff(interpolatedx,2);
    y2 = diff(interpolatedy,2);
    y1 = diff(interpolatedy,1);
    
    curvature = (x1(2:length(x1)).*y2 - y1(2:length(x1)).*x2)./(x1(2:length(x1)).^2 + y1(2:length(x1)).^2).^(3/2);
%     for(i=1:length(x1)-1) x1mid(i)=0.5*(x1(i)+x1(i+1)); end
%     for(i=1:length(y1)-1) y1mid(i)=0.5*(y1(i)+y1(i+1)); end

%     curve.curvature = (x1mid.*y2-y1mid.*x2)./(x1mid.*x1mid+y1mid.*y1mid);

    numSkeletonPoints = length(curvature);
    anteriorPointsToEliminate = floor(anteriorTruncate*numSkeletonPoints);
    posteriorPointsToEliminate = floor(posteriorTruncate*numSkeletonPoints);
    
    curve.curvature = curvature([anteriorPointsToEliminate:numSkeletonPoints-posteriorPointsToEliminate]);
    
    
    curve.x = interpolatedx;
    curve.y = interpolatedy;
    
end