% -*- coding: 'UTF-8' -*-
function estimate_total_volume(~, T1)
% estimate_total_volume is a private method of class POSTPROC
% it uses SPM12 functions to estimated total cranial volume that is
% required for VBM analysis
% Author:
%        Behzad Iravani
%        behzadiravani@gmail.com 
% This script is part of analysis for the odor transfer gain in older
% adults project.
% Stockholm, august 2018
% revised Palo Alto, january 2023 

%%---------------------------------------------------------------%%
T1 = regexprep(T1, 'Dataset', 'Preproc\VBM'); % the preproc data moved to preproc folder. 
Subjects = dir(path2T1);
Subjects(ismember({'.','..'},{Subjects.name})) =[];
% ---------------------------------------------
clear matlabbatch
jj = 0;
for ss = 1:numel(Subjects )
    
T1 = dir(strcat(path2T1,filesep,Subjects(ss).name,'\*_seg8.mat'));

if ~isempty(T1)
    jj = jj+1;
    matlabbatch{1}.spm.util.tvol.matfiles(jj,1)  = cellstr([fullfile(path2T1,Subjects(jj).name,T1.name)]); %Input vol
end
end


matlabbatch{1}.spm.util.tvol.tmax = 3;
matlabbatch{1}.spm.util.tvol.mask = {'C:\toolbox\spm12\spm12\tpm\mask_ICV.nii,1'};
matlabbatch{1}.spm.util.tvol.outf = {pwd()};
spm_jobman('run', matlabbatch);


end