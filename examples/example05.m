addpath ../core
clear variables;
% see crankslider.png for the meaning of each parameter
% parameters >> these can be changed
% link lengths
a=40; b=120; c=0; 
w2=2; % rad/s
simTime=2*pi/w2*2; % multiply by the number of cycles you want to see 

% *** Processing ***

figure(1); gcf; clf;
subplot(1,2,1);
% plot the two extreme positions
t2=asin(c/(b+a));
[~, t32, ~, d2]=cs_position(a, b, c, t2);
cs_plot(a,b,c,d2, t2, t32, 0, eye(3));

t2=asin(c/(b-a))+pi;
[~, t32, ~, d2]=cs_position(a, b, c, t2);
cs_plot(a,b,c,d2, t2, t32, 0, eye(3));

subplot(1,2,2);
% plot the time series of distance
% linspace linearly spaces the time into 100 equal sections
t=linspace(0,simTime, 100);
t1=0; % ground orientation
t2=w2*t; % theta_2
t4=pi/2;
[t3c, t3o, dc, do]=cs_position(a, b, c, t2, t1);

plot(t,do, 'k', 'linewidth', 2);
set(gca, 'fontsize', 24, 'fontname', 'times');
xlabel('time(s)'); 
ylabel('slider distance');
grid on;