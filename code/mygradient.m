function [mag,ori] = mygradient(I)
%
% compute image gradient magnitude and orientation at each pixel
%

% Add padding to avoid artifacts on edges

% Horz filter
fx = [-1, 0, 1];
% Vert filter
fy = fx';

% apply filters to I
dx = imfilter(double(I), fx, 'replicate');
dy = imfilter(double(I), fy, 'replicate');

% L2 norm is the magnitude
mag = ((dx.*dx) + (dy.*dy)).^0.5;

% obtain orientation through atan of gradients
ori = atan2(dy, dx);

end