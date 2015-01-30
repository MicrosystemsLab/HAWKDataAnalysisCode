function percent = findPercentDownBody(Skeleton, index, x ,y)
    
    portionLength = 0;
    wholeLength = 0;
    for i = 2:length(Skeleton.x)
        distance = distanceCalc(Skeleton.x(i-1), Skeleton.y(i-1), Skeleton.x(i), Skeleton.y(i));
        if i <= index
            portionLength = portionLength + distance;
        elseif i == index+1
            portionDistance = distanceCalc(x, y, Skeleton.x(i-1), Skeleton.y(i-1));
            portionLength = portionLength+portionDistance;
        end
        wholeLength = wholeLength + distance;
    end
    
    percent = portionLength/wholeLength;


end