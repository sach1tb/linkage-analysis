function [a31, a32, ddd1, ddd2, w31, w32, dd1, dd2, ...
    t31, t32, d1, d2]=cs_acceleration(a, b, c, a2, w2, t2, a1, w1, t1)
% cs_acceleration performs acceleration, velocity & position analysis of a 
% crank slider linkage according to the convention in crankslider.png
% 
% Syntax
%
%    [a31, ~, ddd1, ~, w31, ~, dd1, ~, t31, ~, d1]=cs_acceleration(a, b, c, a2, w2, t2)
%
% Description
%
%   [[a31, ~, ddd1, ~, w31, ~, dd1, ~, t31, ~, d1]=cs_acceleration(a, b, c, a2, w2, t2)
%   takes as input the link lengths a, b, c, and the angular acceleration in
%   rad/s^2, angular velocity(s) w2 in rad/s and angle(s) t2 for the input link in radians 
%   and returns the angular velocity w31 and sliding link velocity dd1
%

if nargin<7 
    a1=0; w1=0; t1=0; 
end

[w31, w32, dd1, dd2, ...
    t31, t32, d1, d2]=cs_velocity(a, b, c, w2, t2, w1, t1);



a31=(a*a2*cos(t2) - a*w2.^2.*sin(t2)+b*w31.^2.*sin(t31))./(b*cos(t31));
ddd1=-a*a2*sin(t2) - a*w2.^2.*cos(t2)+b*a31.*sin(t31)+b*w31.^2.*cos(t31);


a32=(a*a2*cos(t2) - a*w2.^2*sin(t2)+b*w32.^2.*sin(t31))./(b*cos(t32));
ddd2=-a*a2*sin(t2) - a*w2.^2.*cos(t2)+b*a32.*sin(t31)+b*w32.^2.*cos(t32);

