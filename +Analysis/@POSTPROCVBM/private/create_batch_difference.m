% -*- coding: 'UTF-8' -*-
function matlabbatch = create_batch_difference(obj)
DM = obj.list(obj.list.Group == obj.group, :);


for i=1:length(obj.Indx_Pre)
    matlabbatch{i}.spm.util.imcalc.input ={};

    matlabbatch{i}.spm.util.imcalc.outdir = {obj.output};
    matlabbatch{i}.spm.util.imcalc.expression = 'i2-i1';
    matlabbatch{i}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{i}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{i}.spm.util.imcalc.options.mask = 0;
    matlabbatch{i}.spm.util.imcalc.options.interp = 1;
    matlabbatch{i}.spm.util.imcalc.options.dtype = 4;
    matlabbatch{i}.spm.util.imcalc.output = strcat(num2str(DM.Subj(obj.Indx_Pre(i))),'_pst-pre');
    Gray =  dir([regexprep(DM.T1{obj.Indx_Pre(i)}, 'Dataset', 'Preproc\\VBM'),filesep,'smwrc1*']);
    matlabbatch{i}.spm.util.imcalc.input(1,1)= cellstr([...
        Gray.folder,...
        filesep,Gray.name...
        ,',1']);
    Gray = dir([regexprep(DM.T1{obj.Indx_Pos(i)}, 'Dataset', 'Preproc\\VBM'),filesep,'smwrc1*']);
    matlabbatch{i}.spm.util.imcalc.input(2,1)= cellstr([...
        Gray.folder,...
        filesep,Gray.name...
        ,',1']);
end