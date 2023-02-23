% -*- coding: 'UTF-8' -*-
function matlabbatch = create_batch_mni_norm(obj, preservence)
% create_batch_mni_norm used the the already estimated flow fields to
% conver the T1 scans to MNI coordinate

% preservence input determines to keep if (1) concentartion or (0) volume

% Author: behzad iravani 
% behzadiravani@gmail.com
% Stockholm 2018

% % persistent call template6
% % if isempty(call)
% %     call = 0;
% %     template6 = cellstr(regexprep(spm_select(1, 'image', 'Select the DARTEL Template6'),',1',''));
% % else
% %     call = call + 1;
% % end

matlabbatch = {};
matlabbatch{1}.spm.tools.dartel.mni_norm.template = obj.template6;
Subjects = obj.Data.T1;
Subjects = regexprep(obj.Data.T1, 'Dataset', 'preproc\\VBM');
% ---------------------------------------------
jj = 0;
for isub = 1:numel(Subjects)
    
    FlowField = dir(strcat(Subjects{isub},'\u_rc1*.nii'));
    Images    = dir(strcat(Subjects{isub},'\rc1*.nii'));
    if ~isempty(FlowField)
        jj = jj+1;
        matlabbatch{1}.spm.tools.dartel.mni_norm.data.subjs.flowfields(jj,:) =...
            cellstr([fullfile(Subjects{isub}, FlowField.name)]);
        matlabbatch{1}.spm.tools.dartel.mni_norm.data.subjs.images{1,1}(jj,1)     = ...
            cellstr([fullfile(Subjects{isub}, Images.name)]);
    end
end

matlabbatch{1}.spm.tools.dartel.mni_norm.vox = [NaN NaN NaN];
matlabbatch{1}.spm.tools.dartel.mni_norm.bb = [NaN NaN NaN
    NaN NaN NaN];
matlabbatch{1}.spm.tools.dartel.mni_norm.preserve = preservence;
matlabbatch{1}.spm.tools.dartel.mni_norm.fwhm = [8 8 8];


end