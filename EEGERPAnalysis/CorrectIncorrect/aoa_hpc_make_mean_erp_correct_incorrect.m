%% Creates subject mean ERP for correct and incorrect epochs
function output_end = aoa_hpc_make_mean_erp_correct_incorrect(subjectDirectory,sessionDate)
        creationFunction = 'aoa_hpc_make_mean_erp_correct_incorrect.m';
        load(['/vast/palmer/pi/blumenfeld/dsj8/AoA_Study/Quiz_Run_Numbers/' sessionDate(1:3) '/' sessionDate(5:8) '/' sessionDate '_sliders_and_percentiles_timing.mat'])
        load(['/vast/palmer/pi/blumenfeld/dsj8/AoA_Study/Board_Disappearance_Split/' sessionDate(1:3) '/' sessionDate(5:8) '/' sessionDate '_bad_epochs.mat'])
        
        sliderSuccessesAllPercentilesTiming(isnan(sliderSuccessesAllPercentilesTiming(:,4)),:) = [];
        
        cd(subjectDirectory)
        load([sessionDate '_ICA_epochs_components_removed_quizzes_then_choose_long.mat']);
        load([sessionDate '_good_epoch_designations_quizzes_then_choose.mat']);
        goodConfirmDesignations = good_epoch_designations;
        all_correct_trials = [];
        all_incorrect_trials = [];
        used_quizzes = sliderSuccessesAllPercentilesTiming(bad_epochs == 0,:);
        tic
        for trial = 1:size(ICA_epochs_components_removed,3)
            if used_quizzes(trial,4) == 1 && (used_quizzes(trial,3) > 75 || used_quizzes(trial,3) < 25)
                all_correct_trials = cat(3,all_correct_trials,ICA_epochs_components_removed(:,:,trial));
            elseif used_quizzes(trial,4) == 0 && (used_quizzes(trial,3) > 75 || used_quizzes(trial,3) < 25)
                all_incorrect_trials = cat(3,all_incorrect_trials,ICA_epochs_components_removed(:,:,trial));
            end
        end
        if ~isempty(all_correct_trials)
            correctTotals = size(all_correct_trials,3);
        elseif isempty(all_correct_trials)
            correctTotals = 0;
        end
        
        if ~isempty(all_incorrect_trials)
            incorrectTotals = size(all_incorrect_trials,3);
        elseif isempty(all_incorrect_trials)
            incorrectTotals = 0;
        end
        
        
        
        if size(all_correct_trials,3) > 1
            mean_correct_erp = mean(all_correct_trials,3);
        elseif size(all_correct_trials,3) == 1
            mean_correct_erp = all_correct_trials;
        end
        
        if size(all_incorrect_trials,3) > 1
            mean_incorrect_erp = mean(all_incorrect_trials,3);
        elseif size(all_incorrect_trials,3) == 1
            mean_incorrect_erp = all_incorrect_trials;
        end
        
      

        
        for channel = 1:257;
            if ~isempty(mean_correct_erp) > 0
                mean_correct_erp(channel,:) = mean_correct_erp(channel,:)-mean(mean_correct_erp(channel,:));
            end
            if ~isempty(mean_incorrect_erp) > 0
                mean_incorrect_erp(channel,:) = mean_incorrect_erp(channel,:)-mean(mean_incorrect_erp(channel,:));
            end
            
        end
        output_end = 1;
        save([sessionDate '_mean_erps_correct_incorrect.mat'],'mean_correct_erp','mean_incorrect_erp','correctTotals','incorrectTotals','mean_correct_erp','mean_incorrect_erp','correctTotals','incorrectTotals','creationFunction','-v7.3')
        toc
end
