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

    properties(Dependent)
        
    end
    
    methods
        function obj = POSTPROCREST(Data, BidsPath, analysis)
            % POSTPROC Construct an instance of this class
            if nargin>0
                obj.Data            = Data;
                obj.BidsPath        = BidsPath;
                obj.analysis        = analysis;
                           
            end %end nargin 
        end % end constuctor
    
        function obj = run(obj)


        end % end run
    
    end % methods      
end % POSTPROC

