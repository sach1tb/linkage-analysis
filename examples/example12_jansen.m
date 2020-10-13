function example12_jansen(za, wAZ, ab, by, zy, thetaYZ, ac, yc, yd, bd, ce, de, ef, cf)

addpath ../core

% ** link lengths use lower case letters here as these are scalars.
% make sure to specify all link lengths
% az=za=10; but thetaAZ is the orientation of vector AZ and is not the same as 
% tZA. To relate the two, you must use a constraint, for e.g., thetaAZ=tZA+pi; 
if nargin < 1
    za=15; ab=50; by=41.5; zy=sqrt(38^2+7.8^2);
    ac=61.9; yc=39.3; yd=40.1; bd=55.8; 
    ce=36.7; de=39.4; ef=65.7; cf=49;
    wAZ=2; % rad/s
    % ** angle between the ground links
    thetaYZ=190*pi/180;
end

lnk.za=za; lnk.ab=ab; lnk.by=by; lnk.zy=zy;
lnk.ac=ac; lnk.yc=yc; lnk.yd=yd; lnk.bd=bd; 
lnk.ce=ce; lnk.de=de; lnk.ef=ef; lnk.cf=cf;

% ** units (cm, mm)
units='mm';

% ** angular speed of the crank or input link

aAZ=0;
% multiply by the number of cycles you want to see e.g. here we run for 2
% cycles of the crank
simTime=2*(2*pi/wAZ); 

% ** point of interest
poi='F';

% linspace linearly spaces the time into 100 equal sections
t=linspace(0,simTime, 100);
thetaAZ=wAZ*t; % theta_2

thetaYZ=thetaYZ*ones(1,numel(t));

% note that the fourbar_* functions solve the linkage according to fourbar.png

% ** (1) RAZ + RBA - RBY - RZY = 0
[~, alphaBA, ~, alphaBY, ~, omegaBA, ~, omegaBY, ~, thetaBA, ~, thetaBY]= ...
    fourbar_acceleration(lnk.za, lnk.ab, lnk.by, lnk.zy, aAZ, wAZ, thetaAZ, 0, 0, thetaYZ);
% the above is cross configuration, if you have open configuration then
% simply remove the first ~  as below
% [alphaBA, ~, alphaBY, ~, omegaBA, ~, omegaBY, ~, thetaBA, ~, thetaBY]=...
% fourbar_acceleration(lnk.az, lnk.ab, lnk.by, lnk.zy, aAZ, wAZ, thetaAZ, 0, 0, thetaYZ);

% ** (2) RAZ + RCA - RCY - RYZ = 0
[alphaCA, ~, alphaCY, ~, omegaCA, ~, omegaCY, ~, thetaCA,~, thetaCY]= ...
    fourbar_acceleration(lnk.za, lnk.ac,lnk.yc,  lnk.zy, aAZ, wAZ, thetaAZ, 0, 0, thetaYZ);

% ** (3) RBY + RDB - RDY - RYY = 0
[~, alphaDB, ~, alphaDY, ~, omegaDB, ~, omegaDY, ~, thetaDB,~, thetaDY]=...
    fourbar_acceleration(lnk.by, lnk.bd,lnk.yd,  0, alphaBY, omegaBY, thetaBY, 0, 0, 0);

% ** (4) RCY + REC - RED - RDY = 0
[alphaEC, ~, alphaED, ~, omegaEC, ~, omegaED, ~, thetaEC,~, thetaED]=...
    fourbar_acceleration(lnk.yc, lnk.ce, lnk.de,  lnk.yd, alphaCY, omegaCY, thetaCY, 0, 0, thetaDY);

% ** (5) REC + RFE - RFC - RCC= 0 
[~, alphaFE, ~, alphaFC, ~, omegaFE, ~, omegaFC, ~, thetaFE,~, thetaFC]=...
    fourbar_acceleration(lnk.ce, lnk.ef, lnk.cf,  0, alphaEC, omegaEC, thetaEC, 0, 0, 0);


% ** extract positions of all points use capital letters since these are
% vectors
% ** modify this according to the number of joints you have
% make sure to put a 'p.' in front of every joint position
p.Z=[   zeros(1,numel(t)); 
        zeros(1,numel(t))];
    
p.Y=[   lnk.zy*cos(thetaYZ); 
        lnk.zy*sin(thetaYZ)];
    
p.A=[   lnk.za*cos(thetaAZ); 
        lnk.za*sin(thetaAZ);];
    
p.B=p.A + [ lnk.ab*cos(thetaBA); 
            lnk.ab*sin(thetaBA)];
        
