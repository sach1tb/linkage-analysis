function [t31, t32, d1, d2]=cs_position(a, b,c, t2, t1)
%
% crank-slider (or slider-crank) position analysis
%
% Syntax
%
%   [t31, ~, d1]=cs_position(a, b,c, t2)
%   [~, t32, ~, d2]=cs_position(a, b,c, t2)
%
% Description
%   [t31, ~, d1]=cs_position(a, b,c, t2) takes as input the link
%   lengths a, b, c, and the angle(s) t2 for the input link in radians 
%   and returns the angles theta_3 in radians and distance d for one
%   configuration
%
%   [~, t32, ~, d2]=cs_position(a, b,c, t2) takes as input the link
%   lengths a, b, c, and the angle(s) t2 for the input link in radians 
%   and returns the angles theta_3 in radians and distance d for the other
%   configuration

t31=asin((a*sin(t2)-c)/b);
t32=pi-t31;

d1=a*cos(t2)-b*cos(t31);
d2=a*cos(t2)-b*cos(t32);