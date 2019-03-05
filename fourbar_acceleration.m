function [a3, a4, w3, w4, t3o, t4o, t3c, t4c, t2]=fourbar_acceleration(a,b,c,d,alpha2,w20, t, t1)
%
% a,b,c,d are link lengths
% alpha2 is the angular acceleration of the input link (crank) in radians per
% second
%
% t is the time vector such as 0:.1:10 representing 10 seconds in
% increments of 0.1 seconds
%


w2=w20+alpha2*t;
t2=w20.*t+0.5*alpha2*t.^2;
[w3, w4, t3o, t4o, t3c, t4c]=fourbar_velocity(a, b, c, d, w2, t, t1, t2);


% acceleration analysis
A=c*sin(t4o);
B=b*sin(t3o);
C=a*alpha2*sin(t2) + a*w2.^2.*cos(t2) + b*w3.^2.*cos(t3o) - c*w4.^2.*cos(t4o);
D=c*cos(t4o);
E=b*cos(t3o);
F=a*alpha2*cos(t2) - a*w2.^2.*sin(t2) - b*w3.^2.*sin(t3o) + c*w4.^2.*sin(t4o);


a3=(C.*D-A.*F)./(A.*E-B.*D);
a4=(C.*E-B.*F)./(A.*E-B.*D);