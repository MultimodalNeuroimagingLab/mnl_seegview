function pos=vox2pos(mat,vox)
% positions to voxels
% kjm 8/2020

%%
offset=ones(size(vox,1),1)*mat(1:3,4).';


pos=(mat(1:3,1:3)*vox.').'+offset;


