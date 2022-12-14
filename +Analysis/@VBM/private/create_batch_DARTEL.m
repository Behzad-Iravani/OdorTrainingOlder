% -*- coding: 'UTF-8' -*-
% Batch script for DARTEL 
function  matlabbatch = create_batch_DARTEL(~)
% create_DARTEL_templae is a private method of class VBM that creates 
% the matlabbatch for DARTEL warpping 
%
%     Author: Behzad Iravani
%     behzadiravani@gmail.com
%
%%---------------------------------%%
matlabbatch = {};
%% Dartel - create template
iDar = length(matlabbatch) + 1;
matlabbatch{iDar}.spm.tools.dartel.warp.images{1}(1) = cell(1,1);% only gray matter

end