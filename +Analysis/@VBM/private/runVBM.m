
function runVBM()
% This script runs VBM analysis
%-----------------------------------------------------------------------
% Job saved on 28-Aug-2018 15:34:30 by cfg_util (rev $Rev: 6460 $)
% spm SPM - SPM12 (6906)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------

%{

participants = readtable('Subj_labels.xlsx');
demo = readtable('Behavior_Older_Adults.xlsx');


participants.Properties.VariableNames ={'Subj_num', 'Time_Point', 'Group', 'Date', 'ID'};
participants = table2struct(participants);

bids.util.tsvwrite('Participants.tsv', participants)
%}

%% Clear Memory
fprintf('running VBM...\n')
global current_path
%% Initializing SPM
fprintf('Initializing SPM...\n')
spm('defaults','fmri');
spm_jobman('initcfg');
%% assign the base dir
basedir    = current_path;
fprint('Base directory: %s\n', base_dir)
%% read T1 scans
T1            = fullfile(basedir, 'SU_Raw_T1');    % paths to T1 images
[~ ,~ ,Label] = xlsread('Subj_labels.xlsx');       % read subjects lalbel
Label(find(sum([Label{:,5}] == 7503,2)),:) =[];    % removing subject 7503
Label(find(strcmp(Label(:,5), 'x')),:) = [];
%% read demographic information
[~,~,Tble2]                                = xlsread('MRC362_SMELLMEM_log_20171027.xlsx');
Tble2(~cellfun(@isnumeric,Tble2(:,3)),3)   = {nan};% find missing values


%% read scans
Scans            = dir('F:\Projects\Sweden\SUOdorTraining\01_SU_TransferGain\SU_Rest\Data\Scans\SU_Raw');
Scans            = Scans(~ismember({Scans.name},{'.','..'}));
participants = table();
for i=1:numel(Scans)


    tmp = unique([Tble2{str2num(Scans(i).name)==[Tble2{:,3}],8}]);
    day = rem(tmp/100,1)*100;
    month = rem(fix(tmp/100)/100,1)*100;
    year  = fix(tmp/1e4);


    index = find(demo.Date_T1 == datetime(round([year month day]),'Format','uuuu-MM-dd') | ...
        demo.Date_T2 == datetime(round([year month day]),'Format','uuuu-MM-dd'));

    participants.hasBHV(i) = ~isempty(index);

    participants.Subj(i)       =  cell2mat(Label(str2num(Scans(i).name) == [Label{:,5}] ,1));% subject's unique ID
    participants.Group(i)      =  cell2mat(Label(str2num(Scans(i).name) == [Label{:,5}] ,3));% groups
    participants.Timepoint{i}  =  cell2mat(Label(str2num(Scans(i).name) == [Label{:,5}] ,2));% time
    participants.ScanL{i}      =  Scans(i).name; % scan label

    participants.ScanDate(i) =  datetime(round([year month day]),'Format','uuuu-MM-dd');% date
    if all(~isnan(unique([Tble2{str2num(Scans(i).name)==[Tble2{:,3}],7}])))
    participants.Maleness(i) =  strcmp(strtrim(unique([Tble2{str2num(Scans(i).name)==[Tble2{:,3}],7}])),'M');% gender
    end
    if participants.hasBHV(i)
        participants.uniqueNr(i)   =   demo.UniqueNr(index);
        participants.sex(i) =  demo.K__n(index);
        participants.Age(i) =  demo.x__lder(index);
    else
        participants.uniqueNr(i)   =   nan;
        participants.sex(i) =  nan;
        participants.Age(i) =  nan;

    end

end
%% ------------------------------------------------------------------------
G2 = Group;
S2 = Subj;
G2(Group==0 | Subj==0 )=[];
S2(Group==0 | Subj==0 ) =[];
Timepoint(Group==0 | Subj==0 )=[];
ScanL(Group==0 | Subj==0) = [];
c=0;

