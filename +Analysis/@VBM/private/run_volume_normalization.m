% -*- coding: 'UTF-8' -*-
function run_volume_normalization(Batch)
% run_volume_normalization is part of the VBM analysis using SPM 12 and
% performs volume normalization from DARTEL flow fields

%       Author: behzad iravani
%       behzadiravani@gmail.com
% Stockholm 2018
% revised Palo Alto 

%%----- spm defaluts -----%%
spm('defaults','fmri');
spm_jobman('initcfg');
%%------------------------%%
spm('defaults', 'FMRI');
spm_jobman('run', Batch);

end 