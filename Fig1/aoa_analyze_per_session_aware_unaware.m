clear all
clc

%% Load datasheet

[num text raw] = xlsread('Y:\HNCT_AoA_Study\AoA_Subjects\AoA_All_Subjs_Data_Sheet.xlsx');
root = 'Y:\HNCT_AoA_Study\AoA_Subjects\';
badSession = 0;
figure
hold on


totalsAwareUnaware = [unique(text(1,:)); cell(6,length(unique(text(1,:))))];
unawareTotalsDay2 = [];
unawareTotalsDay3 = [];
awareTotalsDay2 = [];
awareTotalsDay3 = [];
accuracyDay2 = [];
accuracyDay3 = [];
confidenceDay2 = [];
confidenceDay3 = [];
subjectsDay2 = [];
subjectsDay3 = [];
allQuizTotalsDay2 = [];
allQuizTotalsDay3 = [];
for session = 1:length(text)
    
    disp(['Evaluating ' text{1,session} ', Day ' text{2,session}(end)])
    fullSession = [root '/' text{1,session} '/' text{2,session} '/' num2str(raw{3,session}) '_designations.mat'];
    load([root '/' text{1,session} '/' text{2,session} '/' num2str(raw{3,session}) '_sliders_and_percentiles_timing.mat'])
    sliderSuccessesAllPercentilesTiming(sliderSuccessesAllPercentilesTiming(:,1) == 9999,:) = [];
    confidenceLevels = (sliderSuccessesAllPercentilesTiming(:,1)+450)/9;
    accuracyLevels = mean(sliderSuccessesAllPercentilesTiming(:,4))*100;
    load(fullSession)
    originalConfidenceDesignations = confidenceDesignations;
    confidenceDesignations = confidenceDesignations(~cellfun('isempty', confidenceDesignations));
    unawareTotals = length(find(contains(confidenceDesignations,'Unaware'))) + length(find(contains(confidenceDesignations,'IL')));
    awareTotals = length(find(contains(confidenceDesignations,'Aware'))) + length(find(contains(confidenceDesignations,'CH')));
    if strcmp(text{2,session}(end),'2')
        unawareTotalsDay2 = [unawareTotalsDay2 length(find(contains(confidenceDesignations,'Unaware'))) + length(find(contains(confidenceDesignations,'IL')))];
        awareTotalsDay2 = [awareTotalsDay2 length(find(contains(confidenceDesignations,'Aware'))) + length(find(contains(confidenceDesignations,'CH')))];
        confidenceDay2 = [confidenceDay2 mean(confidenceLevels)];
        accuracyDay2 = [accuracyDay2 accuracyLevels];
        subjectsDay2 = [subjectsDay2 text(1,session)];
        allQuizTotalsDay2 = [allQuizTotalsDay2 length(originalConfidenceDesignations)];
    elseif strcmp(text{2,session}(end),'3')
        unawareTotalsDay3 = [unawareTotalsDay3 length(find(contains(confidenceDesignations,'Unaware'))) + length(find(contains(confidenceDesignations,'IL')))];
        awareTotalsDay3 = [awareTotalsDay3 length(find(contains(confidenceDesignations,'Aware'))) + length(find(contains(confidenceDesignations,'CH')))];
        confidenceDay3 = [confidenceDay3 mean(confidenceLevels)];
        accuracyDay3 = [accuracyDay3 accuracyLevels];
        subjectsDay3 = [subjectsDay3 text(1,session)];
        allQuizTotalsDay3 = [allQuizTotalsDay3 length(originalConfidenceDesignations)];
    end
    for subject = 1:length(totalsAwareUnaware)
        if strcmp(text{1,session},totalsAwareUnaware{1,subject})
            totalsAwareUnaware{2,subject} = [totalsAwareUnaware{2,subject} awareTotals];
            totalsAwareUnaware{3,subject} = [totalsAwareUnaware{3,subject} unawareTotals];
        end
    end
end

for subject = 1:length(totalsAwareUnaware)
    totalsAwareUnaware{4,subject} = mean(totalsAwareUnaware{2,subject});
    totalsAwareUnaware{5,subject} = mean(totalsAwareUnaware{3,subject});
end

