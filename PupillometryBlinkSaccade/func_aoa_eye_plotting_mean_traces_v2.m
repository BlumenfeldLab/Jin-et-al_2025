% This script aggregates subject data for pupil diameters, saccades, and
% blinks. It eliminates trials during which the tracker was lost.
function output_end = func_aoa_eye_plotting_mean_traces_v2(dataType,override);



    
    
    
    location = 's'
    
    if strcmp(location,'s')
    
        root = '/mnt/Data27/HNCT_AoA_Study/AoA_Subjects/';
    
    end
    if strcmp(location,'l')
        root = 'Y:/HNCT_AoA_Study/AoA_Subjects/';
    end
    addpath(root)
    [num text raw] = xlsread([root '/AoA_ERP_Blink_Check_Pupil.xlsx']);
    
    disp('Loading data...')
    
    tic    
    eyes = {'left','right'}
    for currenteye = 1:2
        if currenteye == 1
            eye = 'left'
        elseif currenteye == 2
            eye = 'right'
        end
        % Iterate over each subject, aggregating subject means for pupil
        % diameter, blink, and saccade. 
        for subject = 1:size(text,2)
            
            sessionPath = [root  raw{1,subject} '/' raw{2,subject} '/'];
            cd(sessionPath)
            fullsession = num2str(raw{3,subject});
            if isfile([fullsession '_mean_eye_metrics_' eye '_v5.mat']) && override == 0
                disp('Eye data already analyzed.')
                continue

            end
            disp(['Analyzing ' raw{1,subject}])
            allSubjAware = [];
            allSubjUnaware = [];
            allSubjML = [];
            allSubjMH = [];

            allSubjAwareRaw = [];
            allSubjUnawareRaw = [];
            allSubjMLRaw = [];
            allSubjMHRaw = [];

            if blink == 1
                allSubjBlinksAware = [];
                allSubjBlinksUnaware = [];
                allSubjBlinksML = [];
                allSubjBlinksMH = [];
            end
            if saccade == 1
                allSubjSaccadesAware = [];
                allSubjSaccadesUnaware = [];
                allSubjSaccadesML = [];
                allSubjSaccadesMH = [];
            end
    
            
            
            
            
            awareDisappearanceTimes = [];
            unawareDisappearanceTimes = [];
            MHDisappearanceTimes = [];
            MLDisappearanceTimes = [];

            % Raw pupil section
    
            for run = 1:6
                try
    
                    session = [ fullsession(5:8) fullsession(10:11) num2str(run)];
                    load([session '_eyedat_' eye '_zscore_non_quiz_halves.mat']);
                    if blink == 1
                        load([session '_blinkdat_' eye '.mat']);
                    end
                    load([session '_eyedat_' eye '.mat'],'awareconfirms','unawareconfirms');
                    load([session '_eyedat_' eye '.mat'],'awareconfirmtimepoints','unawareconfirmtimepoints','MHconfirmtimepoints','MLconfirmtimepoints')
                    load([session '_eyedat_' eye '.mat'],'quiztimepoints')
                    if saccade == 1
                        load([session '_saccadedat_' eye '.mat']);
                    end
                    allSubjAware = [allSubjAware; awareconfirms_zscore];
                    allSubjUnaware = [allSubjUnaware; unawareconfirms_zscore];
                    allSubjML = [allSubjML; MLconfirms_zscore];
                    allSubjMH = [allSubjMH; MHconfirms_zscore];
                       
                    allSubjAwareRaw = [allSubjAwareRaw; awareconfirms];
                    allSubjUnawareRaw = [allSubjUnawareRaw; unawareconfirms];
                    allSubjMLRaw = [allSubjMLRaw; MLconfirms_zscore];
                    allSubjMHRaw = [allSubjMHRaw; MHconfirms_zscore];

                    if blink == 1
                        allSubjBlinksAware = [allSubjBlinksAware; awareblinks_durations];
                        allSubjBlinksUnaware = [allSubjBlinksUnaware; unawareblinks_durations];
                        allSubjBlinksML = [allSubjBlinksML; MLblinks_durations];
                        allSubjBlinksMH = [allSubjBlinksMH; MHblinks_durations];
                        
                    end
    
                    if saccade == 1
                        allSubjSaccadesAware = [allSubjSaccadesAware; awaresaccades_durations];
                        allSubjSaccadesUnaware = [allSubjSaccadesUnaware; unawaresaccades_durations];
                        allSubjSaccadesML = [allSubjSaccadesML; MLsaccades_durations];
                        allSubjSaccadesMH = [allSubjSaccadesMH; MHsaccades_durations];
                    end
                    

                    
                    for confirm = 1:length(awareconfirmtimepoints)
                        awareDisappearanceTimes = [awareDisappearanceTimes min_positive_value(quiztimepoints - awareconfirmtimepoints(confirm))];
                    end
                    for confirm = 1:length(unawareconfirmtimepoints)
                        unawareDisappearanceTimes = [unawareDisappearanceTimes min_positive_value(quiztimepoints - unawareconfirmtimepoints(confirm))];
                    end
                    for confirm = 1:length(MHconfirmtimepoints)
                        MHDisappearanceTimes = [MHDisappearanceTimes min_positive_value(quiztimepoints - MHconfirmtimepoints(confirm))];
                    end
                    for confirm = 1:length(MLconfirmtimepoints)
                        MLDisappearanceTimes = [MLDisappearanceTimes min_positive_value(quiztimepoints - MLconfirmtimepoints(confirm))];
                    end
    
    
                    
                catch
                    disp('Did not load')
                    continue
                end
            end
            clear awareconfirms unawareconfirms awareconfirms_zscore unawareconfirms_zscore awareblinks_durations unawareblinks_durations awaresaccades_durations unawaresaccades_durations
            clear MLconfirms_zscore MHconfirms_zscore MLblinks_durations MLsaccades_durations MHsaccades_durations
            clear awareconfirmtimepoints unawareconfirmtimepoints MHconfirmtimepoints MLconfirmtimepoints quiztimepoints
            allSubjAwareNoNans = [];
            allSubjUnawareNoNans = [];
            allSubjAwareNoNansRaw = [];
            allSubjUnawareNoNansRaw = [];
            allSubjMHNoNans = [];
            allSubjMLNoNans = [];
            allSubjMHNoNansRaw = [];
            allSubjMLNoNansRaw = []; 
            if blink == 1
                allSubjAwareBlinksKept = [];
                allSubjUnawareBlinksKept = [];
                allSubjMHBlinksKept = [];
                allSubjMLBlinksKept = [];
            end
            if saccade == 1
                allSubjAwareSaccadesKept = [];
                allSubjUnawareSaccadesKept = [];
                allSubjMHSaccadesKept = [];
                allSubjMLSaccadesKept = [];
            end
    
            
            
            
            
            allSubjAwareRemove2s = [];
            allSubjUnawareRemove2s = [];
            allSubjMHRemove2s = [];
            allSubjMLRemove2s = [];
    
            allSubjAwareRemove2sTrials = 0;
            allSubjUnawareRemove2sTrials = 0;
            allSubjMHRemove2sTrials = 0;
            allSubjMLRemove2sTrials = 0;
            
            allSubjAwareNan2s = [];
            allSubjUnawareNan2s = [];
            allSubjMHNan2s = [];
            allSubjMLNan2s = [];
    
            allSubjAwareNan2sTrials = 0;
            allSubjUnawareNan2sTrials = 0;
            allSubjMHNan2sTrials = 0;
            allSubjMLNan2sTrials = 0;
    
            % Perform a comparison for the action epoch. Draw a line
            % between 2s pre-action and 2s post-action. If the correlation
            % coefficient between this and the actual epoch is greater than
            % 0.99, this means that the tracker has been lost, and the
            % epoch should be discarded.
            for confirm = 1:size(allSubjAware,1)
                comparisonEpoch = (allSubjAware(confirm,6000)-allSubjAware(confirm,2001))*[1:4000]/4000;
                comparisonOfEpochs = corrcoef(allSubjAware(confirm,2001:6000),comparisonEpoch);
                if comparisonOfEpochs(2) > 0.99 || isnan(comparisonOfEpochs(2))
                    disp(['Eye Disappearance Found, ' raw{1,subject}, ', Aware'])
                    continue
                end
                if sum(isnan(allSubjAware(confirm,:))) == 0 && min(allSubjAware(confirm,2001:6000))>-3.2 && sum(allSubjAware(confirm,:)==0)<8000 && std(allSubjAware(confirm,:)) > 0.1 && sum(allSubjAware(confirm,:)==min(allSubjAware(confirm,:))) < 4000 && max(allSubjAwareRaw(confirm,:))-min(allSubjAwareRaw(confirm,:)) < 10
                    allSubjAwareNoNans = [allSubjAwareNoNans; allSubjAware(confirm,:)];
                    allSubjAwareNoNansRaw = [allSubjAwareNoNansRaw; allSubjAwareRaw(confirm,:)];
                    if blink == 1
                        allSubjAwareBlinksKept = [allSubjAwareBlinksKept; allSubjBlinksAware(confirm,:)];
                    end
                    if saccade == 1
                        allSubjAwareSaccadesKept = [allSubjAwareSaccadesKept; allSubjSaccadesAware(confirm,:)];
                    end
                    
                    if floor(awareDisappearanceTimes(confirm)/1000) >= 3
                        allSubjAwareRemove2s = [allSubjAwareRemove2s; allSubjAware(confirm,:)];
                        allSubjAwareNan2s = [allSubjAwareNan2s; allSubjAware(confirm,:)];
                        allSubjAwareRemove2sTrials = allSubjAwareRemove2sTrials + 1;
                        allSubjAwareNan2sTrials = allSubjAwareNan2sTrials + 1;
                    elseif floor(awareDisappearanceTimes(confirm)/1000) < 3
                        allSubjAwareNan2s = [allSubjAwareNan2s; [allSubjAware(confirm,1:6000) nan(1,2000)]];
                        allSubjAwareNan2sTrials = allSubjAwareNan2sTrials + 1;
                    end  
    
    
                end
            end
            for confirm = 1:size(allSubjUnaware,1)
                comparisonEpoch = (allSubjUnaware(confirm,6000)-allSubjUnaware(confirm,2001))*[1:4000]/4000;
                comparisonOfEpochs = corrcoef(allSubjUnaware(confirm,2001:6000),comparisonEpoch);
                if comparisonOfEpochs(2) > 0.99 || isnan(comparisonOfEpochs(2))
                    disp(['Eye Disappearance Found, ' raw{1,subject}, ', Unaware'])
                    continue
                end
                if sum(isnan(allSubjUnaware(confirm,:))) == 0 && min(allSubjUnaware(confirm,2001:6000))>-3.2 && sum(allSubjUnaware(confirm,:)==0)<8000 && std(allSubjUnaware(confirm,:)) > 0.1 && sum(allSubjUnaware(confirm,:)==min(allSubjUnaware(confirm,:))) < 4000 && max(allSubjUnawareRaw(confirm,:))-min(allSubjUnawareRaw(confirm,:)) < 10
                    allSubjUnawareNoNans = [allSubjUnawareNoNans; allSubjUnaware(confirm,:)];
                    allSubjUnawareNoNansRaw = [allSubjUnawareNoNansRaw; allSubjUnawareRaw(confirm,:)];
                    if blink == 1
                        allSubjUnawareBlinksKept = [allSubjUnawareBlinksKept; allSubjBlinksUnaware(confirm,:)];
                    end
                    if saccade == 1
                        allSubjUnawareSaccadesKept = [allSubjUnawareSaccadesKept; allSubjSaccadesUnaware(confirm,:)];
                    end
                    if floor(unawareDisappearanceTimes(confirm)/1000) >= 3
                        allSubjUnawareRemove2s = [allSubjUnawareRemove2s; allSubjUnaware(confirm,:)];
                        allSubjUnawareNan2s = [allSubjUnawareNan2s; allSubjUnaware(confirm,:)];
                        allSubjUnawareRemove2sTrials = allSubjUnawareRemove2sTrials + 1;
                        allSubjUnawareNan2sTrials = allSubjUnawareNan2sTrials + 1;
                    elseif floor(unawareDisappearanceTimes(confirm)/1000) < 3
                        allSubjUnawareNan2s = [allSubjUnawareNan2s; [allSubjUnaware(confirm,1:6000) nan(1,2000)]];
                        allSubjUnawareNan2sTrials = allSubjUnawareNan2sTrials + 1;
                    end  
                end
            end
            for confirm = 1:size(allSubjMH,1)
                comparisonEpoch = (allSubjMH(confirm,6000)-allSubjMH(confirm,2001))*[1:4000]/4000;
                comparisonOfEpochs = corrcoef(allSubjMH(confirm,2001:6000),comparisonEpoch);
                if comparisonOfEpochs(2) > 0.99 || isnan(comparisonOfEpochs(2))
                    disp(['Eye Disappearance Found, ' raw{1,subject}, ', MH'])
                    continue
                end
                if sum(isnan(allSubjMH(confirm,:))) == 0 && min(allSubjMH(confirm,:))>-3.2 && sum(allSubjMH(confirm,:)==0)<8000 && std(allSubjMH(confirm,:)) > 0.1 && sum(allSubjMH(confirm,:)==min(allSubjMH(confirm,:))) < 4000 && max(allSubjMHRaw(confirm,:))-min(allSubjMHRaw(confirm,:)) < 10 
                    allSubjMHNoNans = [allSubjMHNoNans; allSubjMH(confirm,:)];
                    allSubjMHNoNansRaw = [allSubjMHNoNansRaw; allSubjMHRaw(confirm,:)];
                    if blink == 1
                        allSubjMHBlinksKept = [allSubjMHBlinksKept; allSubjBlinksMH(confirm,:)];
                    end
                    if saccade == 1
                        allSubjMHSaccadesKept = [allSubjMHSaccadesKept; allSubjSaccadesMH(confirm,:)];
                    end
                    if floor(MHDisappearanceTimes(confirm)/1000) >= 3
                        allSubjMHRemove2s = [allSubjMHRemove2s; allSubjMH(confirm,:)];
                        allSubjMHNan2s = [allSubjMHNan2s; allSubjMH(confirm,:)];
                        allSubjMHRemove2sTrials = allSubjMHRemove2sTrials + 1;
                        allSubjMHNan2sTrials = allSubjMHNan2sTrials + 1;
                    elseif floor(MHDisappearanceTimes(confirm)/1000) < 3
                        allSubjMHNan2s = [allSubjMHNan2s; [allSubjMH(confirm,1:6000) nan(1,2000)]];
                        allSubjMHNan2sTrials = allSubjMHNan2sTrials + 1;
                    end  
                end
            end
            for confirm = 1:size(allSubjML,1)
                comparisonEpoch = (allSubjML(confirm,6000)-allSubjML(confirm,2001))*[1:4000]/4000;
                comparisonOfEpochs = corrcoef(allSubjML(confirm,2001:6000),comparisonEpoch);
                if comparisonOfEpochs(2) > 0.99 || isnan(comparisonOfEpochs(2))
                    disp(['Eye Disappearance Found, ' raw{1,subject}, ', ML'])
                    continue
                end
                if sum(isnan(allSubjML(confirm,:))) == 0 && min(allSubjML(confirm,:))> -4 && sum(allSubjML(confirm,:)==0)<8000 && std(allSubjML(confirm,:)) > 0.1 && sum(allSubjML(confirm,:)==min(allSubjML(confirm,:))) < 4000 && max(allSubjMLRaw(confirm,:))-min(allSubjMLRaw(confirm,:))
                    allSubjMLNoNans = [allSubjMLNoNans; allSubjML(confirm,:)];
                    allSubjMLNoNansRaw = [allSubjMLNoNansRaw; allSubjMLRaw(confirm,:)];
                    if blink == 1
                        allSubjMLBlinksKept = [allSubjMLBlinksKept; allSubjBlinksML(confirm,:)];
                    end
                    if saccade == 1
                        allSubjMLSaccadesKept = [allSubjMLSaccadesKept; allSubjSaccadesML(confirm,:)];
                    end
                    if floor(MLDisappearanceTimes(confirm)/1000) >= 3
                        allSubjMLRemove2s = [allSubjMLRemove2s; allSubjML(confirm,:)];
                        allSubjMLNan2s = [allSubjMLNan2s; allSubjML(confirm,:)];
                        allSubjMLRemove2sTrials = allSubjMLRemove2sTrials + 1;
                        allSubjMLNan2sTrials = allSubjMLNan2sTrials + 1;
                    elseif floor(MLDisappearanceTimes(confirm)/1000) < 3
                        allSubjMLNan2s = [allSubjMLNan2s; [allSubjML(confirm,1:6000) nan(1,2000)]];
                        allSubjMLNan2sTrials = allSubjMLNan2sTrials + 1;
                    end  
                end
            end

            awaretrials = size(allSubjAwareNoNans,1);
            unawaretrials = size(allSubjUnawareNoNans,1);
            MHtrials = size(allSubjMHNoNans,1);
            MLtrials = size(allSubjMLNoNans,1);


            if saccade == 1
                allSubjUnawareSaccadesOnsets = zeros(size(allSubjUnawareSaccadesKept));
                for epoch = 1:size(allSubjUnawareSaccadesKept,1)
                    for timepoint = 2:16000
                        if allSubjUnawareSaccadesKept(epoch,timepoint) > 0 && allSubjUnawareSaccadesKept(epoch,timepoint-1) == 0
                            allSubjUnawareSaccadesOnsets(epoch,timepoint) = 1;
                        end
                    end   
                end
        
                allSubjAwareSaccadesOnsets = zeros(size(allSubjAwareSaccadesKept));
                for epoch = 1:size(allSubjAwareSaccadesKept,1)
                    for timepoint = 2:16000
                        if allSubjAwareSaccadesKept(epoch,timepoint) > 0 && allSubjAwareSaccadesKept(epoch,timepoint-1) == 0
                            allSubjAwareSaccadesOnsets(epoch,timepoint) = 1;
                        end
                    end
                end
                
                allSubjMHSaccadesOnsets = zeros(size(allSubjMHSaccadesKept));
                for epoch = 1:size(allSubjMHSaccadesKept,1)
                    for timepoint = 2:16000
                        if allSubjMHSaccadesKept(epoch,timepoint) > 0 && allSubjMHSaccadesKept(epoch,timepoint-1) == 0;
                            allSubjMHSaccadesOnsets(epoch,timepoint) = 1;
                        end
                    end
                end
        
                allSubjMLSaccadesOnsets = zeros(size(allSubjMLSaccadesKept));
                for epoch = 1:size(allSubjMLSaccadesKept,1)
                    for timepoint = 2:16000
                        if allSubjMLSaccadesKept(epoch,timepoint) > 0 && allSubjMLSaccadesKept(epoch,timepoint-1) == 0;
                            allSubjMLSaccadesOnsets(epoch,timepoint) = 1;
                        end
                    end
                end
            end
    
            allSubjAwareNoNansMean = mean(allSubjAwareNoNans);
            allSubjUnawareNoNansMean = mean(allSubjUnawareNoNans);
            allSubjMHNoNansMean = mean(allSubjMHNoNans);
            allSubjMLNoNansMean = mean(allSubjMLNoNans);
            
            if blink == 1
                allSubjRegBlinksAware = allSubjBlinksAware;
                allSubjRegBlinksUnaware = allSubjBlinksUnaware;
                allSubjRegBlinksMH = allSubjBlinksMH;
                allSubjRegBlinksML = allSubjBlinksML;
        
                allSubjRegBlinksAware((allSubjRegBlinksAware < 100 | allSubjRegBlinksAware >= 400)) = 0;
                allSubjRegBlinksUnaware((allSubjRegBlinksUnaware < 100 | allSubjRegBlinksUnaware >= 400)) = 0;
                allSubjRegBlinksMH((allSubjRegBlinksMH < 100 | allSubjRegBlinksMH >= 400)) = 0;
                allSubjRegBlinksML((allSubjRegBlinksML < 100 | allSubjRegBlinksML >= 400)) = 0;
        
                allSubjRegBlinkRateAware = mean(allSubjRegBlinksAware > 0);
                allSubjRegBlinkRateUnaware = mean(allSubjRegBlinksUnaware > 0);
                allSubjRegBlinkRateMH = mean(allSubjRegBlinksMH > 0);
                allSubjRegBlinkRateML = mean(allSubjRegBlinksML > 0);
                
        
                allSubjLongBlinksAware = allSubjBlinksAware;
                allSubjLongBlinksUnaware = allSubjBlinksUnaware;
                allSubjLongBlinksMH = allSubjBlinksMH;
                allSubjLongBlinksML = allSubjBlinksML;
            
            
    
                allSubjLongBlinksAware((allSubjLongBlinksAware < 400 | allSubjLongBlinksAware >= 1000)) = 0;
                allSubjLongBlinksUnaware((allSubjLongBlinksUnaware < 400 | allSubjLongBlinksUnaware >= 1000)) = 0;
                allSubjLongBlinksMH((allSubjLongBlinksMH < 400 | allSubjLongBlinksMH >= 1000)) = 0;
                allSubjLongBlinksML((allSubjLongBlinksML < 400 | allSubjLongBlinksML >= 1000)) = 0;
        
                allSubjLongBlinkRateAware = mean(allSubjLongBlinksAware > 0);
                allSubjLongBlinkRateUnaware = mean(allSubjLongBlinksUnaware > 0);
                allSubjLongBlinkRateMH = mean(allSubjLongBlinksMH > 0);
                allSubjLongBlinkRateML = mean(allSubjLongBlinksML > 0);
        
                allSubjBlinkDurationsAware = allSubjBlinksAware;
                allSubjBlinkDurationsUnaware = allSubjBlinksUnaware;
                allSubjBlinkDurationsMH = allSubjBlinksMH;
                allSubjBlinkDurationsML = allSubjBlinksML;
                
                allSubjBlinkDurationsAware(allSubjBlinkDurationsAware > 1000) = 0;
                allSubjBlinkDurationsUnaware(allSubjBlinkDurationsUnaware > 1000) = 0;
                allSubjBlinkDurationsMH(allSubjBlinkDurationsMH > 1000) = 0;
                allSubjBlinkDurationsML(allSubjBlinkDurationsML > 1000) = 0;
        
                allSubjBlinkDurationsAware(allSubjBlinkDurationsAware < 100) = 0;
                allSubjBlinkDurationsUnaware(allSubjBlinkDurationsUnaware < 100) = 0;
                allSubjBlinkDurationsMH(allSubjBlinkDurationsMH < 100) = 0;
                allSubjBlinkDurationsML(allSubjBlinkDurationsML < 100) = 0;
        
                allSubjBlinkDurationsAware(allSubjBlinkDurationsAware == 0) = NaN;
                allSubjBlinkDurationsUnaware(allSubjBlinkDurationsUnaware == 0) = NaN;
                allSubjBlinkDurationsMH(allSubjBlinkDurationsMH == 0) = NaN;
                allSubjBlinkDurationsML(allSubjBlinkDurationsML == 0) = NaN;

                % Empty vectors for filling with average sliding window blink durations
                allSubjAwareBlinkDurations = zeros(awaretrials,16000);
                allSubjUnawareBlinkDurations = zeros(unawaretrials,16000);
                allSubjMHBlinkDurations = zeros(MHtrials,16000);
                allSubjMLBlinkDurations = zeros(MLtrials,16000);

                binsize_blink = 200;

                for trial = 1:awaretrials

                    for timepoint = 1000-(binsize_blink/2+1):15000+(binsize_blink/2)
                        allSubjAwareBlinkDurations(trial,timepoint) = sum(allSubjBlinkDurationsAware(trial,timepoint-(binsize_blink/2+1):timepoint+binsize_blink))*(1000/binsize_blink);
                        
                    end
                end
                
                for trial = 1:MHtrials

                    for timepoint = 1000-(binsize_blink/2+1):15000+(binsize_blink/2)
                        allSubjMHBlinkDurations(trial,timepoint) = sum(allSubjBlinkDurationsMH(trial,timepoint-(binsize_blink/2+1):timepoint+binsize_blink))*(1000/binsize_blink);
                        
                    end
                end
                for trial = 1:MLtrials

                    for timepoint = 1000-(binsize_blink/2+1):15000+(binsize_blink/2)
                        allSubjMLBlinkDurations(trial,timepoint) = sum(allSubjBlinkDurationsML(trial,timepoint-(binsize_blink/2+1):timepoint+binsize_blink))*(1000/binsize_blink);
                        
                    end
                end
        
                for trial = 1:unawaretrials

                    for timepoint = 1000-(binsize_blink/2+1):15000+(binsize_blink/2)
                        allSubjUnawareBlinkDurations(trial,timepoint) = sum(allSubjBlinkDurationsUnaware(trial,timepoint-(binsize_blink/2+1):timepoint+binsize_blink))*(1000/binsize_blink);
                        
                    end
                    
                end

                meanBinAwareLongBlinks = zeros(1,16);
                meanBinUnawareLongBlinks = zeros(1,16);
                meanBinMHLongBlinks = zeros(1,16);
                meanBinMLLongBlinks = zeros(1,16);

                fullbins = 0:1000:15000;
                allSubjAwareLongBlinksOnsets = zeros(size(allSubjLongBlinksAware));
                for epoch = 1:size(allSubjLongBlinksAware,1)
                    for timepoint = 2:16000
                        if allSubjLongBlinksAware(epoch,timepoint) > 0 && allSubjLongBlinksAware(epoch,timepoint-1) == 0
                            allSubjAwareLongBlinksOnsets(epoch,timepoint) = 1;
                        end
                    end   
                end
        
        
        
                allSubjUnawareLongBlinksOnsets = zeros(size(allSubjLongBlinksUnaware));
                for epoch = 1:size(allSubjLongBlinksUnaware,1)
                    for timepoint = 2:16000
                        if allSubjLongBlinksUnaware(epoch,timepoint) > 0 && allSubjLongBlinksUnaware(epoch,timepoint-1) == 0
                            allSubjUnawareLongBlinksOnsets(epoch,timepoint) = 1;
                        end
                    end   
                end
        
                allSubjMHLongBlinksOnsets = zeros(size(allSubjLongBlinksMH));
                for epoch = 1:size(allSubjLongBlinksMH,1)
                    for timepoint = 2:16000
                        if allSubjLongBlinksMH(epoch,timepoint) > 0 && allSubjLongBlinksMH(epoch,timepoint-1) == 0
                            allSubjMHLongBlinksOnsets(epoch,timepoint) = 1;
                        end
                    end   
                end
        
                allSubjMLLongBlinksOnsets = zeros(size(allSubjLongBlinksML));
                for epoch = 1:size(allSubjLongBlinksML,1)
                    for timepoint = 2:16000
                        if allSubjLongBlinksML(epoch,timepoint) > 0 && allSubjLongBlinksML(epoch,timepoint-1) == 0
                            allSubjMLLongBlinksOnsets(epoch,timepoint) = 1;
                        end
                    end   
                end
                for bin = 1:16
                    if length(allSubjAwareLongBlinksOnsets) > 0
                        meanBinAwareLongBlinks(bin) = sum(mean(allSubjAwareLongBlinksOnsets(:,fullbins(bin)+1:fullbins(bin)+1000)));
                    end
                end
        
                for bin = 1:16
                    if length(allSubjUnawareLongBlinksOnsets) > 0
                        meanBinUnawareLongBlinks(bin) = sum(mean(allSubjUnawareLongBlinksOnsets(:,fullbins(bin)+1:fullbins(bin)+1000)));
                    end
                end
        
                for bin = 1:16
                    if length(allSubjMHLongBlinksOnsets) > 0
                        meanBinMHLongBlinks(bin) = sum(mean(allSubjMHLongBlinksOnsets(:,fullbins(bin)+1:fullbins(bin)+1000)));
                    end
                end
        
                for bin = 1:16
                    if length(allSubjMLLongBlinksOnsets) > 0
                        meanBinMLLongBlinks(bin) = sum(mean(allSubjMLLongBlinksOnsets(:,fullbins(bin)+1:fullbins(bin)+1000)));
                    end
                end

                allSubjMeanBlinkDurationsAware = nanmean(allSubjAwareBlinkDurations);
                allSubjMeanBlinkDurationsUnaware = nanmean(allSubjUnawareBlinkDurations);
                allSubjMeanBlinkDurationsMH = nanmean(allSubjMHBlinkDurations);
                allSubjMeanBlinkDurationsML = nanmean(allSubjMLBlinkDurations);
            end
    
            
    
            if saccade == 1
    
                allSubjSacRateAware = mean(allSubjAwareSaccadesKept > 0);
                allSubjSacRateUnaware = mean(allSubjUnawareSaccadesKept > 0);
                allSubjSacDurationsAwareNaN = allSubjAwareSaccadesKept;
                allSubjSacDurationsAwareNaN(allSubjSacDurationsAwareNaN == 0) = NaN;
                allSubjSacDurationsUnawareNaN = allSubjUnawareSaccadesKept;
                allSubjSacDurationsUnawareNaN(allSubjSacDurationsUnawareNaN == 0) = NaN;
        
                allSubjSacRateMH = mean(allSubjMHSaccadesKept > 0);
                allSubjSacRateML = mean(allSubjMLSaccadesKept > 0);
                allSubjSacDurationsMHNaN = allSubjMHSaccadesKept;
                allSubjSacDurationsMHNaN(allSubjSacDurationsMHNaN == 0) = NaN;
                allSubjSacDurationsMLNaN = allSubjMLSaccadesKept;
                allSubjSacDurationsMLNaN(allSubjSacDurationsMLNaN == 0) = NaN;
        
        
                

                
                % Empty vectors for filling with sliding window saccade onset rates
                allSubjAwareSaccadesOnsetRates = zeros(awaretrials,16000);
                allSubjUnawareSaccadesOnsetRates = zeros(unawaretrials,16000);
                allSubjMHSaccadesOnsetRates = zeros(MHtrials,16000);
                allSubjMLSaccadesOnsetRates = zeros(MLtrials,16000);
        
                % Empty vectors for filling with average sliding window saccade durations
                allSubjAwareSaccadesDurations = zeros(awaretrials,16000);
                allSubjUnawareSaccadesDurations = zeros(unawaretrials,16000);
                allSubjMHSaccadesDurations = zeros(MHtrials,16000);
                allSubjMLSaccadesDurations = zeros(MLtrials,16000);
                binsize = 100;

                for trial = 1:awaretrials
                    for timepoint = 1000-(binsize/2+1):15000+(binsize/2)
                        allSubjAwareSaccadesOnsetRates(trial,timepoint) = sum(allSubjAwareSaccadesOnsets(trial,timepoint-(binsize/2+1):timepoint+binsize))*(1000/binsize);
                        allSubjAwareSaccadesDurations(trial,timepoint) = nanmean(allSubjSacDurationsAwareNaN(trial,timepoint-(binsize/2+1):timepoint+binsize));
                    end
                end
                
                for trial = 1:MHtrials
                    for timepoint = 1000-(binsize/2+1):15000+(binsize/2)
                        allSubjMHSaccadesOnsetRates(trial,timepoint) = sum(allSubjMHSaccadesOnsets(trial,timepoint-(binsize/2+1):timepoint+binsize))*(1000/binsize); 
                        allSubjMHSaccadesDurations(trial,timepoint) = nanmean(allSubjSacDurationsMHNaN(trial,timepoint-(binsize/2+1):timepoint+binsize));
                    end
                end
                for trial = 1:MLtrials
                    for timepoint = 1000-(binsize/2+1):15000+(binsize/2)
                        allSubjMLSaccadesOnsetRates(trial,timepoint) = sum(allSubjMLSaccadesOnsets(trial,timepoint-(binsize/2+1):timepoint+binsize))*(1000/binsize); 
                        allSubjMLSaccadesDurations(trial,timepoint) = nanmean(allSubjSacDurationsMLNaN(trial,timepoint-(binsize/2+1):timepoint+binsize));
                    end
                end
        
                for trial = 1:unawaretrials
                    for timepoint = 1000-(binsize/2+1):15000+(binsize/2)
                        allSubjUnawareSaccadesOnsetRates(trial,timepoint) = sum(allSubjUnawareSaccadesOnsets(trial,timepoint-(binsize/2+1):timepoint+binsize))*(1000/binsize);
                        allSubjUnawareSaccadesDurations(trial,timepoint) = nanmean(allSubjSacDurationsUnawareNaN(trial,timepoint-(binsize/2+1):timepoint+binsize));
                    end
                end

                allSubjAwareSaccadesOnsetRates = mean(allSubjAwareSaccadesOnsetRates);
                allSubjUnawareSaccadesOnsetRates = mean(allSubjUnawareSaccadesOnsetRates);
                allSubjMHSaccadesOnsetRates = mean(allSubjMHSaccadesOnsetRates);
                allSubjMLSaccadesOnsetRates = mean(allSubjMLSaccadesOnsetRates);

                 allSubjMeanSacDurationAware = nanmean(allSubjAwareSaccadesDurations);
                allSubjMeanSacDurationUnaware = nanmean(allSubjUnawareSaccadesDurations);
                allSubjMeanSacDurationMH = nanmean(allSubjMHSaccadesDurations);
                allSubjMeanSacDurationML = nanmean(allSubjMLSaccadesDurations);
    

                
            end
    
             
    
            
            
    
            allSubjAwareRaw_minus2minus1 = allSubjAwareNoNansRaw;
            allSubjAwareRaw_minus1to0 = allSubjAwareNoNansRaw;
    
    
            allSubjUnawareRaw_minus2minus1 = allSubjUnawareNoNansRaw;
            allSubjUnawareRaw_minus1to0 = allSubjUnawareNoNansRaw;
    
            allSubjMHRaw_minus2minus1 = allSubjMHNoNansRaw;
            allSubjMHRaw_minus1to0 = allSubjMHNoNansRaw;
            
            allSubjMLRaw_minus2minus1 = allSubjMLNoNansRaw;
            allSubjMLRaw_minus1to0 = allSubjMLNoNansRaw;
    
            for trial = 1:awaretrials
                allSubjAwareRaw_minus2minus1(trial,:) = allSubjAwareRaw_minus2minus1(trial,:) - mean(allSubjAwareRaw_minus2minus1(trial,2001:3000));
                allSubjAwareRaw_minus1to0(trial,:) = allSubjAwareRaw_minus1to0(trial,:) - mean(allSubjAwareRaw_minus1to0(trial,3001:4000));
            end
            
            for trial = 1:MHtrials
                allSubjMHRaw_minus2minus1(trial,:) = allSubjMHRaw_minus2minus1(trial,:) - mean(allSubjMHRaw_minus2minus1(trial,2001:3000));
                allSubjMHRaw_minus1to0(trial,:) = allSubjMHRaw_minus1to0(trial,:) - mean(allSubjMHRaw_minus1to0(trial,3001:4000));
            end
            for trial = 1:MLtrials
                allSubjMLRaw_minus2minus1(trial,:) = allSubjMLRaw_minus2minus1(trial,:) - mean(allSubjMLRaw_minus2minus1(trial,2001:3000));
                allSubjMLRaw_minus1to0(trial,:) = allSubjMLRaw_minus1to0(trial,:) - mean(allSubjMLRaw_minus1to0(trial,3001:4000));
            end
    
            for trial = 1:unawaretrials
                allSubjUnawareRaw_minus2minus1(trial,:) = allSubjUnawareRaw_minus2minus1(trial,:) - mean(allSubjUnawareRaw_minus2minus1(trial,2001:3000));
                allSubjUnawareRaw_minus1to0(trial,:) = allSubjUnawareRaw_minus1to0(trial,:) - mean(allSubjUnawareRaw_minus1to0(trial,3001:4000));
            end
    
           
    
            allSubjAwareNoNansMeanRaw_minus2minus1 = mean(allSubjAwareRaw_minus2minus1);
            allSubjAwareNoNansMeanRaw_minus1to0 = mean(allSubjAwareRaw_minus1to0);
    
            allSubjMHNoNansMeanRaw_minus2minus1 = mean(allSubjMHRaw_minus2minus1);
            allSubjMHNoNansMeanRaw_minus1to0 = mean(allSubjMHRaw_minus1to0);
            
            allSubjMLNoNansMeanRaw_minus2minus1 = mean(allSubjMLRaw_minus2minus1);
            allSubjMLNoNansMeanRaw_minus1to0 = mean(allSubjMLRaw_minus1to0);
    
            allSubjUnawareNoNansMeanRaw_minus2minus1 = mean(allSubjUnawareRaw_minus2minus1);
            allSubjUnawareNoNansMeanRaw_minus1to0 = mean(allSubjUnawareRaw_minus1to0);
           
    
            
    
    
    
            
            
            
            
           
            
    
            save([fullsession '_mean_eye_metrics_' eye '_v5'])
            toc
            
        end
    
        
                
    
        
    end

end
