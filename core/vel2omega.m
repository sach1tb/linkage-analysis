function [rdot, omega]= vel2omega(r, th, vx, vy)
% converts the linear velocity at a given angle, length,
% to angular velocity and rate of change of length 

rdot=vx.*cos(th) + vy.*sin(th);
omega=(vy.*cos(th) - vx.*sin(th))./r;
% omega=(sqrt(vx.^2+vy.^2)-rdot.^2)./r.^2;

