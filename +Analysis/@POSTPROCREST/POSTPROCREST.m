% -*- coding: 'UTF-8' -*-
classdef POSTPROCREST<handle
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
        Conn
        X
    end

    methods
        function obj = POSTPROCREST(ConnOutput, CONN_X)
            arguments
                ConnOutput {mustBeText(ConnOutput)}
                CONN_X {mustBeText(CONN_X)}
            end
            % POSTPROC Construct an instance of this class
            if nargin>0
                obj.Conn            = load(ConnOutput);
                load(CONN_X)
                obj.X  = array2table(CONN_x.Results.xX.X, 'VariableNames',CONN_x.Results.xX.nsubjecteffectsbyname);
            end %end nargin
        end % end constuctor

        function tstats = leastsquare(obj, C)
            X = obj.X;
            %             X = [ones(length(X),1), X];
            X.Age = zscore(X.Age);
            X  = table2array(X);
            X = repmat(C, size(X,1),1).* X;
            Y = obj.Conn.results.measures.BetweennessCentrality_roi;
            for cond =1:2
                for col = 1:size(Y,2)
                    % Use the normal equations to solve for the coefficients
                    coeffs(:,cond,col) = pinv(X' * X) * (X' * Y(cond:2:end,col));
                    coeffs(isnan(coeffs(:,cond,col)),cond,col) = 0;
                    % Calculate the residual error
                    yfit = X * coeffs(:,cond,col);
                    residual(:,cond,col) = norm(Y(cond:2:end,col) - yfit)^2;

                    % Calculate the covariance matrix
                    covariance = residual(:,cond,col) * pinv(X' * X);

                    % Calculate the t-statistics for each coefficient
                    tstats(:,cond,col) = coeffs(:,cond,col) ./ sqrt(diag(covariance));
                end
            end
        end % end least squarre
        function [pvalue, CI, stat] = contrast(obj,G)
            X = obj.X;
            Y = obj.Conn.results.measures.BetweennessCentrality_roi;
            post = Y(2:2:end,:);
            pre  = Y(1:2:end,:);
            switch G
                case 'olf'
                    [~, pvalue, CI, stat] = ttest(post(X.olf == 1,:),pre(X.olf == 1,:));
                case 'vis'
                    [~, pvalue, CI, stat] = ttest(post(X.vis == 1,:),pre(X.vis == 1,:));
            end
        end

    end % methods


    methods(Static)

        function write_to_nii(tmap, names, save)
            names =  cellfun(@(x) regexprep(x,'AAL.',''), names,'UniformOutput', false);
            v = spm_vol('Atlas\aal.nii');
           

            [y,~] = spm_read_vols(v);
            ynew =zeros(size(y));

            label = read_text_file('Atlas\aal.txt');
            [~, IA, ~] = intersect(label, names);
            for ci = 1:length(IA)
                ynew(y == IA(ci)) = tmap(ci);
            end
            v.fname = ['C:\Projects\Git\Conn_batch\conn_resting_group\results\secondlevel\RRC\', save,'_Hubness.nii'];
            v.dt = [spm_type('float32') 0];
            spm_write_vol(v, ynew);
            fh = conn_slice_display(v.fname)

            function lines = read_text_file(filename)
                % READ_TEXT_FILE reads in a text file and separates each line into a cell array
                % Usage: lines = read_text_file(filename)
                % Inputs:
                %   - filename: the name of the file to be read in (string)
                % Outputs:
                %   - lines: a cell array containing each line of the text file

                % Open the file for reading
                fid = fopen(filename, 'r');

                % Initialize the cell array to store the lines
                lines = {};

                % Loop through the file and read in each line
                while ~feof(fid)
                    % Read in the current line
                    line = fgetl(fid);

                    % Add the line to the cell array
                    lines{end+1} = line;
                end

                % Close the file
                fclose(fid);

            end
        end
    end
end % POSTPROC

