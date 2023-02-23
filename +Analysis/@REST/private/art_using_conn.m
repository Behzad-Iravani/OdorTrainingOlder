% -*- coding: 'UTF-8' -*-
function art_using_conn(obj)
% art_using_conn is private method of class REST.
% this function performs the artifact detection and scrubbing of fMRI scans using Conn toolbox

%     Behzad Iravani
%     behzadiravani@gmail.com
%
% This class is dependent on the following toolboxes:
%     SPM 12
%     Conn Toolbox 
%
% Stockholm, august 2018
% revised december 2022
functionals  = cellfun(@(x) fullfile(regexprep(x, 'Dataset', 'Preproc\\REST'), ...
    ['w' cell2mat(regexp(x, '\d+', 'match')), '_task-rest_bold.nii']), obj.rest, UniformOutput=false);
structurals = cellfun(@(x) fullfile(regexprep(x, 'Dataset', 'Preproc\\VBM'), ...
    ['wm' cell2mat(regexp(x, '\d+', 'match')), '_T1W.nii']), obj.T1, UniformOutput=false);
conn_module('preprocessing', ...
    'functionals',functionals, ...
    'structurals', structurals, ...
    'steps', 'functional_art', ...
    'RT', 2, ...
    'sliceorder',  'interleaved (Siemens)')

end