function curvature = calculateCurvature(x,y)

    x1 = diff(x);
    x2 = diff(x1);
    y1 = diff(y);
    y2 = diff(y1);
    vectorLength = length(x2);
    
    curvature = (x1(2:length(x1)).*y2 - y1(2:length(x1)).*x2)./(x1(2:length(x1)).^2 + y1(2:length(x1)).^2).^(3/2);
end