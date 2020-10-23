function example10_newtonian_method(a,b,c,d,alpha2,omega2,theta2, rho, ...
                        F1, F2, F3, F4, rF1, rF2, rF3, rF4, T1, T2, T3, T4)
addpath ../core

% newtonian method: gives pin  joint forces and input torque for a required
% angular acceleration and velocity of a fourbar linkage
%
% force torque analysis of a fourbar subject to an external force 
% based on problem 11-12 in book and the example in class
% to use this script you must change the link properties, joint positions, 
% location of where the force is applied in link 3's frame and acceleration
% of each link's center of gravity, all locations marked with '**'

if nargin < 1
    rho=23.4791;
    
    % link properties **
    % a (crank)
    a=0.86; % length m
    m2=rho*a; % mass kg
    I2=m2*a^2/12; % moment of inertia
    rCG2=a/2; % location of center of mass on the link length
    alpha2=10; % angular acceleration
    omega2=-10; % angular velocity
    theta2=-36*pi/180; % angular position
    
    % b (coupler)
    b=1.85;
    m3=rho*b; 
    I3=m3*b^2/12; 
    rCG3=b/2;
    rF3=1.33;
    F3=[500; 0]; % external force applied on link 3 in the x-direction (N)
    
    % c (rocker) 
    c=0.86;
    m4=rho*c; 
    I4=m4*c^2/12; 
    rCG4=c/2;
    T4=0; % external torque on link 4

    % d (ground)
    d=2.22; 
    alpha1=0;
    omega1=0;
    theta1=0;
end


% pva analysis (use as is)
[alpha3o, alpha3c, alpha4o, alpha4c, omega3o, omega3c, omega4o, omega4c, ...
    theta3o, theta3c, theta4o, theta4c]=fourbar_acceleration(a, b, c, d, alpha2, ...
                                                omega2, theta2, alpha1, omega1, theta1);

% joint positions **                                            
% RXY is the position of joint between links X and Y in a 
% local frame located at link Y's frame 
R12=[   rCG2*cos(theta2+pi);
        rCG2*sin(theta2+pi)];
    
R32=[   rCG2*cos(theta2);
        rCG2*sin(theta2)];

R23=[   rCG3*cos(theta3o+pi);
        rCG3*sin(theta3o+pi)];
    
R43=[   rCG3*cos(theta3o);
        rCG3*sin(theta3o)];

R34=[   rCG4*cos(theta4o);
        rCG4*sin(theta4o)];

R14=[   rCG4*cos(theta4o+pi);
        rCG4*sin(theta4o+pi)];

% location of where the force is acting in link 3's frame **
RF3=[(rF3-rCG3)*cos(theta3o); (rF3-rCG3)*sin(theta3o)];

% accelerations of each link at its center of gravity ** (change only if
% needed)
aG2x=-rCG2*alpha2.*sin(theta2) -rCG2*omega2.^2.*cos(theta2);
aG2y=rCG2*alpha2.*cos(theta2) -rCG2*omega2.^2.*sin(theta2);

aAx=-a*alpha2.*sin(theta2) -a*omega2.^2.*cos(theta2);
aAy=a*alpha2.*cos(theta2) -a*omega2.^2.*sin(theta2);

aG3x = aAx + -rCG3*alpha3o.*sin(theta3o) -rCG3*omega3o.^2.*cos(theta3o);
aG3y = aAy + rCG3*alpha3o.*cos(theta3o) -rCG3*omega3o.^2.*sin(theta3o);

aG4x = -rCG4*alpha4o.*sin(theta4o) -rCG4*omega4o.^2.*cos(theta4o);
aG4y = rCG4*alpha4o.*cos(theta4o) -rCG4*omega4o.^2.*sin(theta4o);

% solve the newtonian dynamics equations using matrix inversion
% (use as is)
B=[ m2*aG2x;
    m2*aG2y;
    I2*alpha2;
    m3*aG3x - F3(1,:);
    m3*aG3y - F3(2,:);
    I3*alpha3o - RF3(1)*F3(2,:) + RF3(2)*F3(1,:);
    m4*aG4x;
    m4*aG4y;
    I4*alpha4o - T4];

A=[ 1 0 1 0 0 0 0 0 0
    0 1 0 1 0 0 0 0 0
    -R12(2) R12(1) -R32(2) R32(1) 0 0 0 0 1
    0 0 -1 0 1 0 0 0 0 
    0 0 0 -1 0 1 0 0 0 
    0 0 R23(2) -R23(1) -R43(2) R43(1) 0 0 0
    0 0 0 0 -1 0 1 0 0
    0 0 0 0 0 -1 0 1 0
    0 0 0 0 R34(2) -R34(1) -R14(2) R14(1) 0];

x=A\B;

results=array2table(x', 'VariableNames', {'F12x', 'F12y', 'F32x', 'F32y', ...
                        'F43x', 'F43y', 'F14x', 'F14y', 'T12'});

results
    



