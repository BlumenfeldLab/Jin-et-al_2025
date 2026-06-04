%% Creates mean ERPs for early runs (1-3) and late runs (4-6)
function output_end = aoa_hpc_make_mean_erp_split_designations_runs(subjectDirectory,sessionDate)
        creationFunction = 'aoa_hpc_make_mean_erp_split_designations_runs.m';
        load(['/vast/palmer/pi/blumenfeld/dsj8/AoA_Study/Quiz_Run_Numbers/' sessionDate(1:3) '/' sessionDate(5:8) '/' sessionDate '_sliders_and_percentiles_timing.mat'])
        load(['/vast/palmer/pi/blumenfeld/dsj8/AoA_Study/Board_Disappearance_Split/' sessionDate(1:3) '/' sessionDate(5:8) '/' sessionDate '_bad_epochs.mat'])
        
        sliderSuccessesAllPercentilesTiming(isnan(sliderSuccessesAllPercentilesTiming(:,4)),:) = [];
        
        cd(subjectDirectory)
        load([sessionDate '_ICA_epochs_components_removed_quizzes_then_choose_long.mat']);
        load([sessionDate '_good_epoch_designations_quizzes_then_choose.mat']);
        goodConfirmDesignations = good_epoch_designations;
        all_aware_trials_early_runs = [];
        all_unaware_trials_early_runs = [];
        all_aware_trials_late_runs = [];
        all_unaware_trials_late_runs = [];
        used_quizzes = sliderSuccessesAllPercentilesTiming(bad_epochs == 0,:);
        tic
        for trial = 1:size(ICA_epochs_components_removed,3)
            
                if strcmp(goodConfirmDesignations{trial},'CH') || strcmp(goodConfirmDesignations{trial},'Aware')
                    if used_quizzes(trial,5) <= 3
                        all_aware_trials_early_runs = cat(3,all_aware_trials_early_runs,ICA_epochs_components_removed(:,:,trial));
                    end
                    if used_quizzes(trial,5) > 3
                        all_aware_trials_late_runs = cat(3,all_aware_trials_late_runs,ICA_epochs_components_removed(:,:,trial));
                    end
                elseif strcmp(goodConfirmDesignations{trial},'IL') || strcmp(goodConfirmDesignations{trial},'Unaware')
                    if used_quizzes(trial,5) <= 3
                       
                        all_unaware_trials_early_runs = cat(3,all_unaware_trials_early_runs,ICA_epochs_components_removed(:,:,trial));
                    end
                    if used_quizzes(trial,5) > 3
                        all_unaware_trials_late_runs = cat(3,all_unaware_trials_late_runs,ICA_epochs_components_removed(:,:,trial));
                    end
                end
        end
        if ~isempty(all_aware_trials_early_runs)
            awareTotals_early_runs = size(all_aware_trials_early_runs,3);
        elseif isempty(all_aware_trials_early_runs)
            awareTotals_early_runs = 0;
        end
        
        if ~isempty(all_unaware_trials_early_runs)
            unawareTotals_early_runs = size(all_unaware_trials_early_runs,3);
        elseif isempty(all_unaware_trials_early_runs)
            unawareTotals_early_runs = 0;
        end
        
       if ~isempty(all_aware_trials_late_runs)
            awareTotals_late_runs = size(all_aware_trials_late_runs,3);
        elseif isempty(all_aware_trials_late_runs)
            awareTotals_late_runs = 0;
        end
        
        if ~isempty(all_unaware_trials_late_runs)
            unawareTotals_late_runs = size(all_unaware_trials_late_runs,3);
        elseif isempty(all_unaware_trials_late_runs)
            unawareTotals_late_runs = 0;
        end
        
        
        
        if size(all_aware_trials_early_runs,3) > 1
            mean_aware_erp_early_runs = mean(all_aware_trials_early_runs,3);
        elseif size(all_aware_trials_early_runs,3) == 1
            mean_aware_erp_early_runs = all_aware_trials_early_runs;
        end
        
        if size(all_unaware_trials_early_runs,3) > 1
            mean_unaware_erp_early_runs = mean(all_unaware_trials_early_runs,3);
        elseif size(all_unaware_trials_early_runs,3) == 1
            mean_unaware_erp_early_runs = all_unaware_trials_early_runs;
        end
        
        if size(all_aware_trials_late_runs,3) > 1
            mean_aware_erp_late_runs = mean(all_aware_trials_late_runs,3);
        elseif size(all_aware_trials_late_runs,3) == 1
            mean_aware_erp_late_runs = all_aware_trials_late_runs;
        end
        
        if size(all_unaware_trials_late_runs,3) > 1
            mean_unaware_erp_late_runs = mean(all_unaware_trials_late_runs,3);
        elseif size(all_unaware_trials_late_runs,3) == 1
            mean_unaware_erp_late_runs = all_unaware_trials_late_runs;
        end
        


        
        for channel = 1:257;
            if ~isempty(mean_aware_erp_early_runs) > 0
                mean_aware_erp_early_runs(channel,:) = mean_aware_erp_early_runs(channel,:)-mean(mean_aware_erp_early_runs(channel,:));
            end
            if ~isempty(mean_unaware_erp_early_runs) > 0
                mean_unaware_erp_early_runs(channel,:) = mean_unaware_erp_early_runs(channel,:)-mean(mean_unaware_erp_early_runs(channel,:));
            end
            
            if ~isempty(mean_aware_erp_late_runs)
                mean_aware_erp_late_runs(channel,:) = mean_aware_erp_late_runs(channel,:)-mean(mean_aware_erp_late_runs(channel,:));
            end
            if ~isempty(mean_unaware_erp_late_runs) > 0
                mean_unaware_erp_late_runs(channel,:) = mean_unaware_erp_late_runs(channel,:)-mean(mean_unaware_erp_late_runs(channel,:));
            end    
        end
        output_end = 1;
        save([sessionDate '_mean_erps_split_designations_runs.mat'],'mean_aware_erp_early_runs','mean_unaware_erp_early_runs','awareTotals_early_runs','unawareTotals_early_runs','mean_aware_erp_late_runs','mean_unaware_erp_late_runs','awareTotals_late_runs','unawareTotals_late_runs','creationFunction','-v7.3')
        toc
end
