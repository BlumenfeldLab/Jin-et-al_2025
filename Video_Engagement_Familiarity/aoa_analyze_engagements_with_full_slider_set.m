%% This script analyzes video engagement ratings and familiarity ratings and compares them against awareness, unawareness, confidence, and accuracy
% Row 1: Number of quizzes shown
% Row 2: Proportion Aware
% Row 3: Proportion validated correct (all correct except lowest quartile)
% Row 4: Engagement Level (out of 5)
% Row 5: Familiarity Level (out of 5)
% Row 6: Video Identifier (1,3-10,12-14)
% Row 7: Overall Run position (out of 12)
% Row 8: Unawareness Rate
% Row 9: Proportion validated incorrect
% Row 10: Day run (out of 6)
% Row 11: All Incorrect
% Row 12: All Correct
% Row 13: All Confidences

%%
location = 'l'
if strcmp(location,'s')

    root = '/mnt/Data27/HNCT_AoA_Study/AoA_Subjects/';
    eeglabLocation = '/mnt/Data8/HNCT_AoA_Study/eeglab14_0_0b';
end
if strcmp(location,'l')
    root = 'Y:/HNCT_AoA_Study/AoA_Subjects/';
    eeglabLocation = 'Y:/HNCT_AoA_Study/eeglab14_0_0b';
end

cleanraw_dir = [eeglabLocation '/plugins/clean_rawdata-master'];
Photo_dir = [eeglabLocation '/sample_locs/GSN-HydroCel-257.sfp'];
%[num text raw] = xlsread([root '/AoA_Video_Engagement.xlsx']);
[num text raw] = xlsread([root '/AoA_All_Subjs_Data.xlsx']);
all_run_engagements = [];

