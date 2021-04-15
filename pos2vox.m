function vox=pos2vox(mat,pos)
% positions to voxels
% kjm 8/2020

%%
offset=ones(size(pos,1),1)*mat(1:3,4).';
vox=(pinv(mat(1:3,1:3))*(pos-offset).').';



