% -*- coding: 'UTF-8' -*-
function cleanUP(rest)
% cleanUP moves the generated segmented and DARTEL scans to preproc folder

for subs = 1:numel(rest)

    all_scans = spm_select('List', rest{subs}, '.*\.nii$');   % all the scans
    orig_scan = spm_select('List',rest{subs}, '^\d.*\.nii$'); % orig scan, the one that starts with digit

    scans_to_move =  all_scans(~ismember(cellstr(all_scans),cellstr(orig_scan)),:);
    for num_scans_to_move = 1:size(scans_to_move)
        if ~exist(fullfile('Preproc\rest', ... check if the subject preproc anat exists
                cell2mat(regexp(rest{subs}, '\d+', 'match')) ...
                , 'func'), ...
                'dir')
            mkdir(fullfile('Preproc\rest', ...
                cell2mat(regexp(rest{subs}, '\d+', 'match')) ... create subject preproc anat
                , 'func'))
        end

        movefile(fullfile(rest{subs}, strtrim(scans_to_move(num_scans_to_move ,:))),...
            fullfile('Preproc\rest', ...
            cell2mat(regexp(rest{subs}, '\d+', 'match')) ... create subject preproc anat
            , 'func', strtrim(scans_to_move(num_scans_to_move ,:))))

    end

    % move mat
    mat_file = spm_select('List', rest{subs}, '.*\.mat$');

    for num_mat_to_move = 1:size(mat_file)
        if ~exist(fullfile('Preproc\rest', ... check if the subject preproc anat exists
                cell2mat(regexp(rest{subs}, '\d+', 'match')) ...
                , 'func'), ...
                'dir')
            mkdir(fullfile('Preproc\rest', ...
                cell2mat(regexp(rest{subs}, '\d+', 'match')) ... create subject preproc anat
                , 'func'))
        end

        movefile(fullfile(rest{subs}, strtrim(mat_file(num_mat_to_move ,:))),...
            fullfile('Preproc\rest', ...
            cell2mat(regexp(rest{subs}, '\d+', 'match')) ... create subject preproc anat
            , 'func', strtrim(mat_file(num_mat_to_move ,:))))

    end
    % move text
    txt_file = spm_select('List', rest{subs}, '.*\.txt$');

    for num_mat_to_move = 1:size(txt_file)
        if ~exist(fullfile('Preproc\rest', ... check if the subject preproc anat exists
                cell2mat(regexp(rest{subs}, '\d+', 'match')) ...
                , 'func'), ...
                'dir')
            mkdir(fullfile('Preproc\rest', ...
                cell2mat(regexp(rest{subs}, '\d+', 'match')) ... create subject preproc anat
                , 'func'))
        end

        movefile(fullfile(rest{subs}, strtrim(txt_file(num_mat_to_move ,:))),...
            fullfile('Preproc\rest', ...
            cell2mat(regexp(rest{subs}, '\d+', 'match')) ... create subject preproc anat
            , 'func', strtrim(txt_file(num_mat_to_move ,:))))
    end
end

end