tic
for session = 1:length(text);
    sessionDate = num2str(num(1,session));
    fileLocation = [root '/' text{1,session} '/' text{2,session} '/'];
    fileLocationBase = [root '/' text{1,session} '/'];
    disp(['Analyzing ' text{1,session} ', Day ' text{2,session}(end)])
    try
        fileFound = 0;
        subjectFolder = fileLocationBase;
        cd(subjectFolder)
        ratings = aoa_read_engagement_ratings(dir([subjectFolder '*.txt']).name);
        fileFound = 1;
        ratings = table2array(ratings);
        cd(fileLocation)


        runengagements = zeros(1,6);
        runengagements = [runengagements; zeros(1,6); zeros(1,6); zeros(1,6); zeros(1,6); zeros(1,6); zeros(1,6); zeros(1,6); zeros(1,6); zeros(1,6); zeros(1,6)];
        load([fileLocation sessionDate '_sliders_and_percentiles_timing.mat'])
        for run = 1:6
            try
                % load([fileLocation sessionDate '_run' num2str(run) '_designations_all_types.mat'])
                % eval(['runengagements(1,run) = length(confidenceDesignations_run' num2str(run) ');']); 
                % currentRunDesignations = eval(['confidenceDesignations_run' num2str(run)]);
                % 
                currentRunDesignations = sliderSuccessesAllPercentilesTiming(sliderSuccessesAllPercentilesTiming(:,5) == run,:);
                runengagements(1,run) = size(currentRunDesignations(~isnan(currentRunDesignations(:,5)),:),1); 
                awareCount = 0;
                verifiedCorrectCount = 0;
                unawareCount = 0;
                verifiedIncorrectCount = 0;
                correctCount = 0;
                incorrectCount = 0;
                for quiz = 1:size(currentRunDesignations,1)
                    if currentRunDesignations(quiz,4) == 1
                        correctCount = correctCount + 1;
                    end
                    if currentRunDesignations(quiz,4) == 0
                        incorrectCount = incorrectCount + 1;
                    end
                    if currentRunDesignations(quiz,3) > 75 && currentRunDesignations(quiz,4) == 1
                        awareCount = awareCount + 1;
                        verifiedCorrectCount = verifiedCorrectCount + 1;
                    end
                    if (currentRunDesignations(quiz,3) <= 75 & currentRunDesignations(quiz,3) > 50) && currentRunDesignations(quiz,4) == 1 %|| strcmp(currentRunDesignations{quiz},'Correct Mid Low')
                        verifiedCorrectCount = verifiedCorrectCount + 1;
                    end
                    if currentRunDesignations(quiz,3) < 25 && currentRunDesignations(quiz,4) == 0
                        unawareCount = unawareCount + 1;
                        verifiedIncorrectCount = verifiedIncorrectCount + 1;
                    end
                    if (currentRunDesignations(quiz,3) <= 50 & currentRunDesignations(quiz,3) > 25) && currentRunDesignations(quiz,4) == 0 %|| strcmp(currentRunDesignations{quiz},'Correct Mid Low') %|| strcmp(currentRunDesignations{quiz},'Incorrect Mid High')
                        verifiedIncorrectCount = verifiedIncorrectCount + 1;
                    end
                end
                runengagements(2,run) = awareCount/runengagements(1,run);
                runengagements(3,run) = verifiedCorrectCount/runengagements(1,run);
                runengagements(8,run) = unawareCount/runengagements(1,run);
                runengagements(9,run) = verifiedIncorrectCount/runengagements(1,run);
                runengagements(11,run) = correctCount/(correctCount+incorrectCount);
                runengagements(12,run) = incorrectCount/(correctCount+incorrectCount);
                indices = find(sliderSuccessesAllPercentilesTiming(:,5) == run);
                runengagements(13,run) = nanmean(sliderSuccessesAllPercentilesTiming(indices,3));
            catch
                disp('Run not worked')
                continue
            end
        end


        if strcmp(text{2,session},'Day2')
            for run = 1:6
                runengagements(4,run) = ratings(3,run);
                runengagements(5,run) = ratings(5,run);
                runengagements(6,run) = ratings(1,run);
                runengagements(7,run) = run;
                runengagements(10,run) = run;
            end
        elseif strcmp(text{2,session},'Day3')
            for run = 7:12
                runengagements(4,run-6) = ratings(3,run);
                runengagements(5,run-6) = ratings(5,run);
                runengagements(6,run-6) = ratings(1,run);
                runengagements(7,run-6) = run;
                runengagements(10,run-6) = run-6;
            end
        end
        if isempty(all_run_engagements)
            all_run_engagements = [{text{1,session}};{runengagements}];
        elseif ~isempty(all_run_engagements)
            checkForExist = 0;
            for subject = 1:size(all_run_engagements,2)
                if strcmp(all_run_engagements{1,subject},text{1,session})
                    checkForExist = subject;
                end
            end
            if checkForExist == 0
                all_run_engagements =[all_run_engagements [{text{1,session}};{runengagements}]];
            elseif checkForExist > 0
                %if length(all_run_engagements{2,checkForExist}) < 12
                    all_run_engagements{2,checkForExist} = [all_run_engagements{2,checkForExist} runengagements];
                %end
            end
        end

    catch
        if fileFound == 0
            disp('No text file found.')
        elseif fileFound == 1
            disp('Unable to get data.')
        end
        cd(fileLocation)
    end
end

%%
subjectcorrs = zeros(1,length(all_run_engagements));
subjectcorrpvals = zeros(1,length(all_run_engagements));
subjectrhos = zeros(1,length(all_run_engagements));
subjectspearmanpvals = zeros(1,length(all_run_engagements));
subjectCorrectCorrs = zeros(1,length(all_run_engagements));
subjectCorrectpvals = zeros(1,length(all_run_engagements));
subjectcolors = jet(length(all_run_engagements));

positiveCorrs = [];
negativeCorrs = [];

positiveRhos = [];
negativeRhos = [];

positiveCorrectCorrs = [];
negativeCorrectCorrs = [];

figure;
hold on;

for subject = 1:length(all_run_engagements)
    
    try
        all_run_engagements{2,subject}(:,find(all_run_engagements{2,subject}(1,:)==0)) = [];
        
    catch
        continue
    end
    subplot(5,10,subject)
   
   
    scatter(all_run_engagements{2,subject}(4,:),all_run_engagements{2,subject}(2,:),'filled')
    lsline
    set(groot,'defaultLineLineWidth',2.0)
    xlim([1 5])
    ylim([0 1])
     xlabel('Engagement Rating')
    ylabel('Awareness Level')
    %title(all_run_engagements{1,subject})
    [correlation pvalue] = corrcoef(all_run_engagements{2,subject}(2,:),all_run_engagements{2,subject}(4,:));
    subjectcorrs(subject) = correlation(1,2);
    subjectcorrpvals(subject) = pvalue(1,2);
    if correlation(1,2) >= 0
        positiveCorrs = [positiveCorrs correlation(1,2)];
    elseif correlation(1,2) < 0
        negativeCorrs = [negativeCorrs correlation(1,2)];
    end
    [rho spearmanp] = corr([all_run_engagements{2,subject}(2,:)' all_run_engagements{2,subject}(4,:)'],'Type','spearman');
    subjectrhos(subject) = rho(1,2);
    subjectspearmanpvals(subject) = spearmanp(1,2);
    if rho(1,2) >= 0
        positiveRhos = [positiveRhos rho(1,2)];
    elseif rho(1,2) < 0
        negativeRhos = [negativeRhos rho(1,2)];
    end
    
