function acpc_reslice(data)
% function dbsreslice --- this is a rebuild of hippotaxy(data), to reslice
% dbs shank and sites into a pseudocoronal plane
%     Called by function kjm_DBS_parse. Part of the "Hippotaxy" tool.
%     This is a program for rotating and reslicing brain imaging data into
%     Hippocampal stereotactic space, as described by the manuscript:
%     "Hippocampal stereotaxy: A novel mesial temporal stereotactic
%     coordinate system", by Kai Miller and colleagues, and is currently in
%     submission. Please cite this manuscript in any setting (manuscripts,
%     talks) where this program was used. 
%     
%     Copyright (C) 2015, Kai J Miller, Stanford Neurosurgery
%     kai.miller@stanford.edu, kjmiller@gmail.com
%
% Edited by HH 2021, notably line 75 was debugged by removing duplicated transformation of acpc_mcp by
%   brain_info.mat(1:3, 1:3). Now rot_mat_acpc will apply correct translation to UNCENTERED orig voxels

%% ac-pc vector
    acmpc=data.AC-data.PC;
    acmpc=acmpc*data.brain_info.mat(1:3,1:3);
    acpc_vec=(acmpc)/(sum((acmpc).^2).^.5);
%     acpc_vec=(data.AC-data.PC)/(sum((data.AC-data.PC).^2).^.5); %unit norm ac-pc vector
    
%% mid-commisural point    
    acpc_mcp=(data.AC+data.PC)/2; % mid-commisural point
    data.brain_info.mat(1:3,4) = -data.brain_info.mat(1:3,1:3)*acpc_mcp.'; % re-center image on mcp

%% plane of midline symmetry
    MLPlanepts=[data.AC; data.PC; data.ML1; data.ML2; data.ML3];
    [pc_vecs,tmp,pc_vals]=pca(MLPlanepts); 
    [tmp,n]=min(abs(pc_vals)); %smallest eigenvalue = normal to plane   
    MLPlane_vec=pc_vecs(:,n).'; % vector defining norm of plane of symmetry (midline plane)
    %     NOTE: need to insert automatic left-right check, and reflect MLPlane vec if pointing to left (because PCA can have "arbitrary" inversions.
    VD_vec=cross(MLPlane_vec,acpc_vec); % ventral-dorsal vector

%%  set up rotation tracker
    dpts=[[MLPlane_vec];...
        [acpc_vec];...
        [VD_vec];...
        [0 0 0]];

%% first need to rotate y-dim into ac-pc vec, which means rotate around Zaxis and Xaxis

    % rotate about z -- (spherical-polar thought) - theta = atan(x/y)
    theta0=atan(acpc_vec(1)/acpc_vec(2));        
    Rz=[...
        [cos(theta0) -sin(theta0) 0];...
        [sin(theta0) cos(theta0) 0];...
        [0 0 1]];    
    a=[Rz*data.brain_info.mat(1:3,1:3)*dpts.'].'; %rotation tracker
    
    % rotate about x -- calculate rotation angle incorporate contraction in acpc projection onto x after rotation about z (factor of 1/theta0)
    phi1=atan(acpc_vec(3)/(acpc_vec(2)/cos(theta0))); % atan(z/proj(r) on x, y)
    Rx=[...
        [1 0 0];...
        [0 cos(phi1) sin(phi1)];...
        [0 -sin(phi1)  cos(phi1)]];    
    b=[Rx*a.'].'; %rotation tracker   

%% then need to rotate x-dim into vector defining norm of plane of symmetry, by rotating about Yaxis
    
    % rotate about y -- y-axis is now coincident with rotated acpc, calculate angle for rotation about y
    eta2=-atan(b(3,1)/b(3,3)); % brute force approach to get angle from VD_vec
    
    Ry=[...
        [cos(eta2) 0 sin(eta2)];...
        [0 1 0];...
        [-sin(eta2) 0  cos(eta2)]];    
       
%% housekeeping
    clear a b n dpts tmp acpc_mcp acpc_vec MLP* VD* pc_* dt_projection 
    clear theta0 phi1 eta2

%% perform rotations and clipping % edited by HH 2021
    rot_mat_acpc=[[Ry*Rx*Rz*data.brain_info.mat(1:3,1:3) Ry*Rx*Rz*data.brain_info.mat(1:3,4)];[0 0 0 1]]; % matrix for rotation
    [data_acpc] = mri_dbs_rot_clip(data, rot_mat_acpc);
    data_acpc.brain_info.mat(1:3,4)=-data_acpc.MCP.'; % recenter brain around middle commisural point; default was anchored to min vertex point at [1,1,1]
    
%% package and print acpc data
    data_acpc.brain_info.dim=size(data_acpc.brain_vol);
    data_acpc.brain_info.mat(isnan(data_acpc.brain_info.mat))=1;
    data_acpc.brain_info.dt=data.brain_info.dt;
    tmp=data.brain_info.fname;tmp([-3:0]+end)=[]; data_acpc.brain_info.fname=[tmp '_acpc.nii'];  %delete .nii from end, and add _acpc.nii
    spm_write_vol(data_acpc.brain_info,5000*data_acpc.brain_vol); % need to scale into standard ranges
    
    %% ride along volumes
    for k=1:length(data.ridealong)
        tmpfname=data_acpc.ridealong(k).name; tmpfname([-3:0]+end)=[]; tmpfname=[tmpfname '_acpc.nii'];  %delete .nii from end, and add _acpc.nii
        tmp=data_acpc.brain_info; tmp.fname=tmpfname;
        spm_write_vol(tmp,data_acpc.ridealong(k).vol); % need to scale into standard ranges
    end

%%


data_raw=data;

save([data.brain_info.fname(1:(end-4)) '_acpc'],'data_acpc','data_raw','rot_mat_acpc')

