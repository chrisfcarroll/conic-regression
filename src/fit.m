% fit
% MATLAB code for finding the best fit line using least squares method

input = [...                 % input in the form of matrix
    1, 6;...                 % rows contain points
    2, 5;...
    3, 7;...
    4, 10];
    
m = length(input);             % number of points
X = [ones(m,1), input(:,1)];   % forming X of X beta = y
y = input(:,2);                % forming y of X beta = y
betaHat = (X' * X) \ X' * y;   % computing projection of matrix X on y, giving beta
% display best fit parameters
disp(betaHat);
% plot the best fit line
xx = linspace(0, 5, 2);
yy = betaHat(1) + betaHat(2)*xx;
plot(xx, yy)
% plot the points (data) for which we found the best fit
hold on
plot(input(:,1), input(:,2), 'or')
hold off
