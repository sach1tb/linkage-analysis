function [ax, ay]= alpha2acc(th, r, omega, rdot, alpha, rddot)
% converts the angular acceleration (alpha) and rate of rate of change of 
% length (rdot) at a given angle, length, angular velocity and rdot 
% to linear acceleration


ax=-r.*omega.^2.*cos(th) -r.*alpha.*sin(th) ...
    - rdot.*omega.*sin(th) + rddot.*cos(th);
ay=-r.*omega.^2.*sin(th) + r.*alpha.*cos(th) ...
    + rdot.*omega.*cos(th) + rddot.*sin(th);