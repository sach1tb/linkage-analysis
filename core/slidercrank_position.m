function [t21, t22, t31, t32]=slidercrank_position(a, b,c, d)
%
% performs position analysis of a slider-crank linkage
% with variables named per the convention in slidercrank.png
%
% Syntax
%
%   [t21, ~, t31]=slidercrank_position(a, b,c, d)
%   [~, t22, ~, t32]=slidercrank_position(a, b,c, d)
%
% Description
%   [t21, ~, t31]=cs_position(a, b,c, d) takes as input the link
%   lengths a, b, c, and d and returns the angles theta_2 and theta_3 
%   in radians for one configuration
%
%   [~, t22, ~, t32]=cs_position(a, b,c, d) takes as input the link
%   lengths a, b, c, and d and returns the angles theta_2 and theta_3 
%   in radians for the OTHER configuration

if nargin<1 
    a=10; b=10; c=10; d=10;
end


K1=a.^2 -b.^2 +c.^2 +d.^2;
K2=-2*a.*c;
K3=-2*a.*d;

A=K1-K3;
B=2*K2;
C=K1+K3;

if A==0, A=eps; end
t21=2*atan((-B+sqrt(B.^2-4*A.*C))./(2*A));
t22=2*atan((-B-sqrt(B.^2-4*A.*C))./(2*A));

t31=pi-asin(1./b*(a.*sin(t21)-c));
t32=pi-asin(1./b*(a.*sin(t22)-c));


