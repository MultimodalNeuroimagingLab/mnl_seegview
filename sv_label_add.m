function sv_label_add(locs, loc_names, slice, msize)

    if nargin < 4, msize = 8; end % default marker (and text size)
    
    for k = 1:length(slice.values)
        axes(slice.ha(k))
        tmp_inds = slice.locs==k; % indices of electrodes corresponding to current slice
        sv_label_ax(locs(tmp_inds,slice.perm), loc_names(tmp_inds), msize)
    end
    
end

function sv_label_ax(els, lbls, msize)

    hold on, plot3(els(:,1), els(:,2), els(:,3), 'o', 'MarkerSize', msize, 'MarkerFaceColor', [.99 .99 .99], 'MarkerEdgeColor', 'k')
    for k=1:length(els(:,1)) % text size 1/5th of marker size
        text(els(k,1), els(k,2), els(k,3), lbls{k}, 'FontSize', msize*0.8, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'k')
    end
end

        
        
        