function [mat2, vol2]=matfix(mat,vol)
% function [mat2, vol2]=matfix(mat,vol)
% matrix pre-process, rotations and inversions
% kjm 10/2015
    c=sign(sum(mat(1:3,1:3),1)).*(sum(mat(1:3,1:3).^2).^.5);

%%
    [a,b]=max(abs(mat(1:3,1:3)),[],2); clear a
    if length(unique(b))<3
        b=[unique(b); setdiff([1:3]',b)];
    end    
    vol2=permute(vol,b);
    c=c(b);

%%
    if c(1)<0, vol2=vol2(end:-1:1,:,:); c(1)=-c(1); end
    if c(2)<0, vol2=vol2(:,end:-1:1,:); c(2)=-c(2); end
    if c(3)<0, vol2=vol2(:,:,end:-1:1); c(3)=-c(3); end

%%     
   mat2=diag([c 1]); 

   
   
   
   