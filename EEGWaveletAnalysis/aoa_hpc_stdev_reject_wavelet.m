% This script takes the previously performed spectral analysis and uses
% excessively high beta (movement noise) and gamma (electrical noise) to
% exclude individual trials.

function output_end = aoa_hpc_stdev_reject_wavelet(subjectDirectory,sessionDate)
    
        creationFunction = 'aoa_hpc_stdev_reject_wavelet.m';
        cd(subjectDirectory)
        load([subjectDirectory '/' sessionDate '_power_vectors_quizzes_then_choose_125_window_31_sliding.mat'], 'electrode_all_freq_zscore_power_vector');
        load([sessionDate '_good_epoch_designations_quizzes_then_choose.mat']);
        test_beta_range = electrode_all_freq_zscore_power_vector(:,12:30,:,:);
        test_beta_range = electrode_all_freq_zscore_power_vector(:,12:30,:,:);
        test_beta_range_mean = squeeze(mean(test_beta_range,2));

        test_gamma_range = electrode_all_freq_zscore_power_vector(:,40:140,:,:);
        test_gamma_range = electrode_all_freq_zscore_power_vector(:,40:140,:,:);
        test_gamma_range_mean = squeeze(mean(test_gamma_range,2));

        beta_range_pz = squeeze(test_beta_range_mean(101,:,:));
        gamma_range_pz = squeeze(test_gamma_range_mean(101,:,:));
        all_aware_trials = [];
        all_unaware_trials = [];
        kept_aware_trials = [];
        kept_unaware_trials = [];
        for trial = 1:size(beta_range_pz,2)
            % Given the association of beta with motion artifact and gamma
            % with electrical noise, excessive quantities of both were used
            % to exclude individual trials. Any participants whose trial
            % count fell below the 12-trial minimum for both aware and
            % unaware was subsequently excluded.
            if max(beta_range_pz(:,trial)) < 100 && max(gamma_range_pz(:,trial)) < 100
                
                if strcmp(good_epoch_designations{trial},'CH') || strcmp(good_epoch_designations{trial},'Aware')
                    all_aware_trials = cat(4,all_aware_trials,electrode_all_freq_zscore_power_vector(:,:,:,trial));
                    kept_aware_trials = [kept_aware_trials trial];
                elseif strcmp(good_epoch_designations{trial},'IL') || strcmp(good_epoch_designations{trial},'Unaware')
                    all_unaware_trials = cat(4,all_unaware_trials,electrode_all_freq_zscore_power_vector(:,:,:,trial));
                    kept_unaware_trials = [kept_unaware_trials trial];
                end
            end
        end
        awareTotals = size(all_aware_trials,4);
        unawareTotals = size(all_unaware_trials,4);
        mean_electrode_all_freq_zscore_aware = mean(all_aware_trials,4);
        mean_electrode_all_freq_zscore_unaware = mean(all_unaware_trials,4);
        save([sessionDate '_mean_zscore_powers_stdev_reject.mat'],'mean_electrode_all_freq_zscore_aware','mean_electrode_all_freq_zscore_unaware','awareTotals','unawareTotals','kept_aware_trials','kept_unaware_trials','-v7.3')
        toc
end
