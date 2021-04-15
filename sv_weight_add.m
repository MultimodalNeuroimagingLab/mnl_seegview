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
            if abs(wts(q))<pthresh % not significant
                % black circle
                plot(els(q,1),els(q,2),'.',...
                'MarkerSize',11.5,...
                'Color',.98*[1 1 1])  
                % gray inner
                plot(els(q,1),els(q,2),'.',...
                'MarkerSize',10,...
                'Color',.35*[1 1 1])  
                %
            elseif wts(q)>=pthresh
                % black circle
                plot(els(q,1),els(q,2),'.',...
                'MarkerSize',15*abs(wts(q))/wm+11.5,...
                'Color',.98*[1 1 1])
                % colored inner
                plot(els(q,1),els(q,2),'.',...
                'MarkerSize',15*abs(wts(q))/wm+10,...
                'Color',.99*[1 1-wts(q)/wm 1-wts(q)/wm])
                %
            elseif wts(q)<=(-pthresh)
                % black circle
                plot(els(q,1),els(q,2),'.',...
                'MarkerSize',15*abs(wts(q))/wm+11.5,...
                'Color',.98*[1 1 1])
                %
                plot(els(q,1),els(q,2),'.',...
                'MarkerSize',15*abs(wts(q))/wm+10,...
                'Color',.99*[1+wts(q)/wm 1+wts(q)/wm 1])
            end
%         end
    end
    hold off
end
        