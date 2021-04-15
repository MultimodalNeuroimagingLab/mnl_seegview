function sv_cortex_plot(cortex,locs,th,phi,wts)

%%  plot brain and look at locations
    figure
    k=60; % amount of transparency
    brain_handle=kjm_ctmr_gauss_plot(cortex,[0 0 0],0); 
    brain_handle.FaceAlpha=k/100;
%     el_add(locs,[0 0 0],30)
%     el_add(locs,[.5 1 .5],25)
    loc_view(90,45)
    
%%

rb_dot_surf_view_SEEG(cortex,locs,wts,th,phi)
%%


function rb_dot_surf_view_SEEG(brain,locs,wts,th,phi)

% this function plots the colored dots off of the brain in the direction
% that they will be viewed


lcm=max(abs(wts));



if lcm>0 % need to just have all gray if none significant


for k=1:size(locs,1)% add activity colorscale
    if abs(wts(k))<(.05*lcm)
        hold on, plot3(locs(k,1),locs(k,2),locs(k,3),'.',...
        'MarkerSize',23,...
        'Color',.01*[1 1 1])  
        %
        hold on, plot3(locs(k,1),locs(k,2),locs(k,3),'.',...
        'MarkerSize',20,...
        'Color',.35*[1 1 1])  
        %
    elseif wts(k)>=(.05*lcm)
        %
        hold on, plot3(locs(k,1),locs(k,2),locs(k,3),'.',...
        'MarkerSize',30*abs(wts(k))/lcm+23,...
        'Color',.01*[1 1 1])
        %
        hold on, plot3(locs(k,1),locs(k,2),locs(k,3),'.',...
        'MarkerSize',30*abs(wts(k))/lcm+20,...
        'Color',.99*[1 1-wts(k)/lcm 1-wts(k)/lcm])
        %
    elseif wts(k)<=(-.05*lcm)
        %
        hold on, plot3(locs(k,1),locs(k,2),locs(k,3),'.',...
        'MarkerSize',30*abs(wts(k))/lcm+23,...
        'Color',.01*[1 1 1])
        %
        hold on, plot3(locs(k,1),locs(k,2),locs(k,3),'.',...
        'MarkerSize',30*abs(wts(k))/lcm+20,...
        'Color',.99*[1+wts(k)/lcm 1+wts(k)/lcm 1])
    end
end

else % all gray dots if none significant
    for k=1:size(locs,1)
        hold on, plot3(locs(k,1),locs(k,2),locs(k,3),'.',...
        'MarkerSize',23,...
        'Color',.01*[1 1 1])  
        %
        hold on, plot3(locs(k,1),locs(k,2),locs(k,3),'.',...
        'MarkerSize',20,...
        'Color',.35*[1 1 1]) 
    end
end

if exist('chan')% add in electrode used for coherence with
% hold on, plot3(locs(chan,1),locs(chan,2),locs(chan,3),'.',...
%         'MarkerSize',30,...
%         'Color',[0 0 0])  
% hold on, plot3(locs(chan,1),locs(chan,2),locs(chan,3),'.',...
%         'MarkerSize',25,...
%         'Color',[0 .5 0])
% end  


hold on, plot3(locs(chan,1),locs(chan,2),locs(chan,3),'.',...
        'MarkerSize',30,...
        'Color',[0 0 0])  
    
hold on, plot3(locs(chan,1),locs(chan,2),locs(chan,3),'.',...
        'MarkerSize',25,...
        'Color',.99*[1 1 1]) 
    
    hold on, plot3(locs(chan,1),locs(chan,2),locs(chan,3),'k*',...
        'MarkerSize',15,...
        'Color',[0 0 0])  
end
    




loc_view(th,phi)





