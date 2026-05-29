%% This script makes average traces across subjects of the delta (1-4 Hz), theta (4-8 Hz), alpha (8-12 Hz), and beta bands (12-40 Hz). 


allDirectories = dir('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Long_Epochs_For_Time_Frequency/');
allSubjectDirectories = [];
allSubjectNames = [];
allSubjectDays = [];
subject_names = [];
sessionDates = [];
window_size_factor = 4;
sliding_window_factor = 8;
sampling_rate = 1000;

% Get all subject directories
for entry = 3:length(allDirectories)
    subject_name = allDirectories(entry).name;
    allSubdirectories = dir(['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Long_Epochs_For_Time_Frequency/' subject_name]);
    for subdirectory = 3:length(allSubdirectories)
        allSubjectDirectories = [allSubjectDirectories;{['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Long_Epochs_For_Time_Frequency/' subject_name '/' allSubdirectories(subdirectory).name]}];
        
        allSubjectNames = [allSubjectNames; {subject_name}];
        allSubjectDays = [allSubjectDays;{allSubdirectories(subdirectory).name}];
        folderContents = dir(['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Long_Epochs_For_Time_Frequency/' subject_name '/' allSubdirectories(subdirectory).name]);
        sessionDates = [sessionDates; {folderContents(3).name(1:8)}];
    end
end

creationFunction = 'aoa_mean_wavelet_hpc.m'
%% Load all subject wavelet data and separate by awareness

