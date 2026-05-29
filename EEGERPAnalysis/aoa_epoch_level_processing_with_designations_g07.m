%% This script analyzes any EEG file with a room designation of "G07" or "OldNL09" (see raw EEG data for room location)
clear all
clc

%% Instatiate variables and load outputs from session level processing
filespath = 'Y:\HNCT_AoA_Study\AoA_Subjects\816\Day3\';
cd(filespath)
sessionName = '999999999999';
tic
disp('Loading bad channels, samples, average reference EEG, and merged EGI file...')
load([filespath sessionName '_bad_channels_samples.mat'])
load([filespath sessionName '_EEG_avgref.mat'])
try
    load([filespath sessionName '_Merged_EGI.mat'])
catch
    load([filespath sessionName '_EGI.mat'])
end
%% Load designations from behavioral analysis
designations = load([filespath sessionName '_designations.mat']);
originalDesignations = struct2cell(designations);
designations = struct2cell(designations);
designations = designations{:};

disp('Done')
loading_time = toc

%% Use combinations of TTL pulses (described in raw dataset) to get epochs
Event_Types = {EEG.event.type}.';
Event_Times = {EEG.event.latency}.';
confirmTimes = [];
goodConfirmTimes = [];
badConfirmTimes = [];
runStartTimes = [];
rejection_threshold = 0.25;
previousClickPast = [];
previousConfirmPast = [];
nextClickPast = [];
nextConfirmPast = [];
quizEvents = [];
weirdQuizEvents = [];
eventIndices = [];
designationCount = 1;
badDesignations = [];

runEndTimes = [];
offset = 70; % determined based on photodiode testing
for event = 2:length(Event_Types)-7
    if strcmp(Event_Types{event},'Que4') && strcmp(Event_Types{event+1},'Fac2') && strcmp(Event_Types{event+2},'Fac2') && strcmp(Event_Types{event+3},'Trl1') && strcmp(Event_Types{event+4},'Fac2') && strcmp(Event_Types{event+5},'Fac2') && strcmp(Event_Types{event+6},'Trl1') 
        confirmTimes = [confirmTimes Event_Times{event}];
        previousClickPast = [previousClickPast Event_Times{event}-Event_Times{event-1}];
        previousConfirmPast = [previousConfirmPast Event_Times{event}-Event_Times{event-2}];
        eventIndices = [eventIndices event];
        designationCount = designationCount + 1;
    end
    if strcmp(Event_Types{event},'Que4') && strcmp(Event_Types{event+1},'Fac2') && strcmp(Event_Types{event+2},'Trl1') && strcmp(Event_Types{event+3},'Fac2') && strcmp(Event_Types{event+4},'Fac2') && strcmp(Event_Types{event+5},'Trl1') %&& strcmp(Event_Types{event+6},'Que4')
        confirmTimes = [confirmTimes Event_Times{event}];
        previousClickPast = [previousClickPast Event_Times{event}-Event_Times{event-1}];
        previousConfirmPast = [previousConfirmPast Event_Times{event}-Event_Times{event-2}];
        weirdQuizEvents = [weirdQuizEvents event];
        eventIndices = [eventIndices event];
        designationCount = designationCount + 1;
    end
    if strcmp(Event_Types{event},'Que4') && strcmp(Event_Types{event+1},'Fac2') && strcmp(Event_Types{event+2},'Fac2') && strcmp(Event_Types{event+3},'Trl1') && strcmp(Event_Types{event+4},'Fac2') && strcmp(Event_Types{event+5},'Trl1') %&& strcmp(Event_Types{event+6},'Que4')
        confirmTimes = [confirmTimes Event_Times{event}];
        previousClickPast = [previousClickPast Event_Times{event}-Event_Times{event-1}];
        previousConfirmPast = [previousConfirmPast Event_Times{event}-Event_Times{event-2}];
        weirdQuizEvents = [weirdQuizEvents event];
        eventIndices = [eventIndices event];
        designationCount = designationCount + 1;
    end
    if strcmp(Event_Types{event},'Que4') && strcmp(Event_Types{event+1},'Trl1') && strcmp(Event_Types{event+2},'Fac2') && strcmp(Event_Types{event+3},'Fac2') && strcmp(Event_Types{event+4},'Trl1')
        confirmTimes = [confirmTimes Event_Times{event}];
        previousClickPast = [previousClickPast Event_Times{event}-Event_Times{event-1}];
        previousConfirmPast = [previousConfirmPast Event_Times{event}-Event_Times{event-2}];
        weirdQuizEvents = [weirdQuizEvents event];
        eventIndices = [eventIndices event];
        designationCount = designationCount + 1;
    end
    if strcmp(Event_Types{event},'Pre8') && strcmp(Event_Types{event+1},'Fac2') && strcmp(Event_Types{event+2},'Fac2') && strcmp(Event_Types{event+3},'Trl1') && strcmp(Event_Types{event+4},'Fac2') && strcmp(Event_Types{event+5},'Fac2') && strcmp(Event_Types{event+6},'Trl1')
        badDesignations = [badDesignations designationCount];
        designationCount = designationCount + 1;
        
    end
    if strcmp(Event_Types{event},'Pre8') && strcmp(Event_Types{event+1},'Fac2') && strcmp(Event_Types{event+2},'Trl1') && strcmp(Event_Types{event+3},'Fac2') && strcmp(Event_Types{event+4},'Fac2') && strcmp(Event_Types{event+5},'Trl1')
        badDesignations = [badDesignations designationCount];
        designationCount = designationCount + 1;
        
    end
    if strcmp(Event_Types{event},'Pre8') && strcmp(Event_Types{event+1},'Fac2') && strcmp(Event_Types{event+2},'Fac2') && strcmp(Event_Types{event+3},'Trl1') && strcmp(Event_Types{event+4},'Fac2') && strcmp(Event_Types{event+5},'Trl1')
        badDesignations = [badDesignations designationCount];
        designationCount = designationCount + 1;
        
    end
    if event > 3
        if strcmp(Event_Types{event+1},'Trl1') && strcmp(Event_Types{event+2},'Que4') && strcmp(Event_Types{event+3},'Pre8') && strcmp(Event_Types{event+4},'Fac2')
            runEndTimes = [runEndTimes Event_Times{event}];
            a = event;
        end
    end
    if event > 3
        if strcmp(Event_Types{event},'Pre8') && strcmp(Event_Types{event-1},'Trl1') && strcmp(Event_Types{event-2},'Trl1') && strcmp(Event_Types{event-3},'Trl1')
            runStartTimes = [runStartTimes Event_Times{event}];
            b = event;
        end
    end
