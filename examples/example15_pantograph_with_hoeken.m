function example15_pantograph_with_hoeken(rAZ, rBA, rBY, rYZ, tYZ, rCB, ...
            rXZ, tXZ, rDX, rED, rFE, rCD, rFC, rGF, wAZ, aAZ, t)
%
% SB, NIU, 2019
%
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


addpath ../core


if nargin < 1
    rAZ=10/100;
    rBA=25/100;
    rBY=25/100;
    rYZ=20/100;
    tYZ=0; % rad
    rCB=25/100;
    rXZ=97/100;
    tXZ=pi/2; % rad
    rDX=40/100;
    rED=rDX;
    rFE=rDX;
    rCD=rDX; rDC=rCD;
    rFC=rDX; rCF=rFC;
    rGF=rDX;
    wAZ=1; % rad/s
    aAZ=0;
    t=10; % seconds
end
 
t=linspace(0,t, 100);

tAZ=pi/3+wAZ*t+0.5*aAZ*t.^2; 

% solve hoeken
[aBA, ~, aBY, ~, wBA, ~, wBY, ~, tBA, ~, tBY, ~]= ...
    fourbar_acceleration(rAZ, rBA, rBY, rYZ, aAZ, wAZ, tAZ, 0, 0, tYZ);

% solve position vectors 
[RBAx, RBAy]=pol2cart(tBA, rBA);
[VBAx, VBAy]=omega2vel(tBA,rBA, wBA, 0);
[ABAx, ABAy]=alpha2acc(tBA, rBA,  wBA, 0, aBA, 0);

[RAZx, RAZy]=pol2cart(tAZ, rAZ);
[VAZx, VAZy]=omega2vel(tAZ,rAZ, wAZ,0);
[AAZx, AAZy]=alpha2acc(tAZ,rAZ, wAZ, 0, aAZ, 0);

[RXZx, RXZy]=pol2cart(tXZ, rXZ);
[VXZx, VXZy]=omega2vel(tXZ, rXZ, 0, 0);
[AXZx, AXZy]=alpha2acc(tXZ, rXZ, 0, 0, 0, 0);

% these are simple vector additions
RCZx = 2*RBAx + RAZx;
RCZy = 2*RBAy + RAZy;

% we can use the same equation for velocity and acceleration
VCZx = 2*VBAx + VAZx;
VCZy = 2*VBAy + VAZy;

ACZx = 2*ABAx + AAZx;
ACZy = 2*ABAy + AAZy;


RCXx = RCZx - RXZx;
RCXy = RCZy - RXZy;

VCXx = VCZx - VXZx;
VCXy = VCZy - VXZy;

ACXx = ACZx - AXZx;
ACXy = ACZy - AXZy;


[tCX, rCX]=cart2pol(RCXx, RCXy);
[dotCX, wCX]=vel2omega(rCX, tCX, VCXx, VCXy);
[ddotCX, aCX]= acc2alpha(rCX, tCX, dotCX, wCX, ACXx, ACXy);

% intermediate equations
[~, aDC, ~, aDX, ~, wDC, ~, wDX, ~, tDC, ~, tDX]= ...
    fourbar_acceleration(rCX, rDC, rDX, 0, aCX, wCX, tCX, 0, 0, pi);

[RDXx, RDXy]=pol2cart(tDX, rDX);
[VDXx, VDXy]=omega2vel(tDX, rDX, wDX, 0);
[ADXx, ADXy]=alpha2acc(tDX, rDX, wDX, 0, aDX, 0);

REXx = 2*RDXx;
REXy = 2*RDXy;

RDZx = RDXx + RXZx;
RDZy = RDXy + RXZy;

VEXx = 2*VDXx;
VEXy = 2*VDXy;

AEXx = 2*ADXx;
AEXy = 2*ADXy;

[tEX, rEX]=cart2pol(REXx, REXy);
[dotEX, wEX]=vel2omega(rEX, tEX, VEXx, VEXy);
[ddotEX, aEX]= acc2alpha(rEX, tEX, dotEX, wEX, AEXx, AEXy);

% solve the pantograph
[aFE, ~, aCF, ~, wFE, ~, wCF, ~, tFE, ~, tCF]= ...
    fourbar_acceleration(rEX, rFE, rCF, rCX, aEX, wEX, tEX, aCX, wCX, tCX);

[RFEx, RFEy]=pol2cart(tFE, rFE);
[VFEx, VFEy]=omega2vel(tFE, rFE, wFE, 0);
[AFEx, AFEy]=alpha2acc(tFE, rFE, wFE, 0, aFE, 0);

