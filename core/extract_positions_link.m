function cgpos=extract_positions_link(links, link_chains, t, pos)

ff=fieldnames(links);

for ii=1:numel(ff)
    % assume cg is always at center of the link
    eval(['ll=links.', ff{ii}, '.length/2;']);
    eval(['th=links.', ff{ii}, '.theta;']);
    eval(['cgpos.', ff{ii}, '=pos.' ff{ii}(2), '+[ll.*cos(th); ll.*sin(th)];']);
end
