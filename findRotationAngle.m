

function theta = findRotationAngle(skeleton)
warning('off', 'curvefit:fit:noStartPoint')
    

    delta_y = skeleton.y(1) - skeleton.y(end);
    delta_x = skeleton.x(1) - skeleton.x(end);
    m = delta_y/delta_x;
    b = skeleton.y(1) - m*skeleton.x(1);


    f = fittype('a*x+b');
    line = fit(skeleton.x, skeleton.y,f,'StartPoint',[m b]);
    
    theta = atan(line.a);
    
    if (line.a>0 & delta_y<0)
        theta = theta-pi;
    elseif (line.a<0 & delta_y>0)
        theta = theta + pi;
        
    end
        
end