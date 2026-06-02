clear all
clc

%%
%psydatFileDirectory = 'C:\Users\dsj8\OneDrive - Yale University\Desktop\AoA_Data\AoA_EEG\';
[num text raw] = xlsread('D:\AoA_0930\AoA_All_Subjs_Data.xlsx');
root = 'D:\';

sexes = {'M','F'}
currentsex_subjects = cell(1,2);

indices_m = find(contains(text(6,:),'M'));

currentsex_subjects{1,1} = [unique(text(1,indices_m)); cell(1,length(unique(text(1,indices_m))));cell(1,length(unique(text(1,indices_m))));cell(1,length(unique(text(1,indices_m))));cell(1,length(unique(text(1,indices_m))));cell(1,length(unique(text(1,indices_m))))];

indices_f = find(contains(text(6,:),'F'));

currentsex_subjects{1,2} = [unique(text(1,indices_f)); cell(1,length(unique(text(1,indices_f))));cell(1,length(unique(text(1,indices_f))));cell(1,length(unique(text(1,indices_f))));cell(1,length(unique(text(1,indices_f))));cell(1,length(unique(text(1,indices_f))))];


for sex = 1:2
    badSession = 0;
    allPercentiles = [];
    allResults = [];
    allSessions = [];
    allSessionDays = [];

    figure
    hold on
    subjectList = [];

    for session = 1:length(text)
        if ~strcmp(text{6,session},sexes{sex})
            continue
        end
        disp(['Analyzing ' text{1,session}])
        try
            subjectList = [subjectList; text(1,session)];

            psydatSaveDirectory = [root '\' text{1,session} '\' text{2,session} '\'];
            psydatFileDirectory = psydatSaveDirectory;
            sessionName = num2str(num(1,session));
            psydatSessionName = [sessionName '_' text{2,session}(4)];
            cd(psydatSaveDirectory)
            sliderSuccessesAll = [];
            multipleChoiceSuccessesAll = [];
            quizTimes = [];
            quizNumbers = [];
            runFirstTTLTime = [];
            if strcmp(text{2,session},'Day2')
                sessionDay = 2;
            elseif strcmp(text{2,session},'Day3')
                sessionDay = 3;
            end
            quizAnswers = [];
            load([sessionName '_sliders_and_percentiles_timing.mat'])
            sliderSuccessesAllPercentilesTiming(sliderSuccessesAllPercentilesTiming(:,1) == 9999,:) = [];
            sliderSuccessesAllPercentilesTiming(:,1) = (sliderSuccessesAllPercentilesTiming(:,1) + 450) / 900;
            for subject = 1:length(currentsex_subjects{sex})
                if strcmp(currentsex_subjects{sex}{1,subject},text{1,session})
                    currentsex_subjects{sex}{2,subject} = [currentsex_subjects{sex}{2,subject}; sliderSuccessesAllPercentilesTiming(:,4)];
                    currentsex_subjects{sex}{3,subject} = [currentsex_subjects{sex}{3,subject}; sliderSuccessesAllPercentilesTiming(:,1)];
                    currentsex_subjects{sex}{4,subject} = [currentsex_subjects{sex}{4,subject}; sliderSuccessesAllPercentilesTiming(:,3)];
                end
            end
        catch
            continue
        end
    end
    
    

end
%%
confidences_m = [];
confidences_f = [];
accuracies_m = [];
accuracies_f = [];
unawareness_m = [];
unawareness_f = [];
awareness_m = [];
awareness_f = [];
subjects_m = currentsex_subjects{1};

subjects_f = currentsex_subjects{2};

for subject = 1:length(subjects_m)
    currentSubjectAccuracies = subjects_m{2,subject};
    currentSubjectConfidences = subjects_m{4,subject};
    currentSubjectConfidencesRaw = subjects_m{3,subject};
    
    unawareCount = 0;
    awareCount = 0; 
    for item = 1:length(currentSubjectAccuracies)
        if currentSubjectAccuracies(item) == 0 && currentSubjectConfidences(item) < 25
            unawareCount = unawareCount + 1;
        end
    end
    for item = 1:length(currentSubjectAccuracies)
        if currentSubjectAccuracies(item) == 1 && currentSubjectConfidences(item) > 75
            awareCount = awareCount + 1;
        end
    end
    subjects_m{4,subject} = unawareCount / length(currentSubjectAccuracies);
    subjects_m{5,subject} = awareCount / length(currentSubjectAccuracies);
    accuracies_m = [accuracies_m mean(currentSubjectAccuracies)];
    confidences_m = [confidences_m mean(currentSubjectConfidencesRaw)];
    unawareness_m = [unawareness_m unawareCount / length(currentSubjectAccuracies)];
    awareness_m = [awareness_m awareCount / length(currentSubjectAccuracies)];
end

for subject = 1:length(subjects_f)
    currentSubjectAccuracies = subjects_f{2,subject};
    currentSubjectConfidences = subjects_f{4,subject};
    currentSubjectConfidencesRaw = subjects_f{3,subject};
    unawareCount = 0;
    awareCount = 0;
    for item = 1:length(currentSubjectAccuracies)
        if currentSubjectAccuracies(item) == 0 && currentSubjectConfidences(item) < 25
            unawareCount = unawareCount + 1;
        end
    end
    for item = 1:length(currentSubjectAccuracies)
        if currentSubjectAccuracies(item) == 1 && currentSubjectConfidences(item) > 75
            awareCount = awareCount + 1;
        end
    end
    subjects_f{4,subject} = unawareCount / length(currentSubjectAccuracies);
    subjects_f{5,subject} = awareCount / length(currentSubjectAccuracies);
    accuracies_f = [accuracies_f mean(currentSubjectAccuracies)];
    confidences_f = [confidences_f mean(currentSubjectConfidencesRaw)];
    unawareness_f = [unawareness_f unawareCount / length(currentSubjectAccuracies)];
    awareness_f = [awareness_f awareCount / length(currentSubjectAccuracies)];
end


allSubjects = [unique(text(1,:)); cell(1,length(unique(text(1,:))))];

for session = 1:length(text)
    for subject = 1:length(allSubjects)
        if strcmp(text{1,session}, allSubjects{1,subject})
            allSubjects{2,subject} = num(5,session);
        end
    end
end

ageArray = cell2mat(allSubjects(2,:));
fullArray = [allSubjects;cell(4,length(allSubjects))];


for subject1 = 1:length(subjects_f)
    for subject2 = 1:length(fullArray)
        if strcmp(fullArray{1,subject2},subjects_f{1,subject1})
            fullArray{3,subject2} = mean(subjects_f{2,subject1});
            fullArray{4,subject2} = mean(subjects_f{3,subject1});
            fullArray{5,subject2} = subjects_f{4,subject1};
            fullArray{6,subject2} = subjects_f{5,subject1};
        end
    end
end

for subject1 = 1:length(subjects_m)
    for subject2 = 1:length(fullArray)
        if strcmp(fullArray{1,subject2},subjects_m{1,subject1})
            fullArray{3,subject2} = mean(subjects_m{2,subject1});
            fullArray{4,subject2} = mean(subjects_m{3,subject1});
            fullArray{5,subject2} = subjects_m{4,subject1};
            fullArray{6,subject2} = subjects_m{5,subject1};
        end
    end
end

%%
allAccuracies = cell2mat(fullArray(3,:))*100;
allConfidences = cell2mat(fullArray(4,:))*100;
allUnawareness = cell2mat(fullArray(5,:))*100;
allAwareness = cell2mat(fullArray(6,:))*100;

x = ageArray; % Your 1x67 vector for the x-axis
y = allAccuracies; % Your 1x67 vector for the y-axis

p = polyfit(x, y, 1); % Fit a linear trendline
y_fit = polyval(p, x); % Evaluate the polynomial at the x values

residuals = y - y_fit; % Calculate residuals
SEM = std(residuals) / sqrt(length(y)); % Standard error of the mean

ci = 1.96 * SEM; % 95% confidence interval (replace 1.96 with desired z-score for different levels)
y_upper = y_fit + ci;
y_lower = y_fit - ci;

% Sort the x values for the fill
[x_sorted, sortIdx] = sort(x);
y_upper_sorted = y_upper(sortIdx);
y_lower_sorted = y_lower(sortIdx);

% Plot the shaded error bands
figure;
fill([x_sorted, fliplr(x_sorted)], [y_upper_sorted, fliplr(y_lower_sorted)], 'b', ...
     'FaceAlpha', 0.2, 'EdgeColor', 'none'); % Shaded area with transparency
hold on;

% Plot the trendline on top of the error bands
plot(x, y_fit, '-b', 'LineWidth', 2);

% Plot the original data points
scatter(x, y, 'filled');

% Customize the plot
xlabel('X-axis Label');
ylabel('Y-axis Label');
title('Trendline with Error Bands');
legend('Error Bands (95% CI)', 'Trendline', 'Data', 'Location', 'Best');
hold off;

%% 95% Confidence Intervals

% Given data: accuracies, male
data = accuracies_m;

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
margin_of_error_accuracies_m = t_value * sem;

% Step 5: Confidence Interval
lower_bound_accuracies_m = mean_value - margin_of_error_accuracies_m;
upper_bound_accuracies_m = mean_value + margin_of_error_accuracies_m;
confidence_interval_accuracies_m = [lower_bound_accuracies_m, upper_bound_accuracies_m];

% Display the result
disp('95% Confidence Interval:');
disp(confidence_interval_accuracies_m);
disp('Margin of Error: ')
disp(margin_of_error_accuracies_m)

% Given data: accuracies, female
data = accuracies_f;

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
margin_of_error_accuracies_f = t_value * sem;

% Step 5: Confidence Interval
lower_bound_accuracies_f = mean_value - margin_of_error_accuracies_f;
upper_bound_accuracies_f = mean_value + margin_of_error_accuracies_f;
confidence_interval_accuracies_f = [lower_bound_accuracies_f, upper_bound_accuracies_f];

% Display the result
disp('95% Confidence Interval:');
disp(confidence_interval_accuracies_f);
disp('Margin of Error: ')
disp(margin_of_error_accuracies_f)

% Given data: confidences, male
data = confidences_m;

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
margin_of_error_confidences_m = t_value * sem;

% Step 5: Confidence Interval
lower_bound_confidences_m = mean_value - margin_of_error_confidences_m;
upper_bound_confidences_m = mean_value + margin_of_error_confidences_m;
confidence_interval_confidences_m = [lower_bound_confidences_m, upper_bound_confidences_m];

% Display the result
disp('95% Confidence Interval:');
disp(confidence_interval_confidences_m);
disp('Margin of Error: ')
disp(margin_of_error_confidences_m)

% Given data: confidences, female
data = confidences_f;

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
margin_of_error_confidences_f = t_value * sem;

% Step 5: Confidence Interval
lower_bound_confidences_f = mean_value - margin_of_error_confidences_f;
upper_bound_confidences_f = mean_value + margin_of_error_confidences_f;
confidence_interval_confidences_f = [lower_bound_confidences_f, upper_bound_confidences_f];

% Display the result
disp('95% Confidence Interval:');
disp(confidence_interval_confidences_f);
disp('Margin of Error: ')
disp(margin_of_error_confidences_f)

% Given data: awareness, male
data = awareness_m;

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
margin_of_error_awareness_m = t_value * sem;

% Step 5: Confidence Interval
lower_bound_awareness_m = mean_value - margin_of_error_awareness_m;
upper_bound_awareness_m = mean_value + margin_of_error_awareness_m;
confidence_interval_awareness_m = [lower_bound_awareness_m, upper_bound_awareness_m];

% Display the result
disp('95% Confidence Interval:');
disp(confidence_interval_awareness_m);
disp('Margin of Error: ')
disp(margin_of_error_awareness_m)

% Given data: awareness, female
data = awareness_f;

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
margin_of_error_awareness_f = t_value * sem;

% Step 5: Confidence Interval
lower_bound_awareness_f = mean_value - margin_of_error_awareness_f;
upper_bound_awareness_f = mean_value + margin_of_error_awareness_f;
confidence_interval_awareness_f = [lower_bound_awareness_f, upper_bound_awareness_f];

% Display the result
disp('95% Confidence Interval:');
disp(confidence_interval_awareness_f);
disp('Margin of Error: ')
disp(margin_of_error_awareness_f)

% Given data: unawareness, male
data = unawareness_m;

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
margin_of_error_unawareness_m = t_value * sem;

% Step 5: Confidence Interval
lower_bound_unawareness_m = mean_value - margin_of_error_unawareness_m;
upper_bound_unawareness_m = mean_value + margin_of_error_unawareness_m;
confidence_interval_unawareness_m = [lower_bound_unawareness_m, upper_bound_unawareness_m];

% Display the result
disp('95% Confidence Interval:');
disp(confidence_interval_unawareness_m);
disp('Margin of Error: ')
disp(margin_of_error_unawareness_m)

% Given data: unawareness, female
data = unawareness_f;

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
margin_of_error_unawareness_f = t_value * sem;

% Step 5: Confidence Interval
lower_bound_unawareness_f = mean_value - margin_of_error_unawareness_f;
upper_bound_unawareness_f = mean_value + margin_of_error_unawareness_f;
confidence_interval_unawareness_f = [lower_bound_unawareness_f, upper_bound_unawareness_f];

% Display the result
disp('95% Confidence Interval:');
disp(confidence_interval_unawareness_f);
disp('Margin of Error: ')
disp(margin_of_error_unawareness_f)
