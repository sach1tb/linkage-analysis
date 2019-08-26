function [t1,t2, t3, t4]=cs_plot(a,b,c,d, t2,t3,t1, clrs)

if nargin < 1

    t1=0;
    % fourbar length
    a=40; b=120; c=-20; d=-86; t2=pi/3; t3= 27*pi/180;
    clrs=eye(3);
end

t4=pi/2;
    
% fourbar plot automatically adds ground orientation
o2pos=0*exp(1i*t1);
apos=a*exp(1i*t2);
bpos=a*exp(1i*t2)+b*exp(1i*(t3-pi));
o4pos=d*exp(1i*t1);


% draw it

% ground
plot(real(o2pos), imag(o2pos), 'ko', 'markersize', 12, 'linewidth', 2);
hold on;
plot(real(o2pos), imag(o2pos), 'ks', 'markersize', 16, 'linewidth', 2);


% crank, link 2
quiver(real(o2pos), imag(o2pos), ...
    real(apos-o2pos), imag(apos-o2pos), 0, 'color', clrs(1,:), ...
    'linewidth', 2);
plot(real(apos), imag(apos), 'ko', 'markersize', 9, 'linewidth', 2);

% floating link
quiver(real(bpos), imag(bpos), ...
    real(apos-bpos), imag(apos-bpos), 0, 'color', clrs(2,:), ...
    'linewidth', 2);
plot(real(bpos), imag(bpos), 'ko', 'markersize', 9, 'linewidth', 2)


plot(real(o4pos), imag(o4pos), 's', 'markersize', 16, 'linewidth', 1, ...
    'color', ones(1,3)*.25);
plot(real(o4pos), imag(o4pos), 'o', 'markersize', 12, 'linewidth', 1, ...
    'color', ones(1,3)*.25);

rectangle('Position', [real(bpos)-a/10, imag(bpos)-a/20, a/5, a/10]);
plot([real(bpos)-d/2, real(bpos)+d/2],[imag(bpos), imag(bpos)]-a/20, 'k--');
plot([real(o2pos), real(o4pos)],[imag(o2pos), imag(o4pos)], 'k-.');

quiver(real(o4pos), imag(o4pos), ...
    real(bpos-o4pos), imag(bpos-o4pos), 0, '--', 'color', clrs(3,:), ...
    'linewidth', 2);

grid on;
axis image
axis([-abs(d)-a, abs(d)+a, min(-a,-c), max(a,c)]);
axis off;