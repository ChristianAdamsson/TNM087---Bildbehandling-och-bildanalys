OImage = imread('white-balance.jpg');
lower = 0.1;
upper = 0.9;
gamma = 4;
A = Task5GammaCorrection(OImage, gamma, lower, upper);