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
                r.realignement    = realignment;
                r.movement        = movement;
                r.slice_time_corr = slice_time_corr;
                r.coregisteration = coregisteration;
                r.normalization   = normalization;
            end %end nargin 
        end % end constuctor 
        %%------------RUN REST preproc -----------%%
        function obj = run(obj)
            if obj.realignment


            end % end realignment
            if obj.movement


            end % end movement

            if obj.slice_time_corr


            end % end slice time correction

            if obj.coregisteration

            end % end coregisteration


        end % end method run 
        %%-------------*********************-------------%%
        %%---------------------BATCH---------------------%%
        %%-------------*********************-------------%%
        %%--------- Realignment Matlab Batch ------------%%


    end % end methods

end