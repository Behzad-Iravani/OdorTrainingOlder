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
        segmentation(1,1) logical % whether the segmentation is performed (true) or not (false)
        DARTELnorm(1,1) logical % whether the DARTEL normalization is performed (true) or not (false)
        MNIVolume(1,1) logical % whether the volume normalizetion is performed (true) or not (false)
        MNIConcentration(1,1) logical % whether the concentration normalization is performed (true) or not (false)
        template6
    end
    properties(Dependent)
        Segmentationtemplate(1,1) cell
        DARTELtemplate(1,1) cell
        MNIVolumetemplate(1,1) cell
        MNIConcentrationtemplate(1,1) cell
       
    end
    methods
        %%-------- Constructor ------%%
        function v = VBM(Data, BidsPath, analysis, segmentation, DARTELnorm, MNIVolume, MNIConcentration)
            if nargin>0
                v.Data     = Data;
                v.BidsPath = BidsPath;
                v.analysis.name = analysis(1).name;
                v.analysis.method = analysis(1).method;
                v.segmentation = segmentation;
                v.DARTELnorm = DARTELnorm;
                v.MNIVolume  = MNIVolume;
                v.MNIConcentration = MNIConcentration;
                
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
             obj.template6 = cellstr(regexprep(spm_select(1, 'image', 'Select the DARTEL Template6'),',1',''));
            %//Normalization ----------------------
            if obj.MNIVolume
                disp('Volume normalization,...')
                run_volume_normalization(obj.MNIVolumetemplate);
                disp('done!')
            end
            if obj.MNIConcentration
                disp('Concentration normalization,...')
                run_volume_normalization(obj.MNIConcentrationtemplate);
                disp('done!')
            end
            disp('Cleaning up')
            cleanUP(obj.Data.T1)
            disp('Done!')
        end % if run method
        %%-------------*********************-------------%%
        %%---------------------BATCH---------------------%%
        %%-------------*********************-------------%%
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
        %%---------Volume Matlab Batch --------------
        function matlabbatch = get.MNIVolumetemplate(obj) % preservence 0 volume
            disp('Creating volume normalization batch template!')
            matlabbatch = obj.create_batch_mni_norm(0);
            disp('done!')
        end % get MNIVoluemtemplate
        %%---------------------------------------------------
        %%---------Concentration Matlab Batch --------------
        function matlabbatch = get.MNIConcentrationtemplate(obj) % preservence 1 concentration
            disp('Creating concentration normalization batch template!')
            matlabbatch = obj.create_batch_mni_norm(1);
            disp('done!')
        end % get MNIConcentrationtemplate

    end % end methods
    methods(Static)
        function cbJobDone()
            JobDone % notify that job is done
        end
    end% end methods static
end