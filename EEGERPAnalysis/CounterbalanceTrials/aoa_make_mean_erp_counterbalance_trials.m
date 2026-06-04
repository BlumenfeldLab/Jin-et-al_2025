% For an individual subject, first loads both aware and unaware trials. 
% For the condition which has more trials, select 1000 times with
% replacement the number of the condition with has fewer trials. Then,
% average the 1000 to create a counterbalanced mean ERP.
function output_end = aoa_make_mean_erp_counterbalance_trials(subject_number);
    baseDirectory = '/vast/palmer/pi/blumenfeld/dsj8/AoA_Study/Long_Epochs_For_Time_Frequency'
    cd(baseDirectory)


    tic
    disp(['Analyzing ' subject_number])
    cd([baseDirectory '/' subject_number]);
    all_aware_trials_combined = [];
    all_unaware_trials_combined = [];
    try
        cd([baseDirectory '/' subject_number '/Day2'])
        load([subject_number '_Day2_designated_erps.mat'])
        all_aware_trials_combined = cat(3,all_aware_trials_combined,all_aware_trials);
        all_unaware_trials_combined = cat(3,all_unaware_trials_combined,all_unaware_trials);

    catch
        disp('No Day 2 Found!')
    end
    try
        cd([baseDirectory '/' subject_number '/Day3'])
        load([subject_number '_Day3_designated_erps.mat'])
        all_aware_trials_combined = cat(3,all_aware_trials_combined,all_aware_trials);
        all_unaware_trials_combined = cat(3,all_unaware_trials_combined,all_unaware_trials);
    catch
        disp('No Day 3 Found!')
    end
    if isempty(all_aware_trials_combined) || isempty(all_unaware_trials_combined)
        disp('Empty aware or unaware vector.')
    end

    awareTrials = size(all_aware_trials_combined,3);
    unawareTrials = size(all_unaware_trials_combined,3);

    aware_bootstrap = [];
    unaware_bootstrap = [];
    if awareTrials > unawareTrials
        aware_bootstrap = zeros(257,6000,1000);
        for permutation = 1:1000
            disp(['Performing permutation ' num2str(permutation)])
            indices = randperm(unawareTrials);
            aware_bootstrap(:,:,permutation) = mean(all_aware_trials_combined(:,:,indices(1:unawareTrials)),3);
        end

    end
    if awareTrials < unawareTrials
        unaware_bootstrap = zeros(257,6000,1000);
        for permutation = 1:1000
            disp(['Performing permutation ' num2str(permutation)])
            indices = randperm(awareTrials);
            unaware_bootstrap(:,:,permutation) = mean(all_unaware_trials_combined(:,:,indices(1:awareTrials)),3);
        end


    end
    output_end = 1;
    toc
    mean_aware_bootstrap = mean(aware_bootstrap,3);
    mean_unaware_bootstrap = mean(unaware_bootstrap,3);
    avg_aware_erp = mean(all_aware_trials_combined,3);
    avg_unaware_erp = mean(all_unaware_trials_combined,3);
    creationFunction = 'aoa_make_mean_erp_counterbalance_trials.m';
    cd('/vast/palmer/pi/blumenfeld/dsj8/AoA_Study/Counterbalance_Trials/')
    save([subject_number '_counterbalanced_trials.mat'],'aware_bootstrap','unaware_bootstrap','avg_aware_erp','avg_unaware_erp','all_aware_trials_combined','all_unaware_trials_combined','mean_aware_bootstrap','mean_unaware_bootstrap','creationFunction','-v7.3')
    toc
end

