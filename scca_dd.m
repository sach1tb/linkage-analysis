function cam=scca_dd(fun, h, beta, omega, base_rad, units)
% scca_dd performs design and SVAJ analysis of a cam profile
% 
% Syntax
%
%   cam=scca_dd(fun, h, beta, omega, base_rad, units)
%
%
% Description
%   cam=scca_dd(fun, h, beta, omega, base_rad, units)
%   takes as input a single SCCA function, the change in height,  
%   beta in radians, angular velocity, base radius
%   and the units of base radius and height
%   it returns a matrix cam which contains rows represnting an angle, 
%   and the s, v, a, j values for that angle
%
%   if you enter beta values that don't add up to zero the function
%   automatically assumes a dwell for the remaining portion
%
%   fun can be 'modtrap', for modified trapezoidal, 'modsin' for modified sine, and
%   'cyc' for cycloidal displacement
%
% Reference
%   [1] R. L. Norton, Design of Machinery, McGrawHill
%
% Example:
% design a cam with 5 cm base radius that rises 2 cm for 90 deg., dwells
% for 90 degree, then falls for 2 cm for 90 degrees and dwells for the rest
% scca_dd('modtrap', [2, 0, -2], [pi/2, pi/2, pi/2], 1, 5, 'cm');
%
% Sachit Butail, NIU, 2016


if nargin < 1
    fun='cyc';
    h=[2, 0, -2];
    beta=[pi/2, pi/2, pi/2];
    omega=1;
    base_rad=5;
    units='m';
end


h=[0, h];
beta=[0, beta];

if sum(beta) < 2*pi
    beta=[beta, 2*pi-sum(beta)];
    h=[h, 0];
end


switch fun
    case 'modtrap'
        b=0.25; 
        c=0.5; 
        d=0.25;
        Ca=4.881;
    case 'shm' % *
        b=0;
        c=0;
        d=1;
        Ca=4.9348;
    case 'ca' % *
        b=0;
        c=1;
        d=0;
        Ca=4;
    case 'modsin'
        b=0.25; 
        c=0.0; 
        d=0.75;
        Ca=5.528;
    case 'cyc'
        b=0.5; 
        c=0.0; 
        d=0.5;
        Ca=6.2832;        
end


% plot svaj

figure(1); gcf; clf;
sp=0;
cam=[];
fs=20;
clr=colormap(cool(numel(h)));
for sec=2:numel(h)
    [s, v, a, j, xz]=svaj(beta(sec), h(sec), b, c, d, Ca, omega);
    
    % reset to the last position from previous timestep
    s=s+sp-s(1);
    sp=s(end);
    
    
    figure(1); gcf;
    subplot(4,2,1);
    angle=beta(sec)*xz+sum(beta(1:sec-1));
    plot(angle*180/pi, s, 'linewidth', 3, 'color', clr(sec,:));
    grid on; hold on;
    set(gca, 'fontsize', fs, 'xlim', [0, 360], 'fontname', 'times');
    set(gca, 'xtick', 0:60:360);
    ylabel(sprintf('S (%s)', units));
    
    subplot(4,2,3);
    plot(angle*180/pi, v, 'linewidth', 3, 'color', clr(sec,:));
    grid on; hold on;
    set(gca, 'fontsize', fs, 'xlim', [0, 360], 'fontname', 'times');
    set(gca, 'xtick', 0:60:360);
    ylabel(sprintf('V (%s/s)', units));
    
    subplot(4,2,5);
    plot(angle*180/pi, a, 'linewidth', 3, 'color', clr(sec,:));
    grid on; hold on;
    set(gca, 'fontsize', fs, 'xlim', [0, 360], 'fontname', 'times');
    set(gca, 'xtick', 0:60:360);
    ylabel(sprintf('A (%s/s^2)', units));
    
    subplot(4,2,7);
    plot(angle*180/pi, j, 'linewidth', 3, 'color', clr(sec,:));
    grid on; hold on;
    set(gca, 'fontsize', fs, 'xlim', [0, 360], 'fontname', 'times');
    set(gca, 'xtick', 0:60:360);
    ylabel(sprintf('J (%s/s^3)', units));
    xlabel('\theta (\circ)');

    subplot(4,2,[2, 4, 6, 8]); 
    plot((base_rad+s).*cos(angle), (base_rad+s).*sin(angle), ...
                'linewidth', 3, 'color', clr(sec,:));
    hold on;
    set(gca, 'fontsize', fs, 'fontname', 'times');
    xlabel(units); ylabel(units);
    axis image;
    grid on;
    cam=[cam; angle, s, v, a j];
