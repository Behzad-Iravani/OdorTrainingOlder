% -*- coding: 'UTF-8' -*-
function run_motion_correction_piplin(subjects)
% run_motion_correction_piplin uses the realignment parameters to extract
% frame wise displacement.
%     Author: Behzad Iravani
%     behzadiravani@gmail.com
%
%    Spetember 2018
%    Revised: December 2022
% This method is part of the odor training older adults project
for i = 1:numel(subjects)
    txtfile = dir(fullfile(subjects{i},'*.txt')); % read rp text file
    motion  = dlmread(fullfile(subjects{i},txtfile.name));

    f = strsplit(txtfile.name, '_task-rest_bold'); % retrive subjects name 
    % frame waise difference -- linear
    RPDiff = diff(motion); 
    RPDiff = [zeros(1,6);RPDiff];
    % frame waise difference -- sphereical
    RPDiffSphere       = RPDiff;
    RPDiffSphere(:,4:6)= RPDiffSphere(:,4:6)*50; % average head size of 50
    % computed FD
    FD_Power        = sum(abs(RPDiffSphere),2);
    MeanFD_Power(i) = mean(FD_Power);

 

    imagesc(RPDiff,[0 1e-1])
    colormap('hot')
    set(gca,'xtick',1:6)
    set(gca,'xticklabel',{'x','y','z','rx','ry','rz'})
    pbaspect([.5 1 1])
    set(gca,'FontSize',12,'FontName','Arial');
    ylabel('Scans')
    text(1.2, .5, sprintf('FD = %1.2f',MeanFD_Power(i)),'Units','Normalized',...
        'FontSize',12,'FontName','Arial')
    title(strcat('Subject ID = ' ,f{1}(4:end)))
    print(strcat('Result',filesep,f{1}(4:end),'.png'),'-dpng','-r600 ')

end % subjects

figure
pos=[1];
tmp = lines(1);
col =tmp;
c=0;

V=External.Violin({MeanFD_Power},pos(1) , 'Width',.25, 'ViolinColor',{col(1,:)},...
        'BoxColor',col(1,:),'ViolinAlpha', {.2},'ShowData',true,'EdgeColor',col(1,:));
    
set(gca,'xtick','')
set(gca,'ytick',0:0.25:0.75,'FontSize',12,'FontName','Arial')
set(gca,'ylim',[0,1])

ylabel('FD Measure','FontSize',16,'FontName','Arial')
pbaspect([.5 1 1])
print('Result\FDMeasure.png','-dpng','-r600 ')
end
