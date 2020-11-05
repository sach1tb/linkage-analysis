function [rddot, alpha]= acc2alpha(r, th, rdot, omega, ax, ay)
% converts the linear acceleration at a given angle, length,
% angular velocity and rate of change of length, to angular acceleration
% and rate of rate of change of length

rddot=ax.*cos(th) + ay.*sin(th) + r.*omega.^2;
alpha=(ay.*cos(th)- rdot.*omega - ax.*sin(th))./r;