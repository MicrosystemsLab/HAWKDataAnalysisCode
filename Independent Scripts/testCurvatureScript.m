

sigma = [1:3];
numcurvpts = [50 75 100];

for j=1:3;
    for i = 1:3
        x_filtered =  lowpass1D(x,sigma(i));
        y_filtered =  lowpass1D(y,sigma(i));

        xy_smoothSpline = generateSmoothSpline([x_filtered; y_filtered],numcurvpts(j));
        curvature1 = calculateCurvatureDeltaTheta(xy_smoothSpline);
        curvature2 = calculateCurvatureDerivative(xy_smoothSpline(:,1),xy_smoothSpline(:,2));

        curvature1_smooth = lowpass1D(curvature1, 1.5);
        curvature2_smooth = lowpass1D(curvature2, 1.5);
        
        figure(j);
        
        
        subplot(2,3,i);
        plot(x,y, 'MarkerSize',12 ,'Color','r', 'Marker','+','LineStyle', 'none');
        hold on
        plot( x_filtered, y_filtered, 'LineWidth',4, 'Color','b','Marker','none');
        plot( xy_smoothSpline(:,1),xy_smoothSpline(:,2),'MarkerSize',12 ,'Color','g', 'Marker','.','LineStyle', 'none');
        hold off
%         p(1).MarkerSize = 1;
%         p(1).Marker = '+';
%         p(1).Color = 'r';
        legend('Raw Skeleton Points',...
            [num2str(numcurvpts(j)) ' Evenly Spaced Spline Points'],...
            ['Smoothed Spline Points, sigma = ' num2str(i)],...
            'Location','SouthOutside');
        axis equal;
        title({'Smoothing and Sampling Skeleton', ...
            ['Sigma = ' num2str(sigma(i))],...
            ['Number of Spline Points = ' num2str(numcurvpts(j))]},...
            'FontSize', 18)
        ylabel('y pixel coordinate', 'FontSize', 14);
        xlabel('x pixel coordinate', 'FontSize', 14);
        
        subplot(2,3,i+3);
        plot(1:length(curvature1), curvature1, 'LineWidth',2.5, 'Color','r', 'LineStyle',':','Marker','none');
        hold on
        plot(1:length(curvature2), curvature2, 'LineWidth',2.5, 'Color','b', 'LineStyle',':','Marker','none')
        plot(1:length(curvature1_smooth),curvature1_smooth, 'LineWidth',4, 'Color','r','Marker','none')
        plot(1:length(curvature2_smooth),curvature2_smooth, 'LineWidth',4, 'Color','b','Marker','none');
        hold off
        legend('Delta Theta Method','Derivative Method','Delta Theta Method, Smoothed Sigma = 1.5','Derivative Method, Smoothed Sigma = 1.5','Location','SouthOutside')
        title({'Curvature of skeleton',' Before and After Smoothing'}, 'FontSize', 18);
        ylabel('Curvature', 'FontSize', 14)
        xlabel(['1/' num2str(numcurvpts(j)) 'ths of Body Length'],  'FontSize', 14)
        axis([0 numcurvpts(j) -0.1 0.1]);
    end
end