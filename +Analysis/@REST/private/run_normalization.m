% -*- coding: 'UTF-8' -*-
function run_normalization(batch)
% run_normalization is a private method of class REST. 
% it uses SPM12 and DARTEL flowfield computed by VBM class to 
% normlaizes scans to MNI using DARTEL
% Author:
% Behzad Iravani
% behzadiravani@gmail.com
%%-------------------------%%
spm('defaults', 'FMRI');
spm_jobman('run', batch);

end