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
            obj.DataSet = struct();
            for i=1:numel(obj.T1)
                name =  str2double(...
                    cell2mat(regexp(obj.T1{i}, '\d+(?=\\(anat))', 'match'))...
                    );
                if any(cell2mat(Label(name == [Label{:,5}]& ~isnan([Label{:,5}]),1)))
                    c = c+1;
                    obj.DataSet.Subj(c,1) =  cell2mat(Label(name == [Label{:,5}] & ~isnan([Label{:,5}]) ,1));
                    obj.DataSet.Group(c,1)=  cell2mat(Label(name == [Label{:,5}] & ~isnan([Label{:,5}]) ,3));
                   
                    if any([BHV1{1:end,1}] == obj.DataSet.Subj(c)) 
                        obj.DataSet.Age(c,1)               =  BHV1{[BHV1{1:end,1}]  == obj.DataSet.Subj(c) ,4};
                        obj.DataSet.Gender{c,1} =  strtrim(unique([Tble2{name ==[Tble2{:,3}],7}]));
                        
                        obj.DataSet.aOdorMeM(c,1)         = BHV1{[BHV1{1:end,1}]  == obj.DataSet.Subj(c) ,176};
                        obj.DataSet.bOdorMeM(c,1)         = BHV1{[BHV1{1:end,1}]  == obj.DataSet.Subj(c) ,177};


                        obj.DataSet.aVisMeM(c,1)         = BHV1{[BHV1{1:end,1}]  == obj.DataSet.Subj(c) ,179};
                        obj.DataSet.bVisMeM(c,1)         = BHV1{[BHV1{1:end,1}]  == obj.DataSet.Subj(c) ,180};
                        
                        obj.DataSet.TrainGain(c,1)         = BHV1{[BHV1{1:end,1}]  == obj.DataSet.Subj(c) ,167};
                        obj.DataSet.TransferGrain(c,1)     = BHV1{[BHV1{1:end,1}]  == obj.DataSet.Subj(c) ,168};

                        obj.DataSet.aCogn(c,1)             = BHV1{[BHV1{1:end,1}]  == obj.DataSet.Subj(c) ,173};
                        obj.DataSet.bCogn(c,1)             = BHV1{[BHV1{1:end,1}]  == obj.DataSet.Subj(c) ,174};
                        obj.DataSet.CognGain(c,1)          = obj.DataSet.bCogn(c,1)- obj.DataSet.aCogn(c,1);

                        obj.DataSet.aThresh(c,1)           = BHV1{[BHV1{1:end,1}]  == obj.DataSet.Subj(c) ,24};
                        obj.DataSet.bThresh(c,1)           = BHV1{[BHV1{1:end,1}]  == obj.DataSet.Subj(c) ,25};
                        obj.DataSet.ThreshGain(c,1)        = obj.DataSet.bThresh(c,1)- obj.DataSet.aThresh(c,1);

                        obj.DataSet.aDisc(c,1)             = BHV1{[BHV1{1:end,1}]  == obj.DataSet.Subj(c) ,28};
                        obj.DataSet.bDisc(c,1)             = BHV1{[BHV1{1:end,1}]  == obj.DataSet.Subj(c) ,29};
                        obj.DataSet.DiscGain(c,1)          = obj.DataSet.bDisc(c,1)- obj.DataSet.aDisc(c,1);

                        obj.DataSet.aID(c,1)               = BHV1{[BHV1{1:end,1}]  == obj.DataSet.Subj(c) ,13};
                        obj.DataSet.bID(c,1)               = BHV1{[BHV1{1:end,1}]  == obj.DataSet.Subj(c) ,14};
                        obj.DataSet.IDGain(c,1)            = obj.DataSet.bID(c,1)- obj.DataSet.aID(c,1);
                    else
                        obj.DataSet.Age(c,1)               = nan();
                        obj.DataSet.Gender{c,1}          = nan();
                        obj.DataSet.aOdorMeM(c,1)          = nan(); 
                        obj.DataSet.bOdorMeM(c,1)          = nan(); 
                        obj.DataSet.aVisMeM(c,1)           = nan(); 
                        obj.DataSet.bVisMeM(c,1)           = nan(); 
                        obj.DataSet.TrainGain(c,1)         = nan();
                        obj.DataSet.TransferGrain(c,1)     = nan();
                        obj.DataSet.aCogn(c,1)             = nan();
                        obj.DataSet.bCogn(c,1)             = nan();
                        obj.DataSet.CognGain(c,1)          = nan();
                        obj.DataSet.aThresh(c,1)           = nan();
                        obj.DataSet.bThresh(c,1)           = nan();
                        obj.DataSet.ThreshGain(c,1)        = nan();
                        obj.DataSet.aDisc(c,1)             = nan();
                        obj.DataSet.bDisc(c,1)             = nan();
                        obj.DataSet.DiscGain(c,1)          = nan();
                        obj.DataSet.aID(c,1)               = nan();
                        obj.DataSet.bID(c,1)               = nan();
                        obj.DataSet.IDGain(c,1)            = nan();
                    end
                   
                    obj.DataSet.Timepoint{c,1} = cell2mat(Label(name == [Label{:,5}] & ~isnan([Label{:,5}]) ,2));
                    obj.DataSet.T1{c,1} = obj.T1{i};
                    obj.DataSet.rest{c,1} = obj.rest{i};
                   
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