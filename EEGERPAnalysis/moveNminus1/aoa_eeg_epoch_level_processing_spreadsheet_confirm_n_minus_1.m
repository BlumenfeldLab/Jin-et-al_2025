%%
clear all
clc

%% Iterate through all sessions, cutting epochs for the move before the quizzed move.
startTime = tic;
[num text raw] = xlsread('/mnt/Data27/HNCT_AoA_Study/AoA_Subjects/AoA_ERP_Quizzes_Then_Choose.xlsx');
root = '/mnt/Data27/HNCT_AoA_Study/AoA_Subjects/';
for session = 1:length(text)
    
    filespath = [root '/' text{1,session} '/' text{2,session} '/']
    cd(filespath)
    sessionName = num2str(num(1,session));

    tic
    disp('Loading bad channels, samples, average reference EEG, and merged EGI file...')
    load([filespath sessionName '_bad_channels_samples.mat'])
    load([filespath sessionName '_EEG_avgref.mat'])
    load([filespath sessionName '_confirm_n_minus_1_to_click_n.mat'])
    
    try
        load([filespath sessionName '_EGI.mat'])
    catch
        load([filespath sessionName '_Merged_EGI.mat'])
    end
    

    %%
    designations = load([filespath sessionName '_good_epoch_designations_quizzes_then_choose_clicks.mat']);
    designations = struct2cell(designations);
    designations = designations{:};
    disp('Done')
    loading_time = toc

    %% 
    Event_Types = {EEG.event.type}.';
    Event_Times = {EEG.event.latency}.';
    
    allConfirmEpochs = [];
    confirmTimes = [];
    goodConfirmTimes = [];
    badConfirmTimes = [];
    runStartTimes = [];
    rejection_threshold = 0.25;
    confirmTimes = confirm_n_minus_1 - offset;
    for confirmation = 1:length(confirm_n_minus_1)

        current_time = confirmTimes(confirmation);
        allConfirmEpochs = cat(3,allConfirmEpochs,EEG_avgref(:,current_time-1999:current_time+2000));

    end
    


    goodConfirmEpochs = [];
    badConfirmEpochs = [];
    good_epoch_designations = {};
    bad_epochs = [];
    bad_epoch_designations = {};
    min_epoch = 2000; % milliseconds beforehand
    max_epoch = 2000;
    good_confirm_key_epochs = [];
    bad_confirm_key_epochs = [];

    for confirm = 1:length(confirmTimes)
        if sum(double(bad_samples(confirmTimes(confirm)-200:confirmTimes(confirm)+499))) < rejection_threshold * (700)
            badConfirmTimes = [badConfirmTimes confirmTimes(confirm)];
            badConfirmEpochs = cat(3,badConfirmEpochs,EEG_avgref(:,confirmTimes(confirm)-min_epoch:confirmTimes(confirm)+max_epoch-1));
            bad_epochs = [bad_epochs 1];
            if ~isempty(designations{confirm}) && (strcmp(designations{confirm},'Aware') || strcmp(designations{confirm},'Unaware') || strcmp(designations{confirm},'CH') || strcmp(designations{confirm},'IL'))
                bad_epoch_designations = [bad_epoch_designations designations{confirm}];
                bad_confirm_key_epochs = cat(3,bad_confirm_key_epochs,EEG_avgref(:,confirmTimes(confirm)-min_epoch:confirmTimes(confirm)+max_epoch-1));
            end

        end
        if sum(double(bad_samples(confirmTimes(confirm)-200:confirmTimes(confirm)+499))) >= rejection_threshold * (700)
            goodConfirmTimes = [goodConfirmTimes confirmTimes(confirm)];
            goodConfirmEpochs = cat(3,goodConfirmEpochs,EEG_avgref(:,confirmTimes(confirm)-min_epoch:confirmTimes(confirm)+max_epoch-1));
            bad_epochs = [bad_epochs 0]; 
            if ~isempty(designations{confirm}) && (strcmp(designations{confirm},'Aware') || strcmp(designations{confirm},'Unaware') || strcmp(designations{confirm},'CH') || strcmp(designations{confirm},'IL'))
                good_epoch_designations = [good_epoch_designations designations{confirm}];
                good_confirm_key_epochs = cat(3,good_confirm_key_epochs,EEG_avgref(:,confirmTimes(confirm)-min_epoch:confirmTimes(confirm)+max_epoch-1));
            end
        end
    end
    

    %%

    eval(['save ' filespath sessionName '_goodConfirmTimes_nMinus1.mat goodConfirmTimes -v7.3'])
    eval(['save ' filespath sessionName '_goodConfirmEpochs_nMinus1.mat goodConfirmEpochs -v7.3'])
    eval(['save ' filespath sessionName '_badConfirmTimes_nMinus1.mat badConfirmTimes -v7.3'])
    eval(['save ' filespath sessionName '_badConfirmEpochs_nMinus1.mat badConfirmEpochs -v7.3'])
    eval(['save ' filespath sessionName '_bad_epochs_confirms_nMinus1.mat bad_epochs -v7.3'])
    eval(['save ' filespath sessionName '_bad_epoch_designations_confirms_nMinus1.mat bad_epoch_designations -v7.3'])
    eval(['save ' filespath sessionName '_good_epoch_designations_confirms_nMinus1.mat good_epoch_designations -v7.3'])
    eval(['save ' filespath sessionName '_bad_confirm_key_epochs_nMinus1.mat bad_confirm_key_epochs -v7.3'])
    eval(['save ' filespath sessionName '_good_confirm_key_epochs_nMinus1.mat good_confirm_key_epochs -v7.3'])
    eval(['save ' filespath sessionName '_offset.mat offset -v7.3'])
end
endTime = toc-startTime
