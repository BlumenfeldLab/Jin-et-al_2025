% This script takes whole-run blink .mat data and incorporates it into
% arrays of individual awareness designations.
function unusable = aoa_build_blink_epochs(sheetToRead,eye);
    allSubjAware = [];
    allSubjUnaware = [];
    allSubjML = [];
    allSubjMH = [];
    tic
    addpath('Y:\HNCT_AoA_Study\EyeLink_EDF_Reading')
    addpath(genpath('Y:\HNCT_AoA_Study\EyeLink_EDF_Reading'))
    addpath(genpath('Y:\HNCT_AoA_Study\AoA_Pipeline\AoA_Eyelink_Analysis\Create Session EyelinkTables\'));
    quiztimes_all = [];
    confirmtimes_all = [];
    slidertimes_all = [];
    awareconfirms_all = [];
    unawareconfirms_all = [];
    MHconfirms_all = [];
    MLconfirms_all = [];
    allSubjectEpochs = {};
    allSubjectNamesAware = {};
    allSubjectNamesUnaware = {};
    allSubjectNamesMH = {};
    allSubjectNamesML = {};
    unusable = 0;
    [num text raw] = xlsread(sheetToRead);

    for subject = 1:size(text,2)
    %for subject = size(text,2):size(text,2)
        sessionPath = ['Y:\HNCT_AoA_Study\AoA_Subjects\'  raw{1,subject} '\' raw{2,subject} '\'];
        cd(sessionPath)
        fullsession = num2str(raw{3,subject});
        disp(['Analyzing ' raw{1,subject}])
        for run = 1:6
            
            try


                session = [ fullsession(5:8) fullsession(10:11) num2str(run)];
                if isfile([session '_blinkdat_' eye '.mat'])
                    continue
                end
                load([session '_eyedat_' eye '.mat']);
                awareblinks = [];
                unawareblinks = [];
                MLblinks = [];
                MHblinks = [];
                % Having been calculated by Stublinks, the whole run is
                % stored as a binary (1 = blink, 0 = no blink). Based on
                % the epoch designations, add the individual epochs to
                % separate matrices. If an epoch would begin before or end
                % after the run, nan-pad the epoch.
                if length(awareconfirmtimepoints) > 0
                    for timepoint = 1:length(awareconfirmtimepoints)
                        if awareconfirmtimepoints(timepoint) > 8000 && awareconfirmtimepoints(timepoint) < length(blinktimes)-8000
                            awareblinks = [awareblinks; blinktimes(awareconfirmtimepoints(timepoint)-7999:awareconfirmtimepoints(timepoint)+8000)];
                        end
                        if awareconfirmtimepoints(timepoint) <= 8000
                            disp(['Early timepoint found. Adding NaNs, run ' num2str(run)])
                            epochToAdd = [nan(1,8000-awareconfirmtimepoints(timepoint)) blinktimes(1:awareconfirmtimepoints(timepoint)+8000)];
                            awareblinks = [awareblinks; epochToAdd];
                        end
                        if awareconfirmtimepoints(timepoint) >= length(blinktimes)-8000
                            disp(['Late timepoint found. Adding NaNs, run ' num2str(run)])
                            epochToAdd = [blinktimes(awareconfirmtimepoints(timepoint)-7999:end) nan(1,16000-length(blinktimes(awareconfirmtimepoints(timepoint)-7999:end)))];
                            awareblinks = [awareblinks; epochToAdd];
                        end
                    end
                end
                if length(unawareconfirmtimepoints) > 0
                    for timepoint = 1:length(unawareconfirmtimepoints)
                        if unawareconfirmtimepoints(timepoint) > 8000 && unawareconfirmtimepoints(timepoint) < length(blinktimes)-8000
                            unawareblinks = [unawareblinks; blinktimes(unawareconfirmtimepoints(timepoint)-7999:unawareconfirmtimepoints(timepoint)+8000)];
                        end
                        if unawareconfirmtimepoints(timepoint) <= 8000
                            disp(['Early timepoint found. Adding NaNs, run ' num2str(run)])
                            epochToAdd = [nan(1,8000-unawareconfirmtimepoints(timepoint)) blinktimes(1:unawareconfirmtimepoints(timepoint)+8000)];
                            unawareblinks = [unawareblinks; epochToAdd];
                        end
                        if unawareconfirmtimepoints(timepoint) >= length(blinktimes)-8000
                            disp(['Late timepoint found. Adding NaNs, run ' num2str(run)])
                            epochToAdd = [blinktimes(unawareconfirmtimepoints(timepoint)-7999:end) nan(1,16000-length(blinktimes(unawareconfirmtimepoints(timepoint)-7999:end)))];
                            unawareblinks = [unawareblinks; epochToAdd];
                        end
                    end
                end
                if length(MHconfirmtimepoints) > 0
                    for timepoint = 1:length(MHconfirmtimepoints)
                        if MHconfirmtimepoints(timepoint) > 8000 && MHconfirmtimepoints(timepoint) < length(blinktimes)-8000
                            MHblinks = [MHblinks; blinktimes(MHconfirmtimepoints(timepoint)-7999:MHconfirmtimepoints(timepoint)+8000)];
                        end
                        if MHconfirmtimepoints(timepoint) <= 8000
                            disp(['Early timepoint found. Adding NaNs, run ' num2str(run)])
                            epochToAdd = [nan(1,8000-MHconfirmtimepoints(timepoint)) blinktimes(1:MHconfirmtimepoints(timepoint)+8000)];
                            MHblinks = [MHblinks; epochToAdd];
                        end
                        if MHconfirmtimepoints(timepoint) >= length(blinktimes)-8000
                            disp(['Late timepoint found. Adding NaNs, run ' num2str(run)])
                            epochToAdd = [blinktimes(MHconfirmtimepoints(timepoint)-7999:end) nan(1,16000-length(blinktimes(MHconfirmtimepoints(timepoint)-7999:end)))];
                            MHblinks = [MHblinks; epochToAdd];
                        end
                    end
                end
                if length(MLconfirmtimepoints) > 0
                    for timepoint = 1:length(MLconfirmtimepoints)
                        if MLconfirmtimepoints(timepoint) > 8000 && MLconfirmtimepoints(timepoint) < length(blinktimes)-8000
                            MLblinks = [MLblinks; blinktimes(MLconfirmtimepoints(timepoint)-7999:MLconfirmtimepoints(timepoint)+8000)];
                        end
                        if MLconfirmtimepoints(timepoint) <= 8000
                            disp(['Early timepoint found. Adding NaNs, run ' num2str(run)])
                            epochToAdd = [nan(1,8000-MLconfirmtimepoints(timepoint)) blinktimes(1:MLconfirmtimepoints(timepoint)+8000)];
                            MLblinks = [MLblinks; epochToAdd];
                        end
                        if MLconfirmtimepoints(timepoint) >= length(blinktimes)-8000
                            disp(['Late timepoint found. Adding NaNs, run ' num2str(run)])
                            epochToAdd = [blinktimes(MLconfirmtimepoints(timepoint)-7999:end) nan(1,16000-length(blinktimes(MLconfirmtimepoints(timepoint)-7999:end)))];
                            MLblinks = [MLblinks; epochToAdd];
                        end
                    end
                end
                awareblinks_durations = awareblinks;
                unawareblinks_durations = unawareblinks;
                MLblinks_durations = MLblinks;
                MHblinks_durations = MHblinks;
                for item = 1:size(awareblinks,1)
                    blinkstarts = [];
                    blinkends = [];
                    currentepoch = awareblinks(item,:);
                    if awareblinks(item,1) == 1
                        blinkstarts = [blinkstarts item];
                    end
                    for timepoint = 2:length(awareblinks)
                        if awareblinks(item,timepoint) == 1 && (awareblinks(item,timepoint-1) == 0 || isnan(awareblinks(item,timepoint-1)))
                            blinkstarts = [blinkstarts timepoint];
                        end
                        if (awareblinks(item,timepoint) == 0 || isnan(awareblinks(item,timepoint))) && awareblinks(item,timepoint-1) == 1  
                            blinkends = [blinkends timepoint];
                        end
                    end
                    if length(blinkends) < length(blinkstarts)
                        blinkends = [blinkends 16000];
                    end
                    blinkdiffs = blinkends-blinkstarts;
                    for blink = 1:length(blinkdiffs)
                        awareblinks_durations(item,blinkstarts(blink):blinkends(blink)) = blinkdiffs(blink);
                    end
                end
                for item = 1:size(unawareblinks,1)
                    blinkstarts = [];
                    blinkends = [];
                    currentepoch = unawareblinks(item,:);
                    if unawareblinks(item,1) == 1
                        blinkstarts = [blinkstarts item];
                    end
                    for timepoint = 2:length(unawareblinks)
                        if unawareblinks(item,timepoint) == 1 && (unawareblinks(item,timepoint-1) == 0 || isnan(unawareblinks(item,timepoint-1)))
                            blinkstarts = [blinkstarts timepoint];
                        end
                        if (unawareblinks(item,timepoint) == 0 || isnan(unawareblinks(item,timepoint))) && unawareblinks(item,timepoint-1) == 1  
                            blinkends = [blinkends timepoint];
                        end
                    end
                    if length(blinkends) < length(blinkstarts)
                        blinkends = [blinkends 16000];
                    end
                    blinkdiffs = blinkends-blinkstarts;
                    for blink = 1:length(blinkdiffs)
                        unawareblinks_durations(item,blinkstarts(blink):blinkends(blink)) = blinkdiffs(blink);
                    end
                end
                for item = 1:size(MLblinks,1)
                    blinkstarts = [];
                    blinkends = [];
                    currentepoch = MLblinks(item,:);
                    if MLblinks(item,1) == 1
                        blinkstarts = [blinkstarts item];
                    end
                    for timepoint = 2:length(MLblinks)
                        if MLblinks(item,timepoint) == 1 && (MLblinks(item,timepoint-1) == 0 || isnan(MLblinks(item,timepoint-1)))
                            blinkstarts = [blinkstarts timepoint];
                        end
                        if (MLblinks(item,timepoint) == 0 || isnan(MLblinks(item,timepoint))) && MLblinks(item,timepoint-1) == 1  
                            blinkends = [blinkends timepoint];
                        end
                    end
                    if length(blinkends) < length(blinkstarts)
                        blinkends = [blinkends 16000];
                    end
                    blinkdiffs = blinkends-blinkstarts;
                    for blink = 1:length(blinkdiffs)
                        MLblinks_durations(item,blinkstarts(blink):blinkends(blink)) = blinkdiffs(blink);
                    end
                end
                for item = 1:size(MHblinks,1)
                    blinkstarts = [];
                    blinkends = [];
                    currentepoch = MHblinks(item,:);
                    if MHblinks(item,1) == 1
                        blinkstarts = [blinkstarts item];
                    end
                    for timepoint = 2:length(MHblinks)
                        if MHblinks(item,timepoint) == 1 && (MHblinks(item,timepoint-1) == 0 || isnan(MHblinks(item,timepoint-1)))
                            blinkstarts = [blinkstarts timepoint];
                        end
                        if (MHblinks(item,timepoint) == 0 || isnan(MHblinks(item,timepoint))) && MHblinks(item,timepoint-1) == 1  
                            blinkends = [blinkends timepoint];
                        end
                    end
                    if length(blinkends) < length(blinkstarts)
                        blinkends = [blinkends 16000];
                    end
                    blinkdiffs = blinkends-blinkstarts;
                    for blink = 1:length(blinkdiffs)
                        MHblinks_durations(item,blinkstarts(blink):blinkends(blink)) = blinkdiffs(blink);
                    end
                end
                eval(['save ' session '_blinkdat_' eye '.mat awareblinks unawareblinks MLblinks MHblinks awareblinks_durations unawareblinks_durations MLblinks_durations MHblinks_durations'])

            catch
                %disp('Failed.')
                unusable = unusable + 1;
                continue
            end
        end
    end
    toc


end