end


figure;
hold on
boxplot(subjectcorrs)

subjectcorrjitter = zeros(1,length(all_run_engagements));
for jitter = 1:length(subjectcorrjitter)
    subjectcorrjitter = 1 + (-1+2*rand(1,1))/64;
    scatter(subjectcorrjitter,subjectcorrs(jitter),60,'MarkerFaceColor','red','MarkerEdgeColor','black');
end

set(gca,'FontSize',24)
set(gca,'XTickLabel',[])
title('Subject Awareness vs. Video Engagement Rating')
ylabel('r-value')
ylim([-1 1])

figure;
hold on
boxplot(subjectrhos)

subjectcorrjitter = zeros(1,length(all_run_engagements));
for jitter = 1:length(subjectcorrjitter)
    subjectcorrjitter = 1 + (-1+2*rand(1,1))/64;
    scatter(subjectcorrjitter,subjectrhos(jitter),60,'MarkerFaceColor','red','MarkerEdgeColor','black');
end

set(gca,'FontSize',24)
set(gca,'XTickLabel',[])
title('Subject Awareness vs. Video Engagement Rating')
ylabel('{\rho}-value')
ylim([-1 1])


figure; hold on;
groups = [ones(1,length(positiveRhos))';2*ones(1,length(negativeRhos))'];
boxplot([positiveRhos'; negativeRhos'],groups)

subjectcorrjitter = zeros(1,length(positiveRhos));
for jitter = 1:length(subjectcorrjitter)
    subjectcorrjitter = 1 + (-1+2*rand(1,1))/64;
    scatter(subjectcorrjitter,positiveRhos(jitter),60,'MarkerFaceColor','red','MarkerEdgeColor','black');
end

subjectcorrjitter = zeros(1,length(negativeRhos));
for jitter = 1:length(subjectcorrjitter)
    subjectcorrjitter = 2 + (-1+2*rand(1,1))/64;
    scatter(subjectcorrjitter,negativeRhos(jitter),60,'MarkerFaceColor','blue','MarkerEdgeColor','black');
end
%%
%Row 1: Video Identifier
%Row 2: Engagement Level
%Row 3: Familiarity Level
%Row 4: Unawareness Rate
videoList = [1 3 4 5 6 7 8 9 10 12 13 14];
videoList = [num2cell(videoList); cell(1,12); cell(1,12); cell(1,12)];

for subject = 1:length(all_run_engagements)
    currentSubject = all_run_engagements{2,subject};
    for run = 1:size(currentSubject,2)
        for video = 1:length(videoList)
            if currentSubject(6,run) == videoList{1,video}
                videoList{2,video} = [videoList{2,video} currentSubject(4,run)];
                videoList{3,video} = [videoList{3,video} currentSubject(5,run)];
                videoList{4,video} = [videoList{4,video} currentSubject(8,run)];
            end
        end
    end
end

videoListMeans = videoList;
videoListstd = videoList;
for video = 1:length(videoList)
    for row = 1:4
        videoListMeans{row,video} = mean(videoListMeans{row,video});
        videoListstd{row,video} = std(videoListMeans{row,video});
    end
end

videoListMeans = cell2mat(videoListMeans);
videoListstd = cell2mat(videoListstd);

figure
bar(videoListMeans(2,:))
set(gca,'xticklabel',{'Vid 1','Vid 3','Vid 4','Vid 5','Vid 6','Vid 7','Vid 8','Vid 9','Vid 10','Vid 12','Vid 13','Vid 14'})
set(gca,'FontSize',24)
ylim([0 5])
title('Video Engagement Ratings')

