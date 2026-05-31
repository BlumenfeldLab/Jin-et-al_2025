% Calculates z-scored pupil diameter by reading through a sheet containing individual subject folders with Eyelink .edf files.
function unusable = aoa_zscore_pupil_non_quiz(sheetToRead,eye);
    allSubjAware = [];
    allSubjUnaware = [];
    allSubjML = [];
    allSubjMH = [];
    tic
    addpath('Y:\HNCT_AoA_Study\EyeLink_EDF_Reading')
    addpath(genpath('Y:\HNCT_AoA_Study\EyeLink_EDF_Reading'))
    addpath(genpath('X:\Marie_AoA_Work\eye\Create Session EyelinkTables\'))
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
    allSubjectNamesML = {};
    allSubjectNamesMH = {};
    unusable = 0;
    [num text raw] = xlsread(sheetToRead);

    for subject = 1:size(text,2)
        sessionPath = ['Y:\HNCT_AoA_Study\AoA_Subjects\'  raw{1,subject} '\' raw{2,subject} '\'];
        cd(sessionPath)
        fullsession = num2str(raw{3,subject});
        disp(['Analyzing ' raw{1,subject}])

        for run = 1:6
            
            try


                session = [ fullsession(5:8) fullsession(10:11) num2str(run)];
                if isfile([session '_eyedat_' eye '_zscore_non_quiz_baseline.mat'])
                    continue
                end
                load([session '_eyedat_' eye '.mat']);
                
                runTimepoints = (currentEDF.Events.Messages.time-currentEDF.Events.Start.time);
                runMessages = currentEDF.Events.Messages.info;
                selectAfterQuizIndices = [];
                for timepoint = 1:length(quiztimepoints)
                    messageIndex = find(runTimepoints == quiztimepoints(timepoint));
                    for message = messageIndex:length(runTimepoints)
                        if length(runMessages{message}) >= 14 && strcmp(runMessages{message}(1:14),'block selected')
                            selectAfterQuizIndices = [selectAfterQuizIndices runTimepoints(message)];
                            break
                        elseif message == length(runTimepoints)
                            selectAfterQuizIndices = [selectAfterQuizIndices runTimepoints(message)];
                            break
                        end
                    end
                end
                % Enter NaNs for the quiz and its "answer selected" screen
                for item = 1:length(quiztimepoints)
                    currentRunInterp(quiztimepoints(item):selectAfterQuizIndices(item)) = NaN;
                end
                currentRunInterp(1:runTimepoints(12)) = NaN; 
                wholerun_mean = nanmean(currentRunInterp);
                wholerun_stdev = nanstd(currentRunInterp);
                awareconfirms_zscore = zeros(size(awareconfirms));
                for confirm = 1:size(awareconfirms_zscore,1)
                    for point = 1:size(awareconfirms_zscore,2)
                        awareconfirms_zscore(confirm,point) = (awareconfirms(confirm,point) - wholerun_mean) / wholerun_stdev;
                    end
                    allSubjectNamesAware{end+1} = raw{1,subject};
                end


                unawareconfirms_zscore = zeros(size(unawareconfirms));
                for confirm = 1:size(unawareconfirms_zscore,1)
                    for point = 1:size(unawareconfirms_zscore,2)
                        unawareconfirms_zscore(confirm,point) = (unawareconfirms(confirm,point) - wholerun_mean) / wholerun_stdev;
                    end
                    allSubjectNamesUnaware{end+1} = raw{1,subject};
                end
                
                MLconfirms_zscore = zeros(size(MLconfirms));
                for confirm = 1:size(MLconfirms_zscore,1)
                    for point = 1:size(MLconfirms_zscore,2)
                        MLconfirms_zscore(confirm,point) = (MLconfirms(confirm,point) - wholerun_mean) / wholerun_stdev;
                    end
                    allSubjectNamesML{end+1} = raw{1,subject};
                end
                
                MHconfirms_zscore = zeros(size(MHconfirms));
                for confirm = 1:size(MHconfirms_zscore,1)
                    for point = 1:size(MHconfirms_zscore,2)
                        MHconfirms_zscore(confirm,point) = (MHconfirms(confirm,point) - wholerun_mean) / wholerun_stdev;
                    end
                    allSubjectNamesMH{end+1} = raw{1,subject};
                end

                
                
                currentRunInterpQuizNaN = currentRunInterp;
                allSubjAware = [allSubjAware; awareconfirms_zscore];
                allSubjUnaware = [allSubjUnaware; unawareconfirms_zscore];
                allSubjMH = [allSubjMH; MHconfirms_zscore];
                allSubjML = [allSubjML; MLconfirms_zscore];
                currentRunInterpQuizNaN = currentRunInterp;
                eval(['save ' session '_eyedat_' eye '_zscore_non_quiz_baseline.mat awareconfirms_zscore unawareconfirms_zscore MHconfirms_zscore MLconfirms_zscore selectAfterQuizIndices currentRunInterpQuizNaN'])

            catch
                unusable = unusable + 1;
                continue
            end
        end
    end

    cd('Y:\HNCT_AoA_Study\AoA_Subjects')
    eval(['save aoa_group_data_aware_unaware_pupil_zscore_' eye '_non_quiz_baseline.mat allSubjAware allSubjUnaware allSubjectNamesAware allSubjectNamesUnaware'])
    toc
    %% Plot aware z-scores
    figure;
    hold on
    for confirm = 1:size(allSubjAware,1)
        plot(-3999:4000,allSubjAware(confirm,:));
    end
    xlim([-1999 2000])

    %% Plot unaware z-scores
    figure;
    hold on
    for confirm = 1:size(allSubjUnaware,1)
        plot(-3999:4000,allSubjUnaware(confirm,:));
    end
    xlim([-1999 2000])

 

end
