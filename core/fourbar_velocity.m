function [w3o, w3c, w4o, w4c, ...
    t3o, t3c, t4o, t4c]=fourbar_velocity(a, b, c, d, w2, t2, w1, t1)
% fourbar_velocity performs velocity & position analysis of a 
% fourbar linkage according to the convention in fourbar.png
% 
% Syntax
%
%   [w3o, ~, w4o, ~, t3o, ~, t4o]=fourbar_velocity(a, b, c, d, w2, t2)
%   [w3o, ~, w4o, ~, t3o, ~, t4o]=fourbar_velocity(a, b, c, d, w2)
%   [w3o, ~, w4o, ~, t3o, ~, t4o]=fourbar_velocity(a, b, c, d, w2, t2, w1, t1)
%   [~, w3c, ~, w4c, ~, t3c, ~, t4c]=fourbar_velocity(a, b, c, d, w2, t2)
%   [~, w3c, ~, w4c, ~, t3c, ~, t4c]=fourbar_velocity(a, b, c, d, w2, t2, w1, t1)
%
% Description
%
%   [w3o, ~, w4o, ~, t3o, ~, t4o]=fourbar_velocity(a, b, c, d, w2, t2)
%   takes as input the link lengths a, b, c, d, and the angular velocity(s)
%   w2 in rad/s and angle(s) t2 for the input link in radians 
%   and returns the angular velocity w3o and w4o and orientations for the 
%   coupler and output links in the open configuration
%
%   [w3o, ~, w4o, ~, t3o, ~, t4o]=fourbar_velocity(a, b, c, d, w2) returns
%   the angular velocity and orientations for the 
%   coupler and output links in the open configuration for 2 seconds

if nargin<7 
    w1=0; t1=0; 
end
if nargin<6 
    t2=w2*(0:.01:2); 
    w1=0; t1=0;
end

[t3o, t3c, t4o, t4c]=fourbar_position(a, b, c, d, t2, t1);

w3o=a*w2.*sin(t4o-t2)./(b*sin(t3o-t4o)) + ...
    d*w1.*sin(t4o-t1)./(b*sin(t4o-t3o));
w4o=a*w2.*sin(t2-t3o)./(c*sin(t4o-t3o)) + ...
    d*w1.*sin(t3o-t1)./(c*sin(t4o-t3o));

w3c=a*w2.*sin(t4c-t2)./(b*sin(t3c-t4c)) + ...
    d*w1.*sin(t4c-t1)./(b*sin(t4c-t3c));
w4c=a*w2.*sin(t2-t3c)./(c*sin(t4c-t3c)) + ...
    d*w1.*sin(t3c-t1)./(c*sin(t4c-t3c));
        

