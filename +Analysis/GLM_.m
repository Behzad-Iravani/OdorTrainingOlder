function  GLM_(folder, data, X, coeffname)
% #################################################################################
clear matlabbatch

matlabbatch{1}.spm.stats.factorial_design.des.mreg.mcov = struct('c', {}, 'cname', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.des.mreg.incint = 1;
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;


matlabbatch{1}.spm.stats.factorial_design.dir = {folder};
matlabbatch{1}.spm.stats.factorial_design.des.mreg.scans = data;
% *************************************************************************
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
for ic =1:length(coeffname)
matlabbatch{1}.spm.stats.factorial_design.cov(ic).cname = coeffname{ic};
matlabbatch{1}.spm.stats.factorial_design.cov(ic).c = X(:,ic);
matlabbatch{1}.spm.stats.factorial_design.cov(ic).iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov(ic).iCC  = 1;
end
%% run SPM JOB
spm('defaults', 'FMRI');
spm_jobman('run', matlabbatch);
