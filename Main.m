%{
This is the main script to run the analysis of neuroimaging
 for the odor training in older adults project.

Behzad Iravani
behzadiravani@gmail.com

This script is dependent on following toolboxes:
    SPM12
    BCT
    Statistical and machine learning toolbox

Stockholm, june 2018
revised december 2022
%}

%% Clear memory
clear all; close all;
clc;
%% DATA
DATA = Analysis.neurodata('Dataset');
%% Create Analysis object 
analysis.name{1} = 'vbm'; % the voxel vised T1 analysis
analysis.method.vbm = Analysis.VBM.empty(); % placeholder for VBM method
analysis.name{2} = 'rest'; % Functional connectivity analysis of fMRI 
% analysis.method.rest = Analysis.rest.empty(); % placeholder for VBM method
% Analysis object
ANALYSIS = Analysis.analysis_(DATA, analysis);
%% Running jobs
job_counter = 0;
for job = ANALYSIS.analysis.name
    job_counter = job_counter + 1;
    fprintf('starting a new job\n job #%d: %s\n', job_counter, job{:})
    % constructing and setting up the job object
    JOB = ANALYSIS.JobConstructor(job{:}); % constructing the job object 
    JOB.analysis.method.(job{:}).run
    fprintf('JOB DONE!\n job #%d: %s\n', job_counter, job{:})
end

