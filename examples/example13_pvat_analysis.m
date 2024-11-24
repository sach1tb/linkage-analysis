function example13_pvat_analysis(a,b,c,d,APlen, BAP,theta2, omega2,alpha2, rho,...
             Fe2, Fe3, Fe4, rFe2, rFe3, rF4, Te3, Te4, simTime)

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
    
    % angle
    BAP=.1; % radians
    APlen=b*2; % coupler length
    
    cfg=1; % 1 is open and 0 is crossed

    rho=23.4791;             % material density per length kg/m
                             % if this is not available put m2, I2, m3, ...
                             % etc. directly below
                             
    rFe2=0.0;            % external force location on link 2
    rFe3=1.33;           % external force location on link 3
    rF4=0.0;            % external force location on link 4
    
    alpha2=0; % angular acceleration
    omega2=2*pi; % angular velocity
    
    Fe2=[0; 0];          % external force on link 2
    Fe3=[0; 0];        % external force on link 3
    Fe4=[0; 0];          % .... 
    
    Te3=0; % external torque on link 3
    Te4=0; % external torque on link 4
    
    simTime=1;
end

% *** Processing ***
% linspace linearly spaces the time into 100 equal sections
t=linspace(0,simTime, 100);


% link properties **
% a (crank)
m2=a*rho; % mass kg
I2=m2*(a^2)/12; % moment of inertia (replace with actual value if given)
rCG2=a/2; % location of center of mass on the link length

% b (coupler)
m3=b*rho; 
I3=m3*(b^2)/12; 
rCG3=b/2;

% c (rocker) 
m4=c*rho; 
I4=m4*(c^2)/12; 
rCG4=c/2;

% d (ground)
alpha1=0;
omega1=0;
theta1=0;


if omega2
    theta2=omega2*t+0.5*alpha2*t.^2; 
end

% pva analysis (leave as is)
[alpha3o, alpha3c, alpha4o, alpha4c, omega3o, omega3c, omega4o, omega4c, ...
    theta3o, theta3c, theta4o, theta4c]=fourbar_acceleration(a, b, c, d, alpha2, ...
                                                omega2, theta2, alpha1, omega1, theta1);

% plot it to verify if the configuration is open or cross
% leave as is if it is open, but set the flag after fourbar_plot to 1 if
% the configuration is cross and rerun
if cfg~=1 
    % reset all configurations to cross
    theta3o=theta3c;
    theta4o=theta4c;
    alpha3o=alpha3c;
    alpha4o=alpha4c;
    omega3o=omega3c;
    omega4o=omega4c;
end                                               
                                            
% accelerations of each link at its center of gravity **
aG2x=-rCG2*alpha2.*sin(theta2) -rCG2*omega2.^2.*cos(theta2);
aG2y=rCG2*alpha2.*cos(theta2) -rCG2*omega2.^2.*sin(theta2);

aAx=-a*alpha2.*sin(theta2) -a*omega2.^2.*cos(theta2);
aAy=a*alpha2.*cos(theta2) -a*omega2.^2.*sin(theta2);

aG3x = aAx + -rCG3*alpha3o.*sin(theta3o) -rCG3*omega3o.^2.*cos(theta3o);
aG3y = aAy + rCG3*alpha3o.*cos(theta3o) -rCG3*omega3o.^2.*sin(theta3o);

aG4x = -rCG4*alpha4o.*sin(theta4o) -rCG4*omega4o.^2.*cos(theta4o);
aG4y = rCG4*alpha4o.*cos(theta4o) -rCG4*omega4o.^2.*sin(theta4o);

% velocities of each link at its center of gravity
vG2x = -rCG2*omega2.*sin(theta2);
vG2y = rCG2*omega2.*cos(theta2);

vG3x = -a*omega2.*sin(theta2) - rCG3*omega3o.*sin(theta3o);
vG3y = a*omega2.*cos(theta2) + rCG3*omega3o.*cos(theta3o);

vG4x = -rCG4*omega4o.*sin(theta4o);
vG4y = rCG4*omega4o.*cos(theta4o);

vP2x = -rFe2*omega2.*sin(theta2);
vP2y = rFe2*omega2.*cos(theta2);

