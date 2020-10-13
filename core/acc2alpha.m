function [rddot, alpha]= acc2alpha(r, th, rdot, omega, ax, ay)

rddot=ax.*cos(th) + ay.*sin(th) + r.*omega.^2;
alpha=(ay.*cos(th)- rdot.*omega - ax.*sin(th))./r;