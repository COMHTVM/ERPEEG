% Author: Ye Mei, Luis Garcia Dominguez,Faranak Farzan   2015

% tmseeg_interpolation() - interpolated removed channels based off original
% channel configuration from data loading.  Also rereferences data and pads
% for time segment removed in tmseeg_rm_TMS_artifact.

% Inputs: 
%     S             - parent GUI information (structure)
%     step_num      - Step number for current cleaning step in workflow


% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.

function ERP_interpolation(S,step_num)
global basefile VARS basepath
h = msgbox('Interpolating,now!');
[files, EEG] = tmseeg_load_step(step_num);

%Compare current and original channel configurations
badchan = ~ismember({EEG.chanloc_orig.labels},{EEG.chanlocs.labels});

% Interpolate channels if they have been removed
if EEG.nbchan < EEG.nbchan_o
	EEG         = pop_interp(EEG, EEG.chanloc_orig, 'spherical');
end
EEG.channels_interpolated = find(badchan);
EEG 	= eeg_checkset( EEG );
EEG 	= pop_reref( EEG, []);

save(fullfile(basepath,[basefile '_ERP_settings.mat']), 'VARS');
tmseeg_step_check(files, EEG, S, step_num)

close(h)