awareSessionAverage = cell2mat(totalsAwareUnaware(4,:));
unawareSessionAverage = cell2mat(totalsAwareUnaware(5,:));
sessionAverages = [awareSessionAverage' unawareSessionAverage'];
unawarenessLevelsDay2 = unawareTotalsDay2 ./ allQuizTotalsDay2;
unawarenessLevelsDay3 = unawareTotalsDay3 ./ allQuizTotalsDay3;

awarenessLevelsDay2 = awareTotalsDay2 ./ allQuizTotalsDay2;
awarenessLevelsDay3 = awareTotalsDay3 ./ allQuizTotalsDay3;

%% Plot scatterplots average aware and unaware per session

figure; 
hold on
boxplot([awareSessionAverage unawareSessionAverage]',[ones(1,length(awareSessionAverage)) 2*ones(1,length(unawareSessionAverage))],'labels',{'Aware','Unaware'})

for point = 1:length(awareSessionAverage)
    if awareSessionAverage(point) < quantile(awareSessionAverage,0.25) - 1.5*iqr(awareSessionAverage) || awareSessionAverage(point) > quantile(awareSessionAverage,0.75) + 1.5*iqr(awareSessionAverage) || awareSessionAverage(point) == max(awareSessionAverage) || awareSessionAverage(point) == min(awareSessionAverage)
        scatter(1,awareSessionAverage(point),'MarkerFaceColor',[0 0.5 0],'MarkerEdgeColor',[0 0.5 0],'SizeData',150)
    else
        scatter(1,awareSessionAverage(point),'MarkerFaceColor',[0 0.5 0],'MarkerEdgeColor',[0 0.5 0],'SizeData',150,'jitter','on','jitteramount',0.075)
    end
end

for point = 1:length(unawareSessionAverage)
    if unawareSessionAverage(point) < quantile(unawareSessionAverage,0.25) - 1.5*iqr(unawareSessionAverage) || unawareSessionAverage(point) > quantile(unawareSessionAverage,0.75) + 1.5*iqr(unawareSessionAverage) || unawareSessionAverage(point) == max(unawareSessionAverage) || unawareSessionAverage(point) == min(unawareSessionAverage)
        scatter(2,unawareSessionAverage(point),'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[1 0 0],'SizeData',150)
    else
        scatter(2,unawareSessionAverage(point),'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[1 0 0],'SizeData',150,'jitter','on','jitteramount',0.075)
    end
end
ylim([0 25])

ylabel('Number of Trials')
title('Trials Per Session')

set(gca,'FontSize',24)


for subject = 1:length(totalsAwareUnaware)
    totalsAwareUnaware{6,subject} = sum(totalsAwareUnaware{2,subject});
    totalsAwareUnaware{7,subject} = sum(totalsAwareUnaware{3,subject});
end


allAwareTotals = cell2mat(totalsAwareUnaware(6,:));
allUnawareTotals = cell2mat(totalsAwareUnaware(7,:));

%% Plot scatterplots aware and unaware per session
figure; 
hold on
boxplot([allAwareTotals allUnawareTotals]',[ones(1,length(allAwareTotals)) 2*ones(1,length(allUnawareTotals))],'labels',{'Aware','Unaware'})


for point = 1:length(allAwareTotals)
    if allAwareTotals(point) < quantile(allAwareTotals,0.25) - 1.5*iqr(allAwareTotals) || allAwareTotals(point) > quantile(allAwareTotals,0.75) + 1.5*iqr(allAwareTotals) || allAwareTotals(point) == max(allAwareTotals) || allAwareTotals(point) == min(allAwareTotals)
        scatter(1,allAwareTotals(point),'MarkerFaceColor',[0 0.5 0],'MarkerEdgeColor',[0 0.5 0],'SizeData',150)
    else
        scatter(1,allAwareTotals(point),'MarkerFaceColor',[0 0.5 0],'MarkerEdgeColor',[0 0.5 0],'SizeData',150,'jitter','on','jitteramount',0.075)
    end
end

for point = 1:length(allUnawareTotals)
    if allUnawareTotals(point) < quantile(allUnawareTotals,0.25) - 1.5*iqr(allUnawareTotals) || allUnawareTotals(point) > quantile(allUnawareTotals,0.75) + 1.5*iqr(allUnawareTotals) || allUnawareTotals(point) == max(allUnawareTotals) || allUnawareTotals(point) == min(allUnawareTotals)
        scatter(2,allUnawareTotals(point),'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[1 0 0],'SizeData',150)
    else
        scatter(2,allUnawareTotals(point),'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[1 0 0],'SizeData',150,'jitter','on','jitteramount',0.075)
    end
end
ylim([0 50])

ylabel('Number of Quizzes')
title('Total Trials')

set(gca,'FontSize',24)

%% Plot average aware and unaware boxplots


figure; 
subplot(1,2,1)
hold on
boxplot([awareTotalsDay2 unawareTotalsDay2]',[ones(1,length(awareTotalsDay2)) 2*ones(1,length(unawareTotalsDay2))],'labels',{'Aware','Unaware'})


for point = 1:length(awareTotalsDay2)
    if awareTotalsDay2(point) < quantile(awareTotalsDay2,0.25) - 1.5*iqr(awareTotalsDay2) || awareTotalsDay2(point) > quantile(awareTotalsDay2,0.75) + 1.5*iqr(awareTotalsDay2) || awareTotalsDay2(point) == max(awareTotalsDay2) || awareTotalsDay2(point) == min(awareTotalsDay2)
        scatter(1,awareTotalsDay2(point),'MarkerFaceColor',[0 0.5 0],'MarkerEdgeColor',[0 0.5 0],'SizeData',150)
    else
        scatter(1,awareTotalsDay2(point),'MarkerFaceColor',[0 0.5 0],'MarkerEdgeColor',[0 0.5 0],'SizeData',150,'jitter','on','jitteramount',0.075)
    end
end

for point = 1:length(unawareTotalsDay2)
    if unawareTotalsDay2(point) < quantile(unawareTotalsDay2,0.25) - 1.5*iqr(unawareTotalsDay2) || unawareTotalsDay2(point) > quantile(unawareTotalsDay2,0.75) + 1.5*iqr(unawareTotalsDay2) || unawareTotalsDay2(point) == max(unawareTotalsDay2) || unawareTotalsDay2(point) == min(unawareTotalsDay2)
        scatter(2,unawareTotalsDay2(point),'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[1 0 0],'SizeData',150)
    else
        scatter(2,unawareTotalsDay2(point),'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[1 0 0],'SizeData',150,'jitter','on','jitteramount',0.075)
    end
end
ylim([0 25])
set(gca,'FontSize',24)
subplot(1,2,2)
hold on
boxplot([awareTotalsDay3 unawareTotalsDay3]',[ones(1,length(awareTotalsDay3)) 2*ones(1,length(unawareTotalsDay3))],'labels',{'Aware','Unaware'})

for point = 1:length(awareTotalsDay3)
    if awareTotalsDay3(point) < quantile(awareTotalsDay3,0.25) - 1.5*iqr(awareTotalsDay3) || awareTotalsDay3(point) > quantile(awareTotalsDay3,0.75) + 1.5*iqr(awareTotalsDay3) || awareTotalsDay3(point) == max(awareTotalsDay3) || awareTotalsDay3(point) == min(awareTotalsDay3)
        scatter(1,awareTotalsDay3(point),'MarkerFaceColor',[0 0.5 0],'MarkerEdgeColor',[0 0.5 0],'SizeData',150)
    else
        scatter(1,awareTotalsDay3(point),'MarkerFaceColor',[0 0.5 0],'MarkerEdgeColor',[0 0.5 0],'SizeData',150,'jitter','on','jitteramount',0.075)
    end
end

for point = 1:length(unawareTotalsDay3)
    if unawareTotalsDay3(point) < quantile(unawareTotalsDay3,0.25) - 1.5*iqr(unawareTotalsDay3) || unawareTotalsDay3(point) > quantile(unawareTotalsDay3,0.75) + 1.5*iqr(unawareTotalsDay3) || unawareTotalsDay3(point) == max(unawareTotalsDay3) || unawareTotalsDay3(point) == min(unawareTotalsDay3)
        scatter(2,unawareTotalsDay3(point),'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[1 0 0],'SizeData',150)
    else
        scatter(2,unawareTotalsDay3(point),'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[1 0 0],'SizeData',150,'jitter','on','jitteramount',0.075)
    end
end
ylim([0 25])
set(gca,'FontSize',24)

%% Plot boxplots for confidence and accuracy, Day 2 and Day 3



figure; 
subplot(1,2,1)
hold on
boxplot([confidenceDay2 accuracyDay2]',[ones(1,length(confidenceDay2)) 2*ones(1,length(accuracyDay2))],'labels',{'Confidence','Accuracy'})



for point = 1:length(confidenceDay2)
    if confidenceDay2(point) < quantile(confidenceDay2,0.25) - 1.5*iqr(confidenceDay2) || confidenceDay2(point) > quantile(confidenceDay2,0.75) + 1.5*iqr(confidenceDay2) || confidenceDay2(point) == max(confidenceDay2) || confidenceDay2(point) == min(confidenceDay2)
        scatter(1,confidenceDay2(point),'MarkerFaceColor',[0.5 1 0],'MarkerEdgeColor',[0.5 1 0],'SizeData',150)
    else
        scatter(1,confidenceDay2(point),'MarkerFaceColor',[0.5 1 0],'MarkerEdgeColor',[0.5 1 0],'SizeData',150,'jitter','on','jitteramount',0.075)
    end
end


for point = 1:length(accuracyDay2)
    if accuracyDay2(point) < quantile(accuracyDay2,0.25) - 1.5*iqr(accuracyDay2) || accuracyDay2(point) > quantile(accuracyDay2,0.75) + 1.5*iqr(accuracyDay2) || accuracyDay2(point) == max(accuracyDay2) || accuracyDay2(point) == min(accuracyDay2)
        scatter(2,accuracyDay2(point),'MarkerFaceColor',[1 0.5 0],'MarkerEdgeColor',[1 0.5 0],'SizeData',150)
    else
        scatter(2,accuracyDay2(point),'MarkerFaceColor',[1 0.5 0],'MarkerEdgeColor',[1 0.5 0],'SizeData',150,'jitter','on','jitteramount',0.075)
    end
end

ylim([0 100])
set(gca,'FontSize',24)
title('Day 2 Confidence and Accuracy')
ylabel('Raw Percentage')
subplot(1,2,2)
hold on

boxplot([confidenceDay3 accuracyDay3]',[ones(1,length(confidenceDay3)) 2*ones(1,length(accuracyDay3))],'labels',{'Confidence','Accuracy'})



for point = 1:length(confidenceDay3)
    if confidenceDay3(point) < quantile(confidenceDay3,0.25) - 1.5*iqr(confidenceDay3) || confidenceDay3(point) > quantile(confidenceDay3,0.75) + 1.5*iqr(confidenceDay3) || confidenceDay3(point) == max(confidenceDay3) || confidenceDay3(point) == min(confidenceDay3)
        scatter(1,confidenceDay3(point),'MarkerFaceColor',[0.5 1 0],'MarkerEdgeColor',[0.5 1 0],'SizeData',150)
    else
        scatter(1,confidenceDay3(point),'MarkerFaceColor',[0.5 1 0],'MarkerEdgeColor',[0.5 1 0],'SizeData',150,'jitter','on','jitteramount',0.075)
    end
end


for point = 1:length(accuracyDay3)
    if accuracyDay3(point) < quantile(accuracyDay3,0.25) - 1.5*iqr(accuracyDay3) || accuracyDay3(point) > quantile(accuracyDay3,0.75) + 1.5*iqr(accuracyDay3) || accuracyDay3(point) == max(accuracyDay3) || accuracyDay3(point) == min(accuracyDay3)
        scatter(2,accuracyDay3(point),'MarkerFaceColor',[1 0.5 0],'MarkerEdgeColor',[1 0.5 0],'SizeData',150)
    else
        scatter(2,accuracyDay3(point),'MarkerFaceColor',[1 0.5 0],'MarkerEdgeColor',[1 0.5 0],'SizeData',150,'jitter','on','jitteramount',0.075)
    end
end
ylim([0 100])
ylabel('Raw Percentage')
set(gca,'FontSize',24)
title('Day 3 Confidence and Accuracy')

%% Check for subjects with both Day 2 and Day 3


confidenceDay2CommonSubset = [];
confidenceDay3CommonSubset = [];

for item = 1:length(subjectsDay2)
    currentIndex = [];
    currentIndex = find(contains(subjectsDay3,subjectsDay2{item}));
    if isempty(currentIndex)
        continue
    end
    confidenceDay2CommonSubset = [confidenceDay2CommonSubset; confidenceDay2(item)];
    confidenceDay3CommonSubset = [confidenceDay3CommonSubset; confidenceDay3(currentIndex)];
end

accuracyDay2CommonSubset = [];
accuracyDay3CommonSubset = [];

for item = 1:length(subjectsDay2)
    currentIndex = [];
    currentIndex = find(contains(subjectsDay3,subjectsDay2{item}));
    if isempty(currentIndex)
        continue
    end
    accuracyDay2CommonSubset = [accuracyDay2CommonSubset; accuracyDay2(item)];
    accuracyDay3CommonSubset = [accuracyDay3CommonSubset; accuracyDay3(currentIndex)];
end

unawarenessDay2CommonSubset = [];
unawarenessDay3CommonSubset = [];

for item = 1:length(subjectsDay2)
    currentIndex = [];
    currentIndex = find(contains(subjectsDay3,subjectsDay2{item}));
    if isempty(currentIndex)
        continue
    end
    unawarenessDay2CommonSubset = [unawarenessDay2CommonSubset; unawarenessLevelsDay2(item)];
    unawarenessDay3CommonSubset = [unawarenessDay3CommonSubset; unawarenessLevelsDay3(currentIndex)];
end

awarenessDay2CommonSubset = [];
awarenessDay3CommonSubset = [];

for item = 1:length(subjectsDay2)
    currentIndex = [];
    currentIndex = find(contains(subjectsDay3,subjectsDay2{item}));
    if isempty(currentIndex)
        continue
    end
    awarenessDay2CommonSubset = [awarenessDay2CommonSubset; awarenessLevelsDay2(item)];
    awarenessDay3CommonSubset = [awarenessDay3CommonSubset; awarenessLevelsDay3(currentIndex)];
end

%% 95% Confidence Intervals

% Given data: accuracy, Day 2
data = accuracyDay2CommonSubset;

% Step 1: Mean of the data
mean_value = mean(data);

% Step 2: Standard Error of the Mean (SEM)
n = length(data);
std_dev = std(data);
sem = std_dev / sqrt(n);

% Step 3: Critical t-value for 95% confidence interval
alpha = 0.05;
t_value = tinv(1 - alpha/2, n-1);

% Step 4: Margin of Error
margin_of_error_accuracyDay2CommonSubset = t_value * sem;

% Step 5: Confidence Interval
lower_bound_accuracyDay2CommonSubset = mean_value - margin_of_error_accuracyDay2CommonSubset;
upper_bound_accuracyDay2CommonSubset = mean_value + margin_of_error_accuracyDay2CommonSubset;
confidence_interval_accuracyDay2CommonSubset = [lower_bound_accuracyDay2CommonSubset, upper_bound_accuracyDay2CommonSubset];

% Display the result
disp('95% Confidence Interval:');
disp(confidence_interval_accuracyDay2CommonSubset);
disp('Margin of Error: ')
disp(margin_of_error_accuracyDay2CommonSubset)

% Given data: accuracy, Day 3
data = accuracyDay3CommonSubset;

% Step 1: Mean of the data
mean_value = mean(data);

% Step 2: Standard Error of the Mean (SEM)
n = length(data);
std_dev = std(data);
sem = std_dev / sqrt(n);

% Step 3: Critical t-value for 95% confidence interval
alpha = 0.05;
t_value = tinv(1 - alpha/2, n-1);

% Step 4: Margin of Error
margin_of_error_accuracyDay3CommonSubset = t_value * sem;

% Step 5: Confidence Interval
lower_bound_accuracyDay3CommonSubset = mean_value - margin_of_error_accuracyDay3CommonSubset;
upper_bound_accuracyDay3CommonSubset = mean_value + margin_of_error_accuracyDay3CommonSubset;
confidence_interval_accuracyDay3CommonSubset = [lower_bound_accuracyDay3CommonSubset, upper_bound_accuracyDay3CommonSubset];

% Display the result
disp('95% Confidence Interval:');
disp(confidence_interval_accuracyDay3CommonSubset);
disp('Margin of Error: ')
disp(margin_of_error_accuracyDay3CommonSubset)

% Given data: awareness, Day 2
data = awarenessDay2CommonSubset;

% Step 1: Mean of the data
mean_value = mean(data);

% Step 2: Standard Error of the Mean (SEM)
n = length(data);
std_dev = std(data);
sem = std_dev / sqrt(n);

% Step 3: Critical t-value for 95% confidence interval
alpha = 0.05;
t_value = tinv(1 - alpha/2, n-1);

% Step 4: Margin of Error
margin_of_error_awarenessDay2CommonSubset = t_value * sem;

% Step 5: Confidence Interval
lower_bound_awarenessDay2CommonSubset = mean_value - margin_of_error_awarenessDay2CommonSubset;
upper_bound_awarenessDay2CommonSubset = mean_value + margin_of_error_awarenessDay2CommonSubset;
confidence_interval_awarenessDay2CommonSubset = [lower_bound_awarenessDay2CommonSubset, upper_bound_awarenessDay2CommonSubset];

% Display the result
disp('95% Confidence Interval:');
disp(confidence_interval_awarenessDay2CommonSubset);
disp('Margin of Error: ')
disp(margin_of_error_awarenessDay2CommonSubset)

% Given data: awareness, Day 3
data = awarenessDay3CommonSubset;

% Step 1: Mean of the data
mean_value = mean(data);

% Step 2: Standard Error of the Mean (SEM)
n = length(data);
std_dev = std(data);
sem = std_dev / sqrt(n);

% Step 3: Critical t-value for 95% confidence interval
alpha = 0.05;
t_value = tinv(1 - alpha/2, n-1);

% Step 4: Margin of Error
margin_of_error_awarenessDay3CommonSubset = t_value * sem;

% Step 5: Confidence Interval
lower_bound_awarenessDay3CommonSubset = mean_value - margin_of_error_awarenessDay3CommonSubset;
upper_bound_awarenessDay3CommonSubset = mean_value + margin_of_error_awarenessDay3CommonSubset;
confidence_interval_awarenessDay3CommonSubset = [lower_bound_awarenessDay3CommonSubset, upper_bound_awarenessDay3CommonSubset];

% Display the result
disp('95% Confidence Interval:');
disp(confidence_interval_awarenessDay3CommonSubset);
disp('Margin of Error: ')
disp(margin_of_error_awarenessDay3CommonSubset)

% Given data: unawareness, Day 2
data = unawarenessDay2CommonSubset;

% Step 1: Mean of the data
mean_value = mean(data);

% Step 2: Standard Error of the Mean (SEM)
n = length(data);
std_dev = std(data);
sem = std_dev / sqrt(n);

% Step 3: Critical t-value for 95% confidence interval
alpha = 0.05;
t_value = tinv(1 - alpha/2, n-1);

% Step 4: Margin of Error
margin_of_error_unawarenessDay2CommonSubset = t_value * sem;

% Step 5: Confidence Interval
lower_bound_unawarenessDay2CommonSubset = mean_value - margin_of_error_unawarenessDay2CommonSubset;
upper_bound_unawarenessDay2CommonSubset = mean_value + margin_of_error_unawarenessDay2CommonSubset;
confidence_interval_unawarenessDay2CommonSubset = [lower_bound_unawarenessDay2CommonSubset, upper_bound_unawarenessDay2CommonSubset];

% Display the result
disp('95% Confidence Interval:');
disp(confidence_interval_unawarenessDay2CommonSubset);
disp('Margin of Error: ')
disp(margin_of_error_unawarenessDay2CommonSubset)

% Given data: unawareness, Day 3
data = unawarenessDay3CommonSubset;

% Step 1: Mean of the data
mean_value = mean(data);

% Step 2: Standard Error of the Mean (SEM)
n = length(data);
std_dev = std(data);
sem = std_dev / sqrt(n);

% Step 3: Critical t-value for 95% confidence interval
alpha = 0.05;
t_value = tinv(1 - alpha/2, n-1);

% Step 4: Margin of Error
margin_of_error_unawarenessDay3CommonSubset = t_value * sem;

% Step 5: Confidence Interval
lower_bound_unawarenessDay3CommonSubset = mean_value - margin_of_error_unawarenessDay3CommonSubset;
upper_bound_unawarenessDay3CommonSubset = mean_value + margin_of_error_unawarenessDay3CommonSubset;
confidence_interval_unawarenessDay3CommonSubset = [lower_bound_unawarenessDay3CommonSubset, upper_bound_unawarenessDay3CommonSubset];

% Display the result
disp('95% Confidence Interval:');
disp(confidence_interval_unawarenessDay3CommonSubset);
disp('Margin of Error: ')
disp(margin_of_error_unawarenessDay3CommonSubset)

% Given data: confidence, Day 2
data = confidenceDay2CommonSubset;

% Step 1: Mean of the data
mean_value = mean(data);

% Step 2: Standard Error of the Mean (SEM)
n = length(data);
std_dev = std(data);
sem = std_dev / sqrt(n);

% Step 3: Critical t-value for 95% confidence interval
alpha = 0.05;
t_value = tinv(1 - alpha/2, n-1);

% Step 4: Margin of Error
margin_of_error_confidenceDay2CommonSubset = t_value * sem;

% Step 5: Confidence Interval
lower_bound_confidenceDay2CommonSubset = mean_value - margin_of_error_confidenceDay2CommonSubset;
upper_bound_confidenceDay2CommonSubset = mean_value + margin_of_error_confidenceDay2CommonSubset;
confidence_interval_confidenceDay2CommonSubset = [lower_bound_confidenceDay2CommonSubset, upper_bound_confidenceDay2CommonSubset];

% Display the result
disp('95% Confidence Interval:');
disp(confidence_interval_confidenceDay2CommonSubset);
disp('Margin of Error: ')
disp(margin_of_error_confidenceDay2CommonSubset)

% Given data: confidence, Day 3
data = confidenceDay3CommonSubset;

% Step 1: Mean of the data
mean_value = mean(data);

% Step 2: Standard Error of the Mean (SEM)
n = length(data);
std_dev = std(data);
sem = std_dev / sqrt(n);

% Step 3: Critical t-value for 95% confidence interval
alpha = 0.05;
t_value = tinv(1 - alpha/2, n-1);

% Step 4: Margin of Error
margin_of_error_confidenceDay3CommonSubset = t_value * sem;

% Step 5: Confidence Interval
lower_bound_confidenceDay3CommonSubset = mean_value - margin_of_error_confidenceDay3CommonSubset;
upper_bound_confidenceDay3CommonSubset = mean_value + margin_of_error_confidenceDay3CommonSubset;
confidence_interval_confidenceDay3CommonSubset = [lower_bound_confidenceDay3CommonSubset, upper_bound_confidenceDay3CommonSubset];

% Display the result
disp('95% Confidence Interval:');
disp(confidence_interval_confidenceDay3CommonSubset);
disp('Margin of Error: ')
disp(margin_of_error_confidenceDay3CommonSubset)


%% Perform a t-test between Day 2 and Day 3
[h,p_awareness] = ttest(awarenessDay2CommonSubset,awarenessDay3CommonSubset);
[h,p_unawareness] = ttest(unawarenessDay2CommonSubset,unawarenessDay3CommonSubset);
[h,p_accuracy] = ttest(accuracyDay2CommonSubset,accuracyDay3CommonSubset);
[h,p_confidence] = ttest(confidenceDay2CommonSubset,confidenceDay3CommonSubset);

p_values = [p_awareness p_unawareness p_accuracy p_confidence];
p_values_vector = p_values;
valid_p_values = p_values_vector(~isnan(p_values_vector));  % Exclude NaN p-values
adjusted_p_values = zeros(size(p_values));
adjusted_p_values(~isnan(p_values)) = mafdr(valid_p_values, 'BHFDR', true);  % Apply Benjamini-Hochberg procedure

%% Make Bar Charts for Per Session Aware/Unaware

days = categorical({'Day 1','Day 2'});
categorical_vector_day2 = [];
categorical_vector_day3 = [];
set(0,'DefaultFigureRenderer','Painters')


for day = 1:length(accuracyDay2CommonSubset);
    categorical_vector_day2 = [categorical_vector_day2 categorical({'Day 1'})];
end
for female = 1:length(accuracyDay3CommonSubset)
    categorical_vector_day3 = [categorical_vector_day3 categorical({'Day 2'})];
end

figure; 
hold on; 
bar(days,[mean(awarenessDay2CommonSubset)*100 mean(awarenessDay3CommonSubset)*100],'BarWidth',0.25,'FaceColor',[0.5 1 0])


s1_xs = ones(1,length(awarenessDay2CommonSubset)) + 0.1 * rand(61, 1) - 0.05;
s1 = scatter(s1_xs,awarenessDay2CommonSubset*100,72,[1 0.5 0],'filled')
s2_xs = 2*ones(1,length(awarenessDay2CommonSubset)) + 0.1 * rand(61, 1) - 0.05;
s2 = scatter(s2_xs,awarenessDay3CommonSubset*100,72,[1 0.5 0],'filled')
set(gca,'FontSize',24)

ylabel('Awareness (%)')
ylim([0 40])

for point = 1:length(awarenessDay2CommonSubset)
    line([s1_xs(point) s2_xs(point)],[awarenessDay2CommonSubset(point)*100 awarenessDay3CommonSubset(point)*100]);
end


figure; 
hold on; 
bar(days,[mean(unawarenessDay2CommonSubset)*100 mean(unawarenessDay3CommonSubset)*100],'BarWidth',0.25,'FaceColor',[0.5 1 0])

s1_xs = ones(1,length(unawarenessDay2CommonSubset)) + 0.1 * rand(61, 1) - 0.05;
s1 = scatter(s1_xs,unawarenessDay2CommonSubset*100,72,[1 0.5 0],'filled')
s2_xs = 2*ones(1,length(unawarenessDay2CommonSubset)) + 0.1 * rand(61, 1) - 0.05;
s2 = scatter(s2_xs,unawarenessDay3CommonSubset*100,72,[1 0.5 0],'filled')
set(gca,'FontSize',24)

ylabel('Unawareness (%)')
ylim([0 40])

for point = 1:length(unawarenessDay2CommonSubset)
    line([s1_xs(point) s2_xs(point)],[unawarenessDay2CommonSubset(point)*100 unawarenessDay3CommonSubset(point)*100]);
end


figure; 
hold on; 
bar(days,[mean(accuracyDay2CommonSubset) mean(accuracyDay3CommonSubset)],'BarWidth',0.25,'FaceColor',[0.5 1 0])


s1_xs = ones(1,length(accuracyDay2CommonSubset)) + 0.1 * rand(61, 1) - 0.05;
s1 = scatter(s1_xs,accuracyDay2CommonSubset,72,[1 0.5 0],'filled')
s2_xs = 2*ones(1,length(accuracyDay2CommonSubset)) + 0.1 * rand(61, 1) - 0.05;
s2 = scatter(s2_xs,accuracyDay3CommonSubset,72,[1 0.5 0],'filled')
set(gca,'FontSize',24)

ylabel('Accuracy (%)')
ylim([0 100])

for point = 1:length(accuracyDay2CommonSubset)
    line([s1_xs(point) s2_xs(point)],[accuracyDay2CommonSubset(point) accuracyDay3CommonSubset(point)]);
end


figure; 
hold on; 
bar(days,[mean(confidenceDay2CommonSubset) mean(confidenceDay3CommonSubset)],'BarWidth',0.25,'FaceColor',[0.5 1 0])

s1_xs = ones(1,length(confidenceDay2CommonSubset)) + 0.1 * rand(61, 1) - 0.05;
s1 = scatter(s1_xs,confidenceDay2CommonSubset,72,[1 0.5 0],'filled')
s2_xs = 2*ones(1,length(confidenceDay2CommonSubset)) + 0.1 * rand(61, 1) - 0.05;
s2 = scatter(s2_xs,confidenceDay3CommonSubset,72,[1 0.5 0],'filled')
set(gca,'FontSize',24)

ylabel('Raw Confidence (%)')
ylim([0 100])

for point = 1:length(confidenceDay2CommonSubset)
    line([s1_xs(point) s2_xs(point)],[confidenceDay2CommonSubset(point) confidenceDay3CommonSubset(point)]);
end
