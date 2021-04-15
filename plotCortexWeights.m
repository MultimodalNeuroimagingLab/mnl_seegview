%
% Modified by HH 2021
%
function plotCortexWeights(locs, wts, threshFrac)

    if nargin < 3, threshFrac = 0; end % abs(values) below threshFrac*wm deemed not significant

    wts(isnan(wts)) = 0;
    
    % this function plots colored dots in brain rendering
    wm=max(abs(wts));
    pthresh = threshFrac*wm;

    hold on
    for k=1:size(locs,1)
        if abs(wts(k)) < pthresh % insignificant
            plot3(locs(k,1),locs(k,2),locs(k,3),'.',...
            'MarkerSize',23,...
            'Color',.01*[1 1 1])  
            
            plot3(locs(k,1),locs(k,2),locs(k,3),'.',...
            'MarkerSize',20,...
            'Color',.35*[1 1 1])  
            
        elseif wts(k) >= pthresh % positively significant
            
            plot3(locs(k,1),locs(k,2),locs(k,3),'.',...
            'MarkerSize',30*abs(wts(k))/wm+23,...
            'Color',.01*[1 1 1])
            
            hold on, plot3(locs(k,1),locs(k,2),locs(k,3),'.',...
            'MarkerSize',30*abs(wts(k))/wm+20,...
            'Color',.99*[1 1-wts(k)/wm 1-wts(k)/wm])
            
        else % negatively significant
            plot3(locs(k,1),locs(k,2),locs(k,3),'.',...
            'MarkerSize',30*abs(wts(k))/wm+23,...
            'Color',.01*[1 1 1])
            
            plot3(locs(k,1),locs(k,2),locs(k,3),'.',...
            'MarkerSize',30*abs(wts(k))/wm+20,...
            'Color',.99*[1+wts(k)/wm 1+wts(k)/wm 1])
        end
    end
    hold off
    
end