vP3x = -a*omega2.*sin(theta2) - rFe3*omega3o.*sin(theta3o);
vP3y = a*omega2.*cos(theta2) + rFe3*omega3o.*cos(theta3o);

vP4x = - rF4*omega4o.*sin(theta4o);
vP4y = rF4*omega4o.*cos(theta4o);

% we need these to implement the next set of equations
[RAZx, RAZy]=pol2cart(theta2, a);
[VAZx, VAZy]=omega2vel(theta2,a, omega2, 0);
[AAZx, AAZy]=alpha2acc(theta2, a,  omega2, 0, alpha2, 0);

[RBAx, RBAy]=pol2cart(theta3o, b);
[VBAx, VBAy]=omega2vel(theta3o, b, omega3o, 0);
[ABAx, ABAy]=alpha2acc(theta3o, b,  omega3o, 0, alpha3o, 0);


[RPAx, RPAy]=pol2cart(theta3o + BAP, APlen);
[VPAx, VPAy]=omega2vel(theta3o + BAP, APlen, omega3o, 0);
[APAx, APAy]=alpha2acc(theta3o + BAP, APlen,  omega3o, 0, alpha3o, 0);

RBZx=RBAx+RAZx;
RBZy=RBAy+RAZy;


RZYx = d*ones(1, numel(t));
RZYy = 0*ones(1, numel(t));


RPZx=RPAx+RAZx;
RPZy=RPAy+RAZy;

VPZx=VPAx+VAZx;
VPZy=VPAy+VAZy;

APZx=APAx+AAZx;
APZy=APAy+AAZy;

% animate
for k=1:numel(t)
    figure(1); gcf; clf;
    fourbar_plot(a,b,c,d,BAP,APlen, ...
        theta2(k),theta3o(k),theta4o(k),theta1,...
        [-(a+b), (a+b)], [-(a+APlen), (a+APlen)],eye(3));
end

% plot position trace
plot(RPZx, RPZy, 'k', 'linewidth', 2);
grid on;
set(gca, 'fontsize', 16);

% plot pva data
figure(2); gcf; clf;
subplot(2,2,1);
plot(RPZx, RPZy, 'k', 'linewidth', 2);
grid on;
set(gca, 'fontsize', 16);

subplot(2,2,2);
plot(t, RPZx, 'k:', 'linewidth', 2);
hold on;
plot(t, RPZy, 'k--', 'linewidth', 2);
legend('x', 'y');
grid on;
set(gca, 'fontsize', 16);
xlabel('time(s)');
ylabel('position of G (m)');

subplot(2,2,3);
plot(t, VPZx, 'k:', 'linewidth', 2);
hold on;
plot(t, VPZy, 'k--', 'linewidth', 2);
legend('x', 'y');
grid on;
set(gca, 'fontsize', 16);
xlabel('time(s)');
ylabel('velocity of G (m/s)');

subplot(2,2,4);
plot(t, APZx, 'k:', 'linewidth', 2);
hold on;
plot(t, APZy, 'k--', 'linewidth', 2);
legend('x', 'y');
grid on;
set(gca, 'fontsize', 16);
xlabel('time(s)');
ylabel('acceeleration of G (m/s^2)');


% terms of the final equation without the signs (10.28 in book)

% external forces
t1=dot(Fe2*ones(1,numel(t)), [vP2x;vP2y]) + dot(Fe3*ones(1,numel(t)), [vP3x;vP3y]) + ...
    dot(Fe4*ones(1,numel(t)), [vP4x;vP4y]) + Te3*omega3o + Te4*omega4o; 

% inertial forces
t3=m2*dot([aG2x; aG2y], [vG2x; vG2y]) + ...
    m3*dot([aG3x; aG3y], [vG3x; vG3y]) + m4*dot([aG4x; aG4y], [vG4x; vG4y]);
% inertial torques
t4=I2*alpha2.*omega2 + I3*alpha3o.*omega3o + I4*alpha4o.*omega4o;

T_motor=1/omega2*(t3+t4-t1); % Te2

figure(3); gcf; clf;
plot(t, T_motor, 'k', 'linewidth', 2);
grid on;
set(gca, 'fontsize', 16);
xlabel('time(s)');
ylabel('required motor torque (Nm)');

