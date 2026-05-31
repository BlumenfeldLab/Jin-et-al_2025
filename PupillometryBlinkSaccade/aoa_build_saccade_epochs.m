% Reads a spreadsheet containing all participants and builds their saccade epochs based on whole run data.
function unusable = aoa_build_saccade_epochs(sheetToRead,eye);
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
    MLconfirms_all = [];
    MHconfirms_all = [];
    allSubjectEpochs = {};
    allSubjectNamesAware = {};
    allSubjectNamesUnaware = {};
    unusable = 0;
    [num text raw] = xlsread(sheetToRead);

    for subject = 1:size(text,2) % Iterate over all subjects, loading saccade data. Saccade data are saved as a binary
        sessionPath = ['Y:\HNCT_AoA_Study\AoA_Subjects\'  raw{1,subject} '\' raw{2,subject} '\'];
        cd(sessionPath)
        fullsession = num2str(raw{3,subject});
        disp(['Analyzing ' raw{1,subject}])
        for run = 1:6
            
            try


                session = [ fullsession(5:8) fullsession(10:11) num2str(run)];
                if isfile([session '_saccadedat_' eye '.mat'])
                    continue
                end
                load([session '_eyedat_' eye '.mat']);
                load([session '_saccade.mat']);
                awaresaccades = [];
                unawaresaccades = [];
                MHsaccades = [];
                MLsaccades = [];
                if strcmp(eye,'left')
                    saccadetimes = sacLOnes;
                elseif strcmp(eye,'right')
                    saccadetimes = sacROnes;
                end
                %Determine whether the earliest time in the epoch occurred prior to the
                %start of the run and nan-pad. Same goes for if the latest
                %timepoint in the epoch would be after the run ends.
                %Concatenate together epochs.
                if length(awareconfirmtimepoints) > 0
                    for timepoint = 1:length(awareconfirmtimepoints)
                        if awareconfirmtimepoints(timepoint) > 8000 && awareconfirmtimepoints(timepoint) < length(saccadetimes)-8000
                            awaresaccades = [awaresaccades; saccadetimes(awareconfirmtimepoints(timepoint)-7999:awareconfirmtimepoints(timepoint)+8000)];
                        end
                        if awareconfirmtimepoints(timepoint) <= 8000
                            disp(['Early timepoint found. Adding NaNs, run ' num2str(run)])
                            epochToAdd = [nan(1,8000-awareconfirmtimepoints(timepoint)) saccadetimes(1:awareconfirmtimepoints(timepoint)+8000)];
                            awaresaccades = [awaresaccades; epochToAdd];
                        end
                        if awareconfirmtimepoints(timepoint) >= length(saccadetimes)-8000
                            disp(['Late timepoint found. Adding NaNs, run ' num2str(run)])
                            epochToAdd = [saccadetimes(awareconfirmtimepoints(timepoint)-7999:end) nan(1,16000-length(saccadetimes(awareconfirmtimepoints(timepoint)-7999:end)))];
                            awaresaccades = [awaresaccades; epochToAdd];
                        end
                    end
                end
                if length(unawareconfirmtimepoints) > 0
                    for timepoint = 1:length(unawareconfirmtimepoints)
                        if unawareconfirmtimepoints(timepoint) > 8000 && unawareconfirmtimepoints(timepoint) < length(saccadetimes)-8000
                            unawaresaccades = [unawaresaccades; saccadetimes(unawareconfirmtimepoints(timepoint)-7999:unawareconfirmtimepoints(timepoint)+8000)];
                        end
                        if unawareconfirmtimepoints(timepoint) <= 8000
                            disp(['Early timepoint found. Adding NaNs, run ' num2str(run)])
                            epochToAdd = [nan(1,8000-unawareconfirmtimepoints(timepoint)) saccadetimes(1:unawareconfirmtimepoints(timepoint)+8000)];
                            unawaresaccades = [unawaresaccades; epochToAdd];
                        end
                        if unawareconfirmtimepoints(timepoint) >= length(saccadetimes)-8000
                            disp(['Late timepoint found. Adding NaNs, run ' num2str(run)])
                            epochToAdd = [saccadetimes(unawareconfirmtimepoints(timepoint)-7999:end) nan(1,16000-length(saccadetimes(unawareconfirmtimepoints(timepoint)-7999:end)))];
                            unawaresaccades = [unawaresaccades; epochToAdd];
                        end
                    end
                end
                if length(MLconfirmtimepoints) > 0
                    for timepoint = 1:length(MLconfirmtimepoints)
                        if MLconfirmtimepoints(timepoint) > 8000 && MLconfirmtimepoints(timepoint) < length(saccadetimes)-8000
                            MLsaccades = [MLsaccades; saccadetimes(MLconfirmtimepoints(timepoint)-7999:MLconfirmtimepoints(timepoint)+8000)];
                        end
                        if MLconfirmtimepoints(timepoint) <= 8000
                            disp(['Early timepoint found. Adding NaNs, run ' num2str(run)])
                            epochToAdd = [nan(1,8000-MLconfirmtimepoints(timepoint)) saccadetimes(1:MLconfirmtimepoints(timepoint)+8000)];
                            MLsaccades = [MLsaccades; epochToAdd];
                        end
                        if MLconfirmtimepoints(timepoint) >= length(saccadetimes)-8000
                            disp(['Late timepoint found. Adding NaNs, run ' num2str(run)])
                            epochToAdd = [saccadetimes(MLconfirmtimepoints(timepoint)-7999:end) nan(1,16000-length(saccadetimes(MLconfirmtimepoints(timepoint)-7999:end)))];
                            MLsaccades = [MLsaccades; epochToAdd];
                        end
                    end
                end
                if length(MHconfirmtimepoints) > 0
                    for timepoint = 1:length(MHconfirmtimepoints)
                        if MHconfirmtimepoints(timepoint) > 8000 && MHconfirmtimepoints(timepoint) < length(saccadetimes)-8000
                            MHsaccades = [MHsaccades; saccadetimes(MHconfirmtimepoints(timepoint)-7999:MHconfirmtimepoints(timepoint)+8000)];
                        end
                        if MHconfirmtimepoints(timepoint) <= 8000
                            disp(['Early timepoint found. Adding NaNs, run ' num2str(run)])
                            epochToAdd = [nan(1,8000-MHconfirmtimepoints(timepoint)) saccadetimes(1:MHconfirmtimepoints(timepoint)+8000)];
                            MHsaccades = [MHsaccades; epochToAdd];
                        end
                        if MHconfirmtimepoints(timepoint) >= length(saccadetimes)-8000
                            disp(['Late timepoint found. Adding NaNs, run ' num2str(run)])
                            epochToAdd = [saccadetimes(MHconfirmtimepoints(timepoint)-7999:end) nan(1,16000-length(saccadetimes(MHconfirmtimepoints(timepoint)-7999:end)))];
                            MHsaccades = [MHsaccades; epochToAdd];
                        end
                    end
                end
                awaresaccades_durations = awaresaccades;
                unawaresaccades_durations = unawaresaccades;
                MLsaccades_durations = MLsaccades;
                MHsaccades_durations = MHsaccades;
                for item = 1:size(awaresaccades,1)
                    saccadestarts = [];
                    saccadeends = [];
                    currentepoch = awaresaccades(item,:);
                    if awaresaccades(item,1) == 1
                        saccadestarts = [saccadestarts item];
                    end
                    for timepoint = 2:length(awaresaccades)
                        if awaresaccades(item,timepoint) == 1 && (awaresaccades(item,timepoint-1) == 0 || isnan(awaresaccades(item,timepoint-1)))
                            saccadestarts = [saccadestarts timepoint];
                        end
                        if (awaresaccades(item,timepoint) == 0 || isnan(awaresaccades(item,timepoint))) && awaresaccades(item,timepoint-1) == 1  
                            saccadeends = [saccadeends timepoint];
                        end
                    end
                    if length(saccadeends) < length(saccadestarts)
                        saccadeends = [saccadeends 16000];
                    end
                    saccadediffs = saccadeends-saccadestarts;
                    for saccade = 1:length(saccadediffs)
                        awaresaccades_durations(item,saccadestarts(saccade):saccadeends(saccade)) = saccadediffs(saccade);
                    end
                end
                for item = 1:size(unawaresaccades,1)
                    saccadestarts = [];
                    saccadeends = [];
                    currentepoch = unawaresaccades(item,:);
                    if unawaresaccades(item,1) == 1
                        saccadestarts = [saccadestarts item];
                    end
                    % determine saccade starts and ends based on changing
                    % from 0 to 1 or 1 to 0
                    for timepoint = 2:length(unawaresaccades)
                        if unawaresaccades(item,timepoint) == 1 && (unawaresaccades(item,timepoint-1) == 0 || isnan(unawaresaccades(item,timepoint-1)))
                            saccadestarts = [saccadestarts timepoint];
                        end
                        if (unawaresaccades(item,timepoint) == 0 || isnan(unawaresaccades(item,timepoint))) && unawaresaccades(item,timepoint-1) == 1  
                            saccadeends = [saccadeends timepoint];
                        end
                    end
                    if length(saccadeends) < length(saccadestarts)
                        saccadeends = [saccadeends 16000];
                    end
                    saccadediffs = saccadeends-saccadestarts;
                    for saccade = 1:length(saccadediffs)
                        unawaresaccades_durations(item,saccadestarts(saccade):saccadeends(saccade)) = saccadediffs(saccade);
                    end
                end
                for item = 1:size(MHsaccades,1)
                    saccadestarts = [];
                    saccadeends = [];
                    currentepoch = MHsaccades(item,:);
                    if MHsaccades(item,1) == 1
                        saccadestarts = [saccadestarts item];
                    end
                    for timepoint = 2:length(MHsaccades)
                        if MHsaccades(item,timepoint) == 1 && (MHsaccades(item,timepoint-1) == 0 || isnan(MHsaccades(item,timepoint-1)))
                            saccadestarts = [saccadestarts timepoint];
                        end
                        if (MHsaccades(item,timepoint) == 0 || isnan(MHsaccades(item,timepoint))) && MHsaccades(item,timepoint-1) == 1  
                            saccadeends = [saccadeends timepoint];
                        end
                    end
                    if length(saccadeends) < length(saccadestarts)
                        saccadeends = [saccadeends 16000];
                    end
                    saccadediffs = saccadeends-saccadestarts;
                    for saccade = 1:length(saccadediffs)
                        MHsaccades_durations(item,saccadestarts(saccade):saccadeends(saccade)) = saccadediffs(saccade);
                    end
                end
                for item = 1:size(MLsaccades,1)
                    saccadestarts = [];
                    saccadeends = [];
                    currentepoch = MLsaccades(item,:);
                    if MLsaccades(item,1) == 1
                        saccadestarts = [saccadestarts item];
                    end
                    for timepoint = 2:length(MLsaccades)
                        if MLsaccades(item,timepoint) == 1 && (MLsaccades(item,timepoint-1) == 0 || isnan(MLsaccades(item,timepoint-1)))
                            saccadestarts = [saccadestarts timepoint];
                        end
                        if (MLsaccades(item,timepoint) == 0 || isnan(MLsaccades(item,timepoint))) && MLsaccades(item,timepoint-1) == 1  
                            saccadeends = [saccadeends timepoint];
                        end
                    end
                    if length(saccadeends) < length(saccadestarts)
                        saccadeends = [saccadeends 16000];
                    end
                    saccadediffs = saccadeends-saccadestarts;
                    for saccade = 1:length(saccadediffs)
                        MLsaccades_durations(item,saccadestarts(saccade):saccadeends(saccade)) = saccadediffs(saccade);
                    end
                end
                eval(['save ' session '_saccadedat_' eye '.mat awaresaccades unawaresaccades MLsaccades MHsaccades awaresaccades_durations unawaresaccades_durations MLsaccades_durations MHsaccades_durations'])

            catch
                %disp('Failed.')
                unusable = unusable + 1;
                continue
            end
        end
    end

    toc



end
