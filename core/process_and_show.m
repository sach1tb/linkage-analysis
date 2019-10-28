function process_and_show(links, link_chains, t, units, poi, animate)


% --------- NO change beyond this point ---------------------------
% extract positions, velocities, and accelerations of all joint positions
pos = extract_positions(links, link_chains, t);
vel = extract_velocities(links, link_chains, t);
acc = extract_accelerations(links, link_chains,t);


% extract positions, velocities, and accelerations of CG of all links
cgpos = extract_positions_link(links, link_chains, t, pos);
cgvel = extract_velocities_link(links, link_chains, t, vel);
cgacc = extract_accelerations_link(links, link_chains,t, acc);


% extract positions, velocities, and accelerations of force application 
% points of all links
rfpos = extract_positions_rF(links, link_chains, t, pos);
rfvel = extract_velocities_rF(links, link_chains, t, vel);
rfacc = extract_accelerations_rF(links, link_chains,t, acc);

input_torque=calculate_input_torque(links, cgpos, cgvel, cgacc, ...
    rfpos, rfvel, rfacc, t);

% animatecomment if you don't want to see this
if animate
    for ii=1:numel(t)
        figure(1); gcf; clf;
        plot_linkage(pos,links, ii);
        drawnow;
    end
end
unitsarr=strsplit(units, '-');

figure(1); gcf; clf; % new figure window for plot
ii=1;
subplot(2,3,1);
plot_linkage(pos, links, ii);

fs=16;
subplot(2,3,2);
% plot the foot or end point trace here
xy=eval(['pos.', poi]);
plot (xy(1,:), xy(2,:), 'linewidth', 2); 
set(gca, 'fontsize', fs, 'fontname', 'times');
axis image;
grid on;
title('foot path');

subplot(2,3,3);
% plot the foot or end point trace here
xy=eval(['pos.', poi]);
plot(t, xy(1,:), 'linewidth', 2);
hold on;
plot(t, xy(2,:), 'linewidth', 2);
grid on;
set(gca, 'fontsize', fs, 'fontname', 'times');
xlabel('time (s)');
legend(['x (' , unitsarr{2}, ')'], ['y (' , unitsarr{2}, ')']);

subplot(2,3,4);
% plot the foot or end point trace here
xdot=eval(['vel.', poi]);
plot(t, sqrt(xdot(1,:).^2+xdot(2,:).^2), 'linewidth', 2);
grid on;
ytickformat('%.3f')
set(gca, 'fontsize', fs, 'fontname', 'times');
xlabel('time (s)');
ylabel(['speed (', unitsarr{2} , '/', unitsarr{3}, ')']);

subplot(2,3,5);
% plot the foot or end point trace here
xddot=eval(['acc.', poi]);
plot(t, sqrt(xddot(1,:).^2+xddot(2,:).^2), 'linewidth', 2);
grid on;
ytickformat('%.3f')
set(gca, 'fontsize', fs, 'fontname', 'times');
xlabel('time (s)');
ylabel(['acceleration (', unitsarr{2}, '/', unitsarr{3}, '^2)']);


subplot(2,3,6);
% plot the input torque
plot(t, input_torque, 'linewidth', 2);
grid on;
ytickformat('%.2f')
set(gca, 'fontsize', fs, 'fontname', 'times');
xlabel('time (s)');
ylabel(['input torque (', unitsarr{1}, ' ', unitsarr{2}, '^2/', unitsarr{3}, '^2)']);

