% -*- coding: 'UTF-8' -*-
function run_slice_time_corr(Batch)
% run_slice_time_corr uses spm functions to run slice time correction 
%     Author: Behzad Iravani
%     behzadiravani@gmail.com
%
%    Spetember 2018
%    Revised: December 2022
% This method is part of the odor training older adults project

% run slice time correction job 
spm_jobman('run',Batch)
end