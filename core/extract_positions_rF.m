function rfpos=extract_positions_rF(links, link_chains, t, pos)

ff=fieldnames(links);

for ii=1:numel(ff)
    % assume cg is always at center of the link
    eval(['ll=links.', ff{ii}, '.rF;']);
    eval(['th=links.', ff{ii}, '.theta;']);
    eval(['rfpos.', ff{ii}, '=pos.' ff{ii}(2), '+[ll*cos(th); ll*sin(th)];']);
end