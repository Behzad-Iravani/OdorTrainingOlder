% -*- coding: 'UTF-8' -*-
function run_coregistration(rest, T1, batch)
% run_coregistration is a private method of class REST that runs
% the matlabbatch for co-registartion of EPI scans to T1
%
%     Author: Behzad Iravani
%     behzadiravani@gmail.com
%
%    Spetember 2018
%    Revised: December 2022
% This method is part of the odor training older adults project

%%----------------------------------------------------------%%
%%--------------------- Coregister:EPI->T1 -----------------%%
clc
EPIs = spm_select('List',strcat(rest),'^a.*\.nii$');
 
end