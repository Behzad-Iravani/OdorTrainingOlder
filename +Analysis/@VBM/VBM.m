% -*- coding: 'UTF-8' -*-
classdef VBM < Analysis.analysis_
    % The subclass VBM for the voxel based morphometry for the odor training in older adults project.
    % 
    %     Behzad Iravani
    %     behzadiravani@gmail.com
    % 
    % This class is dependent on the following toolboxes:
    %     SPM 12
    %  
    % Stockholm, june 2019
    % revised december 2022
    properties
        segmentation(1,1) logical % whether the segmentation performs (true) or not (false)
        DARTELnorm(1,1) logical % whether the DARTEL normalization performs (true) or not (false)
    end
    properties(Dependent)
        Segmentationtemplate(1,1) cell
        DARTELtemplate(1,1) cell
    end
    methods
        %%-------- Constructor ------%%
        function v = VBM(Data, BidsPath, analysis, segmentation, DARTELnorm)
            if nargin>0
            v.Data     = Data;
            v.BidsPath = BidsPath;
            v.analysis.name = analysis(1).name;
            v.analysis.method = analysis(1).method;
            v.segmentation = segmentation;
            v.DARTELnorm = DARTELnorm;
            end
        end
        %%------------RUN VBM-----------%%
        function obj = run(obj)
            if obj.segmentation
                disp('Segmentation...')
                if isprop(obj.Data, 'T1') % check if the properties T1 exists
                    % Create & run segmentation batch
                    subjects = obj.Data.T1;
                    run_Segment(subjects,...
                    obj.Segmentationtemplate);
                else
                    error('No T1 found! make sure the data set is correct Dataset\subjs\anat\T1.nii')
                end % end if T1 
            end % end if  segmentation 
            if obj.DARTELnorm
                % Create & run DARTEL batch
                disp('DARTEL normalization...')
                subjects = obj.Data.T1;
                run_dartel_normalization(subjects,...
                    obj.DARTELtemplate);

            end % end if DARTEL normalization
           
        end % if run method   
        %%--------- Segmentation Matlab Batch --------------
        function matlabbatch = get.Segmentationtemplate(obj)
            disp('Creating segmentation batch template!')
                matlabbatch = obj.create_batch_segmentation();
            disp('done!')
        end % get Segmentationtemplate 
        %%---------------------------------------------------
        %%--------- DARTEL Matlab Batch --------------
        function matlabbatch = get.DARTELtemplate(obj)
            disp('Creating DARTEL batch template!')
                matlabbatch = obj.create_batch_DARTEL();
            disp('done!')
        end % get DARTELtemplate
        %%---------------------------------------------------
    end % end methods
    methods(Static)
        function cbJobDone() 
                JobDone % notify that job is done 
        end
    end% end methods static
    end