%%
subjectcorrs = zeros(1,length(all_run_engagements));
subjectcorrpvals = zeros(1,length(all_run_engagements));
subjectrhos = zeros(1,length(all_run_engagements));
subjectspearmanpvals = zeros(1,length(all_run_engagements));
subjectCorrectCorrs = zeros(1,length(all_run_engagements));
subjectCorrectpvals = zeros(1,length(all_run_engagements));
subjectcolors = jet(length(all_run_engagements));

positiveCorrs = [];
negativeCorrs = [];

positiveRhos = [];
negativeRhos = [];

positiveCorrectCorrs = [];
negativeCorrectCorrs = [];

positiveRhoPvalsAccuracyEngagement = [];
negativeRhoPvalsAccuracyEngagement = [];
figure;
hold on;

for subject = 1:length(all_run_engagements)
    
    try
        all_run_engagements{2,subject}(:,find(all_run_engagements{2,subject}(1,:)==0)) = [];
        
    catch
        continue
    end
    subplot(5,10,subject)
   
   
    scatter(all_run_engagements{2,subject}(4,:),all_run_engagements{2,subject}(11,:),'filled')
    lsline
    set(groot,'defaultLineLineWidth',2.0)
    xlim([1 5])
    ylim([0 1])
     xlabel('Engagement Rating')
    ylabel('Accuracy')
    %title(all_run_engagements{1,subject})
    [correlation pvalue] = corrcoef(all_run_engagements{2,subject}(11,:),all_run_engagements{2,subject}(4,:));
    subjectcorrs(subject) = correlation(1,2);
    subjectcorrpvals(subject) = pvalue(1,2);
    if correlation(1,2) >= 0
        positiveCorrs = [positiveCorrs correlation(1,2)];
    elseif correlation(1,2) < 0
        negativeCorrs = [negativeCorrs correlation(1,2)];
    end
    [rho spearmanp] = corr([all_run_engagements{2,subject}(11,:)' all_run_engagements{2,subject}(4,:)'],'Type','spearman');
    subjectrhos(subject) = rho(1,2);
    subjectspearmanpvals(subject) = spearmanp(1,2);
    if rho(1,2) >= 0
        positiveRhos = [positiveRhos rho(1,2)];
        positiveRhoPvalsAccuracyEngagement = [positiveRhoPvalsAccuracyEngagement spearmanp(1,2)];
    elseif rho(1,2) < 0
        negativeRhos = [negativeRhos rho(1,2)];
        negativeRhoPvalsAccuracyEngagement = [negativeRhoPvalsAccuracyEngagement spearmanp(1,2)];
    end
    
end


figure;
hold on
boxplot(subjectcorrs)

subjectcorrjitter = zeros(1,length(all_run_engagements));
for jitter = 1:length(subjectcorrjitter)
    subjectcorrjitter = 1 + (-1+2*rand(1,1))/64;
    scatter(subjectcorrjitter,subjectcorrs(jitter),60,'MarkerFaceColor','red','MarkerEdgeColor','black');
end

set(gca,'FontSize',24)
set(gca,'XTickLabel',[])
title('Subject Quiz Correct vs. Video Engagement Rating')
ylabel('r-value')
ylim([-1 1])

%%
subjectcorrs = zeros(1,length(all_run_engagements));
subjectcorrpvals = zeros(1,length(all_run_engagements));
subjectrhos = zeros(1,length(all_run_engagements));
subjectspearmanpvals = zeros(1,length(all_run_engagements));
subjectCorrectCorrs = zeros(1,length(all_run_engagements));
subjectCorrectpvals = zeros(1,length(all_run_engagements));
subjectcolors = jet(length(all_run_engagements));

positiveCorrs = [];
negativeCorrs = [];

positiveRhos = [];
negativeRhos = [];

positiveCorrectCorrs = [];
negativeCorrectCorrs = [];

positiveRhoPvalsAwarenessFamiliarity = [];
negativeRhoPvalsAwarenessFamiliarity = [];

positiveCorrPvalsAwarenessFamiliarity = [];
negativeCorrPvalsAwarenessFamiliarity = [];

figure;
hold on;