clear GG1 GG2 out1 out2
% --- Scans pre
GG1(1,:)= S2(cellfun(@(x) strcmp(x,'T1'),Timepoint) & G2 ==  1);
GG2(1,:)= S2(cellfun(@(x) strcmp(x,'T2'),Timepoint) & G2 == 1);

for i= 1:length(GG1) Out1(i) =any(GG1(i)==GG2);end
for i= 1:length(GG2) Out2(i) =any(GG2(i)==GG1);end


Group1_pre = ScanL(cellfun(@(x) strcmp(x,'T1'),Timepoint) & G2 ==  1 );
Group1_post= ScanL(cellfun(@(x) strcmp(x,'T2'),Timepoint) & G2 == 1 );
Group1_pre (~Out1)=[];
Group1_post(~Out2)=[];
GG1 (~Out1)=[];
GG2(~Out2)=[];

[~,I] = sort(GG1);
Group1_pre = Group1_pre(I);

[~,I] = sort(GG2);
Group1_post = Group1_post(I);


clear matlabbatch
matlabbatch{1}.spm.stats.factorial_design.dir = {'Z:\PERSONAL\Behzad\SU_Rest\VBM\Result'};
load Z:\PERSONAL\Behzad\SU_Rest\VBM\batch\Vols.mat

for i=1:length(Group1_pre)

    Vpre(i) = Volume.ITV(cellfun(@(x) strcmp(x,Group1_pre{i}),Volume.Files),1);
    Gray =  dir(strcat(T1,filesep, Group1_pre{i},filesep,'smwc1*'));

    AGEPre(i) = Maleness(cellfun(@(x) strcmp(x,Group1_pre{i}),ScanL));


    matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(i).scans(1,:) = cellstr(...
        strcat(T1,filesep, Group1_pre{i},...
        filesep,Gray.name...
        ,',1'));


end
j=0;
for i=1:length(Group1_post)

    Vpst(i) = Volume.ITV(cellfun(@(x) strcmp(x,Group1_post{i}),Volume.Files),1);
    Gray =  dir(strcat(T1,filesep,Group1_post{i},filesep,'smwc1*'));

    AGEPst(i) = Maleness(cellfun(@(x) strcmp(x,Group1_pre{i}),ScanL));


    matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(i).scans(2,:) = cellstr(...
        strcat(T1,filesep, Group1_post{i},...
        filesep,Gray.name...
        ,',1'));

end
matlabbatch{1}.spm.stats.factorial_design.des.pt.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.pt.ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});

c1 = [Vpst;Vpre];
% total volume
matlabbatch{1}.spm.stats.factorial_design.cov(1).cname = 'TotalVol';
matlabbatch{1}.spm.stats.factorial_design.cov(1).c =c1(:);
matlabbatch{1}.spm.stats.factorial_design.cov(1).iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov(1).iCC  = 1;
% sex
c2 = [AGEPre;AGEPst];
matlabbatch{1}.spm.stats.factorial_design.cov(2).cname = 'Sex';
matlabbatch{1}.spm.stats.factorial_design.cov(2).c =double(c2(:));
matlabbatch{1}.spm.stats.factorial_design.cov(2).iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov(2).iCC  = 1;


matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 0;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {'C:\toolbox\spm12\spm12\tpm\mask_ICV.nii,1'};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;

spm_jobman('run',matlabbatch)
save Z:\PERSONAL\Behzad\SU_Rest\VBM\batch\vbmbatchG1.mat matlabbatch


%% Estimate model


[Files,Dirs]    = spm_select('List','Z:\PERSONAL\Behzad\SU_Rest\VBM\Result\','SPM.mat$');
SPM_matfile     = strcat('Z:\PERSONAL\Behzad\SU_Rest\VBM\Result\',filesep,Files(:,:));

load(strcat('Z:\PERSONAL\Behzad\SU_Rest\VBM\Result',filesep,'VBM_estimate_model.mat'));
matlabbatch{1}.spm.stats.fmri_est.spmmat = cellstr(SPM_matfile);

spm_jobman('run',matlabbatch)



