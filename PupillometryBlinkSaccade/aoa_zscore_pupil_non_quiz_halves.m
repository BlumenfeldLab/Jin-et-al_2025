%% This script z-scores pupils to their individual half session (i.e. runs 1, 2, and 3 are z-scored with respect to their mean and
% runs 4, 5, and 6 are z-scored with respect to theirs.
function unusable = aoa_zscore_pupil_non_quiz_halves(sheetToRead,eye);
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
    allSubjectNamesML = {};
    allSubjectNamesMH = {};
    unusable = 0;
    [num text raw] = xlsread(sheetToRead);

    for subject = 1:size(text,2)
        sessionPath = ['Y:\HNCT_AoA_Study\AoA_Subjects\'  raw{1,subject} '\' raw{2,subject} '\'];
        cd(sessionPath)
        fullsession = num2str(raw{3,subject});
        disp(['Analyzing ' raw{1,subject}])
        firstHalfInterp = [];
        secondHalfInterp = [];
        for run = 1:3
            session = [ fullsession(5:8) fullsession(10:11) num2str(run)];
            try
                load([session '_eyedat_' eye '_zscore_non_quiz_baseline.mat']);
                firstHalfInterp = [firstHalfInterp currentRunInterpQuizNaN];
            catch
                continue
            end
        end
        for run = 4:6
            session = [ fullsession(5:8) fullsession(10:11) num2str(run)];
            try
                load([session '_eyedat_' eye '_zscore_non_quiz_baseline.mat']);
                secondHalfInterp = [secondHalfInterp currentRunInterpQuizNaN];
            catch
                continue
            end
        end
        for run = 1:6
            
            try


                session = [ fullsession(5:8) fullsession(10:11) num2str(run)];
                if isfile([session '_eyedat_' eye '_zscore_non_quiz_halves.mat'])
                    continue
                end
                load([session '_eyedat_' eye '.mat']);
                
                if run == 1 || run == 2 || run == 3
                    wholerun_mean = nanmean(firstHalfInterp);
                    wholerun_stdev = nanstd(firstHalfInterp);
                elseif run == 4 || run == 5 || run == 6
                    wholerun_mean = nanmean(secondHalfInterp);
                    wholerun_stdev = nanstd(secondHalfInterp);
                end
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
                
                allSubjAware = [allSubjAware; awareconfirms_zscore];
                allSubjUnaware = [allSubjUnaware; unawareconfirms_zscore];
                allSubjML = [allSubjML; MLconfirms_zscore];
                allSubjMH = [allSubjMH; MHconfirms_zscore];
                eval(['save ' session '_eyedat_' eye '_zscore_non_quiz_halves.mat awareconfirms_zscore unawareconfirms_zscore MLconfirms_zscore MHconfirms_zscore'])

            catch
                %disp('Failed.')
                unusable = unusable + 1;
                continue
            end
        end
    end

    cd('Y:\HNCT_AoA_Study\AoA_Subjects')
    eval(['save aoa_group_data_aware_unaware_pupil_zscore_' eye '_non_quiz_halves.mat allSubjAware allSubjUnaware allSubjMH allSubjML allSubjectNamesAware allSubjectNamesUnaware allSubjectNamesML allSubjectNamesMH'])
    toc
    %%
    figure;
    hold on
    for confirm = 1:size(allSubjAware,1)
        plot(-3999:4000,allSubjAware(confirm,:));
    end
    xlim([-1999 2000])

    %%
    figure;
    hold on
    for confirm = 1:size(allSubjUnaware,1)
        plot(-3999:4000,allSubjUnaware(confirm,:));
    end
    xlim([-1999 2000])

    %%
    allSubjAwareNoNans = [];
    allSubjUnawareNoNans = [];
    for confirm = 1:size(allSubjAware,1)
        if sum(isnan(allSubjAware(confirm,:))) == 0 && min(allSubjAware(confirm,:))>-5;
            allSubjAwareNoNans = [allSubjAwareNoNans; allSubjAware(confirm,:)];
        end
    end
    for confirm = 1:size(allSubjUnaware,1)
        if sum(isnan(allSubjUnaware(confirm,:))) == 0 && min(allSubjUnaware(confirm,:))>-5;
            allSubjUnawareNoNans = [allSubjUnawareNoNans; allSubjUnaware(confirm,:)];
        end
    end


end
