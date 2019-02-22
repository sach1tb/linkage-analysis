function [w3, w4]=fourbar_velocity(a, b, c, d, w2, t)
%
% a,b,c,d are link lengths
% w2 is the angular velocity of the input link (crank) in radians per
% second
%
% t is the time vector such as 0:.1:10 representing 10 seconds in
% increments of 0.1 seconds
%
%

t2=w2.*t;
[t3o, t3c, t4o, t4c]=fourbar_position(a, b, c, d, t2);

w3=a*w2.*sin(t4o-t2)./(b*sin(t3o-t4o));
w4=a*w2.*sin(t2-t3o)./(c*sin(t4o-t3o));
        