p.C=p.A + [ lnk.ac*cos(thetaCA); 
            lnk.ac*sin(thetaCA)];        
        
p.D=p.B + [ lnk.bd*cos(thetaDB); 
            lnk.bd*sin(thetaDB)];
        
p.E=p.D + [ lnk.de*cos(thetaED); 
            lnk.de*sin(thetaED)];
        
p.F=p.E + [ lnk.ef*cos(thetaFE); 
            lnk.ef*sin(thetaFE)];

% ** extract velocities of the point of interest
% note the convention, if you don't understand .* operation, simply copy
% and replace the lengths and omega values in the two lines below
fdotx=-lnk.ef*omegaFE.*sin(thetaFE) - lnk.de*omegaED.*sin(thetaED) - lnk.yd*omegaDY.*sin(thetaDY);
fdoty=lnk.ef*omegaFE.*cos(thetaFE) + lnk.de*omegaED.*cos(thetaED) + lnk.yd*omegaDY.*cos(thetaDY) ;

% ** extract accelerations of the point of interest
% note the convention, if you don't understand .* operation, simply copy
% and replace the lengths and omega values in the two lines below
fddx=-lnk.ef*alphaFE.*sin(thetaFE) -lnk.ef*omegaFE.^2.*cos(thetaFE) ...
    - lnk.de*alphaED.*sin(thetaED) - lnk.de*omegaED.^2.*cos(thetaED) ...
    - lnk.yd*alphaDY.*sin(thetaDY) - lnk.yd*omegaDY.^2.*cos(thetaDY);

fddy=lnk.ef*alphaFE.*cos(thetaFE) -lnk.ef*omegaFE.^2.*sin(thetaFE) ...
    + lnk.de*alphaED.*cos(thetaED) - lnk.de*omegaED.^2.*sin(thetaED) ...
    + lnk.yd*alphaDY.*cos(thetaDY) - lnk.yd*omegaDY.^2.*sin(thetaDY);

% animate


figure(1); gcf; clf; % new figure window for plot

for ii=1:numel(t)
    subplot(2,3,1); cla;
    plot_linkage(p,lnk, ii);
    drawnow;
end

fs=16;
subplot(2,3,2);
% plot the foot or end point trace here
xy=eval(['p.', poi]);
plot (xy(1,:), xy(2,:), 'linewidth', 2); 
set(gca, 'fontsize', fs, 'fontname', 'times');
axis image;
grid on;
title('foot path');

subplot(2,3,4);
% plot the foot or end point trace here
xy=eval(['p.', poi]);
plot(t, xy(1,:), 'linewidth', 2);
hold on;
plot(t, xy(2,:), 'linewidth', 2);
grid on;
set(gca, 'fontsize', fs, 'fontname', 'times');
xlabel('time (s)');
legend(['x (' , units, ')'], ['y (' , units, ')']);

subplot(2,3,5);
% plot the foot or end point trace here
plot(t, sqrt(fdotx.^2+fdoty.^2), 'linewidth', 2);
grid on;
ytickformat('%.3f')
set(gca, 'fontsize', fs, 'fontname', 'times');
xlabel('time (s)');
ylabel(['speed (', units , '/s)']);

subplot(2,3,6);
% plot the foot or end point trace here
plot(t, sqrt(fddx.^2+fddy.^2), 'linewidth', 2);
grid on;
ytickformat('%.3f')
set(gca, 'fontsize', fs, 'fontname', 'times');
xlabel('time (s)');
ylabel(['acceleration (', units, '/s^2)']);


function plot_linkage(p, ll, ii)

ff=fieldnames(p);
lnks=upper(fieldnames(ll));

% plot all points
for jj=1:numel(ff)
    xyjj=eval(['p.', ff{jj}, '(:,', sprintf('%d', ii), ')']);
    plot(xyjj(1), xyjj(2), 'o');
    hold on;
    for kk=jj+1:numel(ff) 
        % connect points using lines based on if their link length is
        % specified
        if ismember([ff{kk}, ff{jj}], lnks) || ismember([ff{jj}, ff{kk}], lnks)
            xykk=eval(['p.', ff{kk}, '(:,', sprintf('%d', ii), ')']);
            plot([xyjj(1), xykk(1)], [xyjj(2), xykk(2)], '-.');
        end
    end
    text(xyjj(1)*1.1, xyjj(2)*1.1, ff{jj}, 'fontsize', 16);
end

axis image;
axis([-100 100 -100 100]);
axis off;
