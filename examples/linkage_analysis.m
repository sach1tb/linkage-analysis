function linkage_analysis
% linkage_analysis performs motion analysis of complex linkages
% according to the procedure described in doc/linkage_analysis.pdf
% at this time, linkage analysis cannot solve fivebars so if you have a
% mechanism that has a five bars where two links are driven, e.g. Klann linkage
% this script will not work
% 
% How to use this script
%
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
% 5) copy the vector loop equations in the prescribed format to the place
% in this script which says VECTOR LOOP EQUATIONS
%
% SB, NIU, 2019

addpath ../core

% ** angular speed of the crank or input link
omegaAZ=2; % rad/s
alphaAZ=0;
simTime=2*(2*pi/omegaAZ); % seconds 
t=linspace(0,simTime, 100);

thetaAZ=omegaAZ*t+0.5*alphaAZ*t.^2; % theta_2

% ** create links here
% the arguments are: 
% links.AB implies a vector pointing from joint B to joint A
% length, theta, omega, alpha, mass, moment of inertia, torque, force x and y,
% distance of the application of force from the joint B 
% FIRST LINK IS ALWAYS CRANK
links.AZ=link(15, thetaAZ, omegaAZ, alphaAZ, 10, 10, 0, [0,0], 0); % crank
links.BA=link(50, 0, 0, 0, 10, 10, 0, [0,0], 0);
links.BY=link(41.5, 0, 0, 0, 10, 10, 0, [0,0], 0);
links.YZ=link(sqrt(38^2+7.8^2), 190*pi/180, 0, 0, 10, 10, 0, [0,0], 0);
links.AC=link(61.9, 0, 0, 0, 10, 10, 0, [0,0], 0);
links.YC=link(39.3, 0, 0, 0, 10, 10, 0, [0,0], 0);
links.YD=link(40.1, 0, 0, 0, 10, 10, 0, [0,0], 0);
links.BD=link(55.8, 0, 0, 0, 10, 10, 0, [0,0], 0);
links.CE=link(36.7, 0, 0, 0, 10, 10, 0, [0,0], 0);
links.DE=link(39.4, 0, 0, 0, 10, 10, 0, [0,0], 0);
links.EF=link(65.7, 0, 0, 0, 10, 10, 0, [0,0], 0);
links.CF=link(49.0, 0, 0, 0, 10, 10, 0, [0,0], 0);

% update links
links=add_links(links);


% ** link chains are successive positions on your linkage starting with
% (0,0) global ground that is always specified as a single letter. Write
% valid chains until all positions are covered
% a correct way is {'Z', 'ZY', 'ZA', 'ZAC'}
% incorrect way is {'Z', 'Y', 'AC'}
link_chains={'Z', 'ZY', 'ZA', 'ZAC', 'ZACF', 'YB', 'YBD', 'YDE'}; 

% ** units (kg-m-s, gm-cm-s)
units='gm-cm-s';


% ** point of interest
poi='F';


% VECTOR LOOP EQUATIONS
% ** note that the vecloop equation MUST be in one of these forms with spaces in
% between each position vector, upper case letters and the same exact
% signs. Modify your vectors so that these are satisfied
%
% RAZ + RBA - RBY - RZY = 0
% RAB + RBA = 0 % when the vectors are opposite to each other
% RAZ - RBA = 0 % when links are extended in the same direction
% for angled links simply use the fourbar loop as if for a ternary link.
 
% (1) RAZ + RBA - RBY - RZY = 0
% the second argument is 1 for open configuration and 2 for cross
links=solve_vecloop('RAZ + RBA - RBY - RYZ = 0', 2, links);

% ** (2) RAZ + RCA - RCY - RYZ = 0
links=solve_vecloop('RAZ + RCA - RCY - RYZ = 0', 1, links);

% ** (3) RBY + RDB - RDY - RYY = 0
links=solve_vecloop('RBY + RDB - RDY - RYY = 0', 2, links);

% ** (4) RCY + REC - RED - RDY = 0
links=solve_vecloop('RCY + REC - RED - RDY = 0', 1, links);

% ** (5) REC + RFE - RFC - RCC= 0 
links=solve_vecloop('REC + RFE - RFC - RCC = 0', 2, links);


% ** if you want to save the data for later analysis
% save('./mylinkage.mat', 'links');

% --------- NO change beyond this point ---------------------------
% extract positions, velocities, and accelerations of all joint positions
pos = extract_positions(links, link_chains, t);
vel = extract_velocities(links, link_chains, t);
acc = extract_accelerations(links, link_chains,t);


% extract positions, velocities, and accelerations of CG of all links
cgpos = extract_positions_link(links, link_chains, t, pos);
cgvel = extract_velocities_link(links, link_chains, t, vel);
cgacc = extract_accelerations_link(links, link_chains,t, acc);


% extract positions, velocities, and accelerations of force application 
% points of all links
rfpos = extract_positions_rF(links, link_chains, t, pos);
rfvel = extract_velocities_rF(links, link_chains, t, vel);
rfacc = extract_accelerations_rF(links, link_chains,t, acc);

