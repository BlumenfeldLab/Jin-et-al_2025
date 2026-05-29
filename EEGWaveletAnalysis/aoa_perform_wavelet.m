

function output_end = aoa_perform_wavelet(subjectDirectory,sessionDate)
    creationFunction = 'aoa_perform_wavelet.m';

    
    min_freq = 1;% min frequency for TF plot
    max_freq =125;% max frequency for TF plot
    num_frex = 125; % number of frequency points you want between min and max freq
    cycles_min=5; % minimum number of wavlet cycles (basically defining frequency resolution
    cycles_max=8; % max number of wavelet cycles
    Fs = 1000;
    Fs_down = 1000;

    % signal for analysis : "mainLFP": rows and columns represent trials and samples respectively
    % Fs_down : sampling rate of mainLFP
    pre_cue = 0;
    post_cue = 3*Fs_down;
    mean_aware_wavelet_zscore_aware = zeros(150,6*Fs_down,257);
    mean_aware_wavelet_zscore_unaware = zeros(150,6*Fs_down,257);
    durations_realtime = [datetime('now')];
    durations_clocktime = [tic];
    
    cd(subjectDirectory)
    load([subjectDirectory '/' sessionDate '_mean_zscore_powers_stdev_reject.mat'], 'kept_aware_trials','kept_unaware_trials');
    load([subjectDirectory '/' sessionDate '_ICA_epochs_components_removed_quizzes_then_choose_long.mat']);
    mainLFP = ICA_epochs_components_removed;
    allAwareZscorePower = zeros(257,6*Fs_down,length(kept_aware_trials),max_freq);
    allUnawareZscorePower = zeros(257,6*Fs_down,length(kept_unaware_trials),max_freq);
    tic
    tf_power_aware_all_trials_raw = zeros(257,6*Fs_down,length(kept_aware_trials),max_freq);
    tf_power_unaware_all_trials_raw = zeros(257,6*Fs_down,length(kept_unaware_trials),max_freq);
    all_powers_and_trials_raw = zeros(257,6*Fs_down,size(ICA_epochs_components_removed,3),max_freq);
    all_beta_delta_ratio_aware = [];
    all_beta_delta_ratio_unaware = [];
   

    for channel = 1:257
        disp(['Performing wavelet analysis on channel ' num2str(channel)])
        mainLFPtemp = squeeze(mainLFP(channel,:,:));
        mainLFPtemp = downsample(mainLFPtemp,Fs/Fs_down)';
        frex = linspace(min_freq,max_freq,num_frex); % define frequency vector
                s    = linspace(cycles_min,cycles_max,num_frex)./(2*pi*frex); % define scaling parameter
                t_LFP = -pre_cue/Fs_down:1/Fs_down:(post_cue-1)/Fs_down; % in sec % define time axis aligned to event of interest
                baseidx = dsearchn(t_LFP',[-0.7 0]'); % define baseline period in the time axis of the signal
                
                % zeropad your signal 
                numTrials=size(mainLFP,3);
                pad_len=2*Fs_down;
                
                mainLFP_pad=[zeros(numTrials,pad_len),mainLFPtemp,zeros(numTrials,pad_len)];
                t_wave=-size(mainLFP_pad,2)/(2*Fs_down):1/Fs_down:(size(mainLFP_pad,2)-1)/(2*Fs_down);% time axis for wavelet
                % definte convolution parameters
                n_wavelet           = length(t_wave);
                n_data               = size(mainLFP_pad,1)*size(mainLFP_pad,2); % rows and columns represent trials and samples respectively
                n_convolution        = n_wavelet+n_data-1;
                n_conv_pow2         = pow2(nextpow2(n_convolution));
                half_of_wavelet_size = (n_wavelet-1)/2;
                %%
                % get FFT of data
                eegfft = fft(reshape(mainLFP_pad',1,[]),n_conv_pow2);
                % initialize
                tf_power = zeros(num_frex,size(mainLFP,2)/(Fs/Fs_down)); % frequencies X time X trials
                tf_power_zscore = tf_power;
                tf_power_aware = zeros(num_frex,size(mainLFP,2)/(Fs/Fs_down));
                tf_power_unaware = zeros(num_frex,size(mainLFP,2)/(Fs/Fs_down));
                tf_power_aware_raw = zeros(num_frex,size(mainLFP,2)/(Fs/Fs_down));
                tf_power_unaware_raw = zeros(num_frex,size(mainLFP,2)/(Fs/Fs_down));
                tf_zscore_aware = tf_power_aware;
                tf_zscore_unaware = tf_power_unaware;
                
                % compute power
                all_powers_and_trials_current_channel = [];
                all_powers_and_trials_current_channel_raw = [];
                all_zscores_and_trials_current_channel = [];
                for fi=1:num_frex   
                    wavelet = fft((1/(s(fi)*sqrt(pi)) )* exp(2*1i*pi*frex(fi).*t_wave) .* exp(-t_wave.^2./(2*(s(fi)^2))) , n_conv_pow2 );
                    % convolution
                    eegconv = ifft(wavelet.*eegfft);
                    eegconv = eegconv(1:n_convolution);
                    eegconv = eegconv(half_of_wavelet_size+1:end-half_of_wavelet_size);
                    % reshape into trials, remove zero padding
                    eegconv = reshape(eegconv,size(mainLFP_pad,2),numTrials)';
                    eegconv = eegconv(:,pad_len+1:end-pad_len);
                    eegconv_aware = eegconv(kept_aware_trials,:);
                    eegconv_unaware = eegconv(kept_unaware_trials,:);
                    
                    % Average power over trials 
                    temppower = mean(abs(eegconv).^2,1);
                        tf_power(fi,:) = 10*log10(temppower);
                    temppower_aware = mean(abs(eegconv_aware).^2,1);
                    temppower_aware_all_trials_raw = abs(eegconv_aware).^2;
                    tf_power_aware(fi,:) = 10*log10(temppower_aware);
                    tf_power_aware_raw(fi,:) = temppower_aware;
                    tf_power_aware_all_trials_raw(channel,:,:,fi) = temppower_aware_all_trials_raw';
                    temppower_unaware = mean(abs(eegconv_unaware).^2,1);
                    tf_power_unaware(fi,:) = 10*log10(temppower_unaware);
                    temppower_unaware_all_trials_raw = abs(eegconv_unaware).^2;
                    tf_power_unaware_raw(fi,:) = temppower_unaware;
                    tf_power_unaware_all_trials_raw(channel,:,:,fi) = temppower_unaware_all_trials_raw';
                    start_id = Fs_down+1;
                    end_id = 2*Fs_down;
                    allPower = abs(eegconv).^2;

                    allPowerMean = mean(allPower(:,Fs_down+1:2*Fs_down),2);
                    allPowerStd = std(allPower(:,Fs_down+1:2*Fs_down)');
                    allZscore = (allPower-allPowerMean)./allPowerStd';
                    allZscore = permute(allZscore,[2 1]);
                    allAwareLogPower = allPower(:,kept_aware_trials);
                    allUnawareLogPower = allPower(:,kept_unaware_trials);
                    
                    allAwareZscorePower(channel,:,:,fi) = allZscore(:,kept_aware_trials);
                    allUnawareZscorePower(channel,:,:,fi) = allZscore(:,kept_unaware_trials);
                    
                    % tf_power(fi,:) = 10*log10(temppower./mean(temppower(baseidx(1):baseidx(2)))); % normalize power with respect to baseline
                    all_powers_and_trials_current_channel = cat(3,all_powers_and_trials_current_channel, 10*log10(abs(eegconv).^2));
                    all_powers_and_trials_current_channel_raw = cat(3,all_powers_and_trials_current_channel_raw, abs(eegconv).^2);
                    all_powers_and_trials_raw(channel,:,:,fi) = abs(eegconv).^2';
                    baseline_mean = mean(temppower(start_id:end_id));
                    baseline_std = std(temppower(start_id:end_id));
                    tf_power_zscore(fi,:) = (temppower - baseline_mean)/baseline_std;
                    baseline_mean_aware = mean(temppower_aware(start_id:end_id));
                    baseline_std_aware = std(temppower_aware(start_id:end_id));
                    tf_zscore_aware(fi,:) = (temppower_aware - baseline_mean_aware)/baseline_std_aware;
                    baseline_mean_unaware = mean(temppower_unaware(start_id:end_id));
                    baseline_std_unaware = std(temppower_unaware(start_id:end_id));
                    tf_zscore_unaware(fi,:) = (temppower_unaware - baseline_mean_unaware)/baseline_std_unaware;
    
                    
                end
                

                close all

                mean_wavelet_zscore_aware(:,:,channel) = tf_zscore_aware;
                mean_wavelet_zscore_unaware(:,:,channel) = tf_zscore_unaware;
                durations_realtime = [durations_realtime datetime('now')];
                durations_clocktime = [durations_clocktime double(toc)];
                

                
    end
            save([sessionDate '_mean_zscore_wavelet' num2str(Fs_down) 'Hz.mat'],'mean_wavelet_zscore_aware','mean_wavelet_zscore_unaware','kept_aware_trials','kept_unaware_trials','durations_clocktime','durations_realtime','creationFunction','-v7.3')
            save([sessionDate '_all_zscore_wavelet' num2str(Fs_down) 'Hz.mat'],'allAwareZscorePower','allUnawareZscorePower','creationFunction','-v7.3');
            save([sessionDate '_all_wavelet_power_trials' num2str(Fs_down) 'Hz.mat'],'all_powers_and_trials_raw','creationFunction','-v7.3');
            toc

end
