% -*- coding: 'UTF-8' -*-
function run_dartel_normalization(path2T1,Batch)
% This function is part of the VBM analysis using SPM 12 and perfoms DARTEL
% normalization
% Author: behzad iravani 
% behzadiravani@gmail.com
% Stockholm 2018


%%----- spm defaluts -----%% 
spm('defaults','fmri');
spm_jobman('initcfg');
%%------------------------%%
% Find Subjects file
for subs = 1:size(path2T1,1)
    T1 = dir(strcat(path2T1{subs},'\rc1*.nii'));
    fprintf('rc1 scan found:\n%s\n%s\n', T1.folder, T1.name)
    cnt = 0;
    if ~isempty(T1)
        cnt = cnt+1; % volume counter
        Batch{1}.spm.tools.dartel.warp.images{1}(cnt,1)  = cellstr([fullfile(T1.folder, T1.name),',1']); %Input vol
    end
end


spm_jobman('run',Batch)
end


