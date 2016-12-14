%{ 
------------------------------------------------------------------------------
Create fake data for points approximately on a parabola which is at an angle theta from 'straight up'

Example: 
[x y 1]'  = [a  0  1 ;  * [t t^2 1]'
             0  b  1 ;
             0  0  1 ]
and for the rotated case:
[x y 1]'  = rotationMatrix * coefficentsMatrix  * [t t^2 1]' 
%}
clear all;

unrotatedSourceData= [
  -4  16  1
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

% let a=b=1
coefficients= ones(3);
nRows=rows(unrotatedSourceData);
randomJitter=[ rand(nRows,2) zeros(nRows,1)] - [ 0.5 * ones(nRows,2) zeros(nRows,1)];

for theta = [0  pi/20]

  rotateByThetaMatrix= [cos(theta)  -sin(theta) 0 
                        sin(theta)   cos(theta) 0
                            0            0      1];

  % Rotate the [x y 1] vectors by Theta 
  % which is done by the magic of matrix multiplication
  rotatedSourceData= unrotatedSourceData * rotateByThetaMatrix + randomJitter;

  rotated_x= rotatedSourceData(:,1);
  rotated_y= rotatedSourceData(:,2);


  % Create features for regression learning
  features= [rotated_x      ...
             rotated_x.^2   ...
             rotated_x.^3   ...
             ones(nRows,1) ];
  
  X= features;
  y= [rotated_x rotated_y ones(nRows,1)];

  % Solve it in one line
  coefficients = (X' * X) \ X' * y; 


  % Extrapolate it
  extrapRows=20;
  extrapInterval=linspace(-5, 7, extrapRows)';
  curveToExtrapolate = [ extrapInterval  extrapInterval.^2 ones(extrapRows,1) ] * rotateByThetaMatrix;
  
  xToExtrapolate=curveToExtrapolate(:,1);  
  extrapolatedFeatures= [xToExtrapolate ...
                        xToExtrapolate.^2 ...
                        xToExtrapolate.^3 ...
                        ones(extrapRows,1) ];

  extrapolatedXY1=  extrapolatedFeatures * coefficients;
  
  
  % Show the original points and the extrapolation
  fprintf('\n Coefficents for theta= %d°:\n', theta * 180/pi);
  disp(coefficients);
  figure(ifelse(theta==0, 1,2));
  plot(rotatedSourceData(:,1), rotatedSourceData(:,2), '-.k+'); % data for which we found the best fit
  hold on;
  plot(extrapolatedXY1(:,1), extrapolatedXY1(:,2), '-co');
  title(sprintf('Angle %d° Black is original, blue is extrapolated', theta * 180/pi));
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
