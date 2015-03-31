% Script for debugging the curvature phase shift analysis 
x = zeros(size(curvature));
x(:,1) = 1:size(curvature,1);

headCrop = 0.2;
tailCrop = 0.1;
cinds = (floor(size(curvature,1)*headCrop) : size(curvature,1)-floor(tailCrop*size(curvature,1)));

for i = 1:110
   plot(x(cinds,i),curvature(cinds,i));
   hold on
   x(:,i+1) = x(:,i)+ps(i);
    
end

