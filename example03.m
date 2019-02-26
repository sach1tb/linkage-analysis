function example03
% we name it a function so that we can put the vector loop equations in the
% same script

% jansen linkage analysis

o2a=15; ab=50; bo4=41.5; o2o4=sqrt(38^2+7.8^2);
ac=61.9; o4c=39.3; o4d=40.1; bd=55.8; 
ce=36.7; de=39.4; ef=65.7; cf=49;

ll=[o2a; ab; bo4; o2o4; ac; o4c; o4d; bd; ce; de; ef; cf];
to2o4=190*pi/180;

% initial guess by eyeballing the angles on the slides
x0 = [120, 240, 210, 280, 120, 190, 150, 280, 280, 250]*pi/180;

t=0:.1:10; % time in seconds
omega=1; % angular velocity
t2=omega*t; % theta_2 is angular velocity x time

options = optimoptions('fsolve','Display','off');
for ii=1:numel(t)
    [x(:,ii), fval] = fsolve(@(x) vecloopjansen(x, ll,to2o4,  t2(ii)), x0, options);
    % check the value of fval to make sure everything is working
    x0=x(:,ii)'; % the next guess is the current solution
end

% re assign the values back
tab=x(1,:);
tbo4=x(2,:);
tac=x(3,:);
to4c=x(4,:);
to4d=x(5,:);
tbd=x(6,:);
tce=x(7,:);
tde=x(8,:);
tef=x(9,:);
tcf=x(10,:);


o4x=o2o4*cos(to2o4); o4y=o2o4*sin(to2o4);
ax=o2a*cos(t2); ay=o2a*sin(t2);
bx=o2a*cos(t2)+ab*cos(tab); by=o2a*sin(t2)+ab*sin(tab);
cx=o2o4*cos(to2o4)+o4c*cos(to4c); cy=o2o4*sin(to2o4)+o4c*sin(to4c);
dx=o2o4*cos(to2o4)+o4d*cos(to4d); dy=o2o4*sin(to2o4)+o4d*sin(to4d);
ex=o2o4*cos(to2o4)+o4d*cos(to4d)+de*cos(tde);ey=o2o4*sin(to2o4)+o4d*sin(to4d)+de*sin(tde);
fx=o2a*cos(t2)+ac*cos(tac)+cf*cos(tcf);fy=o2a*sin(t2)+ac*sin(tac)+cf*sin(tcf);


% % animate
% for ii=1:numel(t)
%     figure(1); gcf; clf;
%     plot([0, ax(ii)], [0, ay(ii)], 'k-.');
%     hold on;
%     plot(0,0, 's');
%     plot(o4x, o4y, 's');
%     text(ax(ii), ay(ii), 'A');
%     text(bx(ii), by(ii), 'B');
%     text(cx(ii), cy(ii), 'C');
%     text(dx(ii), dy(ii), 'D');
%     text(ex(ii), ey(ii), 'E');
%     text(fx(ii), fy(ii), 'F');
%     plot([ax(ii), bx(ii)], [ay(ii), by(ii)], 'k-.', 'linewidth', 2);
%     plot([ax(ii), cx(ii)], [ay(ii), cy(ii)], 'r--', 'linewidth', 2);
%     plot([o4x, dx(ii)], [o4y, dy(ii)], 'k--', 'linewidth', 2);
%     plot([o4x, cx(ii)], [o4y, cy(ii)], 'k--', 'linewidth', 2);
%     plot([o4x, bx(ii)], [o4y, by(ii)], 'k-.', 'linewidth', 2);
%     plot([dx(ii), ex(ii)], [dy(ii), ey(ii)], 'k--', 'linewidth', 2);
%     plot([cx(ii), ex(ii)], [cy(ii), ey(ii)], 'b--', 'linewidth', 2);
%     plot([cx(ii), fx(ii)], [cy(ii), fy(ii)], 'g--', 'linewidth', 2);
%     plot([bx(ii), dx(ii)], [by(ii), dy(ii)], 'k--', 'linewidth', 2);
%     plot([ex(ii), fx(ii)], [ey(ii), fy(ii)], 'b--', 'linewidth', 2);
% 
%     axis image;
%     
%     axis([-50 50 -50 50]*3);
%     drawnow;
% end

