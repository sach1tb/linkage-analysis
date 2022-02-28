function example01_position_analysis(a,b,c,d,APlen,BAP,w2,cfg, simTime)
% see fourbar.png for the meaning of each parameter
% parameters >> these can be changed
% link lengths

% the line below adds the core scripts to the current working directory
addpath ../core

if nargin< 1
    % test linkage
    a=1.3;
    b=1.9;
    c=2.1;
    d=2.5;
    APlen=4; BAP=0; % BAP

    % hoeken's
%     a=2; b=5; c=5; d=4;
%     APlen=10; BAP=0; % BAP
    
    w2=2; % rad/s
    cfg=1;
    simTime=10*pi/abs(w2); % multiply by the number of cycles you want to see 
end
% *** Processing ***
% linspace linearly spaces the time into 100 equal sections
if simTime > 1
    t=linspace(0,simTime, 100);
else
    t=linspace(0,simTime, 10);
end
theta1=0; % ground orientation
theta2=w2*t; % theta_2
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

RO4O2x = d*ones(1, numel(t));
RO4O2y = 0*ones(1, numel(t));

RPO2x=RPAx+RAO2x;
RPO2y=RPAy+RAO2y;

figure(1); gcf; clf;

% animate
for k=1:numel(t)
    figure(1); gcf; clf;
    plot(0,0, 'bs');
    hold on;
    plot(0,0, 'bx');
    plot(RO4O2x, RO4O2y, 'bs');
    plot(RO4O2x, RO4O2y, 'bx');

    plot([RAO2x(k), 0], [RAO2y(k), 0], 'r-o')
    
    plot([RBO2x(k),RAO2x(k)], [RBO2y(k), RAO2y(k)], 'b-o'); 
    plot([RPO2x(k),RAO2x(k)], [RPO2y(k), RAO2y(k)], 'b-o'); 
    plot([RBO2x(k),RPO2x(k)], [RBO2y(k), RPO2y(k)], 'b-o'); 
    plot([RBO2x(k),RO4O2x(k)], [RBO2y(k), RO4O2y(k)], 'b-o'); 
    
    text(.01, .01, 'O2', 'fontsize', 16);
    text(RAO2x(k)*1.1, RAO2y(k)*1.1, 'A', 'fontsize', 16);
    text(RBO2x(k)*1.1, RBO2y(k)*1.1, 'B', 'fontsize', 16);

    text(RO4O2x(k)*1.1, RO4O2y(k)*1.1, 'O4', 'fontsize', 16);
    
    axis image;
    axis([-(d+a) (d+c+APlen) -(a+b+APlen) (a+b+APlen)]);
    
    drawnow();
    grid on;
end

% plot pva data
plot(RPO2x, RPO2y, 'k', 'linewidth', 2);
grid on;
set(gca, 'fontsize', 16);

figure(2); gcf; clf;
plot(t, RPO2x, 'k:', 'linewidth', 2);
hold on;
plot(t, RPO2y, 'k--', 'linewidth', 2);
legend('x', 'y');
grid on;
set(gca, 'fontsize', 16);
xlabel('time(s)');
ylabel('position of point P (m)');
