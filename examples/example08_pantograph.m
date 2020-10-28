function example08_pantograph(rAZ, rAB, rDC, rYZ, wAZ, aAZ)

addpath ../core
% sylvester pantograph
% *all units SI*
% link lengths always in meters and start with lower case r, order of
% uppercase doesn't matter: rAZ=rZA
% vectors start with upper case R, order matters: RAZ != RZA
% angles are always in radians and begin with letter t
% angular rates begin with letter w
% angular accelerations begin with letter a
% linear velocities begin with letter V
% linear accelerations begin with letter A
%
% refer to examples in doc folder for kinematic diagram
%


if nargin < 1
    rAZ=10/100; rAB=40/100;  rDC=40/100; 
    rYZ=54/100;
    tYZ=pi/4; 
    
    rBC=rAB; rDE=rDC;
    rBY=rDC; rYD=rBC; 

    % angular speed of the crank or input link
    wAZ=2; % rad/s
    aAZ=0;
    
    t=10; % seconds
end

t=linspace(0,t, 100);

tAZ=pi/3+wAZ*t+0.5*aAZ*t.^2; 


% note that the fourbar_position solves a linkage in the fourbar.png

% (1) R_AZ + R_BA - R_BY - R_YZ = 0
[aBA, ~, aBY, ~, wBA, ~, wBY, ~, tBA, ~, tBY]=fourbar_acceleration(rAZ, rAB, rBY, rYZ, aAZ, wAZ, tAZ, 0, 0, tYZ);

[RBAx, RBAy]=pol2cart(tBA, rAB);
[VBAx, VBAy]=omega2vel(tBA, rAB, wBA, 0);
[ABAx, ABAy]=alpha2acc(tBA, rAB,  wBA, 0, aBA, 0);


RCBx = RBAx;
RCBy = RBAy;

VCBx = VBAx;
VCBy = VBAy;

ACBx = ABAx;
ACBy = ABAy;

[tCB, rCB]=cart2pol(RCBx, RCBy);
[dotCB, wCB]=vel2omega(rBC, tCB, VCBx, VCBy);
[ddotCB, aCB]= acc2alpha(rBC, tCB, dotCB, wCB, ACBx, ACBy);


[RBYx, RBYy]=pol2cart(tBY, rBY);
[VBYx, VBYy]=omega2vel(tBY, rBY, wBY, 0);
[ABYx, ABYy]=alpha2acc(tBY, rBY,  wBY, 0, aBY, 0);


RYBx = -RBYx;
RYBy = -RBYy;

VYBx = -VBYx;
VYBy = -VBYy;

AYBx = -ABYx;
AYBy = -ABYy;

[tYB, rYB]=cart2pol(RYBx, RYBy);
[dotYB, wYB]=vel2omega(rYB, tYB, VYBx, VYBy);
[ddotYB, aYB]= acc2alpha(rYB, tYB, dotYB, wYB, AYBx, AYBy);


% (2) 
[aDC, ~, aDY, ~, wDC, ~, wDY, ~, tDC,~, tDY]=fourbar_acceleration(rBC, rDC,rYD,  rBY, aCB, wCB, tCB, aYB, wYB, tYB);


% extract positions of all points

[RYZx, RYZy] = pol2cart(tYZ, rYZ);

[RAZx, RAZy]=pol2cart(tAZ, rAZ);
[VAZx, VAZy]=omega2vel(tAZ,rAZ, wAZ,0);
[AAZx, AAZy]=alpha2acc(tAZ,rAZ, wAZ, 0, aAZ, 0);


RBZx = RBAx + RAZx;
RBZy = RBAy + RAZy;

[RCBx, RCBy]=pol2cart(tCB, rBC);
[VCBx, VCBy]=omega2vel(tCB, rBC, wCB, 0);
[ACBx, ACBy]=alpha2acc(tCB, rBC, wCB, 0, aCB, 0);

RCZx = 2*RBAx + RAZx;
RCZy = 2*RBAy + RAZy;


