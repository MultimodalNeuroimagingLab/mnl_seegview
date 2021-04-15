
function locs = indexfix(O_info, elecmatrix, rot_mat_acpc)
% function [mat2, vol2]=matfix(mat,vol)
% matrix pre-process, rotations and inversions
% O_info is the brain_info from the original (raw) matrix, before matfix & recentering
% for N x 3 matrix of indices into the volume that O_info.mat describes
% it adjusts it the same way matfix works
% 
% kjm 8/2020
% comments, stylistic changes by HH 2021

%%
    mat=O_info.mat;
    vol_dims=O_info.dim;
    elecmatrix0=pos2vox(mat,elecmatrix);   % transformation fom original mm to original voxel indices
    c=sign(sum(mat(1:3,1:3),1)).*(sum(mat(1:3,1:3).^2).^.5);

%% same transforms as those applied to volume - 1 see if matrix needs to be rotated
    [~, b]=max(abs(mat(1:3,1:3)),[],2);
    if length(unique(b))<3
        b=[unique(b); setdiff((1:3)', b)];
    end
    
    elecmatrix2=elecmatrix0(:,b);
    c=c(b);
    vol_dims=vol_dims(b);

%% same transforms as those applied to volume - 2 see if matrix needs to be reflected
%     if c(1)<0, vol2=vol2(end:-1:1,:,:); c(1)=-c(1); end
    elecmatrix3=elecmatrix2;    
    for k=1:3
        if c(k)<0, elecmatrix3(:,k)=vol_dims(k)-elecmatrix2(:,k); c(k)=-c(k); end
    end

%% recenter at acpc % not necessary after using debugged rot_mat_acpc, which applies correct translation
%     acpc_mcp=(AC+PC)/2; % mid-commisural point, in voxels
%     elecmatrix4=elecmatrix3-ones(size(elecmatrix2,1),1)*acpc_mcp; % re-center image on mcp
%     locs=elecmatrix4*rot_mat_acpc(1:3,1:3).'; % voxels, centered at acpc -> new acpc pos

%% apply transformation to locs from voxels -> acpc position

locs = (rot_mat_acpc*[elecmatrix3, ones(size(elecmatrix3, 1), 1)]')';
locs = locs(:, 1:3);
  
%%         
%clear a ans b  brain c channel_names elecmatrix0 elecmatrix2 elecmatrix3 k  lead_names lead_nr  locs0 locs1 mat tmp vol_dims  
