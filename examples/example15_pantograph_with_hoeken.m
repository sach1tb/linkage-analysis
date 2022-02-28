function example15_pantograph_with_hoeken(rAZ, rBA, rBY, rYZ, tYZ, rCB, ...
            rXZ, tXZ, rDX, rED, rFE, rCD, rFC, rGF, wAZ, aAZ, FG, lnk_rho, ...
            lnk_thickness, lnk_width, t)
%
% SB, NIU, 2019
%
% * all units SI (m, kg, N, s, radians)
% * link lengths start with lower case r, order of successive letters 
%   doesn't matter: rAZ=rZA
% * vectors start with upper case R, order matters: RAZ != RZA
% * angles begin with letter t
% * angular rates begin with letter w
% * angular accelerations begin with letter a
% * linear velocities begin with letter V
% * linear velocities of center of mass of a link begin with Vc
% * linear accelerations begin with letter A
% * linear accelerations of center of mass of a link begin with Ac
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
    FG=[0; 1]; % N, can also be a time profile to apply load only when needed
    lnk_rho=1190; % kg/m^3
    lnk_thickness=0.0047625; % m
    lnk_width=0.013; % m
end
 
t=linspace(0,t, 100);

tAZ=pi/3+wAZ*t+0.5*aAZ*t.^2; 

% solve hoeken
[aBA, ~, aBY, ~, wBA, ~, wBY, ~, tBA, ~, tBY, ~]= ...
    fourbar_acceleration(rAZ, rBA, rBY, rYZ, aAZ, wAZ, tAZ, 0, 0, tYZ);

% solve position vectors 
% we need these to implement the next set of equations
[RBAx, RBAy]=pol2cart(tBA, rBA);
[VBAx, VBAy]=omega2vel(tBA,rBA, wBA, 0);
[ABAx, ABAy]=alpha2acc(tBA, rBA,  wBA, 0, aBA, 0);

[RBYx, RBYy]=pol2cart(tBY, rBY);
[VBYx, VBYy]=omega2vel(tBY,rBY, wBY, 0);
[ABYx, ABYy]=alpha2acc(tBY, rBY,  wBY, 0, aBY, 0);

% ground links
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

% convert back to angular values so we can plug in for links that change
% size and orientation at the same time
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
    hold on;
    plot(0,0, 'bx');
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


% torque analysis using virtual work
% mass of each link
dpl=lnk_rho*lnk_thickness*lnk_width; % density per length

mAZ=dpl*rAZ;
mBA=dpl*rBA;
mBY=dpl*rBY;
mCA=dpl*rCB*2;
mEX=dpl*rDX*2;
mED=dpl*rED;
mFE=dpl*rFE;
mCD=dpl*rCD;
mFC=dpl*rFC;
mGE=dpl*rGF*2;

% moment of inertia of each link, assuming very littl
iAZ=mAZ*(rAZ^2+lnk_width^2)/12; 
iBA=mBA*(rBA^2+lnk_width^2)/12;
iBY=mBY*(rBY^2+lnk_width^2)/12;
iCA=mCA*((2*rCB)^2+lnk_width^2)/12;
iEX=mEX*((2*rDX)^2+lnk_width^2)/12;
iED=mED*(rED^2+lnk_width^2)/12;
iFE=mFE*(rFE^2+lnk_width^2)/12;
iCD=mCD*(rCD^2+lnk_width^2)/12;
iFC=mFC*(rFC^2+lnk_width^2)/12;
iGE=mGE*((2*rGF)^2+lnk_width^2)/12;

% velocities and accelerations of center of gravity of each link
[VcAZx, VcAZy]=omega2vel(tAZ, rAZ/2, wAZ, 0);
[AcAZx, AcAZy]=alpha2acc(tAZ,rAZ/2, wAZ, 0, aAZ, 0);

VcCAx = 2*VBAx/2 + VAZx;
VcCAy = 2*VBAy/2 + VAZy;

AcCAx = 2*ABAx/2 + AAZx;
AcCAy = 2*ABAy/2 + AAZy;

[VcBYx, VcBYy]=omega2vel(tBY, rBY/2, wBY, 0);
[AcBYx, AcBYy]=alpha2acc(tBY, rBY/2,  wBY, 0, aBY, 0);

[VCFx, VCFy]=omega2vel(tCF, rCF, wCF, 0);
[ACFx, ACFy]=alpha2acc(tCF, rCF, wCF, 0, aCF, 0);

VcFCx = -VCFx/2 + 2*VBAx + VAZx;
VcFCy = -VCFy/2 + 2*VBAy + VAZy;

AcFCx = -ACFx/2 + 2*ABAx + AAZx;
AcFCy = -ACFy/2 + 2*ABAy + AAZy;

[VDCx, VDCy]=omega2vel(tDC, rDC, wDC, 0);
[ADCx, ADCy]=alpha2acc(tDC, rDC, wDC, 0, aDC, 0);

VcDCx = VDCx/2 + 2*VBAx + VAZx;
VcDCy = VDCy/2 + 2*VBAy + VAZy;

AcDCx = ADCx/2 + 2*ABAx + AAZx;
AcDCy = ADCy/2 + 2*ABAy + AAZy;


VcEXx = 2*VDXx/2;
VcEXy = 2*VDXy/2;

AcEXx = 2*ADXx/2;
AcEXy = 2*ADXy/2;

VcGEx = 2*VFEx/2 + VEXx + VXZx;
VcGEy = 2*VFEy/2 + VEXy + VXZy;

AcGEx = 2*AFEx/2 + AEXx + AXZx;
AcGEy = 2*AFEy/2 + AEXy + AXZy;


% terms of the final equation without the signs (10.28 in book)

% external forces
if size(FG,2)==1 % if FG is not a profile e.g. foot hitting the ground
   FG=FG*ones(1,numel(t));
end
t1=dot(FG, [VGZx; VGZy]); 
% inertial forces
t3= mAZ*dot([AcAZx; AcAZy], [VcAZx; VcAZy]) + ...
    mCA*dot([AcCAx; AcCAy], [VcCAx; VcCAy]) + ...
    mBY*dot([AcBYx; AcBYy], [VcBYx; VcBYy]) + ...
    mFC*dot([AcFCx; AcFCy], [VcFCx; VcFCy]) + ...
    mCD*dot([AcDCx; AcDCy], [VcDCx; VcDCy]) + ...
    mEX*dot([AcEXx; AcEXy], [VcEXx; VcEXy]) + ...
    mGE*dot([AcGEx; AcGEy], [VcGEx; VcGEy]);

% inertial torques
t4= iAZ*aAZ.*wAZ + ...
    iCA*aBA.*wBA + ...
    iBY*aBY.*wBY + ...
    iFC*aCF.*wCF + ...
    iCD*aDC.*wDC + ...
    iEX*aEX.*wEX + ...
    iGE*aFE.*wFE;


T_motor=1/wAZ*(t3+t4-t1);

figure(3); gcf; clf;
plot(t, T_motor, 'k', 'linewidth', 2);
grid on;
set(gca, 'fontsize', 16);
xlabel('time(s)');
ylabel('required motor torque (Nm)');
