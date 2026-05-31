% Uses a spreadsheet containing all participants as well as the eye to be
% measured (Left = 1, Right = 2). Calculates pupil diameter as well as
% blinks.
function unusable = aoa_pupil_diameter_calculation(sheetToRead,eye)
    if strcmp(eye,'left')
        eyerownumber = 1;
    end
    if strcmp(eye,'right')
        eyerownumber = 2;
    end
    tic
    addpath('Y:\HNCT_AoA_Study\edf-converter-master')
    addpath(genpath('Y:\HNCT_AoA_Study\edf-converter-master'))
    addpath(genpath('X:\Marie_AoA_Work\eye\Create Session EyelinkTables\'))
    addpath(genpath('Y:\HNCT_AoA_Study\AoA_Pipeline\AoA_Eyelink_Analysis\Create Session EyelinkTables\'));
    quiztimes_all = [];
    confirmtimes_all = [];
    slidertimes_all = [];
    awareconfirms_all = [];
    unawareconfirms_all = [];
    MLconfirms_all = [];
    MHconfirms_all = [];

    
    [num text raw] = xlsread(sheetToRead);
    unusable = 0;
    for subject = 1:size(text,2)
        sessionPath = ['Y:\HNCT_AoA_Study\AoA_Subjects\'  raw{1,subject} '\' raw{2,subject} '\'];
        cd(sessionPath)
        fullsession = num2str(raw{3,subject});
        disp(['Analyzing ' raw{1,subject}])
        % For each run, load the .edf file and convert into real diameter.
        for run = 1:6
            session = [ fullsession(5:8) fullsession(10:11) num2str(run)]
            if isfile([sessionPath '/' session '_eyedat_left.mat']) && isfile([sessionPath '/' session '_eyedat_right.mat'])
                continue
            end
            try
                
                eval(['load ' fullsession '_run' num2str(run) '_designations_all_types.mat;']);
                eval(['designations = confidenceDesignations_run' num2str(run) ';']);
                currentEDF = Edf2Mat([session '.edf']);
                currentRun = currentEDF.RawEdf.FSAMPLE.pa(eyerownumber,:)/1350;
                currentGazeX = currentEDF.RawEdf.FSAMPLE.gx(eyerownumber,:);
                currentGazeY = currentEDF.RawEdf.FSAMPLE.gy(eyerownumber,:);



                allMessages = currentEDF.Events.Messages.info;
                allMessageTimes = currentEDF.Events.Messages.time;
                startTime = 1;
                endTime = length(currentRun);

                disappearingFound = 0;
                runTimeline = currentEDF.timeline;
                % Using the 'board disappearing' flag, look get all board
                % disappearances for further checking if a quiz has
                % occurred.
                for message = 1:length(allMessages)-1
                    if contains(allMessages{message},'board disappearing') && contains(allMessages{message+1},'showing quiz');
                        disappearingFound = disappearingFound + 1;
                        disappearingFound = allMessageTimes(message)-runTimeline(1);



                    end
                    if contains(allMessages{message},'block confirmed') && contains(allMessages{message+1},'board disappearing');
                        disappearingFound = disappearingFound + 1;
                        disappearingFound = allMessageTimes(message)-runTimeline(1);



                    end

                    if allMessageTimes(message)-runTimeline(1) > endTime
                       break
                    end
                end



                disp('Calculating blinks...')
                [~,blinktimes] = Stublinks60(currentRun,1000); % Calculate blinks using Stublinks algorithm
                currentRunBlinked = currentRun;
                currentRunBlinked(:,find(blinktimes(1,:) == 1)) = NaN;

                disp('Interpolating blinks from NaNs...')


                currTrial = currentRunBlinked; 

                if ~all(isnan(currTrial(:))) %%*****DIFFERENT FROM ORIGINAL

                    try
                        % attempt linear interpolation of all gaps in data formed 
                        % by the removal of blinks
                        currTrial = naninterp(currTrial); 
                    catch
                        % if it fails, entire trial is blink
                        warning(['Cannot interpolate, warning']);
                    end

                end

                % replace each trial
                currentRunInterp = currTrial; 


                %figure;
                %hold on
                quiztimes = [];
                confirmtimes = [];
                slidertimes = [];
                quiztimepoints = [];
                confirmtimepoints = [];
                slidertimepoints = [];
                unawareconfirms = [];
                awareconfirms = [];
                awareconfirmtimepoints = [];
                unawareconfirmtimepoints = [];
                MLconfirms = [];
                MHconfirms = [];
                MLconfirmtimepoints = [];
                MHconfirmtimepoints = [];
                
                
                % Find quiz timepoints using 'board disappearing', 'showing
                % quiz', and 'block confirmed' messages.
                for message = 1:length(allMessages)-1
                    if contains(allMessages{message},'board disappearing') && contains(allMessages{message+1},'showing quiz');
                        disappearingFound = disappearingFound + 1;
                        disappearingFound = allMessageTimes(message)-runTimeline(1);
                        if allMessageTimes(message)-runTimeline(1) >= startTime && allMessageTimes(message)-runTimeline(1) <= endTime
                            quiztimes = [quiztimes; currentRunInterp(allMessageTimes(message)-runTimeline(1)-3999:allMessageTimes(message)-runTimeline(1)+4000)];
                            quiztimepoints = [quiztimepoints allMessageTimes(message)-runTimeline(1)];
                        end


                    end
                    if contains(allMessages{message},'block confirmed') && contains(allMessages{message+1},'board disappearing');
                        disappearingFound = disappearingFound + 1;
                        disappearingFound = allMessageTimes(message)-runTimeline(1);
                        if allMessageTimes(message)-runTimeline(1) >= startTime && allMessageTimes(message)-runTimeline(1) <= endTime
                            try
                                confirmtimes = [confirmtimes; currentRunInterp(allMessageTimes(message)-runTimeline(1)-3999:allMessageTimes(message)-runTimeline(1)+4000)];
                                confirmtimepoints = [confirmtimepoints allMessageTimes(message)-runTimeline(1)];
                            catch
                                if allMessageTimes(message)-runTimeline(1)+4000 > length(currentRunInterp)
                                    disp('Epoch ran past the end of the run, adding last value for remainder of epoch')
                                    epochToAdd = currentRunInterp(allMessageTimes(message)-runTimeline(1)-3999:end);
                                    pointsToAdd = NaN(1,8000-length(epochToAdd))
                                    epochToAdd = [epochToAdd pointsToAdd];
                                    confirmtimes = [confirmtimes; epochToAdd];
                                    
                                    confirmtimepoints = [confirmtimepoints allMessageTimes(message)-runTimeline(1)];
                                end
                            end
                        end


                    end
                    if contains(allMessages{message},'showing quiz') && contains(allMessages{message+1},'slider submitted as')
                        if allMessageTimes(message)-runTimeline(1) >= startTime && allMessageTimes(message)-runTimeline(1) <= endTime
                            try
                                slidertimes = [slidertimes; currentRunInterp(allMessageTimes(message)-runTimeline(1)-3999:allMessageTimes(message)-runTimeline(1)+4000)];
                                slidertimepoints = [slidertimepoints allMessageTimes(message)-runTimeline(1)];
                            catch
                                disp('Ended run on a slider.')
                            end
                        end
                    end
                    if allMessageTimes(message)-runTimeline(1) > endTime
                       break
                    end
                end
                quizindices = zeros(1,length(confirmtimepoints));

                for timepoint = 1:length(slidertimepoints)

                    [val,idx] = min(abs(slidertimepoints(timepoint)-confirmtimepoints));
                    if confirmtimepoints(idx) > slidertimepoints(timepoint)
                        idx = idx-1;
                    end
                    quizindices(idx) = timepoint;
                end


                quiztimes_all = [quiztimes_all; quiztimes];
                confirmtimes_all = [confirmtimes_all; confirmtimes];
                slidertimes_all = [slidertimes_all; slidertimes];
                for confirmation = 1:length(confirmtimepoints)
                    if quizindices(confirmation) > 0
                        timepoint = quizindices(confirmation);
                        if strcmp(designations{timepoint},'Unaware')
                            unawareconfirms = [unawareconfirms; currentRunInterp(confirmtimepoints(confirmation)-3999:confirmtimepoints(confirmation)+4000)];
                            unawareconfirmtimepoints = [unawareconfirmtimepoints confirmtimepoints(confirmation)];
                        end
                        if strcmp(designations{timepoint},'Aware')
                            awareconfirms = [awareconfirms; currentRunInterp(confirmtimepoints(confirmation)-3999:confirmtimepoints(confirmation)+4000)];
                            awareconfirmtimepoints = [awareconfirmtimepoints confirmtimepoints(confirmation)];
                        end
                        if strcmp(designations{timepoint},'Incorrect Mid Low') || strcmp(designations{timepoint},'Correct Mid Low') 
                            MLconfirms = [MLconfirms; currentRunInterp(confirmtimepoints(confirmation)-3999:confirmtimepoints(confirmation)+4000)];
                            MLconfirmtimepoints = [MLconfirmtimepoints confirmtimepoints(confirmation)];
                        end
                        if strcmp(designations{timepoint},'Incorrect Mid High') || strcmp(designations{timepoint},'Correct Mid High')
                            MHconfirms = [MHconfirms; currentRunInterp(confirmtimepoints(confirmation)-3999:confirmtimepoints(confirmation)+4000)];
                            MHconfirmtimepoints = [MHconfirmtimepoints confirmtimepoints(confirmation)];
                        end
                    end
                end
                unawareconfirms_all = [unawareconfirms_all; unawareconfirms];
                awareconfirms_all = [awareconfirms_all; awareconfirms];
                MLconfirms_all = [MLconfirms_all; MLconfirms];
                MHconfirms_all = [MHconfirms_all; MHconfirms];
                if strcmp(eye,'left')
                    eval(['save ' sessionPath '/' session '_eyedat_left.mat awareconfirms unawareconfirms MLconfirms MHconfirms quiztimes confirmtimes slidertimes quiztimepoints confirmtimepoints slidertimepoints awareconfirmtimepoints unawareconfirmtimepoints MHconfirmtimepoints MLconfirmtimepoints currentEDF currentRunInterp currentRunBlinked blinktimes currentGazeX currentGazeY']); 
                end
                if strcmp(eye,'right')
                    eval(['save ' sessionPath '/' session '_eyedat_right.mat awareconfirms unawareconfirms MLconfirms MHconfirms quiztimes confirmtimes slidertimes quiztimepoints confirmtimepoints slidertimepoints awareconfirmtimepoints unawareconfirmtimepoints MHconfirmtimepoints MLconfirmtimepoints currentEDF currentRunInterp currentRunBlinked blinktimes currentGazeX currentGazeY']); 
                end
                disp(['Saved ' session ' eye data.'])
            catch
                unusable = unusable + 1;
                continue
            end

        end
    end
    toc
    %% List down all quiz and action times
    quiztimes = quiztimes_all;
    confirmtimes = confirmtimes_all;
    slidertimes = slidertimes_all;

    %% Plot pupil trace associated with the appearance of a quiz
    figure;
    hold on
    quiztimes(any(isnan(quiztimes), 2), :) = [];
    quiztimesMean = quiztimes;

    for quiz = 1:size(quiztimes,1)
       quiztimesMean(quiz,:) = quiztimes(quiz,:)-mean(quiztimes(quiz,:));
    end
    sem_quiztimes = std(quiztimes)/sqrt(size(quiztimes,1));
    mean_quiz_trace = mean(quiztimesMean,1);
    plot(-3999:4000,mean_quiz_trace,'LineWidth',5)
    plot(-3999:4000,mean_quiz_trace+sem_quiztimes,'Color',[0 0.5 0.5])
    plot(-3999:4000,mean_quiz_trace-sem_quiztimes,'Color',[0 0.5 0.5])
    for timepoint = 1:8000
        line([timepoint-4000 timepoint-4000],[mean_quiz_trace(timepoint)-sem_quiztimes(timepoint) mean_quiz_trace(timepoint)+sem_quiztimes(timepoint)],'Color',[0 0.75 0.75 0.1])

    end
    xlabel('Pupil Timecourse, Quiz Appearance')
    ylabel('Change from Mean of Timecourse (mm)')
    title('Time from Quiz Appearance (ms)')
    xlim([-2000 2000])
    %% Plot the pupil timecourse with regards to the confirm of an action
    figure;
    hold on
    confirmtimes(any(isnan(confirmtimes), 2), :) = [];
    confirmtimesMean = confirmtimes;

    for confirm = 1:size(confirmtimes,1)
       confirmtimesMean(confirm,:) = confirmtimes(confirm,:)-mean(confirmtimes(confirm,:));
    end
    sem_confirmtimes = std(confirmtimes)/sqrt(size(confirmtimes,1));
    mean_confirm_trace = mean(confirmtimesMean,1);
    plot(-3999:4000,mean_confirm_trace,'LineWidth',5)
    plot(-3999:4000,mean_confirm_trace+sem_confirmtimes,'Color',[0 0.5 0.5])
    plot(-3999:4000,mean_confirm_trace-sem_confirmtimes,'Color',[0 0.5 0.5])
    for timepoint = 1:8000
        line([timepoint-4000 timepoint-4000],[mean_confirm_trace(timepoint)-sem_confirmtimes(timepoint) mean_confirm_trace(timepoint)+sem_confirmtimes(timepoint)],'Color',[0 0.75 0.75 0.1])

    end
    xlabel('Pupil Timecourse, Confirmation and Screen Disappearance')
    ylabel('Change from Mean of Timecourse (mm)')
    title('Time from Screen Disappearance (ms)')
    xlim([-2000 2000])
    %% Plot pupil with regards to the selection of confidence by slider
    figure;
    hold on
    slidertimes(any(isnan(slidertimes), 2), :) = [];
    slidertimesMean = slidertimes;

    for slider = 1:size(slidertimes,1)
       slidertimesMean(slider,:) = slidertimes(slider,:)-mean(slidertimes(slider,:));
    end
    sem_slidertimes = std(slidertimes)/sqrt(size(slidertimes,1));
    mean_slider_trace = mean(slidertimesMean,1);
    plot(-3999:4000,mean_slider_trace,'LineWidth',5)
    plot(-3999:4000,mean_slider_trace+sem_slidertimes,'Color',[0 0.5 0.5])
    plot(-3999:4000,mean_slider_trace-sem_slidertimes,'Color',[0 0.5 0.5])
    for timepoint = 1:8000
        line([timepoint-4000 timepoint-4000],[mean_slider_trace(timepoint)-sem_slidertimes(timepoint) mean_slider_trace(timepoint)+sem_slidertimes(timepoint)],'Color',[0 0.75 0.75 0.1])

    end
    xlabel('Pupil Timecourse, Quiz Appearance')
    ylabel('Change from Mean of Timecourse (mm)')
    title('Time from Slider Selection (ms)')
    xlim([-2000 2000])
    %%
    unawareconfirms = unawareconfirms_all;
    awareconfirms = awareconfirms_all;
    unawareconfirms(any(isnan(unawareconfirms), 2), :) = [];
    awareconfirms(any(isnan(awareconfirms), 2), :) = [];
    figure;
    hold on
    unawareconfirmsMean = unawareconfirms;

    for confirmation = 1:size(unawareconfirms,1)
       unawareconfirmsMean(confirmation,:) = unawareconfirmsMean(confirmation,:)-mean(unawareconfirmsMean(confirmation,2000:6000));
    end
    unawareconfirmsMean(any(unawareconfirmsMean>1, 2), :) = [];
    unawareconfirmsMean(any(unawareconfirmsMean<-1, 2), :) = [];
    %legend({'Aware','Unaware'})
    awareconfirmsMean = awareconfirms;

    for confirmation = 1:size(awareconfirms,1)
       awareconfirmsMean(confirmation,:) = awareconfirmsMean(confirmation,:)-mean(awareconfirmsMean(confirmation,2000:6000));
    end
    awareconfirmsMean(any(awareconfirmsMean>1, 2), :) = [];
    awareconfirmsMean(any(awareconfirmsMean<-1, 2), :) = [];

    sem_aware = std(awareconfirms)/sqrt(size(awareconfirms,1));
    mean_aware_trace = mean(awareconfirmsMean,1);
    plot(-3999:4000,mean_aware_trace,'LineWidth',5,'Color','blue')

    sem_unaware = std(unawareconfirms)/sqrt(size(unawareconfirms,1));
    mean_unaware_trace = mean(unawareconfirmsMean,1);
    plot(-3999:4000,mean_unaware_trace,'LineWidth',5,'Color','red')



    plot(-3999:4000,mean_unaware_trace+sem_unaware,'Color',[1 0 0])
    plot(-3999:4000,mean_unaware_trace-sem_unaware,'Color',[1 0 0])
    for timepoint = 1:8000
        line([timepoint-4000 timepoint-4000],[mean_unaware_trace(timepoint)-sem_unaware(timepoint) mean_unaware_trace(timepoint)+sem_unaware(timepoint)],'Color',[0.8 0 0 0.1])

    end

    plot(-3999:4000,mean_aware_trace+sem_aware,'Color',[0 0 1])
    plot(-3999:4000,mean_aware_trace-sem_aware,'Color',[0 0 1])
    for timepoint = 1:8000
        line([timepoint-4000 timepoint-4000],[mean_aware_trace(timepoint)-sem_aware(timepoint) mean_aware_trace(timepoint)+sem_aware(timepoint)],'Color',[0 0 0.8 0.1])

    end
    MLconfirms = MLconfirms_all;
    MHconfirms = MHconfirms_all;
    MLconfirms(any(isnan(MLconfirms), 2), :) = [];
    MHconfirms(any(isnan(MHconfirms), 2), :) = [];

    MLconfirmsMean = MLconfirms;

    for confirmation = 1:size(MLconfirms,1)
       MLconfirmsMean(confirmation,:) = MLconfirmsMean(confirmation,:)-mean(MLconfirmsMean(confirmation,2000:6000));
    end
    MLconfirmsMean(any(MLconfirmsMean>1, 2), :) = [];
    MLconfirmsMean(any(MLconfirmsMean<-1, 2), :) = [];
    %legend({'Aware','UnMH'})
    MHconfirmsMean = MHconfirms;

    for confirmation = 1:size(MHconfirms,1)
       MHconfirmsMean(confirmation,:) = MHconfirmsMean(confirmation,:)-mean(MHconfirmsMean(confirmation,2000:6000));
    end
    MHconfirmsMean(any(MHconfirmsMean>1, 2), :) = [];
    MHconfirmsMean(any(MHconfirmsMean<-1, 2), :) = [];

    sem_MH = std(MHconfirms)/sqrt(size(MHconfirms,1));
    mean_MH_trace = mean(MHconfirmsMean,1);
    plot(-3999:4000,mean_MH_trace,'LineWidth',5,'Color','blue')

    sem_ML = std(MLconfirms)/sqrt(size(MLconfirms,1));
    mean_ML_trace = mean(MLconfirmsMean,1);
    plot(-3999:4000,mean_ML_trace,'LineWidth',5,'Color','red')



    plot(-3999:4000,mean_ML_trace+sem_ML,'Color',[1 0 0])
    plot(-3999:4000,mean_ML_trace-sem_ML,'Color',[1 0 0])
    for timepoint = 1:8000
        line([timepoint-4000 timepoint-4000],[mean_ML_trace(timepoint)-sem_ML(timepoint) mean_ML_trace(timepoint)+sem_ML(timepoint)],'Color',[0.8 0 0 0.1])

    end

    plot(-3999:4000,mean_MH_trace+sem_MH,'Color',[0 0 1])
    plot(-3999:4000,mean_MH_trace-sem_MH,'Color',[0 0 1])
    for timepoint = 1:8000
        line([timepoint-4000 timepoint-4000],[mean_MH_trace(timepoint)-sem_MH(timepoint) mean_MH_trace(timepoint)+sem_MH(timepoint)],'Color',[0 0 0.8 0.1])

    end
    xlabel('Pupil Timecourse, Confirmation (ms)')
    ylabel('Change from Mean of Timecourse (mm)')
    title('Time from Confirmation and Screen Disappearance')
    xlim([-2000 2000])
    ylim([-0.3 0.3])
    legend({['Aware, n = ' num2str(size(awareconfirmsMean,1))],['Unaware, n = ' num2str(size(unawareconfirmsMean,1))]})
    set(gca,'FontSize',24)
    
    
end