[RDCx, RDCy]=pol2cart(tDC, rDC);
[VDCx, VDCy]=omega2vel(tDC, rDC, wDC, 0);
[ADCx, ADCy]=alpha2acc(tDC, rDC, wDC, 0, aDC, 0);
RDZx = RDCx + RCZx;
RDZy = RDCy + RCZy;


[RDYx, RDYy]=pol2cart(tDY, rYD);
[VDYx, VDYy]=omega2vel(tDY, rYD, wDY, 0);
[ADYx, ADYy]=alpha2acc(tDY, rYD, wDY, 0, aDY, 0);

RDZx = RDYx + RYZx;
RDZy = RDYy + RYZy;


REZx = 2*RDCx + RCBx + RBAx + RAZx;
REZy = 2*RDCy + RCBy + RBAy + RAZy;

VEZx = 2*VDCx + VCBx + VBAx + VAZx;
VEZy = 2*VDCy + VCBy + VBAy + VAZy;

AEZx = 2*ADCx + ACBx + ABAx + AAZx;
AEZy = 2*ADCy + ACBy + ABAy + AAZy;

RYZx = RYZx*ones(1, numel(t));
RYZy = RYZy*ones(1, numel(t));

% animate
for k=1:numel(t)
    figure(1); gcf; clf;
    plot(0,0, 'bs');
    plot(0,0, 'bx');
    hold on;
    plot(RYZx, RYZy, 'bs');
    plot(RYZx, RYZy, 'bx');

    plot([RAZx(k), 0], [RAZy(k), 0], 'r-o')
    plot([RBZx(k),RAZx(k)], [RBZy(k), RAZy(k)], 'b-o'); 
    plot([RBZx(k),RYZx(k)], [RBZy(k), RYZy(k)], 'b-o');
    plot([RCZx(k),RBZx(k)], [RCZy(k), RBZy(k)], 'b-o');
    plot([RCZx(k),RDZx(k)], [RCZy(k), RDZy(k)], 'b-o');
    plot([RDZx(k),RYZx(k)], [RDZy(k), RYZy(k)], 'b-o');
    plot([REZx(k),RDZx(k)], [REZy(k), RDZy(k)], 'b-o');
    plot(REZx, REZy, 'k');
    
    text(.01, .01, 'Z', 'fontsize', 16);
    text(RAZx(k)*1.1, RAZy(k)*1.1, 'A', 'fontsize', 16);
    text(RBZx(k)*1.1, RBZy(k)*1.1, 'B', 'fontsize', 16);
    text(RCZx(k)*1.1, RCZy(k)*1.1, 'C', 'fontsize', 16);
    text(RDZx(k)*1.1, RDZy(k)*1.1, 'D', 'fontsize', 16);
    text(REZx(k)*1.1, REZy(k)*1.1, 'E', 'fontsize', 16);

    text(RYZx(k)*1.1, RYZy(k)*1.1, 'Y', 'fontsize', 16);
    
    axis image;
    axis([-1 1 -1 1]);
    
    drawnow();
    grid on;
end

% plot pva data
figure(2); gcf; clf;
subplot(2,2,1);
plot(REZx, REZy, 'k', 'linewidth', 2);
grid on;
axis image
set(gca, 'fontsize', 16);

subplot(2,2,2);
plot(t, REZx, 'k:', 'linewidth', 2);
hold on;
plot(t, REZy, 'k--', 'linewidth', 2);
legend('x', 'y');
grid on;
set(gca, 'fontsize', 16);
xlabel('time(s)');
ylabel('position of E (m)');

subplot(2,2,3);
plot(t, VEZx, 'k:', 'linewidth', 2);
hold on;
plot(t, VEZy, 'k--', 'linewidth', 2);
legend('x', 'y');
grid on;
set(gca, 'fontsize', 16);
xlabel('time(s)');
ylabel('velocity of E (m/s)');

subplot(2,2,4);
plot(t, AEZx, 'k:', 'linewidth', 2);
hold on;
plot(t, AEZy, 'k--', 'linewidth', 2);
legend('x', 'y');
grid on;
set(gca, 'fontsize', 16);
xlabel('time(s)');
ylabel('acceeleration of E (m/s^2)');

