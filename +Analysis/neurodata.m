% -*- coding: 'UTF-8' -*-
classdef neurodata < handle
    % neuro data object
    % the data should be structured as BIDS format
    % This is script is part of the analysis for the odor training in older adults project.
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
        BidsPath    % path to BIDs format scans
        DataSet         % table contains the BHV data
    end
    %%---------------------------------%%
    properties (Dependent)
        T1          % structural T1 scans
        rest        % functional echo plannar scans
    end
    %%---------------------------------%%
    methods
        function nd = neurodata(BidsPath) % constructor method
            if nargin>0
                nd.BidsPath = BidsPath;
                nd.DataSet  = struct();
            end
        end

        function obj = getBHVData(obj)
            %// Read Lables and subjcet infos
            [~ ,~ ,Label] = xlsread('+Analysis\MRI_Journal.xlsx');
            Label(find(sum([Label{:,5}] == 7503,2)),:) =[];
            Label(~cellfun(@isnumeric,Label(:,5)),5) = {nan}; % remove non numeric values
            Label(cellfun(@(x) x == -999,Label(:,5)),5) = {nan};
            %// Behavioral Measures
            [~,~,BHV1] = xlsread('+Analysis\Behavior_Older_Adults.xlsx');
            BHV1(~cellfun(@isnumeric,BHV1(:,1)),1) = {nan};% remove non numeric values
            %// Read MR Journals
            [~,~,Tble2] = xlsread('+Analysis\MRC362_SMELLMEM_log_20171027.xlsx');
            Tble2(~cellfun(@isnumeric,Tble2(:,3)),3) = {nan};% remove non numeric values
            c = 0;
            for i=1:numel(obj.T1)
                        name =  str2double(...
                        cell2mat(regexp(obj.T1{i}, '\d+(?=\\(anat))', 'match'))...
                        );
                if any(cell2mat(Label(name == [Label{:,5}]& ~isnan([Label{:,5}]),1)))
                 
                    c = c+1;

                    obj.DataSet.Subj(c,1) =  cell2mat(Label(name == [Label{:,5}] & ~isnan([Label{:,5}]) ,1));
                    obj.DataSet.Group(c,1)=  cell2mat(Label(name == [Label{:,5}] & ~isnan([Label{:,5}]) ,3));
                    if any( [BHV1{1:end,1}] == obj.DataSet.Subj(c))
                        obj.DataSet.Age(c,1)  =  BHV1{[BHV1{1:end,1}]  == obj.DataSet.Subj(c) ,4};
                        obj.DataSet.TrainGain(c,1) = BHV1{[BHV1{1:end,1}]  == obj.DataSet.Subj(c) ,167};
                        obj.DataSet.TransferGrain(c,1)= BHV1{ [BHV1{1:end,1}]  == obj.DataSet.Subj(c) ,168};
                    else
                        obj.DataSet.Age(c,1)  =  nan();
                        obj.DataSet.TrainGain(c,1) = nan();
                        obj.DataSet.TransferGrain(c,1)= nan();
                    end

                    obj.DataSet.Timepoint{c,1} = cell2mat(Label(name == [Label{:,5}] & ~isnan([Label{:,5}]) ,2));
                    obj.DataSet.T1{c,1} = obj.T1{i};
                    obj.DataSet.rest{c,1} = obj.rest{i};
                    obj.DataSet.Maleness(c,1) =  strcmp(unique([Tble2{name ==[Tble2{:,3}],7}]),' M');
                end
            end

            %%// Sort data
            [~,I] = sort(obj.DataSet.Subj);
            obj.DataSet = structfun(@(x) x(I), obj.DataSet,'UniformOutput',0);
        end% getBHVDATA
    function t1 = get.T1(obj)
        sub = dir(obj.BidsPath);
        sub(ismember({'.','..'}, {sub.name})) = [];
        fprintf('%d anat : subject folder(s) found.\n', numel(sub))
        for s = 1:numel(sub)
            t1{s,1} = fullfile(sub(s).folder, sub(s).name, 'anat');
        end
    end % get T1 scans end

    function r = get.rest(obj)
        sub = dir(obj.BidsPath);
        sub(ismember({'.','..'}, {sub.name})) = [];
        fprintf('%d rest : subject folder(s) found.\n', numel(sub))
        for s = 1:numel(sub)
            r{s,1} = fullfile(sub(s).folder, sub(s).name, 'func');
        end
    end % get rest scans end
    end % methods end
    methods(Static)
        function [Indx_Pre, Indx_Pos] = getIndex(DataSet, group)
            % 1: olfactory traning 
            % 2: visual training 
            % --- Scans pre
            Indx_Pre = find(cellfun(@(x) strcmp(x,'T1'),DataSet.Timepoint) & DataSet.Group == group); 
            %--- Scans post
            Indx_Pos = find(cellfun(@(x) strcmp(x,'T2'),DataSet.Timepoint) & DataSet.Group == group); 

            if length(Indx_Pos)> length(Indx_Pre)

                rm = setdiff(DataSet.Subj(Indx_Pos),DataSet.Subj(Indx_Pre));
                Indx_Pos(arrayfun(@(x) find(DataSet.Subj(Indx_Pos)==x),rm','UniformOutput',1)) = [];
            end
            if length(Indx_Pos)<length(Indx_Pre)
                rm = setdiff(DataSet.Subj(Indx_Pre),DataSet.Subj(Indx_Pos));
                Indx_Pre(arrayfun(@(x) find(DataSet.Subj(Indx_Pre)==x),rm','UniformOutput',1)) = [];

            end
        end

    end % methods Static 
end % class end