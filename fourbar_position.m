function [t3o, t3c, t4o, t4c, A, B, C]=fourbar_position(a, b, c, d, t2)
% fourbar_position performs position analysis of a fourbar linkage with pin
% joints only, where the ground link is R1, input link (crank) is R2,
% floating link is R3 and output link (rocker) is R4
% 
% Syntax
%
%   [t3o, ~, t4o]=fourbar_position(a, b, c, d, t2)
%   [~, t3c, ~, t4c]=fourbar_position(a, b, c, d, t2)
%   [t3o, t3c, t4o, t4c, A, B, C]=fourbar_position(a, b, c, d, t2)
%
% Description
%   [t3o, ~, t4o]=fourbar_position(a, b, c, d, t2) takes as input the link
%   lengths a, b, c, d, and the angle(s) t2 for the input link in radians 
%   and returns the angles theta_3 and theta_4 in radians in the open 
%   configuration
%
%   [~, t3c, ~, t4c]=fourbar_position(a, b, c, d, t2) for cross
%   configuration
%
%   [t3o, t3c, t4o, t4c, A, B, C]=fourbar_position(a, b, c, d, t2) to see
%   all values including those of constants A, B, and C
%
%
% Reference
%   [1] R. L. Norton, Design of Machinery, McGrawHill
%
% SB, MEE320, NIU, Fall 2016


% equation 4.8a
K1=d/a;
K2=d/c;
K3=(a^2-b^2+c^2+d^2)/(2*a*c);

% equation 4.10a
A=cos(t2)-K1-K2*cos(t2)+K3;
B=-2*sin(t2);
C=K1-(K2+1)*cos(t2)+K3;

% equation 4.10b
t4o=2*atan((-B-sqrt(B.^2-4*A.*C))./(2*A));

t4c=2*atan((-B+sqrt(B.^2-4*A.*C))./(2*A));

% equation 4.11b 
K4=d/b;
K5=(c^2-d^2-a^2-b^2)/(2*a*b);

% equation 4.12
D=cos(t2)-K1+K4*cos(t2)+K5;
E=-2*sin(t2);
F=K1+(K4-1)*cos(t2)+K5;

t3o=2*atan((-E-sqrt(E.^2-4*D.*F))./(2*D));
t3c=2*atan((-E+sqrt(E.^2-4*D.*F))./(2*D));