for subject = 1:length(all_run_engagements)
    % disp(['Analyzing subject ' num2str(subject)])
    % try
        all_run_engagements{2,subject}(:,find(all_run_engagements{2,subject}(1,:)==0)) = [];
        
    % catch
    %     continue
    % end
    subplot(5,10,subject)
   
   
    scatter(all_run_engagements{2,subject}(5,:),all_run_engagements{2,subject}(2,:),'filled')
    lsline
    set(groot,'defaultLineLineWidth',2.0)
    xlim([1 5])
    ylim([0 1])
    set(gca,'XTick',[1 2 3 4 5])
     xlabel('Familiarity Rating')
    ylabel('Awareness Level')
    %title(all_run_engagements{1,subject})
    [correlation pvalue] = corrcoef(all_run_engagements{2,subject}(2,:),all_run_engagements{2,subject}(5,:));
    subjectcorrs(subject) = correlation(1,2);
    subjectcorrpvals(subject) = pvalue(1,2);
    if correlation(1,2) >= 0
        positiveCorrs = [positiveCorrs correlation(1,2)];
        positiveCorrPvalsAwarenessFamiliarity = [positiveCorrPvalsAwarenessFamiliarity pvalue(1,2)];
    elseif correlation(1,2) < 0
        negativeCorrs = [negativeCorrs correlation(1,2)];
        negativeCorrPvalsAwarenessFamiliarity = [negativeCorrPvalsAwarenessFamiliarity pvalue(1,2)];
    end
    [rho spearmanp] = corr([all_run_engagements{2,subject}(2,:)' all_run_engagements{2,subject}(5,:)'],'Type','spearman');
    subjectrhos(subject) = rho(1,2);
    subjectspearmanpvals(subject) = spearmanp(1,2);
    
    if rho(1,2) >= 0
        positiveRhos = [positiveRhos rho(1,2)];
        positiveRhoPvalsAwarenessFamiliarity = [positiveRhoPvalsAwarenessFamiliarity spearmanp(1,2)];
    elseif rho(1,2) < 0
        negativeRhos = [negativeRhos rho(1,2)];
        negativeRhoPvalsAwarenessFamiliarity = [negativeRhoPvalsAwarenessFamiliarity spearmanp(1,2)];
    end
    
end


figure;
hold on
boxplot(subjectcorrs)

subjectcorrjitter = zeros(1,length(all_run_engagements));
for jitter = 1:length(subjectcorrjitter)
    subjectcorrjitter = 1 + (-1+2*rand(1,1))/64;
    scatter(subjectcorrjitter,subjectcorrs(jitter),60,'MarkerFaceColor','red','MarkerEdgeColor','black');
end

set(gca,'FontSize',24)
set(gca,'XTickLabel',[])
title('Subject Awareness vs. Video Familiarity Rating')
ylabel('r-value')
ylim([-1 1])

figure;
hold on
boxplot(subjectrhos)

subjectcorrjitter = zeros(1,length(all_run_engagements));
for jitter = 1:length(subjectcorrjitter)
    subjectcorrjitter = 1 + (-1+2*rand(1,1))/64;
    scatter(subjectcorrjitter,subjectrhos(jitter),60,'MarkerFaceColor','red','MarkerEdgeColor','black');
end

set(gca,'FontSize',24)
set(gca,'XTickLabel',[])
title('Subject Awareness vs. Video Familiarity Rating')
ylabel('{\rho}-value')
ylim([-1 1])


figure; hold on;
groups = [ones(1,length(positiveRhos))';2*ones(1,length(negativeRhos))'];
boxplot([positiveRhos'; negativeRhos'],groups)

subjectcorrjitter = zeros(1,length(positiveRhos));
for jitter = 1:length(subjectcorrjitter)
    subjectcorrjitter = 1 + (-1+2*rand(1,1))/64;
    scatter(subjectcorrjitter,positiveRhos(jitter),60,'MarkerFaceColor','red','MarkerEdgeColor','black');
end

subjectcorrjitter = zeros(1,length(negativeRhos));
for jitter = 1:length(subjectcorrjitter)
    subjectcorrjitter = 2 + (-1+2*rand(1,1))/64;
    scatter(subjectcorrjitter,negativeRhos(jitter),60,'MarkerFaceColor','blue','MarkerEdgeColor','black');
end


figure;
hold on

%%
%Row 1: Video Identifier
%Row 2: Familiarity Level
%Row 3: Familiarity Level
%Row 4: Unawareness Rate
videoList = [1 3 4 5 6 7 8 9 10 12 13 14];
videoList = [num2cell(videoList); cell(1,12); cell(1,12); cell(1,12)];

