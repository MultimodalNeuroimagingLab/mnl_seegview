%% This function plots an interactive coronal slice, upon which the user can click to view corresponding axial/sagittal slices.
% Electrodes are plotted to each slice if they are within an input threshold distance.
%
%   Requires the vox2pos matrix in the nifti (bmat) to not contain off-diagonal (rotation/shear) values. If so, warning will appear and resulting electrodes
%   will be misaligned from slices (greater misalignment with more rotation)
%   Dependency: Uses SPM12 functions to load the nifti
%
%   slicesGUI(niiPath, electrodes);
%   slicesGUI(niiPath, electrodes, optsIn);
%       niiPath =           char, path to nifti brain image (which should already be ac-pc)
%       electrodes =        char or nx_ table, path to electrodes table file or electrodes table to plot.
%                               Must contain columns <name>, <x>, <y>, and <z>
%       optsIn =            (optional) struct, configurable options. Fields (not case-sensitive):
%           intialPos =     num, y-position of the coronal slice. Default = 0
%           clim =          1x2 double, color limits for the MRI scaled intensity. MRI voxels are normalized
%                               by their 99%ile intensity. Default limits are [0, 1], setting the 99%ile voxels to be white.
%           elecWidth =     num, distance threshold for electrodes to be plotted. Electrodes are plotted to each slice if they are
%                               < elecWidth distance away in the corresponding axis (x, y, or z). Default = inf (all electrodes plotted)
%           plotNames =     boolean, whether to plot electrode names. Default = false.
%
%   HH 2022/04
%
function handles = sliceGUI(niiPath, electrodes, optsIn)
    
    if ischar(electrodes) || isstring(electrodes)
        electrodes = readtable(electrodes, 'FileType', 'text', 'Delimiter', '\t');
    end

    % Configure opts
    
    opts.initialPos = 0;
    opts.clim = [0, 1];
    opts.elecWidth = inf;
    opts.plotNames = false;
    
    if exist('optsIn', 'var') && isa(optsIn, 'struct')
        inFields = fieldnames(optsIn);
        for ii = 1:length(inFields) % make case insensitive
            optsIn.(lower(inFields{ii})) = optsIn.(inFields{ii});
        end

        if isfield(optsIn, 'initialpos'), opts.initialPos = optsIn.initialpos; end
        if isfield(optsIn, 'clim'), opts.clim = optsIn.clim; end
        if isfield(optsIn, 'elecwidth'), opts.elecWidth = optsIn.elecwidth; end
        if isfield(optsIn, 'plotnames'), opts.plotNames = optsIn.plotnames; end
    end

    img = spm_vol(niiPath);
    bvol = spm_read_vols(img); % load brain image
    bmat = img.mat; % vox -> pos transformation
    
    % Permute bvol and bmat so it follows columns x, y, z
    [~, index] = sortrows(abs(bmat(1:3, 1:3)'), [1, 2, 3], 'descend');
    bvol = permute(bvol, index);
    bmat = bmat(:, [index; 4]); % only rearrange first 3 columns
    
    bmatCheck = bmat(1:3, 1:3); % to check if there are any rotations/shears
    if ~all(bmatCheck(~eye(3)) == 0)
        warning('vox2pos matrix has off-diagonal elements; slices are MISALIGNED from electrodes');
        disp(bmat);
    end
    
    bvol = bvol/prctile(bvol(:), 99); % image intensity
    [bvol, bmat] = clipVol(bvol, bmat, 0.15); % remove empty space
    
    locs = [electrodes.x, electrodes.y, electrodes.z];
    
    [x, y, z] = getAxPos(bvol, bmat); % Get positions (mm) along x, y, z axes of brain volume. This may need updating if bmat dimensions are permuted
    
    [~, yIdx] = min(abs(y - opts.initialPos));
    ySlice = squeeze(bvol(:, yIdx, :));
    yValue = y(yIdx);
    handles.f = figure('Position', [700, 300, 2000, 600]);
    
    handles.f.UserData = opts; % use to pass to callback
    
    % Slice orientations of the brain
    handles.axC = subplot('Position', [0, 0.1, 0.3, 0.8]); % coronal
    handles.axA = subplot('Position', [0.33, 0.1, 0.3, 0.8]); % axial
    handles.axS = subplot('Position', [0.66, 0.1, 0.3, 0.8]); % sagittal
    
    set(handles.axA, 'XTick', [], 'YTick', [], 'YDir', 'normal', 'DataAspectRatio', [1, 1, 1]);
    set(handles.axS, 'XTick', [], 'YTick', [], 'YDir', 'normal', 'DataAspectRatio', [1, 1, 1]);
    
    hold(handles.axC, 'on');
    
    handles.hClick = plot(handles.axC, min(x), min(z), '+', 'MarkerEdgeColor', 'r', 'MarkerSize', 0.001, 'LineWidth', 2); % handle on coronal slice tracking click
    
    % Plot electrodes to coronal slice
    locsC = locs(abs(locs(:, 2) - yValue) < opts.elecWidth, :);
    namesC = electrodes.name(abs(locs(:, 2) - yValue) < opts.elecWidth);
    handles.CElecs = plot(handles.axC, locsC(:, 1), locsC(:, 3), 'wo', 'MarkerFaceColor', 'w', 'MarkerSize', 3, 'ButtonDownFcn', {@btnCallback, handles, bvol, x, y, z, electrodes});
    
    % Plot static coronal slice
    imagesc(handles.axC, x, z, ySlice', 'ButtonDownFcn', {@btnCallback, handles, bvol, x, y, z, electrodes}, opts.clim); colormap(gray);
    set(handles.axC, 'XTick', [], 'YTick', [], 'YDir', 'normal', 'DataAspectRatio', [1, 1, 1], 'XLim', [min(x), max(x)], 'YLim', [min(z), max(z)]);
    text(handles.axC, min(x)+5, min(z)+10, sprintf('y=%.1f', yValue), 'color', 'w');
    h = get(handles.axC, 'Children');
    set(handles.axC, 'Children', [h(4), h(3), h(1), h(2)]); % arrange order: clicked cross > elecs > text > mri
    
    if opts.plotNames
        text(handles.axC, locsC(:, 1), locsC(:, 3), namesC, 'color', 'w', 'FontSize', 8, 'ButtonDownFcn', {@btnCallback, handles, bvol, x, y, z, electrodes});
    end
    
end

function btnCallback(~, ~, handles, bvol, x, y, z, electrodes)

    locs = [electrodes.x, electrodes.y, electrodes.z];
    
    pt = get(gca, 'CurrentPoint');
    xCurr = pt(1, 1); zCurr = pt(1, 2); % get x and z coordinates that are clicked
    
    % Set position of red cross
    set(handles.hClick, 'XData', xCurr, 'YData', zCurr, 'MarkerSize', 10);
    
    % Axial slice
    [~, zIdx] = min(abs(z - zCurr));
    zSlice = squeeze(bvol(:, :, zIdx));
    zValue = z(zIdx);
    
    imagesc(handles.axA, x, y, zSlice', handles.f.UserData.clim); colormap(gray);
    hold(handles.axA, 'on');
    text(handles.axA, min(x)+5, min(y)+10, sprintf('z=%.1f', zValue), 'color', 'w');
    
    locsA = locs(abs(locs(:, 3) - zValue) < handles.f.UserData.elecWidth, :); % plot electrodes
    namesA = electrodes.name(abs(locs(:, 3) - zValue) < handles.f.UserData.elecWidth);
    plot(handles.axA, locsA(:, 1), locsA(:, 2), 'wo', 'MarkerFaceColor', 'w', 'MarkerSize', 3);
    if handles.f.UserData.plotNames
        text(handles.axA, locsA(:, 1), locsA(:, 2), namesA, 'color', 'w', 'FontSize', 8);
    end
    set(handles.axA, 'XTick', [], 'YTick', [], 'YDir', 'normal', 'DataAspectRatio', [1, 1, 1], 'XLim', [min(x), max(x)], 'YLim', [min(y), max(y)]);
    hold(handles.axA, 'off');
    
    % Sagittal slice
    [~, xIdx] = min(abs(x - xCurr));
    xSlice = squeeze(bvol(xIdx, :, :));
    xValue = x(xIdx);
    
    imagesc(handles.axS, y, z, xSlice', handles.f.UserData.clim); colormap(gray); hold(handles.axS, 'on');
    text(handles.axS, min(y)+5, min(z)+10, sprintf('x=%.1f', xValue), 'color', 'w');
    
    locsS = locs(abs(locs(:, 1) - xValue) < handles.f.UserData.elecWidth, :);
    namesS = electrodes.name(abs(locs(:, 1) - xValue) < handles.f.UserData.elecWidth);
    plot(handles.axS, locsS(:, 2), locsS(:, 3), 'wo', 'MarkerFaceColor', 'w', 'MarkerSize', 3);
    if handles.f.UserData.plotNames
        text(handles.axS, locsS(:, 2), locsS(:, 3), namesS, 'color', 'w', 'FontSize', 8);
    end
    set(handles.axS, 'XTick', [], 'YTick', [], 'YDir', 'normal', 'DataAspectRatio', [1, 1, 1], 'XLim', [min(y), max(y)], 'YLim', [min(z), max(z)]);
    hold(handles.axS, 'off');
    
    % store axial and sagittal slice values for passing
    handles.f.UserData.zValue = zValue;
    handles.f.UserData.xValue = xValue;
end