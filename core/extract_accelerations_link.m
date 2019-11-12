function cgacc=extract_accelerations_link(links, link_chains, t, acc)

ff=fieldnames(links);

for ii=1:numel(ff)
    % assume cg is always at center of the link
    eval(['ll=links.', ff{ii}, '.length/2;']);
    eval(['th=links.', ff{ii}, '.theta;']);
    eval(['om=links.', ff{ii}, '.omega;']);
    eval(['al=links.', ff{ii}, '.alpha;']);
    eval(['cgacc.', ff{ii}, '=acc.' ff{ii}(2), '+[-ll.*al.*sin(th) - ll.*om.^2.*cos(th); ll.*al.*cos(th) - ll.*om.^2.*sin(th)];']);
end