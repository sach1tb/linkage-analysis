function ics_plot(a,b,c,d,t2,t3,t4,t1, clrs)


% fourbar plot automatically adds ground orientation
opos=0*exp(1i*t1);
apos=a*exp(1i*(t1+t2));
dpos=d*exp(1i*t1);
cpos=d*exp(1i*t1)+c*exp(1i*t4);


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

% coupler
% quiver(real(apos), imag(apos), ...
%     real(ppos-apos), imag(ppos-apos), 0, '.', 'color', clrs(3,:), ...
%     'linewidth', 2);

plot([real(apos),  real(cpos)]', [imag(apos), imag(cpos)]', 'g-', ...
                                'markersize', 10, 'linewidth', 4);

% output                            
plot([real(cpos), real(dpos)]', [imag(cpos), imag(dpos)]', 'b-s', ...
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