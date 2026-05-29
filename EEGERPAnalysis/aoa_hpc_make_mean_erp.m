
function output_end = aoa_hpc_make_mean_erp(subjectDirectory,sessionDate)
    
        % Enter subject directory
        cd(subjectDirectory) 
        
        % Load all designations of epochs deemed clean 
        load([sessionDate '_good_epoch_designations_quizzes_then_choose.mat']); 
        
        
        % Load all preprocessed data
        load([sessionDate '_ICA_epochs_components_removed_quizzes_then_choose_long.mat']); 
        
        % Create empty vectors to hold aware and unaware trials
        all_aware_trials = [];
        all_unaware_trials = [];
        
        % Loop through all trials, concatenating trials to aware and
        % unaware trial vectors if their designations are as such.
        for trial = 1:size(ICA_epochs_components_removed,3)
                % In the initial subjects, the term "aware" had not yet
                % been set. Thus, the name CH meant "correct and high", and
                % IL meant "incorrect and low", the eventual definitions of
                % aware and unaware.
                if strcmp(good_epoch_designations{trial},'CH') || strcmp(good_epoch_designations{trial},'Aware')
                    all_aware_trials = cat(3,all_aware_trials,ICA_epochs_components_removed(:,:,trial));
                elseif strcmp(good_epoch_designations{trial},'IL') || strcmp(good_epoch_designations{trial},'Unaware')
                    all_unaware_trials = cat(3,all_unaware_trials,ICA_epochs_components_removed(:,:,trial));
                end
        end
        
        % Tabulate the total number of aware and unaware trials.
        awareTotals = size(all_aware_trials,3);
        unawareTotals = size(all_unaware_trials,3);
        
        % Calculate the mean of all aware and unaware epochs.
        mean_aware_erp = mean(all_aware_trials,3);
        mean_unaware_erp = mean(all_unaware_trials,3);
        
        % To counteract the offset (seen mostly in the EEG/fMRI EGI
        % system), subtract the mean of each channel.
        for channel = 1:257;
            mean_aware_erp(channel,:) = mean_aware_erp(channel,:)-mean(mean_aware_erp(channel,:));
            mean_unaware_erp(channel,:) = mean_unaware_erp(channel,:)-mean(mean_unaware_erp(channel,:));
        end
        
        % Save the mean aware, mean unaware, and all trial totals for the
        % subject.
        save([sessionDate '_mean_erps.mat'],'mean_aware_erp','mean_unaware_erp','awareTotals','unawareTotals','-v7.3')
        toc
end
