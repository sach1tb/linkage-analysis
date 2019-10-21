function example15
% linkage_analysis performs motion analysis of complex linkages
% according to the procedure described in jansen_linkage.pdf
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


% the line below adds the core scripts to the current working directory
addpath ../core

% ** link lengths use lower case letters here as these are scalars.
% make sure to specify all link lengths
% az=za=10; but thetaAZ is the orientation of vector AZ and is not the same as 
% tZA. To relate the two, you must use a constraint, for e.g., thetaAZ=tZA+pi; 
% length, theta, omega, alpha, mass, moi, torque, force, rF)
% linspace linearly spaces the time into 100 equal sections

% ** angular speed of the crank or input link
omegaAZ=2; % rad/s
alphaAZ=0;
simTime=2*(2*pi/omegaAZ); % seconds 
t=linspace(0,simTime, 100);

thetaAZ=omegaAZ*t+0.5*alphaAZ*t.^2; % theta_2

% ** create links here
links.AZ=link(9.65, thetaAZ, omegaAZ, alphaAZ, 1, 1, 0, [0,0], 0);
links.DA=link(50.4, 0, 0, 0, 1, 1, 0, [0,0], 0);
links.CX=link(24.11, 0, 0, 0, 1, 1, 0, [0,0], 0);
links.DE=link(40, 0, 0, 0, 1, 1, 0, [0,0], 0);
links.EF=link(40, 0, 0, 0, 1, 1, 0, [100,0], 0.1);
links.BY=link(40, 0, 0, 0, 1, 1, 0, [0,0], 0);
links.YE=link(40, 0, 0, 0, 1, 1, 0, [0,100], 0);
links.YZ=link(54, pi/4, 0, 0, 1, 1, 0, [10,0], 10);

% update links
links=add_links(links);


% ** link chains are successive positions on your linkage starting with
% (0,0) global ground that is always specified as a single letter. Write
% valid chains until all positions are covered
% a correct way is {'Z', 'ZY', 'ZA', 'ZAC'}
% incorrect way is {'Z', 'Y', 'AC'}
link_chains={'Z', 'ZY', 'ZA', 'ZAB', 'ABD', 'ZYEF'}; 

% ** units (cm, mm)
units='mm';


% ** point of interest
poi='F';


% VECTOR LOOP EQUATIONS
% ** note that the vecloop equation MUST be in this form with spaces in
% between each position vector, upper case letters and the same exact
% signs. Modify your vectors so that these are satisfied
% the second argument is 1 for open configuration and 2 for cross
links=solve_vecloop('RAZ + RBA - RBY - RYZ = 0', 1, links);
links=solve_vecloop('RDB - RBA = 0', 1, links);
links=solve_vecloop('RYB + RBY = 0', 1, links);
links=solve_vecloop('RDB + RED - REY - RYB = 0', 1, links);
links=solve_vecloop('RFE - RED = 0', 1, links);



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

% animate ** comment if you don't want to see this
for ii=1:numel(t)
    figure(1); gcf; clf;
    plot_linkage(pos,links, ii);
    drawnow;
end

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
legend(['x (' , units, ')'], ['y (' , units, ')']);

subplot(2,3,4);
% plot the foot or end point trace here
xdot=eval(['vel.', poi]);
plot(t, sqrt(xdot(1,:).^2+xdot(2,:).^2), 'linewidth', 2);
grid on;
ytickformat('%.3f')
set(gca, 'fontsize', fs, 'fontname', 'times');
xlabel('time (s)');
ylabel(['speed (', units , '/s)']);

subplot(2,3,5);
% plot the foot or end point trace here
xddot=eval(['acc.', poi]);
plot(t, sqrt(xddot(1,:).^2+xddot(2,:).^2), 'linewidth', 2);
grid on;
ytickformat('%.3f')
set(gca, 'fontsize', fs, 'fontname', 'times');
xlabel('time (s)');
ylabel(['acceleration (', units, '/s^2)']);


subplot(2,3,6);
% plot the input torque
plot(t, input_torque, 'linewidth', 2);
grid on;
ytickformat('%.2f')
set(gca, 'fontsize', fs, 'fontname', 'times');
xlabel('time (s)');
ylabel(['input torque (N', units, ')']);

function plot_linkage(p, ll, ii)

