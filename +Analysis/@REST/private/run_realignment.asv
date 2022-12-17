% -*- coding: 'UTF-8' -*-
function run_realignment(path2EPI,Batch)
% run_realignment is a private method of class REST that creates
% the matlabbatch for realignment of EPI scans
%
%     Author: Behzad Iravani
%     behzadiravani@gmail.com
%
%    Spetember 2018
%    Revised: December 2022
% This method is part of the odor training older adults project

%%----------------------------------------------------------%%

EPI = spm_select('List', strcat(path2EPI,filesep),'.*\.nii$'); % select EPI scans using spm_select function

if isempty(EPI) % make sure that scans exist
    error(sprintf('No scans found for %s', path2EPI))
end

Batch{1}.spm.spatial.realign.estwrite.data{:} = fullfile(path2EPI,EPI);
spm_jobman('run',Batch)
end

