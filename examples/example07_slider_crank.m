function example07_slider_crank(a,b,c,d,cfg)

addpath ../core

% see slidercrank.png to visualize the parameters

% link lengths
if nargin < 1
    % Example 4-3 in Norton
    a=40; b=120; c=-20; 
    d=100; % mm
    cfg=0; % one for open and 0 for cross
end

% *** Processing ***

figure(1); gcf; clf;

if cfg
    [~, t2, ~, t3]=slidercrank_position(a, b, c, d);
else
    [t2, ~, t3]=slidercrank_position(a, b, c, d);
end
% can still use cs plot because its the same linkage
cs_plot(a,b,c,d, t2, t3, 0, eye(3));
drawnow;

