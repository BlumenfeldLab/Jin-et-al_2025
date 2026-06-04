%% Loads and saves subject trial-counterbalanced data.

clear all; close all; clc
cd('/vast/palmer/pi/blumenfeld/dsj8/AoA_Study/Counterbalance_Trials/')
trial_location = dir('/vast/palmer/pi/blumenfeld/dsj8/AoA_Study/Counterbalance_Trials');
trial_location = struct2table(trial_location);

all_files = trial_location.name(3:end);
allSubjectMeansAware = [];
allSubjectMeansUnaware = [];
avg_erp_all_channels_aware_subjects = [];
avg_erp_all_channels_unaware_subjects = [];
for file = 1:length(all_files)
    disp(['Loading ' all_files{file}(1:3)])
    load(all_files{file},'avg_aware_erp','avg_unaware_erp','mean_aware_bootstrap','mean_unaware_bootstrap')
    for electrode = 1:257
        avg_aware_erp(electrode,:) = avg_aware_erp(electrode,:)-mean(avg_aware_erp(electrode,:));
        avg_unaware_erp(electrode,:) = avg_unaware_erp(electrode,:)-mean(avg_unaware_erp(electrode,:));
    end
    if isempty(mean_aware_bootstrap) && ~isempty(mean_unaware_bootstrap)
        for electrode = 1:257
            mean_unaware_bootstrap(electrode,:) = mean_unaware_bootstrap(electrode,:)-mean(mean_unaware_bootstrap(electrode,:));
        end
        allSubjectMeansAware = cat(3,allSubjectMeansAware,avg_aware_erp);
        allSubjectMeansUnaware = cat(3,allSubjectMeansUnaware,mean_unaware_bootstrap);
        avg_erp_all_channels_aware_subjects = cat(3,avg_erp_all_channels_aware_subjects,avg_aware_erp);
        avg_erp_all_channels_unaware_subjects = cat(3,avg_erp_all_channels_unaware_subjects,mean_unaware_bootstrap);
    end
    if ~isempty(mean_aware_bootstrap) && isempty(mean_unaware_bootstrap)
        for electrode = 1:257
            mean_aware_bootstrap(electrode,:) = mean_aware_bootstrap(electrode,:)-mean(mean_aware_bootstrap(electrode,:));
        end
        allSubjectMeansAware = cat(3,allSubjectMeansAware,mean_aware_bootstrap);
        allSubjectMeansUnaware = cat(3,allSubjectMeansUnaware,avg_unaware_erp);
        avg_erp_all_channels_aware_subjects = cat(3,avg_erp_all_channels_aware_subjects,mean_aware_bootstrap);
        avg_erp_all_channels_unaware_subjects = cat(3,avg_erp_all_channels_unaware_subjects,avg_unaware_erp);
    end
    if isempty(mean_aware_bootstrap) && isempty(mean_unaware_bootstrap)
        allSubjectMeansAware = cat(3,allSubjectMeansAware,avg_aware_erp);
        allSubjectMeansUnaware = cat(3,allSubjectMeansUnaware,avg_unaware_erp);
        avg_erp_all_channels_aware_subjects = cat(3,avg_erp_all_channels_aware_subjects,avg_aware_erp);
        avg_erp_all_channels_unaware_subjects = cat(3,avg_erp_all_channels_unaware_subjects,avg_unaware_erp);
    end
end
avg_erp_all_channels_aware_subjects = avg_erp_all_channels_aware_subjects(:,1001:5000,:);
avg_erp_all_channels_unaware_subjects = avg_erp_all_channels_unaware_subjects(:,1001:5000,:);
creationFunction = 'aoa_build_group_erp_means_counterbalance.m';
creationDate = datetime('now');
cd('/vast/palmer/pi/blumenfeld/dsj8/AoA_Study')
save('aoa_group_erp_means_counterbalance.mat','allSubjectMeansAware','allSubjectMeansUnaware','avg_erp_all_channels_aware_subjects','avg_erp_all_channels_unaware_subjects','creationFunction','creationDate','-v7.3')
