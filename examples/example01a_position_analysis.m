function example01a_position_analysis(a,b,c,d,APlen,BAP,theta1, theta2, cfg)
% see fourbar.png for the meaning of each parameter
% parameters >> these can be changed
% link lengths

% the line below adds the core scripts to the current working directory
addpath ../core

if nargin< 1
    % test linkage
    a=2.8; b=1.9; c=3.1; d=2.5;
    APlen=4.0; BAP=0; % BAP
    theta1=0;
    theta2=pi/2;
    cfg=1;
end
% *** Processing ***
[theta3o, theta3c, theta4o, theta4c]=fourbar_position(a, b, c, d, theta2, theta1);



[RAO2x, RAO2y]=pol2cart(theta2, a);
if cfg==1
    theta3=theta3o;
    theta4=theta4o;
else
    theta3=theta3c;
    theta4=theta4c;
end

[RBAx, RBAy]=pol2cart(theta3, b);
[RPAx, RPAy]=pol2cart(theta3 + BAP, APlen);

RBO2x=RBAx+RAO2x;
RBO2y=RBAy+RAO2y;

RO4O2x = d;
RO4O2y = 0;

RPO2x=RPAx+RAO2x;
RPO2y=RPAy+RAO2y;

figure(1); gcf; clf;

fourbar_plot(a,b,c,d,BAP,APlen, theta2,theta3,theta4,theta1, eye(3))


