clear variables;

addpath ../core

% jansen linkage analysis, values from Jansens_Linkage_Wikipedia.svg

lza=15; lab=50; lby=41.5; lzy=sqrt(38^2+7.8^2);
lac=61.9; lyc=39.3; lyd=40.1; lbd=55.8; 
lce=36.7; lde=39.4; lef=65.7; lcf=49;

% link lengths and ground orientation as parameters to be passed to fsolve
ll=[lza; lab; lby; lzy; lac; lyc; lyd; lbd; lce; lde; lef; lcf];
tzy=190*pi/180;

% initial guess by eyeballing the angles on the lecture slides
x0 = [120, 240, 210, 280, 120, 190, 150, 280, 280, 250]*pi/180;

% angular speed
w2=2; % rad/s
simTime=2*pi/w2; % multiply by the number of cycles you want to see

% *** Processing ***
% linspace linearly spaces the time into 100 equal sections
t=linspace(0,simTime, 100);
tza=w2*t; % theta_2

options = optimoptions('fsolve','Display','off');
x=zeros(10,numel(t));
for ii=1:numel(t)
    [x(:,ii), fval] = fsolve(@(x) vecloopjansen(x, ll,tzy,  tza(ii)), x0, options);
    % check the value of fval to make sure everything is working
    x0=x(:,ii)'; % the next guess is the current solution
end

% re assign the values back

tab=x(1,:);
tby=x(2,:);
tac=x(3,:);
to4c=x(4,:);
tyd=x(5,:);
tbd=x(6,:);
tce=x(7,:);
tde=x(8,:);
tef=x(9,:);
tcf=x(10,:);


% position of each point on the linkage
zx=0; zy=0;
yx=lzy*cos(tzy); yy=lzy*sin(tzy);
ax=lza*cos(tza); ay=lza*sin(tza);
bx=lza*cos(tza)+lab*cos(tab); by=lza*sin(tza)+lab*sin(tab);
cx=lzy*cos(tzy)+lyc*cos(to4c); cy=lzy*sin(tzy)+lyc*sin(to4c);
dx=lzy*cos(tzy)+lyd*cos(tyd); dy=lzy*sin(tzy)+lyd*sin(tyd);
ex=lzy*cos(tzy)+lyd*cos(tyd)+lde*cos(tde);ey=lzy*sin(tzy)+lyd*sin(tyd)+lde*sin(tde);
fx=lza*cos(tza)+lac*cos(tac)+lcf*cos(tcf);fy=lza*sin(tza)+lac*sin(tac)+lcf*sin(tcf);


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


function F=vecloopjansen(x, ll,tzy, tza)
% vector loop equations for fourbar linkage
% x is a vector of unknown variables, in this case, t3 and t4
% a,b,c,d, and tza are as defined in fourbar.png

% initial guess
tab=x(1);
tby=x(2);
tac=x(3);
to4c=x(4);
tyd=x(5);
tbd=x(6);
tce=x(7);
tde=x(8);
tef=x(9);
tcf=x(10);

lza=ll(1);  lab=ll(2); lby=ll(3); lzy=ll(4); lac=ll(5); lyc=ll(6); 
lyd=ll(7); lbd=ll(8); lce=ll(9); lde=ll(10); lef=ll(11); lcf=ll(12);

% vector loop equations
%(1)
F(1)=lza*cos(tza)+lab*cos(tab)+lby*cos(tby)-lzy*cos(tzy);
F(2)=lza*sin(tza)+lab*sin(tab)+lby*sin(tby)-lzy*sin(tzy);

%(2)
F(3)=lza*cos(tza)+lac*cos(tac)-lyc*cos(to4c)-lzy*cos(tzy);
F(4)=lza*sin(tza)+lac*sin(tac)-lyc*sin(to4c)-lzy*sin(tzy);

%(3)
F(5)=lby*cos(tby)+lyd*cos(tyd)-lbd*cos(tbd);
F(6)=lby*sin(tby)+lyd*sin(tyd)-lbd*sin(tbd);

%(4)
F(7)=lyc*cos(to4c)+lce*cos(tce)-lyd*cos(tyd)-lde*cos(tde);
F(8)=lyc*sin(to4c)+lce*sin(tce)-lyd*sin(tyd)-lde*sin(tde);

%(5)
F(9)=lce*cos(tce)+lef*cos(tef)-lcf*cos(tcf);
F(10)=lce*sin(tce)+lef*sin(tef)-lcf*sin(tcf);
end

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
