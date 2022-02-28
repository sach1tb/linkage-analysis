function example12_jansen(rZA, wAZ, rAB, rBY, rZY, tYZ, rAC, rYC, rYD, ...
                        rBD, rCE, rDE, rEF, rCF, FF, lnk_rho, ...
                        lnk_thickness, lnk_width, simTime)

addpath ../core

% * all units SI (m, kg, N, s, radians)
% * link lengths start with lower case r, order of successive letters 
%   doesn't matter: rAZ=rZA
% * vectors start with upper case R, order matters: RAZ != RZA
% * angles begin with letter t, order matters: tYZ != tZY
% * angular rates begin with letter w
% * angular accelerations begin with letter a
% * linear velocities begin with letter V
% * linear accelerations begin with letter A
% 
% refer to examples in doc folder for kinematic diagram

if nargin < 1
    rZA=15/100; rAB=50/100; rBY=41.5/100; rZY=sqrt(38^2+7.8^2)/100;
    rAC=61.9/100; rYC=39.3/100; rYD=40.1/100; rBD=55.8/100; 
    rCE=36.7/100; rDE=39.4/100; rEF=65.7/100; rCF=49/100;
    wAZ=1; % rad/s angular speed of crank
    tYZ=190;
    lnk_rho=1190; % kg/m^3
    lnk_thickness=0.0047625; % m
    lnk_width=0.013; % m
    
    FF=[0; 1]; % N, can also be a time profile to apply load only when needed
    
    simTime=10; % seconds
    
    
end

% ** angle between the ground links
tYZ=tYZ*pi/180;

aAZ=0; % rad/s^2 angular acceleration of crank

% linspace linearly spaces the time into 100 equal sections
t=linspace(0,simTime, simTime*10);
tAZ=wAZ*t; % t_2

tYZ=tYZ*ones(1,numel(t));

% note that the fourbar_* functions solve the linkage according to fourbar.png

% ** (1) RAZ + RBA - RBY - RZY = 0
[~, aBA, ~, aBY, ~, wBA, ~, wBY, ~, tBA, ~, tBY]= ...
    fourbar_acceleration(rZA, rAB, rBY, rZY, aAZ, wAZ, tAZ, 0, 0, tYZ);
% the above is cross configuration, if you have open configuration then
% simply remove the first ~  as below
% [aBA, ~, aBY, ~, wBA, ~, wBY, ~, tBA, ~, tBY]=...
% fourbar_acceleration(az, rAB, rBY, rZY, aAZ, wAZ, tAZ, 0, 0, tYZ);

% ** (2) RAZ + RCA - RCY - RYZ = 0
[aCA, ~, aCY, ~, wCA, ~, wCY, ~, tCA,~, tCY]= ...
    fourbar_acceleration(rZA, rAC,rYC,  rZY, aAZ, wAZ, tAZ, 0, 0, tYZ);

% ** (3) RBY + RDB - RDY - RYY = 0
[~, aDB, ~, aDY, ~, wDB, ~, wDY, ~, tDB,~, tDY]=...
    fourbar_acceleration(rBY, rBD,rYD,  0, aBY, wBY, tBY, 0, 0, 0);

% ** (4) RCY + REC - RED - RDY = 0
[aEC, ~, aED, ~, wEC, ~, wED, ~, tEC,~, tED]=...
    fourbar_acceleration(rYC, rCE, rDE,  rYD, aCY, wCY, tCY, 0, 0, tDY);

% ** (5) REC + RFE - RFC - RCC= 0 
[~, aFE, ~, aFC, ~, wFE, ~, wFC, ~, tFE,~, tFC]=...
    fourbar_acceleration(rCE, rEF, rCF,  0, aEC, wEC, tEC, 0, 0, 0);

% solve position vectors 
[RYZx, RYZy] = pol2cart(tYZ, rZY);
[RAZx, RAZy] = pol2cart(tAZ, rZA);
[VAZx, VAZy] = omega2vel(tAZ, rZA, wAZ, 0);
[AAZx, AAZy] = alpha2acc(tAZ, rZA, wAZ, 0, aAZ, 0);

[RBAx, RBAy] = pol2cart(tBA, rAB);
[VBAx, VBAy] = omega2vel(tBA, rAB, wBA, 0);
[ABAx, ABAy] = alpha2acc(tBA, rAB, wBA, 0, aBA, 0);

RBZx = RBAx + RAZx;
RBZy = RBAy + RAZy;

VBZx = VBAx + VAZx;
VBZy = VBAy + VAZy;

ABZx = ABAx + AAZx;
ABZy = ABAy + AAZy;

[RCAx, RCAy] = pol2cart(tCA, rAC);        
RCZx = RCAx + RAZx;
RCZy = RCAy + RAZy;

