%% Note: Move Configurations were not storing properly subjects 774-798. 

[num text raw] = xlsread('D:\AoA_Subjects_Small_Files\AoA_All_Subjs_Data_Movedat.xlsx');
root = 'Y:\HNCT_AoA_Study\AoA_Subjects\';
tic
all_all_moves = [];
all_all_quizzes = [];


% Transpose the cell array to make it a column
dataColumn = unique(text(1,:))';

% Create a table with a single column named 'Data' (or any name you prefer)
dataTable = table(dataColumn, 'VariableNames', {'SubjectID'});

dataTable.RedAccuracy = cell(height(dataTable), 1);
dataTable.RedConfidence = cell(height(dataTable), 1);
dataTable.RedAwareness = cell(height(dataTable), 1);
dataTable.RedUnawareness = cell(height(dataTable), 1);

dataTable.WhiteAccuracy = cell(height(dataTable), 1);
dataTable.WhiteConfidence = cell(height(dataTable), 1);
dataTable.WhiteAwareness = cell(height(dataTable), 1);
dataTable.WhiteUnawareness = cell(height(dataTable), 1);


for session = 1:length(text)
    psydatSaveDirectory = [root '\' text{1,session} '\' text{2,session} '\']
            psydatFileDirectory = psydatSaveDirectory;
            sessionName = num2str(num(1,session));
            psydatSessionName = [sessionName '_' text{2,session}(4)];
    disp(['Loading ' text{1,session} ', ' text{2,session}])
    load([psydatSaveDirectory sessionName '_sliders_and_percentiles_timing.mat'])
    eval(['load ' psydatSaveDirectory sessionName '_move_timings_and_blocks.mat'])
    eval(['load ' psydatSaveDirectory sessionName '_python_timing_data.mat'])
    all_all_moves = [all_all_moves blocksMoved];
    sliderSuccessesAllPercentilesTiming(sliderSuccessesAllPercentilesTiming(:,1) == 9999,:) = [];
    sliderSuccessesAllPercentilesTiming = [sliderSuccessesAllPercentilesTiming zeros(length(sliderSuccessesAllPercentilesTiming),1)];
    for quiz = 1:length(sliderSuccessesAllPercentilesTiming)
        priorMoves = find(allMoveTimes < quizTimes(quiz));
        sliderSuccessesAllPercentilesTiming(quiz,7) = blocksMoved(max(priorMoves));
    end
    all_all_quizzes = [all_all_quizzes; sliderSuccessesAllPercentilesTiming]; 
    currentSessionFirstBlock = sliderSuccessesAllPercentilesTiming(find(sliderSuccessesAllPercentilesTiming(:,7) == 1),:);
    currentSessionOtherBlock = sliderSuccessesAllPercentilesTiming(find(sliderSuccessesAllPercentilesTiming(:,7) ~= 1),:);
    currentSessionFirstBlockAwareDesignation = [];
    for quiz = 1: size(currentSessionFirstBlock,1)
        if currentSessionFirstBlock(quiz,3) > 75 && currentSessionFirstBlock(quiz,4) == 1
            currentSessionFirstBlockAwareDesignation = [currentSessionFirstBlockAwareDesignation 1];
        else
            currentSessionFirstBlockAwareDesignation = [currentSessionFirstBlockAwareDesignation 0];
        end
    end
    currentSessionOtherBlockAwareDesignation = [];
    for quiz = 1: size(currentSessionOtherBlock,1)
        if currentSessionOtherBlock(quiz,3) > 75 && currentSessionOtherBlock(quiz,4) == 1
            currentSessionOtherBlockAwareDesignation = [currentSessionOtherBlockAwareDesignation 1];
        else
            currentSessionOtherBlockAwareDesignation = [currentSessionOtherBlockAwareDesignation 0];
        end
    end
    currentSessionFirstBlockUnawareDesignation = [];
    for quiz = 1: size(currentSessionFirstBlock,1)
        if currentSessionFirstBlock(quiz,3) < 25 && currentSessionFirstBlock(quiz,4) == 0
            currentSessionFirstBlockUnawareDesignation = [currentSessionFirstBlockUnawareDesignation 1];
        else
            currentSessionFirstBlockUnawareDesignation = [currentSessionFirstBlockUnawareDesignation 0];
        end
    end
    currentSessionOtherBlockUnawareDesignation = [];
    for quiz = 1: size(currentSessionOtherBlock,1)
        if currentSessionOtherBlock(quiz,3) < 25 && currentSessionOtherBlock(quiz,4) == 0
            currentSessionOtherBlockUnawareDesignation = [currentSessionOtherBlockUnawareDesignation 1];
        else
            currentSessionOtherBlockUnawareDesignation = [currentSessionOtherBlockUnawareDesignation 0];
        end
    end

    currentSessionFirstBlockAccuracy = currentSessionFirstBlock(:,4);
    currentSessionOtherBlockAccuracy = currentSessionOtherBlock(:,4);

    currentSessionFirstBlockConfidence = currentSessionFirstBlock(:,3);
    currentSessionOtherBlockConfidence = currentSessionOtherBlock(:,3);

    targetValue = text{1,session};


    rowIndex = find(strcmp(dataTable.SubjectID, targetValue));

    


   dataTable.RedAccuracy{rowIndex} = [dataTable.RedAccuracy{rowIndex}; currentSessionFirstBlockAccuracy];
   dataTable.RedConfidence{rowIndex} = [dataTable.RedConfidence{rowIndex}; currentSessionFirstBlockConfidence];
   dataTable.RedAwareness{rowIndex} = [dataTable.RedAwareness{rowIndex} currentSessionFirstBlockAwareDesignation];
   dataTable.RedUnawareness{rowIndex} = [dataTable.RedUnawareness{rowIndex} currentSessionFirstBlockUnawareDesignation];

   dataTable.WhiteAccuracy{rowIndex} = [dataTable.WhiteAccuracy{rowIndex}; currentSessionOtherBlockAccuracy];
   dataTable.WhiteConfidence{rowIndex} = [dataTable.WhiteConfidence{rowIndex}; currentSessionOtherBlockConfidence];
   dataTable.WhiteAwareness{rowIndex} = [dataTable.WhiteAwareness{rowIndex} currentSessionOtherBlockAwareDesignation];
   dataTable.WhiteUnawareness{rowIndex} = [dataTable.WhiteUnawareness{rowIndex} currentSessionOtherBlockUnawareDesignation];
    
    
end
toc

accuracyAverage_red = cellfun(@mean, dataTable.RedAccuracy);
sem_accuracy_red = std(accuracyAverage_red)/sqrt(length(accuracyAverage_red));
confidenceAverage_red = cellfun(@mean, dataTable.RedConfidence);
sem_confidence_red = std(confidenceAverage_red)/sqrt(length(confidenceAverage_red));
awarenessAverage_red = cellfun(@mean, dataTable.RedAwareness);
sem_awareness_red = std(awarenessAverage_red)/sqrt(length(awarenessAverage_red));
unawarenessAverage_red = cellfun(@mean, dataTable.RedUnawareness);
sem_unawareness_red = std(unawarenessAverage_red)/sqrt(length(unawarenessAverage_red));

accuracyAverage_white = cellfun(@mean, dataTable.WhiteAccuracy);
sem_accuracy_white = std(accuracyAverage_white)/sqrt(length(accuracyAverage_white));
confidenceAverage_white = cellfun(@mean, dataTable.WhiteConfidence);
sem_confidence_white = std(confidenceAverage_white)/sqrt(length(confidenceAverage_white));
awarenessAverage_white = cellfun(@mean, dataTable.WhiteAwareness);
sem_awareness_white = std(awarenessAverage_white)/sqrt(length(awarenessAverage_white));
unawarenessAverage_white = cellfun(@mean, dataTable.WhiteUnawareness);
sem_unawareness_white = std(unawarenessAverage_white)/sqrt(length(unawarenessAverage_white));


%% 
[h_accuracy, p_accuracy] = ttest(accuracyAverage_red,accuracyAverage_white);
[h_confidence, p_confidence] = ttest(confidenceAverage_red,confidenceAverage_white);
[h_awareness, p_awareness] = ttest(awarenessAverage_red,awarenessAverage_white);
[h_unawareness, p_unawareness] = ttest(unawarenessAverage_red,unawarenessAverage_white);

% Define your p-values as a vector
p_values = [p_awareness p_unawareness p_accuracy p_confidence]';  % Replace with your actual p-values

% Number of p-values
m = length(p_values);

% Step 1: Sort the p-values and keep track of the original indices
[sorted_p, sort_index] = sort(p_values);

% Step 2: Calculate the Benjamini-Hochberg adjusted p-values
bh_adjusted = sorted_p .* m ./ (1:m)';

% Step 3: Ensure the adjusted p-values are non-decreasing
% This step makes sure that the adjusted p-values don't decrease
bh_adjusted = cummin(bh_adjusted(end:-1:1));  % Apply cumulative minimum from end to start
bh_adjusted = min(bh_adjusted(end:-1:1), 1);  % Reverse back to sorted order and cap at 1

% Step 4: Place adjusted p-values back in original order
adjusted_p_values = NaN(size(p_values));  % Initialize array for adjusted p-values
adjusted_p_values(sort_index) = bh_adjusted;  % Place adjusted values in original order

% Display the adjusted p-values
disp('Adjusted p-values after Benjamini-Hochberg correction:');
disp(adjusted_p_values);

%%

figure; 
hold on; 
scatter(accuracyAverage_white*100,accuracyAverage_red*100,100,'Filled')
ylabel('Red Block Accuracy Percentage');
xlabel('White Block Accuracy Percentage');
set(gca,'FontSize',24);
xlim([0 100])
ylim([0 100])

figure; 
hold on; 
scatter(confidenceAverage_white,confidenceAverage_red,100,'Filled')
ylabel('Red Block Confidence Percentile');
xlabel('White Block Confidence Percentile');
set(gca,'FontSize',24);
xlim([0 100])
ylim([0 100])

figure; 
hold on; 
scatter(awarenessAverage_white*100,awarenessAverage_red*100,100,'Filled')
ylabel('Red Block Awareness Percentage');
xlabel('White Block Awareness Percentage');
set(gca,'FontSize',24);
xlim([0 100])
ylim([0 100])

figure; 
hold on; 
scatter(unawarenessAverage_white*100,unawarenessAverage_red*100,100,'Filled')
ylabel('Red Block Unawareness Percentage');
xlabel('White Block Unawareness Percentage');
set(gca,'FontSize',24);
xlim([0 100])
ylim([0 100])

%% Calculate confidence interval

accuracy_red_confidence_interval = 1.96 * (std(accuracyAverage_red) / sqrt(length(accuracyAverage_red)))
accuracy_white_confidence_interval = 1.96 * (std(accuracyAverage_white) / sqrt(length(accuracyAverage_white)))

confidence_red_confidence_interval = 1.96 * (std(confidenceAverage_red) / sqrt(length(confidenceAverage_red)))
confidence_white_confidence_interval = 1.96 * (std(confidenceAverage_white) / sqrt(length(confidenceAverage_white)))


awareness_red_confidence_interval = 1.96 * (std(awarenessAverage_red) / sqrt(length(awarenessAverage_red)))
awareness_white_confidence_interval = 1.96 * (std(awarenessAverage_white) / sqrt(length(awarenessAverage_white)))

unawareness_red_confidence_interval = 1.96 * (std(unawarenessAverage_red) / sqrt(length(unawarenessAverage_red)))
unawareness_white_confidence_interval = 1.96 * (std(unawarenessAverage_white) / sqrt(length(unawarenessAverage_white)))