end
confirmTimes = confirmTimes + offset;


allConfirmEpochs = [];
goodConfirmEpochs = [];
badConfirmEpochs = [];
good_epoch_designations = {};
bad_epochs = [];
bad_epoch_designations = {};
min_epoch = 2000; % milliseconds beforehand
max_epoch = 2000;
good_confirm_key_epochs = [];
bad_confirm_key_epochs = [];
preliminaryDesignations = [];
for designation = 1:length(designations)
    if sum(designation == badDesignations) == 0
        preliminaryDesignations = [preliminaryDesignations designations(designation)];
    end
end
designations = preliminaryDesignations; 

for confirmation = 1:length(confirmTimes)
    allConfirmEpochs = cat(3,allConfirmEpochs,EEG_avgref(:,confirmTimes(confirmation)-min_epoch:confirmTimes(confirmation)+max_epoch-1));
    if sum(double(bad_samples(confirmTimes(confirmation)-200:confirmTimes(confirmation)+499))) < rejection_threshold * (700)
        badConfirmTimes = [badConfirmTimes confirmTimes(confirmation)];
        badConfirmEpochs = cat(3,badConfirmEpochs,EEG_avgref(:,confirmTimes(confirmation)-min_epoch:confirmTimes(confirmation)+max_epoch-1));
        bad_epochs = [bad_epochs 1];
        if ~isempty(designations{confirmation}) && (strcmp(designations{confirmation},'Aware') || strcmp(designations{confirmation},'Unaware') || strcmp(designations{confirmation},'CH') || strcmp(designations{confirmation},'IL'))
            bad_epoch_designations = [bad_epoch_designations designations{confirmation}];
            bad_confirm_key_epochs = cat(3,bad_confirm_key_epochs,EEG_avgref(:,confirmTimes(confirmation)-min_epoch:confirmTimes(confirmation)+max_epoch-1));
        end
        
    end
    if sum(double(bad_samples(confirmTimes(confirmation)-200:confirmTimes(confirmation)+499))) >= rejection_threshold * (700)
        goodConfirmTimes = [goodConfirmTimes confirmTimes(confirmation)];
        goodConfirmEpochs = cat(3,goodConfirmEpochs,EEG_avgref(:,confirmTimes(confirmation)-min_epoch:confirmTimes(confirmation)+max_epoch-1));
        bad_epochs = [bad_epochs 0]; 
        if ~isempty(designations{confirmation}) && (strcmp(designations{confirmation},'Aware') || strcmp(designations{confirmation},'Unaware') || strcmp(designations{confirmation},'CH') || strcmp(designations{confirmation},'IL'))
            good_epoch_designations = [good_epoch_designations designations{confirmation}];
            good_confirm_key_epochs = cat(3,good_confirm_key_epochs,EEG_avgref(:,confirmTimes(confirmation)-min_epoch:confirmTimes(confirmation)+max_epoch-1));
        end
    end
