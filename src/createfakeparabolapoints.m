% Create fake data for points approximately on a parabola which is at an angle theta from 'straight up'
%

theta= pi/5; % given theta as angle to rotate by

% Matrix magic: This matrix represents a rotation through angle Theta.
rotateByThetaMatrix= [cos(theta)  -sin(theta) 0 
                      sin(theta)   cos(theta) 0
                          0            0      1];

%------------------------------------------------------------------------------
%
% Example: y = -x^2 + C
%
% Create a sample list of (x, y= -x^2, constant) points 
inputXYs= [
  -3  -9  1
  -2  -4  1
  -1  -1  1
   0   0  1
   1  -1  1
   2  -4  1
   3  -9  1
   4  -16 1
   5  -25 1
  ];
randomJitter= [ rand(length(inputXYs),2) ones(length(inputXYs),1)];

for angle = [0 theta]

  if(angle == 0)
    rotated_xy= inputXYs + randomJitter;
  else
    % Rotate the [x y 1] vectors by Theta 
    % which is done by the magic of matrix multiplication
    rotated_xy= inputXYs * rotateByThetaMatrix;
  endif

  rotated_x= rotated_xy(:,1);
  rotated_y= rotated_xy(:,2);


  % Create features for regression learning as [rotated-x rotated-x^2]
  features= [rotated_x rotated_x.^2 ones(rows(rotated_x),1) ];
  X= features;
  y= rotated_y;

  % Solve it in one line
  coefficients = (X' * X) \ X' * y; 


  % Show the original points and the extrapolation
  disp(coefficients);
  figure(ifelse(angle==0, 1,2))
  if(angle==0)
    extrapolatedX = linspace(-4, 7, 20);
    extrapolatedY = coefficients(1)*extrapolatedX + coefficients(2) * extrapolatedX.^2 + coefficients(3);
    plot(extrapolatedX, extrapolatedY, '-co')
    title('Black is original, blue is extrapolated')
  else
    title('Rotated quadratics aren''t that hard')
  endif
  hold on
  plot(rotated_xy(:,1), rotated_xy(:,2), '-.k+') % data for which we found the best fit
  hold off

endfor


%----------------------------------------------------------
%
% Aside: How to create a function that represents a rotated quadratic: (ax^2 + bx + c - y ) * rotateByThetaDegrees
%
a=-1; b=0; c=0;
Q1= [a  0  b 
     0  0 -1 
     0  0  c];
quadratic= @(xy, M)([xy 1] * M * [xy 1]'); % this calculates (ax^2 + bx + c - y)
rotatedquadratic= @(xy, M, rotateByThetaMatrix)([xy 1] * rotateByThetaMatrix' * M * rotateByThetaMatrix * [xy 1]');
%
%----------------------------------------------------------
