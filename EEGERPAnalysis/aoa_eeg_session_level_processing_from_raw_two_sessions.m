clear all
clc
%%
fileLocation = 'Y:\HNCT_AoA_Study\AoA_Subjects\';
eeglabLocation = 'Y:/HNCT_AoA_Study/eeglab14_0_0b';
cleanline_dir = [eeglabLocation '/plugins/tmullen-cleanline-696a7181b7d0'];
cleanraw_dir = [eeglabLocation '/plugins/clean_rawdata-master'];
Photo_dir = [eeglabLocation '/sample_locs/GSN-HydroCel-257.sfp'];
sessionDate = '999999999999';
filename = {[fileLocation '/raw_EEG_part1.raw'],[fileLocation '/raw_EEG_part2.raw']};

%%
tic
cd(fileLocation)
if ~isfile([sessionDate '_Merged_EGI.mat']) 

    
    addpath(genpath(eeglabLocation))
    eeglab('nogui')
    disp('Loading file...')
    EEG1 = pop_readegi(filename{1});
    EEG2 = pop_readegi(filename{2});
    EEG = pop_mergeset(EEG1,EEG2);
    disp('File loaded.')
    clear EEG1;
    clear EEG2;
elseif isfile([sessionDate '_Merged_EGI.mat'])
    disp('EEG struct found. Loading...')
    load([sessionDate '_Merged_EGI.mat'])
end
loadDuration = toc


%% High Pass filter. For six AoA runs, will take ~3 min.
tic
addpath(genpath(eeglabLocation));
highpass_band = [0.25 0.75];        
disp('1Hz Highpass Data')
highpassEEG = clean_drifts(EEG,highpass_band); 

highpassDuration = toc

% Clean line noise. For six AoA runs, will take ~30 min.

disp('Applying cleanline to remove 60 Hz noise')
tic        
%Add plugins folder of EEGlab to path
addpath(genpath(cleanline_dir))

%Find the channel locations - saving this sensor location information
%because cleanline removes this information
chanlocs = highpassEEG.chanlocs;

%Run cleanline
cleanlineEEG = pop_cleanline(highpassEEG, 'bandwidth', 2,'chanlist', [1:highpassEEG.nbchan], 'computepower', 0, 'linefreqs', [60 120],...
'normSpectrum', 0, 'p', 0.01, 'pad', 2, 'plotfigures', 0, 'scanforlines', 1, 'sigtype', 'Channels', 'tau', 100,...
'verb', 1, 'winsize', 4, 'winstep', 2);

%Define the channel locations in the EEG structure
cleanlineEEG.chanlocs = chanlocs;

%Remove plugins folder of EEGlab from path because it conflicts
%with other functions
rmpath(genpath(cleanline_dir))

cleanlineDuration = toc

% Reject session channels. For six AoA runs, will take ~15 min.
%%
disp('Applying cleanline to remove 60 Hz noise')
rejectSessionChannelsTimeStart = datetime('now');

%Add plugins folder of EEGlab to path
addpath(genpath(cleanraw_dir))

%Parameters
chancorr_crit = 0.8;
channel_crit_maxbad_time = 0.5;
line_crit = 4;

cleanlineEEG.chanlocs = cleanlineEEG.urchanlocs;

%%
disp('Session-level channel rejection')
[~,bad_channels] = clean_channels(cleanlineEEG,chancorr_crit,line_crit,[],channel_crit_maxbad_time); %Use the clean_raw-data master plugin

%Define electrode number
bad_channels = find(bad_channels);

rejectSessionChannelsTimeEnd = datetime('now');

disp(['Time elapsed: ' num2str(seconds(rejectSessionChannelsTimeEnd-rejectSessionChannelsTimeStart)) ' seconds.'])

rejectSessionChannelsDuration = seconds(rejectSessionChannelsTimeEnd-rejectSessionChannelsTimeStart);

rmpath(genpath(cleanraw_dir))
% Reject session samples

%Parameters
window_crit_tolerances = [-Inf,7]; %Min and max SD %NOTE: the low end is set to negative 
%infinity so that rejections aren't made because their too quiet; While
%the default value in clean_windows is -3.5, 5; default in
%clean_artifact and pop_clean_rawdata is -Inf, 7;
window_crit = 0.25; %Maximum proportion of bad channels

disp('Reject time periods')
tic
%Bad samples is a mask of good (1) and bad (0) times periods
[cleanwindowEEG, bad_samples] = clean_windows(cleanlineEEG,window_crit,window_crit_tolerances);
windowCleaningDuration = toc

%Visualize rejected EEG data - new data vs old data

%vis_artifacts(cleanwindowEEG, cleanlineEEG);

    
    
%%

% Interpolate over bad channels

disp('Spherical interpolation')

%Set channel locations
cleanlineEEG.chanlocs = readlocs(Photo_dir); 
cleanlineEEG.urchanlocs = readlocs(Photo_dir);

%Remove Cz electrode (Note: if you don't remove it here pop_interp
%will find a mismatch in the number of channel locations and the
%data structure. Cz is added back in average referencing to correct
%this mistmatch)
cleanlineEEG.chanlocs(257) = []; 
cleanlineEEG.urchanlocs(257) = [];
tic
%Interpolation - Input: dataset, channels to interpolate, and method)
interpEEG = pop_interp(cleanlineEEG, bad_channels, 'spherical');
sphericalInterpolationDuration = toc

% Average Reference

disp('Average reference signal')

tic
%Set channel locations
interpEEG.chanlocs = readlocs(Photo_dir); 
interpEEG.urchanlocs = readlocs(Photo_dir);

%Average reference - Interpolated EEG data, average reference [], reference
%electrode info (CZ), and all electrode location info
EEG_avgref = reref(interpEEG.data,[],'refloc',interpEEG.chanlocs(257),'elocs',interpEEG.chanlocs);

%Rename data 
averageReferenceDuration = toc

% Save average reference, bad samples, bad channels, and merged EGI
cd(fileLocation)
tic
eval(['save ' sessionDate '_bad_channels_samples.mat bad_channels bad_samples -v7.3']);
eval(['save ' sessionDate '_EEG_avgref.mat EEG_avgref -v7.3']);
eval(['save ' sessionDate '_Merged_EGI.mat EEG -v7.3']);
fileSaveDuration = toc
