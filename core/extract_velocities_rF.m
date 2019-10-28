function rfvel=extract_velocities_rF(links, link_chains, t, vel)

ff=fieldnames(links);

for ii=1:numel(ff)
    % assume cg is always at center of the link
    eval(['ll=links.', ff{ii}, '.rF;']);
    eval(['th=links.', ff{ii}, '.theta;']);
    eval(['om=links.', ff{ii}, '.omega;']);
    eval(['rfvel.', ff{ii}, '=vel.' ff{ii}(2), '+[-ll*om.*sin(th); ll*om.*cos(th)];']);
end
