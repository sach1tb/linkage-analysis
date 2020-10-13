function example13_pantograph
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

clear variables;

% the line below adds the core scripts to the current working directory
addpath ../core

% ** link lengths use lower case letters here as these are scalars.
% make sure to specify all link lengths
% az=za=10; but thetaAZ is the orientation of vector AZ and is not the same as 
% tZA. To relate the two, you must use a constraint, for e.g., thetaAZ=tZA+pi; 
% length, theta, omega, alpha, mass, moi, torque, force, rF)
% linspace linearly spaces the time into 100 equal sections

% ** angular speed of the crank or input link
omegaCrank=2; % rad/s
alphaCrank=0;
simTime=2*(2*pi/omegaCrank); % seconds 
t=linspace(0,simTime, 100);

thetaCrank=omegaCrank*t+0.5*alphaCrank*t.^2; % theta_2

% ** create links here
% FIRST LINK IS ALWAYS CRANK
links.AZ=link(10, thetaCrank, omegaCrank, alphaCrank, 1, 1, 0, [0,0], 0);
links.BA=link(40, 0, 0, 0, 1, 1, 0, [0,0], 0);
links.BD=link(40, 0, 0, 0, 1, 1, 0, [0,0], 0);
links.DE=link(40, 0, 0, 0, 1, 1, 0, [0,0], 0);
links.EF=link(40, 0, 0, 0, 1, 1, 0, [100,0], 0.1);
links.BY=link(40, 0, 0, 0, 1, 1, 0, [0,0], 0);
links.YE=link(40, 0, 0, 0, 1, 1, 0, [0,100], 0);
links.YZ=link(54, pi/4, 0, 0, 1, 1, 0, [10,0], 10);

% update links
links=add_links(links);


% show animation (1=yes, 0=no);
animate=1; 

% ** link chains are successive positions on your linkage starting with
% (0,0) global ground that is always specified as a single letter. Write
% valid chains until all positions are covered
% a correct way is {'Z', 'ZY', 'ZA', 'ZAC'}
% incorrect way is {'Z', 'Y', 'AC'}
link_chains={'Z', 'ZY', 'ZA', 'ZAB', 'ABD', 'ZYEF'}; 

% ** units (kg-m-s, gm-cm-s)
units='gm-cm-s';


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


% ** if you want to save the data for later analysis
% save('./mylinkage.mat', 'links');

process_and_show(links, link_chains, t, units, poi, animate);