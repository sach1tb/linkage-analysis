function example10_newtonian_method(a,b,c,d,alpha2,omega2,theta2, rho, ...
                        F2, F3, F4, rF2, rF3, rF4, T3, T4)
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
    % link lengths
    a=0.86; b=1.85; c=0.86; d=2.22; 
    
    % angle
    BAP=0; % radians
    APlen=b; % coupler length

    rho=23.4791;             % material density per length kg/m
                             % if this is not available put m2, I2, m3, ...
                             % etc. directly below
    
    rF2=0.0;            % external force location on link 2
    rF3=1.33;           % external force location on link 3
    rF4=0.0;            % external force location on link 4
    
    alpha2=10;          % angular acceleration
    omega2=-10;         % angular velocity
    theta2=-36*pi/180;  % angular position

    F2=[0; 0];          % external force on link 2
    F3=[500; 0];        % external force on link 3
    F4=[0; 0];          % ....
    
    T3=0; % external torque on link 3
    T4=0; % external torque on link 4
end


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


% pva analysis (use as is)
[alpha3o, alpha3c, alpha4o, alpha4c, omega3o, omega3c, omega4o, omega4c, ...
    theta3o, theta3c, theta4o, theta4c]=fourbar_acceleration(a, b, c, d, alpha2, ...
                                                omega2, theta2, alpha1, omega1, theta1);

% plot it to verify if the configuration is open or cross
% leave as is if it is open, but set the flag after fourbar_plot to 1 if
% the configuration is cross and rerun
if 0 % <-- set this value to 1 if the plot doesn't look right
    % reset all configurations to cross
    theta3o=theta3c;
    theta4o=theta4c;
    alpha3o=alpha3c;
    alpha4o=alpha4c;
    omega3o=omega3c;
    omega4o=omega4c;
end
figure(1); gcf; clf;
fourbar_plot(a,b,c,d,BAP,APlen, theta2,theta3o,theta4o,theta1, eye(3));
                                            
                                            
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

% location of where the force is acting in link's CG frame **
RF2=[(rF2-rCG2)*cos(theta2); (rF2-rCG2)*sin(theta2)];
RF3=[(rF3-rCG3)*cos(theta3o); (rF3-rCG3)*sin(theta3o)];
RF4=[(rF4-rCG4)*cos(theta4o); (rF4-rCG4)*sin(theta4o)];


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
B=[ m2*aG2x - F2(1,:);
    m2*aG2y - F2(2,:);
    I2*alpha2 - RF2(1)*F2(2,:) + RF2(2)*F2(1,:);
    m3*aG3x - F3(1,:);
    m3*aG3y - F3(2,:);
    I3*alpha3o - T3 - RF3(1)*F3(2,:) + RF3(2)*F3(1,:);
    m4*aG4x - F4(1,:);
    m4*aG4y - F4(2,:);
    I4*alpha4o - T4 - RF4(1)*F4(2,:) + RF4(2)*F4(1,:)];

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
% fprintf('%.1f, ', x)
% fprintf('\n');

results=array2table(x', 'VariableNames', {'F12x', 'F12y', 'F32x', 'F32y', ...
                        'F43x', 'F43y', 'F14x', 'F14y', 'T2'});
results
    



