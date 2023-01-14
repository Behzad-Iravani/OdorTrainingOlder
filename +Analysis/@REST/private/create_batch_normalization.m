% -*- coding: 'UTF-8' -*-
function matlabbatch = create_batch_normalization(~, T1, rest)
% Batch script for normalization
% Author:
% Behzad Iravani
% behzadiravani@gmail.com
%%-------------------------%%

matlabbatch = {};
matlabbatch{1}.spm.tools.dartel.mni_norm.template = {strcat(regexprep(T1{1}, 'Dataset', 'Preproc\\VBM'), filesep, 'Template_6.nii')};

for nsub = 1:numel(T1)
    
    FlowField = dir(strcat(regexprep(T1{nsub}, 'Dataset', 'Preproc\\VBM'),'\u_rc1*.nii')); % find the flowfield of DARTEL
    if isempty(FlowField)
        error('DARTEL normalization has not been completed. please run VMB first!')
    end
    Images = spm_select('List',rest{nsub},'^a.*\.nii$'); % find the subject EPI scans
    
   
    matlabbatch{1}.spm.tools.dartel.mni_norm.data.subjs.flowfields(nsub,:) =...
        cellstr(fullfile(regexprep(T1{nsub}, 'Dataset', 'Preproc\\VBM\'),FlowField.name));
    matlabbatch{1}.spm.tools.dartel.mni_norm.data.subjs.images{1,1}(nsub,:)  = ...
        cellstr(fullfile(rest{nsub},Images));
    
end
    %##############################################################
    % Adjust Voxel Size 
    V = spm_vol(matlabbatch{1}.spm.tools.dartel.mni_norm.data.subjs.images{1,1}(1,:));
    VX = V{1}(1).mat(find(eye(4)));
    % ############################################################
    
    matlabbatch{1}.spm.tools.dartel.mni_norm.vox = [abs(VX(1:3))];
    matlabbatch{1}.spm.tools.dartel.mni_norm.bb = [NaN NaN NaN
        NaN NaN NaN];
    matlabbatch{1}.spm.tools.dartel.mni_norm.preserve = 0;
    matlabbatch{1}.spm.tools.dartel.mni_norm.fwhm = [8 8 8];
end