end

figure(1); gcf;
subplot(4,2,1);
plot(cam(:,1)*180/pi, cam(:,2), 'k-.', 'linewidth', 1);
subplot(4,2,3);
plot(cam(:,1)*180/pi, cam(:,3), 'k-.', 'linewidth', 1);
subplot(4,2,5);
plot(cam(:,1)*180/pi, cam(:,4), 'k-.', 'linewidth', 1);
subplot(4,2,7);
plot(cam(:,1)*180/pi, cam(:,5), 'k-.', 'linewidth', 1);
subplot(4,2,[2, 4, 6, 8]); 
plot((base_rad+cam(:,2)).*cos(cam(:,1)), (base_rad+cam(:,2)).*sin(cam(:,1)),...
    'k--', 'linewidth', 1);
plot((base_rad).*cos(cam(:,1)), (base_rad).*sin(cam(:,1)),...
    'k--', 'linewidth', 1);


function [S, V, A, J, xz]=svaj(beta, h, b, c, d, Ca, omega)


% zone 1
x=0:.01:b/2; n1=numel(x);
xz(1:n1,1)=x;
y(1:n1,1)=Ca*(b/pi*x-(b/pi)^2*sin(pi/b*x));
ydot(1:n1,1)=Ca*(b/pi-b/pi*cos(pi/b*x));
yddot(1:n1,1)=Ca*sin(pi/b*x);
ydddot(1:n1,1)=Ca*pi/b*cos(pi/b*x);

% zone 2
x=b/2:.01:(1-d)/2; n2=numel(x); n1=numel(xz);
xz(n1+1:n1+n2,:)=x;
y(n1+1:n1+n2,:)=Ca*(x.^2/2+b*(1/pi-1/2).*x + b^2*(1/8-1/pi^2));
ydot(n1+1:n1+n2,:)=Ca*(x+b*(1/pi-1/2));
yddot(n1+1:n1+n2,:)=Ca;
ydddot(n1+1:n1+n2,:)=0;

% zone 3
x=(1-d)/2:.01:(1+d)/2; n3=numel(x); n2=numel(xz);
xz(n2+1:n2+n3,:)=x;
y(n2+1:n2+n3,:)=Ca*((b/pi+c/2)*x +(d/pi)^2 + b^2*(1/8-1/pi^2)-(1-d)^2/8 ...
            -(d/pi)^2*cos(pi/d*(x-(1-d)/2)));
ydot(n2+1:n2+n3,:)=Ca*(b/pi+c/2+d/pi*sin(pi/d*(x-(1-d)/2)));
yddot(n2+1:n2+n3,:)=Ca*cos(pi/d*(x-(1-d)/2));
ydddot(n2+1:n2+n3,:)=-Ca*pi/d*sin(pi/d*(x-(1-d)/2));

% zone 4
x=(1+d)/2:.01:(1-b/2); n4=numel(x); n3=numel(xz);
xz(n3+1:n3+n4,:)=x;
y(n3+1:n3+n4,:)=Ca*(-x.^2/2+(b/pi+1-b/2)*x + (2*d^2-b^2)*(1/pi^2-1/8)-1/4);
ydot(n3+1:n3+n4,:)=Ca*(-x+b/pi+1-b/2);
yddot(n3+1:n3+n4,:)=-Ca;
ydddot(n3+1:n3+n4,:)=0;

% zone 5
x=(1-b/2):.01:1; n5=numel(x); n4=numel(xz);
xz(n4+1:n4+n5,:)=x;
y(n4+1:n4+n5,:)=Ca*(b/pi*x+2*(d^2-b^2)/pi^2+((1-b)^2-d^2)/4-...
                    (b/pi)^2*sin(pi/b*(x-1)));
ydot(n4+1:n4+n5,:)=Ca*(b/pi-b/pi*cos(pi/b*(x-1)));
yddot(n4+1:n4+n5,:)=Ca*sin(pi/b*(x-1));
ydddot(n4+1:n4+n5,:)=Ca*pi/b*cos(pi/b*(x-1));

% compute s v a j
if h >= 0
    s=h*y; S=s;
    v=h/beta*ydot; V=v*omega;
    a=h/beta^2*yddot; A=a*omega^2;
    j=h/beta^3*ydddot; J=j*omega^3;
elseif h < 0
    h=-h;
    s=h*(1-y); S=s;
    v=-h/beta*ydot; V=v*omega;
    a=-h/beta^2*yddot; A=a*omega^2;
    j=-h/beta^3*ydddot; J=j*omega^3;
end
