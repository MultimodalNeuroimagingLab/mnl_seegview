function sv_weight_add(locs, plot_wts, slice, threshFrac)
    
    if nargin < 4, threshFrac = 0; end % abs(values) below threshFrac*wm deemed not significant

    plot_wts(isnan(plot_wts)) = 0;
    
    %% scale to maximum across slices
    wm=max(abs(plot_wts));

    %% plotting add - cycle through slices
    for k=1:length(slice.values)    
        axes(slice.ha(k))
        tmp_inds = slice.locs==k;
        sv_weight_ax(locs(tmp_inds,slice.perm), plot_wts(tmp_inds), wm, threshFrac)
    end
end
    
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
function sv_weight_ax(els, wts, wm, threshFrac)

%%
% wm=max(abs(wts));
els(isnan(els))=0;
pthresh = threshFrac*wm;

%% plot weights
    hold on
    for q=1:size(els,1)% add activity colorscale
%         if abs(els(q,3)-k)<3 % plot only those near current slice
            if abs(wts(q)) < pthresh % not significant
                % dark gray
                plot(els(q,1), els(q,2), 'o', ...
                'MarkerSize', 3, ...
                'MarkerEdgeColor', 0.98*[1 1 1], ...
                'MarkerFaceColor', 0.35*[1 1 1]);
            
            elseif wts(q) >= pthresh
                % red
                plot(els(q,1), els(q,2), 'o', ...
                'MarkerSize', 6*wts(q)/wm + 3, ...
                'MarkerEdgeColor', 0.98*[1 1 1], ...
                'MarkerFaceColor', 0.99*[1 1 - wts(q)/wm 1 - wts(q)/wm]);
                
            elseif wts(q) <= (-pthresh)
                % blue
                plot(els(q,1), els(q,2), 'o', ...
                'MarkerSize', -6*wts(q)/wm + 3, ...
                'MarkerEdgeColor', 0.98*[1 1 1], ...
                'MarkerFaceColor', 0.99*[1 + wts(q)/wm 1 + wts(q)/wm 1]);
            
            end
    end
    hold off
end
        