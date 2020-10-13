function [vx, vy]= omega2vel(th, r, omega, rdot)
vx=-r.*omega.*sin(th) + rdot.*cos(th);
vy=r.*omega.*cos(th) + rdot.*sin(th);
