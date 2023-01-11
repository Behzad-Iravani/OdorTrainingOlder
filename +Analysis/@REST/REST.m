% -*- coding: 'UTF-8' -*-
classdef REST < Analysis.analysis_
    % The subclass REST preprocesses  the resting state scans of the odor training in older adults project.
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
        realignment(1,1) logical % whether the realignment is performed (true) or not (false)
        movement(1,1) logical % whether the movement correction is performed (true) or not (false)
        slice_time_corr(1,1) logical% whether the slice time correction is performed (true) or not (false)
        coregisteration(1,1) logical% whether the coregisteration correctio is performed (true) or not (false)
        normalization(1,1) logical% whether the normalization is performed (true) or not (false)
    end
    properties(Dependent)
        Realignmenttemplate(1,1) cell
        slice_time_corrtemplate(1,1) cell
        coregisterationtemplate(1,1) cell
        normalizationtemplate(1,1) cell
    end
    methods
        %%-------- Constructor ------%%
        function r = REST(Data, BidsPath, analysis, realignment, movement, ...
                slice_time_corr, coregisteration, normalization)
            if nargin>0
                r.Data            = Data;
                r.BidsPath        = BidsPath;
                r.analysis.name   = analysis(1).name;
                r.analysis.method = analysis(1).method;
                r.realignment     = realignment;
                r.movement        = movement;
                r.slice_time_corr = slice_time_corr;
                r.coregisteration = coregisteration;
                r.normalization   = normalization;
            end %end nargin 
        end % end constuctor 
        %%------------RUN REST preproc -----------%%
        function obj = run(obj)
            subjects = obj.Data.rest;
            if obj.realignment % runing realignment 
                disp('Realignment...')
                if isprop(obj.Data, 'rest') % check if the properties rest exists
                    % Create & run segmentation batch
                    run_realignment(subjects,...
                    obj.Realignmenttemplate);
                else
                    error('No EPI found! Make sure the data set is correct Dataset\subjs\func\*rest*.nii')
                end % end if rest 
            end % end realignment
            %%-------------------------------%%
            if obj.movement % runing the motion correction pipeline 
                disp('create motion figures...')
                run_motion_correction_piplin(subjects)
                disp('done!')
            end % end movement
            %%-------------------------------%%
            if obj.slice_time_corr
               disp('Slice time correction...')
               if isprop(obj.Data, 'rest') % check if the properties rest exists
                    % Create & run segmentation batch
                    run_slice_time_corr(obj.slice_time_corrtemplate);
                else
                    error('No EPI found! Make sure the data set is correct Dataset\subjs\func\*rest*.nii')
                end % end if rest 
                disp('done!')
            end % end slice time correction
            %%-------------------------------%%
            if obj.coregisteration
                disp('co-registeration...')
                run_coregistration(obj.Data.rest, obj.Data.rest, obj.coregisterationtemplate)
                disp('done!')
            end % end coregisteration
        end % end method run 
        %%-------------*********************-------------%%
        %%---------------------BATCH---------------------%%
        %%-------------*********************-------------%%
        
        %%--------- Realignment Matlab Batch ------------%%
        function matlabbatch = get.Realignmenttemplate(obj)
            disp('Creating realignment batch template...')
            matlabbatch = obj.create_batch_realignment();
            disp('done!')
        end

        %%------ Slice time correction Matlab Batch -----%%
        function matlabbatch = get.slice_time_corrtemplate(obj)
            disp('Creating slice time correction batch template...')
            matlabbatch = obj.create_batch_slice_time_correction(obj.Data.rest);
            disp('done!')

        end

        %%--------- Coregisteration Matlab Batch --------%%
        function matlabbatch = get.coregisterationtemplate(obj)
            disp('Creating co-registeration batch template...')
            matlabbatch = obj.create_batch_coregisteration();
            disp('done!')
        end
        %%--------- Normalization Matlab Batch --------%%
        function matlabbatch = get.normalizationtemplate(obj)

        end

    end % end methods

end