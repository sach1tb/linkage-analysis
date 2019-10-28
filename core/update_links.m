function links=update_links(links)
% this function updates the link angles every time an analysis is performed 
ff=fieldnames(links);
for ii=1:numel(ff)
    eval(['links.', ff{ii}(2:-1:1), '.theta=links.', ff{ii}, '.theta+pi;']);
end