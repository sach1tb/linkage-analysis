function example05_crank_slider(crankLength,couplerLength,offset,omega2,configuration, simTime)

addpath ../core

% see crankslider.png for the meaning of each parameter
% parameters >> these can be changed
% link lengths
if nargin < 1
    crankLength=11; couplerLength=23; offset=-4.5; 
    omega2=2; % rad/s
    configuration=1;
    simTime=2*pi/omega2*2; % multiply by the number of cycles you want to see 
end
% *** Processing ***

t=linspace(0,simTime, 100);
t1=0; % ground orientation
t2=omega2*t; % theta_2


figure(1); gcf; clf;

for iter=1:numel(t)
    subplot(1,2,1); cla;
    if configuration
        [~, t32, ~, d2]=cs_position(crankLength, couplerLength, offset, t2(iter));
    else
        [t32, ~, d2]=cs_position(crankLength, couplerLength, offset, t2(iter));
    end
    cs_plot(crankLength,couplerLength,offset,d2, t2(iter), t32, 0, eye(3));
    drawnow;
end

% plot the two extreme positions
% t2=asin(offset/(couplerLength+crankLength));
% [~, t32, ~, d2]=cs_position(crankLength, couplerLength, offset, t2);
% cs_plot(crankLength,couplerLength,offset,d2, t2, t32, 0, eye(3));
% 
% % t2=asin(offset/(couplerLength-crankLength))+pi;
% [~, t32, ~, d2]=cs_position(crankLength, couplerLength, offset, t2);
% cs_plot(crankLength,couplerLength,offset,d2, t2, t32, 0, eye(3));

subplot(1,2,2);
% plot the time series of distance
% linspace linearly spaces the time into 100 equal sections

[t3c, t3o, dc, do]=cs_position(crankLength, couplerLength, offset, t2);
if configuration
   plot(t,do, 'k', 'linewidth', 2);
else
   plot(t,dc, 'k', 'linewidth', 2); 
end
set(gca, 'fontsize', 24, 'fontname', 'times');
xlabel('time(s)'); 
ylabel('slider distance');
grid on;