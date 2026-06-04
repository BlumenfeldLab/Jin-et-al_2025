% Sorts trials into either those following early (1-5s) or late delays (6-8s) between confirm and quiz presentation.
function output_end = aoa_hpc_make_mean_erp_split_designations_raw(subjectDirectory,sessionDate)
        creationFunction = 'aoa_hpc_make_mean_erp_split_designations_raw.m';
        load(['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Board_Disappearance_Split/' sessionDate(1:3) '/' sessionDate(5:8) '/' sessionDate '_disappearance_confidence.mat'])
        load(['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Board_Disappearance_Split/' sessionDate(1:3) '/' sessionDate(5:8) '/' sessionDate '_bad_epochs.mat'])
        

        cd(subjectDirectory)
        load([sessionDate '_ICA_epochs_components_removed_quizzes_then_choose_long.mat']);
        load([sessionDate '_good_epoch_designations_quizzes_then_choose.mat']);
        goodConfirmDesignations = good_epoch_designations;
        all_aware_trials_early = [];
        all_unaware_trials_early = [];
        all_aware_trials_late = [];
        all_unaware_trials_late = [];
        used_gaps = quiz_gaps(bad_epochs == 0);
        tic
        for trial = 1:size(ICA_epochs_components_removed,3)
            
                if strcmp(goodConfirmDesignations{trial},'CH') || strcmp(goodConfirmDesignations{trial},'Aware')
                    if used_gaps(trial) <= 5
                        all_aware_trials_early = cat(3,all_aware_trials_early,ICA_epochs_components_removed(:,:,trial));
                    end
                    if used_gaps(trial) > 5
                        all_aware_trials_late = cat(3,all_aware_trials_late,ICA_epochs_components_removed(:,:,trial));
                    end
                elseif strcmp(goodConfirmDesignations{trial},'IL') || strcmp(goodConfirmDesignations{trial},'Unaware')
                    if used_gaps(trial) <= 5
                       
                        all_unaware_trials_early = cat(3,all_unaware_trials_early,ICA_epochs_components_removed(:,:,trial));
                    end
                    if used_gaps(trial) > 5
                        all_unaware_trials_late = cat(3,all_unaware_trials_late,ICA_epochs_components_removed(:,:,trial));
                    end
                end
        end
        if ~isempty(all_aware_trials_early)
            awareTotals_early = size(all_aware_trials_early,3);
        elseif isempty(all_aware_trials_early)
            awareTotals_early = 0;
        end
        
        if ~isempty(all_unaware_trials_early)
            unawareTotals_early = size(all_unaware_trials_early,3);
        elseif isempty(all_unaware_trials_early)
            unawareTotals_early = 0;
        end
        
       if ~isempty(all_aware_trials_late)
            awareTotals_late = size(all_aware_trials_late,3);
        elseif isempty(all_aware_trials_late)
            awareTotals_late = 0;
        end
        
        if ~isempty(all_unaware_trials_late)
            unawareTotals_late = size(all_unaware_trials_late,3);
        elseif isempty(all_unaware_trials_late)
            unawareTotals_late = 0;
        end
        
        
        
        if size(all_aware_trials_early,3) > 1
            mean_aware_erp_early = mean(all_aware_trials_early,3);
        elseif size(all_aware_trials_early,3) == 1
            mean_aware_erp_early = all_aware_trials_early;
        end
        
        if size(all_unaware_trials_early,3) > 1
            mean_unaware_erp_early = mean(all_unaware_trials_early,3);
        elseif size(all_unaware_trials_early,3) == 1
            mean_unaware_erp_early = all_unaware_trials_early;
        end
        
        if size(all_aware_trials_late,3) > 1
            mean_aware_erp_late = mean(all_aware_trials_late,3);
        elseif size(all_aware_trials_late,3) == 1
            mean_aware_erp_late = all_aware_trials_late;
        end
        
        if size(all_unaware_trials_late,3) > 1
            mean_unaware_erp_late = mean(all_unaware_trials_late,3);
        elseif size(all_unaware_trials_late,3) == 1
            mean_unaware_erp_late = all_unaware_trials_late;
        end
        


        
        for channel = 1:257;
            if ~isempty(mean_aware_erp_early) > 0
                mean_aware_erp_early(channel,:) = mean_aware_erp_early(channel,:)-mean(mean_aware_erp_early(channel,:));
            end
            if ~isempty(mean_unaware_erp_early) > 0
                mean_unaware_erp_early(channel,:) = mean_unaware_erp_early(channel,:)-mean(mean_unaware_erp_early(channel,:));
            end
            
            if ~isempty(mean_aware_erp_late)
                mean_aware_erp_late(channel,:) = mean_aware_erp_late(channel,:)-mean(mean_aware_erp_late(channel,:));
            end
            if ~isempty(mean_unaware_erp_late) > 0
                mean_unaware_erp_late(channel,:) = mean_unaware_erp_late(channel,:)-mean(mean_unaware_erp_late(channel,:));
            end    
        end
        output_end = 1;
        save([sessionDate '_mean_erps_split_designations_raw.mat'],'mean_aware_erp_early','mean_unaware_erp_early','awareTotals_early','unawareTotals_early','mean_aware_erp_late','mean_unaware_erp_late','awareTotals_late','unawareTotals_late','creationFunction','-v7.3')
        toc
end
