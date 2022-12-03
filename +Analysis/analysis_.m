classdef analysis_ < Analysis.neurodata
    % The subclass analysis. This is script is part of the analysis for the odor training in older adults project.
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
        Data % neuro data class 
        analysis = struct('name',[], 'method',[])
    end
    methods
        %%--------- Constructor --------%%
        function A = analysis_(Data, analysis)
            if nargin > 0
                A.Data     = Data;
                A.BidsPath = Data.BidsPath ;
                A.analysis = analysis;
                disp(Data)
            end
        end
        %%--------------------------------------%%
        function obj = JobConstructor(obj, job)
            if nargin == 1
                error('No job is defined, please determined the job and try again!')
            else
                switch job
                    case 'vbm'
                        % call vbm object
                        disp('Constructing VBM object')
                        answer = input('Applying DARTEL segmentation, [y/n]? ','s');
                        if strcmp(answer,'y')
                            obj.analysis.method.vbm = Analysis.VBM(obj.Data, obj.BidsPath, obj.analysis, true);
                        else
                            obj.analysis.method.vbm = Analysis.VBM();
                        end
                        % performing preproc analysis

                    case 'rest'

                end

            end % end if nargin
        end % end JobConstructor method
    end % end methods
end % end classs