input_torque=calculate_input_torque(links, cgpos, cgvel, cgacc, ...
    rfpos, rfvel, rfacc, t);

% animatecomment if you don't want to see this
for ii=1:numel(t)
    figure(1); gcf; clf;
    plot_linkage(pos,links, ii);
    drawnow;
end

unitsarr=strsplit(units, '-');

figure(1); gcf; clf; % new figure window for plot
ii=1;
subplot(2,3,1);
plot_linkage(pos, links, ii);

fs=16;
subplot(2,3,2);
% plot the foot or end point trace here
xy=eval(['pos.', poi]);
plot (xy(1,:), xy(2,:), 'linewidth', 2); 
set(gca, 'fontsize', fs, 'fontname', 'times');
axis image;
grid on;
title('foot path');

subplot(2,3,3);
% plot the foot or end point trace here
xy=eval(['pos.', poi]);
plot(t, xy(1,:), 'linewidth', 2);
hold on;
plot(t, xy(2,:), 'linewidth', 2);
grid on;
set(gca, 'fontsize', fs, 'fontname', 'times');
xlabel('time (s)');
legend(['x (' , unitsarr{2}, ')'], ['y (' , unitsarr{2}, ')']);

subplot(2,3,4);
% plot the foot or end point trace here
xdot=eval(['vel.', poi]);
plot(t, sqrt(xdot(1,:).^2+xdot(2,:).^2), 'linewidth', 2);
grid on;
ytickformat('%.3f')
set(gca, 'fontsize', fs, 'fontname', 'times');
xlabel('time (s)');
ylabel(['speed (', unitsarr{2} , '/', unitsarr{3}, ')']);

subplot(2,3,5);
% plot the foot or end point trace here
xddot=eval(['acc.', poi]);
plot(t, sqrt(xddot(1,:).^2+xddot(2,:).^2), 'linewidth', 2);
grid on;
ytickformat('%.3f')
set(gca, 'fontsize', fs, 'fontname', 'times');
xlabel('time (s)');
ylabel(['acceleration (', unitsarr{2}, '/', unitsarr{3}, '^2)']);


subplot(2,3,6);
% plot the input torque
plot(t, input_torque, 'linewidth', 2);
grid on;
ytickformat('%.2f')
set(gca, 'fontsize', fs, 'fontname', 'times');
xlabel('time (s)');
ylabel(['input torque (', unitsarr{1}, ' ', unitsarr{2}, '^2/', unitsarr{3}, '^2)']);


% keep updating the link positions
% links=update_links(links);

function links=update_links(links)
% this function updates the link angles every time an analysis is performed 
ff=fieldnames(links);
for ii=1:numel(ff)
    eval(['links.', ff{ii}(2:-1:1), '.theta=links.', ff{ii}, '.theta+pi;']);
end

function pos=extract_positions(links, link_chains, t)

eval(['pos.', link_chains{1}, '=[zeros(1,numel(t)); zeros(1,numel(t))];']);

for ii=2:numel(link_chains)
    for jj=2:numel(link_chains{ii})
        if ~isfield(pos, link_chains{ii}(jj-1))
            error('link chains must be written so that a position that is needed in a later chain is requested earlier, see example above');
        end
        eval(['ll=links.', link_chains{ii}(jj), link_chains{ii}(jj-1), '.length;']);
        eval(['th=links.', link_chains{ii}(jj), link_chains{ii}(jj-1), '.theta;']);
        eval(['pos.', link_chains{ii}(jj), '=pos.' link_chains{ii}(jj-1), '+[ll*cos(th); ll*sin(th)];']);
    end
end


function vel=extract_velocities(links, link_chains, t)

eval(['vel.', link_chains{1}, '=[zeros(1,numel(t)); zeros(1,numel(t))];']);

for ii=2:numel(link_chains)
    for jj=2:numel(link_chains{ii})
        if ~isfield(vel, link_chains{ii}(jj-1))
            error('link chains must be written so that a position that is needed in a later chain is requested earlier, see example above');
        end
        eval(['ll=links.', link_chains{ii}(jj), link_chains{ii}(jj-1), '.length;']);
        eval(['th=links.', link_chains{ii}(jj), link_chains{ii}(jj-1), '.theta;']);
        eval(['om=links.', link_chains{ii}(jj), link_chains{ii}(jj-1), '.omega;']);
        eval(['vel.', link_chains{ii}(jj), '=vel.' link_chains{ii}(jj-1), '+[-ll*om.*sin(th); ll*om.*cos(th)];']);
    end
end


function acc=extract_accelerations(links, link_chains, t)

eval(['acc.', link_chains{1}, '=[zeros(1,numel(t)); zeros(1,numel(t))];']);

