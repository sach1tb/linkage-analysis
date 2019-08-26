% solve fourbar position analysis using newton raphson method
% command fsolve needs the function name and an initial estimate. 
% the solution can go either way! 
% so open and crossed depends on the inital
% estimate
addpath ../core

clear variables

a=10; b=25; c=25; d=20;
x0 = [0.2,1.5];

t=0:.1:10; % time in seconds
omega=1; % angular velocity
t2=omega*t; % theta_2 is angular velocity x time
options = optimoptions('fsolve','Display','off');
for ii=1:numel(t)
    x(:,ii) = fsolve(@(x) vecloop4bar(x, a, b,c,d,t2(ii)), x0, options);
    x0=x(:,ii)'; % the next guess is the current solution
end
t3o=x(1,:);
t4o=x(2,:);
Px=10*cos(t2)+50*cos(t3o);
Py=10*sin(t2)+50*sin(t3o);
figure(1); gcf; clf; % new figure window for plot
plot (Px, Py, 'linewidth', 2); 
set(gca, 'fontsize', 24, 'fontname', 'times');
axis image;
grid on;
figure (2); gcf; clf;
plot(t, Px, 'linewidth', 2);
hold on;
plot(t, Py, 'linewidth', 2);
grid on;
set(gca, 'fontsize', 24, 'fontname', 'times');
xlabel('time (s)');
legend('P_x', 'P_y');

