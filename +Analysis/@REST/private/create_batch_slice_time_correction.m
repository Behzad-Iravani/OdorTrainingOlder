% -*- coding: 'UTF-8' -*-
function matlabbatch = create_batch_slice_time_correction(~,subjects)
% Batch script for slice time correction 
% Author:
% Behzad Iravani 
% behzadiravani@gmail.com

spm('defaults','fmri');
spm_jobman('initcfg');
EPI = spm_select('List',strcat(subjects),'^\d.*\.nii$');

hdr = spm_vol(strcat(subjects{1}, filesep, EPI(1,:),',1')); % read fist volume to extract nslices
nslices = hdr(1).dim(3);
TR              = 2; % seconds
TA              = TR - (TR/nslices);
SliceOrder      = [1:2:nslices 2:2:nslices]; % interleaved, uneven nbr of slices (for siemens: if even, starts at 2?)


matlabbatch = {};
SPMdir= spm('dir');


matlabbatch{1}.spm.temporal.st.scans{1} = strcat(subjects,filesep,EPI);
matlabbatch{1}.spm.temporal.st.nslices  = nslices;
matlabbatch{1}.spm.temporal.st.tr       = TR;
matlabbatch{1}.spm.temporal.st.ta       = TA;
matlabbatch{1}.spm.temporal.st.so       = SliceOrder;
matlabbatch{1}.spm.temporal.st.refslice = nslices; %???


end