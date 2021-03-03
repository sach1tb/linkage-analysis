function example13_hoekens(a,b,c,d,theta2, omega2,alpha2, lnk_rho, lnk_width, lnk_thickness, ...
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
    a=10/100; b=25/100; c=25/100; d=20/100;
    rPA=b*2; BAP=0; % BAP

    % material density per length kg/m
    rho=23.4791;
%     lnk_rho=1190; % kg/m^3
%     lnk_thickness=0.0047625; % m
%     lnk_width=0.013; % m
    
    alpha2=0; % angular acceleration
    omega2=2*pi; % angular velocity

    FPAx=0;
    FPAy=0;
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


t=linspace(0,1, 100);

theta2=omega2*t+0.5*alpha2*t.^2; 


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
vG2x = -rCG2*omega2.*sin(theta2);
vG2y = rCG2*omega2.*cos(theta2);

vG3x = -a*omega2.*sin(theta2) - rCG3*omega3o.*sin(theta3o);
vG3y = a*omega2.*cos(theta2) + rCG3*omega3o.*cos(theta3o);

vG4x = -rO4G4*omega4o.*sin(theta4o);
vG4y = rO4G4*omega4o.*cos(theta4o);

vP3x = -a*omega2.*sin(theta2) - rPA*omega3o.*sin(theta3o);
vP3y = a*omega2.*cos(theta2) + rPA*omega3o.*cos(theta3o);


% we need these to implement the next set of equations
[RAO2x, RAO2y]=pol2cart(theta2, a);
[VAO2x, VAO2y]=omega2vel(theta2,a, omega2, 0);
[AAO2x, AAO2y]=alpha2acc(theta2, a,  omega2, 0, alpha2, 0);


[RPAx, RPAy]=pol2cart(theta3o, rPA);
[VPAx, VPAy]=omega2vel(theta3o, rPA, omega3o, 0);
[APAx, APAy]=alpha2acc(theta3o, rPA,  omega3o, 0, alpha3o, 0);

RPO2x=RPAx+RAO2x;
RPO2y=RPAy+RAO2y;

VPO2x=VPAx+VAO2x;
VPO2y=VPAy+VAO2y;

APO2x=APAx+AAO2x;
APO2y=APAy+AAO2y;

% plot pva data
figure(2); gcf; clf;
subplot(2,2,1);
plot(RPO2x, RPO2y, 'k', 'linewidth', 2);
grid on;
set(gca, 'fontsize', 16);

subplot(2,2,2);
plot(t, RPO2x, 'k:', 'linewidth', 2);
hold on;
plot(t, RPO2y, 'k--', 'linewidth', 2);
legend('x', 'y');
grid on;
set(gca, 'fontsize', 16);
xlabel('time(s)');
ylabel('position of G (m)');

subplot(2,2,3);
plot(t, VPO2x, 'k:', 'linewidth', 2);
hold on;
plot(t, VPO2y, 'k--', 'linewidth', 2);
legend('x', 'y');
grid on;
set(gca, 'fontsize', 16);
xlabel('time(s)');
ylabel('velocity of G (m/s)');

subplot(2,2,4);
plot(t, APO2x, 'k:', 'linewidth', 2);
hold on;
plot(t, APO2y, 'k--', 'linewidth', 2);
legend('x', 'y');
grid on;
set(gca, 'fontsize', 16);
xlabel('time(s)');
ylabel('acceeleration of G (m/s^2)');


% terms of the final equation without the signs (10.28 in book)

% external forces
t1=dot(F3*ones(1,numel(vP3x)), [vP3x;vP3y]); 
% inertial forces
t3=m2*dot([aG2x; aG2y], [vG2x; vG2y]) + ...
    m3*dot([aG3x; aG3y], [vG3x; vG3y]) + m4*dot([aG4x; aG4y], [vG4x; vG4y]);
% inertial torques
t4=I2*alpha2.*omega2 + I3*alpha3o.*omega3o + I4*alpha4o.*omega4o;

T_motor=1/omega2*(t3+t4-t1);

figure(3); gcf; clf;
plot(t, T_motor, 'k', 'linewidth', 2);
grid on;
set(gca, 'fontsize', 16);
xlabel('time(s)');
ylabel('required motor torque (Nm)');

