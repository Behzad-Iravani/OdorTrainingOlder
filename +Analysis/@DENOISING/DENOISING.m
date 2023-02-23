% -*- coding: 'UTF-8' -*-
classdef DENOISING
    % DENOISNg contains the data and methods for running temporal regression
    % and scrubbing using conn toolbox
    %     Author: Behzad Iravani
    %     behzadiravani@gmail.com
    %
    % This class is dependent on the following toolboxes:
    %     SPM12
    %     CONN toolbox
    %
    % Stockholm, june 2019
    % revised december 2022
    properties
        %         DATA Analysis.neurodata
        functionals cell
        structurals cell
        covariates struct
        masks struct
        reg_names cell
        reg_dimensions double
        reg_deriv double

    end

    methods
        function obj = DENOISING(DATA)
            arguments
                DATA (1,1) {mustBeA(DATA, "Analysis.neurodata")}
            end

            obj.functionals = cellfun(@(x) fullfile(regexprep(x, 'Dataset', 'Preproc\\REST'), ...
                ['w' cell2mat(regexp(x, '\d+', 'match')), '_task-rest_bold.nii']),DATA.rest, UniformOutput=false);
            obj.structurals = cellfun(@(x) fullfile(regexprep(x, 'Dataset', 'Preproc\\VBM'), ...
                ['wm' cell2mat(regexp(x, '\d+', 'match')), '_T1W.nii']), DATA.T1, UniformOutput=false);
            obj.covariates    = getcovariates(DATA.rest);
            obj.masks         = getmasks(DATA.T1);
            obj.reg_dimensions= [Inf, Inf, 5, 5];
            obj.reg_deriv     = [1, 0, 0, 0];

            function cov = getcovariates(rest)
                cov.names(1,1:2) = {'realignment','scrubbing'};
                for sub = 1:numel(rest)
                    %                 cov.names(sub,1:2) = {'realignment','scrubbing'};
                    cov.files{1,1}(sub)= {[regexprep(rest{sub}, 'Dataset', 'Preproc\\REST'), ...
                        '\rp_w' cell2mat(regexp(rest{sub}, '\d+', 'match')), '_task-rest_bold.txt']};
                    cov.files{1,2}(sub)= {[regexprep(rest{sub}, 'Dataset', 'Preproc\\REST'), ...
                        '\art_regression_outliers_w' cell2mat(regexp(rest{sub}, '\d+', 'match')), '_task-rest_bold.mat']};
                end

            end

            function mask = getmasks(T1)
                mask.White = cellfun(@(x) fullfile(regexprep(x, 'Dataset', 'Preproc\\VBM'), ...
                    ['wc2' cell2mat(regexp(x, '\d+', 'match')), '_T1W.nii']), T1, UniformOutput=false);
                mask.CSF   = cellfun(@(x) fullfile(regexprep(x, 'Dataset', 'Preproc\\VBM'), ...
                    ['wc3' cell2mat(regexp(x, '\d+', 'match')), '_T1W.nii']), T1, UniformOutput=false);
            end
        end
        function run(obj)
            conn_module('preprocessing',...
                'functionals',   obj.functionals, ...
                'covariates',    obj.covariates, ...
                'masks',        obj.masks, ...
                'steps',         {'functional_regression'}, ...
                'reg_names',     {'realignment','scrubbing','White Matter','CSF'}, ...
                'reg_dimensions',obj.reg_dimensions, ...
                'reg_deriv',  obj.reg_deriv)
        end % run
        function smooth(obj, DATA)
            arguments
                obj (1,1) {mustBeA(obj, "Analysis.DENOISING")}
                DATA (1,1) {mustBeA(DATA, "Analysis.neurodata")}

            end

            functionals_  = cellfun(@(x) fullfile(regexprep(x, 'Dataset', 'Preproc\\REST'), ...
                ['dw' cell2mat(regexp(x, '\d+', 'match')), '_task-rest_bold.nii']),DATA.rest, UniformOutput=false);
            structurals_ = cellfun(@(x) fullfile(regexprep(x, 'Dataset', 'Preproc\\VBM'), ...
                ['wm' cell2mat(regexp(x, '\d+', 'match')), '_T1W.nii']), DATA.T1, UniformOutput=false);
            conn_module('preprocessing', ...
                'functionals',functionals_, ...
                'structurals', structurals_, ...
                'steps','functional_smooth',...
                 'fwhm', [8 8 8])

        end % smooth
        function bandpass(obj, DATA)
            arguments
                obj (1,1) {mustBeA(obj, "Analysis.DENOISING")}
                DATA (1,1) {mustBeA(DATA, "Analysis.neurodata")}

            end

            functionals_  = cellfun(@(x) fullfile(regexprep(x, 'Dataset', 'Preproc\\REST'), ...
                ['sdw' cell2mat(regexp(x, '\d+', 'match')), '_task-rest_bold.nii']),DATA.rest, UniformOutput=false);
            structurals_ = cellfun(@(x) fullfile(regexprep(x, 'Dataset', 'Preproc\\VBM'), ...
                ['wm' cell2mat(regexp(x, '\d+', 'match')), '_T1W.nii']), DATA.T1, UniformOutput=false);
                conn_module('preprocessing', ...
                'functionals',functionals_, ...
                'structurals',structurals_,...
                'steps', 'functional_bandpass', ...
                'RT', 2,...    
                'bp_filter', [.001,.1])
        end % bandpass

    end
end