function links=solve_vecloop(vecloop, config, links)
% ** (1) RAZ + RBA - RBY - RZY = 0

cellarr=strsplit(vecloop, ' ');

% check if it is valid
for jj=1:2:numel(cellarr)-2
    if ~isfield(links, cellarr{jj}(2:3)) && cellarr{jj}(2) ~=cellarr{jj}(3)
        error('check your vector loop equation');
    end
    % when a vector like RYY, RZZ is sent for a ternary link
    if ~isfield(links, cellarr{jj}(2:3)) && cellarr{jj}(2) ==cellarr{jj}(3)
        eval(['links.', cellarr{jj}(2:3), '= link(0, 0, 0, 0, 0, 0, 0, [0,0], 0);']);
    end
end

if numel(cellarr) ==9 % fourbar loop

a=eval(['links.', cellarr{1}(2:3), '.length;']);
b=eval(['links.', cellarr{3}(2:3), '.length;']);
c=eval(['links.', cellarr{5}(2:3), '.length;']);
d=eval(['links.', cellarr{7}(2:3), '.length;']);
alpha2=eval(['links.', cellarr{1}(2:3), '.alpha;']);
omega2=eval(['links.', cellarr{1}(2:3), '.omega;']);
theta2=eval(['links.', cellarr{1}(2:3), '.theta;']);
alpha1=eval(['links.', cellarr{7}(2:3), '.alpha;']);
omega1=eval(['links.', cellarr{7}(2:3), '.omega;']);
theta1=eval(['links.', cellarr{7}(2:3), '.theta;']);

if config ==1
    [alpha3, ~, alpha4, ~, omega3, ~, omega4, ~, theta3, ~, theta4]= ...
        fourbar_acceleration(a, b, c, d, alpha2, omega2, theta2, alpha1, omega1, theta1);
elseif config==2
    [~, alpha3, ~, alpha4, ~, omega3, ~, omega4, ~, theta3, ~, theta4]= ...
        fourbar_acceleration(a, b, c, d, alpha2, omega2, theta2, alpha1, omega1, theta1);
end


eval(['links.', cellarr{3}(2:3), '.alpha=alpha3;']);

eval(['links.', cellarr{5}(2:3), '.alpha=alpha4;']);

eval(['links.', cellarr{3}(2:3), '.omega=omega3;']);

eval(['links.', cellarr{5}(2:3), '.omega=omega4;']);

eval(['links.', cellarr{3}(2:3), '.theta=theta3;']);

eval(['links.', cellarr{5}(2:3), '.theta=theta4;']);
elseif numel(cellarr) ==5
    % RAB + RBA = 0;
    if cellarr{2} == '+'
        eval(['links.', cellarr{1}(2:3), '.theta=links.', cellarr{3}(2:3), '.theta+pi;']);
        eval(['links.', cellarr{1}(2:3), '.omega=links.', cellarr{3}(2:3), '.omega;']);
        eval(['links.', cellarr{1}(2:3), '.alpha=links.', cellarr{3}(2:3), '.alpha;']);
    % RAB - RCB = 0;    
    elseif cellarr{2} == '-'
        eval(['links.', cellarr{1}(2:3), '=links.', cellarr{3}(2:3), ';']);
    end
end