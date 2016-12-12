% Create fake data for points approximately on a parabola which is at an angle theta from 'straight up'
%

theta= pi/5; % given theta as angle to rotate by

% Matrix magic: This matrix represents a rotation through angle Theta.
rotateByThetaMatrix= [cos(theta)  -sin(theta) 0 
                      sin(theta)   cos(theta) 0
                          0            0      1];

%------------------------------------------------------------------------------
%{
Example: 

[x y 1]'  = [a  0  1 ;  * [t t^2 1]'
             0  b  1 ;
             0  0  1 ]

and for the rotated case:

[x y 1]'  = rotationMatrix * coefficentsMatrix  * [t t^2 1]'
%}


% let a=b=1

unrotatedXYs= [
  -3   9  1
  -2   4  1
  -1   1  1
   0   0  1
   1   1  1
   2   4  1
   3   9  1
   4  16  1
   5  25  1
  ];

coefficients= ones(3);

tfeatures= unrotatedXYs;

randomJitter=[ rand(rows(tfeatures),2) ones(rows(tfeatures),1)];

for angle = [0 theta]

  if(angle == 0)
    rotated_tfeatures= tfeatures + randomJitter;
  else
    % Rotate the [x y 1] vectors by Theta 
    % which is done by the magic of matrix multiplication
    rotated_tfeatures= tfeatures * rotateByThetaMatrix;
  endif

  rotated_x= rotated_tfeatures(:,1);
  rotated_y= rotated_tfeatures(:,2);


  % Create features for regression learning as [rotated-x rotated-x^2]
  features= [rotated_x      ...
             rotated_x.^2   ...
             rotated_y      ...
             rotated_y.^2   ...
             rotated_x .* rotated_y ...
             ones(rows(rotated_x),1) ];
  X= features;
  y= zeros(rows(rotated_x), 1);

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
  plot(rotated_tfeatures(:,1), rotated_tfeatures(:,2), '-.k+') % data for which we found the best fit
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
