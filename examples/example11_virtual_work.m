function example11_virtual_work(a,b,c,d,theta2, omega2,alpha2, lnk_rho, lnk_width, lnk_thickness, ...
        rPA, FPAx, FPAy)

addpath ../core

% energy method: gives input torque for a required
% angular acceleration and velocity of a fourbar linkage
%
% force torque analysis of a fourbar subject to an external force 
% based on problem 11-12 in book and the example in class
% to use this script you must change the link properties, joint positions, 
% location of where the force is applied in link 3's frame and acceleration
% of each link's center of gravity, all locations marked with '**'
% 

if nargin < 1
    a=1.8*2;
    b=2.7*2;
    c=2.2*2;
    d=2.3*2;

    % material density per length kg/m
    rho=7.74;
%     lnk_rho=1190; % kg/m^3
%     lnk_thickness=0.0047625; % m
%     lnk_width=0.013; % m
    
    rPA=2.7;
    
    alpha2=0; % angular acceleration
    omega2=pi; % angular velocity
    theta2=-15*pi/180; % angular position

    FPAx=10*cosd(20);
    FPAy=10*sind(20);

end

% link properties **
% a (crank)
m2=a*rho; % mass kg
I2=m2*(a^2)/12; % moment of inertia
rCG2=a/2; % location of center of mass on the link length

% b (coupler)
m3=b*rho; 
I3=m3*(b^2)/12; 
rCG3=b/2;
F3=[FPAx; FPAy]; % external force applied on link 3 in the x-direction (N)

% c (rocker) 
m4=c*rho; 
I4=m4*(c^2)/12; 
rCG4=c/2;
rO4G4=c/2;
T4=0; % external torque on link 4

% d (ground)
alpha1=0;
omega1=0;
theta1=0;


% pva analysis (leave as is)
[alpha3o, alpha3c, alpha4o, alpha4c, omega3o, omega3c, omega4o, omega4c, ...
    theta3o, theta3c, theta4o, theta4c]=fourbar_acceleration(a, b, c, d, alpha2, ...
                                                omega2, theta2, alpha1, omega1, theta1);

% accelerations of each link at its center of gravity **
aG2x=-rCG2*alpha2.*sin(theta2) -rCG2*omega2.^2.*cos(theta2);
aG2y=rCG2*alpha2.*cos(theta2) -rCG2*omega2.^2.*sin(theta2);

aAx=-a*alpha2.*sin(theta2) -a*omega2.^2.*cos(theta2);
aAy=a*alpha2.*cos(theta2) -a*omega2.^2.*sin(theta2);

aG3x = aAx + -rCG3*alpha3o.*sin(theta3o) -rCG3*omega3o.^2.*cos(theta3o);
aG3y = aAy + rCG3*alpha3o.*cos(theta3o) -rCG3*omega3o.^2.*sin(theta3o);

aG4x = -rO4G4*alpha4o.*sin(theta4o) -rO4G4*omega4o.^2.*cos(theta4o);
aG4y = rO4G4*alpha4o.*cos(theta4o) -rO4G4*omega4o.^2.*sin(theta4o);

% velocities of each link at its center of gravity
vG2x = -rCG2*omega2*sin(theta2);
vG2y = rCG2*omega2*cos(theta2);

vG3x = -a*omega2*sin(theta2) - rCG3*omega3o*sin(theta3o);
vG3y = a*omega2*cos(theta2) + rCG3*omega3o*cos(theta3o);

vG4x = -rO4G4*omega4o*sin(theta4o);
vG4y = rO4G4*omega4o*cos(theta4o);

vP3x = -a*omega2*sin(theta2) - rPA*omega3o*sin(theta3o);
vP3y = a*omega2*cos(theta2) + rPA*omega3o*cos(theta3o);


% terms of the final equation without the signs (10.28 in book)

% external forces
t1=dot(F3, [vP3x,vP3y]'); 
% inertial forces
t3=m2*dot([aG2x; aG2y], [vG2x; vG2y]) + ...
    m3*dot([aG3x; aG3y], [vG3x; vG3y]) + m4*dot([aG4x; aG4y], [vG4x; vG4y]);
% inertial torques
t4=I2*alpha2*omega2 + I3*alpha3o*omega3o + I4*alpha4o*omega4o;

T12=1/omega2*(t3+t4-t1);

fprintf('T12=%.2f\n', T12);


