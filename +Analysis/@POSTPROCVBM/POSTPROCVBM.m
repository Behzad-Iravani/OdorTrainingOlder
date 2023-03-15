% -*- coding: 'UTF-8' -*-
classdef POSTPROCVBM < Analysis.analysis_
    % POSTPROC class is part of odor transfer gain in older adults that
    % takes care of all the post processing needed for generating the
    % results and figures for VBM
    % Author:
    % Behzad Iravani
    % behzadiravani@gmail.com
    % This class is dependent on the following toolboxes:
    %     SPM 12
    %
    % Stockholm, june 2019
    % revised january 2023
    %%-----------------------------------------------------------%%
    properties
        group (1,1) double {mustBeNumeric(group), mustBeLessThan(group, 3), mustBeGreaterThan(group, 0), mustBeInteger(group)} = 1
        list table
        output
        Indx_Pre = []
        Indx_Pos = []
    end
    properties(Dependent)
        totalvolume(1,1) stuct  % total cranial volume needed to be corrected in VBM
        contrasttempalte
    end

    methods
        function obj = POSTPROCVBM(Data, BidsPath, analysis, list, group)
            % POSTPROC Construct an instance of this class
            if nargin>0
                obj.Data            = Data;
                obj.BidsPath        = BidsPath;
                obj.analysis        = analysis;
                obj.list            = list;
                obj.group           = group; % 1 olfactory training, 2 visual traning

            end %end nargin
        end % end constuctor

        function obj = run(obj)
            clc;
            path_preproc = regexprep(obj.Data.T1, 'Dataset', 'preproc\\VBM');
            for folder = 1:numel(path_preproc)
                if exist(path_preproc{folder}, 'dir')
                    disp('reading smwc1*.nii files: modulated gray matter volumes ... ')
                    T1_preproc{folder,1} = spm_select('list', path_preproc{folder}, '^smwc1.*\.nii$');
                else
                    warning('no preprocessed T1 folder: %s', path_preproc{folder})
                end
            end
            disp('checking whether the contrast map exists...')
            if ~exist('Derivatives\VBM', 'dir')
                mkdir('Derivatives\VBM')
                compute_contast = true;
            else
                folder = dir('Derivatives\VBM\');
                if numel(folder)<=2 || ~exist('Derivatives\VBM\Olf', 'dir') || ~exist('Derivatives\VBM\Vis', 'dir')
                    disp('No data,...')
                    compute_contast = true;
                elseif exist('Derivatives\VBM\Olf','dir')
                    files = dir('Derivatives\VBM\Olf');
                    files(ismember({files.name}, {'.', '..'})) = [];
                    if numel(files) <= 20
                    compute_contast = true;
                    else
                        compute_contast = false;
                    end
                   elseif exist('Derivatives\VBM\Vis','dir')
                    files = dir('Derivatives\VBM\Vis');
                    files(ismember({files.name}, {'.', '..'})) = [];
                    if numel(files) <= 20
                    compute_contast = true;
                    else
                        compute_contast = false;
                    end
                end
            end

            if compute_contast
                disp('Creating contrast maps,...')
                obj.Contrast()
            else
                load(['Derivatives\', sprintf('Contrast_g_%d.mat', obj.group)])
            end
           
        end % end run
        %&------------------ GET FUNCTIONS ------------------
        function totalvolume = get.totalvolume(obj)
            disp('Estimating the total cranial volume...')
            totalvolume = estimate_total_volume(obj);
             disp('done!')
        end % end get total volume
        %%-----------------------------------------------------
        function matlabbatch = get.contrasttempalte(obj)
            matlabbatch = create_batch_difference(obj);
        end % contrast batch


        function Contrast(obj)
            % 1 is olfactory
            % 2 is visual
            DM = obj.list;
            obj.list = cat(2,DM, list_x_volume(DM, obj.totalvolume));
            
            %% --- Scans pre
            obj.Indx_Pre = find(cellfun(@(x) strcmp(x,'T1'), DM.Timepoint) & DM.Group == obj.group);

            %% --- Scans post
            obj.Indx_Pos = find(cellfun(@(x) strcmp(x,'T2'), DM.Timepoint) & DM.Group == obj.group);

            if length(obj.Indx_Pos)> length(obj.Indx_Pre)
                rm = setdiff(DM.Subj(obj.Indx_Pos),DM.Subj(obj.Indx_Pre));
                obj.Indx_Pos(arrayfun(@(x) find(DM.Subj(obj.Indx_Pos)==x),rm','UniformOutput',1)) = [];
            end
            if length(obj.Indx_Pos)<length(obj.Indx_Pre)
                rm = setdiff(DM.Subj(obj.Indx_Pre),DM.Subj(obj.Indx_Pos));
                obj.Indx_Pre(arrayfun(@(x) find(DM.Subj(obj.Indx_Pre)==x),rm','UniformOutput',1)) = [];
            end
            if obj.group == 1
                if ~exist('Derivatives\VBM\Olf', 'dir')
                    mkdir('Derivatives\VBM\olf')
                end % if
                obj.output = 'Derivatives\VBM\Olf';
            elseif obj.group == 2
                if ~exist('Derivatives\VBM\Vis', 'dir')
                    mkdir('Derivatives\VBM\Vis')
                end % if
                obj.output = 'Derivatives\VBM\Vis';
            else
                error('illegal group identifier...')
            end
            run_contrast([obj.contrasttempalte()])
            file = struct(obj);
            save(['Derivatives\', sprintf('Contrast_g_%d.mat', obj.group)],"file")
            clear file

        end % contrast

    end % methods

% % %     methods(Static)
% % %         function json = write_json(x)
% % %             j = struct();
% % %             fields = fieldnames(x);
% % %             c=0;
% % %            for f = fields'
% % %                c=c+1;
% % %                j.type = f{:}
% % %                x.(f{:})  = {x.(f{:})};
% % %                index(c)  = isempty(x.(f{:}));
% % %                if istable(x.(f{:}))
% % %                    x.(f{:}) =  table2cell(x.(f{:}));
% % %                elseif isobject(x.(f{:}))
% % %                    index(c)  = true;
% % %                end
% % %            end
% % %            x = rmfield(x, fields(index));
% % %            g.g = "text"
% % %            json = jsondecode(g);
           
% % %         end
% % %     end % methods static
end % POSTPROC

