function [t1,t2, t3, t4]=fourbar_plot(a,b,c,d,BAP,APlen, t2,t3,t4,t1, clrs)

% BAP and APlen is the angle it makes with the floating
% link and the distance of the coupler link from the joint between
% the crank and the floater 
%
% % example use:
% a=40; b=60; c=30; d=55; t2=2*pi/3; t1=0;
% [t3o, t3c, t4o, t4c, A, B, C]=fourbar_position(a, b, c, d, t2, t1); 
% fourbar_plot(a, b, c, d, 0, 0, t2, t3o, t4o, t1, eye(3))

% fourbar plot automatically adds ground orientation
opos=0*exp(1i*t1);
apos=a*exp(1i*t2);
bpos=a*exp(1i*t2)+b*exp(1i*t3);
dpos=d*exp(1i*t1);
cpos=d*exp(1i*t1)+c*exp(1i*t4);

ppos=a*exp(1i*t2)+APlen*exp(1i*(t3+BAP));

% draw it

% ground
plot(real(opos), imag(opos), 'b^', 'markersize', 28, 'linewidth', 2);
hold on;

% crank, link 2
% quiver(real(opos), imag(opos), ...
%     real(apos-opos), imag(apos-opos), 0, 'color', clrs(1,:), ...
%     'linewidth', 2);
plot([real(apos), real(opos)], [imag(apos), imag(opos)], 'r-o', ...
                                'markersize', 10, 'linewidth', 4);

% floating link
% quiver(real(apos), imag(apos), ...
%     real(bpos-apos), imag(bpos-apos), 0, 'color', clrs(2,:), ...
%     'linewidth', 2);
plot([real(bpos), real(apos)], [imag(bpos), imag(apos)], 'g-o', ...
                                'markersize', 10, 'linewidth', 4);

% coupler
% quiver(real(apos), imag(apos), ...
%     real(ppos-apos), imag(ppos-apos), 0, '.', 'color', clrs(3,:), ...
%     'linewidth', 2);

plot([real(apos),  real(cpos)]', [imag(apos), imag(cpos)]', 'g-o', ...
                                'markersize', 10, 'linewidth', 4);

patch([real(apos),real(bpos), real(ppos)]', ...
            [imag(apos),imag(bpos), imag(ppos)]', 1,'edgecolor', 'none', ...
            'facecolor', 'c');                          
% plot([real(apos), real(ppos)]', [imag(apos), imag(ppos)]', 'b-', ...
%     'markersize', 10, 'linewidth', 4);
% plot([real(bpos), real(ppos)]', [imag(bpos), imag(ppos)]', 'b-', ...
%     'markersize', 10, 'linewidth', 4);

% rocker/output
% quiver(real(opos), imag(opos), ...
%     real(dpos-opos), imag(dpos-opos), 0, 'k', ...
%     'linewidth', 2);
plot([real(cpos), real(dpos)]', [imag(cpos), imag(dpos)]', 'b-o', ...
    'markersize', 10, 'linewidth', 4);

% ground
plot(real(dpos), imag(dpos), 'b^', 'markersize', 28, 'linewidth', 2);
% quiver(real(dpos), imag(dpos), ...
%     real(cpos-dpos), imag(cpos-dpos), 0, 'color', clrs(3,:), ...
%     'linewidth', 2);
grid on;
axis image;

% axis off
% axis([-1 1 -1 1]*10);

% box on;