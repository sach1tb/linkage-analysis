function pos=extract_positions(links, link_chains, t)

eval(['pos.', link_chains{1}, '=[zeros(1,numel(t)); zeros(1,numel(t))];']);

for ii=2:numel(link_chains)
    for jj=2:numel(link_chains{ii})
        if ~isfield(pos, link_chains{ii}(jj-1))
            error('link chains must be written so that a position that is needed in a later chain is requested earlier, see example above');
        end
        eval(['ll=links.', link_chains{ii}(jj), link_chains{ii}(jj-1), '.length;']);
        eval(['th=links.', link_chains{ii}(jj), link_chains{ii}(jj-1), '.theta;']);
        eval(['pos.', link_chains{ii}(jj), '=pos.' link_chains{ii}(jj-1), '+[ll.*cos(th); ll.*sin(th)];']);
    end
end
