% -*- coding: 'UTF-8' -*-
function cleanUP(T1)
% cleanUP moves the generated segmented and DARTEL scans to preproc folder  

for subs = 1:numel(T1)

        all_scans = spm_select('List', T1{subs}, '.*\.nii$');   % all the scans
        orig_scan = spm_select('List',T1{subs}, '^\d.*\.nii$'); % orig scan, the one that starts with digit
       
        scans_to_move =  all_scans(~ismember(cellstr(all_scans),cellstr(orig_scan)),:);
        for num_scans_to_move = 1:size(scans_to_move)
            if ~exist(fullfile('Preproc\VBM', ... check if the subject preproc anat exists
                    cell2mat(regexp(T1{subs}, '\d+', 'match')) ...
                    , 'anat'), ...
                     'dir')
                mkdir(fullfile('Preproc\VBM', ...
                    cell2mat(regexp(T1{subs}, '\d+', 'match')) ... create subject preproc anat
                    , 'anat'))
            end

            movefile(fullfile(T1{subs}, strtrim(scans_to_move(num_scans_to_move ,:))),...
                fullfile('Preproc\VBM', ...
                    cell2mat(regexp(T1{subs}, '\d+', 'match')) ... create subject preproc anat
                    , 'anat', strtrim(scans_to_move(num_scans_to_move ,:))))

        end

         % move mat 
        mat_file = spm_select('List', T1{subs}, '.*\.mat$');

         for num_mat_to_move = 1:size(mat_file)
            if ~exist(fullfile('Preproc\VBM', ... check if the subject preproc anat exists
                    cell2mat(regexp(T1{subs}, '\d+', 'match')) ...
                    , 'anat'), ...
                     'dir')
                mkdir(fullfile('Preproc\VBM', ...
                    cell2mat(regexp(T1{subs}, '\d+', 'match')) ... create subject preproc anat
                    , 'anat'))
            end

            movefile(fullfile(T1{subs}, strtrim(mat_file(num_mat_to_move ,:))),...
                fullfile('Preproc\VBM', ...
                    cell2mat(regexp(T1{subs}, '\d+', 'match')) ... create subject preproc anat
                    , 'anat', strtrim(mat_file(num_mat_to_move ,:))))

        end
end

end