% -*- coding: 'UTF-8' -*-
classdef analysis_ < Analysis.neurodata
    % The subclass analysis. This is script is part of the analysis for the odor training in older adults project.
    % 
    %     Author: Behzad Iravani
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
                    %'preprocessing'
                    case 'vbm'
                        % call vbm object
                        % setup preproc analysis for VBM
                        disp('Constructing VBM object')
                        answer_seg = input('Applying  segmentation, [y/n]? ','s');
                        answer_DARTL = input('Applying  DARTEL normalization, [y/n]? ','s');
                        answer_volume = input('Applying  volume normalization, [y/n]? ','s');
                        answer_concentration = input('Applying  concentration normalization, [y/n]? ','s');
                        
                        translator = containers.Map({'y', 'n'}, [true , false]); % converts string to boolean

                        obj.analysis.method.vbm = Analysis.VBM(obj.Data, obj.BidsPath, obj.analysis,...
                            translator(answer_seg),...
                            translator(answer_DARTL),...
                            translator(answer_volume),...
                            translator(answer_concentration));
                 
                    %%----------------------------------------------------%%
                    case 'rest'
                        % call rest object
                        % setup preproc analysis for REST
                        disp('Constructing REST object')
                        answer_realign = input('Applying  realignment, [y/n]? ','s');
                        answer_motion = input('Applying  motion correction, [y/n]? ','s');
                        answer_slicetc = input('Applying  slice time correction, [y/n]? ','s');
                        answer_correg = input('Applying  coregistration, [y/n]? ','s');
                        answer_norm = input('Applying  normalization, [y/n]? ','s');
                        answer_art = input('Applying  artifact detection using conn, [y/n]? ','s');
                        
                        translator = containers.Map({'y', 'n'}, [true , false]); % converts string to boolean
                        
                        obj.analysis.method.rest = Analysis.REST(...
                            obj.Data,...
                            obj.BidsPath,...
                            obj.analysis,...
                            translator(answer_realign),...
                            translator(answer_motion),...
                             translator(answer_art),...
                            translator(answer_slicetc),...
                            translator(answer_correg),...
                            translator(answer_norm));
                        %%----------------------------------------------------%%
                    %%postprocessing 
                    case 'postprocVBM'
                         disp('Constructing POSTPROCVBM object')
                         disp('reading list from .tsv file,...') 
                         list =  readtable('Dataset.tsv', 'FileType','text');
                         disp('create job for group 1: olfactory training')
                         obj.analysis.method.postprocVBM{1} = Analysis.POSTPROCVBM(...
                            obj.Data,...
                            obj.BidsPath,...
                            obj.analysis,list,1); % olfactory training 
                         disp('create job for group 2: visual training')
                         obj.analysis.method.postprocVBM{2} = Analysis.POSTPROCVBM(...
                             obj.Data,...
                            obj.BidsPath,...
                            obj.analysis,list,2); % visual training 
                        disp('done!')
                        %%----------------------------------------------------%%
                    case 'postprocREST'

                        %%----------------------------------------------------%%
                end

            end % end if nargin
        end % end JobConstructor method
    end % end methods
    methods (Static)
        
    end
end % end classs



