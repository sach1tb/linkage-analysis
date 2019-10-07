clear variables;
% see fourbar.png for the meaning of each parameter
% parameters >> these can be changed
% link lengths

% the line below adds the core scripts to the current working directory
addpath ../core

a=1.36; b=10; c=10; d=15;
APlen=20; BAP=0; % BAP
w2=2; % rad/s
simTime=2*pi/w2; % multiply by the number of cycles you want to see 

% *** Processing ***
% linspace linearly spaces the time into 100 equal sections
t=linspace(0,simTime, 100);
t1=0; % ground orientation
t2=w2*t; % theta_2
[t3o, t3c, t4o, t4c]=fourbar_position(a, b, c, d, t2, t1);
px=a*cos(t2)+APlen*cos(t3o+BAP);
py=a*sin(t2)+APlen*sin(t3o+BAP);
figure(1); gcf; clf;
subplot(1,3,1);
iter=30;
fourbar_plot(a,b,c,d,BAP,APlen, t2(iter),t3o(iter),...
    t4o(iter),t1, eye(3));
plot(px,py, 'k-.', 'linewidth', 2);
set(gca, 'fontsize', 24, 'fontname', 'times');
subplot(1,3,2);
plot(px,py, 'k-.', 'linewidth', 2);
set(gca, 'fontsize', 24, 'fontname', 'times');
grid on;
axis image; % this makes sure you see the right aspect ratio
subplot(1,3,3);
plot(t, px, 'linewidth',2); hold on; plot(t, py, 'linewidth',2);
set(gca, 'fontsize', 24, 'fontname', 'times');
xlabel('time(s)'); 
grid on; legend('x', 'y');