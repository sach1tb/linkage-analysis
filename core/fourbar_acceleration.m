function [a3o, a3c, a4o, a4c, w3o, w3c, w4o, w4c, t3o, t3c, t4o, t4c]=...
    fourbar_acceleration(a, b, c, d, a2, w2, t2, a1, w1, t1)
% fourbar_acceleration performs, acceleration, velocity & position analysis 
% of a fourbar linkage according to the convention in fourbar.png
% 
% Syntax
%
%   [a3o, ~, a4o, ~, w3o, ~, w4o, ~, t3o, ~, t4o]=fourbar_acceleration(a, b, c, d, a2, w2, t2)
%   [a3o, ~, a4o, ~, w3o, ~, w4o, ~, t3o, ~, t4o]=fourbar_acceleration(a, b, c, d, a2, w2, t2, a1, w1, t1)
% Description
%
%   [a3o, ~, a4o, ~, w3o, ~, w4o, ~, t3o, ~, t4o]=fourbar_acceleration(a, b, c, d, a2, w2, t2)
%   takes as input the link lengths a, b, c, d, and the angular acceleration(s)
%   a2 in rad/s^2, angular velocity(s) w2 in rad/s and angle(s) t2 for the 
%   input link in radians and returns the angular accelerations a3o and a4o 
%   angular velocities w3o and w4o and orientations for the 
%   coupler and output links in the open configuration

% w2=w20+a2*t;
% t2=w20.*t+0.5*a2*t.^2;
if nargin < 8
    a1=0;
    w1=0;
    t1=0;
end

% if t1 is passed as a single value but t2 as more then
if numel(t2) > 1 && numel(t1) ==1
    t1=t1*ones(1,numel(t2));
end


[w3o, w3c, w4o, w4c, ...
    t3o, t3c, t4o, t4c]=fourbar_velocity(a, b, c, d, w2, t2, w1, t1);

% acceleration analysis
% open configuration
% A=c*sin(t4o);
% B=b*sin(t3o);
% C=a*a2.*sin(t2) + a*w2.^2.*cos(t2) + b*w3o.^2.*cos(t3o) - c*w4o.^2.*cos(t4o);
% D=c*cos(t4o);
% E=b*cos(t3o);
% F=a*a2.*cos(t2) - a*w2.^2.*sin(t2) - b*w3o.^2.*sin(t3o) + c*w4o.^2.*sin(t4o);

% a3o=(C.*D-A.*F)./(A.*E-B.*D);
% a4o=(C.*E-B.*F)./(A.*E-B.*D);

% a3o-a3ot
% a4o-a4ot

% cross configuration
% A=c*sin(t4c);
% B=b*sin(t3c);
% C=a*a2.*sin(t2) + a*w2.^2.*cos(t2) + b*w3c.^2.*cos(t3c) - c*w4c.^2.*cos(t4c);
% D=c*cos(t4c);
% E=b*cos(t3c);
% F=a*a2.*cos(t2) - a*w2.^2.*sin(t2) - b*w3c.^2.*sin(t3c) + c*w4c.^2.*sin(t4c);
% 
% 
% a3c=(C.*D-A.*F)./(A.*E-B.*D);
% a4c=(C.*E-B.*F)./(A.*E-B.*D);


% full version for complex linkages
% -(- d*cos(t1 - t3)*w1^2 + a*cos(t2 - t3)*w2^2 + b*w3^2 - c*cos(t3 - t4)*w4^2 + ...
% a*a2*sin(t2 - t3) - a1*d*sin(t1 - t3))/(c*sin(t3 - t4))
a4o=-(- d.*cos(t1 - t3o).*w1.^2 + a.*cos(t2 - t3o).*w2.^2 + b.*w3o.^2 - c.*cos(t3o - t4o).*w4o.^2 + ...
    a.*a2.*sin(t2 - t3o) - a1.*d.*sin(t1 - t3o))./(c.*sin(t3o - t4o));
a3o=(d.*cos(t1 - t4o).*w1.^2 - a.*cos(t2 - t4o).*w2.^2 - b.*cos(t3o - t4o).*w3o.^2 + c.*w4o.^2 -...
    a.*a2.*sin(t2 - t4o) + a1.*d.*sin(t1 - t4o))./(b.*sin(t3o - t4o));


a4c=-(- d.*cos(t1 - t3c).*w1.^2 + a.*cos(t2 - t3c).*w2.^2 + b.*w3c.^2 - c.*cos(t3c - t4c).*w4c.^2 + ...
    a.*a2.*sin(t2 - t3c) - a1.*d.*sin(t1 - t3c))./(c.*sin(t3c - t4c));
a3c=(d.*cos(t1 - t4c).*w1.^2 - a.*cos(t2 - t4c).*w2.^2 - b.*cos(t3c - t4c).*w3c.^2 + c.*w4c.^2 -...
    a.*a2.*sin(t2 - t4c) + a1.*d.*sin(t1 - t4c))./(b.*sin(t3c - t4c));