for subject = 1:length(all_run_engagements)
    currentSubject = all_run_engagements{2,subject};
    for run = 1:size(currentSubject,2)
        for video = 1:length(videoList)
            if currentSubject(6,run) == videoList{1,video}
                videoList{2,video} = [videoList{2,video} currentSubject(4,run)];
                videoList{3,video} = [videoList{3,video} currentSubject(5,run)];
                videoList{4,video} = [videoList{4,video} currentSubject(8,run)];
            end
        end
    end
end

videoListMeans = videoList;
videoListstd = videoList;
for video = 1:length(videoList)
    for row = 1:4
        videoListMeans{row,video} = mean(videoListMeans{row,video});
        videoListstd{row,video} = std(videoListMeans{row,video});
    end
end

videoListMeans = cell2mat(videoListMeans);
videoListstd = cell2mat(videoListstd);

figure
bar(videoListMeans(2,:))
set(gca,'xticklabel',{'Vid 1','Vid 3','Vid 4','Vid 5','Vid 6','Vid 7','Vid 8','Vid 9','Vid 10','Vid 12','Vid 13','Vid 14'})
set(gca,'FontSize',24)
ylim([0 5])
title('Video Familiarity Ratings')




%%
subjectcorrs = zeros(1,length(all_run_engagements));
subjectcorrpvals = zeros(1,length(all_run_engagements));
subjectrhos = zeros(1,length(all_run_engagements));
subjectspearmanpvals = zeros(1,length(all_run_engagements));
subjectCorrectCorrs = zeros(1,length(all_run_engagements));
subjectCorrectpvals = zeros(1,length(all_run_engagements));
subjectcolors = jet(length(all_run_engagements));

positiveCorrs = [];
negativeCorrs = [];

positiveRhos = [];
negativeRhos = [];

positiveCorrectCorrs = [];
negativeCorrectCorrs = [];

positiveRhoPvalsAccuracyFamiliarity = [];
negativeRhoPvalsAccuracyFamiliarity = [];

positiveCorrPvalsAccuracyFamiliarity = [];
negativeCorrPvalsAccuracyFamiliarity = [];

figure;
hold on;

for subject = 1:length(all_run_engagements)
    
    try
        all_run_engagements{2,subject}(:,find(all_run_engagements{2,subject}(1,:)==0)) = [];
        
    catch
        continue
    end
    subplot(5,10,subject)
   
   
    scatter(all_run_engagements{2,subject}(5,:),all_run_engagements{2,subject}(11,:),'filled')
    lsline
    set(groot,'defaultLineLineWidth',2.0)
    xlim([1 5])
    ylim([0 1])
    set(gca,'XTick',[1 2 3 4 5])
     xlabel('Familiarity Rating')
    ylabel('Accuracy')
    
    %title(all_run_engagements{1,subject})
    [correlation pvalue] = corrcoef(all_run_engagements{2,subject}(11,:),all_run_engagements{2,subject}(5,:));
    subjectcorrs(subject) = correlation(1,2);
    subjectcorrpvals(subject) = pvalue(1,2);
    if correlation(1,2) >= 0
        positiveCorrs = [positiveCorrs correlation(1,2)];
        positiveCorrPvalsAccuracyFamiliarity = [positiveCorrPvalsAccuracyFamiliarity pvalue(1,2)];

    elseif correlation(1,2) < 0
        negativeCorrs = [negativeCorrs correlation(1,2)];
        negativeCorrPvalsAccuracyFamiliarity = [negativeCorrPvalsAccuracyFamiliarity pvalue(1,2)];
    end
    [rho spearmanp] = corr([all_run_engagements{2,subject}(11,:)' all_run_engagements{2,subject}(5,:)'],'Type','spearman');
    subjectrhos(subject) = rho(1,2);
    subjectspearmanpvals(subject) = spearmanp(1,2);
    if rho(1,2) >= 0
        positiveRhos = [positiveRhos rho(1,2)];
        positiveRhoPvalsAccuracyFamiliarity = [positiveRhoPvalsAccuracyFamiliarity spearmanp(1,2)];

    elseif rho(1,2) < 0
        negativeRhos = [negativeRhos rho(1,2)];
        negativeRhoPvalsAccuracyFamiliarity = [negativeRhoPvalsAccuracyFamiliarity spearmanp(1,2)];
    end
    
end


figure;
hold on
boxplot(subjectcorrs)

