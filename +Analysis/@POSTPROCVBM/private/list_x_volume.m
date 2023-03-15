function v = list_x_volume(list_, volumes)
[~, ~, ib] = intersect(cellfun(@(x) regexp(x, '\d+(?=\\anat)', 'match'), list_.T1),...
cellfun(@(x) regexp(x, '\d+(?=_T1W.nii_seg8.mat)', 'match'), volumes.File));

v = volumes(ib,:);