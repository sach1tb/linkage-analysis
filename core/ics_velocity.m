function [w31, w32, w41, w42, bd1, bd2, ...
    t31, t32, t41, t42, b1, b2]=ics_velocity(a, c, d, gamma, w2, t2, w1, t1)
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

[t31, ~,t41, ~, b1]=ics_position(a, c, d, gamma, t2);
w41=a*w2*cos(t2-t31)/(b1+c*cos(gamma));
bd1=(-a*w2*sin(t2)+w41*(b1*sin(t31)+c*sin(t41)))/cos(t31);
w31=w41;

[~, t32, ~,t42, ~, b2]=ics_position(a, c, d, gamma, t2);
w42=a*w2*cos(t2-t32)/(b2+c*cos(gamma));
bd2=(-a*w2*sin(t2)+w42*(b2*sin(t32)+c*sin(t42)))/cos(t32);
w32=w42;

