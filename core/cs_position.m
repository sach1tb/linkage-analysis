function [t31, t32, d1, d2]=cs_position(a, b,c, t2, t1)
%
% crank-slider (or slider-crank) position analysis
%
% all values in radians 

t31=asin((a*sin(t2)-c)/b);
t32=pi-t31;

d1=a*cos(t2)-b*cos(t31);
d2=a*cos(t2)-b*cos(t32);