end
%% Gather the epochs for the previous move
previousClickPastAware = [];
previousClickPastUnaware = [];
previousConfirmPastAware = [];
previousConfirmPastUnaware = [];
previousClickPastAll = [];
previousConfirmPastAll = [];
for designation = 1:length(designations);
    try
        if (strcmp(designations{designation},'Aware') || strcmp(designations{designation},'CH')) && bad_epochs(designation) == 0
            previousClickPastAware = [previousClickPastAware previousClickPast(designation)];
            previousConfirmPastAware = [previousConfirmPastAware previousConfirmPast(designation)];
            previousClickPastAll = [previousClickPastAll previousClickPast(designation)];
            previousConfirmPastAll = [previousConfirmPastAll previousConfirmPast(designation)];
        end
        if (strcmp(designations{designation},'Unaware') || strcmp(designations{designation},'IL')) && bad_epochs(designation) == 0
            previousClickPastUnaware = [previousClickPastUnaware previousClickPast(designation)];
            previousConfirmPastUnaware = [previousConfirmPastUnaware previousConfirmPast(designation)];
            previousClickPastAll = [previousClickPastAll previousClickPast(designation)];
            previousConfirmPastAll = [previousConfirmPastAll previousConfirmPast(designation)];
        end
    catch
        continue
    end
end
previousClickPast = previousClickPastAll;
previousConfirmPast = previousConfirmPastAll;

%% Save all variavbles
eval(['save ' filespath sessionName '_previousClickPast.mat previousClickPast -v7.3'])
eval(['save ' filespath sessionName '_previousConfirmPast.mat previousConfirmPast -v7.3'])
eval(['save ' filespath sessionName '_previousClickPastAware.mat previousClickPastAware -v7.3'])
eval(['save ' filespath sessionName '_previousClickPastUnaware.mat previousClickPastUnaware -v7.3'])
eval(['save ' filespath sessionName '_previousConfirmPastAware.mat previousConfirmPastAware -v7.3'])
eval(['save ' filespath sessionName '_previousConfirmPastUnaware.mat previousConfirmPastUnaware -v7.3'])
eval(['save ' filespath sessionName '_goodConfirmTimes.mat goodConfirmTimes -v7.3'])
eval(['save ' filespath sessionName '_goodConfirmEpochs.mat goodConfirmEpochs -v7.3'])
eval(['save ' filespath sessionName '_badConfirmTimes.mat badConfirmTimes -v7.3'])
eval(['save ' filespath sessionName '_badConfirmEpochs.mat badConfirmEpochs -v7.3'])
eval(['save ' filespath sessionName '_bad_epochs.mat bad_epochs -v7.3'])
eval(['save ' filespath sessionName '_bad_epoch_designations.mat bad_epoch_designations -v7.3'])
eval(['save ' filespath sessionName '_good_epoch_designations.mat good_epoch_designations -v7.3'])
eval(['save ' filespath sessionName '_bad_confirm_key_epochs.mat bad_confirm_key_epochs -v7.3'])
eval(['save ' filespath sessionName '_good_confirm_key_epochs.mat good_confirm_key_epochs -v7.3'])
