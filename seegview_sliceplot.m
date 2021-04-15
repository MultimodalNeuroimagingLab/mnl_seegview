% Plots slices that include electrodes <locs>
% Does not plot electrodes but uses locs to determine range of slices to plot
%
% KJM, minor edits by HH 2021
function [x_slice, y_slice, z_slice] = seegview_sliceplot(locs, V, x, y, z, slicethickness, scale)
% function [hax,hay,haz,x_slice,y_slice,z_slice]=seegview_sliceplot(locs,V,x,y,z,slicethickness)

%% 
if nargin < 7, scale = [0, 1]; end
if exist('slicethickness') ~= 1, slicethickness = 8; end

%% get cross-sectional planes

    % get x planes
    x_pts=(min(locs(:,1))+slicethickness/2):slicethickness:max(locs(:,1));
    for k=1:length(x_pts)
        [~, x_slice_inds(k)] = min(abs(x - x_pts(k)));
    end
    x_slice.images = V(x_slice_inds, :, :);
    x_slice.values = x(x_slice_inds);
    clear x_slice_inds x_pts

    % get y planes
    y_pts=(min(locs(:,2))+slicethickness/2):slicethickness:max(locs(:,2));
    for k=1:length(y_pts)
        [~, y_slice_inds(k)] = min(abs(y - y_pts(k)));
    end
    y_slice.images = V(:,y_slice_inds,:);
    y_slice.values = y(y_slice_inds);
    clear y_slice_inds y_pts

    % get z planes
    z_pts=(min(locs(:,3))+slicethickness/2):slicethickness:max(locs(:, 3));
    for k=1:length(z_pts)
        [~, z_slice_inds(k)] = min(abs(z - z_pts(k)));
    end
    z_slice.images=V(:,:,z_slice_inds);
    z_slice.values=z(z_slice_inds);
    clear z_slice_inds z_pts

    % assign each loc to closest slice in that axis
    for k=1:size(locs, 1)
        [~, x_slice.locs(k)] = min(abs(locs(k,1) - x_slice.values));
        [~, y_slice.locs(k)] = min(abs(locs(k,2) - y_slice.values));
        [~, z_slice.locs(k)] = min(abs(locs(k,3) - z_slice.values));
    end


%% generate plots

%% z - plotting (axial slices)
    figure('Position', [100, 500, 1000, 800]); haz = tight_subplot(ceil(length(z_slice.values)/5), 5, .01, .01, .01);
    for k=1:length(z_slice.values)    
        axes(haz(k))
        surf(x,y,.001*squeeze(z_slice.images(:,:,k)).'-100,'edgecolor','none'), view(0,90)
        colormap(gray),
        
        caxis([0.001*scale(1)-100, 0.001*scale(2)-100]);
        
        %tmp_inds=z_slice.locs==k;
        axis equal, axis off, axis tight
        text(min(x)+5, min(y)+10, -100, sprintf('z=%.1f', z_slice.values(k)), 'color', 'w');
    end
    z_slice.ha=haz;
    z_slice.perm = [1 2 3];

%% y - plotting (coronal slices)
    figure('Position', [700, 300, 1000, 800]); hay = tight_subplot(ceil(length(y_slice.values)/5),5,.01,.01,.01);
    for k=1:length(y_slice.values)    
        axes(hay(k))
        curr_image=y_slice.images(:,k,:);
        surf(x,z,.001*permute(curr_image,[1 3 2]).'-100,'edgecolor','none'), view(0,90)
        colormap(gray),
        
        caxis([0.001*scale(1)-100, 0.001*scale(2)-100]);
        
        %tmp_inds=y_slice.locs==k;
        axis equal, axis off, axis tight
        text(min(x)+5, min(z)+10, -100, sprintf('y=%.1f', y_slice.values(k)),'color', 'w')

    end
    y_slice.ha=hay;
    y_slice.perm=[1 3 2];

%% x - plotting (sagittal slices)
    figure('Position', [1300, 100, 1000, 800]); hax = tight_subplot(ceil(length(x_slice.values)/5),5,.01,.01,.01);
    for k=1:length(x_slice.values)    
        axes(hax(k))
        curr_image=x_slice.images(k,:,:);
        surf(y,z,.001*permute(curr_image,[2 3 1]).'-100,'edgecolor','none'), view(0,90)
        colormap(gray),
        
        caxis([0.001*scale(1)-100, 0.001*scale(2)-100]);
        
        %tmp_inds=x_slice.locs==k;
        axis equal, axis off, axis tight
        text(min(y)+5, min(z)+10, -100, sprintf('x=%.1f', x_slice.values(k)),'color', 'w')
    end
    x_slice.ha=hax;
    x_slice.perm=[2 3 1];    
 