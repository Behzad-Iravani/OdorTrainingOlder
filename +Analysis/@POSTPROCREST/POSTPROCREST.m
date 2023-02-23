% -*- coding: 'UTF-8' -*-
classdef POSTPROCREST< Analysis.analysis_
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
    
%     properties
%         volumeflag(1,1) logical % whether the extracting volume is performed (true) or not (false)
%     end

    properties 
        Atlas
    end
    
    methods
        function obj = POSTPROCREST(Data, Atlas)
            % POSTPROC Construct an instance of this class
            if nargin>0
                obj.Data            = Data;
                obj.Atlas           = Atlas;
            


                           
            end %end nargin 
        end % end constuctor
    
        function obj = roi_extract_tcs(obj)
            conn_module('preprocessing', 'steps',  'functional_roiextract')


        end % end run
    
    end % methods      
end % POSTPROC