RGZx = 2*RFEx + REXx + RXZx;
RGZy = 2*RFEy + REXy + RXZy;

VGZx = 2*VFEx + VEXx + VXZx;
VGZy = 2*VFEy + VEXy + VXZy;

AGZx = 2*AFEx + AEXx + AXZx;
AGZy = 2*AFEy + AEXy + AXZy;


REZx = REXx - RDXx + RDZx;
REZy = REXy - RDXy + RDZy;


RBZx = RBAx + RAZx;
RBZy = RBAy + RAZy;

RFZx = RFEx + REZx;
RFZy = RFEy + REZy;

RYZx = rYZ*cos(tYZ)*ones(1, numel(t));
RYZy = rYZ*sin(tYZ)*ones(1, numel(t));

RXZx = RXZx*ones(1, numel(t));
RXZy = RXZy*ones(1, numel(t));

% animate
for k=1:numel(t)
    figure(1); gcf; clf;
    plot(0,0, 'bs');
    plot(0,0, 'bx');
    hold on;
    plot(RXZx, RXZy, 'bs');
    plot(RXZx, RXZy, 'bx');
    plot(RYZx, RYZy, 'bs');
    plot(RYZx, RYZy, 'bx');

    plot([RAZx(k), 0], [RAZy(k), 0], 'r-o')
    
    plot([RBZx(k),RAZx(k)], [RBZy(k), RAZy(k)], 'b-o'); 
    plot([RBZx(k),RYZx(k)], [RBZy(k), RYZy(k)], 'b-o');
    plot([RCZx(k),RAZx(k)], [RCZy(k), RAZy(k)], 'b-o');
    plot([RCZx(k),RDZx(k)], [RCZy(k), RDZy(k)], 'b-o');
    plot([RFZx(k),REZx(k)], [RFZy(k), REZy(k)], 'b-o');
    plot([RCZx(k),RFZx(k)], [RCZy(k), RFZy(k)], 'b-o');
    plot([RGZx(k),RFZx(k)], [RGZy(k), RFZy(k)], 'b-o');
    plot([RDZx(k),RXZx(k)], [RDZy(k), RXZy(k)], 'b-o');
    plot([REZx(k),RDZx(k)], [REZy(k), RDZy(k)], 'b-o');
    plot(RCZx, RCZy, 'k-.');
    plot(RGZx, RGZy, 'k');
    
    text(.01, .01, 'Z', 'fontsize', 16);
    text(RAZx(k)*1.1, RAZy(k)*1.1, 'A', 'fontsize', 16);
    text(RBZx(k)*1.1, RBZy(k)*1.1, 'B', 'fontsize', 16);
    text(RCZx(k)*1.1, RCZy(k)*1.1, 'C', 'fontsize', 16);
    text(RDZx(k)*1.1, RDZy(k)*1.1, 'D', 'fontsize', 16);
    text(REZx(k)*1.1, REZy(k)*1.1, 'E', 'fontsize', 16);
    text(RFZx(k)*1.1, RFZy(k)*1.1, 'F', 'fontsize', 16);
    text(RGZx(k)*1.1, RGZy(k)*1.1, 'G', 'fontsize', 16);

    text(RXZx(k)*1.1, RXZy(k)*1.1, 'X', 'fontsize', 16);
    text(RYZx(k)*1.1, RYZy(k)*1.1, 'Y', 'fontsize', 16);
    
    axis image;
    axis([-1 1 -1 1]);
    
    drawnow();
    grid on;
end

% plot pva data
figure(2); gcf; clf;
subplot(2,2,1);
plot(RGZx, RGZy, 'k', 'linewidth', 2);
grid on;
set(gca, 'fontsize', 16);

subplot(2,2,2);
plot(t, RGZx, 'k:', 'linewidth', 2);
hold on;
plot(t, RGZy, 'k--', 'linewidth', 2);
legend('x', 'y');
grid on;
set(gca, 'fontsize', 16);
xlabel('time(s)');
ylabel('position of G (m)');

subplot(2,2,3);
plot(t, VGZx, 'k:', 'linewidth', 2);
hold on;
plot(t, VGZy, 'k--', 'linewidth', 2);
legend('x', 'y');
grid on;
set(gca, 'fontsize', 16);
xlabel('time(s)');
ylabel('velocity of G (m/s)');

subplot(2,2,4);
plot(t, AGZx, 'k:', 'linewidth', 2);
hold on;
plot(t, AGZy, 'k--', 'linewidth', 2);
legend('x', 'y');
grid on;
set(gca, 'fontsize', 16);
xlabel('time(s)');
ylabel('acceeleration of G (m/s^2)');

% axis([-50 100, 0 150]);
