

sigma = [1:3];
numcurvpts = [50 75 100];

for j=1:3;
    for i = 1:3
        x_filtered =  lowpass1D(x,sigma(i));
        y_filtered =  lowpass1D(y,sigma(i));

        xy_smoothSpline = generateSmoothSpline([x_filtered; y_filtered],numcurvpts(j));
        curvature1 = calculateCurvatureDeltaTheta(xy_smoothSpline);
        curvature2 = calculateCurvature(xy_smoothSpline(:,1),xy_smoothSpline(:,2));

        curvature1_smooth = lowpass1D(curvature1, 1.5);
        curvature2_smooth = lowpass1D(curvature2, 1.5);
        
        figure(j);
        %suptitle(['Number of points on the curve ', num2str(numcurvpts(j))]);
        subplot(2,3,i), plot(x,y,'r+', x_filtered, y_filtered,'b-', xy_smoothSpline(:,1),xy_smoothSpline(:,2),'g.');
        legend('Raw Spline Points',['Smoothed Spline Points, sigma = ' num2str(i)],[num2str(numcurvpts(j)) ' Evenly Spaced Spline Points'],'Location','SouthOutside');
        subplot(2,3,i+3), plot(1:length(curvature1), curvature1,'r:',1:length(curvature2),curvature2,'b:',...
            1:length(curvature1_smooth),curvature1_smooth, 'r-', 1:length(curvature2_smooth),curvature2_smooth,'b-');
        legend('Delta Theta Method','Derivative Method','Location','SouthOutside')
    end
end