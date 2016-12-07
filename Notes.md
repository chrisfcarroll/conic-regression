Notes
=====

The math is similar to ridge regression.  In standard linear regression, the regression coefficients are (XTX)−1XTy. 

In ridge regression, you add a quadratic penalty on the size of the regression coefficients, and so the coefficients become (XTX+λIn)−1XTy, where Ip is the p by p identity matrix, p being the number of rows in your data.

