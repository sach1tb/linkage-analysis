function example14_jansen
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
omegaCrank=2; % rad/s
alphaCrank=0;
simTime=2*(2*pi/omegaCrank); % seconds 
t=linspace(0,simTime, 100);

thetaCrank=omegaCrank*t+0.5*alphaCrank*t.^2; % theta_2

% ** create links here
% the arguments are: 
% links.AB implies a vector pointing from joint B to joint A
% length, theta, omega, alpha, mass, moment of inertia, torque, force x and y,
% distance of the application of force from the joint B 
% FIRST LINK IS ALWAYS CRANK
links.AZ=link(15, thetaCrank, omegaCrank, alphaCrank, 10, 10, 0, [0,0], 0); % crank
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
links.CF=link(49, 0, 0, 0, 10, 10, 0, [0,0], 0);

% update links
links=add_links(links);


% show animation (1=yes, 0=no);
animate=1; 

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

process_and_show(links, link_chains, t, units, poi, animate);