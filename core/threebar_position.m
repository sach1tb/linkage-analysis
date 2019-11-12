function [b, t3]=threebar_position(a, c, t2, t4)
% threebar_position performs position analysis of a linkage
% that has an extendable link between two fixed grounds
% 
% Syntax
%
%   [b, t30]=threebar_position(a, c, t2, t4)
% SB, MEE320, NIU, 2018
%


b=sqrt(c^2+a^2-2*a*c*cos(t4-t2));
t3=atan((c*sin(t4)-a*sin(t2))./(c*cos(t4)-a*cos(t2)));