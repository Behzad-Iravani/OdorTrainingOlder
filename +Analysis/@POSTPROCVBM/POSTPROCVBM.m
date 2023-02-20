% -*- coding: 'UTF-8' -*-
classdef POSTPROCVBM< Analysis.analysis_
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
        totalvolume(1,1) stuct  % total cranial volume needed to be corrected in VBM
    end
    
    methods
        function obj = POSTPROCVBM(Data, BidsPath, analysis)
            % POSTPROC Construct an instance of this class
            if nargin>0
                obj.Data            = Data;
                obj.BidsPath        = BidsPath;
                obj.analysis        = analysis;
                           
            end %end nargin 
        end % end constuctor
    
        function obj = run(obj)
          clc;
          path_preproc = regexprep(obj.Data.T1, 'Dataset', 'preproc\\VBM');
          for folder = 1:numel(path_preproc)
            if exist(path_preproc{folder}, 'dir') 
                disp('reading MRR log')
                
                T1_preproc = spm_select('list', path_preproc{folder}, '^smwc1.*\.nii$');

            else
                warning('no preprocessed T1 folder: %s', path_preproc{folder})
            end
          end
          dir()

        end % end run
    
        function totalvolume = get.totalvolume(obj) 
             disp('Estimating the total cranial volume...')
             totalvolume = obj.estimate_total_volume();   
             disp('done!')
        end % end get total volume
    end % methods      
end % POSTPROC

