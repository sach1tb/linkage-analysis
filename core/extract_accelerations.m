function acc=extract_accelerations(links, link_chains, t)

eval(['acc.', link_chains{1}, '=[zeros(1,numel(t)); zeros(1,numel(t))];']);

for ii=2:numel(link_chains)
    for jj=2:numel(link_chains{ii})
        if ~isfield(acc, link_chains{ii}(jj-1))
            error('link chains must be written so that a position that is needed in a later chain is requested earlier, see example above');
        end
        eval(['ll=links.', link_chains{ii}(jj), link_chains{ii}(jj-1), '.length;']);
        eval(['th=links.', link_chains{ii}(jj), link_chains{ii}(jj-1), '.theta;']);
        eval(['om=links.', link_chains{ii}(jj), link_chains{ii}(jj-1), '.omega;']);
        eval(['al=links.', link_chains{ii}(jj), link_chains{ii}(jj-1), '.alpha;']);
        eval(['acc.', link_chains{ii}(jj), '=acc.' link_chains{ii}(jj-1), '+[-ll.*al.*sin(th) - ll.*om.^2.*cos(th); ll.*al.*cos(th) - ll.*om.^2.*sin(th)];']);
    end
end