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
            end
        end
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
end % class end