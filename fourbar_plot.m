function [t1,t2, t3, t4]=fourbar_plot(a,b,c,d,cot,col, t2,t3,t4,t1, clrs)

% cot and col is the angle it makes with the floating
% link and the length of the coupler link

opos=0*exp(1i*t1);
t2=t2+t1;
t3=t3+t1;
t4=t4+t1;
apos=a*exp(1i*t2);
bpos=a*exp(1i*t2)+b*exp(1i*t3);
dpos=d*exp(1i*t1);
cpos=d*exp(1i*t1)+c*exp(1i*t4);

copos=a*exp(1i*t2)+col*exp(1i*(t3+cot));

% draw it

plot(real(opos), imag(opos), 'ko', 'markersize', 12, 'linewidth', 2);
hold on;
plot(real(opos), imag(opos), 'ks', 'markersize', 16, 'linewidth', 2);
quiver(real(opos), imag(opos), ...
    real(apos-opos), imag(apos-opos), 0, 'color', clrs(1,:), ...
    'linewidth', 2);
quiver(real(apos), imag(apos), ...
    real(bpos-apos), imag(bpos-apos), 0, 'color', clrs(2,:), ...
    'linewidth', 2);
quiver(real(apos), imag(apos), ...
    real(copos-apos), imag(copos-apos), 0, '--', 'color', clrs(3,:), ...
    'linewidth', 2);
quiver(real(opos), imag(opos), ...
    real(dpos-opos), imag(dpos-opos), 0, 'k', ...
    'linewidth', 2);
plot(real(dpos), imag(dpos), 'ko', 'markersize', 12, 'linewidth', 2);
plot(real(dpos), imag(dpos), 'ks', 'markersize', 16, 'linewidth', 2);
quiver(real(dpos), imag(dpos), ...
    real(cpos-dpos), imag(cpos-dpos), 0, 'color', clrs(3,:), ...
    'linewidth', 2);
grid on;
axis square
axis off;
