function [vx, vy]= omega2vel(th, r, omega, rdot)
% converts the angular velocity (omega) and rate of change of length (rdot)
% at a given angle and length to linear velocity

vx=-r.*omega.*sin(th) + rdot.*cos(th);
vy=r.*omega.*cos(th) + rdot.*sin(th);
