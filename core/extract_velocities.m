function vel=extract_velocities(links, link_chains, t)

eval(['vel.', link_chains{1}, '=[zeros(1,numel(t)); zeros(1,numel(t))];']);

for ii=2:numel(link_chains)
    for jj=2:numel(link_chains{ii})
        if ~isfield(vel, link_chains{ii}(jj-1))
            error('link chains must be written so that a position that is needed in a later chain is requested earlier, see example above');
        end
        eval(['ll=links.', link_chains{ii}(jj), link_chains{ii}(jj-1), '.length;']);
        eval(['th=links.', link_chains{ii}(jj), link_chains{ii}(jj-1), '.theta;']);
        eval(['om=links.', link_chains{ii}(jj), link_chains{ii}(jj-1), '.omega;']);
        eval(['vel.', link_chains{ii}(jj), '=vel.' link_chains{ii}(jj-1), '+[-ll.*om.*sin(th); ll.*om.*cos(th)];']);
    end
end