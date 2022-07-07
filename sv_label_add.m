function sv_label_add(locs, loc_names, slice, msize)

    if nargin < 4, msize = 9; end % default marker (and text size)
    
    if isempty(loc_names)
        
        for k = 1:length(slice.values)
            axes(slice.ha(k))
            tmp_inds = slice.locs==k; % indices of electrodes corresponding to current slice
            sv_label_ax(locs(tmp_inds,slice.perm), [], msize) % plot electrodes without labels
        end
        
    else
    
        for k = 1:length(slice.values)
            axes(slice.ha(k))
            tmp_inds = slice.locs==k;
            sv_label_ax(locs(tmp_inds,slice.perm), loc_names(tmp_inds), msize) % plot electrodes and add label names
        end
        
    end
    
end

function sv_label_ax(els, lbls, msize)

    hold on, plot3(els(:,1), els(:,2), els(:,3), 'o', 'MarkerSize', msize, 'MarkerFaceColor', [.99 .99 .99], 'MarkerEdgeColor', 'k')
    if isempty(lbls), return; end
    for k=1:length(els(:,1)) % text size 1/5th of marker size
        text(els(k,1), els(k,2), els(k,3), lbls{k}, 'FontSize', msize*0.8, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'r')
    end
end

        
        
        