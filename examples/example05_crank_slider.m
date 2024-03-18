function example05_crank_slider(a,b,c,w2,cfg, simTime)

addpath ../core

% see crankslider.png to visualize the parameters

% link lengths
if nargin < 1
    a=11; b=23; c=-4.5; 
    w2=2; % rad/s
    cfg=1; % one for open and 0 for cross
    simTime=2*pi/w2*2; % multiply by the number of cycles you want to see 
end

% *** Processing ***
t=linspace(0,simTime, 100);
t2=w2*t; % theta_2


figure(1); gcf; clf;

for iter=1:numel(t)
    subplot(1,2,1); cla;
    if cfg
        [~, t32, ~, d2]=cs_position(a, b, c, t2(iter));
    else
        [t32, ~, d2]=cs_position(a, b, c, t2(iter));
    end
    cs_plot(a,b,c,d2, t2(iter), t32, 0, eye(3));
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

subplot(1,2,2);
% plot the time series of distance
% linspace linearly spaces the time into 100 equal sections

[t3c, t3o, dc, do]=cs_position(a, b, c, t2);
if cfg
   plot(t,do, 'k', 'linewidth', 2);
else
   plot(t,dc, 'k', 'linewidth', 2); 
end
set(gca, 'fontsize', 24, 'fontname', 'times');
xlabel('time(s)'); 
ylabel('slider distance');
grid on;