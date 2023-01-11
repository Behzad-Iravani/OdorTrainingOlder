% -*- coding: 'UTF-8' -*-
function matlabbatch = create_batch_realignment(~)
% Batch script for realignment
% Author:
% Behzad Iravani 
% behzadiravani@gmail.com
matlabbatch = {};

    matlabbatch{1}.spm.spatial.realign.estwrite.data{1} =cell(0,0); %#ok<*SAGROW>
    %%----------------------EOPTIONS---------------------------%%
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.quality = 1;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.sep     = 3;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.fwhm    = 5;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.rtm     = 1;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.interp  = 7;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.warp    = [0,0,0];
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.weight  = cell(0,1);
    %%----------------------ROPTIONS--------------------------%%
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [0,1];
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.interp = 7;
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.wrap = [0,0,0];
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.maskedPattern = 1;
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.prefix = 'r';


end