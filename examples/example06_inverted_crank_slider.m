function example06_inverted_crank_slider(a,c,d,w2,cfg, simTime)

addpath ../core

% see crankslider.png for the meaning of each parameter
% parameters >> these can be changed
% link lengths
if nargin < 1
    a=2; c=4; d=6; 
    gamma=pi/2;
    w2=10; % rad/s
    cfg=1;
    simTime=2*pi/w2*2; % multiply by the number of cycles you want to see 
end
% *** Processing ***

t=linspace(0,simTime, 10);
t1=0; % ground orientation
t2=30*pi/180; % theta_2


figure(1); gcf; clf;

for iter=1:numel(t)
    subplot(1,2,1); cla;
    if cfg
        [~, t32, ~,t42, ~, b2]=ics_position(a, c, d, gamma, t2);
        ics_plot(a,b2,c,d,t2, t32, t42, t1, eye(3));
    else
        [t31, ~,t41, ~, b1]=ics_position(a, c, d, gamma, t2);
        ics_plot(a,b1,c,d,t2, t31, t41, t1, eye(3));
    end
    
    drawnow;
end

% plot the two extreme positions
% t2=asin(c/(b+a));
% [~, t32, ~, d2]=cs_position(a, b, c, t2);
% cs_plot(a,b,c,d2, t2, t32, 0, eye(3));
% 
% % t2=asin(c/(b-a))+pi;
% [~, t32, ~, d2]=cs_position(a, b, c, t2);
% cs_plot(a,b,c,d2, t2, t32, 0, eye(3));

% subplot(1,2,2);
% plot the time series of distance
% linspace linearly spaces the time into 100 equal sections

% [t3c, t3o, dc, do]=cs_position(a, b, c, t2, t1);
% if cfg
%    plot(t,do, 'k', 'linewidth', 2);
% else
%    plot(t,dc, 'k', 'linewidth', 2); 
% end
% set(gca, 'fontsize', 24, 'fontname', 'times');
% xlabel('time(s)'); 
% ylabel('slider distance');
% grid on;