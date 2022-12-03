classdef VBM < Analysis.analysis_
    % The subclass VBM for voxel bases morphology for the odor training in older adults project.
    % 
    %     Behzad Iravani
    %     behzadiravani@gmail.com
    % 
    % This class is dependent on the following toolboxes:
    %     SPM12
    %     BCT
    %     Statistical and machine learning toolbox
    % 
    % Stockholm, june 2019
    % revised december 2022
    properties
        segemntation(1,1) logical % wether the DARTEL segmentation performs (true) or not (false)
        DARTELtemplate(1,1) cell
    end
    methods
        %%-------- Constructor ------%%
        function v = VBM(Data, BidsPath, analysis, segmentation)
            if nargin>0
            v.Data     = Data;
            v.BidsPath = BidsPath;
            v.analysis.name = analysis(1).name;
            v.analysis.method = analysis(1).method;
            v.segemntation = segmentation;
            load +Analysis\@VBM\DARTEL.mat
            v.DARTELtemplate = matlabbatch;
            end
        end
        %%---------------------------%%
        function obj = obj.runVBM(obj)
            fprintf(['Hellow'])

        end
        function obj = run(obj)
            if obj.segmentation
            subjects = obj.Data.T;
              for subs = 1:numel(subjects)
                msg = fprintf('subject #%d out of %d',subs,numel(subjects));
                run_Segment_dartel(subjects{subs},...
                    Analysis.VBM.template);
                fprintf(repmat('\b',1,msg))
              end % end subject loop 
            end % end DARTEL segmentation method
        end % if segmentation
        end
    end