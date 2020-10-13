function example15_pantograph_with_hoeken(rAZ, rBA, rBY, rYZ, tYZ, rCB, ...
            rXZ, tXZ, rDX, rED, rFE, rCD, rFC, rGF, wAZ, aAZ, t)
%
% SB, NIU, 2019

addpath ../core


if nargin < 1
    rAZ=10;
    rBA=25;
    rBY=25;
    rYZ=20;
    tYZ=0; % rad
    rCB=25;
    rXZ=97;
    tXZ=pi/3; % rad
    rDX=40;
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
[VBAx, VBAy]=omega2vel(rBA, tBA, 0, wBA);
[ABAx, ABAy]=alpha2acc(rBA, tBA, 0, wBA, 0, aBA);


[RAZx, RAZy]=pol2cart(tAZ, rAZ);
[VAZx, VAZy]=omega2vel(tAZ,rAZ, wAZ,0);
[AAZx, AAZy]=alpha2acc(tAZ,rAZ, wAZ, 0, aAZ, 0);

[RXZx, RXZy]=pol2cart(tXZ, rXZ);
[VXZx, VXZy]=omega2vel(tXZ, rXZ, 0, 0);
[AXZx, AXZy]=alpha2acc(tAZ, rAZ, 0, 0, 0, 0);

RBZx=RBAx+RAZx;
RBZy=RBAy+RAZy;


RCZx=2*RBAx+RAZx;
RCZy=2*RBAy+RAZy;

VCZx = 2*VBAx + VAZx;
VCZy = 2*VBAy + VAZy;

ACZx = 2*ABAx + AAZx;
ACZy = 2*ABAy + AAZy;


RCXx=RCZx - RXZx;
RCXy=RCZy - RXZy;


VCXx=VCZx - VXZx;
VCXy=VCZy - VXZy;

ACXx=ACZx - AXZx;
ACXy=ACZy - AXZy;


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

RGZx=2*RFEx+REXx + RXZx;
RGZy=2*RFEy+REXy + RXZy;

REZx = REXx - RDXx + RDZx;
REZy = REXy - RDXy + RDZy;

RFZx = RFEx + REZx;
RFZy = RFEy + REZy;

RYZx = rYZ*cos(tYZ)*ones(1, numel(t));
RYZy = rYZ*sin(tYZ)*ones(1, numel(t));

RXZx = RXZx*ones(1, numel(t));
RXZy = RXZy*ones(1, numel(t));


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


    plot([RBZx(k),RAZx(k)], [RBZy(k), RAZy(k)], 'r-o');
    plot([RBZx(k),RYZx(k)], [RBZy(k), RYZy(k)], 'r-o');
    plot([RCZx(k),RAZx(k)], [RCZy(k), RAZy(k)], 'r-o');
    plot([RCZx(k),RDZx(k)], [RCZy(k), RDZy(k)], 'r-o');
    plot([RFZx(k),REZx(k)], [RFZy(k), REZy(k)], 'r-o');
    plot([RCZx(k),RFZx(k)], [RCZy(k), RFZy(k)], 'r-o');
    plot([RGZx(k),RFZx(k)], [RGZy(k), RFZy(k)], 'r-o');
    plot([RDZx(k),RXZx(k)], [RDZy(k), RXZy(k)], 'r-o');
    plot([REZx(k),RDZx(k)], [REZy(k), RDZy(k)], 'r-o');
    plot(RCZx, RCZy, 'k-.');
    plot(RGZx, RGZy, 'k');
    grid on;
end


% axis([-50 100, 0 150]);