figure(1); gcf; clf; % new figure window for plot
ii=10;
subplot(1,3,1);
plot([ax(ii), bx(ii)], [ay(ii), by(ii)], 'r', 'linewidth', 2);
hold on;
plot(0,0, 'ks', 'markersize', 8);
plot(o4x, o4y, 'rs');
plot([0, ax(ii)], [0, ay(ii)], 'r', 'linewidth', 2);
plot([ax(ii), cx(ii)], [ay(ii), cy(ii)], 'k', 'linewidth', 2);
plot([o4x, dx(ii)], [o4y, dy(ii)], 'g', 'linewidth', 2);
plot([o4x, cx(ii)], [o4y, cy(ii)], 'k', 'linewidth', 2);
plot([o4x, bx(ii)], [o4y, by(ii)], 'g', 'linewidth', 2);
plot([dx(ii), ex(ii)], [dy(ii), ey(ii)], 'k', 'linewidth', 2);
plot([cx(ii), ex(ii)], [cy(ii), ey(ii)], 'b', 'linewidth', 2);
plot([cx(ii), fx(ii)], [cy(ii), fy(ii)], 'b', 'linewidth', 2);
plot([bx(ii), dx(ii)], [by(ii), dy(ii)], 'g', 'linewidth', 2);
plot([ex(ii), fx(ii)], [ey(ii), fy(ii)], 'b', 'linewidth', 2);
grid on;
axis square
axis off;

subplot(1,3,2);

plot (fx, fy, 'linewidth', 2); 
set(gca, 'fontsize', 24, 'fontname', 'times');
axis image;
grid on;

subplot(1,3,3);
plot(t, fx, 'linewidth', 2);
hold on;
plot(t, fy, 'linewidth', 2);
grid on;
set(gca, 'fontsize', 24, 'fontname', 'times');
xlabel('time (s)');
legend('F_x', 'F_y');


function F=vecloopjansen(x, ll,to2o4, to2a)
% vector loop equations for fourbar linkage
% x is a vector of unknown variables, in this case, t3 and t4
% a,b,c,d, and t2 are as defined in fourbar.png

% initial guess
tab=x(1);
tbo4=x(2);
tac=x(3);
to4c=x(4);
to4d=x(5);
tbd=x(6);
tce=x(7);
tde=x(8);
tef=x(9);
tcf=x(10);

o2a=ll(1);  ab=ll(2); bo4=ll(3); o2o4=ll(4); ac=ll(5); o4c=ll(6); 
o4d=ll(7); bd=ll(8); ce=ll(9); de=ll(10); ef=ll(11); cf=ll(12);

% vector loop equations
%(1)
F(1)=o2a*cos(to2a)+ab*cos(tab)+bo4*cos(tbo4)-o2o4*cos(to2o4);
F(2)=o2a*sin(to2a)+ab*sin(tab)+bo4*sin(tbo4)-o2o4*sin(to2o4);

%(2)
F(3)=o2a*cos(to2a)+ac*cos(tac)-o4c*cos(to4c)-o2o4*cos(to2o4);
F(4)=o2a*sin(to2a)+ac*sin(tac)-o4c*sin(to4c)-o2o4*sin(to2o4);

%(3)
F(5)=bo4*cos(tbo4)+o4d*cos(to4d)-bd*cos(tbd);
F(6)=bo4*sin(tbo4)+o4d*sin(to4d)-bd*sin(tbd);

%(4)
F(7)=o4c*cos(to4c)+ce*cos(tce)-o4d*cos(to4d)-de*cos(tde);
F(8)=o4c*sin(to4c)+ce*sin(tce)-o4d*sin(to4d)-de*sin(tde);

%(5)
F(9)=ce*cos(tce)+ef*cos(tef)-cf*cos(tcf);
F(10)=ce*sin(tce)+ef*sin(tef)-cf*sin(tcf);
