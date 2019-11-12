function [t3o, t3c, t4o, t4c, A, B, C]=fourbar_position(a, b, c, d, t2, t1)
% fourbar_position performs position analysis of a fourbar linkage
% according to the convention in fourbar.png
% 
% Syntax
%
%   [t3o, ~, t4o]=fourbar_position(a, b, c, d, t2)
%   [t3o, ~, t4o]=fourbar_position(a, b, c, d, t2, t1)
%   [~, t3c, ~, t4c]=fourbar_position(a, b, c, d, t2)
%   [~, t3c, ~, t4c]=fourbar_position(a, b, c, d, t2, t1)
%   [t3o, t3c, t4o, t4c, A, B, C]=fourbar_position(a, b, c, d, t2)
%   [t3o, t3c, t4o, t4c, A, B, C]=fourbar_position(a, b, c, d, t2, t1)
%
% Description
%   [t3o, ~, t4o]=fourbar_position(a, b, c, d, t2) takes as input the link
%   lengths a, b, c, d, and the angle(s) t2 for the input link in radians 
%   and returns the angles theta_3 and theta_4 in radians in the open 
%   configuration
%
%   [t3o, ~, t4o]=fourbar_position(a, b, c, d, t2, t1) allows a tilted
%   ground with angle t1 in radians
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
% SB, MEE320, NIU, 2018
%
% Known bugs: 
% 1) does not work for pi - 2pi range for parallelogram linkages (3/2019)

if nargin<6, t1=0; end

K1=2*d.*c.*cos(t1)-2*a.*c.*cos(t2);
K2=2*d.*c.*sin(t1)-2*a.*c.*sin(t2);
K3=2*a.*d.*sin(t1).*sin(t2) + 2*a.*d.*cos(t1).*cos(t2);
K4=b.^2-a.^2-c.^2-d.^2;

A=K4+K1+K3;
B=-2*K2;
C=K4-K1+K3;

if A==0, A=eps; end
t4c=2*atan((-B-sqrt(B.^2-4*A.*C))./(2*A));
t4o=2*atan((-B+sqrt(B.^2-4*A.*C))./(2*A));

K5=2*a.*b.*cos(t2)-2*b.*d.*cos(t1);
K6=2*a.*b.*sin(t2)-2*b.*d.*sin(t1);
K7=2*a.*d.*sin(t1).*sin(t2) + 2*a.*d.*cos(t1).*cos(t2);
K8=(c.^2-d.^2-a.^2-b.^2);


D=K8+K7+K5;
E=-2*K6;
F=K8-K5+K7;

if D==0, D=eps; end
t3c=2*atan((-E+sqrt(E.^2-4*D.*F))./(2*D));
t3o=2*atan((-E-sqrt(E.^2-4*D.*F))./(2*D));