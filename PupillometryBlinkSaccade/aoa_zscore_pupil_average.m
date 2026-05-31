clear all
clc
%%
eyes = {'left','right'};

[num text raw] = xlsread('Y:\HNCT_AoA_Study\AoA_Subjects\AoA_ERP_Blink_Check_Pupil.xlsx');
allPupilZscoreGroupAware = [];
allPupilZscoreGroupUnaware = [];
allPupilEpochsKeptLR = {};
for currenteye = 1:2
    
    eye = eyes{currenteye}
    allSubjAware = [];
    allSubjUnaware = [];
    allSubjectNamesAware = {};
    allSubjectNamesUnaware = {};
    for subject = 1:size(text,2)
        sessionPath = ['Y:\HNCT_AoA_Study\AoA_Subjects\'  raw{1,subject} '\' raw{2,subject} '\'];
        cd(sessionPath)
        fullsession = num2str(raw{3,subject});
        disp(['Analyzing ' raw{1,subject}])
        for run = 1:6
            try

                session = [ fullsession(5:8) fullsession(10:11) num2str(run)];
                load([session '_eyedat_' eye '_zscore_non_quiz_baseline.mat']);

                for confirm = 1:size(awareconfirms_zscore,1)
                    allSubjectNamesAware{end+1} = raw{1,subject};
                end

                for confirm = 1:size(unawareconfirms_zscore,1)
                    allSubjectNamesUnaware{end+1} = raw{1,subject};
                end
                allSubjAware = [allSubjAware; awareconfirms_zscore];
                allSubjUnaware = [allSubjUnaware; unawareconfirms_zscore];


            catch
                continue
            end
        end
    end

    %% Load in all aware and unaware trials with no NaNs 
    allSubjAwareNoNans = [];
    allSubjUnawareNoNans = [];
    allSubjectsNamesNoNansAware = {};
    allSubjectsNamesNoNansUnaware = {};
    for confirm = 1:size(allSubjAware,1)
        if sum(isnan(allSubjAware(confirm,:))) == 0 && min(allSubjAware(confirm,:))>-3 && sum(allSubjAware(confirm,:)==0)<8000 && std(allSubjAware(confirm,:)) > 0.1
            allSubjAwareNoNans = [allSubjAwareNoNans; allSubjAware(confirm,:)];
            allSubjectsNamesNoNansAware{end+1} = allSubjectNamesAware{confirm};
        end
    end
    for confirm = 1:size(allSubjUnaware,1)
        if sum(isnan(allSubjUnaware(confirm,:))) == 0 && min(allSubjUnaware(confirm,:))>-3 && sum(allSubjUnaware(confirm,:)==0)<8000 && std(allSubjUnaware(confirm,:)) > 0.1
            allSubjUnawareNoNans = [allSubjUnawareNoNans; allSubjUnaware(confirm,:)];
            allSubjectsNamesNoNansUnaware{end+1} = allSubjectNamesUnaware{confirm};
        end
    end

    %% Go through all pupil epochs, adding them to a cell by subject.
    allSubjectPupilEpochs = unique(allSubjectNamesAware)

    allSubjectPupilEpochs = [allSubjectPupilEpochs; cell(2,length(allSubjectPupilEpochs))];



    for confirm = 1:size(allSubjAwareNoNans,1)
        for subject = 1:size(allSubjectPupilEpochs,2)
            if strcmp(allSubjectPupilEpochs{1,subject},allSubjectsNamesNoNansAware{confirm})
                allSubjectPupilEpochs{2,subject} = [allSubjectPupilEpochs{2,subject}; allSubjAwareNoNans(confirm,:)];
            end
        end
    end

    for confirm = 1:size(allSubjUnawareNoNans,1)
        for subject = 1:size(allSubjectPupilEpochs,2)
            if strcmp(allSubjectPupilEpochs{1,subject},allSubjectsNamesNoNansUnaware{confirm})
                allSubjectPupilEpochs{3,subject} = [allSubjectPupilEpochs{3,subject}; allSubjUnawareNoNans(confirm,:)];
            end
        end
    end

    %% Using a minimum of 12 aware and unaware, eliminate subjects with too few trials
    allSubjectPupilEpochsKept = [];
    for subject = 1:size(allSubjectPupilEpochs,2);
        if size(allSubjectPupilEpochs{2,subject},1) >= 12 && size(allSubjectPupilEpochs{3,subject},1) >= 12
            allSubjectPupilEpochsKept = [allSubjectPupilEpochsKept allSubjectPupilEpochs(:,subject)];
        end
    end
    allSubjectPupilAverageAware = [];
    allSubjectPupilAverageUnaware = [];

    for subject = 1:size(allSubjectPupilEpochsKept,2)
        allSubjectPupilAverageAware = [allSubjectPupilAverageAware; mean(allSubjectPupilEpochsKept{2,subject})];
        allSubjectPupilAverageUnaware = [allSubjectPupilAverageUnaware; mean(allSubjectPupilEpochsKept{3,subject})];
    end

    allSubjectPupilAverageDiff = allSubjectPupilAverageAware - allSubjectPupilAverageUnaware;

    %% Plot aware vs unaware z-scores
    figure;
    hold on
    semAware = std(allSubjectPupilAverageAware)/sqrt(size(allSubjectPupilAverageAware,1));
    semUnaware = std(allSubjectPupilAverageUnaware)/sqrt(size(allSubjectPupilAverageUnaware,1));
    semDiff = std(allSubjectPupilAverageDiff)/sqrt(size(allSubjectPupilAverageDiff,1));


    plot(-3999:4000,mean(allSubjectPupilAverageAware),'Color',[0 0 1],'LineWidth',4)
    plot(-3999:4000,mean(allSubjectPupilAverageUnaware),'Color',[1 0 0],'LineWidth',4)
    plot(-3999:4000,mean(allSubjectPupilAverageDiff),'Color',[0 1 0],'LineWidth',4)
    line([-2000 2000],[0 0])
    line([0 0],[-0.3 1])
    patch([-3999:4000 fliplr(-3999:4000)], [mean(allSubjectPupilAverageDiff)-semDiff fliplr(mean(allSubjectPupilAverageDiff)+semDiff)], [0 1 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat')
    patch([-3999:4000 fliplr(-3999:4000)], [mean(allSubjectPupilAverageAware)-semAware fliplr(mean(allSubjectPupilAverageAware)+semAware)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat')
    patch([-3999:4000 fliplr(-3999:4000)], [mean(allSubjectPupilAverageUnaware)-semUnaware fliplr(mean(allSubjectPupilAverageUnaware)+semUnaware)], [1 0 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat')
    plot(-3999:4000,mean(allSubjectPupilAverageAware)+semAware,'Color',[0 0 1])
    plot(-3999:4000,mean(allSubjectPupilAverageAware)-semAware,'Color',[0 0 1])
    plot(-3999:4000,mean(allSubjectPupilAverageUnaware)+semUnaware,'Color',[1 0 0])
    plot(-3999:4000,mean(allSubjectPupilAverageUnaware)-semUnaware,'Color',[1 0 0])
    plot(-3999:4000,mean(allSubjectPupilAverageDiff)+semDiff,'Color',[0 1 0])
    plot(-3999:4000,mean(allSubjectPupilAverageDiff)-semDiff,'Color',[0 1 0])
    plot(-3999:4000,mean(allSubjectPupilAverageDiff),'Color',[0 1 0],'LineWidth',4)
    plot(-3999:4000,mean(allSubjectPupilAverageAware),'Color',[0 0 1],'LineWidth',4)
    plot(-3999:4000,mean(allSubjectPupilAverageUnaware),'Color',[1 0 0],'LineWidth',4)


    xlim([-2000 2000])
    ylim([-0.3 1])
    xlabel('Time from Confirmation (ms)')
    ylabel('Z-score from Whole Run Baseline')

    legend({'Aware','Unaware','Aware Minus Unaware'})
    set(gca,'FontSize',24)
    title(['Pupil Diameter, Z-Scored to Run, N = ' num2str(size(allSubjectPupilEpochsKept,2))])

    
    
    allPupilEpochsKeptLR{end+1} = allSubjectPupilEpochsKept;
end


%% Create average aware and unaware group epochs for further analysis
allSubjectPupilAverageAwareEpochs = zeros(1,4000,size(allSubjectPupilAverageAware,1));
for item = 1:size(allSubjectPupilAverageAware,1)
    allSubjectPupilAverageAwareEpochs(1,:,item) = allSubjectPupilAverageAware(item,2001:6000);
end

allSubjectPupilAverageUnawareEpochs = zeros(1,4000,size(allSubjectPupilAverageUnaware,1));
for item = 1:size(allSubjectPupilAverageUnaware,1)
    allSubjectPupilAverageUnawareEpochs(1,:,item) = allSubjectPupilAverageUnaware(item,2001:6000);
end
