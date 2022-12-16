% -*- coding: 'UTF-8' -*-
function run_Segment(path2T1,Batch)
% This function is part of the VBM analysis using SPM 12 and perfoms
% segmentation
%       Author: behzad iravani
%       behzadiravani@gmail.com
% Stockholm 2018
% revised Palo Alto 

%%----- spm defaluts -----%%
spm('defaults','fmri');
spm_jobman('initcfg');
%%------------------------%%
% Find Subjects file
for subs = 1:size(path2T1,1)
    msg = fprintf('subject #%d out of %d',subs,size(path2T1,1));
    file = dir(fullfile(path2T1{subs},'*.nii'));
    if isempty(file)
        error(sprintf('mising file: %s',path2T1{subs}))
    end
    if(numel(file)>1)
        error(sprintf('more than one T1 scan is not allowed: %s\nThe analysis might have interputed before!',path2T1{subs}))
    end
    fprintf(repmat('\b',1,msg))
      vols{subs}= fullfile(path2T1{subs},[file.name, ',1']); %Input vol
end % end subject loop
Batch{1}.spm.spatial.preproc.channel.vols = vols';

SPMdir= spm('dir');
Batch{1}.spm.spatial.preproc.tissue(1).tpm = cellstr(strcat(...
    SPMdir,filesep,'tpm\',sprintf('TPM.nii,%d',1)));
spm_jobman('run',Batch)
% clean up %% >>>>> clean up should come after DARTEL normalization 
disp('Cleaning up....')
cleanUP(path2T1, file)
disp('done!')
end


function cleanUP(path2T1, file)
if ~exis(fullfile('preproc', file.name, 'anat'), 'dir')
    mkdir(fullfile('preproc', file.name, 'anat'))
end
movefile(fullfile(path2T1,['c1', file.name]), fullfile('preproc', file.name, 'anat', ['c1', file.name]))
movefile(fullfile(path2T1,[regexprep(file.name,'.nii',''), '_seg8']),...
    fullfile('preproc', file.name, 'anat', [regexprep(file.name,'.nii',''), '_seg8']))

end