subjectcorrjitter = zeros(1,length(all_run_engagements));
for jitter = 1:length(subjectcorrjitter)
    subjectcorrjitter = 1 + (-1+2*rand(1,1))/64;
    scatter(subjectcorrjitter,subjectcorrs(jitter),60,'MarkerFaceColor','red','MarkerEdgeColor','black');
end

set(gca,'FontSize',24)
set(gca,'XTickLabel',[])
title('Subject Quiz Correct vs. Video Familiarity Rating')
ylabel('r-value')
ylim([-1 1])

%%
subjectcorrs = zeros(1,length(all_run_engagements));
subjectcorrpvals = zeros(1,length(all_run_engagements));
subjectrhos = zeros(1,length(all_run_engagements));
subjectspearmanpvals = zeros(1,length(all_run_engagements));
subjectCorrectCorrs = zeros(1,length(all_run_engagements));
subjectCorrectpvals = zeros(1,length(all_run_engagements));
subjectcolors = jet(length(all_run_engagements));

positiveCorrs = [];
negativeCorrs = [];

positiveRhos = [];
negativeRhos = [];

positiveCorrectCorrsConfidenceFamiliarity = [];
negativeCorrectCorrsConfidenceFamiliarity = [];
positiveRhoPvalsConfidenceFamiliarity = [];
negativeRhoPvalsConfidenceFamiliarity = [];

positiveCorrPvalsConfidenceFamiliarity = [];
negativeCorrPvalsConfidenceFamiliarity = [];
figure;
hold on;

for subject = 1:length(all_run_engagements)
    
    try
        all_run_engagements{2,subject}(:,find(all_run_engagements{2,subject}(1,:)==0)) = [];
        
    catch
        continue
    end
    subplot(5,10,subject)
   
   
    scatter(all_run_engagements{2,subject}(5,:),all_run_engagements{2,subject}(13,:),'filled')
    lsline
    set(groot,'defaultLineLineWidth',2.0)
    xlim([1 5])
    ylim([0 100])
    set(gca,'xtick',[1 2 3 4 5])
     xlabel('Familiarity Rating')
    ylabel('Confidence Percentile')
    %title(all_run_engagements{1,subject}(1:3))
    [correlation pvalue] = corrcoef(all_run_engagements{2,subject}(13,:),all_run_engagements{2,subject}(5,:));
    subjectcorrs(subject) = correlation(1,2);
    subjectcorrpvals(subject) = pvalue(1,2);
    set(gca,'FontWeight','normal')
    if correlation(1,2) >= 0
        positiveCorrs = [positiveCorrs correlation(1,2)];
        positiveCorrPvalsConfidenceFamiliarity = [positiveCorrPvalsConfidenceFamiliarity pvalue(1,2)];

    elseif correlation(1,2) < 0
        negativeCorrs = [negativeCorrs correlation(1,2)];
        negativeCorrPvalsConfidenceFamiliarity = [negativeCorrPvalsConfidenceFamiliarity pvalue(1,2)];
    end
    [rho spearmanp] = corr([all_run_engagements{2,subject}(13,:)' all_run_engagements{2,subject}(5,:)'],'Type','spearman');
    subjectrhos(subject) = rho(1,2);
    subjectspearmanpvals(subject) = spearmanp(1,2);
    if rho(1,2) >= 0
        positiveRhos = [positiveRhos rho(1,2)];
        positiveRhoPvalsConfidenceFamiliarity = [positiveRhoPvalsConfidenceFamiliarity spearmanp(1,2)];

    elseif rho(1,2) < 0
        negativeRhos = [negativeRhos rho(1,2)];
        negativeRhoPvalsConfidenceFamiliarity = [negativeRhoPvalsConfidenceFamiliarity spearmanp(1,2)];
    end
    
end


figure;
hold on
boxplot(subjectcorrs)

subjectcorrjitter = zeros(1,length(all_run_engagements));
for jitter = 1:length(subjectcorrjitter)
    subjectcorrjitter = 1 + (-1+2*rand(1,1))/64;
    scatter(subjectcorrjitter,subjectcorrs(jitter),60,'MarkerFaceColor','red','MarkerEdgeColor','black');
end

set(gca,'FontSize',24)
set(gca,'XTickLabel',[])
title('Subject Confidence Percentile vs. Video Familiarity Rating')
ylabel('r-value')
ylim([-1 1])

