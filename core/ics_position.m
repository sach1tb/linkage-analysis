function [t31, t32, t41, t42, b1, b2]=ics_position(a, c, d, gamma, t2, t1)
%
% inverted crank-slider (or slider-crank) position analysis
%
% Syntax
%
%   [t31, ~, t41, ~, b1]=ics_position(a,c,d, gamma, t2)


P=a*sin(t2)*sin(gamma) + (a*cos(t2)-d)*cos(gamma);
Q=-a*sin(t2)*cos(gamma) + (a*cos(t2)-d)*sin(gamma);
R=-c*sin(gamma);

S=R-Q;
T=2*P;
U=Q+R;

t41=2*atan2((-T+sqrt(T.^2-4*S.*U)),(2*S));
t42=2*atan2((-T-sqrt(T.^2-4*S.*U)),(2*S));

t31=t41+gamma;
t32=t42+gamma;

b1=(a*sin(t2)-c*sin(t41))./(sin(t31));
b2=(a*sin(t2)-c*sin(t42))./(sin(t32));
b2=abs(b2);
