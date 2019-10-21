addpath ../core
% complex linkage analysis for analyzing complex 1 dof linkages that consist of
% multiple fourbars 

% how to use this script
% 1) synthesize your linkage
% 
% 2) draw vectors corresponding to the kinematic links with joints marked
% using upper case letters. 
%
% 3) denote the vectors using the convention that R_AB is a vector
% pointing from joint B to joint A; make sure that you draw the angle that
% you will be measuring
%
% 4) write the vector loop equations for successive fourbar loops following
% the convention as R_crank + R_coupler - R_rocker - R_ground = 0
%
% 5) add additional constraints so that each vector loop has two unknowns
% only. e.g. if R_crank is not know for the second vector loop then see if
% it relates to the orientation of an existing link
%

clear variables;

% ** link lengths use lower case letters here as these are scalars.
% make sure to specify all link lengths
% az=za=10; but tAZ is the orientation of vector AZ and is not the same as 
% tZA. To relate the two, you must use a constraint, for e.g., tAZ=tZA+pi; 
ll.az=10; ll.ab=40; ll.bd=40; ll.de=40; ll.ef=40;
ll.by=40; ll.ye=40; ll.yz=54;

% ** units (cm, mm)
units='mm';

% ** angular speed of the crank or input link
wAZ=2; % rad/s
aAZ=0;
% multiply by the number of cycles you want to see e.g. here we run for 2
% cycles of the crank
simTime=2*(2*pi/wAZ); 

% ** point of interest
poi='F';

% linspace linearly spaces the time into 100 equal sections
t=linspace(0,simTime, 100);
tAZ=wAZ*t; % theta_2

% ** angle of the ground link, if you have more than one ground then add
% another line similar to the one here
tYZ=pi/4*ones(1,numel(t));

% note that the fourbar_* functions solve the linkage according to fourbar.png

% ** (1) R_AZ + R_BA - R_BY - R_YZ = 0
[aBA, ~, aBY, ~, wBA, ~, wBY, ~, tBA, ~, tBY]=fourbar_acceleration(ll.az, ll.ab, ll.by, ll.yz, aAZ, wAZ, tAZ, 0, 0, tYZ);
tYB=tBY+pi;
tDB=tBA;
wYB=wBY;
wDB=wBA;
aYB=aBY;
aDB=aBA;

% ** (2) 
[aED, ~, aEY, ~, wED, ~, wEY, ~, tED,~, tEY]=fourbar_acceleration(ll.bd, ll.de,ll.ye,  ll.by, aDB, wDB, tDB, aYB, wYB, tYB);
tFE=tED;
wFE=wED;
aFE=aED;

% ** extract positions of all points use capital letters since these are
% vectors
% ** modify this according to the number of joints you have
% make sure to put a 'p.' in front of every joint position
p.Z=[   zeros(1,numel(t)); 
        zeros(1,numel(t))];
    
p.Y=[   ll.yz*cos(tYZ); 
        ll.yz*sin(tYZ)];
    
p.A=[   ll.az*cos(tAZ); 
        ll.az*sin(tAZ);];
    
p.B=p.A + [ ll.ab*cos(tBA); 
            ll.ab*sin(tBA)];
        
p.D=p.B + [ ll.bd*cos(tDB); 
            ll.bd*sin(tDB)];
        
p.E=p.D + [ ll.de*cos(tED); 
            ll.de*sin(tED)];
        
p.F=p.E + [ ll.ef*cos(tFE); 
            ll.ef*sin(tFE)];

% ** extract velocities of the point of interest
% note the convention, if you don't understand .* operation, simply copy
% and replace the lengths and omega values in the two lines below
fdotx=-ll.ef*wFE.*sin(tFE) - ll.ye*wEY.*sin(tEY);
fdoty=ll.ef*wFE.*cos(tFE) + ll.ye*wEY.*cos(tEY);

% ** extract accelerations of the point of interest
% note the convention, if you don't understand .* operation, simply copy
% and replace the lengths and omega values in the two lines below
fddx=-ll.ef*aFE.*sin(tFE) -ll.ef*wFE.^2.*cos(tFE) - ll.ye*aEY.*sin(tEY) - ll.ye*wEY.^2.*cos(tEY);
fddy=ll.ef*aFE.*cos(tFE) -ll.ef*wFE.^2.*sin(tFE) + ll.ye*aEY.*cos(tEY) - ll.ye*wEY.^2.*sin(tEY);

% animate
for ii=1:numel(t)
    figure(1); gcf; clf;
    plot_linkage(p,ll, ii);
    drawnow;
end

figure(1); gcf; clf; % new figure window for plot
ii=1;
subplot(2,3,1);
plot_linkage(p, ll, ii);

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
end