for ii=2:numel(link_chains)
    for jj=2:numel(link_chains{ii})
        if ~isfield(acc, link_chains{ii}(jj-1))
            error('link chains must be written so that a position that is needed in a later chain is requested earlier, see example above');
        end
        eval(['ll=links.', link_chains{ii}(jj), link_chains{ii}(jj-1), '.length;']);
        eval(['th=links.', link_chains{ii}(jj), link_chains{ii}(jj-1), '.theta;']);
        eval(['om=links.', link_chains{ii}(jj), link_chains{ii}(jj-1), '.omega;']);
        eval(['al=links.', link_chains{ii}(jj), link_chains{ii}(jj-1), '.alpha;']);
        eval(['acc.', link_chains{ii}(jj), '=acc.' link_chains{ii}(jj-1), '+[-ll*al.*sin(th) - ll*om.^2.*cos(th); ll*al.*cos(th) - ll*om.^2.*sin(th)];']);
    end
end


function cgpos=extract_positions_link(links, link_chains, t, pos)

ff=fieldnames(links);

for ii=1:numel(ff)
    % assume cg is always at center of the link
    eval(['ll=links.', ff{ii}, '.length/2;']);
    eval(['th=links.', ff{ii}, '.theta;']);
    eval(['cgpos.', ff{ii}, '=pos.' ff{ii}(2), '+[ll*cos(th); ll*sin(th)];']);
end


function cgvel=extract_velocities_link(links, link_chains, t, vel)

ff=fieldnames(links);

for ii=1:numel(ff)
    % assume cg is always at center of the link
    eval(['ll=links.', ff{ii}, '.length/2;']);
    eval(['th=links.', ff{ii}, '.theta;']);
    eval(['om=links.', ff{ii}, '.omega;']);
    eval(['cgvel.', ff{ii}, '=vel.' ff{ii}(2), '+[-ll*om.*sin(th); ll*om.*cos(th)];']);
end


function cgacc=extract_accelerations_link(links, link_chains, t, acc)

ff=fieldnames(links);

for ii=1:numel(ff)
    % assume cg is always at center of the link
    eval(['ll=links.', ff{ii}, '.length/2;']);
    eval(['th=links.', ff{ii}, '.theta;']);
    eval(['om=links.', ff{ii}, '.omega;']);
    eval(['al=links.', ff{ii}, '.alpha;']);
    eval(['cgacc.', ff{ii}, '=acc.' ff{ii}(2), '+[-ll*al.*sin(th) - ll*om.^2.*cos(th); ll*al.*cos(th) - ll*om.^2.*sin(th)];']);
end


function rfpos=extract_positions_rF(links, link_chains, t, pos)

ff=fieldnames(links);

for ii=1:numel(ff)
    % assume cg is always at center of the link
    eval(['ll=links.', ff{ii}, '.rF;']);
    eval(['th=links.', ff{ii}, '.theta;']);
    eval(['rfpos.', ff{ii}, '=pos.' ff{ii}(2), '+[ll*cos(th); ll*sin(th)];']);
end


function rfvel=extract_velocities_rF(links, link_chains, t, vel)

ff=fieldnames(links);

for ii=1:numel(ff)
    % assume cg is always at center of the link
    eval(['ll=links.', ff{ii}, '.rF;']);
    eval(['th=links.', ff{ii}, '.theta;']);
    eval(['om=links.', ff{ii}, '.omega;']);
    eval(['rfvel.', ff{ii}, '=vel.' ff{ii}(2), '+[-ll*om.*sin(th); ll*om.*cos(th)];']);
end


function rfacc=extract_accelerations_rF(links, link_chains, t, acc)

ff=fieldnames(links);

for ii=1:numel(ff)
    % assume cg is always at center of the link
    eval(['ll=links.', ff{ii}, '.rF;']);
    eval(['th=links.', ff{ii}, '.theta;']);
    eval(['om=links.', ff{ii}, '.omega;']);
    eval(['al=links.', ff{ii}, '.alpha;']);
    eval(['rfacc.', ff{ii}, '=acc.' ff{ii}(2), '+[-ll*al.*sin(th) - ll*om.^2.*cos(th); ll*al.*cos(th) - ll*om.^2.*sin(th)];']);
end



function input_torque=calculate_input_torque(links, cgpos, cgvel, cgacc, rfpos, rfvel, rfacc, t)
ff=fieldnames(links);
% external forces
ext=zeros(1,numel(t));
for ii=1:numel(ff)
    try
    ext=dot(eval(['links.', ff{ii}, '.force'])'*ones(1,numel(t)), eval(['rfvel.', ff{ii}]))+ ext;
    catch
        keyboard
    end
end 
% inertial forces
inertf=zeros(1,numel(t));
for ii=1:numel(ff)
    inertf=eval(['links.', ff{ii}, '.mass'])* ...
        dot(eval(['cgacc.', ff{ii}]), eval(['cgvel.', ff{ii}]))+ inertf;
end

% inertial torques
inertt=zeros(1,numel(t));
for ii=1:numel(ff)
    inertt=eval(['links.', ff{ii}, '.moi'])* ...
        dot(eval(['links.', ff{ii}, '.alpha']), eval(['links.', ff{ii}, '.omega']))+ inertt;
end

input_torque=1/eval(['links.', ff{1}, '.omega'])*(inertt+inertf-ext);