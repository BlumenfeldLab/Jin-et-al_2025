clear all;
close all;


root = '//gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Pupil_Data/';
sig_lines = true;
addpath(root)


allDirectories = dir('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Pupil_Data');
allSubjectDirectories = [];
allSubjectNames = [];
allSubjectDays = [];
subject_names = [];
sessionDates = [];
problem_subjs = [];
for entry = 3:length(allDirectories)
    subject_name = allDirectories(entry).name;
    allSubdirectories = dir(['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Pupil_Data/' subject_name]);
    for subdirectory = 3:length(allSubdirectories)
        allSubjectDirectories = [allSubjectDirectories;{['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Pupil_Data/' subject_name '/' allSubdirectories(subdirectory).name]}];
        
        allSubjectNames = [allSubjectNames; {subject_name}];
        allSubjectDays = [allSubjectDays;{allSubdirectories(subdirectory).name}];
        folderContents = dir(['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Pupil_Data/' subject_name '/' allSubdirectories(subdirectory).name]);
    end
end

disp('Loading data...')

tic





%% Load and average all subjects together
binsize = 100;
tic
all_subj_pupil_data_left = [unique(allSubjectNames)'; cell(8,length(unique(allSubjectNames)))];
all_subj_pupil_data_right = [unique(allSubjectNames)'; cell(8,length(unique(allSubjectNames)))];
all_subj_pupil_data_left_raw = [unique(allSubjectNames)'; cell(8,length(unique(allSubjectNames)))];
all_subj_pupil_data_right_raw = [unique(allSubjectNames)'; cell(8,length(unique(allSubjectNames)))];
all_subj_sac_data_left = [unique(allSubjectNames)'; cell(8,length(unique(allSubjectNames)))];
all_subj_sac_data_right = [unique(allSubjectNames)'; cell(8,length(unique(allSubjectNames)))];
all_subj_sac_rate_left = [unique(allSubjectNames)'; cell(8,length(unique(allSubjectNames)))];
all_subj_sac_rate_right = [unique(allSubjectNames)'; cell(8,length(unique(allSubjectNames)))];
all_subj_sac_rate_left_remove2s = [unique(allSubjectNames)'; cell(8,length(unique(allSubjectNames)))];
all_subj_sac_rate_right_remove2s = [unique(allSubjectNames)'; cell(8,length(unique(allSubjectNames)))];
all_subj_blink_data_left = [unique(allSubjectNames)'; cell(8,length(unique(allSubjectNames)))];
all_subj_blink_data_right = [unique(allSubjectNames)'; cell(8,length(unique(allSubjectNames)))];
all_subj_long_blink_data_left = [unique(allSubjectNames)'; cell(8,length(unique(allSubjectNames)))];
all_subj_long_blink_data_right = [unique(allSubjectNames)'; cell(8,length(unique(allSubjectNames)))];
all_subj_long_blink_data_left_bin = [unique(allSubjectNames)'; cell(8,length(unique(allSubjectNames)))];
all_subj_long_blink_data_right_bin = [unique(allSubjectNames)'; cell(8,length(unique(allSubjectNames)))];
all_subj_sac_duration_data_left = [unique(allSubjectNames)'; cell(8,length(unique(allSubjectNames)))];
all_subj_sac_duration_data_right = [unique(allSubjectNames)'; cell(8,length(unique(allSubjectNames)))];
all_subj_blink_duration_data_left = [unique(allSubjectNames)'; cell(8,length(unique(allSubjectNames)))];
all_subj_blink_duration_data_right = [unique(allSubjectNames)'; cell(8,length(unique(allSubjectNames)))];
all_subj_minus1to0_data_left = [unique(allSubjectNames)'; cell(8,length(unique(allSubjectNames)))];
all_subj_minus1to0_data_right = [unique(allSubjectNames)'; cell(8,length(unique(allSubjectNames)))];
all_subj_minus2minus1_data_left = [unique(allSubjectNames)'; cell(8,length(unique(allSubjectNames)))];
all_subj_minus2minus1_data_right = [unique(allSubjectNames)'; cell(8,length(unique(allSubjectNames)))];
all_subj_remove2s_data_left = [unique(allSubjectNames)'; cell(8,length(unique(allSubjectNames)))];
all_subj_remove2s_data_right = [unique(allSubjectNames)'; cell(8,length(unique(allSubjectNames)))];
all_subj_nan2s_data_left = [unique(allSubjectNames)'; cell(8,length(unique(allSubjectNames)))];
all_subj_nan2s_data_right = [unique(allSubjectNames)'; cell(8,length(unique(allSubjectNames)))];
all_subj_remove2s_data_left_raw = [unique(allSubjectNames)'; cell(8,length(unique(allSubjectNames)))];
all_subj_remove2s_data_right_raw = [unique(allSubjectNames)'; cell(8,length(unique(allSubjectNames)))];
for currenteye = 1:2
    
    if currenteye == 1
        eye = 'left'
    elseif currenteye == 2
        eye = 'right'
    end
    for session_number = 1:length(allSubjectNames)
        disp(['Loading ' allSubjectNames{session_number}])
        %try
            sessionPath = allSubjectDirectories{session_number};
            cd(sessionPath)
            fullsession = [allSubjectNames{session_number} '_' allSubjectDays{session_number}];
            load([fullsession '_mean_eye_metrics_' eye '_v6.mat'],'allSubjAwareNoNansMean','allSubjUnawareNoNansMean','allSubjMHNoNansMean','allSubjMLNoNansMean','awaretrials','unawaretrials','MHtrials','MLtrials');
            load([fullsession '_mean_eye_metrics_' eye '_v6.mat'],'allSubjAwareNoNansMeanRaw','allSubjUnawareNoNansMeanRaw','allSubjMHNoNansMeanRaw','allSubjMLNoNansMeanRaw','awaretrials','unawaretrials','MHtrials','MLtrials');
            load([fullsession '_mean_eye_metrics_' eye '_v6.mat'],'allSubjSacRateAware','allSubjSacRateUnaware','allSubjSacRateMH','allSubjSacRateML','allSubjAwareSaccadesOnsetRates','allSubjUnawareSaccadesOnsetRates','allSubjMHSaccadesOnsetRates','allSubjMLSaccadesOnsetRates')
            load([fullsession '_mean_eye_metrics_' eye '_v6.mat'],'allSubjLongBlinkRateAware','allSubjLongBlinkRateUnaware','allSubjLongBlinkRateMH','allSubjLongBlinkRateML')
            load([fullsession '_mean_eye_metrics_' eye '_v6.mat'],'allSubjRegBlinkRateAware','allSubjRegBlinkRateUnaware','allSubjRegBlinkRateMH','allSubjRegBlinkRateML')
            load([fullsession '_mean_eye_metrics_' eye '_v6.mat'],'meanBinAwareLongBlinks','meanBinUnawareLongBlinks','meanBinMHLongBlinks','meanBinMLLongBlinks')
            load([fullsession '_mean_eye_metrics_' eye '_v6.mat'],'allSubjMeanSacDurationAware','allSubjMeanSacDurationUnaware','allSubjMeanSacDurationMH','allSubjMeanSacDurationML')
            load([fullsession '_mean_eye_metrics_' eye '_v6.mat'],'allSubjMeanBlinkDurationsAware','allSubjMeanBlinkDurationsUnaware','allSubjMeanBlinkDurationsMH','allSubjMeanBlinkDurationsML')
            load([fullsession '_mean_eye_metrics_' eye '_v6.mat'],'allSubjAwareNoNansMeanRaw_minus1to0','allSubjUnawareNoNansMeanRaw_minus1to0','allSubjMHNoNansMeanRaw_minus1to0','allSubjMLNoNansMeanRaw_minus1to0')
            load([fullsession '_mean_eye_metrics_' eye '_v6.mat'],'allSubjAwareNoNansMeanRaw_minus2minus1','allSubjUnawareNoNansMeanRaw_minus2minus1','allSubjMHNoNansMeanRaw_minus2minus1','allSubjMLNoNansMeanRaw_minus2minus1')
            load([fullsession '_mean_eye_metrics_' eye '_v6.mat'],'allSubjAwareRemove2s','allSubjUnawareRemove2s','allSubjMHRemove2s','allSubjMLRemove2s')
            load([fullsession '_mean_eye_metrics_' eye '_v6.mat'],'allSubjAwareRemove2sTrials','allSubjUnawareRemove2sTrials','allSubjMHRemove2sTrials','allSubjMLRemove2sTrials')
            load([fullsession '_mean_eye_metrics_' eye '_v6.mat'],'allSubjAwareNan2s','allSubjUnawareNan2s','allSubjMHNan2s','allSubjMLNan2s')
            load([fullsession '_mean_eye_metrics_' eye '_v6.mat'],'allSubjAwareRemove2sRaw','allSubjUnawareRemove2sRaw','allSubjMHRemove2sRaw','allSubjMLRemove2sRaw')
            load([fullsession '_mean_eye_metrics_' eye '_v6.mat'],'allSubjSacRateAwareRemove2s','allSubjSacRateUnawareRemove2s','allSubjSacRateMHRemove2s','allSubjSacRateMLRemove2s')
            % If any nans are found, turn into empty vectors
            if isnan(allSubjLongBlinkRateAware)
                allSubjLongBlinkRateAware = nan(1,16000);
            end
            if isnan(allSubjLongBlinkRateUnaware)
                allSubjLongBlinkRateUnaware = nan(1,16000);
            end
            if isnan(allSubjLongBlinkRateMH)
                allSubjLongBlinkRateMH = nan(1,16000);
            end
            if isnan(allSubjLongBlinkRateML)
                allSubjLongBlinkRateML = nan(1,16000);
            end
            
            if isnan(allSubjAwareNoNansMean)
                allSubjAwareNoNansMean = nan(1,8000);
            end
            if isnan(allSubjUnawareNoNansMean)
                allSubjUnawareNoNansMean = nan(1,8000);
            end
            if isnan(allSubjMHNoNansMean)
                allSubjMHNoNansMean = nan(1,8000);
            end
            if isnan(allSubjMLNoNansMean)
                allSubjMLNoNansMean = nan(1,8000);
            end
            
            if isnan(allSubjAwareNoNansMeanRaw)
                allSubjAwareNoNansMeanRaw = nan(1,8000);
            end
            if isnan(allSubjUnawareNoNansMeanRaw)
                allSubjUnawareNoNansMeanRaw = nan(1,8000);
            end
            if isnan(allSubjMHNoNansMeanRaw)
                allSubjMHNoNansMeanRaw = nan(1,8000);
            end
            if isnan(allSubjMLNoNansMeanRaw)
                allSubjMLNoNansMeanRaw = nan(1,8000);
            end
            
            if isnan(allSubjRegBlinkRateAware)
                allSubjRegBlinkRateAware = nan(1,16000);
            end
            if isnan(allSubjRegBlinkRateUnaware)
                allSubjRegBlinkRateUnaware = nan(1,16000);
            end
            if isnan(allSubjRegBlinkRateMH)
                allSubjRegBlinkRateMH = nan(1,16000);
            end
            if isnan(allSubjRegBlinkRateML)
                allSubjRegBlinkRateML = nan(1,16000);
            end
            
            if isnan(allSubjSacRateAware)
                allSubjSacRateAware = nan(1,16000);
            end
            if isnan(allSubjSacRateUnaware)
                allSubjSacRateUnaware = nan(1,16000);
            end
            
            if isnan(allSubjSacRateMH)
                allSubjSacRateMH = nan(1,16000);
            end
            if isnan(allSubjSacRateML)
                allSubjSacRateML = nan(1,16000);
            end
            
            if isnan(allSubjSacRateAwareRemove2s)
                allSubjSacRateAwareRemove2s = nan(1,16000);
            end
            if isnan(allSubjSacRateUnawareRemove2s)
                allSubjSacRateUnawareRemove2s = nan(1,16000);
            end
            
            if isnan(allSubjSacRateMHRemove2s)
                allSubjSacRateMHRemove2s = nan(1,16000);
            end
            if isnan(allSubjSacRateMLRemove2s)
                allSubjSacRateMLRemove2s = nan(1,16000);
            end
            
            if isnan(allSubjAwareNoNansMeanRaw_minus2minus1)
                allSubjAwareNoNansMeanRaw_minus2minus1 = nan(1,8000);
            end
            if isnan(allSubjUnawareNoNansMeanRaw_minus2minus1)
                allSubjUnawareNoNansMeanRaw_minus2minus1 = nan(1,8000);
            end
            if isnan(allSubjMHNoNansMeanRaw_minus2minus1)
                allSubjMHNoNansMeanRaw_minus2minus1 = nan(1,8000);
            end
            if isnan(allSubjMLNoNansMeanRaw_minus2minus1)
                allSubjMLNoNansMeanRaw_minus2minus1 = nan(1,8000);
            end
            
            if allSubjAwareRemove2sTrials == 0
                allSubjAwareRemove2s = nan(2,8000);
            end
            if allSubjUnawareRemove2sTrials == 0
                allSubjUnawareRemove2s = nan(2,8000);
            end
            if allSubjMHRemove2sTrials == 0
                allSubjMHRemove2s = nan(2,8000);
            end
            if allSubjMLRemove2sTrials == 0
                allSubjMLRemove2s = nan(2,8000);
            end
            
            if awaretrials == 0
                allSubjAwareNan2s = nan(2,8000);
            end
            if unawaretrials == 0
                allSubjUnawareNan2s = nan(2,8000);
            end
            if MHtrials == 0
                allSubjMHNan2s = nan(2,8000);
            end
            if MLtrials == 0
                allSubjMLNan2s = nan(2,8000);
            end
            
            if isnan(allSubjAwareNoNansMeanRaw_minus1to0)
                allSubjAwareNoNansMeanRaw_minus1to0 = nan(1,8000);
            end
            if isnan(allSubjUnawareNoNansMeanRaw_minus1to0)
                allSubjUnawareNoNansMeanRaw_minus1to0 = nan(1,8000);
            end
            if isnan(allSubjMHNoNansMeanRaw_minus1to0)
                allSubjMHNoNansMeanRaw_minus1to0 = nan(1,8000);
            end
            if isnan(allSubjMLNoNansMeanRaw_minus1to0)
                allSubjMLNoNansMeanRaw_minus1to0 = nan(1,8000);
            end
            
            if isempty(allSubjAwareRemove2sRaw)
                allSubjAwareRemove2sRaw = nan(2,8000);
            end
            if isempty(allSubjUnawareRemove2sRaw)
                allSubjUnawareRemove2sRaw = nan(2,8000);
            end
            if isempty(allSubjMHRemove2sRaw)
                allSubjMHRemove2sRaw = nan(2,8000);
            end
            if isempty(allSubjMLRemove2sRaw)
                allSubjMLRemove2sRaw = nan(2,8000);
            end
            
            if isnan(allSubjMeanBlinkDurationsAware)
                allSubjMeanBlinkDurationsAware = nan(1,16000);
            end
            if isnan(allSubjMeanBlinkDurationsUnaware)
                allSubjMeanBlinkDurationsUnaware = nan(1,16000);
            end
            if isnan(allSubjMeanBlinkDurationsMH)
                allSubjMeanBlinkDurationsMH = nan(1,16000);
            end
            if isnan(allSubjMeanBlinkDurationsML)
                allSubjMeanBlinkDurationsML = nan(1,16000);
            end
            
            
            
            
            if strcmp(eye,'left')
                for subject = 1:length(all_subj_pupil_data_left)
                    if strcmp(allSubjectNames{session_number},all_subj_pupil_data_left{1,subject})
                        all_subj_pupil_data_left{2,subject} = [all_subj_pupil_data_left{2,subject}; allSubjAwareNoNansMean];
                        all_subj_pupil_data_left{3,subject} = [all_subj_pupil_data_left{3,subject}; allSubjUnawareNoNansMean];
                        all_subj_pupil_data_left{4,subject} = [all_subj_pupil_data_left{4,subject}; allSubjMHNoNansMean];
                        all_subj_pupil_data_left{5,subject} = [all_subj_pupil_data_left{5,subject}; allSubjMLNoNansMean];
                        all_subj_pupil_data_left{6,subject} = [all_subj_pupil_data_left{6,subject} awaretrials];
                        all_subj_pupil_data_left{7,subject} = [all_subj_pupil_data_left{7,subject} unawaretrials];
                        all_subj_pupil_data_left{8,subject} = [all_subj_pupil_data_left{8,subject} MHtrials];
                        all_subj_pupil_data_left{9,subject} = [all_subj_pupil_data_left{9,subject} MLtrials];
                        
                        all_subj_pupil_data_left_raw{2,subject} = [all_subj_pupil_data_left_raw{2,subject}; allSubjAwareNoNansMeanRaw];
                        all_subj_pupil_data_left_raw{3,subject} = [all_subj_pupil_data_left_raw{3,subject}; allSubjUnawareNoNansMeanRaw];
                        all_subj_pupil_data_left_raw{4,subject} = [all_subj_pupil_data_left_raw{4,subject}; allSubjMHNoNansMeanRaw];
                        all_subj_pupil_data_left_raw{5,subject} = [all_subj_pupil_data_left_raw{5,subject}; allSubjMLNoNansMeanRaw];
                        all_subj_pupil_data_left_raw{6,subject} = [all_subj_pupil_data_left_raw{6,subject} awaretrials];
                        all_subj_pupil_data_left_raw{7,subject} = [all_subj_pupil_data_left_raw{7,subject} unawaretrials];
                        all_subj_pupil_data_left_raw{8,subject} = [all_subj_pupil_data_left_raw{8,subject} MHtrials];
                        all_subj_pupil_data_left_raw{9,subject} = [all_subj_pupil_data_left_raw{9,subject} MLtrials];
                        
                        all_subj_sac_data_left{2,subject} = [all_subj_sac_data_left{2,subject}; allSubjAwareSaccadesOnsetRates];
                        all_subj_sac_data_left{3,subject} = [all_subj_sac_data_left{3,subject}; allSubjUnawareSaccadesOnsetRates];
                        all_subj_sac_data_left{4,subject} = [all_subj_sac_data_left{4,subject}; allSubjMHSaccadesOnsetRates];
                        all_subj_sac_data_left{5,subject} = [all_subj_sac_data_left{5,subject}; allSubjMLSaccadesOnsetRates];
                        all_subj_sac_data_left{6,subject} = [all_subj_sac_data_left{6,subject} awaretrials];
                        all_subj_sac_data_left{7,subject} = [all_subj_sac_data_left{7,subject} unawaretrials];
                        all_subj_sac_data_left{8,subject} = [all_subj_sac_data_left{8,subject} MHtrials];
                        all_subj_sac_data_left{9,subject} = [all_subj_sac_data_left{9,subject} MLtrials];

                        all_subj_sac_rate_left{2,subject} = [all_subj_sac_rate_left{2,subject}; allSubjSacRateAware];
                        all_subj_sac_rate_left{3,subject} = [all_subj_sac_rate_left{3,subject}; allSubjSacRateUnaware];
                        all_subj_sac_rate_left{4,subject} = [all_subj_sac_rate_left{4,subject}; allSubjSacRateMH];
                        all_subj_sac_rate_left{5,subject} = [all_subj_sac_rate_left{5,subject}; allSubjSacRateML];
                        all_subj_sac_rate_left{6,subject} = [all_subj_sac_rate_left{6,subject} awaretrials];
                        all_subj_sac_rate_left{7,subject} = [all_subj_sac_rate_left{7,subject} unawaretrials];
                        all_subj_sac_rate_left{8,subject} = [all_subj_sac_rate_left{8,subject} MHtrials];
                        all_subj_sac_rate_left{9,subject} = [all_subj_sac_rate_left{9,subject} MLtrials];
                        
                        all_subj_blink_data_left{2,subject} = [all_subj_blink_data_left{2,subject}; allSubjRegBlinkRateAware];
                        all_subj_blink_data_left{3,subject} = [all_subj_blink_data_left{3,subject}; allSubjRegBlinkRateUnaware];
                        all_subj_blink_data_left{4,subject} = [all_subj_blink_data_left{4,subject}; allSubjRegBlinkRateMH];
                        all_subj_blink_data_left{5,subject} = [all_subj_blink_data_left{5,subject}; allSubjRegBlinkRateML];
                        all_subj_blink_data_left{6,subject} = [all_subj_blink_data_left{6,subject} awaretrials];
                        all_subj_blink_data_left{7,subject} = [all_subj_blink_data_left{7,subject} unawaretrials];
                        all_subj_blink_data_left{8,subject} = [all_subj_blink_data_left{8,subject} MHtrials];
                        all_subj_blink_data_left{9,subject} = [all_subj_blink_data_left{9,subject} MLtrials];
                        
                        all_subj_long_blink_data_left{2,subject} = [all_subj_long_blink_data_left{2,subject}; allSubjLongBlinkRateAware];
                        all_subj_long_blink_data_left{3,subject} = [all_subj_long_blink_data_left{3,subject}; allSubjLongBlinkRateUnaware];
                        all_subj_long_blink_data_left{4,subject} = [all_subj_long_blink_data_left{4,subject}; allSubjLongBlinkRateMH];
                        all_subj_long_blink_data_left{5,subject} = [all_subj_long_blink_data_left{5,subject}; allSubjLongBlinkRateML];
                        all_subj_long_blink_data_left{6,subject} = [all_subj_long_blink_data_left{6,subject} awaretrials];
                        all_subj_long_blink_data_left{7,subject} = [all_subj_long_blink_data_left{7,subject} unawaretrials];
                        all_subj_long_blink_data_left{8,subject} = [all_subj_long_blink_data_left{8,subject} MHtrials];
                        all_subj_long_blink_data_left{9,subject} = [all_subj_long_blink_data_left{9,subject} MLtrials];

                        all_subj_long_blink_data_left_bin{2,subject} = [all_subj_long_blink_data_left_bin{2,subject}; meanBinAwareLongBlinks];
                        all_subj_long_blink_data_left_bin{3,subject} = [all_subj_long_blink_data_left_bin{3,subject}; meanBinUnawareLongBlinks];
                        all_subj_long_blink_data_left_bin{4,subject} = [all_subj_long_blink_data_left_bin{4,subject}; meanBinMHLongBlinks];
                        all_subj_long_blink_data_left_bin{5,subject} = [all_subj_long_blink_data_left_bin{5,subject}; meanBinMLLongBlinks];
                        all_subj_long_blink_data_left_bin{6,subject} = [all_subj_long_blink_data_left_bin{6,subject} awaretrials];
                        all_subj_long_blink_data_left_bin{7,subject} = [all_subj_long_blink_data_left_bin{7,subject} unawaretrials];
                        all_subj_long_blink_data_left_bin{8,subject} = [all_subj_long_blink_data_left_bin{8,subject} MHtrials];
                        all_subj_long_blink_data_left_bin{9,subject} = [all_subj_long_blink_data_left_bin{9,subject} MLtrials];

                        all_subj_sac_duration_data_left{2,subject} = [all_subj_sac_duration_data_left{2,subject}; allSubjMeanSacDurationAware];
                        all_subj_sac_duration_data_left{3,subject} = [all_subj_sac_duration_data_left{3,subject}; allSubjMeanSacDurationUnaware];
                        all_subj_sac_duration_data_left{4,subject} = [all_subj_sac_duration_data_left{4,subject}; allSubjMeanSacDurationMH];
                        all_subj_sac_duration_data_left{5,subject} = [all_subj_sac_duration_data_left{5,subject}; allSubjMeanSacDurationML];
                        all_subj_sac_duration_data_left{6,subject} = [all_subj_sac_duration_data_left{6,subject} awaretrials];
                        all_subj_sac_duration_data_left{7,subject} = [all_subj_sac_duration_data_left{7,subject} unawaretrials];
                        all_subj_sac_duration_data_left{8,subject} = [all_subj_sac_duration_data_left{8,subject} MHtrials];
                        all_subj_sac_duration_data_left{9,subject} = [all_subj_sac_duration_data_left{9,subject} MLtrials];
                        
                        all_subj_blink_duration_data_left{2,subject} = [all_subj_blink_duration_data_left{2,subject}; allSubjMeanBlinkDurationsAware];
                        all_subj_blink_duration_data_left{3,subject} = [all_subj_blink_duration_data_left{3,subject}; allSubjMeanBlinkDurationsUnaware];
                        all_subj_blink_duration_data_left{4,subject} = [all_subj_blink_duration_data_left{4,subject}; allSubjMeanBlinkDurationsMH];
                        all_subj_blink_duration_data_left{5,subject} = [all_subj_blink_duration_data_left{5,subject}; allSubjMeanBlinkDurationsML];
                        all_subj_blink_duration_data_left{6,subject} = [all_subj_blink_duration_data_left{6,subject} awaretrials];
                        all_subj_blink_duration_data_left{7,subject} = [all_subj_blink_duration_data_left{7,subject} unawaretrials];
                        all_subj_blink_duration_data_left{8,subject} = [all_subj_blink_duration_data_left{8,subject} MHtrials];
                        all_subj_blink_duration_data_left{9,subject} = [all_subj_blink_duration_data_left{9,subject} MLtrials];
                        
                        all_subj_minus1to0_data_left{2,subject} = [all_subj_minus1to0_data_left{2,subject};  allSubjAwareNoNansMeanRaw_minus1to0];
                        all_subj_minus1to0_data_left{3,subject} = [all_subj_minus1to0_data_left{3,subject};  allSubjUnawareNoNansMeanRaw_minus1to0];
                        all_subj_minus1to0_data_left{4,subject} = [all_subj_minus1to0_data_left{4,subject};  allSubjMHNoNansMeanRaw_minus1to0];
                        all_subj_minus1to0_data_left{5,subject} = [all_subj_minus1to0_data_left{5,subject};  allSubjMLNoNansMeanRaw_minus1to0];
                        all_subj_minus1to0_data_left{6,subject} = [all_subj_minus1to0_data_left{6,subject} awaretrials];
                        all_subj_minus1to0_data_left{7,subject} = [all_subj_minus1to0_data_left{7,subject} unawaretrials];
                        all_subj_minus1to0_data_left{8,subject} = [all_subj_minus1to0_data_left{8,subject} MHtrials];
                        all_subj_minus1to0_data_left{9,subject} = [all_subj_minus1to0_data_left{9,subject} MLtrials];
                        
                        all_subj_minus2minus1_data_left{2,subject} = [all_subj_minus2minus1_data_left{2,subject};  allSubjAwareNoNansMeanRaw_minus2minus1];
                        all_subj_minus2minus1_data_left{3,subject} = [all_subj_minus2minus1_data_left{3,subject};  allSubjUnawareNoNansMeanRaw_minus2minus1];
                        all_subj_minus2minus1_data_left{4,subject} = [all_subj_minus2minus1_data_left{4,subject};  allSubjMHNoNansMeanRaw_minus2minus1];
                        all_subj_minus2minus1_data_left{5,subject} = [all_subj_minus2minus1_data_left{5,subject};  allSubjMLNoNansMeanRaw_minus2minus1];
                        all_subj_minus2minus1_data_left{6,subject} = [all_subj_minus2minus1_data_left{6,subject} awaretrials];
                        all_subj_minus2minus1_data_left{7,subject} = [all_subj_minus2minus1_data_left{7,subject} unawaretrials];
                        all_subj_minus2minus1_data_left{8,subject} = [all_subj_minus2minus1_data_left{8,subject} MHtrials];
                        all_subj_minus2minus1_data_left{9,subject} = [all_subj_minus2minus1_data_left{9,subject} MLtrials];

                        all_subj_remove2s_data_left{2,subject} = [all_subj_remove2s_data_left{2,subject};  mean(allSubjAwareRemove2s)];
                        all_subj_remove2s_data_left{3,subject} = [all_subj_remove2s_data_left{3,subject};  mean(allSubjUnawareRemove2s)];
                        all_subj_remove2s_data_left{4,subject} = [all_subj_remove2s_data_left{4,subject};  mean(allSubjMHRemove2s)];
                        all_subj_remove2s_data_left{5,subject} = [all_subj_remove2s_data_left{5,subject};  mean(allSubjMLRemove2s)];
                        all_subj_remove2s_data_left{6,subject} = [all_subj_remove2s_data_left{6,subject} allSubjAwareRemove2sTrials];
                        all_subj_remove2s_data_left{7,subject} = [all_subj_remove2s_data_left{7,subject} allSubjUnawareRemove2sTrials];
                        all_subj_remove2s_data_left{8,subject} = [all_subj_remove2s_data_left{8,subject} allSubjMHRemove2sTrials];
                        all_subj_remove2s_data_left{9,subject} = [all_subj_remove2s_data_left{9,subject} allSubjMLRemove2sTrials];
                        
                        all_subj_remove2s_data_left_raw{2,subject} = [all_subj_remove2s_data_left_raw{2,subject};  nanmean(allSubjAwareRemove2sRaw)];
                        all_subj_remove2s_data_left_raw{3,subject} = [all_subj_remove2s_data_left_raw{3,subject};  nanmean(allSubjUnawareRemove2sRaw)];
                        all_subj_remove2s_data_left_raw{4,subject} = [all_subj_remove2s_data_left_raw{4,subject};  nanmean(allSubjMHRemove2sRaw)];
                        all_subj_remove2s_data_left_raw{5,subject} = [all_subj_remove2s_data_left_raw{5,subject};  nanmean(allSubjMLRemove2sRaw)];
                        all_subj_remove2s_data_left_raw{6,subject} = [all_subj_remove2s_data_left_raw{6,subject} allSubjAwareRemove2sTrials];
                        all_subj_remove2s_data_left_raw{7,subject} = [all_subj_remove2s_data_left_raw{7,subject} allSubjUnawareRemove2sTrials];
                        all_subj_remove2s_data_left_raw{8,subject} = [all_subj_remove2s_data_left_raw{8,subject} allSubjMHRemove2sTrials];
                        all_subj_remove2s_data_left_raw{9,subject} = [all_subj_remove2s_data_left_raw{9,subject} allSubjMLRemove2sTrials];

                        all_subj_nan2s_data_left{2,subject} = [all_subj_nan2s_data_left{2,subject};  nanmean(allSubjAwareNan2s)];
                        all_subj_nan2s_data_left{3,subject} = [all_subj_nan2s_data_left{3,subject};  nanmean(allSubjUnawareNan2s)];
                        all_subj_nan2s_data_left{4,subject} = [all_subj_nan2s_data_left{4,subject};  nanmean(allSubjMHNan2s)];
                        all_subj_nan2s_data_left{5,subject} = [all_subj_nan2s_data_left{5,subject}; nanmean(allSubjMLNan2s)];
                        all_subj_nan2s_data_left{6,subject} = [all_subj_nan2s_data_left{6,subject} awaretrials];
                        all_subj_nan2s_data_left{7,subject} = [all_subj_nan2s_data_left{7,subject} unawaretrials];
                        all_subj_nan2s_data_left{8,subject} = [all_subj_nan2s_data_left{8,subject} MHtrials];
                        all_subj_nan2s_data_left{9,subject} = [all_subj_nan2s_data_left{9,subject} MLtrials];
                        
                        all_subj_sac_rate_left_remove2s{2,subject} = [all_subj_sac_rate_left_remove2s{2,subject}; allSubjSacRateAwareRemove2s];
                        all_subj_sac_rate_left_remove2s{3,subject} = [all_subj_sac_rate_left_remove2s{3,subject}; allSubjSacRateUnawareRemove2s];
                        all_subj_sac_rate_left_remove2s{4,subject} = [all_subj_sac_rate_left_remove2s{4,subject}; allSubjSacRateMHRemove2s];
                        all_subj_sac_rate_left_remove2s{5,subject} = [all_subj_sac_rate_left_remove2s{5,subject}; allSubjSacRateMLRemove2s];
                        all_subj_sac_rate_left_remove2s{6,subject} = [all_subj_sac_rate_left_remove2s{6,subject} allSubjAwareRemove2sTrials];
                        all_subj_sac_rate_left_remove2s{7,subject} = [all_subj_sac_rate_left_remove2s{7,subject} allSubjUnawareRemove2sTrials];
                        all_subj_sac_rate_left_remove2s{8,subject} = [all_subj_sac_rate_left_remove2s{8,subject} allSubjMHRemove2sTrials];
                        all_subj_sac_rate_left_remove2s{9,subject} = [all_subj_sac_rate_left_remove2s{9,subject} allSubjMLRemove2sTrials];




                    end
                end
            end
            if strcmp(eye,'right')
                for subject = 1:length(all_subj_pupil_data_right)
                    if strcmp(allSubjectNames{session_number},all_subj_pupil_data_right{1,subject})
                        all_subj_pupil_data_right{2,subject} = [all_subj_pupil_data_right{2,subject}; allSubjAwareNoNansMean];
                        all_subj_pupil_data_right{3,subject} = [all_subj_pupil_data_right{3,subject}; allSubjUnawareNoNansMean];
                        all_subj_pupil_data_right{4,subject} = [all_subj_pupil_data_right{4,subject}; allSubjMHNoNansMean];
                        all_subj_pupil_data_right{5,subject} = [all_subj_pupil_data_right{5,subject}; allSubjMLNoNansMean];
                        all_subj_pupil_data_right{6,subject} = [all_subj_pupil_data_right{6,subject} awaretrials];
                        all_subj_pupil_data_right{7,subject} = [all_subj_pupil_data_right{7,subject} unawaretrials];
                        all_subj_pupil_data_right{8,subject} = [all_subj_pupil_data_right{8,subject} MHtrials];
                        all_subj_pupil_data_right{9,subject} = [all_subj_pupil_data_right{9,subject} MLtrials];
                        
                        all_subj_pupil_data_right_raw{2,subject} = [all_subj_pupil_data_right_raw{2,subject}; allSubjAwareNoNansMeanRaw];
                        all_subj_pupil_data_right_raw{3,subject} = [all_subj_pupil_data_right_raw{3,subject}; allSubjUnawareNoNansMeanRaw];
                        all_subj_pupil_data_right_raw{4,subject} = [all_subj_pupil_data_right_raw{4,subject}; allSubjMHNoNansMeanRaw];
                        all_subj_pupil_data_right_raw{5,subject} = [all_subj_pupil_data_right_raw{5,subject}; allSubjMLNoNansMeanRaw];
                        all_subj_pupil_data_right_raw{6,subject} = [all_subj_pupil_data_right_raw{6,subject} awaretrials];
                        all_subj_pupil_data_right_raw{7,subject} = [all_subj_pupil_data_right_raw{7,subject} unawaretrials];
                        all_subj_pupil_data_right_raw{8,subject} = [all_subj_pupil_data_right_raw{8,subject} MHtrials];
                        all_subj_pupil_data_right_raw{9,subject} = [all_subj_pupil_data_right_raw{9,subject} MLtrials];
                        
                        all_subj_sac_data_right{2,subject} = [all_subj_sac_data_right{2,subject}; allSubjAwareSaccadesOnsetRates];
                        all_subj_sac_data_right{3,subject} = [all_subj_sac_data_right{3,subject}; allSubjUnawareSaccadesOnsetRates];
                        all_subj_sac_data_right{4,subject} = [all_subj_sac_data_right{4,subject}; allSubjMHSaccadesOnsetRates];
                        all_subj_sac_data_right{5,subject} = [all_subj_sac_data_right{5,subject}; allSubjMLSaccadesOnsetRates];
                        all_subj_sac_data_right{6,subject} = [all_subj_sac_data_right{6,subject} awaretrials];
                        all_subj_sac_data_right{7,subject} = [all_subj_sac_data_right{7,subject} unawaretrials];
                        all_subj_sac_data_right{8,subject} = [all_subj_sac_data_right{8,subject} MHtrials];
                        all_subj_sac_data_right{9,subject} = [all_subj_sac_data_right{9,subject} MLtrials];

                        all_subj_sac_rate_right{2,subject} = [all_subj_sac_rate_right{2,subject}; allSubjSacRateAware];
                        all_subj_sac_rate_right{3,subject} = [all_subj_sac_rate_right{3,subject}; allSubjSacRateUnaware];
                        all_subj_sac_rate_right{4,subject} = [all_subj_sac_rate_right{4,subject}; allSubjSacRateMH];
                        all_subj_sac_rate_right{5,subject} = [all_subj_sac_rate_right{5,subject}; allSubjSacRateML];
                        all_subj_sac_rate_right{6,subject} = [all_subj_sac_rate_right{6,subject} awaretrials];
                        all_subj_sac_rate_right{7,subject} = [all_subj_sac_rate_right{7,subject} unawaretrials];
                        all_subj_sac_rate_right{8,subject} = [all_subj_sac_rate_right{8,subject} MHtrials];
                        all_subj_sac_rate_right{9,subject} = [all_subj_sac_rate_right{9,subject} MLtrials];
                        
                        all_subj_blink_data_right{2,subject} = [all_subj_blink_data_right{2,subject}; allSubjRegBlinkRateAware];
                        all_subj_blink_data_right{3,subject} = [all_subj_blink_data_right{3,subject}; allSubjRegBlinkRateUnaware];
                        all_subj_blink_data_right{4,subject} = [all_subj_blink_data_right{4,subject}; allSubjRegBlinkRateMH];
                        all_subj_blink_data_right{5,subject} = [all_subj_blink_data_right{5,subject}; allSubjRegBlinkRateML];
                        all_subj_blink_data_right{6,subject} = [all_subj_blink_data_right{6,subject} awaretrials];
                        all_subj_blink_data_right{7,subject} = [all_subj_blink_data_right{7,subject} unawaretrials];
                        all_subj_blink_data_right{8,subject} = [all_subj_blink_data_right{8,subject} MHtrials];
                        all_subj_blink_data_right{9,subject} = [all_subj_blink_data_right{9,subject} MLtrials];
                        
                        all_subj_long_blink_data_right{2,subject} = [all_subj_long_blink_data_right{2,subject}; allSubjLongBlinkRateAware];
                        all_subj_long_blink_data_right{3,subject} = [all_subj_long_blink_data_right{3,subject}; allSubjLongBlinkRateUnaware];
                        all_subj_long_blink_data_right{4,subject} = [all_subj_long_blink_data_right{4,subject}; allSubjLongBlinkRateMH];
                        all_subj_long_blink_data_right{5,subject} = [all_subj_long_blink_data_right{5,subject}; allSubjLongBlinkRateML];
                        all_subj_long_blink_data_right{6,subject} = [all_subj_long_blink_data_right{6,subject} awaretrials];
                        all_subj_long_blink_data_right{7,subject} = [all_subj_long_blink_data_right{7,subject} unawaretrials];
                        all_subj_long_blink_data_right{8,subject} = [all_subj_long_blink_data_right{8,subject} MHtrials];
                        all_subj_long_blink_data_right{9,subject} = [all_subj_long_blink_data_right{9,subject} MLtrials];

                        all_subj_long_blink_data_right_bin{2,subject} = [all_subj_long_blink_data_right_bin{2,subject}; meanBinAwareLongBlinks];
                        all_subj_long_blink_data_right_bin{3,subject} = [all_subj_long_blink_data_right_bin{3,subject}; meanBinUnawareLongBlinks];
                        all_subj_long_blink_data_right_bin{4,subject} = [all_subj_long_blink_data_right_bin{4,subject}; meanBinMHLongBlinks];
                        all_subj_long_blink_data_right_bin{5,subject} = [all_subj_long_blink_data_right_bin{5,subject}; meanBinMLLongBlinks];
                        all_subj_long_blink_data_right_bin{6,subject} = [all_subj_long_blink_data_right_bin{6,subject} awaretrials];
                        all_subj_long_blink_data_right_bin{7,subject} = [all_subj_long_blink_data_right_bin{7,subject} unawaretrials];
                        all_subj_long_blink_data_right_bin{8,subject} = [all_subj_long_blink_data_right_bin{8,subject} MHtrials];
                        all_subj_long_blink_data_right_bin{9,subject} = [all_subj_long_blink_data_right_bin{9,subject} MLtrials];
                        
                        all_subj_sac_duration_data_right{2,subject} = [all_subj_sac_duration_data_right{2,subject}; allSubjMeanSacDurationAware];
                        all_subj_sac_duration_data_right{3,subject} = [all_subj_sac_duration_data_right{3,subject}; allSubjMeanSacDurationUnaware];
                        all_subj_sac_duration_data_right{4,subject} = [all_subj_sac_duration_data_right{4,subject}; allSubjMeanSacDurationMH];
                        all_subj_sac_duration_data_right{5,subject} = [all_subj_sac_duration_data_right{5,subject}; allSubjMeanSacDurationML];
                        all_subj_sac_duration_data_right{6,subject} = [all_subj_sac_duration_data_right{6,subject} awaretrials];
                        all_subj_sac_duration_data_right{7,subject} = [all_subj_sac_duration_data_right{7,subject} unawaretrials];
                        all_subj_sac_duration_data_right{8,subject} = [all_subj_sac_duration_data_right{8,subject} MHtrials];
                        all_subj_sac_duration_data_right{9,subject} = [all_subj_sac_duration_data_right{9,subject} MLtrials];
                        
                        all_subj_blink_duration_data_right{2,subject} = [all_subj_blink_duration_data_right{2,subject}; allSubjMeanBlinkDurationsAware];
                        all_subj_blink_duration_data_right{3,subject} = [all_subj_blink_duration_data_right{3,subject}; allSubjMeanBlinkDurationsUnaware];
                        all_subj_blink_duration_data_right{4,subject} = [all_subj_blink_duration_data_right{4,subject}; allSubjMeanBlinkDurationsMH];
                        all_subj_blink_duration_data_right{5,subject} = [all_subj_blink_duration_data_right{5,subject}; allSubjMeanBlinkDurationsML];
                        all_subj_blink_duration_data_right{6,subject} = [all_subj_blink_duration_data_right{6,subject} awaretrials];
                        all_subj_blink_duration_data_right{7,subject} = [all_subj_blink_duration_data_right{7,subject} unawaretrials];
                        all_subj_blink_duration_data_right{8,subject} = [all_subj_blink_duration_data_right{8,subject} MHtrials];
                        all_subj_blink_duration_data_right{9,subject} = [all_subj_blink_duration_data_right{9,subject} MLtrials];

                        all_subj_minus1to0_data_right{2,subject} = [all_subj_minus1to0_data_right{2,subject}; allSubjAwareNoNansMeanRaw_minus1to0];
                        all_subj_minus1to0_data_right{3,subject} = [all_subj_minus1to0_data_right{3,subject}; allSubjUnawareNoNansMeanRaw_minus1to0];
                        all_subj_minus1to0_data_right{4,subject} = [all_subj_minus1to0_data_right{4,subject}; allSubjMHNoNansMeanRaw_minus1to0];
                        all_subj_minus1to0_data_right{5,subject} = [all_subj_minus1to0_data_right{5,subject}; allSubjMLNoNansMeanRaw_minus1to0];
                        all_subj_minus1to0_data_right{6,subject} = [all_subj_minus1to0_data_right{6,subject} awaretrials];
                        all_subj_minus1to0_data_right{7,subject} = [all_subj_minus1to0_data_right{7,subject} unawaretrials];
                        all_subj_minus1to0_data_right{8,subject} = [all_subj_minus1to0_data_right{8,subject} MHtrials];
                        all_subj_minus1to0_data_right{9,subject} = [all_subj_minus1to0_data_right{9,subject} MLtrials];

                        all_subj_minus2minus1_data_right{2,subject} = [all_subj_minus2minus1_data_right{2,subject}; allSubjAwareNoNansMeanRaw_minus2minus1];
                        all_subj_minus2minus1_data_right{3,subject} = [all_subj_minus2minus1_data_right{3,subject}; allSubjUnawareNoNansMeanRaw_minus2minus1];
                        all_subj_minus2minus1_data_right{4,subject} = [all_subj_minus2minus1_data_right{4,subject}; allSubjMHNoNansMeanRaw_minus2minus1];
                        all_subj_minus2minus1_data_right{5,subject} = [all_subj_minus2minus1_data_right{5,subject}; allSubjMLNoNansMeanRaw_minus2minus1];
                        all_subj_minus2minus1_data_right{6,subject} = [all_subj_minus2minus1_data_right{6,subject} awaretrials];
                        all_subj_minus2minus1_data_right{7,subject} = [all_subj_minus2minus1_data_right{7,subject} unawaretrials];
                        all_subj_minus2minus1_data_right{8,subject} = [all_subj_minus2minus1_data_right{8,subject} MHtrials];
                        all_subj_minus2minus1_data_right{9,subject} = [all_subj_minus2minus1_data_right{9,subject} MLtrials];

                        all_subj_remove2s_data_right{2,subject} = [all_subj_remove2s_data_right{2,subject};  mean(allSubjAwareRemove2s)];
                        all_subj_remove2s_data_right{3,subject} = [all_subj_remove2s_data_right{3,subject};  mean(allSubjUnawareRemove2s)];
                        all_subj_remove2s_data_right{4,subject} = [all_subj_remove2s_data_right{4,subject};  mean(allSubjMHRemove2s)];
                        all_subj_remove2s_data_right{5,subject} = [all_subj_remove2s_data_right{5,subject};  mean(allSubjMLRemove2s)];
                        all_subj_remove2s_data_right{6,subject} = [all_subj_remove2s_data_right{6,subject} allSubjAwareRemove2sTrials];
                        all_subj_remove2s_data_right{7,subject} = [all_subj_remove2s_data_right{7,subject} allSubjUnawareRemove2sTrials];
                        all_subj_remove2s_data_right{8,subject} = [all_subj_remove2s_data_right{8,subject} allSubjMHRemove2sTrials];
                        all_subj_remove2s_data_right{9,subject} = [all_subj_remove2s_data_right{9,subject} allSubjMLRemove2sTrials];
                        
                        all_subj_remove2s_data_right_raw{2,subject} = [all_subj_remove2s_data_right_raw{2,subject};  nanmean(allSubjAwareRemove2sRaw)];
                        all_subj_remove2s_data_right_raw{3,subject} = [all_subj_remove2s_data_right_raw{3,subject};  nanmean(allSubjUnawareRemove2sRaw)];
                        all_subj_remove2s_data_right_raw{4,subject} = [all_subj_remove2s_data_right_raw{4,subject};  nanmean(allSubjMHRemove2sRaw)];
                        all_subj_remove2s_data_right_raw{5,subject} = [all_subj_remove2s_data_right_raw{5,subject};  nanmean(allSubjMLRemove2sRaw)];
                        all_subj_remove2s_data_right_raw{6,subject} = [all_subj_remove2s_data_right_raw{6,subject} allSubjAwareRemove2sTrials];
                        all_subj_remove2s_data_right_raw{7,subject} = [all_subj_remove2s_data_right_raw{7,subject} allSubjUnawareRemove2sTrials];
                        all_subj_remove2s_data_right_raw{8,subject} = [all_subj_remove2s_data_right_raw{8,subject} allSubjMHRemove2sTrials];
                        all_subj_remove2s_data_right_raw{9,subject} = [all_subj_remove2s_data_right_raw{9,subject} allSubjMLRemove2sTrials];

                        all_subj_nan2s_data_right{2,subject} = [all_subj_nan2s_data_right{2,subject};  nanmean(allSubjAwareNan2s)];
                        all_subj_nan2s_data_right{3,subject} = [all_subj_nan2s_data_right{3,subject};  nanmean(allSubjUnawareNan2s)];
                        all_subj_nan2s_data_right{4,subject} = [all_subj_nan2s_data_right{4,subject};  nanmean(allSubjMHNan2s)];
                        all_subj_nan2s_data_right{5,subject} = [all_subj_nan2s_data_right{5,subject}; nanmean(allSubjMLNan2s)];
                        all_subj_nan2s_data_right{6,subject} = [all_subj_nan2s_data_right{6,subject} awaretrials];
                        all_subj_nan2s_data_right{7,subject} = [all_subj_nan2s_data_right{7,subject} unawaretrials];
                        all_subj_nan2s_data_right{8,subject} = [all_subj_nan2s_data_right{8,subject} MHtrials];
                        all_subj_nan2s_data_right{9,subject} = [all_subj_nan2s_data_right{9,subject} MLtrials];







                    end
                end
            end
        %catch
%             problem_subjs = [problem_subjs; {allSubjectNames{session_number}}];
%             continue
%         end
        toc
    end
end
%% Remove any subject with fewer than 12 unaware or aware trials
all_subj_left_kept = [];
all_subj_right_kept = [];
all_subj_left_kept_raw = [];
all_subj_right_kept_raw = [];
all_subj_sac_left_kept = [];
all_subj_sac_right_kept = [];
all_subj_sac_rate_left_kept = [];
all_subj_sac_rate_right_kept = [];
all_subj_blink_left_kept = [];
all_subj_blink_right_kept = [];
all_subj_long_blink_left_kept = [];
all_subj_long_blink_right_kept = [];
all_subj_long_blink_left_kept_bin = [];
all_subj_long_blink_right_kept_bin = [];
all_subj_sac_duration_left_kept = [];
all_subj_sac_duration_right_kept = [];
all_subj_blink_duration_left_kept = [];
all_subj_blink_duration_right_kept = [];
all_subj_minus1to0_left_kept = [];
all_subj_minus1to0_right_kept = [];
all_subj_minus2minus1_left_kept = [];
all_subj_minus2minus1_right_kept = [];
all_subj_sac_rate_left_kept = [];
all_subj_sac_rate_right_kept = [];
all_subj_remove2s_left_kept = [];
all_subj_remove2s_right_kept = [];
all_subj_nan2s_left_kept = [];
all_subj_nan2s_right_kept = [];
all_subj_remove2s_left_kept_raw = [];
all_subj_remove2s_right_kept_raw = [];
excluded_subj_left = [];
kept_subj_left = [];
for subject = 1:length(all_subj_pupil_data_left)

    if sum(all_subj_pupil_data_left{6,subject}) >= 12 && sum(all_subj_pupil_data_left{7,subject}) >= 12
        all_subj_left_kept = [all_subj_left_kept all_subj_pupil_data_left(:,subject)];
        all_subj_left_kept_raw = [all_subj_left_kept_raw all_subj_pupil_data_left_raw(:,subject)];
        all_subj_sac_left_kept = [all_subj_sac_left_kept all_subj_sac_data_left(:,subject)];
        all_subj_sac_rate_left_kept = [all_subj_sac_rate_left_kept all_subj_sac_rate_left(:,subject)];
        all_subj_blink_left_kept = [all_subj_blink_left_kept all_subj_blink_data_left(:,subject)];
        all_subj_long_blink_left_kept = [all_subj_long_blink_left_kept all_subj_long_blink_data_left(:,subject)];
        all_subj_long_blink_left_kept_bin = [all_subj_long_blink_left_kept_bin all_subj_long_blink_data_left_bin(:,subject)];
        all_subj_sac_duration_left_kept = [all_subj_sac_duration_left_kept all_subj_sac_duration_data_left(:,subject)];
        all_subj_blink_duration_left_kept = [all_subj_blink_duration_left_kept all_subj_blink_duration_data_left(:,subject)];
        all_subj_minus1to0_left_kept = [all_subj_minus1to0_left_kept all_subj_minus1to0_data_left(:,subject)];
        all_subj_minus2minus1_left_kept = [all_subj_minus2minus1_left_kept all_subj_minus2minus1_data_left(:,subject)];
        all_subj_nan2s_left_kept = [all_subj_nan2s_left_kept all_subj_nan2s_data_left(:,subject)];
        currentSubj = all_subj_pupil_data_left(:,subject);
        kept_subj_left = [kept_subj_left currentSubj(1)];

    end
    if sum(all_subj_remove2s_data_left{6,subject}) >= 12 && sum(all_subj_remove2s_data_left{7,subject}) >= 12
        all_subj_remove2s_left_kept = [all_subj_remove2s_left_kept all_subj_remove2s_data_left(:,subject)];
        all_subj_remove2s_left_kept_raw = [all_subj_remove2s_left_kept_raw all_subj_remove2s_data_left_raw(:,subject)];
    end
    if sum(all_subj_pupil_data_left{6,subject}) < 12 && sum(all_subj_pupil_data_left{7,subject}) < 12
        currentSubj = all_subj_pupil_data_left(:,subject);
        excluded_subj_left = [excluded_subj_left currentSubj(1)];
    end
end 
kept_subj_left = unique(kept_subj_left)
        
for subject = 1:length(all_subj_pupil_data_right)

    if sum(all_subj_pupil_data_right{6,subject}) >= 12 && sum(all_subj_pupil_data_right{7,subject}) >= 12
        all_subj_right_kept = [all_subj_right_kept all_subj_pupil_data_right(:,subject)];
        all_subj_right_kept_raw = [all_subj_right_kept_raw all_subj_pupil_data_right_raw(:,subject)];
        all_subj_sac_right_kept = [all_subj_sac_right_kept all_subj_sac_data_right(:,subject)];
        all_subj_sac_rate_right_kept = [all_subj_sac_rate_right_kept all_subj_sac_rate_right(:,subject)];
        all_subj_blink_right_kept = [all_subj_blink_right_kept all_subj_blink_data_right(:,subject)];
        all_subj_long_blink_right_kept = [all_subj_long_blink_right_kept all_subj_long_blink_data_right(:,subject)];
        all_subj_long_blink_right_kept_bin = [all_subj_long_blink_right_kept_bin all_subj_long_blink_data_right_bin(:,subject)];
        all_subj_sac_duration_right_kept = [all_subj_sac_duration_right_kept all_subj_sac_duration_data_right(:,subject)];
        all_subj_blink_duration_right_kept = [all_subj_blink_duration_right_kept all_subj_blink_duration_data_right(:,subject)];

        all_subj_minus1to0_right_kept = [all_subj_minus1to0_right_kept all_subj_minus1to0_data_right(:,subject)];

                all_subj_minus2minus1_right_kept = [all_subj_minus2minus1_right_kept all_subj_minus2minus1_data_right(:,subject)];
                all_subj_nan2s_right_kept = [all_subj_nan2s_right_kept all_subj_nan2s_data_right(:,subject)];

    end
    if sum(all_subj_remove2s_data_right{6,subject}) >= 12 && sum(all_subj_remove2s_data_right{7,subject}) >= 12
        all_subj_remove2s_right_kept = [all_subj_remove2s_right_kept all_subj_remove2s_data_right(:,subject)];
        all_subj_remove2s_right_kept_raw = [all_subj_remove2s_right_kept_raw all_subj_remove2s_data_right_raw(:,subject)];
    end
end

all_avg_pupil_aware_right = [];
all_avg_pupil_aware_left = [];
all_avg_pupil_unaware_right = [];
all_avg_pupil_unaware_left = [];

all_avg_pupil_aware_right_raw = [];
all_avg_pupil_aware_left_raw = [];
all_avg_pupil_unaware_right_raw = [];
all_avg_pupil_unaware_left_raw = [];

all_avg_sac_aware_right = [];
all_avg_sac_aware_left = [];
all_avg_sac_unaware_right = [];
all_avg_sac_unaware_left = [];

all_avg_blink_aware_right = [];
all_avg_blink_aware_left = [];
all_avg_blink_unaware_right = [];
all_avg_blink_unaware_left = [];

all_avg_long_blink_aware_right = [];
all_avg_long_blink_aware_left = [];
all_avg_long_blink_unaware_right = [];
all_avg_long_blink_unaware_left = [];

all_avg_long_blink_aware_right_bin = [];
all_avg_long_blink_aware_left_bin = [];
all_avg_long_blink_unaware_right_bin = [];
all_avg_long_blink_unaware_left_bin = [];

all_avg_sac_duration_aware_right = [];
all_avg_sac_duration_aware_left = [];
all_avg_sac_duration_unaware_right = [];
all_avg_sac_duration_unaware_left = [];

all_avg_blink_duration_aware_right = [];
all_avg_blink_duration_aware_left = [];
all_avg_blink_duration_unaware_right = [];
all_avg_blink_duration_unaware_left = [];

all_avg_sac_rate_aware_right = [];
all_avg_sac_rate_aware_left = [];
all_avg_sac_rate_unaware_right = [];
all_avg_sac_rate_unaware_left = [];

all_avg_minus1to0_aware_right = [];
all_avg_minus1to0_aware_left = [];
all_avg_minus1to0_unaware_right = [];
all_avg_minus1to0_unaware_left = [];

all_avg_minus2minus1_aware_right = [];
all_avg_minus2minus1_aware_left = [];
all_avg_minus2minus1_unaware_right = [];
all_avg_minus2minus1_unaware_left = [];

all_avg_remove2s_aware_right = [];
all_avg_remove2s_aware_left = [];
all_avg_remove2s_unaware_right = [];
all_avg_remove2s_unaware_left = [];

all_avg_remove2s_aware_right_raw = [];
all_avg_remove2s_aware_left_raw = [];
all_avg_remove2s_unaware_right_raw = [];
all_avg_remove2s_unaware_left_raw = [];

all_avg_nan2s_aware_right = [];
all_avg_nan2s_aware_left = [];
all_avg_nan2s_unaware_right = [];
all_avg_nan2s_unaware_left = [];



for subject = 1:length(all_subj_left_kept)
    if size(all_subj_left_kept{5,subject},1) > 1
        all_subj_left_kept{2,subject}(1,:) = all_subj_left_kept{2,subject}(1,:) * all_subj_left_kept{6,subject}(1) / sum(all_subj_left_kept{6,subject});
        all_subj_left_kept{2,subject}(2,:) = all_subj_left_kept{2,subject}(2,:) * all_subj_left_kept{6,subject}(2) / sum(all_subj_left_kept{6,subject});
        all_subj_left_kept{2,subject} = nansum(all_subj_left_kept{2,subject});
        all_avg_pupil_aware_left = [all_avg_pupil_aware_left; all_subj_left_kept{2,subject}];
        
        all_subj_left_kept{3,subject}(1,:) = all_subj_left_kept{3,subject}(1,:) * all_subj_left_kept{7,subject}(1) / sum(all_subj_left_kept{7,subject});
        all_subj_left_kept{3,subject}(2,:) = all_subj_left_kept{3,subject}(2,:) * all_subj_left_kept{7,subject}(2) / sum(all_subj_left_kept{7,subject});
        all_subj_left_kept{3,subject} = nansum(all_subj_left_kept{3,subject});
        all_avg_pupil_unaware_left = [all_avg_pupil_unaware_left; all_subj_left_kept{3,subject}];
        
        all_subj_left_kept{4,subject}(1,:) = all_subj_left_kept{4,subject}(1,:) * all_subj_left_kept{8,subject}(1) / sum(all_subj_left_kept{8,subject});
        all_subj_left_kept{4,subject}(2,:) = all_subj_left_kept{4,subject}(2,:) * all_subj_left_kept{8,subject}(2) / sum(all_subj_left_kept{8,subject});
        all_subj_left_kept{4,subject} = nansum(all_subj_left_kept{4,subject});
        
        all_subj_left_kept{5,subject}(1,:) = all_subj_left_kept{5,subject}(1,:) * all_subj_left_kept{9,subject}(1) / sum(all_subj_left_kept{9,subject});
        all_subj_left_kept{5,subject}(2,:) = all_subj_left_kept{5,subject}(2,:) * all_subj_left_kept{9,subject}(2) / sum(all_subj_left_kept{9,subject});
        all_subj_left_kept{5,subject} = nansum(all_subj_left_kept{5,subject});
        
        %Analyze raw pupil size data
        all_subj_left_kept_raw{2,subject}(1,:) = all_subj_left_kept_raw{2,subject}(1,:) * all_subj_left_kept_raw{6,subject}(1) / sum(all_subj_left_kept_raw{6,subject});
        all_subj_left_kept_raw{2,subject}(2,:) = all_subj_left_kept_raw{2,subject}(2,:) * all_subj_left_kept_raw{6,subject}(2) / sum(all_subj_left_kept_raw{6,subject});
        all_subj_left_kept_raw{2,subject} = nansum(all_subj_left_kept_raw{2,subject});
        all_avg_pupil_aware_left_raw = [all_avg_pupil_aware_left_raw; all_subj_left_kept_raw{2,subject}];
        
        all_subj_left_kept_raw{3,subject}(1,:) = all_subj_left_kept_raw{3,subject}(1,:) * all_subj_left_kept_raw{7,subject}(1) / sum(all_subj_left_kept_raw{7,subject});
        all_subj_left_kept_raw{3,subject}(2,:) = all_subj_left_kept_raw{3,subject}(2,:) * all_subj_left_kept_raw{7,subject}(2) / sum(all_subj_left_kept_raw{7,subject});
        all_subj_left_kept_raw{3,subject} = nansum(all_subj_left_kept_raw{3,subject});
        all_avg_pupil_unaware_left_raw = [all_avg_pupil_unaware_left_raw; all_subj_left_kept_raw{3,subject}];
        
        all_subj_left_kept_raw{4,subject}(1,:) = all_subj_left_kept_raw{4,subject}(1,:) * all_subj_left_kept_raw{8,subject}(1) / sum(all_subj_left_kept_raw{8,subject});
        all_subj_left_kept_raw{4,subject}(2,:) = all_subj_left_kept_raw{4,subject}(2,:) * all_subj_left_kept_raw{8,subject}(2) / sum(all_subj_left_kept_raw{8,subject});
        all_subj_left_kept_raw{4,subject} = nansum(all_subj_left_kept_raw{4,subject});
        
        all_subj_left_kept_raw{5,subject}(1,:) = all_subj_left_kept_raw{5,subject}(1,:) * all_subj_left_kept_raw{9,subject}(1) / sum(all_subj_left_kept_raw{9,subject});
        all_subj_left_kept_raw{5,subject}(2,:) = all_subj_left_kept_raw{5,subject}(2,:) * all_subj_left_kept_raw{9,subject}(2) / sum(all_subj_left_kept_raw{9,subject});
        all_subj_left_kept_raw{5,subject} = nansum(all_subj_left_kept_raw{5,subject});
        
        %Analyze saccade onset data
        all_subj_sac_left_kept{2,subject}(1,:) = all_subj_sac_left_kept{2,subject}(1,:) * all_subj_sac_left_kept{6,subject}(1) / sum(all_subj_sac_left_kept{6,subject});
        all_subj_sac_left_kept{2,subject}(2,:) = all_subj_sac_left_kept{2,subject}(2,:) * all_subj_sac_left_kept{6,subject}(2) / sum(all_subj_sac_left_kept{6,subject});
        all_subj_sac_left_kept{2,subject} = nansum(all_subj_sac_left_kept{2,subject});
        all_avg_sac_aware_left = [all_avg_sac_aware_left; all_subj_sac_left_kept{2,subject}];
        
        all_subj_sac_left_kept{3,subject}(1,:) = all_subj_sac_left_kept{3,subject}(1,:) * all_subj_sac_left_kept{7,subject}(1) / sum(all_subj_sac_left_kept{7,subject});
        all_subj_sac_left_kept{3,subject}(2,:) = all_subj_sac_left_kept{3,subject}(2,:) * all_subj_sac_left_kept{7,subject}(2) / sum(all_subj_sac_left_kept{7,subject});
        all_subj_sac_left_kept{3,subject} = nansum(all_subj_sac_left_kept{3,subject});
        all_avg_sac_unaware_left = [all_avg_sac_unaware_left; all_subj_sac_left_kept{3,subject}];
        
        all_subj_sac_left_kept{4,subject}(1,:) = all_subj_sac_left_kept{4,subject}(1,:) * all_subj_sac_left_kept{8,subject}(1) / sum(all_subj_sac_left_kept{8,subject});
        all_subj_sac_left_kept{4,subject}(2,:) = all_subj_sac_left_kept{4,subject}(2,:) * all_subj_sac_left_kept{8,subject}(2) / sum(all_subj_sac_left_kept{8,subject});
        all_subj_sac_left_kept{4,subject} = nansum(all_subj_sac_left_kept{4,subject});
        
        all_subj_sac_left_kept{5,subject}(1,:) = all_subj_sac_left_kept{5,subject}(1,:) * all_subj_sac_left_kept{9,subject}(1) / sum(all_subj_sac_left_kept{9,subject});
        all_subj_sac_left_kept{5,subject}(2,:) = all_subj_sac_left_kept{5,subject}(2,:) * all_subj_sac_left_kept{9,subject}(2) / sum(all_subj_sac_left_kept{9,subject});
        all_subj_sac_left_kept{5,subject} = nansum(all_subj_sac_left_kept{5,subject});

        %Analyze saccade % data
        all_subj_sac_rate_left_kept{2,subject}(1,:) = all_subj_sac_rate_left_kept{2,subject}(1,:) * all_subj_sac_rate_left_kept{6,subject}(1) / sum(all_subj_sac_rate_left_kept{6,subject});
        all_subj_sac_rate_left_kept{2,subject}(2,:) = all_subj_sac_rate_left_kept{2,subject}(2,:) * all_subj_sac_rate_left_kept{6,subject}(2) / sum(all_subj_sac_rate_left_kept{6,subject});
        all_subj_sac_rate_left_kept{2,subject} = nansum(all_subj_sac_rate_left_kept{2,subject});
        all_avg_sac_rate_aware_left = [all_avg_sac_rate_aware_left; all_subj_sac_rate_left_kept{2,subject}];
        
        all_subj_sac_rate_left_kept{3,subject}(1,:) = all_subj_sac_rate_left_kept{3,subject}(1,:) * all_subj_sac_rate_left_kept{7,subject}(1) / sum(all_subj_sac_rate_left_kept{7,subject});
        all_subj_sac_rate_left_kept{3,subject}(2,:) = all_subj_sac_rate_left_kept{3,subject}(2,:) * all_subj_sac_rate_left_kept{7,subject}(2) / sum(all_subj_sac_rate_left_kept{7,subject});
        all_subj_sac_rate_left_kept{3,subject} = nansum(all_subj_sac_rate_left_kept{3,subject});
        all_avg_sac_rate_unaware_left = [all_avg_sac_rate_unaware_left; all_subj_sac_rate_left_kept{3,subject}];
        
        all_subj_sac_rate_left_kept{4,subject}(1,:) = all_subj_sac_rate_left_kept{4,subject}(1,:) * all_subj_sac_rate_left_kept{8,subject}(1) / sum(all_subj_sac_rate_left_kept{8,subject});
        all_subj_sac_rate_left_kept{4,subject}(2,:) = all_subj_sac_rate_left_kept{4,subject}(2,:) * all_subj_sac_rate_left_kept{8,subject}(2) / sum(all_subj_sac_rate_left_kept{8,subject});
        all_subj_sac_rate_left_kept{4,subject} = nansum(all_subj_sac_rate_left_kept{4,subject});
        
        all_subj_sac_rate_left_kept{5,subject}(1,:) = all_subj_sac_rate_left_kept{5,subject}(1,:) * all_subj_sac_rate_left_kept{9,subject}(1) / sum(all_subj_sac_rate_left_kept{9,subject});
        all_subj_sac_rate_left_kept{5,subject}(2,:) = all_subj_sac_rate_left_kept{5,subject}(2,:) * all_subj_sac_rate_left_kept{9,subject}(2) / sum(all_subj_sac_rate_left_kept{9,subject});
        all_subj_sac_rate_left_kept{5,subject} = nansum(all_subj_sac_rate_left_kept{5,subject});
        
        %Analyze blink % data
        all_subj_blink_left_kept{2,subject}(1,:) = all_subj_blink_left_kept{2,subject}(1,:) * all_subj_blink_left_kept{6,subject}(1) / sum(all_subj_blink_left_kept{6,subject});
        all_subj_blink_left_kept{2,subject}(2,:) = all_subj_blink_left_kept{2,subject}(2,:) * all_subj_blink_left_kept{6,subject}(2) / sum(all_subj_blink_left_kept{6,subject});
        all_subj_blink_left_kept{2,subject} = nansum(all_subj_blink_left_kept{2,subject});
        all_avg_blink_aware_left = [all_avg_blink_aware_left; all_subj_blink_left_kept{2,subject}];
        
        all_subj_blink_left_kept{3,subject}(1,:) = all_subj_blink_left_kept{3,subject}(1,:) * all_subj_blink_left_kept{7,subject}(1) / sum(all_subj_blink_left_kept{7,subject});
        all_subj_blink_left_kept{3,subject}(2,:) = all_subj_blink_left_kept{3,subject}(2,:) * all_subj_blink_left_kept{7,subject}(2) / sum(all_subj_blink_left_kept{7,subject});
        all_subj_blink_left_kept{3,subject} = nansum(all_subj_blink_left_kept{3,subject});
        all_avg_blink_unaware_left = [all_avg_blink_unaware_left; all_subj_blink_left_kept{3,subject}];
        
        all_subj_blink_left_kept{4,subject}(1,:) = all_subj_blink_left_kept{4,subject}(1,:) * all_subj_blink_left_kept{8,subject}(1) / sum(all_subj_blink_left_kept{8,subject});
        all_subj_blink_left_kept{4,subject}(2,:) = all_subj_blink_left_kept{4,subject}(2,:) * all_subj_blink_left_kept{8,subject}(2) / sum(all_subj_blink_left_kept{8,subject});
        all_subj_blink_left_kept{4,subject} = nansum(all_subj_blink_left_kept{4,subject});
        
        all_subj_blink_left_kept{5,subject}(1,:) = all_subj_blink_left_kept{5,subject}(1,:) * all_subj_blink_left_kept{9,subject}(1) / sum(all_subj_blink_left_kept{9,subject});
        all_subj_blink_left_kept{5,subject}(2,:) = all_subj_blink_left_kept{5,subject}(2,:) * all_subj_blink_left_kept{9,subject}(2) / sum(all_subj_blink_left_kept{9,subject});
        all_subj_blink_left_kept{5,subject} = nansum(all_subj_blink_left_kept{5,subject});
        
        %Analyze long blink % data
        all_subj_long_blink_left_kept{2,subject}(1,:) = all_subj_long_blink_left_kept{2,subject}(1,:) * all_subj_long_blink_left_kept{6,subject}(1) / sum(all_subj_long_blink_left_kept{6,subject});
        all_subj_long_blink_left_kept{2,subject}(2,:) = all_subj_long_blink_left_kept{2,subject}(2,:) * all_subj_long_blink_left_kept{6,subject}(2) / sum(all_subj_long_blink_left_kept{6,subject});
        all_subj_long_blink_left_kept{2,subject} = nansum(all_subj_long_blink_left_kept{2,subject});
        all_avg_long_blink_aware_left = [all_avg_long_blink_aware_left; all_subj_long_blink_left_kept{2,subject}];
        
        all_subj_long_blink_left_kept{3,subject}(1,:) = all_subj_long_blink_left_kept{3,subject}(1,:) * all_subj_long_blink_left_kept{7,subject}(1) / sum(all_subj_long_blink_left_kept{7,subject});
        all_subj_long_blink_left_kept{3,subject}(2,:) = all_subj_long_blink_left_kept{3,subject}(2,:) * all_subj_long_blink_left_kept{7,subject}(2) / sum(all_subj_long_blink_left_kept{7,subject});
        all_subj_long_blink_left_kept{3,subject} = nansum(all_subj_long_blink_left_kept{3,subject});
        all_avg_long_blink_unaware_left = [all_avg_long_blink_unaware_left; all_subj_long_blink_left_kept{3,subject}];
        
        all_subj_long_blink_left_kept{4,subject}(1,:) = all_subj_long_blink_left_kept{4,subject}(1,:) * all_subj_long_blink_left_kept{8,subject}(1) / sum(all_subj_long_blink_left_kept{8,subject});
        all_subj_long_blink_left_kept{4,subject}(2,:) = all_subj_long_blink_left_kept{4,subject}(2,:) * all_subj_long_blink_left_kept{8,subject}(2) / sum(all_subj_long_blink_left_kept{8,subject});
        all_subj_long_blink_left_kept{4,subject} = nansum(all_subj_long_blink_left_kept{4,subject});
        
        all_subj_long_blink_left_kept{5,subject}(1,:) = all_subj_long_blink_left_kept{5,subject}(1,:) * all_subj_long_blink_left_kept{9,subject}(1) / sum(all_subj_long_blink_left_kept{9,subject});
        all_subj_long_blink_left_kept{5,subject}(2,:) = all_subj_long_blink_left_kept{5,subject}(2,:) * all_subj_long_blink_left_kept{9,subject}(2) / sum(all_subj_long_blink_left_kept{9,subject});
        all_subj_long_blink_left_kept{5,subject} = nansum(all_subj_long_blink_left_kept{5,subject});
        
        %Analyze binned long blink data
        all_subj_long_blink_left_kept_bin{2,subject}(1,:) = all_subj_long_blink_left_kept_bin{2,subject}(1,:) * all_subj_long_blink_left_kept_bin{6,subject}(1) / sum(all_subj_long_blink_left_kept_bin{6,subject});
        all_subj_long_blink_left_kept_bin{2,subject}(2,:) = all_subj_long_blink_left_kept_bin{2,subject}(2,:) * all_subj_long_blink_left_kept_bin{6,subject}(2) / sum(all_subj_long_blink_left_kept_bin{6,subject});
        all_subj_long_blink_left_kept_bin{2,subject} = nansum(all_subj_long_blink_left_kept_bin{2,subject});
        all_avg_long_blink_aware_left_bin = [all_avg_long_blink_aware_left_bin; all_subj_long_blink_left_kept_bin{2,subject}];
        
        all_subj_long_blink_left_kept_bin{3,subject}(1,:) = all_subj_long_blink_left_kept_bin{3,subject}(1,:) * all_subj_long_blink_left_kept_bin{7,subject}(1) / sum(all_subj_long_blink_left_kept_bin{7,subject});
        all_subj_long_blink_left_kept_bin{3,subject}(2,:) = all_subj_long_blink_left_kept_bin{3,subject}(2,:) * all_subj_long_blink_left_kept_bin{7,subject}(2) / sum(all_subj_long_blink_left_kept_bin{7,subject});
        all_subj_long_blink_left_kept_bin{3,subject} = nansum(all_subj_long_blink_left_kept_bin{3,subject});
        all_avg_long_blink_unaware_left_bin = [all_avg_long_blink_unaware_left_bin; all_subj_long_blink_left_kept_bin{3,subject}];

        all_subj_long_blink_left_kept_bin{4,subject}(1,:) = all_subj_long_blink_left_kept_bin{4,subject}(1,:) * all_subj_long_blink_left_kept_bin{8,subject}(1) / sum(all_subj_long_blink_left_kept_bin{8,subject});
        all_subj_long_blink_left_kept_bin{4,subject}(2,:) = all_subj_long_blink_left_kept_bin{4,subject}(2,:) * all_subj_long_blink_left_kept_bin{8,subject}(2) / sum(all_subj_long_blink_left_kept_bin{8,subject});
        all_subj_long_blink_left_kept_bin{4,subject} = nansum(all_subj_long_blink_left_kept_bin{4,subject});
        
        all_subj_long_blink_left_kept_bin{5,subject}(1,:) = all_subj_long_blink_left_kept_bin{5,subject}(1,:) * all_subj_long_blink_left_kept_bin{9,subject}(1) / sum(all_subj_long_blink_left_kept_bin{9,subject});
        all_subj_long_blink_left_kept_bin{5,subject}(2,:) = all_subj_long_blink_left_kept_bin{5,subject}(2,:) * all_subj_long_blink_left_kept_bin{9,subject}(2) / sum(all_subj_long_blink_left_kept_bin{9,subject});
        all_subj_long_blink_left_kept_bin{5,subject} = nansum(all_subj_long_blink_left_kept_bin{5,subject});
        
        %Analyze saccade duration data
        all_subj_sac_duration_left_kept{2,subject}(1,:) = all_subj_sac_duration_left_kept{2,subject}(1,:) * all_subj_sac_duration_left_kept{6,subject}(1) / sum(all_subj_sac_duration_left_kept{6,subject});
        all_subj_sac_duration_left_kept{2,subject}(2,:) = all_subj_sac_duration_left_kept{2,subject}(2,:) * all_subj_sac_duration_left_kept{6,subject}(2) / sum(all_subj_sac_duration_left_kept{6,subject});
        all_subj_sac_duration_left_kept{2,subject} = nansum(all_subj_sac_duration_left_kept{2,subject});
        all_avg_sac_duration_aware_left = [all_avg_sac_duration_aware_left; all_subj_sac_duration_left_kept{2,subject}];
        
        all_subj_sac_duration_left_kept{3,subject}(1,:) = all_subj_sac_duration_left_kept{3,subject}(1,:) * all_subj_sac_duration_left_kept{7,subject}(1) / sum(all_subj_sac_duration_left_kept{7,subject});
        all_subj_sac_duration_left_kept{3,subject}(2,:) = all_subj_sac_duration_left_kept{3,subject}(2,:) * all_subj_sac_duration_left_kept{7,subject}(2) / sum(all_subj_sac_duration_left_kept{7,subject});
        all_subj_sac_duration_left_kept{3,subject} = nansum(all_subj_sac_duration_left_kept{3,subject});
        all_avg_sac_duration_unaware_left = [all_avg_sac_duration_unaware_left; all_subj_sac_duration_left_kept{3,subject}];
        
        all_subj_sac_duration_left_kept{4,subject}(1,:) = all_subj_sac_duration_left_kept{4,subject}(1,:) * all_subj_sac_duration_left_kept{8,subject}(1) / sum(all_subj_sac_duration_left_kept{8,subject});
        all_subj_sac_duration_left_kept{4,subject}(2,:) = all_subj_sac_duration_left_kept{4,subject}(2,:) * all_subj_sac_duration_left_kept{8,subject}(2) / sum(all_subj_sac_duration_left_kept{8,subject});
        all_subj_sac_duration_left_kept{4,subject} = nansum(all_subj_sac_duration_left_kept{4,subject});
        
        all_subj_sac_duration_left_kept{5,subject}(1,:) = all_subj_sac_duration_left_kept{5,subject}(1,:) * all_subj_sac_duration_left_kept{9,subject}(1) / sum(all_subj_sac_duration_left_kept{9,subject});
        all_subj_sac_duration_left_kept{5,subject}(2,:) = all_subj_sac_duration_left_kept{5,subject}(2,:) * all_subj_sac_duration_left_kept{9,subject}(2) / sum(all_subj_sac_duration_left_kept{9,subject});
        all_subj_sac_duration_left_kept{5,subject} = nansum(all_subj_sac_duration_left_kept{5,subject});
        

        %Analyze blink duration data
        all_subj_blink_duration_left_kept{2,subject}(1,:) = all_subj_blink_duration_left_kept{2,subject}(1,:) * all_subj_blink_duration_left_kept{6,subject}(1) / sum(all_subj_blink_duration_left_kept{6,subject});
        all_subj_blink_duration_left_kept{2,subject}(2,:) = all_subj_blink_duration_left_kept{2,subject}(2,:) * all_subj_blink_duration_left_kept{6,subject}(2) / sum(all_subj_blink_duration_left_kept{6,subject});
        all_subj_blink_duration_left_kept{2,subject} = nansum(all_subj_blink_duration_left_kept{2,subject});
        all_avg_blink_duration_aware_left = [all_avg_blink_duration_aware_left; all_subj_blink_duration_left_kept{2,subject}];
        
        all_subj_blink_duration_left_kept{3,subject}(1,:) = all_subj_blink_duration_left_kept{3,subject}(1,:) * all_subj_blink_duration_left_kept{7,subject}(1) / sum(all_subj_blink_duration_left_kept{7,subject});
        all_subj_blink_duration_left_kept{3,subject}(2,:) = all_subj_blink_duration_left_kept{3,subject}(2,:) * all_subj_blink_duration_left_kept{7,subject}(2) / sum(all_subj_blink_duration_left_kept{7,subject});
        all_subj_blink_duration_left_kept{3,subject} = nansum(all_subj_blink_duration_left_kept{3,subject});
        all_avg_blink_duration_unaware_left = [all_avg_blink_duration_unaware_left; all_subj_blink_duration_left_kept{3,subject}];
        
        all_subj_blink_duration_left_kept{4,subject}(1,:) = all_subj_blink_duration_left_kept{4,subject}(1,:) * all_subj_blink_duration_left_kept{8,subject}(1) / sum(all_subj_blink_duration_left_kept{8,subject});
        all_subj_blink_duration_left_kept{4,subject}(2,:) = all_subj_blink_duration_left_kept{4,subject}(2,:) * all_subj_blink_duration_left_kept{8,subject}(2) / sum(all_subj_blink_duration_left_kept{8,subject});
        all_subj_blink_duration_left_kept{4,subject} = nansum(all_subj_blink_duration_left_kept{4,subject});
        
        all_subj_blink_duration_left_kept{5,subject}(1,:) = all_subj_blink_duration_left_kept{5,subject}(1,:) * all_subj_blink_duration_left_kept{9,subject}(1) / sum(all_subj_blink_duration_left_kept{9,subject});
        all_subj_blink_duration_left_kept{5,subject}(2,:) = all_subj_blink_duration_left_kept{5,subject}(2,:) * all_subj_blink_duration_left_kept{9,subject}(2) / sum(all_subj_blink_duration_left_kept{9,subject});
        all_subj_blink_duration_left_kept{5,subject} = nansum(all_subj_blink_duration_left_kept{5,subject});
        
         %Analyze raw pupil
        all_subj_minus1to0_left_kept{2,subject}(1,:) = all_subj_minus1to0_left_kept{2,subject}(1,:) * all_subj_minus1to0_left_kept{6,subject}(1) / sum(all_subj_minus1to0_left_kept{6,subject});
        all_subj_minus1to0_left_kept{2,subject}(2,:) = all_subj_minus1to0_left_kept{2,subject}(2,:) * all_subj_minus1to0_left_kept{6,subject}(2) / sum(all_subj_minus1to0_left_kept{6,subject});
        all_subj_minus1to0_left_kept{2,subject} = nansum(all_subj_minus1to0_left_kept{2,subject});
        all_avg_minus1to0_aware_left = [all_avg_minus1to0_aware_left; all_subj_minus1to0_left_kept{2,subject}];

        all_subj_minus1to0_left_kept{3,subject}(1,:) = all_subj_minus1to0_left_kept{3,subject}(1,:) * all_subj_minus1to0_left_kept{7,subject}(1) / sum(all_subj_minus1to0_left_kept{7,subject});
        all_subj_minus1to0_left_kept{3,subject}(2,:) = all_subj_minus1to0_left_kept{3,subject}(2,:) * all_subj_minus1to0_left_kept{7,subject}(2) / sum(all_subj_minus1to0_left_kept{7,subject});
        all_subj_minus1to0_left_kept{3,subject} = nansum(all_subj_minus1to0_left_kept{3,subject});
        all_avg_minus1to0_unaware_left = [all_avg_minus1to0_unaware_left; all_subj_minus1to0_left_kept{3,subject}];

        all_subj_minus1to0_left_kept{4,subject}(1,:) = all_subj_minus1to0_left_kept{4,subject}(1,:) * all_subj_minus1to0_left_kept{8,subject}(1) / sum(all_subj_minus1to0_left_kept{8,subject});
        all_subj_minus1to0_left_kept{4,subject}(2,:) = all_subj_minus1to0_left_kept{4,subject}(2,:) * all_subj_minus1to0_left_kept{8,subject}(2) / sum(all_subj_minus1to0_left_kept{8,subject});
        all_subj_minus1to0_left_kept{4,subject} = nansum(all_subj_minus1to0_left_kept{4,subject});

        all_subj_minus1to0_left_kept{5,subject}(1,:) = all_subj_minus1to0_left_kept{5,subject}(1,:) * all_subj_minus1to0_left_kept{9,subject}(1) / sum(all_subj_minus1to0_left_kept{9,subject});
        all_subj_minus1to0_left_kept{5,subject}(2,:) = all_subj_minus1to0_left_kept{5,subject}(2,:) * all_subj_minus1to0_left_kept{9,subject}(2) / sum(all_subj_minus1to0_left_kept{9,subject});
        all_subj_minus1to0_left_kept{5,subject} = nansum(all_subj_minus1to0_left_kept{5,subject});
        
         %Analyze raw pupil -2 to -1 baseline
        all_subj_minus2minus1_left_kept{2,subject}(1,:) = all_subj_minus2minus1_left_kept{2,subject}(1,:) * all_subj_minus2minus1_left_kept{6,subject}(1) / sum(all_subj_minus2minus1_left_kept{6,subject});
        all_subj_minus2minus1_left_kept{2,subject}(2,:) = all_subj_minus2minus1_left_kept{2,subject}(2,:) * all_subj_minus2minus1_left_kept{6,subject}(2) / sum(all_subj_minus2minus1_left_kept{6,subject});
        all_subj_minus2minus1_left_kept{2,subject} = nansum(all_subj_minus2minus1_left_kept{2,subject});
        all_avg_minus2minus1_aware_left = [all_avg_minus2minus1_aware_left; all_subj_minus2minus1_left_kept{2,subject}];

        all_subj_minus2minus1_left_kept{3,subject}(1,:) = all_subj_minus2minus1_left_kept{3,subject}(1,:) * all_subj_minus2minus1_left_kept{7,subject}(1) / sum(all_subj_minus2minus1_left_kept{7,subject});
        all_subj_minus2minus1_left_kept{3,subject}(2,:) = all_subj_minus2minus1_left_kept{3,subject}(2,:) * all_subj_minus2minus1_left_kept{7,subject}(2) / sum(all_subj_minus2minus1_left_kept{7,subject});
        all_subj_minus2minus1_left_kept{3,subject} = nansum(all_subj_minus2minus1_left_kept{3,subject});
        all_avg_minus2minus1_unaware_left = [all_avg_minus2minus1_unaware_left; all_subj_minus2minus1_left_kept{3,subject}];

        all_subj_minus2minus1_left_kept{4,subject}(1,:) = all_subj_minus2minus1_left_kept{4,subject}(1,:) * all_subj_minus2minus1_left_kept{8,subject}(1) / sum(all_subj_minus2minus1_left_kept{8,subject});
        all_subj_minus2minus1_left_kept{4,subject}(2,:) = all_subj_minus2minus1_left_kept{4,subject}(2,:) * all_subj_minus2minus1_left_kept{8,subject}(2) / sum(all_subj_minus2minus1_left_kept{8,subject});
        all_subj_minus2minus1_left_kept{4,subject} = nansum(all_subj_minus2minus1_left_kept{4,subject});

        all_subj_minus2minus1_left_kept{5,subject}(1,:) = all_subj_minus2minus1_left_kept{5,subject}(1,:) * all_subj_minus2minus1_left_kept{9,subject}(1) / sum(all_subj_minus2minus1_left_kept{9,subject});
        all_subj_minus2minus1_left_kept{5,subject}(2,:) = all_subj_minus2minus1_left_kept{5,subject}(2,:) * all_subj_minus2minus1_left_kept{9,subject}(2) / sum(all_subj_minus2minus1_left_kept{9,subject});
        all_subj_minus2minus1_left_kept{5,subject} = nansum(all_subj_minus2minus1_left_kept{5,subject});

        %Analyze nanned trials 2s and beyond for trials of only 2s
        all_subj_nan2s_left_kept{2,subject}(1,:) = all_subj_nan2s_left_kept{2,subject}(1,:) * all_subj_nan2s_left_kept{6,subject}(1) / sum(all_subj_nan2s_left_kept{6,subject});
        all_subj_nan2s_left_kept{2,subject}(2,:) = all_subj_nan2s_left_kept{2,subject}(2,:) * all_subj_nan2s_left_kept{6,subject}(2) / sum(all_subj_nan2s_left_kept{6,subject});
        all_subj_nan2s_left_kept{2,subject} = nansum(all_subj_nan2s_left_kept{2,subject});
        all_avg_nan2s_aware_left = [all_avg_nan2s_aware_left; all_subj_nan2s_left_kept{2,subject}];

        all_subj_nan2s_left_kept{3,subject}(1,:) = all_subj_nan2s_left_kept{3,subject}(1,:) * all_subj_nan2s_left_kept{7,subject}(1) / sum(all_subj_nan2s_left_kept{7,subject});
        all_subj_nan2s_left_kept{3,subject}(2,:) = all_subj_nan2s_left_kept{3,subject}(2,:) * all_subj_nan2s_left_kept{7,subject}(2) / sum(all_subj_nan2s_left_kept{7,subject});
        all_subj_nan2s_left_kept{3,subject} = nansum(all_subj_nan2s_left_kept{3,subject});
        all_avg_nan2s_unaware_left = [all_avg_nan2s_unaware_left; all_subj_nan2s_left_kept{3,subject}];

        all_subj_nan2s_left_kept{4,subject}(1,:) = all_subj_nan2s_left_kept{4,subject}(1,:) * all_subj_nan2s_left_kept{8,subject}(1) / sum(all_subj_nan2s_left_kept{8,subject});
        all_subj_nan2s_left_kept{4,subject}(2,:) = all_subj_nan2s_left_kept{4,subject}(2,:) * all_subj_nan2s_left_kept{8,subject}(2) / sum(all_subj_nan2s_left_kept{8,subject});
        all_subj_nan2s_left_kept{4,subject} = nansum(all_subj_nan2s_left_kept{4,subject});

        all_subj_nan2s_left_kept{5,subject}(1,:) = all_subj_nan2s_left_kept{5,subject}(1,:) * all_subj_nan2s_left_kept{9,subject}(1) / sum(all_subj_nan2s_left_kept{9,subject});
        all_subj_nan2s_left_kept{5,subject}(2,:) = all_subj_nan2s_left_kept{5,subject}(2,:) * all_subj_nan2s_left_kept{9,subject}(2) / sum(all_subj_nan2s_left_kept{9,subject});
        all_subj_nan2s_left_kept{5,subject} = nansum(all_subj_nan2s_left_kept{5,subject});
        


    end
    if length(all_subj_left_kept{6,subject}) == 1
        all_avg_pupil_aware_left = [all_avg_pupil_aware_left; all_subj_left_kept{2,subject}];
        all_avg_pupil_unaware_left = [all_avg_pupil_unaware_left; all_subj_left_kept{3,subject}];
        
        all_avg_pupil_aware_left_raw = [all_avg_pupil_aware_left_raw; all_subj_left_kept_raw{2,subject}];
        all_avg_pupil_unaware_left_raw = [all_avg_pupil_unaware_left_raw; all_subj_left_kept_raw{3,subject}];
        
        all_avg_sac_aware_left = [all_avg_sac_aware_left; all_subj_sac_left_kept{2,subject}];
        all_avg_sac_unaware_left = [all_avg_sac_unaware_left; all_subj_sac_left_kept{3,subject}];

        all_avg_sac_rate_aware_left = [all_avg_sac_rate_aware_left; all_subj_sac_rate_left_kept{2,subject}];
        all_avg_sac_rate_unaware_left = [all_avg_sac_rate_unaware_left; all_subj_sac_rate_left_kept{3,subject}];
        
        all_avg_blink_aware_left = [all_avg_blink_aware_left; all_subj_blink_left_kept{2,subject}];
        all_avg_blink_unaware_left = [all_avg_blink_unaware_left; all_subj_blink_left_kept{3,subject}];
        
        all_avg_long_blink_aware_left = [all_avg_long_blink_aware_left; all_subj_long_blink_left_kept{2,subject}];
        all_avg_long_blink_unaware_left = [all_avg_long_blink_unaware_left; all_subj_long_blink_left_kept{3,subject}];

        all_avg_long_blink_aware_left_bin = [all_avg_long_blink_aware_left_bin; all_subj_long_blink_left_kept_bin{2,subject}];
        all_avg_long_blink_unaware_left_bin = [all_avg_long_blink_unaware_left_bin; all_subj_long_blink_left_kept_bin{3,subject}];
        
        all_avg_sac_duration_aware_left = [all_avg_sac_duration_aware_left; all_subj_sac_duration_left_kept{2,subject}];
        all_avg_sac_duration_unaware_left = [all_avg_sac_duration_unaware_left; all_subj_sac_duration_left_kept{3,subject}];
        
        all_avg_blink_duration_aware_left = [all_avg_blink_duration_aware_left; all_subj_blink_duration_left_kept{2,subject}];
        all_avg_blink_duration_unaware_left = [all_avg_blink_duration_unaware_left; all_subj_blink_duration_left_kept{3,subject}];
        
        all_avg_minus1to0_aware_left = [all_avg_minus1to0_aware_left; all_subj_minus1to0_left_kept{2,subject}];
        all_avg_minus1to0_unaware_left = [all_avg_minus1to0_unaware_left; all_subj_minus1to0_left_kept{3,subject}];

        all_avg_minus2minus1_aware_left = [all_avg_minus2minus1_aware_left; all_subj_minus2minus1_left_kept{2,subject}];
        all_avg_minus2minus1_unaware_left = [all_avg_minus2minus1_unaware_left; all_subj_minus2minus1_left_kept{3,subject}];

        all_avg_nan2s_aware_left = [all_avg_nan2s_aware_left; all_subj_nan2s_left_kept{2,subject}];
        all_avg_nan2s_unaware_left = [all_avg_nan2s_unaware_left; all_subj_nan2s_left_kept{3,subject}];

    end
end
for subject = 1:length(all_subj_remove2s_left_kept)
    if size(all_subj_remove2s_left_kept{5,subject},1) > 1
        %try
                %Analyze with 2s trials removed
                all_subj_remove2s_left_kept{2,subject}(1,:) = all_subj_remove2s_left_kept{2,subject}(1,:) * all_subj_remove2s_left_kept{6,subject}(1) / sum(all_subj_remove2s_left_kept{6,subject});
                all_subj_remove2s_left_kept{2,subject}(2,:) = all_subj_remove2s_left_kept{2,subject}(2,:) * all_subj_remove2s_left_kept{6,subject}(2) / sum(all_subj_remove2s_left_kept{6,subject});
                all_subj_remove2s_left_kept{2,subject} = nansum(all_subj_remove2s_left_kept{2,subject});
                all_avg_remove2s_aware_left = [all_avg_remove2s_aware_left; all_subj_remove2s_left_kept{2,subject}];
        
                all_subj_remove2s_left_kept{3,subject}(1,:) = all_subj_remove2s_left_kept{3,subject}(1,:) * all_subj_remove2s_left_kept{7,subject}(1) / sum(all_subj_remove2s_left_kept{7,subject});
                all_subj_remove2s_left_kept{3,subject}(2,:) = all_subj_remove2s_left_kept{3,subject}(2,:) * all_subj_remove2s_left_kept{7,subject}(2) / sum(all_subj_remove2s_left_kept{7,subject});
                all_subj_remove2s_left_kept{3,subject} = nansum(all_subj_remove2s_left_kept{3,subject});
                all_avg_remove2s_unaware_left = [all_avg_remove2s_unaware_left; all_subj_remove2s_left_kept{3,subject}];
        
                all_subj_remove2s_left_kept{4,subject}(1,:) = all_subj_remove2s_left_kept{4,subject}(1,:) * all_subj_remove2s_left_kept{8,subject}(1) / sum(all_subj_remove2s_left_kept{8,subject});
                all_subj_remove2s_left_kept{4,subject}(2,:) = all_subj_remove2s_left_kept{4,subject}(2,:) * all_subj_remove2s_left_kept{8,subject}(2) / sum(all_subj_remove2s_left_kept{8,subject});
                all_subj_remove2s_left_kept{4,subject} = nansum(all_subj_remove2s_left_kept{4,subject});
        
                all_subj_remove2s_left_kept{5,subject}(1,:) = all_subj_remove2s_left_kept{5,subject}(1,:) * all_subj_remove2s_left_kept{9,subject}(1) / sum(all_subj_remove2s_left_kept{9,subject});
                all_subj_remove2s_left_kept{5,subject}(2,:) = all_subj_remove2s_left_kept{5,subject}(2,:) * all_subj_remove2s_left_kept{9,subject}(2) / sum(all_subj_remove2s_left_kept{9,subject});
                all_subj_remove2s_left_kept{5,subject} = nansum(all_subj_remove2s_left_kept{5,subject});
                
                %Analyze with 2s trials removed, raw
                all_subj_remove2s_left_kept_raw{2,subject}(1,:) = all_subj_remove2s_left_kept_raw{2,subject}(1,:) * all_subj_remove2s_left_kept_raw{6,subject}(1) / sum(all_subj_remove2s_left_kept_raw{6,subject});
                all_subj_remove2s_left_kept_raw{2,subject}(2,:) = all_subj_remove2s_left_kept_raw{2,subject}(2,:) * all_subj_remove2s_left_kept_raw{6,subject}(2) / sum(all_subj_remove2s_left_kept_raw{6,subject});
                all_subj_remove2s_left_kept_raw{2,subject} = nansum(all_subj_remove2s_left_kept_raw{2,subject});
                all_avg_remove2s_aware_left_raw = [all_avg_remove2s_aware_left_raw; all_subj_remove2s_left_kept_raw{2,subject}];
        
                all_subj_remove2s_left_kept_raw{3,subject}(1,:) = all_subj_remove2s_left_kept_raw{3,subject}(1,:) * all_subj_remove2s_left_kept_raw{7,subject}(1) / sum(all_subj_remove2s_left_kept_raw{7,subject});
                all_subj_remove2s_left_kept_raw{3,subject}(2,:) = all_subj_remove2s_left_kept_raw{3,subject}(2,:) * all_subj_remove2s_left_kept_raw{7,subject}(2) / sum(all_subj_remove2s_left_kept_raw{7,subject});
                all_subj_remove2s_left_kept_raw{3,subject} = nansum(all_subj_remove2s_left_kept_raw{3,subject});
                all_avg_remove2s_unaware_left_raw = [all_avg_remove2s_unaware_left_raw; all_subj_remove2s_left_kept_raw{3,subject}];
        
                all_subj_remove2s_left_kept_raw{4,subject}(1,:) = all_subj_remove2s_left_kept_raw{4,subject}(1,:) * all_subj_remove2s_left_kept_raw{8,subject}(1) / sum(all_subj_remove2s_left_kept_raw{8,subject});
                all_subj_remove2s_left_kept_raw{4,subject}(2,:) = all_subj_remove2s_left_kept_raw{4,subject}(2,:) * all_subj_remove2s_left_kept_raw{8,subject}(2) / sum(all_subj_remove2s_left_kept_raw{8,subject});
                all_subj_remove2s_left_kept_raw{4,subject} = nansum(all_subj_remove2s_left_kept_raw{4,subject});
        
                all_subj_remove2s_left_kept_raw{5,subject}(1,:) = all_subj_remove2s_left_kept_raw{5,subject}(1,:) * all_subj_remove2s_left_kept_raw{9,subject}(1) / sum(all_subj_remove2s_left_kept_raw{9,subject});
                all_subj_remove2s_left_kept_raw{5,subject}(2,:) = all_subj_remove2s_left_kept_raw{5,subject}(2,:) * all_subj_remove2s_left_kept_raw{9,subject}(2) / sum(all_subj_remove2s_left_kept_raw{9,subject});
                all_subj_remove2s_left_kept_raw{5,subject} = nansum(all_subj_remove2s_left_kept_raw{5,subject});
%             catch
%                 disp(['Subject overflow, ' num2str(subject)])
%             end
    end
    if length(all_subj_remove2s_left_kept{6,subject}) == 1
%         try
            all_avg_remove2s_aware_left = [all_avg_remove2s_aware_left; all_subj_remove2s_left_kept{2,subject}];
            all_avg_remove2s_unaware_left = [all_avg_remove2s_unaware_left; all_subj_remove2s_left_kept{3,subject}];
            all_avg_remove2s_aware_left_raw = [all_avg_remove2s_aware_left_raw; all_subj_remove2s_left_kept_raw{2,subject}];
            all_avg_remove2s_unaware_left_raw = [all_avg_remove2s_unaware_left_raw; all_subj_remove2s_left_kept_raw{3,subject}];
%         catch
%             disp(['Subject overflow, ' num2str(subject)])
%         end
    end
end
for subject = 1:length(all_subj_right_kept)
    if size(all_subj_right_kept{5,subject},1) > 1
        all_subj_right_kept{2,subject}(1,:) = all_subj_right_kept{2,subject}(1,:) * all_subj_right_kept{6,subject}(1) / sum(all_subj_right_kept{6,subject});
        all_subj_right_kept{2,subject}(2,:) = all_subj_right_kept{2,subject}(2,:) * all_subj_right_kept{6,subject}(2) / sum(all_subj_right_kept{6,subject});
        all_subj_right_kept{2,subject} = nansum(all_subj_right_kept{2,subject});
        all_avg_pupil_aware_right = [all_avg_pupil_aware_right; all_subj_right_kept{2,subject}];

        
        all_subj_right_kept{3,subject}(1,:) = all_subj_right_kept{3,subject}(1,:) * all_subj_right_kept{7,subject}(1) / sum(all_subj_right_kept{7,subject});
        all_subj_right_kept{3,subject}(2,:) = all_subj_right_kept{3,subject}(2,:) * all_subj_right_kept{7,subject}(2) / sum(all_subj_right_kept{7,subject});
        all_subj_right_kept{3,subject} = nansum(all_subj_right_kept{3,subject});
        all_avg_pupil_unaware_right = [all_avg_pupil_unaware_right; all_subj_right_kept{3,subject}];
        
        all_subj_right_kept{4,subject}(1,:) = all_subj_right_kept{4,subject}(1,:) * all_subj_right_kept{8,subject}(1) / sum(all_subj_right_kept{8,subject});
        all_subj_right_kept{4,subject}(2,:) = all_subj_right_kept{4,subject}(2,:) * all_subj_right_kept{8,subject}(2) / sum(all_subj_right_kept{8,subject});
        all_subj_right_kept{4,subject} = nansum(all_subj_right_kept{4,subject});
        
        all_subj_right_kept{5,subject}(1,:) = all_subj_right_kept{5,subject}(1,:) * all_subj_right_kept{9,subject}(1) / sum(all_subj_right_kept{9,subject});
        all_subj_right_kept{5,subject}(2,:) = all_subj_right_kept{5,subject}(2,:) * all_subj_right_kept{9,subject}(2) / sum(all_subj_right_kept{9,subject});
        all_subj_right_kept{5,subject} = nansum(all_subj_right_kept{5,subject});
        
        %Analyze Raw Pupil Diameter
        all_subj_right_kept_raw{2,subject}(1,:) = all_subj_right_kept_raw{2,subject}(1,:) * all_subj_right_kept_raw{6,subject}(1) / sum(all_subj_right_kept_raw{6,subject});
        all_subj_right_kept_raw{2,subject}(2,:) = all_subj_right_kept_raw{2,subject}(2,:) * all_subj_right_kept_raw{6,subject}(2) / sum(all_subj_right_kept_raw{6,subject});
        all_subj_right_kept_raw{2,subject} = nansum(all_subj_right_kept_raw{2,subject});
        all_avg_pupil_aware_right_raw = [all_avg_pupil_aware_right_raw; all_subj_right_kept_raw{2,subject}];
        
        all_subj_right_kept_raw{3,subject}(1,:) = all_subj_right_kept_raw{3,subject}(1,:) * all_subj_right_kept_raw{7,subject}(1) / sum(all_subj_right_kept_raw{7,subject});
        all_subj_right_kept_raw{3,subject}(2,:) = all_subj_right_kept_raw{3,subject}(2,:) * all_subj_right_kept_raw{7,subject}(2) / sum(all_subj_right_kept_raw{7,subject});
        all_subj_right_kept_raw{3,subject} = nansum(all_subj_right_kept_raw{3,subject});
        all_avg_pupil_unaware_right_raw = [all_avg_pupil_unaware_right_raw; all_subj_right_kept_raw{3,subject}];
        
        all_subj_right_kept_raw{4,subject}(1,:) = all_subj_right_kept_raw{4,subject}(1,:) * all_subj_right_kept_raw{8,subject}(1) / sum(all_subj_right_kept_raw{8,subject});
        all_subj_right_kept_raw{4,subject}(2,:) = all_subj_right_kept_raw{4,subject}(2,:) * all_subj_right_kept_raw{8,subject}(2) / sum(all_subj_right_kept_raw{8,subject});
        all_subj_right_kept_raw{4,subject} = nansum(all_subj_right_kept_raw{4,subject});
        
        all_subj_right_kept_raw{5,subject}(1,:) = all_subj_right_kept_raw{5,subject}(1,:) * all_subj_right_kept_raw{9,subject}(1) / sum(all_subj_right_kept_raw{9,subject});
        all_subj_right_kept_raw{5,subject}(2,:) = all_subj_right_kept_raw{5,subject}(2,:) * all_subj_right_kept_raw{9,subject}(2) / sum(all_subj_right_kept_raw{9,subject});
        all_subj_right_kept_raw{5,subject} = nansum(all_subj_right_kept_raw{5,subject});
        
        %Analyze Saccade
         all_subj_sac_right_kept{2,subject}(1,:) = all_subj_sac_right_kept{2,subject}(1,:) * all_subj_sac_right_kept{6,subject}(1) / sum(all_subj_sac_right_kept{6,subject});
        all_subj_sac_right_kept{2,subject}(2,:) = all_subj_sac_right_kept{2,subject}(2,:) * all_subj_sac_right_kept{6,subject}(2) / sum(all_subj_sac_right_kept{6,subject});
        all_subj_sac_right_kept{2,subject} = nansum(all_subj_sac_right_kept{2,subject});
        all_avg_sac_aware_right = [all_avg_sac_aware_right; all_subj_sac_right_kept{2,subject}];

        
        all_subj_sac_right_kept{3,subject}(1,:) = all_subj_sac_right_kept{3,subject}(1,:) * all_subj_sac_right_kept{7,subject}(1) / sum(all_subj_sac_right_kept{7,subject});
        all_subj_sac_right_kept{3,subject}(2,:) = all_subj_sac_right_kept{3,subject}(2,:) * all_subj_sac_right_kept{7,subject}(2) / sum(all_subj_sac_right_kept{7,subject});
        all_subj_sac_right_kept{3,subject} = nansum(all_subj_sac_right_kept{3,subject});
        all_avg_sac_unaware_right = [all_avg_sac_unaware_right; all_subj_sac_right_kept{3,subject}];
        
        all_subj_sac_right_kept{4,subject}(1,:) = all_subj_sac_right_kept{4,subject}(1,:) * all_subj_sac_right_kept{8,subject}(1) / sum(all_subj_sac_right_kept{8,subject});
        all_subj_sac_right_kept{4,subject}(2,:) = all_subj_sac_right_kept{4,subject}(2,:) * all_subj_sac_right_kept{8,subject}(2) / sum(all_subj_sac_right_kept{8,subject});
        all_subj_sac_right_kept{4,subject} = nansum(all_subj_sac_right_kept{4,subject});
        
        all_subj_sac_right_kept{5,subject}(1,:) = all_subj_sac_right_kept{5,subject}(1,:) * all_subj_sac_right_kept{9,subject}(1) / sum(all_subj_sac_right_kept{9,subject});
        all_subj_sac_right_kept{5,subject}(2,:) = all_subj_sac_right_kept{5,subject}(2,:) * all_subj_sac_right_kept{9,subject}(2) / sum(all_subj_sac_right_kept{9,subject});
        all_subj_sac_right_kept{5,subject} = nansum(all_subj_sac_right_kept{5,subject});
        
        
        all_subj_sac_rate_right_kept{2,subject}(1,:) = all_subj_sac_rate_right_kept{2,subject}(1,:) * all_subj_sac_rate_right_kept{6,subject}(1) / sum(all_subj_sac_rate_right_kept{6,subject});
        all_subj_sac_rate_right_kept{2,subject}(2,:) = all_subj_sac_rate_right_kept{2,subject}(2,:) * all_subj_sac_rate_right_kept{6,subject}(2) / sum(all_subj_sac_rate_right_kept{6,subject});
        all_subj_sac_rate_right_kept{2,subject} = nansum(all_subj_sac_rate_right_kept{2,subject});
        all_avg_sac_rate_aware_right = [all_avg_sac_rate_aware_right; all_subj_sac_rate_right_kept{2,subject}];
        
        all_subj_sac_rate_right_kept{3,subject}(1,:) = all_subj_sac_rate_right_kept{3,subject}(1,:) * all_subj_sac_rate_right_kept{7,subject}(1) / sum(all_subj_sac_rate_right_kept{7,subject});
        all_subj_sac_rate_right_kept{3,subject}(2,:) = all_subj_sac_rate_right_kept{3,subject}(2,:) * all_subj_sac_rate_right_kept{7,subject}(2) / sum(all_subj_sac_rate_right_kept{7,subject});
        all_subj_sac_rate_right_kept{3,subject} = nansum(all_subj_sac_rate_right_kept{3,subject});
        all_avg_sac_rate_unaware_right = [all_avg_sac_rate_unaware_right; all_subj_sac_rate_right_kept{3,subject}];
        
        all_subj_sac_rate_right_kept{4,subject}(1,:) = all_subj_sac_rate_right_kept{4,subject}(1,:) * all_subj_sac_rate_right_kept{8,subject}(1) / sum(all_subj_sac_rate_right_kept{8,subject});
        all_subj_sac_rate_right_kept{4,subject}(2,:) = all_subj_sac_rate_right_kept{4,subject}(2,:) * all_subj_sac_rate_right_kept{8,subject}(2) / sum(all_subj_sac_rate_right_kept{8,subject});
        all_subj_sac_rate_right_kept{4,subject} = nansum(all_subj_sac_rate_right_kept{4,subject});
        
        all_subj_sac_rate_right_kept{5,subject}(1,:) = all_subj_sac_rate_right_kept{5,subject}(1,:) * all_subj_sac_rate_right_kept{9,subject}(1) / sum(all_subj_sac_rate_right_kept{9,subject});
        all_subj_sac_rate_right_kept{5,subject}(2,:) = all_subj_sac_rate_right_kept{5,subject}(2,:) * all_subj_sac_rate_right_kept{9,subject}(2) / sum(all_subj_sac_rate_right_kept{9,subject});
        all_subj_sac_rate_right_kept{5,subject} = nansum(all_subj_sac_rate_right_kept{5,subject});

          all_subj_blink_right_kept{2,subject}(1,:) = all_subj_blink_right_kept{2,subject}(1,:) * all_subj_blink_right_kept{6,subject}(1) / sum(all_subj_blink_right_kept{6,subject});
        all_subj_blink_right_kept{2,subject}(2,:) = all_subj_blink_right_kept{2,subject}(2,:) * all_subj_blink_right_kept{6,subject}(2) / sum(all_subj_blink_right_kept{6,subject});
        all_subj_blink_right_kept{2,subject} = nansum(all_subj_blink_right_kept{2,subject});
        all_avg_blink_aware_right = [all_avg_blink_aware_right; all_subj_blink_right_kept{2,subject}];

        
        all_subj_blink_right_kept{3,subject}(1,:) = all_subj_blink_right_kept{3,subject}(1,:) * all_subj_blink_right_kept{7,subject}(1) / sum(all_subj_blink_right_kept{7,subject});
        all_subj_blink_right_kept{3,subject}(2,:) = all_subj_blink_right_kept{3,subject}(2,:) * all_subj_blink_right_kept{7,subject}(2) / sum(all_subj_blink_right_kept{7,subject});
        all_subj_blink_right_kept{3,subject} = nansum(all_subj_blink_right_kept{3,subject});
        all_avg_blink_unaware_right = [all_avg_blink_unaware_right; all_subj_blink_right_kept{3,subject}];
        
        all_subj_blink_right_kept{4,subject}(1,:) = all_subj_blink_right_kept{4,subject}(1,:) * all_subj_blink_right_kept{8,subject}(1) / sum(all_subj_blink_right_kept{8,subject});
        all_subj_blink_right_kept{4,subject}(2,:) = all_subj_blink_right_kept{4,subject}(2,:) * all_subj_blink_right_kept{8,subject}(2) / sum(all_subj_blink_right_kept{8,subject});
        all_subj_blink_right_kept{4,subject} = nansum(all_subj_blink_right_kept{4,subject});
        
        all_subj_blink_right_kept{5,subject}(1,:) = all_subj_blink_right_kept{5,subject}(1,:) * all_subj_blink_right_kept{9,subject}(1) / sum(all_subj_blink_right_kept{9,subject});
        all_subj_blink_right_kept{5,subject}(2,:) = all_subj_blink_right_kept{5,subject}(2,:) * all_subj_blink_right_kept{9,subject}(2) / sum(all_subj_blink_right_kept{9,subject});
        all_subj_blink_right_kept{5,subject} = nansum(all_subj_blink_right_kept{5,subject});
        
         all_subj_long_blink_right_kept{2,subject}(1,:) = all_subj_long_blink_right_kept{2,subject}(1,:) * all_subj_long_blink_right_kept{6,subject}(1) / sum(all_subj_long_blink_right_kept{6,subject});
        all_subj_long_blink_right_kept{2,subject}(2,:) = all_subj_long_blink_right_kept{2,subject}(2,:) * all_subj_long_blink_right_kept{6,subject}(2) / sum(all_subj_long_blink_right_kept{6,subject});
        all_subj_long_blink_right_kept{2,subject} = nansum(all_subj_long_blink_right_kept{2,subject});
        all_avg_long_blink_aware_right = [all_avg_long_blink_aware_right; all_subj_long_blink_right_kept{2,subject}];

        
        all_subj_long_blink_right_kept{3,subject}(1,:) = all_subj_long_blink_right_kept{3,subject}(1,:) * all_subj_long_blink_right_kept{7,subject}(1) / sum(all_subj_long_blink_right_kept{7,subject});
        all_subj_long_blink_right_kept{3,subject}(2,:) = all_subj_long_blink_right_kept{3,subject}(2,:) * all_subj_long_blink_right_kept{7,subject}(2) / sum(all_subj_long_blink_right_kept{7,subject});
        all_subj_long_blink_right_kept{3,subject} = nansum(all_subj_long_blink_right_kept{3,subject});
        all_avg_long_blink_unaware_right = [all_avg_long_blink_unaware_right; all_subj_long_blink_right_kept{3,subject}];
        
        all_subj_long_blink_right_kept{4,subject}(1,:) = all_subj_long_blink_right_kept{4,subject}(1,:) * all_subj_long_blink_right_kept{8,subject}(1) / sum(all_subj_long_blink_right_kept{8,subject});
        all_subj_long_blink_right_kept{4,subject}(2,:) = all_subj_long_blink_right_kept{4,subject}(2,:) * all_subj_long_blink_right_kept{8,subject}(2) / sum(all_subj_long_blink_right_kept{8,subject});
        all_subj_long_blink_right_kept{4,subject} = nansum(all_subj_long_blink_right_kept{4,subject});
        
        all_subj_long_blink_right_kept{5,subject}(1,:) = all_subj_long_blink_right_kept{5,subject}(1,:) * all_subj_long_blink_right_kept{9,subject}(1) / sum(all_subj_long_blink_right_kept{9,subject});
        all_subj_long_blink_right_kept{5,subject}(2,:) = all_subj_long_blink_right_kept{5,subject}(2,:) * all_subj_long_blink_right_kept{9,subject}(2) / sum(all_subj_long_blink_right_kept{9,subject});
        all_subj_long_blink_right_kept{5,subject} = nansum(all_subj_long_blink_right_kept{5,subject});
        
        all_subj_long_blink_right_kept_bin{2,subject}(1,:) = all_subj_long_blink_right_kept_bin{2,subject}(1,:) * all_subj_long_blink_right_kept_bin{6,subject}(1) / sum(all_subj_long_blink_right_kept_bin{6,subject});
        all_subj_long_blink_right_kept_bin{2,subject}(2,:) = all_subj_long_blink_right_kept_bin{2,subject}(2,:) * all_subj_long_blink_right_kept_bin{6,subject}(2) / sum(all_subj_long_blink_right_kept_bin{6,subject});
        all_subj_long_blink_right_kept_bin{2,subject} = nansum(all_subj_long_blink_right_kept_bin{2,subject});
        all_avg_long_blink_aware_right_bin = [all_avg_long_blink_aware_right_bin; all_subj_long_blink_right_kept_bin{2,subject}];
        
        all_subj_long_blink_right_kept_bin{3,subject}(1,:) = all_subj_long_blink_right_kept_bin{3,subject}(1,:) * all_subj_long_blink_right_kept_bin{7,subject}(1) / sum(all_subj_long_blink_right_kept_bin{7,subject});
        all_subj_long_blink_right_kept_bin{3,subject}(2,:) = all_subj_long_blink_right_kept_bin{3,subject}(2,:) * all_subj_long_blink_right_kept_bin{7,subject}(2) / sum(all_subj_long_blink_right_kept_bin{7,subject});
        all_subj_long_blink_right_kept_bin{3,subject} = nansum(all_subj_long_blink_right_kept_bin{3,subject});
        all_avg_long_blink_unaware_right_bin = [all_avg_long_blink_unaware_right_bin; all_subj_long_blink_right_kept_bin{3,subject}];
        
        all_subj_long_blink_right_kept_bin{4,subject}(1,:) = all_subj_long_blink_right_kept_bin{4,subject}(1,:) * all_subj_long_blink_right_kept_bin{8,subject}(1) / sum(all_subj_long_blink_right_kept_bin{8,subject});
        all_subj_long_blink_right_kept_bin{4,subject}(2,:) = all_subj_long_blink_right_kept_bin{4,subject}(2,:) * all_subj_long_blink_right_kept_bin{8,subject}(2) / sum(all_subj_long_blink_right_kept_bin{8,subject});
        all_subj_long_blink_right_kept_bin{4,subject} = nansum(all_subj_long_blink_right_kept_bin{4,subject});
        
        all_subj_long_blink_right_kept_bin{5,subject}(1,:) = all_subj_long_blink_right_kept_bin{5,subject}(1,:) * all_subj_long_blink_right_kept_bin{9,subject}(1) / sum(all_subj_long_blink_right_kept_bin{9,subject});
        all_subj_long_blink_right_kept_bin{5,subject}(2,:) = all_subj_long_blink_right_kept_bin{5,subject}(2,:) * all_subj_long_blink_right_kept_bin{9,subject}(2) / sum(all_subj_long_blink_right_kept_bin{9,subject});
        all_subj_long_blink_right_kept_bin{5,subject} = nansum(all_subj_long_blink_right_kept_bin{5,subject});
        
        %Analyze saccade duration data
        all_subj_sac_duration_right_kept{2,subject}(1,:) = all_subj_sac_duration_right_kept{2,subject}(1,:) * all_subj_sac_duration_right_kept{6,subject}(1) / sum(all_subj_sac_duration_right_kept{6,subject});
        all_subj_sac_duration_right_kept{2,subject}(2,:) = all_subj_sac_duration_right_kept{2,subject}(2,:) * all_subj_sac_duration_right_kept{6,subject}(2) / sum(all_subj_sac_duration_right_kept{6,subject});
        all_subj_sac_duration_right_kept{2,subject} = nansum(all_subj_sac_duration_right_kept{2,subject});
        all_avg_sac_duration_aware_right = [all_avg_sac_duration_aware_right; all_subj_sac_duration_right_kept{2,subject}];
        
        all_subj_sac_duration_right_kept{3,subject}(1,:) = all_subj_sac_duration_right_kept{3,subject}(1,:) * all_subj_sac_duration_right_kept{7,subject}(1) / sum(all_subj_sac_duration_right_kept{7,subject});
        all_subj_sac_duration_right_kept{3,subject}(2,:) = all_subj_sac_duration_right_kept{3,subject}(2,:) * all_subj_sac_duration_right_kept{7,subject}(2) / sum(all_subj_sac_duration_right_kept{7,subject});
        all_subj_sac_duration_right_kept{3,subject} = nansum(all_subj_sac_duration_right_kept{3,subject});
        all_avg_sac_duration_unaware_right = [all_avg_sac_duration_unaware_right; all_subj_sac_duration_right_kept{3,subject}];
        
        all_subj_sac_duration_right_kept{4,subject}(1,:) = all_subj_sac_duration_right_kept{4,subject}(1,:) * all_subj_sac_duration_right_kept{8,subject}(1) / sum(all_subj_sac_duration_right_kept{8,subject});
        all_subj_sac_duration_right_kept{4,subject}(2,:) = all_subj_sac_duration_right_kept{4,subject}(2,:) * all_subj_sac_duration_right_kept{8,subject}(2) / sum(all_subj_sac_duration_right_kept{8,subject});
        all_subj_sac_duration_right_kept{4,subject} = nansum(all_subj_sac_duration_right_kept{4,subject});
        
        all_subj_sac_duration_right_kept{5,subject}(1,:) = all_subj_sac_duration_right_kept{5,subject}(1,:) * all_subj_sac_duration_right_kept{9,subject}(1) / sum(all_subj_sac_duration_right_kept{9,subject});
        all_subj_sac_duration_right_kept{5,subject}(2,:) = all_subj_sac_duration_right_kept{5,subject}(2,:) * all_subj_sac_duration_right_kept{9,subject}(2) / sum(all_subj_sac_duration_right_kept{9,subject});
        all_subj_sac_duration_right_kept{5,subject} = nansum(all_subj_sac_duration_right_kept{5,subject});
        
         %Analyze saccade duration data
        all_subj_blink_duration_right_kept{2,subject}(1,:) = all_subj_blink_duration_right_kept{2,subject}(1,:) * all_subj_blink_duration_right_kept{6,subject}(1) / sum(all_subj_blink_duration_right_kept{6,subject});
        all_subj_blink_duration_right_kept{2,subject}(2,:) = all_subj_blink_duration_right_kept{2,subject}(2,:) * all_subj_blink_duration_right_kept{6,subject}(2) / sum(all_subj_blink_duration_right_kept{6,subject});
        all_subj_blink_duration_right_kept{2,subject} = nansum(all_subj_blink_duration_right_kept{2,subject});
        all_avg_blink_duration_aware_right = [all_avg_blink_duration_aware_right; all_subj_blink_duration_right_kept{2,subject}];
        
        all_subj_blink_duration_right_kept{3,subject}(1,:) = all_subj_blink_duration_right_kept{3,subject}(1,:) * all_subj_blink_duration_right_kept{7,subject}(1) / sum(all_subj_blink_duration_right_kept{7,subject});
        all_subj_blink_duration_right_kept{3,subject}(2,:) = all_subj_blink_duration_right_kept{3,subject}(2,:) * all_subj_blink_duration_right_kept{7,subject}(2) / sum(all_subj_blink_duration_right_kept{7,subject});
        all_subj_blink_duration_right_kept{3,subject} = nansum(all_subj_blink_duration_right_kept{3,subject});
        all_avg_blink_duration_unaware_right = [all_avg_blink_duration_unaware_right; all_subj_blink_duration_right_kept{3,subject}];
        
        all_subj_blink_duration_right_kept{4,subject}(1,:) = all_subj_blink_duration_right_kept{4,subject}(1,:) * all_subj_blink_duration_right_kept{8,subject}(1) / sum(all_subj_blink_duration_right_kept{8,subject});
        all_subj_blink_duration_right_kept{4,subject}(2,:) = all_subj_blink_duration_right_kept{4,subject}(2,:) * all_subj_blink_duration_right_kept{8,subject}(2) / sum(all_subj_blink_duration_right_kept{8,subject});
        all_subj_blink_duration_right_kept{4,subject} = nansum(all_subj_blink_duration_right_kept{4,subject});
        
        all_subj_blink_duration_right_kept{5,subject}(1,:) = all_subj_blink_duration_right_kept{5,subject}(1,:) * all_subj_blink_duration_right_kept{9,subject}(1) / sum(all_subj_blink_duration_right_kept{9,subject});
        all_subj_blink_duration_right_kept{5,subject}(2,:) = all_subj_blink_duration_right_kept{5,subject}(2,:) * all_subj_blink_duration_right_kept{9,subject}(2) / sum(all_subj_blink_duration_right_kept{9,subject});
        all_subj_blink_duration_right_kept{5,subject} = nansum(all_subj_blink_duration_right_kept{5,subject});
        
        %Analyze blink duration data
        all_subj_minus1to0_right_kept{2,subject}(1,:) = all_subj_minus1to0_right_kept{2,subject}(1,:) * all_subj_minus1to0_right_kept{6,subject}(1) / sum(all_subj_minus1to0_right_kept{6,subject});
        all_subj_minus1to0_right_kept{2,subject}(2,:) = all_subj_minus1to0_right_kept{2,subject}(2,:) * all_subj_minus1to0_right_kept{6,subject}(2) / sum(all_subj_minus1to0_right_kept{6,subject});
        all_subj_minus1to0_right_kept{2,subject} = nansum(all_subj_minus1to0_right_kept{2,subject});
        all_avg_minus1to0_aware_right = [all_avg_minus1to0_aware_right; all_subj_minus1to0_right_kept{2,subject}];

        
        all_subj_minus1to0_right_kept{3,subject}(1,:) = all_subj_minus1to0_right_kept{3,subject}(1,:) * all_subj_minus1to0_right_kept{7,subject}(1) / sum(all_subj_minus1to0_right_kept{7,subject});
        all_subj_minus1to0_right_kept{3,subject}(2,:) = all_subj_minus1to0_right_kept{3,subject}(2,:) * all_subj_minus1to0_right_kept{7,subject}(2) / sum(all_subj_minus1to0_right_kept{7,subject});
        all_subj_minus1to0_right_kept{3,subject} = nansum(all_subj_minus1to0_right_kept{3,subject});
        all_avg_minus1to0_unaware_right = [all_avg_minus1to0_unaware_right; all_subj_minus1to0_right_kept{3,subject}];
        
        all_subj_minus1to0_right_kept{4,subject}(1,:) = all_subj_minus1to0_right_kept{4,subject}(1,:) * all_subj_minus1to0_right_kept{8,subject}(1) / sum(all_subj_minus1to0_right_kept{8,subject});
        all_subj_minus1to0_right_kept{4,subject}(2,:) = all_subj_minus1to0_right_kept{4,subject}(2,:) * all_subj_minus1to0_right_kept{8,subject}(2) / sum(all_subj_minus1to0_right_kept{8,subject});
        all_subj_minus1to0_right_kept{4,subject} = nansum(all_subj_minus1to0_right_kept{4,subject});
        
        all_subj_minus1to0_right_kept{5,subject}(1,:) = all_subj_minus1to0_right_kept{5,subject}(1,:) * all_subj_minus1to0_right_kept{9,subject}(1) / sum(all_subj_minus1to0_right_kept{9,subject});
        all_subj_minus1to0_right_kept{5,subject}(2,:) = all_subj_minus1to0_right_kept{5,subject}(2,:) * all_subj_minus1to0_right_kept{9,subject}(2) / sum(all_subj_minus1to0_right_kept{9,subject});
        all_subj_minus1to0_right_kept{5,subject} = nansum(all_subj_minus1to0_right_kept{5,subject});
        
         all_subj_minus2minus1_right_kept{2,subject}(1,:) = all_subj_minus2minus1_right_kept{2,subject}(1,:) * all_subj_minus2minus1_right_kept{6,subject}(1) / sum(all_subj_minus2minus1_right_kept{6,subject});
        all_subj_minus2minus1_right_kept{2,subject}(2,:) = all_subj_minus2minus1_right_kept{2,subject}(2,:) * all_subj_minus2minus1_right_kept{6,subject}(2) / sum(all_subj_minus2minus1_right_kept{6,subject});
        all_subj_minus2minus1_right_kept{2,subject} = nansum(all_subj_minus2minus1_right_kept{2,subject});
        all_avg_minus2minus1_aware_right = [all_avg_minus2minus1_aware_right; all_subj_minus2minus1_right_kept{2,subject}];

        
        all_subj_minus2minus1_right_kept{3,subject}(1,:) = all_subj_minus2minus1_right_kept{3,subject}(1,:) * all_subj_minus2minus1_right_kept{7,subject}(1) / sum(all_subj_minus2minus1_right_kept{7,subject});
        all_subj_minus2minus1_right_kept{3,subject}(2,:) = all_subj_minus2minus1_right_kept{3,subject}(2,:) * all_subj_minus2minus1_right_kept{7,subject}(2) / sum(all_subj_minus2minus1_right_kept{7,subject});
        all_subj_minus2minus1_right_kept{3,subject} = nansum(all_subj_minus2minus1_right_kept{3,subject});
        all_avg_minus2minus1_unaware_right = [all_avg_minus2minus1_unaware_right; all_subj_minus2minus1_right_kept{3,subject}];
        
        all_subj_minus2minus1_right_kept{4,subject}(1,:) = all_subj_minus2minus1_right_kept{4,subject}(1,:) * all_subj_minus2minus1_right_kept{8,subject}(1) / sum(all_subj_minus2minus1_right_kept{8,subject});
        all_subj_minus2minus1_right_kept{4,subject}(2,:) = all_subj_minus2minus1_right_kept{4,subject}(2,:) * all_subj_minus2minus1_right_kept{8,subject}(2) / sum(all_subj_minus2minus1_right_kept{8,subject});
        all_subj_minus2minus1_right_kept{4,subject} = nansum(all_subj_minus2minus1_right_kept{4,subject});
        
        all_subj_minus2minus1_right_kept{5,subject}(1,:) = all_subj_minus2minus1_right_kept{5,subject}(1,:) * all_subj_minus2minus1_right_kept{9,subject}(1) / sum(all_subj_minus2minus1_right_kept{9,subject});
        all_subj_minus2minus1_right_kept{5,subject}(2,:) = all_subj_minus2minus1_right_kept{5,subject}(2,:) * all_subj_minus2minus1_right_kept{9,subject}(2) / sum(all_subj_minus2minus1_right_kept{9,subject});
        all_subj_minus2minus1_right_kept{5,subject} = nansum(all_subj_minus2minus1_right_kept{5,subject});

        %Analyze nanned trials 2s and beyond for trials of only 2s
        all_subj_nan2s_right_kept{2,subject}(1,:) = all_subj_nan2s_right_kept{2,subject}(1,:) * all_subj_nan2s_right_kept{6,subject}(1) / sum(all_subj_nan2s_right_kept{6,subject});
        all_subj_nan2s_right_kept{2,subject}(2,:) = all_subj_nan2s_right_kept{2,subject}(2,:) * all_subj_nan2s_right_kept{6,subject}(2) / sum(all_subj_nan2s_right_kept{6,subject});
        all_subj_nan2s_right_kept{2,subject} = nansum(all_subj_nan2s_right_kept{2,subject});
        all_avg_nan2s_aware_right = [all_avg_nan2s_aware_right; all_subj_nan2s_right_kept{2,subject}];

        all_subj_nan2s_right_kept{3,subject}(1,:) = all_subj_nan2s_right_kept{3,subject}(1,:) * all_subj_nan2s_right_kept{7,subject}(1) / sum(all_subj_nan2s_right_kept{7,subject});
        all_subj_nan2s_right_kept{3,subject}(2,:) = all_subj_nan2s_right_kept{3,subject}(2,:) * all_subj_nan2s_right_kept{7,subject}(2) / sum(all_subj_nan2s_right_kept{7,subject});
        all_subj_nan2s_right_kept{3,subject} = nansum(all_subj_nan2s_right_kept{3,subject});
        all_avg_nan2s_unaware_right = [all_avg_nan2s_unaware_right; all_subj_nan2s_right_kept{3,subject}];

        all_subj_nan2s_right_kept{4,subject}(1,:) = all_subj_nan2s_right_kept{4,subject}(1,:) * all_subj_nan2s_right_kept{8,subject}(1) / sum(all_subj_nan2s_right_kept{8,subject});
        all_subj_nan2s_right_kept{4,subject}(2,:) = all_subj_nan2s_right_kept{4,subject}(2,:) * all_subj_nan2s_right_kept{8,subject}(2) / sum(all_subj_nan2s_right_kept{8,subject});
        all_subj_nan2s_right_kept{4,subject} = nansum(all_subj_nan2s_right_kept{4,subject});

        all_subj_nan2s_right_kept{5,subject}(1,:) = all_subj_nan2s_right_kept{5,subject}(1,:) * all_subj_nan2s_right_kept{9,subject}(1) / sum(all_subj_nan2s_right_kept{9,subject});
        all_subj_nan2s_right_kept{5,subject}(2,:) = all_subj_nan2s_right_kept{5,subject}(2,:) * all_subj_nan2s_right_kept{9,subject}(2) / sum(all_subj_nan2s_right_kept{9,subject});
        all_subj_nan2s_right_kept{5,subject} = nansum(all_subj_nan2s_right_kept{5,subject});
        
        
        
    end
    if length(all_subj_right_kept{6,subject}) == 1
        all_avg_pupil_aware_right = [all_avg_pupil_aware_right; all_subj_right_kept{2,subject}];
        all_avg_pupil_unaware_right = [all_avg_pupil_unaware_right; all_subj_right_kept{3,subject}];
        
        all_avg_pupil_aware_right_raw = [all_avg_pupil_aware_right_raw; all_subj_right_kept_raw{2,subject}];
        all_avg_pupil_unaware_right_raw = [all_avg_pupil_unaware_right_raw; all_subj_right_kept_raw{3,subject}];
        
        all_avg_sac_aware_right = [all_avg_sac_aware_right; all_subj_sac_right_kept{2,subject}];
        all_avg_sac_unaware_right = [all_avg_sac_unaware_right; all_subj_sac_right_kept{3,subject}];

        all_avg_sac_rate_aware_right = [all_avg_sac_rate_aware_right; all_subj_sac_rate_right_kept{2,subject}];
        all_avg_sac_rate_unaware_right = [all_avg_sac_rate_unaware_right; all_subj_sac_rate_right_kept{3,subject}];
        
        all_avg_blink_aware_right = [all_avg_blink_aware_right; all_subj_blink_right_kept{2,subject}];
        all_avg_blink_unaware_right = [all_avg_blink_unaware_right; all_subj_blink_right_kept{3,subject}];
        
        all_avg_long_blink_aware_right = [all_avg_long_blink_aware_right; all_subj_long_blink_right_kept{2,subject}];
        all_avg_long_blink_unaware_right = [all_avg_long_blink_unaware_right; all_subj_long_blink_right_kept{3,subject}];

        all_avg_long_blink_aware_right_bin = [all_avg_long_blink_aware_right_bin; all_subj_long_blink_right_kept_bin{2,subject}];
        all_avg_long_blink_unaware_right_bin = [all_avg_long_blink_unaware_right_bin; all_subj_long_blink_right_kept_bin{3,subject}];
        
        all_avg_sac_duration_aware_right = [all_avg_sac_duration_aware_right; all_subj_sac_duration_right_kept{2,subject}];
        all_avg_sac_duration_unaware_right = [all_avg_sac_duration_unaware_right; all_subj_sac_duration_right_kept{3,subject}];

        all_avg_blink_duration_aware_right = [all_avg_blink_duration_aware_right; all_subj_blink_duration_right_kept{2,subject}];
        all_avg_blink_duration_unaware_right = [all_avg_blink_duration_unaware_right; all_subj_blink_duration_right_kept{3,subject}];
        
        all_avg_minus1to0_aware_right = [all_avg_minus1to0_aware_right; all_subj_minus1to0_right_kept{2,subject}];
        all_avg_minus1to0_unaware_right = [all_avg_minus1to0_unaware_right; all_subj_minus1to0_right_kept{3,subject}];

        all_avg_minus2minus1_aware_right = [all_avg_minus2minus1_aware_right; all_subj_minus2minus1_right_kept{2,subject}];
        all_avg_minus2minus1_unaware_right = [all_avg_minus2minus1_unaware_right; all_subj_minus2minus1_right_kept{3,subject}];
        
        

        all_avg_nan2s_aware_right = [all_avg_nan2s_aware_right; all_subj_nan2s_right_kept{2,subject}];
        all_avg_nan2s_unaware_right = [all_avg_nan2s_unaware_right; all_subj_nan2s_right_kept{3,subject}];

    end
end
for subject = 1:length(all_subj_remove2s_right_kept)
    if length(all_subj_remove2s_right_kept{6,subject}) > 1
%         try
                %Analyze with 2s trials removed
                all_subj_remove2s_right_kept{2,subject}(1,:) = all_subj_remove2s_right_kept{2,subject}(1,:) * all_subj_remove2s_right_kept{6,subject}(1) / sum(all_subj_remove2s_right_kept{6,subject});
                all_subj_remove2s_right_kept{2,subject}(2,:) = all_subj_remove2s_right_kept{2,subject}(2,:) * all_subj_remove2s_right_kept{6,subject}(2) / sum(all_subj_remove2s_right_kept{6,subject});
                all_subj_remove2s_right_kept{2,subject} = nansum(all_subj_remove2s_right_kept{2,subject});
                all_avg_remove2s_aware_right = [all_avg_remove2s_aware_right; all_subj_remove2s_right_kept{2,subject}];
        
                all_subj_remove2s_right_kept{3,subject}(1,:) = all_subj_remove2s_right_kept{3,subject}(1,:) * all_subj_remove2s_right_kept{7,subject}(1) / sum(all_subj_remove2s_right_kept{7,subject});
                all_subj_remove2s_right_kept{3,subject}(2,:) = all_subj_remove2s_right_kept{3,subject}(2,:) * all_subj_remove2s_right_kept{7,subject}(2) / sum(all_subj_remove2s_right_kept{7,subject});
                all_subj_remove2s_right_kept{3,subject} = nansum(all_subj_remove2s_right_kept{3,subject});
                all_avg_remove2s_unaware_right = [all_avg_remove2s_unaware_right; all_subj_remove2s_right_kept{3,subject}];
        
                all_subj_remove2s_right_kept{4,subject}(1,:) = all_subj_remove2s_right_kept{4,subject}(1,:) * all_subj_remove2s_right_kept{8,subject}(1) / sum(all_subj_remove2s_right_kept{8,subject});
                all_subj_remove2s_right_kept{4,subject}(2,:) = all_subj_remove2s_right_kept{4,subject}(2,:) * all_subj_remove2s_right_kept{8,subject}(2) / sum(all_subj_remove2s_right_kept{8,subject});
                all_subj_remove2s_right_kept{4,subject} = nansum(all_subj_remove2s_right_kept{4,subject});
        
                all_subj_remove2s_right_kept{5,subject}(1,:) = all_subj_remove2s_right_kept{5,subject}(1,:) * all_subj_remove2s_right_kept{9,subject}(1) / sum(all_subj_remove2s_right_kept{9,subject});
                all_subj_remove2s_right_kept{5,subject}(2,:) = all_subj_remove2s_right_kept{5,subject}(2,:) * all_subj_remove2s_right_kept{9,subject}(2) / sum(all_subj_remove2s_right_kept{9,subject});
                all_subj_remove2s_right_kept{5,subject} = nansum(all_subj_remove2s_right_kept{5,subject});
                
                % Analyze with 2s trials removed, raw
                all_subj_remove2s_right_kept_raw{2,subject}(1,:) = all_subj_remove2s_right_kept_raw{2,subject}(1,:) * all_subj_remove2s_right_kept_raw{6,subject}(1) / sum(all_subj_remove2s_right_kept_raw{6,subject});
                all_subj_remove2s_right_kept_raw{2,subject}(2,:) = all_subj_remove2s_right_kept_raw{2,subject}(2,:) * all_subj_remove2s_right_kept_raw{6,subject}(2) / sum(all_subj_remove2s_right_kept_raw{6,subject});
                all_subj_remove2s_right_kept_raw{2,subject} = nansum(all_subj_remove2s_right_kept_raw{2,subject});
                all_avg_remove2s_aware_right_raw = [all_avg_remove2s_aware_right_raw; all_subj_remove2s_right_kept_raw{2,subject}];
        
                all_subj_remove2s_right_kept_raw{3,subject}(1,:) = all_subj_remove2s_right_kept_raw{3,subject}(1,:) * all_subj_remove2s_right_kept_raw{7,subject}(1) / sum(all_subj_remove2s_right_kept_raw{7,subject});
                all_subj_remove2s_right_kept_raw{3,subject}(2,:) = all_subj_remove2s_right_kept_raw{3,subject}(2,:) * all_subj_remove2s_right_kept_raw{7,subject}(2) / sum(all_subj_remove2s_right_kept_raw{7,subject});
                all_subj_remove2s_right_kept_raw{3,subject} = nansum(all_subj_remove2s_right_kept_raw{3,subject});
                all_avg_remove2s_unaware_right_raw = [all_avg_remove2s_unaware_right_raw; all_subj_remove2s_right_kept_raw{3,subject}];
        
                all_subj_remove2s_right_kept_raw{4,subject}(1,:) = all_subj_remove2s_right_kept_raw{4,subject}(1,:) * all_subj_remove2s_right_kept_raw{8,subject}(1) / sum(all_subj_remove2s_right_kept_raw{8,subject});
                all_subj_remove2s_right_kept_raw{4,subject}(2,:) = all_subj_remove2s_right_kept_raw{4,subject}(2,:) * all_subj_remove2s_right_kept_raw{8,subject}(2) / sum(all_subj_remove2s_right_kept_raw{8,subject});
                all_subj_remove2s_right_kept_raw{4,subject} = nansum(all_subj_remove2s_right_kept_raw{4,subject});
        
                all_subj_remove2s_right_kept_raw{5,subject}(1,:) = all_subj_remove2s_right_kept_raw{5,subject}(1,:) * all_subj_remove2s_right_kept_raw{9,subject}(1) / sum(all_subj_remove2s_right_kept_raw{9,subject});
                all_subj_remove2s_right_kept_raw{5,subject}(2,:) = all_subj_remove2s_right_kept_raw{5,subject}(2,:) * all_subj_remove2s_right_kept_raw{9,subject}(2) / sum(all_subj_remove2s_right_kept_raw{9,subject});
                all_subj_remove2s_right_kept_raw{5,subject} = nansum(all_subj_remove2s_right_kept_raw{5,subject});
%             catch
%                 disp(['Subject overflow, ' num2str(subject)])
%             end
    elseif length(all_subj_remove2s_right_kept{6,subject}) == 1
%         try
            all_avg_remove2s_aware_right = [all_avg_remove2s_aware_right; all_subj_remove2s_right_kept{2,subject}];
            all_avg_remove2s_unaware_right = [all_avg_remove2s_unaware_right; all_subj_remove2s_right_kept{3,subject}];
            all_avg_remove2s_aware_right_raw = [all_avg_remove2s_aware_right_raw; all_subj_remove2s_right_kept_raw{2,subject}];
            all_avg_remove2s_unaware_right_raw = [all_avg_remove2s_unaware_right_raw; all_subj_remove2s_right_kept_raw{3,subject}];
%         catch
%             disp(['Subject overflow, ' num2str(subject)])
%         end
    end
end
            
    
        
    



%% Plot Z-Score Pupil Dilation
% load([root '/timecourse_cluster_aware_eye_left_E1_5000perm_zscore.mat'])
sig_time_pts_aware = nan(1,8000);
% sig_time_pts_aware(sig_time_pts+2000) = 0.95;

% load([root '/timecourse_cluster_unaware_eye_left_E1_5000perm_zscore.mat'])
sig_time_pts_unaware = nan(1,8000);
% sig_time_pts_unaware(sig_time_pts+2000) = 0.9;

aware_SEM = zeros(1,8000);
unaware_SEM = zeros(1,8000);
mean_aware_pupil = mean(all_avg_pupil_aware_left);
mean_unaware_pupil = mean(all_avg_pupil_unaware_left);
for point = 1:length(mean_aware_pupil)
    aware_SEM(point) = std(all_avg_pupil_aware_left(:,point))/ sqrt(size(all_avg_pupil_aware_left,1));
    unaware_SEM(point) = std(all_avg_pupil_unaware_left(:,point))/ sqrt(size(all_avg_pupil_unaware_left,1));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end
figure

hold on
patch([-3999:4000 fliplr(-3999:4000)], [mean_aware_pupil-aware_SEM fliplr(mean_aware_pupil+aware_SEM)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-3999:4000 fliplr(-3999:4000)], [mean_unaware_pupil-unaware_SEM fliplr(mean_unaware_pupil+unaware_SEM)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
plot(-3999:4000,mean(all_avg_pupil_aware_left),'Color','blue','LineWidth',5)
plot(-3999:4000,mean(all_avg_pupil_unaware_left),'Color',[1 0.7 0],'LineWidth',5)
plot(-3999:4000,sig_time_pts_aware,'LineWidth',5,'Color','blue')
plot(-3999:4000,sig_time_pts_unaware,'LineWidth',5,'Color',[1 0.7 0])
xlim([-2000 2000])
title(['Left Pupil Diameter, Z-Scored to Run Baseline, N = ' num2str(size(all_avg_pupil_aware_left,1))])
set(gca,'FontSize',24)
ylabel('Pupil Diameter Z-Score')
legend({'Aware','Unaware'})%,'Aware Significant Timepoints','Unaware Significant Timepoints'})
%yyaxis right
% ax = gca;
% ax.YAxis(1).Visible = 'off';
% ax.YAxis(2).Color = 'black';



% load([root '/timecourse_cluster_aware_eye_right_E1_5000perm_zscore.mat'])
sig_time_pts_aware = nan(1,8000);
% sig_time_pts_aware(sig_time_pts+2000) = 0.95;


% load([root '/timecourse_cluster_unaware_eye_right_E1_5000perm_zscore.mat'])
sig_time_pts_unaware = nan(1,8000);
% sig_time_pts_unaware(sig_time_pts+2000) = 0.9;

mean_aware_pupil = mean(all_avg_pupil_aware_right);
mean_unaware_pupil = mean(all_avg_pupil_unaware_right);
for point = 1:length(mean_aware_pupil)
    aware_SEM(point) = std(all_avg_pupil_aware_right(:,point))/ sqrt(size(all_avg_pupil_aware_right,1));
    unaware_SEM(point) = std(all_avg_pupil_unaware_right(:,point))/ sqrt(size(all_avg_pupil_unaware_right,1));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end

figure
hold on
patch([-3999:4000 fliplr(-3999:4000)], [mean_aware_pupil-aware_SEM fliplr(mean_aware_pupil+aware_SEM)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-3999:4000 fliplr(-3999:4000)], [mean_unaware_pupil-unaware_SEM fliplr(mean_unaware_pupil+unaware_SEM)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
plot(-3999:4000,mean(all_avg_pupil_aware_right),'Color','blue','LineWidth',5)
plot(-3999:4000,mean(all_avg_pupil_unaware_right),'Color',[1 0.7 0],'LineWidth',5)
plot(-3999:4000,sig_time_pts_aware,'LineWidth',5,'Color','blue')
plot(-3999:4000,sig_time_pts_unaware,'LineWidth',5,'Color',[1 0.7 0])
xlim([-4000 2000])

title(['Right Pupil Diameter, Z-Scored to Run Baseline, N = ' num2str(size(all_avg_pupil_aware_right,1))])
set(gca,'FontSize',24)
xlabel(['Time from Confirm (ms)'])
ylabel(['Pupil Diameter Z-Score'])
legend({'Aware','Unaware','Aware Significant Timepoints','Unaware Significant Timepoints'})
%yyaxis right
% ax = gca;
% ax.YAxis(1).Visible = 'off';
% ax.YAxis(2).Color = 'black';

all_subj_pupil_data_in_common_left_aware = [];
all_subj_pupil_data_in_common_right_aware = [];
all_subj_pupil_data_in_common_left_unaware = [];
all_subj_pupil_data_in_common_right_unaware = [];


for subjleft = 1:size(all_avg_pupil_aware_left,1)
    for subjright = 1:size(all_avg_pupil_aware_right,1)
        if strcmp(all_subj_left_kept{1,subjleft},all_subj_right_kept{1,subjright})
            all_subj_pupil_data_in_common_left_aware = [all_subj_pupil_data_in_common_left_aware; all_avg_pupil_aware_left(subjleft,:)];
            all_subj_pupil_data_in_common_left_unaware = [all_subj_pupil_data_in_common_left_unaware; all_avg_pupil_unaware_left(subjleft,:)];
            all_subj_pupil_data_in_common_right_aware = [all_subj_pupil_data_in_common_right_aware; all_avg_pupil_aware_right(subjright,:)];
            all_subj_pupil_data_in_common_right_unaware = [all_subj_pupil_data_in_common_right_unaware; all_avg_pupil_unaware_right(subjright,:)];
        end
    end
end



mean_aware_pupil = mean(all_subj_pupil_data_in_common_left_aware);
mean_unaware_pupil = mean(all_subj_pupil_data_in_common_left_unaware);
for point = 1:length(mean_aware_pupil)
    aware_SEM(point) = std(all_subj_pupil_data_in_common_left_aware(:,point))/ sqrt(size(all_subj_pupil_data_in_common_left_aware,1));
    unaware_SEM(point) = std(all_subj_pupil_data_in_common_left_unaware(:,point))/ sqrt(size(all_subj_pupil_data_in_common_left_unaware,1));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end
figure
hold on
patch([-3999:4000 fliplr(-3999:4000)], [mean_aware_pupil-aware_SEM fliplr(mean_aware_pupil+aware_SEM)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-3999:4000 fliplr(-3999:4000)], [mean_unaware_pupil-unaware_SEM fliplr(mean_unaware_pupil+unaware_SEM)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
plot(-3999:4000,mean(all_subj_pupil_data_in_common_left_aware),'Color','blue','LineWidth',5)
plot(-3999:4000,mean(all_subj_pupil_data_in_common_left_unaware),'Color',[1 0.7 0],'LineWidth',5)
xlim([-4000 2000])
title(['Left Pupil Diameter, Z-Scored to Run Baseline, Common Subset, N = ' num2str(size(all_subj_pupil_data_in_common_left_aware,1))])
set(gca,'FontSize',24)
xlabel(['Time from Confirm (ms)'])
ylabel(['Pupil Diameter Z-Score'])
legend({'Aware','Unaware'})
%yyaxis right
% ax = gca;
% ax.YAxis(1).Visible = 'off';
% ax.YAxis(2).Color = 'black';
mean_aware_pupil = mean(all_subj_pupil_data_in_common_right_aware);
mean_unaware_pupil = mean(all_subj_pupil_data_in_common_right_unaware);
for point = 1:length(mean_aware_pupil)
    aware_SEM(point) = std(all_subj_pupil_data_in_common_right_aware(:,point))/ sqrt(size(all_subj_pupil_data_in_common_right_aware,1));
    unaware_SEM(point) = std(all_subj_pupil_data_in_common_right_unaware(:,point))/ sqrt(size(all_subj_pupil_data_in_common_right_unaware,1));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end
figure
hold on
patch([-3999:4000 fliplr(-3999:4000)], [mean_aware_pupil-aware_SEM fliplr(mean_aware_pupil+aware_SEM)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-3999:4000 fliplr(-3999:4000)], [mean_unaware_pupil-unaware_SEM fliplr(mean_unaware_pupil+unaware_SEM)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
plot(-3999:4000,mean(all_subj_pupil_data_in_common_right_aware),'Color','blue','LineWidth',5)
plot(-3999:4000,mean(all_subj_pupil_data_in_common_right_unaware),'Color',[1 0.7 0],'LineWidth',5)
xlim([-4000 2000])
title(['Right Pupil Diameter, Z-Scored to Run Baseline, Common Subset, N = ' num2str(size(all_subj_pupil_data_in_common_right_aware,1))])
set(gca,'FontSize',24)
xlabel(['Time from Confirm (ms)'])
ylabel(['Pupil Diameter Z-Score'])
legend({'Aware','Unaware'})
%yyaxis right
% ax = gca;
% ax.YAxis(1).Visible = 'off';
% ax.YAxis(2).Color = 'black';


%% Plot Saccade Onset Rate

% load('timecourse_cluster_aware_minus_unaware_eye_right_E1_5000perm_sac.mat')
% sig_time_pts_right = nan(1,4000);
% sig_time_pts_right(sig_time_pts) = 2.9;

% load('timecourse_cluster_aware_minus_unaware_eye_left_E1_5000perm_sac.mat')
% sig_time_pts_left = nan(1,4000);
% sig_time_pts_left(sig_time_pts) = 2.9;
%mean_aware_sac = lowpass(mean(all_avg_sac_aware_left),0.1,1000)*100;
%mean_unaware_sac = lowpass(mean(all_avg_sac_unaware_left),0.1,1000)*100;
mean_aware_sac = mean(all_avg_sac_aware_left);
mean_unaware_sac = mean(all_avg_sac_unaware_left);
for point = 1:length(mean_aware_sac)
    aware_SEM_sac(point) = std(all_avg_sac_aware_left(:,point))/ sqrt(size(all_avg_sac_aware_left,1));
    unaware_SEM_sac(point) = std(all_avg_sac_unaware_left(:,point))/ sqrt(size(all_avg_sac_unaware_left,1));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end
%aware_SEM_sac = lowpass(aware_SEM_sac,0.1,1000)*100;
%unaware_SEM_sac = lowpass(unaware_SEM_sac,0.1,1000)*100;
figure
hold on
% plot(-1999:2000,sig_time_pts_left,'LineWidth',5,'Color','green')
patch([-7999:8000 fliplr(-7999:8000)], [mean_aware_sac-aware_SEM_sac fliplr(mean_aware_sac+aware_SEM_sac)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-7999:8000 fliplr(-7999:8000)], [mean_unaware_sac-unaware_SEM_sac fliplr(mean_unaware_sac+unaware_SEM_sac)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
plot(-7999:8000,mean_aware_sac,'Color','blue','LineWidth',5)
plot(-7999:8000,mean_unaware_sac,'Color',[1 0.7 0],'LineWidth',5)
xlim([-6000 2000])
ylim([0 3])
title(['Left Eye Saccade Rate'])
set(gca,'FontSize',24)
legend({'Aware minus Unaware','Aware','Unaware'})
xlabel('Time from Confirm (ms)')
ylabel('Saccades per Second')
all_avg_sac_aware_temp = all_avg_sac_aware_right;
all_avg_sac_unaware_temp = all_avg_sac_unaware_right;
for subject = 1:size(all_avg_sac_aware_temp)
    for timepoint = 6000-(binsize/2+1):10000+(binsize/2)
        all_avg_sac_aware_temp(subject,timepoint) = mean(all_avg_sac_aware_temp(subject,timepoint-(binsize/2):timepoint+(binsize/2-1)));
        all_avg_sac_unaware_temp(subject,timepoint) = mean(all_avg_sac_unaware_temp(subject,timepoint-(binsize/2):timepoint+(binsize/2-1)));

    end
end


%mean_aware_sac = lowpass(mean(all_avg_sac_aware_left),0.1,1000)*100;
%mean_unaware_sac = lowpass(mean(all_avg_sac_unaware_left),0.1,1000)*100;
mean_aware_sac = mean(all_avg_sac_aware_right);
mean_unaware_sac = mean(all_avg_sac_unaware_right);
for point = 1:length(mean_aware_sac)
    aware_SEM_sac(point) = std(all_avg_sac_aware_temp(:,point))/ sqrt(size(all_avg_sac_aware_temp,1));
    unaware_SEM_sac(point) = std(all_avg_sac_unaware_temp(:,point))/ sqrt(size(all_avg_sac_unaware_temp,1));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end
%aware_SEM_sac = lowpass(aware_SEM_sac,0.1,1000)*100;
%unaware_SEM_sac = lowpass(unaware_SEM_sac,0.1,1000)*100;
figure
hold on
plot(-1999:2000,sig_time_pts_right,'LineWidth',5,'Color','green')
patch([-7999:8000 fliplr(-7999:8000)], [mean_aware_sac-aware_SEM_sac fliplr(mean_aware_sac+aware_SEM_sac)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-7999:8000 fliplr(-7999:8000)], [mean_unaware_sac-unaware_SEM_sac fliplr(mean_unaware_sac+unaware_SEM_sac)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
plot(-7999:8000,mean_aware_sac,'Color','blue','LineWidth',5)
plot(-7999:8000,mean_unaware_sac,'Color',[1 0.7 0],'LineWidth',5)
xlim([-6000 2000])
ylim([0 3])
title(['Right Eye Saccade Rate'])
xlabel('Time from Confirm (ms)')
ylabel('Saccades per Second')
set(gca,'FontSize',24)
legend({'Aware minus Unaware','Aware','Unaware'})

%% Plot Saccade %



%mean_aware_sac = lowpass(mean(all_avg_sac_rate_aware_left),0.1,1000)*100;
%mean_unaware_sac = lowpass(mean(all_avg_sac_rate_unaware_left),0.1,1000)*100;
mean_aware_sac = mean(all_avg_sac_rate_aware_left)*100;
mean_unaware_sac = mean(all_avg_sac_rate_unaware_left)*100;
for point = 1:length(mean_aware_sac)
    aware_SEM_sac(point) = std(all_avg_sac_rate_aware_left(:,point)*100)/ sqrt(size(all_avg_sac_rate_aware_left,1));
    unaware_SEM_sac(point) = std(all_avg_sac_rate_unaware_left(:,point)*100)/ sqrt(size(all_avg_sac_rate_unaware_left,1));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end
%aware_SEM_sac = lowpass(aware_SEM_sac,0.1,1000)*100;
%unaware_SEM_sac = lowpass(unaware_SEM_sac,0.1,1000)*100;
figure
hold on
patch([-7999:8000 fliplr(-7999:8000)], [mean_aware_sac-aware_SEM_sac fliplr(mean_aware_sac+aware_SEM_sac)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-7999:8000 fliplr(-7999:8000)], [mean_unaware_sac-unaware_SEM_sac fliplr(mean_unaware_sac+unaware_SEM_sac)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
plot(-7999:8000,mean_aware_sac,'Color','blue','LineWidth',5)
plot(-7999:8000,mean_unaware_sac,'Color',[1 0.7 0],'LineWidth',5)
xlim([-6000 2000])
ylim([0 10])
title(['Left Eye Saccade Percentage'])
set(gca,'FontSize',24)
legend({'Aware','Unaware'})
xlabel('Time from Confirm (ms)')
ylabel('Percentage of Trials (%)')
all_avg_sac_rate_aware_temp = all_avg_sac_rate_aware_right;
all_avg_sac_rate_unaware_temp = all_avg_sac_rate_unaware_right;



%mean_aware_sac = lowpass(mean(all_avg_sac_rate_aware_left),0.1,1000)*100;
%mean_unaware_sac = lowpass(mean(all_avg_sac_rate_unaware_left),0.1,1000)*100;
mean_aware_sac = mean(all_avg_sac_rate_aware_right)*100;
mean_unaware_sac = mean(all_avg_sac_rate_unaware_right)*100;
for point = 1:length(mean_aware_sac)
    aware_SEM_sac(point) = std(all_avg_sac_rate_aware_temp(:,point)*100)/ sqrt(size(all_avg_sac_rate_aware_temp,1));
    unaware_SEM_sac(point) = std(all_avg_sac_rate_unaware_temp(:,point)*100)/ sqrt(size(all_avg_sac_rate_unaware_temp,1));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end
%aware_SEM_sac = lowpass(aware_SEM_sac,0.1,1000)*100;
%unaware_SEM_sac = lowpass(unaware_SEM_sac,0.1,1000)*100;
figure
hold on
patch([-7999:8000 fliplr(-7999:8000)], [mean_aware_sac-aware_SEM_sac fliplr(mean_aware_sac+aware_SEM_sac)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-7999:8000 fliplr(-7999:8000)], [mean_unaware_sac-unaware_SEM_sac fliplr(mean_unaware_sac+unaware_SEM_sac)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
plot(-7999:8000,mean_aware_sac,'Color','blue','LineWidth',5)
plot(-7999:8000,mean_unaware_sac,'Color',[1 0.7 0],'LineWidth',5)
xlim([-6000 2000])
ylim([0 10])
title(['Right Eye Saccade Percentage'])
xlabel('Time from Confirm (ms)')
ylabel('Percentage of Trials (%)')
set(gca,'FontSize',24)
legend({'Aware','Unaware'})


%%

% timecourse = 1:1000;
% all_pupil_aware_left_cut = all_avg_pupil_aware_left(:,3001:4000);
% all_pupil_unaware_left_cut = all_avg_pupil_unaware_left(:,3001:4000);
% aware_slopes = [];
% unaware_slopes = [];
% for subject = 1:size(all_avg_pupil_aware_left,1)
%     aware_fit = fitlm(timecourse,all_pupil_aware_left_cut(subject,:));
%     aware_coeffs = table2array(aware_fit.Coefficients);
%     aware_slopes = [aware_slopes aware_coeffs(2,1)];
%     unaware_fit = fitlm(timecourse,all_pupil_unaware_left_cut(subject,:));
%     unaware_coeffs = table2array(unaware_fit.Coefficients);
%     unaware_slopes = [unaware_slopes unaware_coeffs(2,1)];
% end

%%

all_avg_sac_aware_left_post = (all_avg_sac_aware_left(:,8750:9250));
all_avg_sac_unaware_left_post = (all_avg_sac_unaware_left(:,8750:9250));
max_saccades_aware_left = zeros(1,size(all_avg_sac_aware_left_post,1));
max_saccades_unaware_left = zeros(1,size(all_avg_sac_unaware_left_post,1));
for subject = 1:size(all_avg_sac_aware_left_post,1)
    
    max_saccades_aware_left(subject) = max(all_avg_sac_aware_left_post(subject,:));
    max_saccades_unaware_left(subject) = max(all_avg_sac_unaware_left_post(subject,:));
end

figure;
hold on
boxplot([max_saccades_aware_left max_saccades_unaware_left]',[ones(1,length(max_saccades_aware_left)) 2*ones(1,length(max_saccades_unaware_left))],'labels',{'Aware','Unaware'})


% for point = 1:length(max_saccades_aware_left)
%     if max_saccades_aware_left(point) < quantile(max_saccades_aware_left,0.25) - 1.5*iqr(max_saccades_aware_left) || max_saccades_aware_left(point) > quantile(max_saccades_aware_left,0.75) + 1.5*iqr(max_saccades_aware_left) || max_saccades_aware_left(point) == max(max_saccades_aware_left) || max_saccades_aware_left(point) == min(max_saccades_aware_left)
%         scatter(1,max_saccades_aware_left(point),'MarkerFaceColor',[0 0 1],'MarkerEdgeColor',[0 0 1],'SizeData',150)
%     else
%         scatter(1,max_saccades_aware_left(point),'MarkerFaceColor',[0 0 1],'MarkerEdgeColor',[0 0 1],'SizeData',150,'jitter','on','jitteramount',0.075)
%     end
% end
% 
% for point = 1:length(max_saccades_unaware_left)
%     if max_saccades_unaware_left(point) < quantile(max_saccades_unaware_left,0.25) - 1.5*iqr(max_saccades_unaware_left) || max_saccades_unaware_left(point) > quantile(max_saccades_unaware_left,0.75) + 1.5*iqr(max_saccades_unaware_left) || max_saccades_unaware_left(point) == max(max_saccades_unaware_left) || max_saccades_unaware_left(point) == min(max_saccades_unaware_left)
%         scatter(2,max_saccades_unaware_left(point),'MarkerFaceColor',[1 0.7 0],'MarkerEdgeColor',[1 0.7 0],'SizeData',150)
%     else
%         scatter(2,max_saccades_unaware_left(point),'MarkerFaceColor',[1 0.7 0],'MarkerEdgeColor',[1 0.7 0],'SizeData',150,'jitter','on','jitteramount',0.075)
%     end
% end


swarmchart(ones(1,length(max_saccades_aware_left)),max_saccades_aware_left,'filled','XJitterWidth',0.3,'MarkerFaceColor',[0 0 1],'MarkerEdgeColor',[0 0 1],'SizeData',150)
swarmchart(ones(1,length(max_saccades_unaware_left))*2,max_saccades_unaware_left,'filled','XJitterWidth',0.3,'MarkerFaceColor',[1 0.7 0],'MarkerEdgeColor',[1 0.7 0],'SizeData',150)
ylim([0 4.5])


ylabel('Saccades Per Second')
title('Post-Board Disappearance Saccade Rate Peak, Left Eye')

set(gca,'FontSize',24)



all_avg_sac_aware_right_post = (all_avg_sac_aware_right(:,8750:9250));
all_avg_sac_unaware_right_post = (all_avg_sac_unaware_right(:,8750:9250));
max_saccades_aware_right = zeros(1,size(all_avg_sac_aware_right_post,1));
max_saccades_unaware_right = zeros(1,size(all_avg_sac_unaware_right_post,1));
for subject = 1:size(all_avg_sac_aware_right_post,1)
    
    max_saccades_aware_right(subject) = max(all_avg_sac_aware_right_post(subject,:));
    max_saccades_unaware_right(subject) = max(all_avg_sac_unaware_right_post(subject,:));
end

figure;
hold on
boxplot([max_saccades_aware_right max_saccades_unaware_right]',[ones(1,length(max_saccades_aware_right)) 2*ones(1,length(max_saccades_unaware_right))],'labels',{'Aware','Unaware'})
% for point = 1:length(max_saccades_aware_right)
%     if max_saccades_aware_right(point) < quantile(max_saccades_aware_right,0.25) - 1.5*iqr(max_saccades_aware_right) || max_saccades_aware_right(point) > quantile(max_saccades_aware_right,0.75) + 1.5*iqr(max_saccades_aware_right) || max_saccades_aware_right(point) == max(max_saccades_aware_right) || max_saccades_aware_right(point) == min(max_saccades_aware_right)
%         scatter(1,max_saccades_aware_right(point),'MarkerFaceColor',[0 0 1],'MarkerEdgeColor',[0 0 1],'SizeData',150)
%     else
%         scatter(1,max_saccades_aware_right(point),'MarkerFaceColor',[0 0 1],'MarkerEdgeColor',[0 0 1],'SizeData',150,'jitter','on','jitteramount',0.075)
%     end
% end

% for point = 1:length(max_saccades_unaware_right)
%     if max_saccades_unaware_right(point) < quantile(max_saccades_unaware_right,0.25) - 1.5*iqr(max_saccades_unaware_right) || max_saccades_unaware_right(point) > quantile(max_saccades_unaware_right,0.75) + 1.5*iqr(max_saccades_unaware_right) || max_saccades_unaware_right(point) == max(max_saccades_unaware_right) || max_saccades_unaware_right(point) == min(max_saccades_unaware_right)
%         scatter(2,max_saccades_unaware_right(point),'MarkerFaceColor',[1 0.7 0],'MarkerEdgeColor',[1 0.7 0],'SizeData',150)
%     else
%         scatter(2,max_saccades_unaware_right(point),'MarkerFaceColor',[1 0.7 0],'MarkerEdgeColor',[1 0.7 0],'SizeData',150,'jitter','on','jitteramount',0.2)
%     end
% end

swarmchart(ones(1,length(max_saccades_aware_right)),max_saccades_aware_right,'filled','XJitterWidth',0.3,'MarkerFaceColor',[0 0 1],'MarkerEdgeColor',[0 0 1],'SizeData',150)
swarmchart(ones(1,length(max_saccades_unaware_right))*2,max_saccades_unaware_right,'filled','XJitterWidth',0.3,'MarkerFaceColor',[1 0.7 0],'MarkerEdgeColor',[1 0.7 0],'SizeData',150)
ylim([0 4.5])

ylabel('Saccades Per Second')
title('Post-Board Disappearance Saccade Rate Peak, Right Eye')

set(gca,'FontSize',24)

%% Plot average normal blink rate

%mean_aware_blink = lowpass(mean(all_avg_blink_aware_left),0.1,1000)*100;
%mean_unaware_blink = lowpass(mean(all_avg_blink_unaware_left),0.1,1000)*100;
mean_aware_blink = mean(all_avg_blink_aware_left)*100;
mean_unaware_blink = mean(all_avg_blink_unaware_left)*100;
for point = 1:length(mean_aware_blink)
    aware_SEM_blink(point) = std(all_avg_blink_aware_left(:,point)*100)/ sqrt(size(all_avg_blink_aware_left,1));
    unaware_SEM_blink(point) = std(all_avg_blink_unaware_left(:,point)*100)/ sqrt(size(all_avg_blink_unaware_left,1));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end
%aware_SEM_blink = lowpass(aware_SEM_blink,0.1,1000)*100;
%unaware_SEM_blink = lowpass(unaware_SEM_blink,0.1,1000)*100;
figure
hold on
patch([-7999:8000 fliplr(-7999:8000)], [mean_aware_blink-aware_SEM_blink fliplr(mean_aware_blink+aware_SEM_blink)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-7999:8000 fliplr(-7999:8000)], [mean_unaware_blink-unaware_SEM_blink fliplr(mean_unaware_blink+unaware_SEM_blink)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
plot(-7999:8000,mean_aware_blink,'Color','blue','LineWidth',5)
plot(-7999:8000,mean_unaware_blink,'Color',[1 0.7 0],'LineWidth',5)
xlim([-6000 2000])
ylim([0 30])
title(['Left Eye Blink Rate'])
ylabel(['Blink Rate (%)'])
xlabel(['Time from Confirm'])
set(gca,'FontSize',24)
legend({'Aware','Unaware'})

all_avg_blink_aware_temp = all_avg_blink_aware_right;
all_avg_blink_unaware_temp = all_avg_blink_unaware_right;
for subject = 1:size(all_avg_blink_aware_temp)
    for timepoint = 6000-(binsize/2+1):10000+(binsize/2)
        all_avg_blink_aware_temp(subject,timepoint) = mean(all_avg_blink_aware_temp(subject,timepoint-(binsize/2):timepoint+(binsize/2-1)));
        all_avg_blink_unaware_temp(subject,timepoint) = mean(all_avg_blink_unaware_temp(subject,timepoint-(binsize/2):timepoint+(binsize/2-1)));

    end
end


%mean_aware_blink = lowpass(mean(all_avg_blink_aware_left),0.1,1000)*100;
%mean_unaware_blink = lowpass(mean(all_avg_blink_unaware_left),0.1,1000)*100;
mean_aware_blink = mean(all_avg_blink_aware_right)*100;
mean_unaware_blink = mean(all_avg_blink_unaware_right)*100;
for point = 1:length(mean_aware_blink)
    aware_SEM_blink(point) = std(all_avg_blink_aware_temp(:,point)*100)/ sqrt(size(all_avg_blink_aware_temp,1));
    unaware_SEM_blink(point) = std(all_avg_blink_unaware_temp(:,point)*100)/ sqrt(size(all_avg_blink_unaware_temp,1));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end
%aware_SEM_blink = lowpass(aware_SEM_blink,0.1,1000)*100;
%unaware_SEM_blink = lowpass(unaware_SEM_blink,0.1,1000)*100;
figure
hold on
patch([-7999:8000 fliplr(-7999:8000)], [mean_aware_blink-aware_SEM_blink fliplr(mean_aware_blink+aware_SEM_blink)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-7999:8000 fliplr(-7999:8000)], [mean_unaware_blink-unaware_SEM_blink fliplr(mean_unaware_blink+unaware_SEM_blink)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
plot(-7999:8000,mean_aware_blink,'Color','blue','LineWidth',5)
plot(-7999:8000,mean_unaware_blink,'Color',[1 0.7 0],'LineWidth',5)
xlim([-6000 2000])
ylim([0 30])
title(['Right Eye Blink Rate'])
set(gca,'FontSize',24)
legend({'Aware','Unaware'})
ylabel(['Blink Rate (%)'])
xlabel(['Time from Confirm'])

%% Plot average long blink rate

% load([root '/timecourse_cluster_aware_vs_unaware_eye_left_E1_5000perm_long_blink.mat'])
sig_time_pts_versus = nan(1,16000);
% sig_time_pts_versus(sig_time_pts+6000) = 10;

%mean_aware_long_blink = lowpass(mean(all_avg_long_blink_aware_left),0.1,1000)*100;
%mean_unaware_long_blink = lowpass(mean(all_avg_long_blink_unaware_left),0.1,1000)*100;
mean_aware_long_blink = mean(all_avg_long_blink_aware_left)*100;
mean_unaware_long_blink = mean(all_avg_long_blink_unaware_left)*100;
for point = 1:length(mean_aware_long_blink)
    aware_SEM_long_blink(point) = std(all_avg_long_blink_aware_left(:,point)*100)/ sqrt(size(all_avg_long_blink_aware_left,1));
    unaware_SEM_long_blink(point) = std(all_avg_long_blink_unaware_left(:,point)*100)/ sqrt(size(all_avg_long_blink_unaware_left,1));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end
%aware_SEM_long_blink = lowpass(aware_SEM_long_blink,0.1,1000)*100;
%unaware_SEM_long_blink = lowpass(unaware_SEM_long_blink,0.1,1000)*100;
figure
hold on
patch([-7999:8000 fliplr(-7999:8000)], [mean_aware_long_blink-aware_SEM_long_blink fliplr(mean_aware_long_blink+aware_SEM_long_blink)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-7999:8000 fliplr(-7999:8000)], [mean_unaware_long_blink-unaware_SEM_long_blink fliplr(mean_unaware_long_blink+unaware_SEM_long_blink)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
plot(-7999:8000,sig_time_pts_versus,'Color','green','LineWidth',5)
plot(-7999:8000,mean_aware_long_blink,'Color','blue','LineWidth',5)
plot(-7999:8000,mean_unaware_long_blink,'Color',[1 0.7 0],'LineWidth',5)

xlim([-6000 2000])
ylim([0 30])
title(['Left Eye Long Blink Rate'])
ylabel(['Long Blink Rate (%)'])
xlabel(['Time from Confirm'])
set(gca,'FontSize',24)
legend({'Aware','Unaware','Aware vs. Unaware Significant Timepoints'})

all_avg_long_blink_aware_temp = all_avg_long_blink_aware_right;
all_avg_long_blink_unaware_temp = all_avg_long_blink_unaware_right;
% for subject = 1:size(all_avg_long_blink_aware_temp)
%     for timepoint = 6000-(binsize/2+1):10000+(binsize/2)
%         all_avg_long_blink_aware_temp(subject,timepoint) = mean(all_avg_long_blink_aware_temp(subject,timepoint-(binsize/2):timepoint+(binsize/2-1)));
%         all_avg_long_blink_unaware_temp(subject,timepoint) = mean(all_avg_long_blink_unaware_temp(subject,timepoint-(binsize/2):timepoint+(binsize/2-1)));
% 
%     end
% end

% load([root '/timecourse_cluster_aware_vs_unaware_eye_right_E1_5000perm_long_blink.mat'])
sig_time_pts_versus = nan(1,16000);
% sig_time_pts_versus(sig_time_pts+6000) = 10;

%mean_aware_long_blink = lowpass(mean(all_avg_long_blink_aware_left),0.1,1000)*100;
%mean_unaware_long_blink = lowpass(mean(all_avg_long_blink_unaware_left),0.1,1000)*100;
mean_aware_long_blink = mean(all_avg_long_blink_aware_right)*100;
mean_unaware_long_blink = mean(all_avg_long_blink_unaware_right)*100;
for point = 1:length(mean_aware_long_blink)
    aware_SEM_long_blink(point) = std(all_avg_long_blink_aware_temp(:,point)*100)/ sqrt(size(all_avg_long_blink_aware_temp,1));
    unaware_SEM_long_blink(point) = std(all_avg_long_blink_unaware_temp(:,point)*100)/ sqrt(size(all_avg_long_blink_unaware_temp,1));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end
%aware_SEM_long_blink = lowpass(aware_SEM_long_blink,0.1,1000)*100;
%unaware_SEM_long_blink = lowpass(unaware_SEM_long_blink,0.1,1000)*100;
figure
hold on
patch([-7999:8000 fliplr(-7999:8000)], [mean_aware_long_blink-aware_SEM_long_blink fliplr(mean_aware_long_blink+aware_SEM_long_blink)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-7999:8000 fliplr(-7999:8000)], [mean_unaware_long_blink-unaware_SEM_long_blink fliplr(mean_unaware_long_blink+unaware_SEM_long_blink)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
plot(-7999:8000,sig_time_pts_versus,'Color','green','LineWidth',5)
plot(-7999:8000,mean_aware_long_blink,'Color','blue','LineWidth',5)
plot(-7999:8000,mean_unaware_long_blink,'Color',[1 0.7 0],'LineWidth',5)

xlim([-6000 2000])
ylim([0 30])
title(['Right Eye Long Blink Rate'])
set(gca,'FontSize',24)
legend({'Aware','Unaware','Aware vs. Unaware Significant Timepoints'})
ylabel(['Long Blink Rate (%)'])
xlabel(['Time from Confirm'])

%% Nonoverlapping binned long blinks

aware_SEM_long_blink = zeros(1,16);
unaware_SEM_long_blink = zeros(1,16);

%mean_aware_long_blink = lowpass(mean(all_avg_long_blink_aware_left_bin),0.1,1000);
%mean_unaware_long_blink = lowpass(mean(all_avg_long_blink_unaware_left_bin),0.1,1000);
mean_aware_long_blink_bin = mean(all_avg_long_blink_aware_left_bin);
mean_unaware_long_blink_bin = mean(all_avg_long_blink_unaware_left_bin);
for point = 1:length(mean_aware_long_blink_bin)
    aware_SEM_long_blink(point) = std(all_avg_long_blink_aware_left_bin(:,point))/ sqrt(size(all_avg_long_blink_aware_left_bin,1));
    unaware_SEM_long_blink(point) = std(all_avg_long_blink_unaware_left_bin(:,point))/ sqrt(size(all_avg_long_blink_unaware_left_bin,1));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end
%aware_SEM_long_blink = lowpass(aware_SEM_long_blink,0.1,1000);
%unaware_SEM_long_blink = lowpass(unaware_SEM_long_blink,0.1,1000);
figure
hold on
patch([-7:8 fliplr(-7:8)], [mean_aware_long_blink_bin-aware_SEM_long_blink fliplr(mean_aware_long_blink_bin+aware_SEM_long_blink)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-7:8 fliplr(-7:8)], [mean_unaware_long_blink_bin-unaware_SEM_long_blink fliplr(mean_unaware_long_blink_bin+unaware_SEM_long_blink)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
plot(-7:8,mean_aware_long_blink_bin,'Color','blue','LineWidth',5)
plot(-7:8,mean_unaware_long_blink_bin,'Color',[1 0.7 0],'LineWidth',5)
xlim([-7 2])
ylim([0 0.15])
title(['Left Eye Long Blink Onsets'])
ylabel(['Long Blink Onsets per Second'])
xlabel(['Time from Confirm'])
set(gca,'FontSize',24)
legend({'Aware','Unaware'})

% all_avg_long_blink_aware_temp = all_avg_long_blink_aware_right_bin;
% all_avg_long_blink_unaware_temp = all_avg_long_blink_unaware_right;
% for subject = 1:size(all_avg_long_blink_aware_temp)
%     for timepoint = 6000-(binsize/2+1):10000+(binsize/2)
%         all_avg_long_blink_aware_temp(subject,timepoint) = mean(all_avg_long_blink_aware_temp(subject,timepoint-(binsize/2):timepoint+(binsize/2-1)));
%         all_avg_long_blink_unaware_temp(subject,timepoint) = mean(all_avg_long_blink_unaware_temp(subject,timepoint-(binsize/2):timepoint+(binsize/2-1)));
% 
%     end
% end


%mean_aware_long_blink = lowpass(mean(all_avg_long_blink_aware_left_bin),0.1,1000);
%mean_unaware_long_blink = lowpass(mean(all_avg_long_blink_unaware_left_bin),0.1,1000);
mean_aware_long_blink_bin = mean(all_avg_long_blink_aware_right_bin);
mean_unaware_long_blink_bin = mean(all_avg_long_blink_unaware_right_bin);
for point = 1:length(mean_aware_long_blink_bin)
    aware_SEM_long_blink(point) = std(all_avg_long_blink_aware_temp(:,point))/ sqrt(size(all_avg_long_blink_aware_temp,1));
    unaware_SEM_long_blink(point) = std(all_avg_long_blink_unaware_temp(:,point))/ sqrt(size(all_avg_long_blink_unaware_temp,1));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end
%aware_SEM_long_blink = lowpass(aware_SEM_long_blink,0.1,1000);
%unaware_SEM_long_blink = lowpass(unaware_SEM_long_blink,0.1,1000);
figure
hold on
patch([-7:8 fliplr(-7:8)], [mean_aware_long_blink_bin-aware_SEM_long_blink fliplr(mean_aware_long_blink_bin+aware_SEM_long_blink)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-7:8 fliplr(-7:8)], [mean_unaware_long_blink_bin-unaware_SEM_long_blink fliplr(mean_unaware_long_blink_bin+unaware_SEM_long_blink)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
plot(-7:8,mean_aware_long_blink_bin,'Color','blue','LineWidth',5)
plot(-7:8,mean_unaware_long_blink_bin,'Color',[1 0.7 0],'LineWidth',5)
xlim([-7 2])
ylim([0 0.15])
title(['Right Eye Long Blink Onsets'])
set(gca,'FontSize',24)
legend({'Aware','Unaware'})
ylabel(['Long Blink Onsets per Second'])
xlabel(['Time from Confirm'])

%% Plot saccade duration


%mean_aware_sac_duration = lowpass(mean(all_avg_sac_duration_aware_left),0.1,1000)*100;
%mean_unaware_sac_duration = lowpass(mean(all_avg_sac_duration_unaware_left),0.1,1000)*100;
aware_SEM_sac_duration = zeros(1,16000);
unaware_SEM_sac_duration = zeros(1,16000);
mean_aware_sac_duration = nanmean(all_avg_sac_duration_aware_left);
mean_unaware_sac_duration = nanmean(all_avg_sac_duration_unaware_left);
for point = 1:length(mean_aware_sac_duration)
    aware_SEM_sac_duration(point) = nanstd(all_avg_sac_duration_aware_left(:,point))/ sqrt(size(all_avg_sac_duration_aware_left,1));
    unaware_SEM_sac_duration(point) = nanstd(all_avg_sac_duration_unaware_left(:,point))/ sqrt(size(all_avg_sac_duration_unaware_left,1));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end
%aware_SEM_sac_duration = lowpass(aware_SEM_sac_duration,0.1,1000)*100;
%unaware_SEM_sac_duration = lowpass(unaware_SEM_sac_duration,0.1,1000)*100;
figure
hold on
patch([-7999:8000 fliplr(-7999:8000)], [mean_aware_sac_duration-aware_SEM_sac_duration fliplr(mean_aware_sac_duration+aware_SEM_sac_duration)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-7999:8000 fliplr(-7999:8000)], [mean_unaware_sac_duration-unaware_SEM_sac_duration fliplr(mean_unaware_sac_duration+unaware_SEM_sac_duration)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
plot(-7999:8000,mean_aware_sac_duration,'Color','blue','LineWidth',5)
plot(-7999:8000,mean_unaware_sac_duration,'Color',[1 0.7 0],'LineWidth',5)
xlim([-6000 2000])
ylim([0 70])
title(['Left Eye Saccade Duration'])
ylabel(['Saccade Duration (ms)'])
xlabel(['Time from Confirm'])
set(gca,'FontSize',24)
legend({'Aware','Unaware'})

all_avg_sac_duration_aware_temp = all_avg_sac_duration_aware_right;
all_avg_sac_duration_unaware_temp = all_avg_sac_duration_unaware_right;
% for subject = 1:size(all_avg_sac_duration_aware_temp)
%     for timepoint = 6000-(binsize/2+1):10000+(binsize/2)
%         all_avg_sac_duration_aware_temp(subject,timepoint) = mean(all_avg_sac_duration_aware_temp(subject,timepoint-(binsize/2):timepoint+(binsize/2-1)));
%         all_avg_sac_duration_unaware_temp(subject,timepoint) = mean(all_avg_sac_duration_unaware_temp(subject,timepoint-(binsize/2):timepoint+(binsize/2-1)));
% 
%     end
% end


%mean_aware_sac_duration = lowpass(mean(all_avg_sac_duration_aware_left),0.1,1000)*100;
%mean_unaware_sac_duration = lowpass(mean(all_avg_sac_duration_unaware_left),0.1,1000)*100;
mean_aware_sac_duration = nanmean(all_avg_sac_duration_aware_right);
mean_unaware_sac_duration = nanmean(all_avg_sac_duration_unaware_right);
for point = 1:length(mean_aware_sac_duration)
    aware_SEM_sac_duration(point) = nanstd(all_avg_sac_duration_aware_temp(:,point))/ sqrt(size(all_avg_sac_duration_aware_temp,1));
    unaware_SEM_sac_duration(point) = nanstd(all_avg_sac_duration_unaware_temp(:,point))/ sqrt(size(all_avg_sac_duration_unaware_temp,1));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end
%aware_SEM_sac_duration = lowpass(aware_SEM_sac_duration,0.1,1000)*100;
%unaware_SEM_sac_duration = lowpass(unaware_SEM_sac_duration,0.1,1000)*100;
figure
hold on
patch([-7999:8000 fliplr(-7999:8000)], [mean_aware_sac_duration-aware_SEM_sac_duration fliplr(mean_aware_sac_duration+aware_SEM_sac_duration)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-7999:8000 fliplr(-7999:8000)], [mean_unaware_sac_duration-unaware_SEM_sac_duration fliplr(mean_unaware_sac_duration+unaware_SEM_sac_duration)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
plot(-7999:8000,mean_aware_sac_duration,'Color','blue','LineWidth',5)
plot(-7999:8000,mean_unaware_sac_duration,'Color',[1 0.7 0],'LineWidth',5)
xlim([-6000 2000])
ylim([0 70])
title(['Right Eye Saccade Duration'])
set(gca,'FontSize',24)
legend({'Aware','Unaware'})
ylabel(['Saccade Duration (ms)'])
xlabel(['Time from Confirm'])

%% Raw pupil diameter, baselined -1 to 0

% load([root '/timecourse_cluster_aware_eye_left_E1_5000perm_minus1to0.mat'])
sig_time_pts_aware = nan(1,8000);
% sig_time_pts_aware(sig_time_pts+3000) = 0.35;
% 
% load([root '/timecourse_cluster_unaware_eye_left_E1_5000perm_minus1to0.mat'])
sig_time_pts_unaware = nan(1,8000);
% sig_time_pts_unaware(sig_time_pts+3000) = 0.325;

aware_SEM_minus1to0 = zeros(1,8000);
unaware_SEM_minus1to0 = zeros(1,8000);
%mean_aware_minus1to0 = lowpass(mean(all_avg_minus1to0_aware_left),0.1,1000)*100;
%mean_unaware_minus1to0 = lowpass(mean(all_avg_minus1to0_unaware_left),0.1,1000)*100;
mean_aware_minus1to0 = nanmean(all_avg_minus1to0_aware_left);
mean_unaware_minus1to0 = nanmean(all_avg_minus1to0_unaware_left);
for point = 1:length(mean_aware_minus1to0)
    aware_SEM_minus1to0(point) = std(all_avg_minus1to0_aware_left(:,point))/ sqrt(size(all_avg_minus1to0_aware_left,1));
    unaware_SEM_minus1to0(point) = std(all_avg_minus1to0_unaware_left(:,point))/ sqrt(size(all_avg_minus1to0_unaware_left,1));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end
%aware_SEM_minus1to0 = lowpass(aware_SEM_minus1to0,0.1,1000)*100;
%unaware_SEM_minus1to0 = lowpass(unaware_SEM_minus1to0,0.1,1000)*100;
figure
hold on
patch([-3999:4000 fliplr(-3999:4000)], [mean_aware_minus1to0-aware_SEM_minus1to0 fliplr(mean_aware_minus1to0+aware_SEM_minus1to0)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-3999:4000 fliplr(-3999:4000)], [mean_unaware_minus1to0-unaware_SEM_minus1to0 fliplr(mean_unaware_minus1to0+unaware_SEM_minus1to0)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
plot(-3999:4000,mean_aware_minus1to0,'Color','blue','LineWidth',5)
plot(-3999:4000,mean_unaware_minus1to0,'Color',[1 0.7 0],'LineWidth',5)
plot(-3999:4000,sig_time_pts_aware,'LineWidth',5,'Color','blue')
plot(-3999:4000,sig_time_pts_unaware,'LineWidth',5,'Color',[1 0.7 0])
xlim([-2000 2000])
ylim([-0.1 0.4])
title(['Left Eye Raw Pupil Diameter, -1 to 0 Baseline'])
ylabel(['Pupil Diameter Change from Baseline (mm)'])
xlabel(['Time from Confirm'])
set(gca,'FontSize',24)
legend({'Aware','Unaware','Aware Significant Timepoints','Unaware Significant Timepoints'})

all_avg_minus1to0_aware_temp = all_avg_minus1to0_aware_right;
all_avg_minus1to0_unaware_temp = all_avg_minus1to0_unaware_right;
% for subject = 1:size(all_avg_minus1to0_aware_temp)
%     for timepoint = 6000-(binsize/2+1):10000+(binsize/2)
%         all_avg_minus1to0_aware_temp(subject,timepoint) = mean(all_avg_minus1to0_aware_temp(subject,timepoint-(binsize/2):timepoint+(binsize/2-1)));
%         all_avg_minus1to0_unaware_temp(subject,timepoint) = mean(all_avg_minus1to0_unaware_temp(subject,timepoint-(binsize/2):timepoint+(binsize/2-1)));
% 
%     end
% end


% load([root '/timecourse_cluster_aware_eye_right_E1_5000perm_minus1to0.mat'])
sig_time_pts_aware = nan(1,8000);
% sig_time_pts_aware(sig_time_pts+3000) = 0.35;

% load([root '/timecourse_cluster_unaware_eye_right_E1_5000perm_minus1to0.mat'])
sig_time_pts_unaware = nan(1,8000);
% sig_time_pts_unaware(sig_time_pts+3000) = 0.325;

%mean_aware_minus1to0 = lowpass(mean(all_avg_minus1to0_aware_left),0.1,1000)*100;
%mean_unaware_minus1to0 = lowpass(mean(all_avg_minus1to0_unaware_left),0.1,1000)*100;
mean_aware_minus1to0 = mean(all_avg_minus1to0_aware_right);
mean_unaware_minus1to0 = mean(all_avg_minus1to0_unaware_right);
for point = 1:length(mean_aware_minus1to0)
    aware_SEM_minus1to0(point) = std(all_avg_minus1to0_aware_temp(:,point))/ sqrt(size(all_avg_minus1to0_aware_temp,1));
    unaware_SEM_minus1to0(point) = std(all_avg_minus1to0_unaware_temp(:,point))/ sqrt(size(all_avg_minus1to0_unaware_temp,1));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end
%aware_SEM_minus1to0 = lowpass(aware_SEM_minus1to0,0.1,1000)*100;
%unaware_SEM_minus1to0 = lowpass(unaware_SEM_minus1to0,0.1,1000)*100;
figure
hold on
patch([-3999:4000 fliplr(-3999:4000)], [mean_aware_minus1to0-aware_SEM_minus1to0 fliplr(mean_aware_minus1to0+aware_SEM_minus1to0)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-3999:4000 fliplr(-3999:4000)], [mean_unaware_minus1to0-unaware_SEM_minus1to0 fliplr(mean_unaware_minus1to0+unaware_SEM_minus1to0)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
plot(-3999:4000,mean_aware_minus1to0,'Color','blue','LineWidth',5)
plot(-3999:4000,mean_unaware_minus1to0,'Color',[1 0.7 0],'LineWidth',5)
plot(-3999:4000,sig_time_pts_aware,'LineWidth',5,'Color','blue')
plot(-3999:4000,sig_time_pts_unaware,'LineWidth',5,'Color',[1 0.7 0])
xlim([-2000 2000])
ylim([-0.1 0.4])
title(['Right Eye Raw Pupil Diameter, -1 to 0 Baseline'])
set(gca,'FontSize',24)
legend({'Aware','Unaware','Aware Significant Timepoints','Unaware Significant Timepoints'})
ylabel(['Pupil Diameter Change from Baseline (mm)'])
xlabel(['Time from Confirm'])


%%


% load([root '/timecourse_cluster_aware_eye_left_E1_5000perm_minus2minus1.mat'])
sig_time_pts_aware = nan(1,8000);
% sig_time_pts_aware(sig_time_pts+3000) = 0.375;


% load([root '/timecourse_cluster_unaware_eye_left_E1_5000perm_minus2minus1.mat'])
sig_time_pts_unaware = nan(1,8000);
% sig_time_pts_unaware(sig_time_pts+3000) = 0.35;

aware_SEM_minus2minus1 = zeros(1,8000);
unaware_SEM_minus2minus1 = zeros(1,8000);
%mean_aware_minus2minus1 = lowpass(mean(all_avg_minus2minus1_aware_left),0.1,1000)*100;
%mean_unaware_minus2minus1 = lowpass(mean(all_avg_minus2minus1_unaware_left),0.1,1000)*100;
mean_aware_minus2minus1 = nanmean(all_avg_minus2minus1_aware_left);
mean_unaware_minus2minus1 = nanmean(all_avg_minus2minus1_unaware_left);
for point = 1:length(mean_aware_minus2minus1)
    aware_SEM_minus2minus1(point) = std(all_avg_minus2minus1_aware_left(:,point))/ sqrt(size(all_avg_minus2minus1_aware_left,1));
    unaware_SEM_minus2minus1(point) = std(all_avg_minus2minus1_unaware_left(:,point))/ sqrt(size(all_avg_minus2minus1_unaware_left,1));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end
%aware_SEM_minus2minus1 = lowpass(aware_SEM_minus2minus1,0.1,1000)*100;
%unaware_SEM_minus2minus1 = lowpass(unaware_SEM_minus2minus1,0.1,1000)*100;
figure
hold on
patch([-3999:4000 fliplr(-3999:4000)], [mean_aware_minus2minus1-aware_SEM_minus2minus1 fliplr(mean_aware_minus2minus1+aware_SEM_minus2minus1)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-3999:4000 fliplr(-3999:4000)], [mean_unaware_minus2minus1-unaware_SEM_minus2minus1 fliplr(mean_unaware_minus2minus1+unaware_SEM_minus2minus1)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
plot(-3999:4000,mean_aware_minus2minus1,'Color','blue','LineWidth',5)
plot(-3999:4000,mean_unaware_minus2minus1,'Color',[1 0.7 0],'LineWidth',5)
plot(-3999:4000,sig_time_pts_aware,'LineWidth',5,'Color','blue')
plot(-3999:4000,sig_time_pts_unaware,'LineWidth',5,'Color',[1 0.7 0])
xlim([-2000 2000])
ylim([-0.1 0.4])
title(['Left Eye Raw Pupil Diameter, -2 to -1 Baseline'])
ylabel(['Pupil Diameter Change from Baseline (mm)'])
xlabel(['Time from Confirm'])
set(gca,'FontSize',24)
legend({'Aware','Unaware','Aware Significant Timepoints','Unaware Significant Timepoints'})
all_avg_minus2minus1_aware_temp = all_avg_minus2minus1_aware_right;
all_avg_minus2minus1_unaware_temp = all_avg_minus2minus1_unaware_right;
% for subject = 1:size(all_avg_minus2minus1_aware_temp)
%     for timepoint = 6000-(binsize/2+1):10000+(binsize/2)
%         all_avg_minus2minus1_aware_temp(subject,timepoint) = mean(all_avg_minus2minus1_aware_temp(subject,timepoint-(binsize/2):timepoint+(binsize/2-1)));
%         all_avg_minus2minus1_unaware_temp(subject,timepoint) = mean(all_avg_minus2minus1_unaware_temp(subject,timepoint-(binsize/2):timepoint+(binsize/2-1)));
% 
%     end
% end


% load([root '/timecourse_cluster_aware_eye_right_E1_5000perm_minus2minus1.mat'])
sig_time_pts_aware = nan(1,8000);
% sig_time_pts_aware(sig_time_pts+3000) = 0.375;


% load([root '/timecourse_cluster_unaware_eye_right_E1_5000perm_minus2minus1.mat'])
sig_time_pts_unaware = nan(1,8000);
% sig_time_pts_unaware(sig_time_pts+3000) = 0.35;

%mean_aware_minus2minus1 = lowpass(mean(all_avg_minus2minus1_aware_left),0.1,1000)*100;
%mean_unaware_minus2minus1 = lowpass(mean(all_avg_minus2minus1_unaware_left),0.1,1000)*100;
mean_aware_minus2minus1 = mean(all_avg_minus2minus1_aware_right);
mean_unaware_minus2minus1 = mean(all_avg_minus2minus1_unaware_right);
for point = 1:length(mean_aware_minus2minus1)
    aware_SEM_minus2minus1(point) = std(all_avg_minus2minus1_aware_temp(:,point))/ sqrt(size(all_avg_minus2minus1_aware_temp,1));
    unaware_SEM_minus2minus1(point) = std(all_avg_minus2minus1_unaware_temp(:,point))/ sqrt(size(all_avg_minus2minus1_unaware_temp,1));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end
%aware_SEM_minus2minus1 = lowpass(aware_SEM_minus2minus1,0.1,1000)*100;
%unaware_SEM_minus2minus1 = lowpass(unaware_SEM_minus2minus1,0.1,1000)*100;
figure
hold on
patch([-3999:4000 fliplr(-3999:4000)], [mean_aware_minus2minus1-aware_SEM_minus2minus1 fliplr(mean_aware_minus2minus1+aware_SEM_minus2minus1)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-3999:4000 fliplr(-3999:4000)], [mean_unaware_minus2minus1-unaware_SEM_minus2minus1 fliplr(mean_unaware_minus2minus1+unaware_SEM_minus2minus1)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
plot(-3999:4000,mean_aware_minus2minus1,'Color','blue','LineWidth',5)
plot(-3999:4000,mean_unaware_minus2minus1,'Color',[1 0.7 0],'LineWidth',5)
plot(-3999:4000,sig_time_pts_aware,'LineWidth',5,'Color','blue')
plot(-3999:4000,sig_time_pts_unaware,'LineWidth',5,'Color',[1 0.7 0])
xlim([-2000 2000])
ylim([-0.1 0.4])
title(['Right Eye Raw Pupil Diameter, -2 to -1 Baseline'])
set(gca,'FontSize',24)
legend({'Aware','Unaware','Aware Significant Timepoints','Unaware Significant Timepoints'})
ylabel(['Pupil Diameter Change from Baseline (mm)'])
xlabel(['Time from Confirm']);



%% Plot Nan 2s Trials


%mean_aware_nan2s = lowpass(mean(all_avg_nan2s_aware_left),0.1,1000)*100;
%mean_unaware_nan2s = lowpass(mean(all_avg_nan2s_unaware_left),0.1,1000)*100;
aware_SEM_nan2s = zeros(1,8000);
unaware_SEM_nan2s = zeros(1,8000);
mean_aware_nan2s = nanmean(all_avg_nan2s_aware_left);
mean_unaware_nan2s = nanmean(all_avg_nan2s_unaware_left);
for point = 1:length(mean_aware_nan2s)
    aware_SEM_nan2s(point) = nanstd(all_avg_nan2s_aware_left(:,point))/ sqrt(size(all_avg_nan2s_aware_left,1));
    unaware_SEM_nan2s(point) = nanstd(all_avg_nan2s_unaware_left(:,point))/ sqrt(size(all_avg_nan2s_unaware_left,1));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end
%aware_SEM_nan2s = lowpass(aware_SEM_nan2s,0.1,1000)*100;
%unaware_SEM_nan2s = lowpass(unaware_SEM_nan2s,0.1,1000)*100;
figure
hold on
patch([-3999:4000 fliplr(-3999:4000)], [mean_aware_nan2s-aware_SEM_nan2s fliplr(mean_aware_nan2s+aware_SEM_nan2s)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-3999:4000 fliplr(-3999:4000)], [mean_unaware_nan2s-unaware_SEM_nan2s fliplr(mean_unaware_nan2s+unaware_SEM_nan2s)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
plot(-3999:4000,mean_aware_nan2s,'Color','blue','LineWidth',5)
plot(-3999:4000,mean_unaware_nan2s,'Color',[1 0.7 0],'LineWidth',5)
xlim([-2000 3000])
ylim([-0.2 1])
title(['Left Eye 2s Trials Nanned, N = ' num2str(size(all_avg_nan2s_aware_left,1))])
ylabel(['Pupil Diameter Z-Score'])
xlabel(['Time from Confirm'])
set(gca,'FontSize',24)
legend({'Aware','Unaware'})

all_avg_nan2s_aware_temp = all_avg_nan2s_aware_right;
all_avg_nan2s_unaware_temp = all_avg_nan2s_unaware_right;
% for subject = 1:size(all_avg_nan2s_aware_temp)
%     for timepoint = 6000-(binsize/2+1):10000+(binsize/2)
%         all_avg_nan2s_aware_temp(subject,timepoint) = mean(all_avg_nan2s_aware_temp(subject,timepoint-(binsize/2):timepoint+(binsize/2-1)));
%         all_avg_nan2s_unaware_temp(subject,timepoint) = mean(all_avg_nan2s_unaware_temp(subject,timepoint-(binsize/2):timepoint+(binsize/2-1)));
% 
%     end
% end


%mean_aware_nan2s = lowpass(mean(all_avg_nan2s_aware_left),0.1,1000)*100;
%mean_unaware_nan2s = lowpass(mean(all_avg_nan2s_unaware_left),0.1,1000)*100;
mean_aware_nan2s = nanmean(all_avg_nan2s_aware_right);
mean_unaware_nan2s = nanmean(all_avg_nan2s_unaware_right);
for point = 1:length(mean_aware_nan2s)
    aware_SEM_nan2s(point) = nanstd(all_avg_nan2s_aware_temp(:,point))/ sqrt(size(all_avg_nan2s_aware_temp,1));
    unaware_SEM_nan2s(point) = nanstd(all_avg_nan2s_unaware_temp(:,point))/ sqrt(size(all_avg_nan2s_unaware_temp,1));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end
%aware_SEM_nan2s = lowpass(aware_SEM_nan2s,0.1,1000)*100;
%unaware_SEM_nan2s = lowpass(unaware_SEM_nan2s,0.1,1000)*100;
figure
hold on
patch([-3999:4000 fliplr(-3999:4000)], [mean_aware_nan2s-aware_SEM_nan2s fliplr(mean_aware_nan2s+aware_SEM_nan2s)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-3999:4000 fliplr(-3999:4000)], [mean_unaware_nan2s-unaware_SEM_nan2s fliplr(mean_unaware_nan2s+unaware_SEM_nan2s)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
plot(-3999:4000,mean_aware_nan2s,'Color','blue','LineWidth',5)
plot(-3999:4000,mean_unaware_nan2s,'Color',[1 0.7 0],'LineWidth',5)
xlim([-2000 3000])
ylim([-0.2 1])
title(['Right Eye 2s Trials Nanned, N = ' num2str(size(all_avg_nan2s_aware_right,1))])
set(gca,'FontSize',24)
legend({'Aware','Unaware'})
ylabel(['Pupil Diameter '])
xlabel(['Time from Confirm'])

 %% Plot Remove 2s Trials


%mean_aware_remove2s = lowpass(mean(all_avg_remove2s_aware_left),0.1,1000)*100;
%mean_unaware_remove2s = lowpass(mean(all_avg_remove2s_unaware_left),0.1,1000)*100;
aware_SEM_remove2s = zeros(1,8000);
unaware_SEM_remove2s = zeros(1,8000);
mean_aware_remove2s = nanmean(all_avg_remove2s_aware_left);
mean_unaware_remove2s = nanmean(all_avg_remove2s_unaware_left);

load('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Pupil_Timecourse_Permutation/timecourse_cluster_aware_vs_unaware_eye_left_E1_5000perm_remove2s.mat')
sig_line = nan(1,8000);
sig_time_pts = sig_time_pts + 2000;
sig_line(sig_time_pts) = 1;

for point = 1:length(mean_aware_remove2s)
    aware_SEM_remove2s(point) = nanstd(all_avg_remove2s_aware_left(:,point))/ sqrt(size(all_avg_remove2s_aware_left,1));
    unaware_SEM_remove2s(point) = nanstd(all_avg_remove2s_unaware_left(:,point))/ sqrt(size(all_avg_remove2s_unaware_left,1));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end

%aware_SEM_remove2s = lowpass(aware_SEM_remove2s,0.1,1000)*100;
%unaware_SEM_remove2s = lowpass(unaware_SEM_remove2s,0.1,1000)*100;
figure
hold on
patch([-3999:4000 fliplr(-3999:4000)], [mean_aware_remove2s-aware_SEM_remove2s fliplr(mean_aware_remove2s+aware_SEM_remove2s)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-3999:4000 fliplr(-3999:4000)], [mean_unaware_remove2s-unaware_SEM_remove2s fliplr(mean_unaware_remove2s+unaware_SEM_remove2s)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
plot(-3999:4000,mean_aware_remove2s,'Color','blue','LineWidth',5)
plot(-3999:4000,mean_unaware_remove2s,'Color',[1 0.7 0],'LineWidth',5)
xlim([-4000 3000])
ylim([-0.2 1.0])
plot(-3999:4000,sig_line,'LineWidth',5,'Color','green')
title(['Pupil Diameter Prior to and Following Action, N = ' num2str(size(all_avg_remove2s_aware_left,1))])
ylabel(['Pupil Diameter Z-Score'])
xlabel(['Time from Confirm'])
set(gca,'FontSize',24)
legend({'Aware','Unaware'})

all_avg_remove2s_aware_temp = all_avg_remove2s_aware_right;
all_avg_remove2s_unaware_temp = all_avg_remove2s_unaware_right;
% for subject = 1:size(all_avg_remove2s_aware_temp)
%     for timepoint = 6000-(binsize/2+1):10000+(binsize/2)
%         all_avg_remove2s_aware_temp(subject,timepoint) = mean(all_avg_remove2s_aware_temp(subject,timepoint-(binsize/2):timepoint+(binsize/2-1)));
%         all_avg_remove2s_unaware_temp(subject,timepoint) = mean(all_avg_remove2s_unaware_temp(subject,timepoint-(binsize/2):timepoint+(binsize/2-1)));
% 
%     end
% end


load('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Pupil_Timecourse_Permutation/timecourse_cluster_aware_vs_unaware_eye_right_E1_5000perm_remove2s.mat')
sig_line = nan(1,8000);
sig_time_pts = sig_time_pts + 2000;
sig_line(sig_time_pts) = 1;

%mean_aware_remove2s = lowpass(mean(all_avg_remove2s_aware_left),0.1,1000)*100;
%mean_unaware_remove2s = lowpass(mean(all_avg_remove2s_unaware_left),0.1,1000)*100;
mean_aware_remove2s = nanmean(all_avg_remove2s_aware_right);
mean_unaware_remove2s = nanmean(all_avg_remove2s_unaware_right);
for point = 1:length(mean_aware_remove2s)
    aware_SEM_remove2s(point) = nanstd(all_avg_remove2s_aware_temp(:,point))/ sqrt(size(all_avg_remove2s_aware_temp,1));
    unaware_SEM_remove2s(point) = nanstd(all_avg_remove2s_unaware_temp(:,point))/ sqrt(size(all_avg_remove2s_unaware_temp,1));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end
%aware_SEM_remove2s = lowpass(aware_SEM_remove2s,0.1,1000)*100;
%unaware_SEM_remove2s = lowpass(unaware_SEM_remove2s,0.1,1000)*100;
figure
hold on
patch([-3999:4000 fliplr(-3999:4000)], [mean_aware_remove2s-aware_SEM_remove2s fliplr(mean_aware_remove2s+aware_SEM_remove2s)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-3999:4000 fliplr(-3999:4000)], [mean_unaware_remove2s-unaware_SEM_remove2s fliplr(mean_unaware_remove2s+unaware_SEM_remove2s)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
plot(-3999:4000,mean_aware_remove2s,'Color','blue','LineWidth',5)
plot(-3999:4000,mean_unaware_remove2s,'Color',[1 0.7 0],'LineWidth',5)
plot(-3999:4000,sig_line,'LineWidth',5,'Color','green')

xlim([-4000 3000])
ylim([-0.2 1.0])
title(['Right Eye 2s Trials Removed, N = ' num2str(size(all_avg_remove2s_aware_right,1))])
set(gca,'FontSize',24)
legend({'Aware','Unaware'})
ylabel(['Pupil Diameter Z-Score'])
xlabel(['Time from Confirm'])

%% Pupil Velocity, Remove 2s Trials

load('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Pupil_Timecourse_Permutation/timecourse_cluster_aware_vs_unaware_eye_right_E1_5000perm_velocity.mat')
sig_line = nan(1,8000);
sig_time_pts = sig_time_pts + 2000;
sig_line(sig_time_pts) = 1;


first_derivative_aware_remove2s_right = zeros(size(all_avg_remove2s_aware_right));

for subject = 1:size(all_avg_remove2s_aware_right,1)
    for timepoint = 50:7950
        first_derivative_aware_remove2s_right(subject,timepoint) = (all_avg_remove2s_aware_right(subject,timepoint+50) - all_avg_remove2s_aware_right(subject,timepoint-49)) * 1000 / 100;
    end
end

first_derivative_unaware_remove2s_right = zeros(size(all_avg_remove2s_unaware_right));

for subject = 1:size(all_avg_remove2s_unaware_right,1)
    for timepoint = 50:7950
        first_derivative_unaware_remove2s_right(subject,timepoint) = (all_avg_remove2s_unaware_right(subject,timepoint+50) - all_avg_remove2s_unaware_right(subject,timepoint-49)) * 1000 / 100;
    end
end


%mean_aware_remove2s = lowpass(mean(all_avg_remove2s_aware_left),0.1,1000)*100;
%mean_unaware_remove2s = lowpass(mean(all_avg_remove2s_unaware_left),0.1,1000)*100;
mean_aware_remove2s_1stdev = nanmean(first_derivative_aware_remove2s_right);
mean_unaware_remove2s_1stdev = nanmean(first_derivative_unaware_remove2s_right);
for point = 1:length(mean_aware_remove2s_1stdev)
    aware_SEM_remove2s(point) = nanstd(first_derivative_aware_remove2s_right(:,point))/ sqrt(size(first_derivative_aware_remove2s_right,1));
    unaware_SEM_remove2s(point) = nanstd(first_derivative_unaware_remove2s_right(:,point))/ sqrt(size(first_derivative_unaware_remove2s_right,1));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end
%aware_SEM_remove2s = lowpass(aware_SEM_remove2s,0.1,1000)*100;
%unaware_SEM_remove2s = lowpass(unaware_SEM_remove2s,0.1,1000)*100;
figure
hold on
patch([-3999:4000 fliplr(-3999:4000)], [mean_aware_remove2s_1stdev-aware_SEM_remove2s fliplr(mean_aware_remove2s_1stdev+aware_SEM_remove2s)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-3999:4000 fliplr(-3999:4000)], [mean_unaware_remove2s_1stdev-unaware_SEM_remove2s fliplr(mean_unaware_remove2s_1stdev+unaware_SEM_remove2s)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
plot(-3999:4000,mean_aware_remove2s_1stdev,'Color','blue','LineWidth',5)
plot(-3999:4000,mean_unaware_remove2s_1stdev,'Color',[1 0.7 0],'LineWidth',5)
plot(-3999:4000,sig_line,'LineWidth',5,'Color','green')
xlim([-4000 3000])
% ylim([-0.2 1])
title(['Right Eye Velocity 2s Trials Removed, N = ' num2str(size(first_derivative_aware_remove2s_right,1))])
set(gca,'FontSize',24)
legend({'Aware','Unaware'})
ylabel(['Z-Scores per Second'])
xlabel(['Time from Confirm'])




first_derivative_aware_remove2s_left = zeros(size(all_avg_remove2s_aware_left));

for subject = 1:size(all_avg_remove2s_aware_left,1)
    for timepoint = 50:7950
        first_derivative_aware_remove2s_left(subject,timepoint) = (all_avg_remove2s_aware_left(subject,timepoint+50) - all_avg_remove2s_aware_left(subject,timepoint-49)) *1000 / 100;
    end
end

first_derivative_unaware_remove2s_left = zeros(size(all_avg_remove2s_unaware_left));

for subject = 1:size(all_avg_remove2s_unaware_left,1)
    for timepoint = 50:7950
        first_derivative_unaware_remove2s_left(subject,timepoint) = (all_avg_remove2s_unaware_left(subject,timepoint+50) - all_avg_remove2s_unaware_left(subject,timepoint-49)) * 1000 / 100;
    end
end



%mean_aware_remove2s = lowpass(mean(all_avg_remove2s_aware_left),0.1,1000)*100;
%mean_unaware_remove2s = lowpass(mean(all_avg_remove2s_unaware_left),0.1,1000)*100;
mean_aware_remove2s_1stdev = nanmean(first_derivative_aware_remove2s_left);
mean_unaware_remove2s_1stdev = nanmean(first_derivative_unaware_remove2s_left);
for point = 1:length(mean_aware_remove2s_1stdev)
    aware_SEM_remove2s(point) = nanstd(first_derivative_aware_remove2s_left(:,point))/ sqrt(size(first_derivative_aware_remove2s_left,1));
    unaware_SEM_remove2s(point) = nanstd(first_derivative_unaware_remove2s_left(:,point))/ sqrt(size(first_derivative_unaware_remove2s_left,1));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end
%aware_SEM_remove2s = lowpass(aware_SEM_remove2s,0.1,1000)*100;
%unaware_SEM_remove2s = lowpass(unaware_SEM_remove2s,0.1,1000)*100;

load('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Pupil_Timecourse_Permutation/timecourse_cluster_aware_vs_unaware_eye_left_E1_5000perm_velocity.mat')
sig_line = nan(1,8000);
sig_time_pts = sig_time_pts + 2000;
sig_line(sig_time_pts) = 1;

figure
hold on
patch([-3999:4000 fliplr(-3999:4000)], [mean_aware_remove2s_1stdev-aware_SEM_remove2s fliplr(mean_aware_remove2s_1stdev+aware_SEM_remove2s)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-3999:4000 fliplr(-3999:4000)], [mean_unaware_remove2s_1stdev-unaware_SEM_remove2s fliplr(mean_unaware_remove2s_1stdev+unaware_SEM_remove2s)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
plot(-3999:4000,mean_aware_remove2s_1stdev,'Color','blue','LineWidth',5)
plot(-3999:4000,mean_unaware_remove2s_1stdev,'Color',[1 0.7 0],'LineWidth',5)
plot(-3999:4000,sig_line,'LineWidth',5,'Color','green')
xlim([-4000 3000])
% ylim([-0.2 1])
title(['Left Eye Velocity 2s Trials Removed, N = ' num2str(size(first_derivative_aware_remove2s_left,1))])
set(gca,'FontSize',24)
legend({'Aware','Unaware'})
ylabel(['Z-Scores Per Second'])
xlabel(['Time from Confirm'])


%% Plot Remove 2s Trials Raw

load('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Pupil_Timecourse_Permutation/timecourse_cluster_aware_vs_unaware_eye_right_E1_5000perm_remove2s.mat')

%mean_aware_remove2s = lowpass(mean(all_avg_remove2s_aware_left),0.1,1000)*100;
%mean_unaware_remove2s = lowpass(mean(all_avg_remove2s_unaware_left),0.1,1000)*100;
aware_SEM_remove2s_raw = zeros(1,8000);
unaware_SEM_remove2s_raw = zeros(1,8000);
mean_aware_remove2s_raw = nanmean(all_avg_remove2s_aware_left_raw);
mean_unaware_remove2s_raw = nanmean(all_avg_remove2s_unaware_left_raw);

load('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Pupil_Timecourse_Permutation/timecourse_cluster_aware_vs_unaware_eye_left_E1_5000perm_remove2s.mat')
sig_line = nan(1,8000);
sig_time_pts = sig_time_pts + 2000;
sig_line(sig_time_pts) = 1;

for point = 1:length(mean_aware_remove2s_raw)
    aware_SEM_remove2s_raw(point) = nanstd(all_avg_remove2s_aware_left_raw(:,point))/ sqrt(size(all_avg_remove2s_aware_left_raw,1));
    unaware_SEM_remove2s_raw(point) = nanstd(all_avg_remove2s_unaware_left_raw(:,point))/ sqrt(size(all_avg_remove2s_unaware_left_raw,1));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end

%aware_SEM_remove2s = lowpass(aware_SEM_remove2s,0.1,1000)*100;
%unaware_SEM_remove2s = lowpass(unaware_SEM_remove2s,0.1,1000)*100;
figure
hold on
patch([-3999:4000 fliplr(-3999:4000)], [mean_aware_remove2s_raw-aware_SEM_remove2s_raw fliplr(mean_aware_remove2s_raw+aware_SEM_remove2s_raw)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-3999:4000 fliplr(-3999:4000)], [mean_unaware_remove2s_raw-unaware_SEM_remove2s_raw fliplr(mean_unaware_remove2s_raw+unaware_SEM_remove2s_raw)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
plot(-3999:4000,mean_aware_remove2s_raw,'Color','blue','LineWidth',5)
plot(-3999:4000,mean_unaware_remove2s_raw,'Color',[1 0.7 0],'LineWidth',5)
xlim([-4000 3000])
ylim([3 4.5])
% plot(-3999:4000,sig_line,'LineWidth',5,'Color','green')
title(['Left Eye 2s Trials Removed Raw Diameter, N = ' num2str(size(all_avg_remove2s_aware_left,1))])
ylabel(['Pupil Diameter (mm)'])
xlabel(['Time from Confirm'])
set(gca,'FontSize',24)
legend({'Aware','Unaware'})

all_avg_remove2s_aware_temp = all_avg_remove2s_aware_left;
all_avg_remove2s_unaware_temp = all_avg_remove2s_unaware_left;
% for subject = 1:size(all_avg_remove2s_aware_temp)
%     for timepoint = 6000-(binsize/2+1):10000+(binsize/2)
%         all_avg_remove2s_aware_temp(subject,timepoint) = mean(all_avg_remove2s_aware_temp(subject,timepoint-(binsize/2):timepoint+(binsize/2-1)));
%         all_avg_remove2s_unaware_temp(subject,timepoint) = mean(all_avg_remove2s_unaware_temp(subject,timepoint-(binsize/2):timepoint+(binsize/2-1)));
% 
%     end
% end


%mean_aware_remove2s = lowpass(mean(all_avg_remove2s_aware_right),0.1,1000)*100;
%mean_unaware_remove2s = lowpass(mean(all_avg_remove2s_unaware_right),0.1,1000)*100;
aware_SEM_remove2s_raw = zeros(1,8000);
unaware_SEM_remove2s_raw = zeros(1,8000);
mean_aware_remove2s_raw = nanmean(all_avg_remove2s_aware_right_raw);
mean_unaware_remove2s_raw = nanmean(all_avg_remove2s_unaware_right_raw);

load('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Pupil_Timecourse_Permutation/timecourse_cluster_aware_vs_unaware_eye_right_E1_5000perm_remove2s.mat')
sig_line = nan(1,8000);
sig_time_pts = sig_time_pts + 2000;
sig_line(sig_time_pts) = 1;

for point = 1:length(mean_aware_remove2s_raw)
    aware_SEM_remove2s_raw(point) = nanstd(all_avg_remove2s_aware_right_raw(:,point))/ sqrt(size(all_avg_remove2s_aware_right_raw,1));
    unaware_SEM_remove2s_raw(point) = nanstd(all_avg_remove2s_unaware_right_raw(:,point))/ sqrt(size(all_avg_remove2s_unaware_right_raw,1));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end

%aware_SEM_remove2s = lowpass(aware_SEM_remove2s,0.1,1000)*100;
%unaware_SEM_remove2s = lowpass(unaware_SEM_remove2s,0.1,1000)*100;
figure
hold on
patch([-3999:4000 fliplr(-3999:4000)], [mean_aware_remove2s_raw-aware_SEM_remove2s_raw fliplr(mean_aware_remove2s_raw+aware_SEM_remove2s_raw)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-3999:4000 fliplr(-3999:4000)], [mean_unaware_remove2s_raw-unaware_SEM_remove2s_raw fliplr(mean_unaware_remove2s_raw+unaware_SEM_remove2s_raw)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
plot(-3999:4000,mean_aware_remove2s_raw,'Color','blue','LineWidth',5)
plot(-3999:4000,mean_unaware_remove2s_raw,'Color',[1 0.7 0],'LineWidth',5)
xlim([-4000 3000])
ylim([3 4.5])
% plot(-3999:4000,sig_line,'LineWidth',5,'Color','green')
title(['Right Eye 2s Trials Removed Raw Diameter, N = ' num2str(size(all_avg_remove2s_aware_right,1))])
ylabel(['Pupil Diameter (mm)'])
xlabel(['Time from Confirm'])
set(gca,'FontSize',24)
legend({'Aware','Unaware'})

%% Plot all blinks from 100-1000 ms

load('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Pupil_Timecourse_Permutation/timecourse_cluster_aware_minus_unaware_eye_left_E1_5000perm_all_blink.mat')
sig_line = nan(1,16000);
sig_time_pts = sig_time_pts + 6000;
sig_line(sig_time_pts) = 34;

%mean_aware_all_blink = lowpass(mean(all_avg_all_blink_aware_left),0.1,1000)*100;
%mean_unaware_all_blink = lowpass(mean(all_avg_all_blink_unaware_left),0.1,1000)*100;
mean_aware_all_blink = mean(all_avg_long_blink_aware_left+all_avg_blink_aware_left)*100;
mean_unaware_all_blink = mean(all_avg_long_blink_unaware_left+all_avg_blink_unaware_left)*100;

all_avg_all_blink_aware_left = all_avg_long_blink_aware_left + all_avg_blink_aware_left;
all_avg_all_blink_unaware_left = all_avg_long_blink_unaware_left + all_avg_blink_unaware_left;

for point = 1:length(mean_aware_all_blink)
    aware_SEM_all_blink(point) = std(all_avg_all_blink_aware_left(:,point)*100)/ sqrt(size(all_avg_all_blink_aware_left,1));
    unaware_SEM_all_blink(point) = std(all_avg_all_blink_unaware_left(:,point)*100)/ sqrt(size(all_avg_all_blink_unaware_left,1));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end
%aware_SEM_all_blink = lowpass(aware_SEM_all_blink,0.1,1000)*100;
%unaware_SEM_all_blink = lowpass(unaware_SEM_all_blink,0.1,1000)*100;
figure
hold on
patch([-7999:8000 fliplr(-7999:8000)], [mean_aware_all_blink-aware_SEM_all_blink fliplr(mean_aware_all_blink+aware_SEM_all_blink)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-7999:8000 fliplr(-7999:8000)], [mean_unaware_all_blink-unaware_SEM_all_blink fliplr(mean_unaware_all_blink+unaware_SEM_all_blink)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
%plot(-7999:8000,sig_time_pts_versus,'Color','green','LineWidth',5)
plot(-7999:8000,mean_aware_all_blink,'Color','blue','LineWidth',5)
plot(-7999:8000,mean_unaware_all_blink,'Color',[1 0.7 0],'LineWidth',5)
plot(-7999:8000,sig_line,'LineWidth',5,'Color','green')

xlim([-2000 2000])
ylim([0 35])
title(['Left Eye All Blink Rate'])
ylabel(['All Blink Rate (%)'])
xlabel(['Time from Confirm'])
set(gca,'FontSize',24)
legend({'Aware','Unaware','Aware vs. Unaware Significant Timepoints'})


% for subject = 1:size(all_avg_all_blink_aware_temp)
%     for timepoint = 6000-(binsize/2+1):10000+(binsize/2)
%         all_avg_all_blink_aware_temp(subject,timepoint) = mean(all_avg_all_blink_aware_temp(subject,timepoint-(binsize/2):timepoint+(binsize/2-1)));
%         all_avg_all_blink_unaware_temp(subject,timepoint) = mean(all_avg_all_blink_unaware_temp(subject,timepoint-(binsize/2):timepoint+(binsize/2-1)));
% 
%     end
% end

% load([root '/timecourse_cluster_aware_vs_unaware_eye_right_E1_5000perm_all_blink.mat'])
sig_time_pts_versus = nan(1,16000);
% sig_time_pts_versus(sig_time_pts+6000) = 10;

%mean_aware_all_blink = lowpass(mean(all_avg_all_blink_aware_left),0.1,1000)*100;
%mean_unaware_all_blink = lowpass(mean(all_avg_all_blink_unaware_left),0.1,1000)*100;
mean_aware_all_blink = mean(all_avg_long_blink_aware_right+all_avg_blink_aware_right)*100;
mean_unaware_all_blink = mean(all_avg_long_blink_unaware_right+all_avg_blink_unaware_right)*100;

all_avg_all_blink_aware_temp = all_avg_long_blink_aware_right+all_avg_blink_aware_right;
all_avg_all_blink_unaware_temp = all_avg_long_blink_unaware_right+all_avg_blink_unaware_right;
all_avg_all_blink_aware_right = all_avg_long_blink_aware_right+all_avg_blink_aware_right;
all_avg_all_blink_unaware_right = all_avg_long_blink_unaware_right+all_avg_blink_unaware_right;

load('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Pupil_Timecourse_Permutation/timecourse_cluster_aware_minus_unaware_eye_right_E1_5000perm_all_blink.mat')
sig_line = nan(1,16000);
sig_time_pts = sig_time_pts + 6000;
sig_line(sig_time_pts) = 34;


for point = 1:length(mean_aware_all_blink)
    aware_SEM_all_blink(point) = std(all_avg_all_blink_aware_temp(:,point)*100)/ sqrt(size(all_avg_all_blink_aware_temp,1));
    unaware_SEM_all_blink(point) = std(all_avg_all_blink_unaware_temp(:,point)*100)/ sqrt(size(all_avg_all_blink_unaware_temp,1));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end
%aware_SEM_all_blink = lowpass(aware_SEM_all_blink,0.1,1000)*100;
%unaware_SEM_all_blink = lowpass(unaware_SEM_all_blink,0.1,1000)*100;
figure
hold on
patch([-7999:8000 fliplr(-7999:8000)], [mean_aware_all_blink-aware_SEM_all_blink fliplr(mean_aware_all_blink+aware_SEM_all_blink)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-7999:8000 fliplr(-7999:8000)], [mean_unaware_all_blink-unaware_SEM_all_blink fliplr(mean_unaware_all_blink+unaware_SEM_all_blink)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
plot(-7999:8000,sig_line,'LineWidth',5,'Color','green')
plot(-7999:8000,mean_aware_all_blink,'Color','blue','LineWidth',5)
plot(-7999:8000,mean_unaware_all_blink,'Color',[1 0.7 0],'LineWidth',5)


xlim([-2000 2000])
ylim([0 35])
title(['Right Eye All Blink Rate'])
set(gca,'FontSize',24)
legend({'Aware','Unaware','Aware vs. Unaware Significant Timepoints'})
ylabel(['All Blink Rate (%)'])
xlabel(['Time from Confirm'])

%% Plot blink duration

all_avg_blink_duration_aware_left(all_avg_blink_duration_aware_left == 0) = NaN;
all_avg_blink_duration_aware_right(all_avg_blink_duration_aware_right == 0) = NaN;
all_avg_blink_duration_unaware_left(all_avg_blink_duration_unaware_left == 0) = NaN;
all_avg_blink_duration_unaware_right(all_avg_blink_duration_unaware_right == 0) = NaN;

%mean_aware_blink_duration = lowpass(mean(all_avg_blink_duration_aware_left),0.1,1000)*100;
%mean_unaware_blink_duration = lowpass(mean(all_avg_blink_duration_unaware_left),0.1,1000)*100;
aware_SEM_blink_duration = zeros(1,16000);
unaware_SEM_blink_duration = zeros(1,16000);
mean_aware_blink_duration = nanmean(all_avg_blink_duration_aware_left);
mean_unaware_blink_duration = nanmean(all_avg_blink_duration_unaware_left);
for point = 1:length(mean_aware_blink_duration)
    aware_SEM_blink_duration(point) = nanstd(all_avg_blink_duration_aware_left(:,point))/ sqrt(size(all_avg_blink_duration_aware_left,1));
    unaware_SEM_blink_duration(point) = nanstd(all_avg_blink_duration_unaware_left(:,point))/ sqrt(size(all_avg_blink_duration_unaware_left,1));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end
%aware_SEM_blink_duration = lowpass(aware_SEM_blink_duration,0.1,1000)*100;
%unaware_SEM_blink_duration = lowpass(unaware_SEM_blink_duration,0.1,1000)*100;
figure
hold on
patch([-7999:8000 fliplr(-7999:8000)], [mean_aware_blink_duration-aware_SEM_blink_duration fliplr(mean_aware_blink_duration+aware_SEM_blink_duration)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-7999:8000 fliplr(-7999:8000)], [mean_unaware_blink_duration-unaware_SEM_blink_duration fliplr(mean_unaware_blink_duration+unaware_SEM_blink_duration)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
plot(-7999:8000,mean_aware_blink_duration,'Color','blue','LineWidth',5)
plot(-7999:8000,mean_unaware_blink_duration,'Color',[1 0.7 0],'LineWidth',5)
xlim([-6000 2000])
ylim([0 400])
title(['Left Eye Blink Duration'])
ylabel(['Blink Duration (ms)'])
xlabel(['Time from Confirm'])
set(gca,'FontSize',24)
legend({'Aware','Unaware'})

all_avg_blink_duration_aware_temp = all_avg_blink_duration_aware_right;
all_avg_blink_duration_unaware_temp = all_avg_blink_duration_unaware_right;
% for subject = 1:size(all_avg_blink_duration_aware_temp)
%     for timepoint = 6000-(binsize/2+1):10000+(binsize/2)
%         all_avg_blink_duration_aware_temp(subject,timepoint) = mean(all_avg_blink_duration_aware_temp(subject,timepoint-(binsize/2):timepoint+(binsize/2-1)));
%         all_avg_blink_duration_unaware_temp(subject,timepoint) = mean(all_avg_blink_duration_unaware_temp(subject,timepoint-(binsize/2):timepoint+(binsize/2-1)));
% 
%     end
% end


%mean_aware_blink_duration = lowpass(mean(all_avg_blink_duration_aware_left),0.1,1000)*100;
%mean_unaware_blink_duration = lowpass(mean(all_avg_blink_duration_unaware_left),0.1,1000)*100;
mean_aware_blink_duration = nanmean(all_avg_blink_duration_aware_right);
mean_unaware_blink_duration = nanmean(all_avg_blink_duration_unaware_right);
for point = 1:length(mean_aware_blink_duration)
    aware_SEM_blink_duration(point) = nanstd(all_avg_blink_duration_aware_temp(:,point))/ sqrt(size(all_avg_blink_duration_aware_temp,1));
    unaware_SEM_blink_duration(point) = nanstd(all_avg_blink_duration_unaware_temp(:,point))/ sqrt(size(all_avg_blink_duration_unaware_temp,1));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end
%aware_SEM_blink_duration = lowpass(aware_SEM_blink_duration,0.1,1000)*100;
%unaware_SEM_blink_duration = lowpass(unaware_SEM_blink_duration,0.1,1000)*100;
figure
hold on
patch([-7999:8000 fliplr(-7999:8000)], [mean_aware_blink_duration-aware_SEM_blink_duration fliplr(mean_aware_blink_duration+aware_SEM_blink_duration)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-7999:8000 fliplr(-7999:8000)], [mean_unaware_blink_duration-unaware_SEM_blink_duration fliplr(mean_unaware_blink_duration+unaware_SEM_blink_duration)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
plot(-7999:8000,mean_aware_blink_duration,'Color','blue','LineWidth',5)
plot(-7999:8000,mean_unaware_blink_duration,'Color',[1 0.7 0],'LineWidth',5)
xlim([-6000 2000])
ylim([0 400])
title(['Right Eye Blink Duration'])
set(gca,'FontSize',24)
legend({'Aware','Unaware'})
ylabel(['Blink Duration (ms)'])
xlabel(['Time from Confirm'])

%% Plot blink duration with imputation



%mean_aware_blink_duration = lowpass(mean(all_avg_blink_duration_aware_left),0.1,1000)*100;
%mean_unaware_blink_duration = lowpass(mean(all_avg_blink_duration_unaware_left),0.1,1000)*100;
aware_SEM_blink_duration = zeros(1,16000);
unaware_SEM_blink_duration = zeros(1,16000);
mean_aware_blink_duration = nanmean(all_avg_blink_duration_aware_left);
mean_unaware_blink_duration = nanmean(all_avg_blink_duration_unaware_left);
for point = 1:length(mean_aware_blink_duration)
    aware_SEM_blink_duration(point) = nanstd(all_avg_blink_duration_aware_left(:,point))/ sqrt(size(all_avg_blink_duration_aware_left,1));
    unaware_SEM_blink_duration(point) = nanstd(all_avg_blink_duration_unaware_left(:,point))/ sqrt(size(all_avg_blink_duration_unaware_left,1));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end
%aware_SEM_blink_duration = lowpass(aware_SEM_blink_duration,0.1,1000)*100;
%unaware_SEM_blink_duration = lowpass(unaware_SEM_blink_duration,0.1,1000)*100;
figure
hold on
patch([-7999:8000 fliplr(-7999:8000)], [mean_aware_blink_duration-aware_SEM_blink_duration fliplr(mean_aware_blink_duration+aware_SEM_blink_duration)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-7999:8000 fliplr(-7999:8000)], [mean_unaware_blink_duration-unaware_SEM_blink_duration fliplr(mean_unaware_blink_duration+unaware_SEM_blink_duration)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
plot(-7999:8000,mean_aware_blink_duration,'Color','blue','LineWidth',5)
plot(-7999:8000,mean_unaware_blink_duration,'Color',[1 0.7 0],'LineWidth',5)
xlim([-6000 2000])
ylim([0 1000])
title(['Left Eye Blink Duration'])
ylabel(['Blink Duration (ms)'])
xlabel(['Time from Confirm'])
set(gca,'FontSize',24)
legend({'Aware','Unaware'})

all_avg_blink_duration_aware_temp = all_avg_blink_duration_aware_right;
all_avg_blink_duration_unaware_temp = all_avg_blink_duration_unaware_right;
% for subject = 1:size(all_avg_blink_duration_aware_temp)
%     for timepoint = 6000-(binsize/2+1):10000+(binsize/2)
%         all_avg_blink_duration_aware_temp(subject,timepoint) = mean(all_avg_blink_duration_aware_temp(subject,timepoint-(binsize/2):timepoint+(binsize/2-1)));
%         all_avg_blink_duration_unaware_temp(subject,timepoint) = mean(all_avg_blink_duration_unaware_temp(subject,timepoint-(binsize/2):timepoint+(binsize/2-1)));
% 
%     end
% end


%mean_aware_blink_duration = lowpass(mean(all_avg_blink_duration_aware_left),0.1,1000)*100;
%mean_unaware_blink_duration = lowpass(mean(all_avg_blink_duration_unaware_left),0.1,1000)*100;
mean_aware_blink_duration = nanmean(all_avg_blink_duration_aware_right);
mean_unaware_blink_duration = nanmean(all_avg_blink_duration_unaware_right);
for point = 1:length(mean_aware_blink_duration)
    aware_SEM_blink_duration(point) = nanstd(all_avg_blink_duration_aware_temp(:,point))/ sqrt(size(all_avg_blink_duration_aware_temp,1));
    unaware_SEM_blink_duration(point) = nanstd(all_avg_blink_duration_unaware_temp(:,point))/ sqrt(size(all_avg_blink_duration_unaware_temp,1));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end
%aware_SEM_blink_duration = lowpass(aware_SEM_blink_duration,0.1,1000)*100;
%unaware_SEM_blink_duration = lowpass(unaware_SEM_blink_duration,0.1,1000)*100;
figure
hold on
patch([-7999:8000 fliplr(-7999:8000)], [mean_aware_blink_duration-aware_SEM_blink_duration fliplr(mean_aware_blink_duration+aware_SEM_blink_duration)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-7999:8000 fliplr(-7999:8000)], [mean_unaware_blink_duration-unaware_SEM_blink_duration fliplr(mean_unaware_blink_duration+unaware_SEM_blink_duration)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
plot(-7999:8000,mean_aware_blink_duration,'Color','blue','LineWidth',5)
plot(-7999:8000,mean_unaware_blink_duration,'Color',[1 0.7 0],'LineWidth',5)
xlim([-6000 2000])
ylim([0 1000])
title(['Right Eye Blink Duration'])
set(gca,'FontSize',24)
legend({'Aware','Unaware'})
ylabel(['Blink Duration (ms)'])
xlabel(['Time from Confirm'])


%% Pupil Velocity
load('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Pupil_Timecourse_Permutation/timecourse_cluster_aware_vs_unaware_eye_left_E1_5000perm_velocity.mat')
sig_line = nan(1,8000);
sig_time_pts = sig_time_pts + 2000;
sig_line(sig_time_pts) = 1;


first_derivative_aware_left = zeros(size(all_avg_pupil_aware_left));

for subject = 1:size(all_avg_pupil_aware_left,1)
    for timepoint = 50:7950
        first_derivative_aware_left(subject,timepoint) = (all_avg_pupil_aware_left(subject,timepoint+50) - all_avg_pupil_aware_left(subject,timepoint-49)) * 1000 / 100;
    end
end

first_derivative_unaware_left = zeros(size(all_avg_pupil_unaware_left));

for subject = 1:size(all_avg_pupil_unaware_left,1)
    for timepoint = 50:7950
        first_derivative_unaware_left(subject,timepoint) = (all_avg_pupil_unaware_left(subject,timepoint+50) - all_avg_pupil_unaware_left(subject,timepoint-49)) * 1000 / 100;
    end
end


%mean_aware = lowpass(mean(all_avg_pupil_aware_left),0.1,1000)*100;
%mean_unaware = lowpass(mean(all_avg_pupil_unaware_left),0.1,1000)*100;
mean_aware_1stdev = nanmean(first_derivative_aware_left);
mean_unaware_1stdev = nanmean(first_derivative_unaware_left);
for point = 1:length(mean_aware_1stdev)
    aware_SEM(point) = nanstd(first_derivative_aware_left(:,point))/ sqrt(size(first_derivative_aware_left,1));
    unaware_SEM(point) = nanstd(first_derivative_unaware_left(:,point))/ sqrt(size(first_derivative_unaware_left,1));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end
%aware_SEM = lowpass(aware_SEM,0.1,1000)*100;
%unaware_SEM = lowpass(unaware_SEM,0.1,1000)*100;
figure
hold on
patch([-3999:4000 fliplr(-3999:4000)], [mean_aware_1stdev-aware_SEM fliplr(mean_aware_1stdev+aware_SEM)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-3999:4000 fliplr(-3999:4000)], [mean_unaware_1stdev-unaware_SEM fliplr(mean_unaware_1stdev+unaware_SEM)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
plot(-3999:4000,mean_aware_1stdev,'Color','blue','LineWidth',5)
plot(-3999:4000,mean_unaware_1stdev,'Color',[1 0.7 0],'LineWidth',5)
plot(-3999:4000,sig_line,'LineWidth',5,'Color','green')
xlim([-2000 2000])
% ylim([-0.2 1])
title(['Left Eye Velocity, N = ' num2str(size(first_derivative_aware_left,1))])
set(gca,'FontSize',24)
legend({'Aware','Unaware'})
ylabel(['Z-Scores per Second'])
xlabel(['Time from Confirm'])

load('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Pupil_Timecourse_Permutation/timecourse_cluster_aware_vs_unaware_eye_right_E1_5000perm_velocity.mat')
sig_line = nan(1,8000);
sig_time_pts = sig_time_pts + 2000;
sig_line(sig_time_pts) = 1;


first_derivative_aware_right = zeros(size(all_avg_pupil_aware_right));

for subject = 1:size(all_avg_pupil_aware_right,1)
    for timepoint = 50:7950
        first_derivative_aware_right(subject,timepoint) = (all_avg_pupil_aware_right(subject,timepoint+50) - all_avg_pupil_aware_right(subject,timepoint-49)) * 1000 / 100;
    end
end

first_derivative_unaware_right = zeros(size(all_avg_pupil_unaware_right));

for subject = 1:size(all_avg_pupil_unaware_right,1)
    for timepoint = 50:7950
        first_derivative_unaware_right(subject,timepoint) = (all_avg_pupil_unaware_right(subject,timepoint+50) - all_avg_pupil_unaware_right(subject,timepoint-49)) * 1000 / 100;
    end
end


%mean_aware = lowpass(mean(all_avg_pupil_aware_left),0.1,1000)*100;
%mean_unaware = lowpass(mean(all_avg_pupil_unaware_left),0.1,1000)*100;
mean_aware_1stdev = nanmean(first_derivative_aware_right);
mean_unaware_1stdev = nanmean(first_derivative_unaware_right);
for point = 1:length(mean_aware_1stdev)
    aware_SEM(point) = nanstd(first_derivative_aware_right(:,point))/ sqrt(size(first_derivative_aware_right,1));
    unaware_SEM(point) = nanstd(first_derivative_unaware_right(:,point))/ sqrt(size(first_derivative_unaware_right,1));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end
%aware_SEM = lowpass(aware_SEM,0.1,1000)*100;
%unaware_SEM = lowpass(unaware_SEM,0.1,1000)*100;
figure
hold on
patch([-3999:4000 fliplr(-3999:4000)], [mean_aware_1stdev-aware_SEM fliplr(mean_aware_1stdev+aware_SEM)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-3999:4000 fliplr(-3999:4000)], [mean_unaware_1stdev-unaware_SEM fliplr(mean_unaware_1stdev+unaware_SEM)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
plot(-3999:4000,mean_aware_1stdev,'Color','blue','LineWidth',5)
plot(-3999:4000,mean_unaware_1stdev,'Color',[1 0.7 0],'LineWidth',5)
plot(-3999:4000,sig_line,'LineWidth',5,'Color','green')
xlim([-2000 2000])
% ylim([-0.2 1])
title(['Right Eye Velocity, N = ' num2str(size(first_derivative_aware_right,1))])
set(gca,'FontSize',24)
legend({'Aware','Unaware'})
ylabel(['Z-Scores per Second'])
xlabel(['Time from Confirm'])
%% Remove 2s Raw, Difference

all_avg_remove2s_diff_left_raw = all_avg_remove2s_aware_left_raw - all_avg_remove2s_unaware_left_raw;
all_avg_remove2s_diff_right_raw = all_avg_remove2s_aware_right_raw - all_avg_remove2s_unaware_right_raw;

diff_SEM = zeros(1,8000);
mean_diff_remove2s_left = nanmean(all_avg_remove2s_diff_left_raw);
for point = 1:length(all_avg_remove2s_diff_left_raw)
    diff_SEM(point) = nanstd(all_avg_remove2s_diff_left_raw(:,point))/ sqrt(size(all_avg_remove2s_diff_left_raw,1));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end

figure
hold on
patch([-3999:4000 fliplr(-3999:4000)], [mean_diff_remove2s_left-diff_SEM fliplr(mean_diff_remove2s_left+diff_SEM)], [0 1 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
plot(-3999:4000,mean_diff_remove2s_left,'Color',[0 1 0],'LineWidth',5)
xlim([-2000 2000])
ylim([-0.1 0.1])
line([-3000 3000],[0 0])
title(['Left Eye Raw Paired Difference, N = ' num2str(size(all_avg_remove2s_diff_left_raw,1))])
ylabel(['Pupil Diameter (mm)'])
xlabel(['Time from Confirm'])
set(gca,'FontSize',24)
legend({'Aware minus Unaware'})

all_avg_remove2s_diff_right_raw = all_avg_remove2s_aware_right_raw - all_avg_remove2s_unaware_right_raw;
all_avg_remove2s_diff_right_raw = all_avg_remove2s_aware_right_raw - all_avg_remove2s_unaware_right_raw;

diff_SEM = zeros(1,8000);
mean_diff_remove2s_right = nanmean(all_avg_remove2s_diff_right_raw);
for point = 1:length(all_avg_remove2s_diff_right_raw)
    diff_SEM(point) = nanstd(all_avg_remove2s_diff_right_raw(:,point))/ sqrt(size(all_avg_remove2s_diff_right_raw,1));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end

figure
hold on
patch([-3999:4000 fliplr(-3999:4000)], [mean_diff_remove2s_right-diff_SEM fliplr(mean_diff_remove2s_right+diff_SEM)], [0 1 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
plot(-3999:4000,mean_diff_remove2s_right,'Color',[0 1 0],'LineWidth',5)
xlim([-2000 2000])
ylim([-0.1 0.1])
line([-3000 3000],[0 0])
title(['Right Eye Raw Paired Difference, N = ' num2str(size(all_avg_remove2s_diff_right_raw,1))])
ylabel(['Pupil Diameter (mm)'])
xlabel(['Time from Confirm'])
set(gca,'FontSize',24)
legend({'Aware minus Unaware'})


%% Raw Pupil Diameter, Left vs Right

load('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Pupil_Timecourse_Permutation/timecourse_cluster_aware_vs_unaware_eye_left_E1_5000perm_minus1000_baseline_raw.mat')
sig_left_raw = nan(1,8000);
sig_left_raw(sig_time_pts+2000) = 0.08;

load('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Pupil_Timecourse_Permutation/timecourse_cluster_aware_vs_unaware_eye_right_E1_5000perm_minus1000_baseline_raw.mat')
sig_right_raw = nan(1,8000);
sig_right_raw(sig_time_pts+2000) = 0.08;

diff_left_raw = all_avg_pupil_aware_left_raw - all_avg_pupil_unaware_left_raw;
diff_right_raw = all_avg_pupil_aware_right_raw - all_avg_pupil_unaware_right_raw;

diff_SEM_left = zeros(1,8000);
mean_diff_left = nanmean(diff_left_raw);
diff_SEM_right = zeros(1,8000);
mean_diff_right = nanmean(diff_right_raw);
for point = 1:8000
    diff_SEM_left(point) = nanstd(diff_left_raw(:,point))/ sqrt(size(diff_left_raw,1));
    diff_SEM_right(point) = nanstd(diff_right_raw(:,point))/ sqrt(size(diff_right_raw,1));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end

figure
hold on
plot(-3999:4000,sig_right_raw,'Color','green','LineWidth',5)
patch([-3999:4000 fliplr(-3999:4000)], [mean_diff_right-diff_SEM_right fliplr(mean_diff_right+diff_SEM_right)], [1 0 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
%patch([-3999:4000 fliplr(-3999:4000)], [mean_diff_left-diff_SEM_left fliplr(mean_diff_left+diff_SEM_left)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')

plot(-3999:4000,mean_diff_right,'Color',[1 0 0],'LineWidth',5)
%plot(-3999:4000,mean_diff_left,'Color',[0 0 1],'LineWidth',5)
xlim([-2000 2000])
ylim([-0.1 0.1])
line([-3000 3000],[0 0])
title(['Raw Paired Difference, Left N = ' num2str(size(diff_left_raw,1)) ', Right N = ' num2str(size(diff_right_raw,1))])
ylabel(['Pupil Diameter (mm)'])
xlabel(['Time from Confirm'])
set(gca,'FontSize',24)
legend({'Aware minus Unaware','Right Eye Difference'})

figure
hold on
plot(-3999:4000,sig_left_raw,'Color','green','LineWidth',5)
%patch([-3999:4000 fliplr(-3999:4000)], [mean_diff_right-diff_SEM_right fliplr(mean_diff_right+diff_SEM_right)], [1 0 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-3999:4000 fliplr(-3999:4000)], [mean_diff_left-diff_SEM_left fliplr(mean_diff_left+diff_SEM_left)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')

%plot(-3999:4000,mean_diff_right,'Color',[1 0 0],'LineWidth',5)
plot(-3999:4000,mean_diff_left,'Color',[0 0 1],'LineWidth',5)
xlim([-2000 2000])
ylim([-0.1 0.1])
line([-3000 3000],[0 0])
title(['Raw Paired Difference, Left N = ' num2str(size(diff_left_raw,1)) ', Right N = ' num2str(size(diff_right_raw,1))])
ylabel(['Pupil Diameter (mm)'])
xlabel(['Time from Confirm'])
set(gca,'FontSize',24)
legend({'Aware minus Unaware','Left Eye Difference'})


%% Raw Pupil Diameter, Left vs Right, -1000 to 0 baseline

load('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Pupil_Timecourse_Permutation/timecourse_cluster_aware_vs_unaware_eye_left_E1_5000perm_minus1000_baseline_raw.mat')
sig_left_raw = nan(1,8000);
sig_left_raw(sig_time_pts+2000) = 0.08;

load('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Pupil_Timecourse_Permutation/timecourse_cluster_aware_vs_unaware_eye_right_E1_5000perm_minus1000_baseline_raw.mat')
sig_right_raw = nan(1,8000);
sig_right_raw(sig_time_pts+2000) = 0.08;

diff_left_raw = all_avg_pupil_aware_left_raw - all_avg_pupil_unaware_left_raw;
% diff_left_raw = diff_left_raw - mean(diff_left_raw(:,3001:4000),2);
diff_right_raw = all_avg_pupil_aware_right_raw - all_avg_pupil_unaware_right_raw;
% diff_right_raw = diff_right_raw - mean(diff_right_raw(:,3001:4000),2);
diff_SEM_left = zeros(1,8000);
mean_diff_left = nanmean(diff_left_raw);
diff_SEM_right = zeros(1,8000);
mean_diff_right = nanmean(diff_right_raw);
for point = 1:8000
    diff_SEM_left(point) = nanstd(diff_left_raw(:,point))/ sqrt(size(diff_left_raw,1));
    diff_SEM_right(point) = nanstd(diff_right_raw(:,point))/ sqrt(size(diff_right_raw,1));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end

figure
hold on
plot(-3999:4000,sig_right_raw,'Color','green','LineWidth',5)
patch([-3999:4000 fliplr(-3999:4000)], [mean_diff_right-diff_SEM_right fliplr(mean_diff_right+diff_SEM_right)], [1 0 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
%patch([-3999:4000 fliplr(-3999:4000)], [mean_diff_left-diff_SEM_left fliplr(mean_diff_left+diff_SEM_left)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')

plot(-3999:4000,mean_diff_right,'Color',[1 0 0],'LineWidth',5)
%plot(-3999:4000,mean_diff_left,'Color',[0 0 1],'LineWidth',5)
xlim([-2000 2000])
ylim([-0.1 0.1])
line([-3000 3000],[0 0])
title(['Raw Paired Difference, Left N = ' num2str(size(diff_left_raw,1)) ', Right N = ' num2str(size(diff_right_raw,1))])
ylabel(['Pupil Diameter (mm)'])
xlabel(['Time from Confirm'])
set(gca,'FontSize',24)
legend({'Aware minus Unaware','Right Eye Difference'})

figure
hold on
plot(-3999:4000,sig_left_raw,'Color','green','LineWidth',5)
%patch([-3999:4000 fliplr(-3999:4000)], [mean_diff_right-diff_SEM_right fliplr(mean_diff_right+diff_SEM_right)], [1 0 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-3999:4000 fliplr(-3999:4000)], [mean_diff_left-diff_SEM_left fliplr(mean_diff_left+diff_SEM_left)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')

%plot(-3999:4000,mean_diff_right,'Color',[1 0 0],'LineWidth',5)
plot(-3999:4000,mean_diff_left,'Color',[0 0 1],'LineWidth',5)
xlim([-2000 2000])
ylim([-0.1 0.1])
line([-3000 3000],[0 0])
title(['Raw Paired Difference, Left N = ' num2str(size(diff_left_raw,1)) ', Right N = ' num2str(size(diff_right_raw,1))])
ylabel(['Pupil Diameter (mm)'])
xlabel(['Time from Confirm'])
set(gca,'FontSize',24)
legend({'Aware minus Unaware','Left Eye Difference'})
%% Plot Raw Pupil Diameter



%mean_aware_raw = lowpass(mean(all_avg_pupil_aware_left_raw),0.1,1000)*100;
%mean_unaware_raw = lowpass(mean(all_avg_pupil_unaware_left_raw),0.1,1000)*100;
mean_aware_raw = mean(all_avg_pupil_aware_left_raw);
mean_unaware_raw = mean(all_avg_pupil_unaware_left_raw);
for point = 1:length(mean_aware_raw)
    aware_SEM_raw(point) = std(all_avg_pupil_aware_left_raw(:,point))/ sqrt(size(all_avg_pupil_aware_left_raw,1));
    unaware_SEM_raw(point) = std(all_avg_pupil_unaware_left_raw(:,point))/ sqrt(size(all_avg_pupil_unaware_left_raw,1));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end
%aware_SEM_sac = lowpass(aware_SEM_sac,0.1,1000)*100;
%unaware_SEM_sac = lowpass(unaware_SEM_sac,0.1,1000)*100;
figure
hold on
patch([-3999:4000 fliplr(-3999:4000)], [mean_aware_raw-aware_SEM_raw fliplr(mean_aware_raw+aware_SEM_raw)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-3999:4000 fliplr(-3999:4000)], [mean_unaware_raw-unaware_SEM_raw fliplr(mean_unaware_raw+unaware_SEM_raw)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
plot(-3999:4000,mean_aware_raw,'Color','blue','LineWidth',5)
plot(-3999:4000,mean_unaware_raw,'Color',[1 0.7 0],'LineWidth',5)
xlim([-2000 2000])
ylim([3.4 4.1])
title(['Left Eye Raw Pupil Diameter, N = ' num2str(size(all_avg_pupil_aware_left_raw,1))])
set(gca,'FontSize',24)
legend({'Aware','Unaware'})
xlabel('Raw Pupil Diameter (mm)')
ylabel('Saccades per Second')
all_avg_sac_aware_temp = all_avg_pupil_aware_right_raw;
all_avg_sac_unaware_temp = all_avg_pupil_unaware_right_raw;



%mean_aware_raw = lowpass(mean(all_avg_pupil_aware_left_raw),0.1,1000)*100;
%mean_unaware_raw = lowpass(mean(all_avg_pupil_unaware_left_raw),0.1,1000)*100;
mean_aware_raw = mean(all_avg_pupil_aware_right_raw);
mean_unaware_raw = mean(all_avg_pupil_unaware_right_raw);
for point = 1:length(mean_aware_raw)
    aware_SEM_raw(point) = std(all_avg_sac_aware_temp(:,point))/ sqrt(size(all_avg_sac_aware_temp,1));
    unaware_SEM_raw(point) = std(all_avg_sac_unaware_temp(:,point))/ sqrt(size(all_avg_sac_unaware_temp,1));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end
%aware_SEM_sac = lowpass(aware_SEM_sac,0.1,1000)*100;
%unaware_SEM_sac = lowpass(unaware_SEM_sac,0.1,1000)*100;
figure
hold on
patch([-3999:4000 fliplr(-3999:4000)], [mean_aware_raw-aware_SEM_raw fliplr(mean_aware_raw+aware_SEM_raw)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-3999:4000 fliplr(-3999:4000)], [mean_unaware_raw-unaware_SEM_raw fliplr(mean_unaware_raw+unaware_SEM_raw)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
plot(-3999:4000,mean_aware_raw,'Color','blue','LineWidth',5)
plot(-3999:4000,mean_unaware_raw,'Color',[1 0.7 0],'LineWidth',5)
xlim([-2000 2000])
ylim([3.4 4.1])
title(['Right Eye Raw Pupil Diameter, N = ' num2str(size(all_avg_pupil_aware_right_raw,1))])
xlabel('Time from Confirm (ms)')
ylabel('Pupil Diameter (mm)')
set(gca,'FontSize',24)
legend({'Aware','Unaware'})

% %%
% cd('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Pupil_Figures')
% % Step 1: Get handles to all open figures
% figHandles = findall(0, 'Type', 'figure');
% 
% % Step 2: Iterate through each open figure
% for i = 1:length(figHandles)
%     % Switch focus to the current figure
%     figure(figHandles(i));
%     
%     % Get the title of the current figure
%     figTitle = get(get(gca, 'Title'), 'String');
%     set(gcf, 'Position', get(0, 'Screensize'));
%     % If the title is empty, skip saving this figure
%     if isempty(figTitle)
%         continue;
%     end
%     
%     % Set the 'Name' property to the figure title
%     set(figHandles(i), 'Name', figTitle);
%     
%     % Replace spaces in the title with underscores to make a valid file name
%     figTitle = strrep(figTitle, ' ', '_');
%     
%     % Save the figure as a .fig file
%     figFileName = sprintf('%s.fig', figTitle);
%     saveas(figHandles(i), figFileName);
%     
%     % Save the figure as a .png file
%     pngFileName = sprintf('%s.png', figTitle);
%     saveas(figHandles(i), pngFileName, 'png');
% end
