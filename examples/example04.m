% jansen linkage analysis, values from Jansens_Linkage_Wikipedia.svg

addpath ../core
clear variables
o2a=15; ab=50; bo4=41.5; o2o4=sqrt(38^2+7.8^2);
ac=61.9; o4c=39.3; o4d=40.1; bd=55.8;
ce=36.7; de=39.4; ef=65.7; cf=49;
to2o4=190*pi/180;

% angular speed
w2=2; % rad/s
simTime=2*pi/w2; % multiply by the number of cycles you want to see

% *** Processing ***
% linspace linearly spaces the time into 100 equal sections
t=linspace(0,simTime, 100);
to2a=w2*t; % theta_2

% note that the fourbar_position solves a linkage in the fourbar.png
% orientation, so if a vector in the equation is not setup that way, we
% should make sure that the angle is updated.
% e.g. the equation R_O2A + R_AB + R_BO4 - R_O2O4 = 0 will be solved as
% R_O2A + R_AB - R_O4B - R_O2O4 = 0, so to get angle that BO4 we have to
% add pi (Slide 21, Lecture 11)


% (1) 
[~, tab, ~, to4b]=fourbar_position(o2a, ab, bo4, o2o4, to2a, to2o4);
tbo4=to4b+pi;

% (2)
[tac, ~, to4c]=fourbar_position(o2a, ac, o4c, o2o4, to2a, to2o4);

% (3) ground is oriented at pi since the loop travels
% backward
[~, ~,~, to4d]=fourbar_position(bo4, bd,o4d,  0, to4b, pi);

% (4)
[tce, ~, tde]=fourbar_position(o4c, ce, de,o4d, to4c, to4d);

% (5) ground is oriented at pi
[~,tef, ~, tcf]=fourbar_position(ce, ef, cf, 0, tce, pi);


% extract positions of all points
o2x=0; o2y=0;
o4x=o2o4*cos(to2o4); o4y=o2o4*sin(to2o4);
ax=o2a*cos(to2a); ay=o2a*sin(to2a);
bx=o2a*cos(to2a)+ab*cos(tab); by=o2a*sin(to2a)+ab*sin(tab);
cx=o2o4*cos(to2o4)+o4c*cos(to4c); cy=o2o4*sin(to2o4)+o4c*sin(to4c);
dx=o2o4*cos(to2o4)+o4d*cos(to4d); dy=o2o4*sin(to2o4)+o4d*sin(to4d);
ex=o2o4*cos(to2o4)+o4d*cos(to4d)+de*cos(tde);ey=o2o4*sin(to2o4)+o4d*sin(to4d)+de*sin(tde);
fx=o2a*cos(to2a)+ac*cos(tac)+cf*cos(tcf);fy=o2a*sin(to2a)+ac*sin(tac)+cf*sin(tcf);


% animate
for ii=1:numel(t)
    figure(1); gcf; clf;
    plot_linkage(o2x,o2y, o4x, o4y, ax,ay, bx,by, cx,cy, dx,dy, ex,ey, fx,fy, ii);
    drawnow;
end


figure(1); gcf; clf; % new figure window for plot
ii=1;
subplot(1,3,1);
plot_linkage(o2x,o2y, o4x, o4y, ax,ay, bx,by, cx,cy, dx,dy, ex,ey, fx,fy, ii);

subplot(1,3,2);

plot (fx, fy, 'linewidth', 2); 
set(gca, 'fontsize', 24, 'fontname', 'times');
axis image;
grid on;
title('foot path');

subplot(1,3,3);
plot(t, fx, 'linewidth', 2);
hold on;
plot(t, fy, 'linewidth', 2);
grid on;
set(gca, 'fontsize', 24, 'fontname', 'times');
xlabel('time (s)');
legend('F_x', 'F_y');



function plot_linkage(o2x,o2y, o4x, o4y, ax,ay, bx,by, cx,cy, dx,dy, ex,ey, fx,fy, ii)

% connect points using lines

plot([ax(ii), bx(ii)], [ay(ii), by(ii)], 'r', 'linewidth', 2);
hold on;
plot(o2x,o2y, 'ks', 'markersize', 8);
plot(o4x, o4y, 'rs', 'markersize', 8);
plot([o2x, ax(ii)], [o2y, ay(ii)], 'r', 'linewidth', 2);
plot([ax(ii), cx(ii)], [ay(ii), cy(ii)], 'k', 'linewidth', 2);
plot([o4x, dx(ii)], [o4y, dy(ii)], 'g', 'linewidth', 2);
plot([o4x, cx(ii)], [o4y, cy(ii)], 'k', 'linewidth', 2);
plot([o4x, bx(ii)], [o4y, by(ii)], 'g', 'linewidth', 2);
plot([dx(ii), ex(ii)], [dy(ii), ey(ii)], 'k', 'linewidth', 2);
plot([cx(ii), ex(ii)], [cy(ii), ey(ii)], 'b', 'linewidth', 2);
plot([cx(ii), fx(ii)], [cy(ii), fy(ii)], 'b', 'linewidth', 2);
plot([bx(ii), dx(ii)], [by(ii), dy(ii)], 'g', 'linewidth', 2);
plot([ex(ii), fx(ii)], [ey(ii), fy(ii)], 'b', 'linewidth', 2);

% text(ax(ii), ay(ii), 'A');
% text(bx(ii), by(ii), 'B');
% text(cx(ii), cy(ii), 'C');
% text(dx(ii), dy(ii), 'D');
% text(ex(ii), ey(ii), 'E');
% text(fx(ii), fy(ii), 'F');

axis image;
axis([-50 50 -50 50]*3);
axis off;
end