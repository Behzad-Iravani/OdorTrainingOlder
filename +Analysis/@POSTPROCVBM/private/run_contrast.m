% -*- coding: 'UTF-8' -*-
function run_contrast(batch)


fprintf('Computed difference\n')
spm('defaults', 'FMRI');
for i=1:numel(batch)
spm_jobman('run', batch(i));
end

end