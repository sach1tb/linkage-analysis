function [t1,t2, t3, t4]=fourbar_plot(a,b,c,d,BAP,APlen,...
                                        t2,t3,t4,t1,xlim, ylim, clrs)
% plots a fourbar with a coupler
% usage:
%
%   fourbar_plot(a,b,c,d,BAP,APlen, t2,t3,t4,t1,xlim, ylim, clrs)
%   
%   a, b, c, d, are link lengths
%   BAP is an angle on the coupler (refer to fourbar.png in 'doc')
%   APlen is the length of a side of the coupler 
%   t2, t3, t4, t1 are crank, coupler, rocker, and ground angles in radians 
%   xlim is [xmin xmax] range of x in which the linkage moves
%   ylim is [ymin ymax] range of y in which the linkage moves
% 
% example use:
%   a=40; b=60; c=30; d=55; t2=2*pi/3; t1=0;
%   [t3o, t3c, t4o, t4c, A, B, C]=fourbar_position(a, b, c, d, t2, t1); 
%   fourbar_plot(a, b, c, d, 0, 0, t2, t3o, t4o, t1, [-(a+d) (a+d)], [-(a+b) (a+b)], eye(3))

% fourbar plot automatically adds ground orientation
opos=0*exp(1i*t1);
apos=a*exp(1i*t2);
bpos=a*exp(1i*t2)+b*exp(1i*t3);
dpos=d*exp(1i*t1);
% cpos=d*exp(1i*t1)+c*exp(1i*t4);

ppos=a*exp(1i*t2)+APlen*exp(1i*(t3+BAP));

% draw it

% ground
plot(real(opos), imag(opos), '^', 'markersize', 28,'color', clrs(:,1)', 'linewidth', 2);
hold on;

% crank, link 2
% quiver(real(opos), imag(opos), ...
%     real(apos-opos), imag(apos-opos), 0, 'color', clrs(1,:), ...
%     'linewidth', 2);
plot([real(apos), real(opos)], [imag(apos), imag(opos)], '-o', ...
                                'markersize', 10, 'color', clrs(:,1)', 'linewidth', 4);

% floating link
% quiver(real(apos), imag(apos), ...
%     real(bpos-apos), imag(bpos-apos), 0, 'color', clrs(2,:), ...
%     'linewidth', 2);
plot([real(bpos), real(apos)], [imag(bpos), imag(apos)], '-o', ...
                                'markersize', 10,'color', clrs(:,2)','linewidth', 4);

% coupler
% quiver(real(apos), imag(apos), ...
%     real(ppos-apos), imag(ppos-apos), 0, '.', 'color', clrs(3,:), ...
%     'linewidth', 2);

% plot([real(apos),  real(cpos)]', [imag(apos), imag(cpos)]', 'g-o', ...
%                                 'markersize', 10, 'linewidth', 4);

% plot([real(bpos), real(ppos)], [imag(bpos), imag(ppos)], 'g-o', ...
%                                 'markersize', 10, 'linewidth', 4);
% plot([real(apos), real(ppos)], [imag(apos), imag(ppos)], 'g-o', ...
%                                 'markersize', 10, 'linewidth', 4);                            
patch([real(apos),real(bpos), real(ppos)]', ...
            [imag(apos),imag(bpos), imag(ppos)]', 1,'edgecolor', 'none', ...
            'facecolor', clrs(:,2)', 'facealpha', 0.75);                          
% plot([real(apos), real(ppos)]', [imag(apos), imag(ppos)]', 'b-', ...
%     'markersize', 10, 'linewidth', 4);
% plot([real(bpos), real(ppos)]', [imag(bpos), imag(ppos)]', 'b-', ...
%     'markersize', 10, 'linewidth', 4);

% rocker/output
% quiver(real(opos), imag(opos), ...
%     real(dpos-opos), imag(dpos-opos), 0, 'k', ...
%     'linewidth', 2);
plot([real(bpos), real(dpos)]', [imag(bpos), imag(dpos)]', '-o', ...
    'markersize', 10,'color', clrs(:,3)', 'linewidth', 4);

% ground
plot(real(dpos), imag(dpos), '^', 'markersize', 28, 'color', clrs(:,3)','linewidth', 2);
% quiver(real(dpos), imag(dpos), ...
%     real(cpos-dpos), imag(cpos-dpos), 0, 'color', clrs(3,:), ...
%     'linewidth', 2);
grid on;
axis image;
set(gca, 'xlim', xlim);
set(gca, 'ylim', ylim);
set(gca, 'fontsize', 16);

% axis off
% axis([-1 1 -1 1]*10);

% box on;