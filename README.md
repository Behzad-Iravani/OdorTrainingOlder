# OdorTrainingOlder
The scripts here includes the analysis codes performing the VBM and FC analysis of the project odor training in the older adults. using SPM12 and Brain Connectivity toolbox in the MATLAB enviroment. 

The package is orgnized in a form of object-oriented programs that generates the batch script for preprocessing as well as post processing of structural and functional MRI scans. 
Objects defined in this package: 
%%---------------Prprocessing-------------%%
neurodata % object contianing the path to strcutral and functional scans (should be in BIDS format). 
analysis_ % object containing the analysis name and methods for carring out preprocessing fro VBM and REST. 
VBM       % object containing methods for segmentation and DARTEL normalization.
REST      % object containing methods for standard fMRI preprocessing and motion correction. 
%%---------------Postprocessing-------------%% 
Palo Alto, december 2022
