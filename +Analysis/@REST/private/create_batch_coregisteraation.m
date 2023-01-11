% -*- coding: 'UTF-8' -*-
function matlabbatch = create_batch_coregisteraation()
% Batch script for coregistration 
% Author:
% Behzad Iravani 
% behzadiravani@gmail.com

matlabbatch = {};
matlabbatch{1}.spm.spatial.coreg.estimate.source    = {'UNDEFINED'};
matlabbatch{1}.spm.spatial.coreg.estimate.ref       = {'UNDEFINED'};

end 