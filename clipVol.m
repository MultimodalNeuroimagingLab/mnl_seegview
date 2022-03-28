% Removes voxels from bvol with signal < thresh, and clips out all slices without any voxels
%   [bvol, bmat] = clipVol(bvol, bmat, thresh)
%       bvol =      nxmxp, 3D brain volume, where each entry is a voxel
%       bmat =      4x4, transformation matrix from voxels -> position
%       thresh =    (optional) 1x1, threshold below which signal is set to 0
%
%   KJM 2021
%   updated by HH, 2021
%
function [bvol, bmat] = clipVol(bvol, bmat, thresh)
    
    if nargin < 3, thresh = 0.05; end

    % Limit volume to slices with at least 1 voxel passing thresh. Logical method is non-destructive to voxels within
    % the volume to keep
    bvol_logical = bvol > thresh; % logical volume corresponding to voxels > thresh
    
    % ensure clipping is done for consecutive series of indices
    bx = find(squeeze(sum(sum(bvol_logical, 2), 3)), 1, 'first'):find(squeeze(sum(sum(bvol_logical, 2), 3)), 1, 'last'); % slices with at least some signal
    by = find(squeeze(sum(sum(bvol_logical, 1), 3)), 1, 'first'):find(squeeze(sum(sum(bvol_logical, 1), 3)), 1, 'last'); 
    bz = find(squeeze(sum(sum(bvol_logical, 1), 2)), 1, 'first'):find(squeeze(sum(sum(bvol_logical, 1), 2)), 1, 'last'); 

    bvol = bvol(bx, by, bz); % reassign brain image, update transformation matrix accordingly
    bmat(1:3, 4) = bmat(1:3, 4)+[(bx(1)-1)*bmat(1,1); (by(1)-1)*bmat(2,2); (bz(1)-1)*bmat(3,3)];
end