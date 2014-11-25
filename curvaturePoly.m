function curve = curvaturePoly(spinex, spiney, gain, numberofpoly)

%sung-jin park 2010 Jan curvature and interpolation of midline of worm.

px = polyfit(1:length(spinex), spinex, numberofpoly);
py = polyfit(1:length(spiney), spiney, numberofpoly);
interpolatedpolyx = polyval(px,1:1/gain:21); 
interpolatedpolyy = polyval(py,1:1/gain:21);

x1poly = diff(interpolatedpolyx,1);
x2poly = diff(interpolatedpolyx,2);
y2poly = diff(interpolatedpolyy,2);
y1poly = diff(interpolatedpolyy,1);
for(i=1:length(x1poly)-1) x1midpoly(i)=0.5*(x1poly(i)+x1poly(i+1)); end
for(i=1:length(y1poly)-1) y1midpoly(i)=0.5*(y1poly(i)+y1poly(i+1)); end

curve.curvature = (x1midpoly.*y2poly-y1midpoly.*x2poly)./(x1midpoly.*x1midpoly+y1midpoly.*y1midpoly);
curve.x = interpolatedpolyx;
curve.y = interpolatedpolyy;

