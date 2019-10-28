function links=add_links(links)
% this function adds the missing link position vectors 
ff=fieldnames(links);
for ii=1:numel(ff)
    eval(['links.', ff{ii}(2:-1:1), '= link(0, 0, 0, 0, 0, 0, 0, [0,0], 0);']);
    eval(['links.', ff{ii}(2:-1:1), '.length=links.', ff{ii}, '.length;']);
    eval(['links.', ff{ii}(2:-1:1), '.theta=links.', ff{ii}, '.theta+pi;']);
end