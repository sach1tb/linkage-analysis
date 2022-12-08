function example11_virtual_work(a,b,c,d,theta2, omega2,alpha2, ...
        F2, F3, F4, rF2, rF3, rF4, T3, T4)

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

% pva analysis (leave as is)
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
vG2x = -rCG2*omega2*sin(theta2);
vG2y = rCG2*omega2*cos(theta2);

vG3x = -a*omega2*sin(theta2) - rCG3*omega3o*sin(theta3o);
vG3y = a*omega2*cos(theta2) + rCG3*omega3o*cos(theta3o);

vG4x = -rCG4*omega4o*sin(theta4o);
vG4y = rCG4*omega4o*cos(theta4o);

vP2x = -rF2*omega2*sin(theta2);
vP2y = rF2*omega2*cos(theta2);

vP3x = -a*omega2*sin(theta2) - rF3*omega3o*sin(theta3o);
vP3y = a*omega2*cos(theta2) + rF3*omega3o*cos(theta3o);

vP4x = - rF4*omega4o*sin(theta4o);
vP4y = rF4*omega4o*cos(theta4o);

% terms of the final equation without the signs (10.28 in book)

% external forces
t1=dot(F2, [vP2x,vP2y]') + dot(F3, [vP3x,vP3y]') + ...
    dot(F4, [vP4x,vP4y]') + T3*omega3c + T4*omega4c; 

% inertial forces
t3=m2*dot([aG2x; aG2y], [vG2x; vG2y]) + ...
    m3*dot([aG3x; aG3y], [vG3x; vG3y]) + m4*dot([aG4x; aG4y], [vG4x; vG4y]);
% inertial torques
t4=I2*alpha2*omega2 + I3*alpha3o*omega3o + I4*alpha4o*omega4o;

T2=1/omega2*(t3+t4-t1);

fprintf('T2=%.4f\n', T2);


