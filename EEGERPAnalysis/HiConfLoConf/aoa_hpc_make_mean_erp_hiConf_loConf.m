%% Makes subject mean ERP for low-confidence vs high-confidence actions.
function output_end = aoa_hpc_make_mean_erp_hiConf_loConf(subjectDirectory,sessionDate)
        creationFunction = 'aoa_hpc_make_mean_erp_hiConf_loConf.m';
        load(['/vast/palmer/pi/blumenfeld/dsj8/AoA_Study/Quiz_Run_Numbers/' sessionDate(1:3) '/' sessionDate(5:8) '/' sessionDate '_sliders_and_percentiles_timing.mat'])
        load(['/vast/palmer/pi/blumenfeld/dsj8/AoA_Study/Board_Disappearance_Split/' sessionDate(1:3) '/' sessionDate(5:8) '/' sessionDate '_bad_epochs.mat'])
        
        sliderSuccessesAllPercentilesTiming(isnan(sliderSuccessesAllPercentilesTiming(:,4)),:) = [];
        
        cd(subjectDirectory)
        load([sessionDate '_ICA_epochs_components_removed_quizzes_then_choose_long.mat']);
        load([sessionDate '_good_epoch_designations_quizzes_then_choose.mat']);
        goodConfirmDesignations = good_epoch_designations;
        all_hiConf_trials = [];
        all_loConf_trials = [];
        used_quizzes = sliderSuccessesAllPercentilesTiming(bad_epochs == 0,:);
        tic
        for trial = 1:size(ICA_epochs_components_removed,3)
            if used_quizzes(trial,3) > 75
                all_hiConf_trials = cat(3,all_hiConf_trials,ICA_epochs_components_removed(:,:,trial));
            elseif used_quizzes(trial,3) < 25
                all_loConf_trials = cat(3,all_loConf_trials,ICA_epochs_components_removed(:,:,trial));
            end
        end
        if ~isempty(all_hiConf_trials)
            hiConfTotals = size(all_hiConf_trials,3);
        elseif isempty(all_hiConf_trials)
            hiConfTotals = 0;
        end
        
        if ~isempty(all_loConf_trials)
            loConfTotals = size(all_loConf_trials,3);
        elseif isempty(all_loConf_trials)
            loConfTotals = 0;
        end
        
        
        
        if size(all_hiConf_trials,3) > 1
            mean_hiConf_erp = mean(all_hiConf_trials,3);
        elseif size(all_hiConf_trials,3) == 1
            mean_hiConf_erp = all_hiConf_trials;
        end
        
        if size(all_loConf_trials,3) > 1
            mean_loConf_erp = mean(all_loConf_trials,3);
        elseif size(all_loConf_trials,3) == 1
            mean_loConf_erp = all_loConf_trials;
        end
        
      

        
        for channel = 1:257;
            if ~isempty(mean_hiConf_erp) > 0
                mean_hiConf_erp(channel,:) = mean_hiConf_erp(channel,:)-mean(mean_hiConf_erp(channel,:));
            end
            if ~isempty(mean_loConf_erp) > 0
                mean_loConf_erp(channel,:) = mean_loConf_erp(channel,:)-mean(mean_loConf_erp(channel,:));
            end
            
        end
        output_end = 1;
        save([sessionDate '_mean_erps_hiConf_loConf.mat'],'mean_hiConf_erp','mean_loConf_erp','hiConfTotals','loConfTotals','mean_hiConf_erp','mean_loConf_erp','hiConfTotals','loConfTotals','creationFunction','-v7.3')
        toc
end