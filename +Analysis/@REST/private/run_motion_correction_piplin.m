% -*- coding: 'UTF-8' -*-
function run_motion_correction_piplin()


txtfile = dir(fullfile(d(i).name,'*.txt'));

motion = dlmread(fullfile(d(i).name,txtfile.name));


end