allSubjectWavelets = [unique(allSubjectNames)'; cell(6,length(unique(allSubjectNames)))];
tic
for session = 1:length(allSubjectNames)
    
    disp(['Loading ' allSubjectNames{session} ', ' allSubjectDays{session}]);
    cd(allSubjectDirectories{session})
    load([sessionDates{session} '_mean_zscore_wavelet1000Hz.mat'])
    for subject = 1:length(allSubjectWavelets)
        if strcmp(allSubjectWavelets{1,subject},allSubjectNames{session})
            allSubjectWavelets{2,subject} = cat(4,allSubjectWavelets{2,subject},mean_wavelet_zscore_aware);
            allSubjectWavelets{3,subject} = cat(4,allSubjectWavelets{3,subject},mean_wavelet_zscore_unaware);
            allSubjectWavelets{4,subject} = [allSubjectWavelets{4,subject} length(kept_aware_trials)];
            allSubjectWavelets{5,subject} = [allSubjectWavelets{5,subject} length(kept_unaware_trials)]; 
        end
    end
    toc
end


%% Take weighted average across two EEG testing days if needed
allSubjectMeansAware = zeros([size(mean_wavelet_zscore_unaware) length(allSubjectWavelets)]);
allSubjectMeansAware = permute(allSubjectMeansAware,[3 1 2 4]);
allSubjectMeansUnaware = zeros([size(mean_wavelet_zscore_unaware) length(allSubjectWavelets)]);
allSubjectMeansUnaware = permute(allSubjectMeansUnaware,[3 1 2 4]);
allSubjectMeansAwareTwoSessionOnly = [];
allSubjectMeansUnawareTwoSessionOnly = [];
for subject = 1:length(allSubjectWavelets)
    disp(['Concatenating subject ' allSubjectWavelets{1,subject}])
    if length(allSubjectWavelets{4,subject}) == 2
        day2spect_aware = allSubjectWavelets{2,subject}(:,:,:,1);
        day2spect_aware = permute(day2spect_aware,[3 1 2]);
        day3spect_aware = allSubjectWavelets{2,subject}(:,:,:,2);
        day3spect_aware = permute(day3spect_aware,[3 1 2]);
        allSubjectMeansAware(:,:,:,subject) = (day2spect_aware*allSubjectWavelets{4,subject}(1) + day3spect_aware*allSubjectWavelets{4,subject}(2)) / sum(allSubjectWavelets{4,subject});
        allSubjectMeansAwareTwoSessionOnly = cat(4,allSubjectMeansAwareTwoSessionOnly,(day2spect_aware*allSubjectWavelets{4,subject}(1) + day3spect_aware*allSubjectWavelets{4,subject}(2)) / sum(allSubjectWavelets{4,subject}));
    elseif length(allSubjectWavelets{4,subject}) == 1
        allSubjectMeansAware(:,:,:,subject) = permute(allSubjectWavelets{2,subject},[3 1 2]);
    end
    if length(allSubjectWavelets{4,subject}) == 2
        day2spect_unaware = allSubjectWavelets{3,subject}(:,:,:,1);
        day2spect_unaware = permute(day2spect_unaware,[3 1 2]);
        day3spect_unaware = allSubjectWavelets{3,subject}(:,:,:,2);
        day3spect_unaware = permute(day3spect_unaware, [3 1 2]);
        allSubjectMeansUnaware(:,:,:,subject) = (day2spect_unaware*allSubjectWavelets{5,subject}(1) + day3spect_unaware*allSubjectWavelets{5,subject}(2)) / sum(allSubjectWavelets{5,subject});
        allSubjectMeansUnawareTwoSessionOnly = cat(4,allSubjectMeansUnawareTwoSessionOnly,(day2spect_unaware*allSubjectWavelets{5,subject}(1) + day3spect_unaware*allSubjectWavelets{5,subject}(2)) / sum(allSubjectWavelets{5,subject}));
    elseif length(allSubjectWavelets{4,subject}) == 1
        allSubjectMeansUnaware(:,:,:,subject) = permute(allSubjectWavelets{3,subject},[3 1 2]);
    end
    allSubjectWavelets{2,subject} = [];
    allSubjectWavelets{3,subject} = [];
end
%% Separate data into a group subject mean

allSubjectMeansAwareDelta = squeeze(mean(allSubjectMeansAware(:,1:4,:,:),2));
allSubjectMeansAwareTheta = squeeze(mean(allSubjectMeansAware(:,4:8,:,:),2));
allSubjectMeansAwareAlpha = squeeze(mean(allSubjectMeansAware(:,8:12,:,:),2));
allSubjectMeansAwareBeta = squeeze(mean(allSubjectMeansAware(:,12:30,:,:),2));
allSubjectMeansAwareGamma = squeeze(mean(allSubjectMeansAware(:,40:125,:,:),2));

allSubjectMeansUnawareDelta = squeeze(mean(allSubjectMeansUnaware(:,1:4,:,:),2));
allSubjectMeansUnawareTheta = squeeze(mean(allSubjectMeansUnaware(:,4:8,:,:),2));
allSubjectMeansUnawareAlpha = squeeze(mean(allSubjectMeansUnaware(:,8:12,:,:),2));
allSubjectMeansUnawareBeta = squeeze(mean(allSubjectMeansUnaware(:,12:30,:,:),2));
allSubjectMeansUnawareGamma = squeeze(mean(allSubjectMeansUnaware(:,40:125,:,:),2));

save(['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/aoa_group_wavelet_1000Hz.mat'],'allSubjectMeansAwareAlpha','allSubjectMeansUnawareAlpha','allSubjectMeansAwareBeta','allSubjectMeansUnawareBeta','allSubjectMeansAwareDelta','allSubjectMeansUnawareDelta','allSubjectMeansAwareGamma','allSubjectMeansUnawareGamma','allSubjectMeansAwareTheta','allSubjectMeansUnawareTheta','creationFunction','-v7.3')

%% Plot either power or z-score
method = 'Z-score'
startBin = floor(size(allSubjectMeansAware,3)/6);
endBin = 5*floor(size(allSubjectMeansAware,3)/6);
mean_aware_spectrogram = mean(allSubjectMeansAware,4);
mean_aware_spectrogram = mean_aware_spectrogram(:,:,startBin:endBin);
allSubjectMeansAware = allSubjectMeansAware(:,:,startBin:endBin,:);
mean_unaware_spectrogram = mean(allSubjectMeansUnaware,4);
allSubjectMeansUnaware = allSubjectMeansUnaware(:,:,startBin:endBin,:);
mean_unaware_spectrogram = mean_unaware_spectrogram(:,:,startBin:endBin);
mean_diff_spectrogram = mean_aware_spectrogram - mean_unaware_spectrogram;
close all
if strcmp(method,'Z-score')
    clims = [-4 4];
elseif strcmp(method,'Power')
    clims = [-0.5 0.5];
end





%% Plot the wavelet spectral analyses
smoothFactor = 100;
tic
% Define the total time range and number of bins
totalTimeRange = 6000;  % Milliseconds
numBins = length(startBin:endBin);
zeroPoint = size(mean_aware_spectrogram,3)/2
% Calculate the time interval per bin
timeIntervalPerBin = totalTimeRange / numBins;

% Generate the x-axis values for the bins
binIndices = 1:numBins;  % Assuming your bins are indexed from 1 to 124
timeValues = -4000 + (binIndices - 1) * timeIntervalPerBin;

cd('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Spectrogram_Figures_All_Freqs_Wavelet')
close all
for electrode = 1:257

    f = figure;
    hold on;
    subplot(1,3,1)
    imagesc(squeeze(mean_aware_spectrogram(electrode,:,:)));
    set(gca,'YDir','normal');
    caxis(clims);
    colormap('jet');
    xlim([0 size(allSubjectMeansAware,3)])
    ylim([0 125])
    line([zeroPoint zeroPoint], [0 125])
    set(gca,'FontSize',24)

    % Set x-axis labels
     xticks([0:100:1000]);  % Set the x-axis tick locations
     xticklabels(string(-2000:400:2000));  % Set the x-axis tick labels as strings

    title(['Aware, Electrode ' num2str(electrode)])
    xlabel(['Time from Confirm (ms)'])
    ylabel(['Frequency (Hz)'])
    subplot(1,3,2)
    imagesc(squeeze(mean_unaware_spectrogram(electrode,:,:)));
    set(gca,'YDir','normal');
    caxis(clims);
    colormap('jet');
    xlim([0 size(allSubjectMeansAware,3)])
    ylim([0 125])
    line([zeroPoint zeroPoint], [0 125])
    set(gca,'FontSize',24)

    % Set x-axis labels
     xticks([0:100:1000]);  % Set the x-axis tick locations
     xticklabels(string(-2000:400:2000));  % Set the x-axis tick labels as strings

    title(['Unaware, Electrode ' num2str(electrode)])
    xlabel(['Time from Confirm (ms)'])
    ylabel(['Frequency (Hz)'])
    subplot(1,3,3)
    imagesc(squeeze(mean_diff_spectrogram(electrode,:,:)));
    set(gca,'YDir','normal');
    caxis(clims);
    colormap('jet');
    colorbar
    xlim([0 size(allSubjectMeansAware,3)])
    ylim([0 125])
    line([zeroPoint zeroPoint], [0 125])
    set(gca,'FontSize',24)

     % Set x-axis labels
     xticks([0:100:1000]);  % Set the x-axis tick locations
     xticklabels(string(-2000:400:2000));  % Set the x-axis tick labels as strings

    title(['Difference, Electrode ' num2str(electrode)])
    xlabel(['Time from Confirm (ms)'])
    ylabel(['Frequency (Hz)'])
    set(f, 'WindowState', 'maximized');
    savefig(f,['E' num2str(electrode) '_Spectrogram.fig'])
    saveas(gcf,['E' num2str(electrode) '_Spectrogram.png'])
    close all
    
end

%%

tic
% Define the total time range and number of bins
totalTimeRange = 6000;  % Milliseconds
numBins = length(startBin:endBin);
zeroPoint = size(mean_aware_spectrogram,3)/2
% Calculate the time interval per bin
timeIntervalPerBin = totalTimeRange / numBins;

% Generate the x-axis values for the bins
binIndices = 1:numBins;  % Assuming your bins are indexed from 1 to 124
timeValues = -4000 + (binIndices - 1) * timeIntervalPerBin;

cd('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Spectrogram_Figures_Low_Freqs_Wavelet')
close all
for electrode = 1:257

    f = figure;
    hold on;
    subplot(1,3,1)
    imagesc(squeeze(mean_aware_spectrogram(electrode,:,:)));
    set(gca,'YDir','normal');
    caxis(clims);
    colormap('jet');
    xlim([0 size(allSubjectMeansAware,3)])
    ylim([0.5 60])
    line([zeroPoint zeroPoint], [0 60])
    set(gca,'FontSize',24)

     % Set x-axis labels
     xticks([0:666.25:2665]);  % Set the x-axis tick locations
     xticklabels(string(-2000:1000:2000));  % Set the x-axis tick labels as strings

    title(['Aware, Electrode ' num2str(electrode)])
    xlabel(['Time from Confirm (ms)'])
    ylabel(['Frequency (Hz)'])
    subplot(1,3,2)
    imagesc(squeeze(mean_unaware_spectrogram(electrode,:,:)));
    set(gca,'YDir','normal');
    caxis(clims);
    colormap('jet');
    xlim([0 size(allSubjectMeansAware,3)])
    ylim([0.5 60])
    line([zeroPoint zeroPoint], [0 60])
    set(gca,'FontSize',24)

    % Set x-axis labels
     xticks([0:666.25:2665]);  % Set the x-axis tick locations
     xticklabels(string(-2000:1000:2000));  % Set the x-axis tick labels as strings

    title(['Unaware, Electrode ' num2str(electrode)])
    xlabel(['Time from Confirm (ms)'])
    ylabel(['Frequency (Hz)'])
    subplot(1,3,3)
    imagesc(squeeze(mean_diff_spectrogram(electrode,:,:)));
    set(gca,'YDir','normal');
    caxis(clims);
    colormap('jet');
    colorbar
    xlim([0 size(allSubjectMeansAware,3)])
    ylim([0.5 60])
    line([zeroPoint zeroPoint], [0 60])
    set(gca,'FontSize',24)

     % Set x-axis labels
     xticks([0:666.25:2665]);  % Set the x-axis tick locations
     xticklabels(string(-2000:1000:2000));  % Set the x-axis tick labels as strings

    title(['Difference, Electrode ' num2str(electrode)])
    xlabel(['Time from Confirm (ms)'])
    ylabel(['Frequency (Hz)'])
    set(f, 'WindowState', 'maximized');
    colorbar('off')
    savefig(f,['E' num2str(electrode) '_Spectrogram.fig'])
    saveas(gcf,['E' num2str(electrode) '_Spectrogram.png'])
    close all
    
end

%% Plot low freqs only
cd('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Spectrogram_Figures_Low_Freqs')
close all
for electrode = 1:257

    f = figure;
    hold on;
    subplot(1,3,1)
    hold on
    imagesc(squeeze(mean_aware_spectrogram(electrode,:,:)));
    set(gca,'YDir','normal');
    caxis(clims);
    colormap('jet');
    xlim([0 124])
    ylim([1 40])
    line([zeroPoint zeroPoint], [0 150])
    set(gca,'FontSize',24)

    % Set x-axis labels
    xticks([3:12:124]);  % Set the x-axis tick locations
    xticklabels(string(round(timeValues(3:12:124))));  % Set the x-axis tick labels as strings

    title(['Aware, Electrode ' num2str(electrode)])
    xlabel(['Time from Confirm (ms)'])
    ylabel(['Frequency (Hz)'])
    subplot(1,3,2)
    hold on
    imagesc(squeeze(mean_unaware_spectrogram(electrode,:,:)));
    set(gca,'YDir','normal');
    caxis(clims);
    colormap('jet');
    xlim([0 124])
    ylim([1 40])
    line([zeroPoint zeroPoint], [0 150])
    set(gca,'FontSize',24)

    % Set x-axis labels
    xticks([3:12:124]);  % Set the x-axis tick locations
    xticklabels(string(round(timeValues(3:12:124))));  % Set the x-axis tick labels as strings
    
    title(['Unaware, Electrode ' num2str(electrode)])
    xlabel(['Time from Confirm (ms)'])
    ylabel(['Frequency (Hz)'])
    subplot(1,3,3)
    hold on
    imagesc(squeeze(mean_diff_spectrogram(electrode,:,:)));
    set(gca,'YDir','normal');
    caxis(clims);
    colormap('jet');
    colorbar
    xlim([0 124])
    ylim([1 40])
    line([zeroPoint zeroPoint], [0 150])
    set(gca,'FontSize',24)

    % Set x-axis labels
    xticks([3:12:124]);  % Set the x-axis tick locations
    xticklabels(string(round(timeValues(3:12:124))));  % Set the x-axis tick labels as strings

    title(['Difference, Electrode ' num2str(electrode)])
    xlabel(['Time from Confirm (ms)'])
    ylabel(['Frequency (Hz)'])
    set(f, 'WindowState', 'maximized');
    colorbar( 'off' )
    savefig(f,['E' num2str(electrode) '_Spectrogram.fig'])
    saveas(gcf,['E' num2str(electrode) '_Spectrogram.png'])
    close all
    
end


