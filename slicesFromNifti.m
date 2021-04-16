%% This function plots slices from an input nifti along the x, y, and z directions, and plots electrodes to the slices.
%   It is a convenient wrapper to apply just the slice_plot part of the SEEG_view package when the brain image and
%   electrodes are already in AC-PC space.
%   Dependency: Uses SPM12 functions to load the nifti
%
%   slicesFromNifti(niiPath, electrodes);
%   slicesFromNifti(niiPath, electrodes, slicethickness, wts, clim);
%       niiPath =           str, path to nifti brain image (which should already be ac-pc)
%       electrodes =        nx_ table, table of electrodes to plot. Must have columns <name>, <x>, <y>, and <z>
%       slicethickness =    num (optional), distance in mm between consecutive slices. Default = 8
%       wts =               nx1 double (optional), plot weights corresponding to electrodes. If none given, electrodes
%                           will be plotted with labelled names.
%       clim =              1x2 double (optional), color limits for the MRI scaled intensity. MRI voxels are normalized
%                           by their 99%ile intensity. Default limits are [0, 1], setting the 99%ile voxels to be white.
%
%   Returns:
%       x_slice =           slice object in x direction
%       y_slice =           slice object in y direction
%       z_slice =           slice object in z direction
%
%   HH 2021
%
function [x_slice, y_slice, z_slice] = slicesFromNifti(niiPath, electrodes, slicethickness, wts, clim)
    
    if ~exist('clim', 'var') || isempty(clim), clim = [0, 1]; end
    if ~exist('slicethickness', 'var') || isempty(slicethickness), slicethickness = 8; end

    img = spm_vol(niiPath);
    bvol = spm_read_vols(img); % load brain image
    bmat = img.mat; % vox -> pos transformation
    
    bvol = bvol/prctile(bvol(:), 99); % image intensity
    [bvol, bmat] = clipVol(bvol, bmat, 0.1); % renove empty space
    
    locs = [electrodes.x, electrodes.y, electrodes.z];
    
    [x, y, z] = getAxPos(bvol, bmat); % Get positions (mm) along x, y, z axes of brain volume
    
    [x_slice, y_slice, z_slice] = seegview_sliceplot(locs, bvol, x, y, z, slicethickness, clim);
    
    if exist('wts', 'var') && ~isempty(wts)
        assert(length(wts) == size(locs, 1), 'length of wts (%d) does not match number of electrodes (%d)', length(wts), height(electrodes));
        sv_weight_add(locs, wts, x_slice, 0.1);
        sv_weight_add(locs, wts, y_slice, 0.1);
        sv_weight_add(locs, wts, z_slice, 0.1);
    else
        sv_label_add(locs, electrodes.name, x_slice);
        sv_label_add(locs, electrodes.name, y_slice);
        sv_label_add(locs, electrodes.name, z_slice);
    end
    
end