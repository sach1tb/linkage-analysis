function rfacc=extract_accelerations_rF(links, link_chains, t, acc)

ff=fieldnames(links);

for ii=1:numel(ff)
    % assume cg is always at center of the link
    eval(['ll=links.', ff{ii}, '.rF;']);
    eval(['th=links.', ff{ii}, '.theta;']);
    eval(['om=links.', ff{ii}, '.omega;']);
    eval(['al=links.', ff{ii}, '.alpha;']);
    eval(['rfacc.', ff{ii}, '=acc.' ff{ii}(2), '+[-ll*al.*sin(th) - ll*om.^2.*cos(th); ll*al.*cos(th) - ll*om.^2.*sin(th)];']);
end