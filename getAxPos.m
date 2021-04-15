% Returns axes positions of input brain image voxels
%       bvol =      nxmxp
%       bmat =      4x4
%
%   Returns:
%       x =         nx1
%       y =         mx1
%       z =         px1
function [x, y, z] = getAxPos(bvol, bmat)
    x = (1:size(bvol, 1)).'*bmat(1, 1) + bmat(1, 4); % left -> right
    y = (1:size(bvol, 2)).'*bmat(2, 2) + bmat(2, 4); % posterior -> anterior
    z = (1:size(bvol, 3)).'*bmat(3, 3) + bmat(3, 4); % inferior -> superior
end