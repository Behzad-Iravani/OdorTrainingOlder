% -*- coding: 'UTF-8' -*-
% Batch script for segmentation
function matlabbatch = create_batch_segmentation(~)
% create_batch_segmentation is a private method of class VBM that creates 
% the matlabbatch for segmentation warpping 

%     Author: Behzad Iravani
%     behzadiravani@gmail.com
%
%%----------------------------%%

matlabbatch = {};
%% Segmentation
iSeg = length(matlabbatch) + 1;
matlabbatch{iSeg}.spm.spatial.preproc.channel.write = [0 1];
ngaus  = [1 1 2 3 4 2];
native = [
    1 0 0 0 0 0
    1 1 0 0 0 0];
warped = [
    0 0 0 0 0 0
    1 1 1 0 0 0];
for c = 1:6 % tissue class c
    matlabbatch{iSeg}.spm.spatial.preproc.tissue(c).tpm = {
        fullfile(spm('dir'), 'tpm', sprintf('TPM.nii,%d', c))};
    matlabbatch{iSeg}.spm.spatial.preproc.tissue(c).ngaus = ngaus(c);
    matlabbatch{iSeg}.spm.spatial.preproc.tissue(c).native = native(:, c)';
    matlabbatch{iSeg}.spm.spatial.preproc.tissue(c).warped = warped(:, c)';
end
end
