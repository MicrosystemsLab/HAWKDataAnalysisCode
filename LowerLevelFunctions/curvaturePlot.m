%%%% Function: curvature Plot
%  This function creates the kymograph image representing the curvature
%  with respective to frame. 
%
%  params {curvature} 2D vector, i: time or frame, j: longitudinal location points
%  params {numberoflocation} double,  number of longitudinal location points 
%  params {upperlimit}, double, upper limit of curvature (typical : 0.035)
%  params {lowerlimit}, double, lower limit of curvature (typical : -0.035)
%  returns {curvatureimage} struct, contains a uint8 for each red, green,
%  blue channel, a 3D matrix image to be printed and the scalred curvature
%  data.
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%  This was adapted from the methods orginally written by Sung-Jin Park,
%  Jan 2010
%
%%%%%

function curvatureimage = curvaturePlot(curvature, numberoflocation, upperlimit, lowerlimit)


for i=1:size(curvature,1)
    curvaturetoPlot(i,:) = curvature(i,round(1+(size(curvature,2)-1)...
        /(numberoflocation-1)*(0:(numberoflocation-1))));
    for j=1:numberoflocation
        if (isnan(curvaturetoPlot(i,j)))
            imageR(j, i) = uint8(200);
            imageG(j, i) = uint8(200);
            imageB(j, i) = uint8(200);
        elseif (curvaturetoPlot(i,j)>0)
            
            imageR(j, i) = uint8(255-255/(upperlimit)*(curvaturetoPlot(i,j)));
            imageG(j, i) = uint8(255-255/(upperlimit)*(curvaturetoPlot(i,j)));
            imageB(j, i) = uint8(255);
        else
            imageR(j, i) = uint8(255);
            imageG(j, i) = uint8((255/(-lowerlimit)*(curvaturetoPlot(i,j)-lowerlimit)));
            imageB(j, i) = uint8((255/(-lowerlimit)*(curvaturetoPlot(i,j)-lowerlimit)));
        end
    end
    curvatureimage.R = imageR;
    curvatureimage.G = imageG;
    curvatureimage.B = imageB;
    curvatureimage.curvaturetoPlot = curvaturetoPlot;
    
end

% curvatureimage.img = [curvatureimage.R; curvatureimage.G; curvatureimage.B];
curvatureimage.img(:,:,1) = curvatureimage.R;
curvatureimage.img(:,:,2) = curvatureimage.G;
curvatureimage.img(:,:,3) = curvatureimage.B;
end

