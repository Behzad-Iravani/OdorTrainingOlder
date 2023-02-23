% -*- coding: 'UTF-8' -*-
function estimate_total_volume(obj)
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
path2T1 = regexprep(obj.T1, 'Dataset', 'Preproc\\VBM'); % the preproc data moved to preproc folder. 
% ---------------------------------------------
clear matlabbatch
jj = 0;
for ss = 1:numel(path2T1 )
T1 = dir(strcat(path2T1{ss},'\*_seg8.mat'));
correct_volumes([fullfile(T1.folder,T1.name)], regexprep(path2T1{ss}, 'Preproc\\VBM','Dataset')) 

if ~isempty(T1)
    jj = jj+1;
    matlabbatch{1}.spm.util.tvol.matfiles(jj,1)  = cellstr([fullfile(T1.folder,T1.name)]); %Input vol
end
end


matlabbatch{1}.spm.util.tvol.tmax = 3;
matlabbatch{1}.spm.util.tvol.mask = {'C:\Projects\spm12\spm12\tpm\mask_ICV.nii,1'};
matlabbatch{1}.spm.util.tvol.outf = {'C:\Projects\Git\+Analysis\POSTPROCVBM\totalvolumes.xlsx'};
spm_jobman('run', matlabbatch);


end

function correct_volumes(u_path, u_files)
load(u_path)
image.fname = [u_files, filesep, cell2mat(regexp(u_files, '\d+', 'match')), '_T1W.nii'];

for i = 1:length(tpm)
tpm(i).fname = 'C:\Projects\spm12\spm12\tpm\TPM.nii';
end

save(u_path, '-regexp', '^(?!u_.*$).')


end