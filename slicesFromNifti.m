%% This function plots slices from an input nifti along the x, y, and z directions, and plots electrodes to the slices.
%   It is a convenient wrapper to apply just the slice_plot part of the SEEG_view package when the brain image and
%   electrodes are already in AC-PC space. Requires the vox2pos matrix in the nifti (bmat) to not contain off-diagonal (rotation/shear) values.
%   If so, warning will appear and resulting electrodes will be misaligned from slices (greater misalignment with more rotation)
%   Dependency: Uses SPM12 functions to load the nifti
%
%   slicesFromNifti(niiPath, electrodes);
%   slicesFromNifti(niiPath, electrodes, slicethickness, wts, clim);
%       niiPath =           char, path to nifti brain image (which should already be ac-pc)
%       electrodes =        char or nx_ table, path to electrodes table file or electrodes table to plot.
%                               Must contain columns <name>, <x>, <y>, and <z>
%       slicethickness =    num (optional), distance in mm between consecutive slices. Default = 8
%       wts =               nx1 double (optional), plot weights corresponding to electrodes. If none given, electrodes
%                           will be plotted with labelled names.
%       clim =              1x2 double (optional), color limits for the MRI scaled intensity. MRI voxels are normalized
%                           by their 99%ile intensity. Default limits are [0, 1], setting the 99%ile voxels to be white.
%       wm =                num (optional), maximum weight to clip wts when wts are given (all values >= wm are plotted with maximum size and intensity)
%       plotNames =         bool (optional), if true (default), electrode names are plotted to each electrode when wts are not given.
%
%   Returns:
%       x_slice =           slice object in x direction
%       y_slice =           slice object in y direction
%       z_slice =           slice object in z direction
%
%   HH 2021
%   Updated 2021/06/29 to allow for electrodes input as path
%   Updated 2022/07/22 with additional plotNames input
%
function [x_slice, y_slice, z_slice] = slicesFromNifti(niiPath, electrodes, slicethickness, wts, clim, wm, plotNames)
    
    if ~exist('clim', 'var') || isempty(clim), clim = [0, 1]; end
    if ~exist('slicethickness', 'var') || isempty(slicethickness), slicethickness = 8; end
    if ischar(electrodes) || isstring(electrodes)
        electrodes = readtable(electrodes, 'FileType', 'text', 'Delimiter', '\t', 'TreatAsEmpty', 'n/a');
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
    [bvol, bmat] = clipVol(bvol, bmat, 0.1); % renove empty space
    
    locs = [electrodes.x, electrodes.y, electrodes.z];
    
    [x, y, z] = getAxPos(bvol, bmat); % Get positions (mm) along x, y, z axes of brain volume; assumes no rotations/shearing in bmat
    
    [x_slice, y_slice, z_slice] = seegview_sliceplot(locs, bvol, x, y, z, slicethickness, clim);
    
    if exist('wts', 'var') && ~isempty(wts)
        if ~exist('wm', 'var') || isempty(wm), wm = max(abs(wts)); end
        
        assert(length(wts) == size(locs, 1), 'length of wts (%d) does not match number of electrodes (%d)', length(wts), height(electrodes));
        sv_weight_add(locs, wts, x_slice, 0.1, wm);
        sv_weight_add(locs, wts, y_slice, 0.1, wm);
        sv_weight_add(locs, wts, z_slice, 0.1, wm);
    else
        if exist('plotNames', 'var') && ~plotNames
            sv_label_add(locs, [], x_slice);
            sv_label_add(locs, [], y_slice);
            sv_label_add(locs, [], z_slice);
        else % plot names to each electrode (default behavior)
            sv_label_add(locs, electrodes.name, x_slice);
            sv_label_add(locs, electrodes.name, y_slice);
            sv_label_add(locs, electrodes.name, z_slice);
        end
    end
    
end