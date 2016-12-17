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
"creating data"

function xy1= rotatedParabolaWithJitter(theta, x0=0, y0=0, from=-4, to=4)

  cTheta= cos(theta); 
  sTheta= sin(theta);
  rotateByThetaAndTranslateByX0Y0 = ...
      [ cTheta  -sTheta  x0 
        sTheta   cTheta  y0
             0        0   1 ];

  unrotatedParabola= [
    -4  16  1
    -3   9  1
    -2   4  1
    -1   1  1
     0   0  1
     1   1  1
     2   4  1
     3   9  1
     4  16  1
    ];
  randomJitter=[ rand(rows(unrotatedParabola),2)/2-0.5 zeros(rows(unrotatedParabola),1)]; % Jitter the x & y but not the 1 column

  xy1= (unrotatedParabola + randomJitter) * rotateByThetaAndTranslateByX0Y0';

endfunction


figureNumber=0;
for theta = [0 pi/12 pi/4]
  figureNumber++; fprintf('%i) Theta=%d\n', figureNumber ,theta);
  
  X=unrotatedParabola= [
    -4  16  1
    -3   9  1
    -2   4  1
    -1   1  1
     0   0  1
     1   1  1
     2   4  1
     3   9  1
     4  16  1
    ];

  y=rotated_tfeatures= rotatedParabolaWithJitter(theta, 3,7, from=-4, to=+4);

  % Solve it in one line
  coefficients = (X' * X) \ X' * y; 
  coefficients = round(coefficients * 1e12) / 1e12;
  disp(coefficients);

  %extrapolate it
  rangeXToExtrapolate = linspace(-7, 7, 15);
  featuresToExtrapolate= [rangeXToExtrapolate' rangeXToExtrapolate'.^2  ones(length(rangeXToExtrapolate),1)];
  extraXY= featuresToExtrapolate * coefficients;
  extraX= extraXY(:,1);
  extraY= extraXY(:,2);

  % extrat1 = ifelse(sTheta==0,
  %   rangeXToExtrapolate - x0,
  %   (-cTheta + sqrt(cTheta^2 - 4 * sTheta * (rangeXToExtrapolate - x0))) / 2 / sTheta
  %   );
  % extrat2 = ifelse(sTheta==0,
  %   rangeXToExtrapolate - x0,
  %   (-cTheta - sqrt(cTheta^2 - 4 * sTheta * (rangeXToExtrapolate - x0))) / 2 / sTheta
  %   );

  % tt = [ extrat1( imag(extrat1)==0 ) flip( extrat2( imag(extrat2)==0 ) )];
  % xx= cTheta * tt - sTheta * tt.^2 + x0;
  % yy= sTheta* tt + cTheta * tt.^2 + y0;
  % extraX= xx;
  % extraY= yy;

  % Show the original points and the extrapolation
  fprintf('\n');
  figure(figureNumber);
  plot(rotated_tfeatures(:,1), rotated_tfeatures(:,2), '-.ko') % original data that we're trying to fit
  hold on
  plot(extraX, extraY, '-cx')
  title( sprintf('Theta=%i deg, Black is original, blue is extra', theta * 180/pi ));
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