ff=fieldnames(p);
lnks=fieldnames(ll);

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
eval(['sc=ll.',lnks{1}, '.length + ll.',lnks{2}, '.length + ll.',...
    lnks{3}, '.length + ll.',lnks{4}, '.length; ']);
axis([-sc sc -sc sc]);
axis off;

function lnk=link(length, theta, omega, alpha, mass, moi, torque, force, rF)

lnk=struct( 'length', length, 'theta', theta, 'omega', omega, ...
            'alpha', alpha, 'mass', mass, ...
            'moi', moi, 'torque', torque, 'force', force, 'rF', rF);
        
function links=add_links(links)
% this function adds the missing link position vectors 
ff=fieldnames(links);
for ii=1:numel(ff)
    eval(['links.', ff{ii}(2:-1:1), '= link(0, 0, 0, 0, 0, 0, 0, [0,0], 0);']);
    eval(['links.', ff{ii}(2:-1:1), '.length=links.', ff{ii}, '.length;']);
    eval(['links.', ff{ii}(2:-1:1), '.theta=links.', ff{ii}, '.theta+pi;']);
end


function links=solve_vecloop(vecloop, config, links)
% ** (1) RAZ + RBA - RBY - RZY = 0

cellarr=strsplit(vecloop, ' ');

% check if it is valid
for jj=1:2:numel(cellarr)-2
    if ~isfield(links, cellarr{jj}(2:3)) && cellarr{jj}(2) ~=cellarr{jj}(3)
        error('check your vector loop equation');
    end
    % when a vector like RYY, RZZ is sent for a ternary link
    if ~isfield(links, cellarr{jj}(2:3)) && cellarr{jj}(2) ==cellarr{jj}(3)
        eval(['links.', cellarr{jj}(2:3), '= link(0, 0, 0, 0, 0, 0, 0, [0,0], 0);']);
    end
end

if numel(cellarr) ==9 % fourbar loop

a=eval(['links.', cellarr{1}(2:3), '.length;']);
b=eval(['links.', cellarr{3}(2:3), '.length;']);
c=eval(['links.', cellarr{5}(2:3), '.length;']);
d=eval(['links.', cellarr{7}(2:3), '.length;']);
alpha2=eval(['links.', cellarr{1}(2:3), '.alpha;']);
omega2=eval(['links.', cellarr{1}(2:3), '.omega;']);
theta2=eval(['links.', cellarr{1}(2:3), '.theta;']);
alpha1=eval(['links.', cellarr{7}(2:3), '.alpha;']);
omega1=eval(['links.', cellarr{7}(2:3), '.omega;']);
theta1=eval(['links.', cellarr{7}(2:3), '.theta;']);

if config ==1
    [alpha3, ~, alpha4, ~, omega3, ~, omega4, ~, theta3, ~, theta4]= ...
        fourbar_acceleration(a, b, c, d, alpha2, omega2, theta2, alpha1, omega1, theta1);
elseif config==2
    [~, alpha3, ~, alpha4, ~, omega3, ~, omega4, ~, theta3, ~, theta4]= ...
        fourbar_acceleration(a, b, c, d, alpha2, omega2, theta2, alpha1, omega1, theta1);
end


eval(['links.', cellarr{3}(2:3), '.alpha=alpha3;']);

eval(['links.', cellarr{5}(2:3), '.alpha=alpha4;']);

eval(['links.', cellarr{3}(2:3), '.omega=omega3;']);

eval(['links.', cellarr{5}(2:3), '.omega=omega4;']);

eval(['links.', cellarr{3}(2:3), '.theta=theta3;']);

eval(['links.', cellarr{5}(2:3), '.theta=theta4;']);
elseif numel(cellarr) ==5
    % RAB + RBA = 0;
    if cellarr{2} == '+'
        eval(['links.', cellarr{1}(2:3), '.theta=links.', cellarr{3}(2:3), '.theta+pi;']);
        eval(['links.', cellarr{1}(2:3), '.omega=links.', cellarr{3}(2:3), '.omega;']);
        eval(['links.', cellarr{1}(2:3), '.alpha=links.', cellarr{3}(2:3), '.alpha;']);
    % RAB - RCB = 0;    
    elseif cellarr{2} == '-'
        eval(['links.', cellarr{1}(2:3), '=links.', cellarr{3}(2:3), ';']);
    end
end

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
