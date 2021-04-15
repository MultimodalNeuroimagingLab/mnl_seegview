function [dataout] = mri_dbs_rot_clip(data, rot_mat)
% function [dataout] = mri_dbs_rot_clip(data, rot_mat)
%     Called by function hippotaxy. Part of the "Hippotaxy" tool.
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
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.


%% initialize variables, etc if necessary here
    acpc_mcp=(data.AC+data.PC)/2; % mid-commisural point

%% calculate points for new space -- brute force approach winds up being much simpler
    % create zeroed out volume for points of interest (POI) matrix
    poi_vol=0*data.brain_vol;

    % fill select pixels of volume with points of interest
    poi_vol(data.AC(1),data.AC(2),data.AC(3))=1; %AC = 1,
    poi_vol(data.PC(1),data.PC(2),data.PC(3))=2; %PC = 2;
    %poi_vol(floor(acpc_mcp(1)),floor(acpc_mcp(2)),floor(acpc_mcp(3)))=3; %MCP=3 - recalc'ed after rotation bc of floor command whereas ac and pc are actual pixel
    if isfield(data,'LMark'), 
        for k = 1:size(data.LMark,1)  %sub2ind is more efficient, but less intuitive
        poi_vol(data.LMark(k,1),data.LMark(k,2),data.LMark(k,3))=4+k; % dbs = 5+ -- dbscampal body principal axis
        end
    end  
    for k=1:length(data.adhoc)
    poi_vol(data.adhoc(k).pt(1),data.adhoc(k).pt(2),data.adhoc(k).pt(3))=9+k; % dbs = 5+ -- dbscampal body principal axis
    end
    %   NEED TO ADD IN TRANSFORMATION OF ANY STORED POINTS HERE
    
%% rotations
    % rotate primary volume; rot_mat_out translation sets vox [1,1,1] to minimum vertex pos (mm)
    [brain_vol_rot, rot_mat_out] = affine(data.brain_vol, rot_mat,1,0,[],1); % reslice at 1mm^3 voxels, method 1 is trilinear interpolation
    
    % rotate ride along volumes
    for k=1:length(data.ridealong)
        [ratmp_rot, tmp] = affine(data.ridealong(k).vol, rot_mat,1,0,[],2); % reslice at 1mm^3 voxels, method 2 is nearest neighbor - don't want it interpolating
        ridealong_rot(k).vol=ratmp_rot;
        ridealong_rot(k).name=data.ridealong(k).name;        
    end
    
    %% rotate POI -- note, have problems with obtaining points bc of nearest neighbor interpolation. 
    % instead, will filter with cube, then step back down to a point by
    % taking average position
    poi_vol_cubes=smooth3(poi_vol,'box',3*[1 1 1]); % preserves sum of each point, but spread across 3x3x3 volume equally
    tmp=unique(poi_vol_cubes);tmp(tmp==0)=[];
    poi_vol_cubes=round(poi_vol_cubes/min(tmp));
%     poi_vol_cubes=max(unique(poi_vol))*poi_vol_cubes/max(max(max(poi_vol_cubes))); 
    [poi_vol_rot, tmp] = affine(poi_vol_cubes, rot_mat,1,0,[],2); %method 2 is nearest neighbor - don't want it interpolating
    
    
%% clip rotated matrices - need to insert button in program to turn this on and off

    % project mass down onto each axis
    cx=sum(brain_vol_rot,3); cx=smoothdata(squeeze(sum(cx,2)));
    cy=sum(brain_vol_rot,3); cy=smoothdata(squeeze(sum(cy,1)));
    cz=sum(brain_vol_rot,2); cz=smoothdata(squeeze(sum(cz,1)));
    
    % x clip limits
    dd=mean([cx(1:10) cx(end-0:9)]); ddcutoff=.03*(max(cx)-dd)+dd;
    xlo=find(cx>ddcutoff,1,'first');  if xlo>20, xlo=xlo-20; end
    xhi=find(cx>ddcutoff,1,'last'); if xhi<(length(cx)-21), xhi=xhi+20; end
    
    % y clip limits
    dd=mean([cy(1:10) cy(end-0:9)]); ddcutoff=.03*(max(cy)-dd)+dd;
    ylo=find(cy>ddcutoff,1,'first');  if ylo>20, ylo=ylo-20; end
    yhi=find(cy>ddcutoff,1,'last'); if yhi<(length(cy)-21), yhi=yhi+20; end
    
    % z clip limits
    dd=mean([cz(1:10) cz(end-0:9)]); ddcutoff=.03*(max(cz)-dd)+dd;
    zlo=find(cz>ddcutoff,1,'first');  if zlo>20, zlo=zlo-20; end
    zhi=find(cz>ddcutoff,1,'last'); if zhi<(length(cz)-21), zhi=zhi+20; end
    
    % make clips
    brain_vol_rot=brain_vol_rot(xlo:xhi,ylo:yhi,zlo:zhi);
    poi_vol_rot=poi_vol_rot(xlo:xhi,ylo:yhi,zlo:zhi);
    
    % clip ride along volumes
    for k=1:length(data.ridealong)
        ridealong_rot(k).vol=ridealong_rot(k).vol(xlo:xhi,ylo:yhi,zlo:zhi);       
    end
    
%% recover indices in rotated space (note, if clipping image, make sure to do that first)
% Finds mean position of all smoothed AC, PC voxels post-transformation
% MCP determined to be mean of new AC, PC.
    
    [rAC(:,1), rAC(:,2), rAC(:,3)]=ind2sub(size(poi_vol_rot),find(poi_vol_rot==1)); %AC = 1, 
    rAC=mean(rAC,1);
    [rPC(:,1), rPC(:,2), rPC(:,3)]=ind2sub(size(poi_vol_rot),find(poi_vol_rot==2)); %PC = 2, 
    rPC=mean(rPC,1);
    rMCP=mean([rAC; rPC]);
    rMCP=mean(rMCP,1);
    if isfield(data,'LMark'), for k = 1:size(data.LMark,1)
        [rdbsTmp(:,1), rdbsTmp(:,2), rdbsTmp(:,3)]=ind2sub(size(poi_vol_rot),find(poi_vol_rot==(k+4))); % dbs = 4 -- dbscampal body principal axis
        rdbs(k,:)=mean(rdbsTmp,1); clear rdbsTmp
    end, end
    radhoc=[];
    for k=1:length(data.adhoc)
    poi_vol(data.adhoc(k).pt(1),data.adhoc(k).pt(2),data.adhoc(k).pt(3))=9+k; % dbs = 5+ -- dbscampal body principal axis
    [radhocTmp(:,1), radhocTmp(:,2), radhocTmp(:,3)]=ind2sub(size(poi_vol_rot),find(poi_vol_rot==(k+9))); 
    radhoc(k).pt=mean(radhocTmp,1); clear radhocTmp
    radhoc(k).name=data.adhoc(k).name;
    
    end

%     error('a','a')
    % note - need to save clip parameters, so can rotate and reslice and appropriately clip ride-along matrices (e.g. ROIs, etc) as desired.
 
%% package into structure for export
    dataout.AC=rAC; 
    dataout.PC=rPC; 
    dataout.MCP=rMCP;
    if isfield(data,'LMark'),dataout.dbs=rdbs; end
    dataout.brain_vol=brain_vol_rot;
    dataout.brain_info.mat=rot_mat_out;
    if exist('ridealong_rot')
    dataout.ridealong=ridealong_rot;
    end
    dataout.adhoc=radhoc;


