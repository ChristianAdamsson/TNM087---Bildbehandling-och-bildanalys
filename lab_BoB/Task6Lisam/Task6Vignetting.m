function [ Profile1, Profile2 ] = Vignette( Im1, Im2, norings )
%Vignette: Compare vignetting properties of two images
%   If Im1 and Im2 show the same object imaged under different conditions
%   then Profile1 and Profile2 describe the mean gray value as a function
%   of the radius
%
%% Who has done it
%
% Author: Oskjo806
% Co-author: Chrad171
%
%% Syntax of the function
%
% Input arguments:  Im1, Im2 are input images, you can assume that they are
%                       gray value images (of type uint8, uint16 or double)
%                   norings is optional and describes the number of
%                       concentric rings to use. The default is to use 50 rings
% Output arguments: Profile1 and Profile2 are vectors with the mean gray
%                       values in each ring. The final results are normed
%                       so that the maximum values in Profile1 and Profile2
%                       are equal to one
%
% The images to use are CWhite1.jpg (Canon) and HWhite1.jpg (Holga9
%
% You MUST NEVER change the first line
%
%% Basic version control (in case you need more than one attempt)
%
% Version: 1
% Date: 6/12/2017
%
% Gives a history of your submission to Lisam.
% Version and date for this function have to be updated before each
% submission to Lisam (in case you need more than one attempt)
%
%% General rules
%
% 1) Don't change the structure of the template by removing %% lines
%
% 2) Document what you are doing using comments
%
% 3) Before submitting make the code readable by using automatic indentation
%       ctrl-a / ctrl-i
%
% 4) In case a task requires that you have to submit more than one function
%       save every function in a single file and collect all of them in a
%       zip-archive and upload that to Lisam. NO RAR, NO GZ, ONLY ZIP!
%       All non-zip archives will be rejected automatically
%
% 5) Often you must do something else between the given commands in the
%       template
%
%

%% Your code starts here
%

%% Input parameters
%
if nargin < 3
    norings = 50;
end


%% Generate two square images cIm1 and cIm2 that have the same size
% Use the center of the images and if at least one of them is an RGB image
% either convert to gray value or exit with an error message

[sr1, sc1, nc1] = size(Im1);
[sr2, sc2, nc2] = size(Im2);


if nc1 > 1
    Im1 = rgb2gray(Im1);
end

if nc2 > 1
    Im2 = rgb2gray(Im2);
end

%the centers
csr1 = round(sr1/2);
csc1 = round(sc1/2);
csr2 = round(sr2/2);
csc2 = round(sc2/2);

%instead of if-statements we chose to use min-function. since they should
%always be squared and have the same size this shouldn't be a problem

s1 = min(sr1, sc1);

s2 = min(sr2, sc2);

s = min(s1, s2);


cIm1 = Im1(round(csr1-s/2)+1:round(csr1+s/2), round(csc1-s/2)+1:round(csc1+s/2));
cIm2 = Im2(round(csr2-s/2)+1:round(csr2+s/2), round(csc2-s/2)+1:round(csc2+s/2));

Profile1 = zeros(norings,1);
Profile2 = Profile1;

%% Now you have two gray value images of the size (square) size and you
%   generate grid with the help of an axis vector ax that defines your
%   rings
%

%ax = (-s/2:s/(norings-1):s/2 );
% or read the documentation of linspace
ax = linspace(-s/2, s/2, norings);
%...

[C, R] = meshgrid(ax); %Euclidean mesh
[~,Rho] = cart2pol(C,R);%Polar coordinates comment on the ~ used
Rho = round(Rho);


%% Do the actual calculations

for ringno = 1:norings
    RMask = (C.^2 ./ Rho(ringno,ringno).^2) + (R.^2 ./Rho(ringno,ringno).^2)  <= 1;% Generate a mask describing the ring number ringno
    
    if ringno > 1
    maskvec = (C.^2 ./ Rho(ringno-1,ringno-1).^2) + (R.^2 ./Rho(ringno-1,ringno-1).^2)  <= 1;
    RMask = RMask - maskvec
    RMask = logical(RMask); %we got the problem that the previous line made it a double array and not logical
    end    
    
    temp = size(RMask);
    nopixels = temp(1,1)*temp(1,2); % Compute the number of pixes in RMask
    
    pixsum = sum(cIm1(RMask));% Compute the sum over all pixel values in RMask in Im1
    Profile1(ringno) = mean(cIm1(RMask));% ../.. Mean gray value of pixels i RMask
    
    % ... and now you do it for the second images
    pixsum2 = sum(cIm2(RMask));
    Profile2(ringno) = mean(cIm2(RMask));
end

%% Finally the normalization to max value one
Profile1 = Profile1/max(Profile1);
Profile2 = Profile2/max(Profile2);


%% Extra question: How can you find out if Im1 is better than Im2?
plot(Profile1, 'b')
hold on
plot(Profile2, 'g');
end