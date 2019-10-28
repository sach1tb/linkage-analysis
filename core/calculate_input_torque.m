function input_torque=calculate_input_torque(links, cgpos, cgvel, cgacc, rfpos, rfvel, rfacc, t)
ff=fieldnames(links);
% external forces
ext=zeros(1,numel(t));
for ii=1:numel(ff)
    try
    ext=dot(eval(['links.', ff{ii}, '.force'])'*ones(1,numel(t)), eval(['rfvel.', ff{ii}]))+ ext;
    catch
        keyboard
    end
end 
% inertial forces
inertf=zeros(1,numel(t));
for ii=1:numel(ff)
    inertf=eval(['links.', ff{ii}, '.mass'])* ...
        dot(eval(['cgacc.', ff{ii}]), eval(['cgvel.', ff{ii}]))+ inertf;
end

% inertial torques
inertt=zeros(1,numel(t));
for ii=1:numel(ff)
    inertt=eval(['links.', ff{ii}, '.moi'])* ...
        dot(eval(['links.', ff{ii}, '.alpha']), eval(['links.', ff{ii}, '.omega']))+ inertt;
end

input_torque=1/eval(['links.', ff{1}, '.omega'])*(inertt+inertf-ext);
