%% Scalp EEG Time-frequency analysis for all epoch types

% This code is an adaptation from the icEEG time frequency analysis code. The main
% goal of this code is to make spectrogram for button press epochs by subject
% (plots of mean baselined power across time averaged over all trials and electrodes)

%***Inputs***
%Epochs with ICA components removed
%Define epoch type
%Sampling rate
%EEGLab structure
%Save figure directory

%***Outputs***
%Frequency content of the signal log power
%Frequency content of the signal z score power
%These outputs will be used to exclude participants with exceedingly high z-score power

%***Within Function Saving***
%Can generate plots of frequency content

%Adapted/Written by: Mark Aksen and Sharif I. Kronemer
%Date: 01/30/2019
%Modified: 1/23/2020
%Modified: 10/20/2023 by David S. Jin


function output_end = aoa_make_spectrogram_on_trials(fileLocation,sessionDate,window_size_factor,sliding_window_factor,ID,Day,sampling_rate)

    sampling_rate = 1000;
    epoch_duration = 6000;
    save_fig = 1; disp(['Starting subject ' ID ', ' Day])
    
    
    load([fileLocation sessionDate '_ICA_epochs_components_removed_quizzes_then_choose_long.mat'])
    load([fileLocation sessionDate '_good_epoch_designations_quizzes_then_choose.mat'])
    
    
    cd(fileLocation)
    system(['rm ' fileLocation sessionDate '_power_vectors_quizzes_then_choose_*'])
    
    epochs = ICA_epochs_components_removed;
    %Cut epochs duration (cut extra samples)
    %epochs = epochs(:,abs((epoch_duration/2)-2001):(epoch_duration/2)+2001,:);
    %sampling_rate = 1000;
    
    %Define the size of the window for each bin of power analysis
    window_size = floor(sampling_rate/window_size_factor); %250ms would be 1000/4
    
    %Define the number of samples you want to slide the window by
    sliding_window = floor(window_size/sliding_window_factor);  %31.25ms would be 250/8
    
    %Calculate the total number of bins that will result from your window
    epoch_size = size(epochs,2); %Find the number of samples in the epoch (e.g., 1000ms or 5000ms at 1000Hz)
    nonoverlap_bins_num = floor(epoch_size/sliding_window); %Divide epoch samples by sliding window
    bins_per_window = floor(window_size/sliding_window); %Total number of bins with a single window
    total_bins_num = nonoverlap_bins_num - bins_per_window + 1; %Calculate the total number of bins in the epoch
    
    %Find the number of electrodes (e.g., 256)
    nElectrode = size(epochs,1);
    
    %Find the number of trial
    num_trials = size(epochs,3);
    
    %% Time-frequency Analysis
    disp('Performing time-frequency analysis...')
    %Initialize Variable Trials(electrodes x frequency x num bin, trials)
    electrode_all_freq_log_power_vector = [];
    electrode_all_freq_zscore_power_vector = [];
    
    tic
    
    %Loop over electrodes
    tic
    figure;
    hold on
    xlabel('Electrode analyzed')
    ylabel('Cumulative time (seconds)')
    durations = [0];
    channelCompleteTimes = [datetime('now')];
    for electrode = 1:nElectrode
    
        disp(['Performing time-frequency analysis on electrode ' num2str(electrode)])
    
    
        %Loop over trials
        for trial_num = 1:num_trials
    
            %Select voltage data from a single trial and electrode
            trial = squeeze(epochs(electrode, :, trial_num));
    
            %Run Spectrogram on single trial and electrode
            [trial_power, ~, ~] = spectrogram(trial, window_size, window_size-sliding_window, 1:150, sampling_rate);
    
            %Calculate power - squared, absolute value
            trial_power = abs(trial_power).^2;
    
            %Take logarithm of power (channel x time)
            log_trial_power = log(trial_power);
    
            %Store all frequencies (electrode x frequency x time x trials)
            electrode_all_freq_log_power_vector(electrode,:,:,trial_num) = log_trial_power; %Log power
            electrode_all_freq_zscore_power_vector(electrode,:,:,trial_num) = trial_power; %Non-log power
    
        end
    
        cumulative_time = toc;
        durations = [durations cumulative_time];
        channelCompleteTimes = [channelCompleteTimes datetime('now')];
        scatter(electrode,cumulative_time,'filled')
        scatter(electrode,durations(end)-durations(end-1),'filled')
        drawnow
    end
    electrode_all_freq_power_vector_unbaselined = log_trial_power;
    electrode_all_freq_power_vector = electrode_all_freq_zscore_power_vector;
    disp('Done.')
    
    %% Baseline correction (subtract mean power across each electrode individually)
    disp('Performing baseline correction...')
    %For All Frequencies Extracted
    
    %Loop over frequencies
    for freq = 1:size(electrode_all_freq_log_power_vector,2)
    
        %Loop over electrodes
        for electrode = 1:nElectrode
    
            %Loop over trials
            for trial_num = 1:num_trials
    
    
                electrode_all_freq_log_power_vector(electrode,freq,:,trial_num) = electrode_all_freq_log_power_vector(electrode,freq,:,trial_num)...
                    -nanmean(electrode_all_freq_log_power_vector(electrode,freq,32:62,trial_num));
    
            end
    
        end
    
    end
    disp('Done.')
    %% Zscore Non-log Power
    
    %Display in command line
    disp('Running z-score power')
    
    %Loop over frequencies
    for freq = 1:size(electrode_all_freq_zscore_power_vector,2)
    
        %Loop over electrodes
        for electrode = 1:nElectrode
    
            %Find the mean baseline and standard deviation for all
            %trials of that reference range for that electrode -
            %dimensions channel x frequency x time x trials
            all_trial_mean = nanmean(nanmean(squeeze(electrode_all_freq_zscore_power_vector(electrode,freq,32:62,:)),2),1);
            all_trial_SD = std(nanmean(squeeze(electrode_all_freq_zscore_power_vector(electrode,freq,32:62,:)),2),[],1);
    
            %Loop over trials
            for trial_num = 1:num_trials
    
                %Define freq, trial, and electrode to z-score
                data = squeeze(electrode_all_freq_zscore_power_vector(electrode,freq,:,trial_num));
    
                %Baseline power - baseline equals mean power in prestimulus period
                electrode_all_freq_zscore_power_vector(electrode,freq,:,trial_num) = (data-all_trial_mean)/all_trial_SD;
    
            end
    
        end
    
    end
    
    toc
    
    
    %%
    
    %Average frequency over trial and electrode
    
    mean_electrode_all_freq_power = mean(electrode_all_freq_log_power_vector,4);
    mean_electrode_all_freq_zscore = mean(electrode_all_freq_zscore_power_vector,4);
    mean_electrode_all_freq_power_aware = [];
    mean_electrode_all_freq_power_unaware = [];
    all_electrode_all_freq_power_aware = [];
    all_electrode_all_freq_power_unaware = [];
    all_electrode_all_freq_zscore_aware = [];
    all_electrode_all_freq_zscore_unaware = [];
    awareTotals = 0;
    unawareTotals = 0;
    for epoch = 1:length(good_epoch_designations)
        if strcmp(good_epoch_designations{epoch},'CH') || strcmp(good_epoch_designations{epoch},'Aware')
            all_electrode_all_freq_power_aware = cat(4,all_electrode_all_freq_power_aware,electrode_all_freq_log_power_vector(:,:,:,epoch));
            awareTotals = awareTotals + 1;
        elseif strcmp(good_epoch_designations{epoch},'IL') || strcmp(good_epoch_designations{epoch},'Unaware')
            all_electrode_all_freq_power_unaware = cat(4,all_electrode_all_freq_power_unaware,electrode_all_freq_log_power_vector(:,:,:,epoch));
            unawareTotals = unawareTotals + 1;
        end
    end
    for epoch = 1:length(good_epoch_designations)
        if strcmp(good_epoch_designations{epoch},'CH') || strcmp(good_epoch_designations{epoch},'Aware')
            all_electrode_all_freq_zscore_aware = cat(4,all_electrode_all_freq_zscore_aware,electrode_all_freq_zscore_power_vector(:,:,:,epoch));
        elseif strcmp(good_epoch_designations{epoch},'IL') || strcmp(good_epoch_designations{epoch},'Unaware')
            all_electrode_all_freq_zscore_unaware = cat(4,all_electrode_all_freq_zscore_unaware,electrode_all_freq_zscore_power_vector(:,:,:,epoch));
        end
    end
    mean_electrode_all_freq_power_aware = mean(all_electrode_all_freq_power_aware,4);
    mean_electrode_all_freq_power_unaware = mean(all_electrode_all_freq_zscore_unaware,4);
    mean_electrode_all_freq_zscore_aware = mean(all_electrode_all_freq_power_aware,4);
    mean_electrode_all_freq_zscore_unaware = mean(all_electrode_all_freq_zscore_unaware,4);
    
    %%
    electrode = 21;
    ID_string = ID;
    if ~ischar(ID)
        ID_string = num2str(ID);
    end
    epoch_type = 'Aware Confirms';
    figPower = figure('units','normalized','outerposition',[0 0 1 1]);
    set(gcf, 'color', [1 1 1]);
    title(['Power 1-120Hz ', epoch_type, ' - ', ID_string, ' Electrode ' num2str(electrode) ' n = ' num2str(awareTotals)]); hold on;
    xlabel('Time (ms)')
    ylabel('Frequency (Hz)')
    
    %Plot image
    imagesc(squeeze(mean_electrode_all_freq_power_aware(electrode,1:120,:)));
    
    %Define y-ticks
    set(gca,'ytick',[0 10 20 30 40 50 60 70 80 90 100 110 120]);
    set(gca,'ydir','normal')
    
    %Define x-tickes
    %xtick_spacing = [5,13,21,29,37,45,53];
    set(gca,'xticklabel',[-2000 -1333 -667 0 667 1333 2000]);
    xlim([0 120])
    ylim([0 120])
    %Draw stimuls onset line
    line([60 60], ylim,'color','k')
    
    caxis([-1 1]);
    colormap jet
    colorbar
    savefig(figPower,['Aware_' ID_string, '_Electrode_' num2str(electrode) '_power.fig'])
    drawnow
    epoch_type = 'Unaware Confirms';
    figPower = figure('units','normalized','outerposition',[0 0 1 1]);
    set(gcf, 'color', [1 1 1]);
    title(['Power 1-120Hz ', epoch_type, ' - ', ID_string, ' Electrode ' num2str(electrode) ' n = ' num2str(unawareTotals)]); hold on;
    xlabel('Time (ms)')
    ylabel('Frequency (Hz)')
    
    %Plot image
    imagesc(squeeze(mean_electrode_all_freq_power_unaware(electrode,1:120,:)));
    
    %Define y-ticks
    set(gca,'ytick',[0 10 20 30 40 50 60 70 80 90 100 110 120]);
    set(gca,'ydir','normal')
    
    %Define x-tickes
    %xtick_spacing = [5,13,21,29,37,45,53];
    set(gca,'xticklabel',[-2000 -1333 -667 0 667 1333 2000]);
    xlim([0 120])
    ylim([0 120])
    %Draw stimuls onset line
    line([60 60], ylim,'color','k')
    
    caxis([-1 1]);
    colormap jet
    colorbar
    savefig(figPower,['Unaware_' ID_string, '_Electrode_' num2str(electrode) '_power.fig'])
    
    drawnow
    epoch_type = 'Aware-Unaware Confirms';
    figPower = figure('units','normalized','outerposition',[0 0 1 1]);
    set(gcf, 'color', [1 1 1]);
    title(['Power 1-120Hz ', epoch_type, ' - ', ID_string, ' Electrode ' num2str(electrode)]); hold on;
    xlabel('Time (ms)')
    ylabel('Frequency (Hz)')
    
    %Plot image
    imagesc(squeeze(mean_electrode_all_freq_power_aware(electrode,1:120,:))-squeeze(mean_electrode_all_freq_power_unaware(electrode,1:120,:)));
    
    %Define y-ticks
    set(gca,'ytick',[0 10 20 30 40 50 60 70 80 90 100 110 120]);
    set(gca,'ydir','normal')
    
    %Define x-tickes
    %xtick_spacing = [5,13,21,29,37,45,53];
    set(gca,'xticklabel',[-2000 -1333 -667 0 667 1333 2000]);
    xlim([60 180])
    ylim([60 180])
    %Draw stimuls onset line
    line([60 60], ylim,'color','k')
    
    caxis([-1 1]);
    colormap jet
    colorbar
    
    savefig(figPower,['Aware-Unaware_' ID_string, '_Electrode_' num2str(electrode) '_power.fig'])
    drawnow
    %%
    currentDate = string(datetime('now'));
    currentDate = currentDate{1}(1:11);
    eval(['save ' fileLocation sessionDate '_power_vectors_quizzes_then_choose_' num2str(round(window_size)) '_window_' num2str(round(sliding_window)) '_sliding.mat electrode_all_freq_log_power_vector electrode_all_freq_power_vector electrode_all_freq_zscore_power_vector mean_electrode_all_freq_zscore mean_electrode_all_freq_power_aware mean_electrode_all_freq_power_unaware awareTotals unawareTotals mean_electrode_all_freq_zscore_aware mean_electrode_all_freq_zscore_unaware -v7.3'])
    eval(['save ' fileLocation sessionDate '_power_vectors_timings_' currentDate '.mat durations channelCompleteTimes -v7.3'])
    eval(['save ' fileLocation sessionDate '_mean_vectors_quizzes_then_choose_' num2str(round(window_size)) '_window_' num2str(round(sliding_window)) '_sliding.mat mean_electrode_all_freq_power_aware mean_electrode_all_freq_power_unaware awareTotals unawareTotals mean_electrode_all_freq_zscore_aware mean_electrode_all_freq_zscore_unaware -v7.3'])
    
    close all
    output_end = toc

end
