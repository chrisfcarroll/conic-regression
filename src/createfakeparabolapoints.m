% Create fake data for points approximately on a parabola, 
% oriented approximately facing downwards-right with axis of symmetry
% at angle around -30 degrees down from the x-axis
%
topleft= [      rand(100) 
          500 + rand(100)];

minangle= -0.3; maxangle= -0.7;
theta=- minangle + rand() * (maxangle-minangle);
rot=[cos(theta)  -sin(theta) 0 
     sin(theta)   cos(theta) 0
         0            0      1];

rot2=[cos(theta/2)  -sin(theta/2) 
     sin(theta/2)   cos(theta/2)];

a=-1; b=0; c=0;
Q1= [a  0  b 
         0  0 -1 
         0  0  c];

quadratic= @(xy, M)([xy 1] * M * [xy 1]');
rotatedquadratic= @(xy, M, rot)([xy 1] * rot' * M * rot * [xy 1]');

for x= -10:10
  y= -x^2;
  xyR= [x y 1] * rot
  assert( rotatedquadratic ( ([-3 -9 1] * rot)(1:2) , Q1, rot ), 0, 1e14);
endfor


input= [
  -1  -1
  0  0
  1  -1
  2  -4
  3  -9
  4  -16
  5  -25
  ];

xyR= [input ones(rows(input),1)] * rot;
xR= xyR(:,1);
features= [xR xR.^2 ones(rows(xR),1)];


m = length(input);             % number of points
%X = [ones(m,1), input(:,1)];   % forming X of X beta = y
%y = input(:,2);                % forming y of X beta = y
X= features;
y= xyR(:,2);

betaHat = (X' * X) \ X' * y;   % computing projection of matrix X on y, giving beta
% display best fit parameters
disp(betaHat);

xx = linspace(-1, 5, 20);
yy = betaHat(1) + betaHat(2)*xx + betaHat(3) * xx.^2;
plot(xx, yy) % plot the best fit line
hold on
plot(input(:,1), input(:,2), 'or') % data for which we found the best fit
hold off
