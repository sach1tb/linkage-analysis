function plot_linkage(p, ll, ii)

ff=fieldnames(p);
lnks=fieldnames(ll);

% plot all points
for jj=1:numel(ff)
    xyjj=eval(['p.', ff{jj}, '(:,', sprintf('%d', ii), ')']);
    plot(xyjj(1), xyjj(2), 'o');
    hold on;
    for kk=jj+1:numel(ff) 
        % connect points using lines based on if their link length is
        % specified
        if ismember([ff{kk}, ff{jj}], lnks) || ismember([ff{jj}, ff{kk}], lnks)
            xykk=eval(['p.', ff{kk}, '(:,', sprintf('%d', ii), ')']);
            plot([xyjj(1), xykk(1)], [xyjj(2), xykk(2)], '-.');
        end
    end
    text(xyjj(1)*1.1, xyjj(2)*1.1, ff{jj}, 'fontsize', 16);
end

axis image;
eval(['sc=ll.',lnks{1}, '.length + ll.',lnks{2}, '.length + ll.',...
    lnks{3}, '.length + ll.',lnks{4}, '.length; ']);
axis([-sc sc -sc sc]);
axis off;