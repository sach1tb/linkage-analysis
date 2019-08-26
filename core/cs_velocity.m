function [w31, w32, dd1, dd2, ...
    t31, t32, d1, d2]=cs_velocity(a, b, c, w2, t2, w1, t1)
% cs_velocity performs velocity & position analysis of a 
% crank slider linkage according to the convention in crankslider.png
% 
% Syntax
%
%   [w31, ~, dd1, ~, t31, ~, d1]=cs_velocity(a, b, c, w2, t2)
%
% Description
%
%   [w31, ~, dd1, ~, t31, ~, d1]=cs_velocity(a, b, c, w2, t2)
%   takes as input the link lengths a, b, c, and the angular velocity(s)
%   w2 in rad/s and angle(s) t2 for the input link in radians 
%   and returns the angular velocity w31 and sliding link velocity dd1
%

if nargin<6 
    w1=0; t1=0; 
end

[t31, t32, d1, d2]=cs_position(a, b, c, t2, t1);


w31=a*cos(t2)./(b*cos(t31)).*w2;
dd1=-a*w2*sin(t2)+b*w31.*sin(t31);

w32=a*cos(t2)./(b*cos(t32)).*w2;
dd2=-a*w2*sin(t2)+b*w32.*sin(t32);