[RDBx, RDBy] = pol2cart(tDB, rBD);
[VDBx, VDBy] = omega2vel(tDB, rBD, wDB, 0);
[ADBx, ADBy] = alpha2acc(tDB, rBD, wDB, 0, aDB, 0);
RDZx = RDBx + RBZx;
RDZy = RDBy + RBZy;

VDZx = VDBx + VBZx;
VDZy = VDBy + VBZy;

ADZx = ADBx + ABZx;
ADZy = ADBy + ABZy;

[REDx, REDy] = pol2cart(tED, rDE);
[VEDx, VEDy] = omega2vel(tED, rDE, wED, 0);
[AEDx, AEDy] = alpha2acc(tED, rDE, wED, 0, aED, 0);

REZx = REDx + RDZx;
REZy = REDy + RDZy;

VEZx = VEDx + VDZx;
VEZy = VEDy + VDZy;

AEZx = AEDx + ADZx;
AEZy = AEDy + ADZy;

[RFEx, RFEy] = pol2cart(tFE, rEF);
[VFEx, VFEy] = omega2vel(tFE, rEF, wFE, 0);
[AFEx, AFEy] = alpha2acc(tFE, rEF, wFE, 0, aFE, 0);

RFZx = RFEx + REZx;
RFZy = RFEy + REZy;

VFZx = VFEx + VEZx;
VFZy = VFEy + VEZy;

AFZx = AFEx + AEZx;
AFZy = AFEy + AEZy;


figure(1); gcf; clf; % new figure window for plot

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
    plot([RBZx(k),RDZx(k)], [RBZy(k), RDZy(k)], 'b-o');
    plot([RCZx(k),RAZx(k)], [RCZy(k), RAZy(k)], 'b-o');
    plot([RCZx(k),RYZx(k)], [RCZy(k), RYZy(k)], 'b-o');
    plot([RDZx(k),RYZx(k)], [RDZy(k), RYZy(k)], 'b-o');
    plot([REZx(k),RDZx(k)], [REZy(k), RDZy(k)], 'b-o');
    plot([REZx(k),RCZx(k)], [REZy(k), RCZy(k)], 'b-o');
    plot([RFZx(k),REZx(k)], [RFZy(k), REZy(k)], 'b-o');
    plot([RCZx(k),RFZx(k)], [RCZy(k), RFZy(k)], 'b-o');

    plot(RFZx, RFZy, 'k');
    
    text(.01, .01, 'Z', 'fontsize', 16);
    text(RAZx(k)*1.1, RAZy(k)*1.1, 'A', 'fontsize', 16);
    text(RBZx(k)*1.1, RBZy(k)*1.1, 'B', 'fontsize', 16);
    text(RCZx(k)*1.1, RCZy(k)*1.1, 'C', 'fontsize', 16);
    text(RDZx(k)*1.1, RDZy(k)*1.1, 'D', 'fontsize', 16);
    text(REZx(k)*1.1, REZy(k)*1.1, 'E', 'fontsize', 16);
    text(RFZx(k)*1.1, RFZy(k)*1.1, 'F', 'fontsize', 16);
    text(RYZx(k)*1.1, RYZy(k)*1.1, 'Y', 'fontsize', 16);
    
    axis image;
    axis([-1 1 -1 1]);
    
    drawnow();
    grid on;
end

% plot pva data
figure(2); gcf; clf;
subplot(2,2,1);
plot(RFZx, RFZy, 'k', 'linewidth', 2);
grid on;
set(gca, 'fontsize', 16);

subplot(2,2,2);
plot(t, RFZx, 'k:', 'linewidth', 2);
hold on;
plot(t, RFZy, 'k--', 'linewidth', 2);
legend('x', 'y');
grid on;
set(gca, 'fontsize', 16);
xlabel('time(s)');
ylabel('position of F (m)');

subplot(2,2,3);
plot(t, VFZx, 'k:', 'linewidth', 2);
hold on;
plot(t, VFZy, 'k--', 'linewidth', 2);
legend('x', 'y');
grid on;
set(gca, 'fontsize', 16);
xlabel('time(s)');
ylabel('velocity of F (m/s)');

subplot(2,2,4);
plot(t, AFZx, 'k:', 'linewidth', 2);
hold on;
plot(t, AFZy, 'k--', 'linewidth', 2);
legend('x', 'y');
grid on;
set(gca, 'fontsize', 16);
xlabel('time(s)');
ylabel('acceeleration of F (m/s^2)');


% torque analysis using virtual work
% mass of each link
dpl=lnk_rho*lnk_thickness*lnk_width; % density per length


