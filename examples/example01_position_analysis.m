function example01_position_analysis(a,b,c,d,APlen,BAP,w2,cfg, animate, simTime)
% see fourbar.png for the meaning of each variable
% this script performs position analysis for a time series
% to do position analysis for a single position directly use
% fourbar_position and fourbar_plot as follows (make sure you understand
% what the function argument mean)
% type help fourbar_plot to see how to use the function
% 
% 
% [theta3o, theta3c, theta4o, theta4c]=fourbar_position(20,40,30,40,pi/3,0);
% fourbar_plot(20,40,30,40,pi/3,20, pi/3,theta3o,theta4o,0,...
%                 [-50, 50], [-20, 40], eye(3));
% 
% the line below adds the core scripts to the current working directory
addpath ../core

if nargin< 1
    % link lengths
    a=1.3; b=1.9; c=2.1; d=2.5; 

    % coupler shape
    BAP=pi/4; % radians
    APlen=4; % coupler length
   
    % hoeken's
%   a=2; b=5; c=5; d=4;
%   BAP=0; % radians
%   APlen=10; 
    
    w2=2; % rad/s
    cfg=1; % 1 is open and 0 is crossed
    animate=1;
    simTime=10; % seconds
end

% linspace linearly spaces the time into 100 equal sections
t=linspace(0,simTime, 100);

theta1=0; % ground orientation
theta2=w2*t; % theta_2
% calculate theta_3, theta_4, etc.
[theta3o, theta3c, theta4o, theta4c]=fourbar_position(a, b, c, d, theta2, theta1);


% this function converts polar coordinates to cartesian
% e.g. x = a*cos(theta2)
[RAZx, RAZy]=pol2cart(theta2, a);

% if the configuration is not 1 (open) then simply change variable names so
% we plot the other one
if cfg~=1
    theta3o=theta3c;
    theta4o=theta4c;
end

[RPAx, RPAy]=pol2cart(theta3o + BAP, APlen);

RPZx=RPAx+RAZx;
RPZy=RPAy+RAZy;

% animate
if animate
    for k=1:numel(t)
        figure(1); gcf; clf;
        % fourbar plot plots the fourbar
        % the x and y limits of the plot may need changing depending on which
        % configuration you are using
        fourbar_plot(a,b,c,d,BAP,APlen, theta2(k),theta3o(k),theta4o(k),theta1,...
                [-(a+b), (a+b)], [-(a+APlen), (a+APlen)], eye(3));
    end
else
    fourbar_plot(a,b,c,d,BAP,APlen, theta2(numel(t)),theta3o(numel(t)),theta4o(numel(t)),theta1,...
            [-(a+b), (a+b)], [-(a+APlen), (a+APlen)], eye(3));
end

% plot position trace
plot(RPZx, RPZy, 'k', 'linewidth', 2);
grid on;
set(gca, 'fontsize', 16);

% x-y plots
figure(2); gcf; clf;
plot(t, RPZx, 'k:', 'linewidth', 2);
hold on;
plot(t, RPZy, 'k--', 'linewidth', 2);
legend('x', 'y');
grid on;
set(gca, 'fontsize', 16);
xlabel('time(s)');
ylabel('position of point P (m)');