%%
subjectcorrs = zeros(1,length(all_run_engagements));
subjectcorrpvals = zeros(1,length(all_run_engagements));
subjectrhos = zeros(1,length(all_run_engagements));
subjectspearmanpvals = zeros(1,length(all_run_engagements));
subjectCorrectCorrs = zeros(1,length(all_run_engagements));
subjectCorrectpvals = zeros(1,length(all_run_engagements));
subjectcolors = jet(length(all_run_engagements));

positiveCorrs = [];
negativeCorrs = [];

positiveRhos = [];
negativeRhos = [];

positiveCorrectCorrs = [];
negativeCorrectCorrs = [];

positiveRhoPvalsConfidenceEngagement = [];
negativeRhoPvalsConfidenceEngagement = [];

figure;
hold on;

for subject = 1:length(all_run_engagements)
    
    try
        all_run_engagements{2,subject}(:,find(all_run_engagements{2,subject}(1,:)==0)) = [];
        
    catch
        continue
    end
    subplot(5,10,subject)
   
   
    scatter(all_run_engagements{2,subject}(4,:),all_run_engagements{2,subject}(13,:),'filled')
    lsline
    set(groot,'defaultLineLineWidth',2.0)
    xlim([1 5])
    ylim([0 100])
    set(gca,'xtick',[1 2 3 4 5])
     xlabel('Engagement Rating')
    ylabel('Confidence Percentile')
    %title(all_run_engagements{1,subject})
    [correlation pvalue] = corrcoef(all_run_engagements{2,subject}(13,:),all_run_engagements{2,subject}(4,:));
    subjectcorrs(subject) = correlation(1,2);
    subjectcorrpvals(subject) = pvalue(1,2);
    if correlation(1,2) >= 0
        positiveCorrs = [positiveCorrs correlation(1,2)];
    elseif correlation(1,2) < 0
        negativeCorrs = [negativeCorrs correlation(1,2)];
    end
    [rho spearmanp] = corr([all_run_engagements{2,subject}(13,:)' all_run_engagements{2,subject}(4,:)'],'Type','spearman');
    subjectrhos(subject) = rho(1,2);
    subjectspearmanpvals(subject) = spearmanp(1,2);
    if rho(1,2) >= 0
        positiveRhos = [positiveRhos rho(1,2)];
        positiveRhoPvalsConfidenceEngagement = [positiveRhoPvalsConfidenceEngagement spearmanp(1,2)];

    elseif rho(1,2) < 0
        negativeRhos = [negativeRhos rho(1,2)];
        negativeRhoPvalsConfidenceEngagement = [negativeRhoPvalsConfidenceEngagement spearmanp(1,2)];
    end
    
end


figure;
hold on
boxplot(subjectcorrs)

subjectcorrjitter = zeros(1,length(all_run_engagements));
for jitter = 1:length(subjectcorrjitter)
    subjectcorrjitter = 1 + (-1+2*rand(1,1))/64;
    scatter(subjectcorrjitter,subjectcorrs(jitter),60,'MarkerFaceColor','red','MarkerEdgeColor','black');
end

set(gca,'FontSize',24)
set(gca,'XTickLabel',[])
title('Subject Quiz Confidence vs. Video Engagement Rating')
ylabel('r-value')
ylim([-1 1])

%% All Subjects, Aggregated
allSubjectEngagements = [];
allSubjectAwarenesses = [];
allSubjectUnawarenesses = [];
allSubjectFamiliarities = [];
allSubjectAccuracies = [];
allSubjectConfidences = [];
for subject = 1:length(all_run_engagements)
    currentSubject = all_run_engagements{2,subject};
    allSubjectAccuracies = [allSubjectAccuracies currentSubject(12,:)];
    allSubjectConfidences = [allSubjectConfidences currentSubject(13,:)];
    allSubjectEngagements = [allSubjectEngagements currentSubject(4,:)];
    allSubjectAwarenesses = [allSubjectAwarenesses currentSubject(2,:)];
    allSubjectUnawarenesses = [allSubjectUnawarenesses currentSubject(8,:)];
    allSubjectFamiliarities = [allSubjectFamiliarities currentSubject(5,:)];
end


figure; scatter(allSubjectEngagements, allSubjectAwarenesses*100,'filled')
xlabel('Engagement Rating')
ylabel('Run Awareness Rate (%)')