mZA=dpl*rZA;
mAB=dpl*rAB;
mBY=dpl*rBY;
mYC=dpl*rYC;
mBD=dpl*rBD;
mCE=dpl*rCE;
mDE=dpl*rDE;
mEF=dpl*rEF;
mCF=dpl*rCF;

% moment of inertia of each link
iZA=mZA*(rZA^2+lnk_width^2)/12; 
iAB=mAB*(rAB^2+lnk_width^2)/12;
iBY=mBY*(rBY^2+lnk_width^2)/12;
iYC=mYC*(rYC^2+lnk_width^2)/12;
iBD=mBD*(rBD^2+lnk_width^2)/12;
iCE=mCE*(rCE^2+lnk_width^2)/12;
iDE=mDE*(rDE^2+lnk_width^2)/12;
iEF=mEF*(rEF^2+lnk_width^2)/12;
iCF=mCF*(rCF^2+lnk_width^2)/12;

% velocities and accelerations of center of gravity of each link
rAZ=rZA;
[VcAZx, VcAZy]=omega2vel(tAZ, rAZ/2, wAZ, 0);
[AcAZx, AcAZy]=alpha2acc(tAZ,rAZ/2, wAZ, 0, aAZ, 0);

VcBAx = VBAx/2 + VAZx;
VcBAy = VBAy/2 + VAZy;

AcBAx = ABAx/2 + AAZx;
AcBAy = ABAy/2 + AAZy;

[VcBYx, VcBYy]=omega2vel(tBY, rBY/2, wBY, 0);
[AcBYx, AcBYy]=alpha2acc(tBY, rBY/2,  wBY, 0, aBY, 0);

VcDBx = VDBx/2+ VBAx + VAZx;
VcDBy = VDBy/2+ VBAy + VAZy;

AcDBx = ADBx/2+ ABAx + AAZx;
AcDBy = ADBy/2+ ABAy + AAZy;

[VcDYx, VcDYy] = omega2vel(tDY, rDY/2, wDY, 0);
[AcDYx, AcDYy] = alpha2acc(tDY, rDY/2, wDY, 0, aDY, 0);




tCF=tFC+pi;
wCF=wFC;
aCF=aFC;
[VCFx, VCFy]=omega2vel(tCF, rCF, wCF, 0);
[ACFx, ACFy]=alpha2acc(tCF, rCF, wCF, 0, aCF, 0);

VcFCx = -VCFx/2 + 2*VBAx + VAZx;
VcFCy = -VCFy/2 + 2*VBAy + VAZy;

AcFCx = -ACFx/2 + 2*ABAx + AAZx;
AcFCy = -ACFy/2 + 2*ABAy + AAZy;


% terms of the final equation without the signs (10.28 in book)

% external forces
if size(FF,2)==1 % if FG is not a profile e.g. foot hitting the ground
   FF=FF*ones(1,numel(t));
end
t1=dot(FF, [VFZx; VFZy]); 
% inertial forces
t3= mZA*dot([AcAZx; AcAZy], [VcAZx; VcAZy]) + ...
    mAB*dot([AcBAx; AcBAy], [VcBAx; VcBAy]) + ...
    mBD*dot([AcDBx; AcDBy], [VcDBx; VcDBy]) + ...
    mDY*dot([AcDYx; AcDYy], [VcDYx; VcDYy]) + ...    
    mDE*dot([AcDEx; AcDEy], [VcDEx; VcDEy]) + ...
    mEF*dot([AcEFx; AcEFy], [VcEFx; VcEFy]) + ...
    mCE*dot([AcCEx; AcCEy], [VcCEx; VcCEy]) + ...
    mYC*dot([AcYCx; AcYCy], [VcYCx; VcYCy]) + ...
    mCA*dot([AcCAx; AcCAy], [VcCAx; VcCAy]) + ...
    mBY*dot([AcBYx; AcBYy], [VcBYx; VcBYy]) + ...
    mFC*dot([AcFCx; AcFCy], [VcFCx; VcFCy]);

% inertial torques
t4= iZA*aAZ.*wAZ + ...
    iAB*aBA.*wBA + ...
    iBD*aBD.*wBD + ...
    iDY*aDY.*wDY + ...
    iDE*aDE.*wDE + ...
    iEF*aEF.*wEF + ...
    iCE*aCE.*wCE + ...
    iYC*aYC.*wYC + ...
    iCA*aCA.*wCA + ...
    iBY*aBY.*wBY + ...
    iFC*aCF.*wCF;


T_motor=1/wAZ*(t3+t4-t1);

figure(3); gcf; clf;
plot(t, T_motor, 'k', 'linewidth', 2);
grid on;
set(gca, 'fontsize', 16);
xlabel('time(s)');
ylabel('required motor torque (Nm)');
