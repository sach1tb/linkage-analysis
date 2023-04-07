function [w31, w32, ddot1, ddot2, ...
    t31, t32, d1, d2]=cs_velocity(a, b, c, w2, t2)
% cs_velocity performs velocity & position analysis of a 
% crank slider linkage according to the convention in crankslider.png
% 
% Syntax
%
%   [w31, ~, ddot1, ~, t31, ~, d1]=cs_velocity(a, b, c, w2, t2)
%
% Description
%
%   [w31, ~, ddot1, ~, t31, ~, d1]=cs_velocity(a, b, c, w2, t2)
%   takes as input the link lengths a, b, c, and the angular velocity(s)
%   w2 in rad/s and angle(s) t2 for the input link in radians 
%   and returns the angular velocity w31 and sliding link velocity ddot1
%

if nargin<1 
    a=11; b=23; c=-4.5; t2=pi/3; w2=1;
end

[t31, t32, d1, d2]=cs_position(a, b, c, t2);


w31=a*cos(t2)./(b*cos(t31)).*w2;
ddot1=-a*w2*sin(t2)+b*w31.*sin(t31);

w32=a*cos(t2)./(b*cos(t32)).*w2;
ddot2=-a*w2*sin(t2)+b*w32.*sin(t32);


