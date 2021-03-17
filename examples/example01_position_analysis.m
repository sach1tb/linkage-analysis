function example01_position_analysis(a,b,c,d,APlen,BAP,w2,cfg, simTime)
% see fourbar.png for the meaning of each parameter
% parameters >> these can be changed
% link lengths

% the line below adds the core scripts to the current working directory
addpath ../core

if nargin< 1
    % test linkage
    a=1.36; b=10; c=10; d=15;
    APlen=20; BAP=0; % BAP

    % hoeken's
%     a=2; b=5; c=5; d=4;
%     APlen=10; BAP=0; % BAP
    
    w2=-2; % rad/s
    cfg=1;
    simTime=2*pi/abs(w2); % multiply by the number of cycles you want to see 
end
% *** Processing ***
% linspace linearly spaces the time into 100 equal sections
t=linspace(0,simTime, 100);
t1=0; % ground orientation
t2=w2*t; % theta_2
[t3o, t3c, t4o, t4c]=fourbar_position(a, b, c, d, t2, t1);
if cfg==1
    px=a*cos(t2)+APlen*cos(t3o+BAP);
    py=a*sin(t2)+APlen*sin(t3o+BAP);
else
    px=a*cos(t2)+APlen*cos(t3c+BAP);
    py=a*sin(t2)+APlen*sin(t3c+BAP);
end
figure(1); gcf; clf;


if cfg==1
    for iter=1:numel(t)
        figure(1); gcf; clf;
        fourbar_plot(a,b,c,d,BAP,APlen, t2(iter),t3o(iter),...
            t4o(iter),t1, eye(3));
        drawnow;
        grid on;
    end
else
    for iter=1:numel(t)
        figure(1); gcf; clf;
        fourbar_plot(a,b,c,d,BAP,APlen, t2(iter),t3c(iter),...
            t4c(iter),t1, eye(3));
        drawnow;
        grid on;
    end
end
plot(px,py, 'k-.', 'linewidth', 2);
set(gca, 'fontsize', 24, 'fontname', 'times');

figure(2); gcf; clf;
plot(t, px, 'k:', 'linewidth', 2);
hold on;
plot(t, py, 'k--', 'linewidth', 2);
legend('x', 'y');
grid on;
set(gca, 'fontsize', 16);
xlabel('time(s)');
ylabel('position of P (m)');