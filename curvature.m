% function curve = curvature(skeleton, sigma, numcurvpts)

    curve = zeros(numcurvpts,length(skeleton));
%     curvature_smooth = zeros(numcurvpts,length(skeleton));
    for frame = 1:length(skeleton)
        x = skeleton(frame).x;
        y = skeleton(frame).y;
        
        x_filtered =  lowpass1D(x,sigma);
        y_filtered =  lowpass1D(y,sigma);

        xy_smoothSpline = generateSmoothSpline([x_filtered; y_filtered],numcurvpts);
        curve(:,frame) = calculateCurvature2(xy_smoothSpline, numcurvpts);
%         curvature_smooth(:,frame) = lowpass1D(curvature, 1.5);
      
    end


% end