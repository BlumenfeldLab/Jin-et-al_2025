clear all; close all; clc
subjectDir = '/vast/palmer/pi/blumenfeld/dsj8/AoA_Study/Click_Confirm_Differential';
creationFunction = 'aoa_hpc_cut_click_epochs_from_confirm';
subjectDirContents = dir(subjectDir);

subjectTable = struct2table(subjectDirContents(3:end));
subjectTable.Aware = cell(1,size(subjectTable,1))';
subjectTable.Unaware = cell(1,size(subjectTable,1))';
subjectTable.AwareMean = cell(1,size(subjectTable,1))';
subjectTable.UnawareMean = cell(1,size(subjectTable,1))';
subjectTable.badTrialsAware = cell(1,size(subjectTable,1))';
subjectTable.badTrialsUnaware = cell(1,size(subjectTable,1))';
tic
for subject = 1:size(subjectTable,2)
    currentSubject = subjectTable.name{subject};
    disp(['Analyzing ' currentSubject])
    currentSubjectConfirmEpochs = ...
        dir(['/vast/palmer/pi/blumenfeld/dsj8/AoA_Study/Long_Epochs_For_Time_Frequency/' currentSubject]);
    currentSubjectDayDirectories = squeeze(struct2cell(currentSubjectConfirmEpochs))';
    for directory = 3:size(currentSubjectDayDirectories,1)
        load(['/vast/palmer/pi/blumenfeld/dsj8/AoA_Study/Long_Epochs_For_Time_Frequency/' currentSubject ...
            '/' currentSubjectDayDirectories{directory,1} '/'  currentSubject '_' ...
            currentSubjectDayDirectories{directory,1} '_ICA_epochs_components_removed_quizzes_then_choose_long.mat'])
        load(['/vast/palmer/pi/blumenfeld/dsj8/AoA_Study/Long_Epochs_For_Time_Frequency/' currentSubject ...
            '/' currentSubjectDayDirectories{directory,1} '/'  currentSubject '_' ...
            currentSubjectDayDirectories{directory,1} '_good_epoch_designations_quizzes_then_choose.mat'])
        load(['/vast/palmer/pi/blumenfeld/dsj8/AoA_Study/Click_Confirm_Differential/' currentSubject ...
            '/' currentSubjectDayDirectories{directory,1} '/click_initiation_diffs.mat'])
        ICA_epochs_components_removed_click_diffs = zeros(257,4000,size(ICA_epochs_components_removed,3));
        extraLongEpochs = [];
        for epoch = 1:size(ICA_epochs_components_removed,3);
            if goodDiffDurations(epoch) < 1000
                currentEpoch = ICA_epochs_components_removed(:,1001-goodDiffDurations(epoch):5000-goodDiffDurations(epoch),epoch);
                ICA_epochs_components_removed_click_diffs(:,:,epoch) = currentEpoch;
            elseif goodDiffDurations(epoch) >= 1000
                disp(['Extra long click to confirm duration found, ' num2str(goodDiffDurations(epoch)) 'ms'])
                extraLongEpochs = [extraLongEpochs epoch];
            end
        end
        ICA_epochs_components_removed = ICA_epochs_components_removed_click_diffs;
        
        awareTrials = [];
        unawareTrials = [];
        
        for trial = 1:length(good_epoch_designations)
            if strcmp(good_epoch_designations{trial},'Aware');
                awareTrials = cat(3,awareTrials,ICA_epochs_components_removed(:,:,trial));
            end
            if strcmp(good_epoch_designations{trial},'Unaware');
                unawareTrials = cat(3,unawareTrials,ICA_epochs_components_removed(:,:,trial));
            end
            
        end
        subjectTable.Aware{subject} = cat(3,subjectTable.Aware{subject},awareTrials);
        subjectTable.Unaware{subject} = cat(3,subjectTable.Unaware{subject},unawareTrials);
        emptyTrialsAware = squeeze(all(all(awareTrials == 0, 1), 2));
        emptyTrialSumAware = sum(find(emptyTrialsAware));
        emptyTrialsUnaware = squeeze(all(all(unawareTrials == 0, 1), 2));
        emptyTrialSumUnaware = sum(find(emptyTrialsUnaware));
        
        subjectTable.badTrialsAware{subject} = [subjectTable.badTrialsAware{subject} emptyTrialSumAware];
        subjectTable.badTrialsUnaware{subject} = [subjectTable.badTrialsUnaware{subject} emptyTrialSumUnaware];
        
        

            
    end
    subjectTable.AwareMean{subject} = mean(subjectTable.Aware{subject},3);
    subjectTable.UnawareMean{subject} = mean(subjectTable.Unaware{subject},3);
    toc
end
