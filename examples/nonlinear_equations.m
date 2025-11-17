clearvars

% how to solve nonlinear equations

% sample equations, solve for x and y; a,b,c,d are constants
% a*cos(x) + b*cos(y) = c
% a*sin(x) + b*sin(y) = d

% need a guess
z0=[0, 0]; % bad guess

a=3; b=2; c=3; d=4;

options = optimoptions('fsolve','Display','off');
z=fsolve(@(z) nlineq(z, a, b,c,d), z0, options);

z*180/pi

nlineq(z,a,b,c,d)

function F=nlineq(z, a,b,c,d)

x=z(1);
y=z(2);

F(1)=a*cos(x) + b*cos(y)-c;
F(1)=a*sin(x) + b*sin(y)-d;
end