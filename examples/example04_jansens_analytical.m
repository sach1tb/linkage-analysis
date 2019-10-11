% jansen linkage analysis, values from Jansens_Linkage_Wikipedia.svg

addpath ../core
clear variables
laz=15; lab=50; lby=41.5; lyz=sqrt(38^2+7.8^2);
lac=61.9; lcy=39.3; ldy=40.1; lbd=55.8;
lce=36.7; lde=39.4; lef=65.7; lcf=49;
tzy=190*pi/180;

% angular speed
w2=2; % rad/s
simTime=2*pi/w2; % multiply by the number of cycles you want to see

% *** Processing ***
% linspace linearly spaces the time into 100 equal sections
t=linspace(0,simTime, 100);
tza=w2*t; % theta_2

% note that the fourbar_position solves a linkage in the fourbar.png
% orientation, so if a vector in the equation is not setup that way, we
% should make sure that the angle is updated.
% e.g. the equation R_ZA + R_AB + R_BY - R_ZY = 0 will be solved as
% R_ZA + R_AB - R_YB - R_ZY = 0, so to get angle that by we have to
% add pi (Slide 21, Lecture 11)


% (1) 
[~, tab, ~, to4b]=fourbar_position(laz, lab, lby, lyz, tza, tzy);
tbo4=to4b+pi;

% (2)
[tac, ~, to4c]=fourbar_position(laz, lac, lcy, lyz, tza, tzy);

% (3) ground is oriented at pi since the loop travels
% backward
[~, ~,~, to4d]=fourbar_position(lby, lbd,ldy,  0, to4b, pi);

% (4)
[tce, ~, tde]=fourbar_position(lcy, lce, lde,ldy, to4c, to4d);

% (5) ground is oriented at pi
[~,tef, ~, tcf]=fourbar_position(lce, lef, lcf, 0, tce, pi);


% extract positions of all points
zx=0; zy=0;
yx=lyz*cos(tzy); yy=lyz*sin(tzy);
ax=laz*cos(tza); ay=laz*sin(tza);
bx=laz*cos(tza)+lab*cos(tab); by=laz*sin(tza)+lab*sin(tab);
cx=lyz*cos(tzy)+lcy*cos(to4c); cy=lyz*sin(tzy)+lcy*sin(to4c);
dx=lyz*cos(tzy)+ldy*cos(to4d); dy=lyz*sin(tzy)+ldy*sin(to4d);
ex=lyz*cos(tzy)+ldy*cos(to4d)+lde*cos(tde);ey=lyz*sin(tzy)+ldy*sin(to4d)+lde*sin(tde);
fx=laz*cos(tza)+lac*cos(tac)+lcf*cos(tcf);fy=laz*sin(tza)+lac*sin(tac)+lcf*sin(tcf);


% animate
for ii=1:numel(t)
    figure(1); gcf; clf;
    plot_linkage(zx,zy, yx, yy, ax,ay, bx,by, cx,cy, dx,dy, ex,ey, fx,fy, ii);
    drawnow;
end


figure(1); gcf; clf; % new figure window for plot
ii=1;
subplot(1,3,1);
plot_linkage(zx,zy, yx, yy, ax,ay, bx,by, cx,cy, dx,dy, ex,ey, fx,fy, ii);

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



function plot_linkage(zx,zy, yx, yy, ax,ay, bx,by, cx,cy, dx,dy, ex,ey, fx,fy, ii)

% connect points using lines

plot([ax(ii), bx(ii)], [ay(ii), by(ii)], 'r', 'linewidth', 2);
hold on;
plot(zx,zy, 'ks', 'markersize', 8);
plot(yx, yy, 'rs', 'markersize', 8);
plot([zx, ax(ii)], [zy, ay(ii)], 'r', 'linewidth', 2);
plot([ax(ii), cx(ii)], [ay(ii), cy(ii)], 'k', 'linewidth', 2);
plot([yx, dx(ii)], [yy, dy(ii)], 'g', 'linewidth', 2);
plot([yx, cx(ii)], [yy, cy(ii)], 'k', 'linewidth', 2);
plot([yx, bx(ii)], [yy, by(ii)], 'g', 'linewidth', 2);
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