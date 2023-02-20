%{
This is the main script to run the analysis of neuroimaging
 for the odor training in older adults project.
Author:
        Behzad Iravani
        behzadiravani@gmail.com

This script is dependent on following toolboxes:
    SPM12
    BCT
    Statistical and machine learning toolbox

Stockholm, august 2018
revised december 2022
%}

%% Clear memory
clear all; close all;
clc;
%% DATA
DATA = Analysis.neurodata('Dataset');
% load the behavioral data from excell sheets
DATA.getBHVData() 
writecell([fieldnames(DATA.DataSet)'
    table2cell(struct2table(DATA.DataSet))], "Dataset.tsv","filetype","text", "Delimiter", '\t')
%% Create preproc Analysis object
analysis.name{1} = 'vbm'; % the voxel vised T1 analysis
analysis.method.vbm = Analysis.VBM.empty(); % placeholder for VBM method
analysis.name{2} = 'rest'; % Functional connectivity analysis of fMRI
analysis.method.rest = Analysis.REST.empty(); % placeholder for REST method
% Analysis object
ANALYSIS = Analysis.analysis_(DATA, analysis);
%% Running preprocessing jobs
run_preproc = input('>> Would you like to run preproc? [y/n] ','s');
if strcmpi(run_preproc, 'y')
    job_counter = 0;
    for job = ANALYSIS.analysis.name
        job_counter = job_counter + 1;
        fprintf('preproc: starting a new job\n job #%d: %s\n', job_counter, job{:})
        % constructing and setting up the job object
        JOB = ANALYSIS.JobConstructor(job{:}); % constructing the job object
        JOB.analysis.method.(job{:}).run
        fprintf('JOB DONE!\n job #%d: %s\n', job_counter, job{:})
    end % end for jobs
end % end run_preproc

%% Create postproc Analysis object
analysis.name{1} = 'postprocVBM'; % postprocessing vbm
analysis.method.postprocVBM = Analysis.POSTPROCVBM.empty(); % placeholder for VBM method
analysis.name{2} = 'postprocRest'; % postprocessing resting state 
analysis.method.postprocREST = Analysis.POSTPROCREST.empty(); % placeholder for REST method
% Analysis object
ANALYSIS = Analysis.analysis_(DATA, analysis);
%% Running post processing
% construct a POSTPROC Analysis object
run_postproc = input('>> Would you like to run post-processing? [y/n] ','s');
if strcmpi(run_postproc, 'y')
    job_counter = 0;
    for job = ANALYSIS.analysis.name
        job_counter = job_counter + 1;
        fprintf('postproc: starting a new job\n job #%d: %s\n', job_counter, job{:})
        JOB = ANALYSIS.JobConstructor(job{:}); % constructing the job object
        JOB.analysis.method.(job{:}).run()

    end % end jobs

end % end run postproc
