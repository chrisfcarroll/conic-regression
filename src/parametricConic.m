%------------------------------------------------------------------------------
%
% Create fake data for points approximately on a parabola which is at an theta theta from 'straight up'
%
%{
Example: 
[x y 1]'  = [a  0  1 ;  * [t t^2 1]'
             0  b  1 ;
             0  0  1 ]
and for the rotated case:
[x y 1]'  = coefficentsMatrix  * rotationMatrix * [t t^2 1]'
%}

  unrotatedParabola= [
    -5  25  1
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
  randomJitter=[ rand(rows(unrotatedParabola),2) ones(rows(unrotatedParabola),1)]; % Jitter the x & y but not the 1 column

figureNumber=0;
for theta = 0  % [0 pi/12 pi/4]
  figureNumber++;

  cTheta= cos(theta); sTheta= sin(theta); x0=10; y0=20;
  rotateByThetaAndTranslateByX0Y0 = ...
      [ cTheta  -sTheta  x0 
        sTheta   cTheta  y0
             0        0   1 ];

  rotated_tfeatures= (unrotatedParabola + randomJitter) * rotateByThetaAndTranslateByX0Y0;
 
  rotated_x= rotated_tfeatures(:,1);
  rotated_y= rotated_tfeatures(:,2);


  % Create features for regression learning as [rotated-x rotated-x^2]
  % features= [rotated_x      ...
  %            rotated_x.^2   ...
  %            rotated_y      ...
  %            rotated_y.^2   ...
  %            rotated_x .* rotated_y ...
  %            ones(rows(rotated_x),1) ];

  X= rotated_tfeatures;
  y= [rotated_x rotated_y];

  % Solve it in one line
  coefficients = (X' * X) \ X' * y; 

  %extrapolate it
  rangeXToExtrapolate = linspace(-4, 7, 20);

  extrapolatedt1 = ifelse(sTheta==0,
    rangeXToExtrapolate - x0,
    (-cTheta + sqrt(cTheta^2 - 4 * sTheta * (x0 - rangeXToExtrapolate))) / 2 / sTheta
    );
  extrapolatedt2 = ifelse(sTheta==0,
    rangeXToExtrapolate - x0,
    (-cTheta - sqrt(cTheta^2 - 4 * sTheta * (x0 - rangeXToExtrapolate))) / 2 / sTheta
    );

  extrapolatedXY = coefficients(1)*extrapolatedt1 + coefficients(2) * extrapolatedt1.^2 + coefficients(3);  
  extrapolatedX  = extrapolatedXY(:,1);
  extrapolatedY  = extrapolatedXY(:,2);

  % Show the original points and the extrapolation
  disp(coefficients);
  figure(figureNumber);
  plot(rotated_tfeatures(:,1), rotated_tfeatures(:,2), '-.k+') % original data that we're trying to fit
  hold on
  plot(extrapolatedX, extrapolatedY, '-co')
  title( sprintf('Theta=%i deg, Black is original, blue is extrapolated', theta * 180/pi ));
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
rotatedquadratic= @(xy, M, rotateByThetaAndTranslateByX0Y0)(
                    [xy 1] * rotateByThetaAndTranslateByX0Y0' * M * rotateByThetaAndTranslateByX0Y0 * [xy 1]');
%
%----------------------------------------------------------
