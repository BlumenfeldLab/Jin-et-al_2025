%% Generates the moves and times of movement for each participant, and compares against puzzle complexity. Note: Move Configurations were not storing properly subjects 774-798. 

[num text raw] = xlsread('Y:\HNCT_AoA_Study\AoA_Subjects\AoA_All_Subjs_Data_Movedat.xlsx');
root = 'Y:\HNCT_AoA_Study\AoA_Subjects\';
tic
all_all_moves = [];
all_all_quizzes = [];
all_all_coordinates = [];
all_all_times = [];
weird_subjs = [];
case1 = dlmread('C:\Users\dsj8\Documents\RushHourGamev10\case1_1_simplified.txt');
case2 = dlmread('C:\Users\dsj8\Documents\RushHourGamev10\case2_1_simplified.txt');
case3 = dlmread('C:\Users\dsj8\Documents\RushHourGamev10\case3_1_simplified.txt');
case4 = dlmread('C:\Users\dsj8\Documents\RushHourGamev10\case4_1_simplified.txt');
case5 = dlmread('C:\Users\dsj8\Documents\RushHourGamev10\case5_1_simplified.txt');
case6 = dlmread('C:\Users\dsj8\Documents\RushHourGamev10\case6_1_simplified.txt');
case7 = dlmread('C:\Users\dsj8\Documents\RushHourGamev10\case7_1_simplified.txt');
case8 = dlmread('C:\Users\dsj8\Documents\RushHourGamev10\case8_1_simplified.txt');
case9 = dlmread('C:\Users\dsj8\Documents\RushHourGamev10\case9_1_simplified.txt');
case10 = dlmread('C:\Users\dsj8\Documents\RushHourGamev10\case10_1_simplified.txt');

case1 = case1(1:length(case1)/2,:);
case2 = case2(1:length(case2)/2,:);
case3 = case3(1:length(case3)/2,:);
case4 = case4(1:length(case4)/2,:);
case5 = case5(1:length(case5)/2,:);
case6 = case6(1:length(case6)/2,:);
case7 = case7(1:length(case7)/2,:);
case8 = case8(1:length(case8)/2,:);
case9 = case9(1:length(case9)/2,:);
case10 = case10(1:length(case10)/2,:);


for session = 1:length(text)
    psydatSaveDirectory = [root '\' text{1,session} '\' text{2,session} '\']
            psydatFileDirectory = psydatSaveDirectory;
            sessionName = num2str(num(1,session));
            psydatSessionName = [sessionName '_' text{2,session}(4)];

    try
        if ~isfile([psydatSaveDirectory sessionName '_move_timings_and_blocks.mat'])
        
            weirdMove = [];
            allBlockRuns = [];
            allMoveCoordinates = [];
            allMoveTimes = [];
            for run = 1:6
                psydatFileName = [psydatFileDirectory '\'  psydatSessionName '_run' num2str(run) '.psydat'];
                if ~isfile(psydatFileName)
                    continue
                end
                try
                    movesList = py.list(py.pickle.load(py.open(psydatFileName,'rb')).entries{5}{'Pre-Move Configuration'}.values());
                    timesList = py.list(py.pickle.load(py.open(psydatFileName,'rb')).entries{5}{'Pre-Move Configuration'}.keys());
                catch
                    continue
                end
                moves_x = cell(1,length(movesList));
                moves_y = cell(1,length(movesList));
%                 for time = 1:length(timesList)
%                     currentTime = cell(timesList(time));
%                     allMoveTimes = [allMoveTimes timesList{1}];
%                 end
                timeCell = cell(timesList);
                allMoveTimes = [allMoveTimes cellfun(@double,timeCell)];

                for move = 1:length(movesList)
                    currentMove = movesList{move};
                    for block = 1:length(currentMove)
                        moves_x{move} = [moves_x{move} double(currentMove{block}{1})];
                        moves_y{move} = [moves_y{move} double(currentMove{block}{2})];

                    end
                    allBlockRuns = [allBlockRuns run];
                end
                allMoveCoordinates = [allMoveCoordinates [moves_x; moves_y]];
            end

            blocksMoved = [0];
            for move = 2:length(allMoveCoordinates)
                xcomparison1 = allMoveCoordinates{1,move-1};
                xcomparison2 = allMoveCoordinates{1,move};
                ycomparison1 = allMoveCoordinates{2,move-1};
                ycomparison2 = allMoveCoordinates{2,move};
                if length(xcomparison1) == length(xcomparison2)
                    if length(find(xcomparison1 ~= xcomparison2)) == 1
                        blocksMoved = [blocksMoved find(xcomparison1 ~= xcomparison2)];
                    elseif length(find(ycomparison1 ~= ycomparison2)) == 1
                        blocksMoved = [blocksMoved find(ycomparison1 ~= ycomparison2)];
                    elseif length(find(xcomparison1 ~= xcomparison2)) > 1 || length(find(ycomparison1 ~= ycomparison2)) > 1
                        blocksMoved = [blocksMoved 0];
                    elseif length(find(xcomparison1 ~= xcomparison2)) == 0 && length(find(ycomparison1 ~= ycomparison2)) == 0
                        blocksMoved = [blocksMoved 0];
                        weirdMove = [weirdMove move];
                    end
                end
                if length(xcomparison1) ~= length(xcomparison2)
                    blocksMoved = [blocksMoved 0];
                    continue
                end
            end
            

            eval(['save ' psydatSaveDirectory '\' sessionName '_move_timings_and_blocks.mat allBlockRuns allMoveCoordinates allMoveTimes blocksMoved weirdMove'])

        end
    catch
        continue
    end
    disp(['Loading ' text{1,session} ', ' text{2,session}])
    load([psydatSaveDirectory sessionName '_sliders_and_percentiles_timing.mat'])
    eval(['load ' psydatSaveDirectory sessionName '_move_timings_and_blocks.mat'])
    eval(['load ' psydatSaveDirectory sessionName '_python_timing_data.mat'])
    if length(allMoveCoordinates) ~= length(blocksMoved)
        disp('Weird subject found')
        weird_subjs = [weird_subjs {psydatSaveDirectory}];
        continue;
    end
    all_all_moves = [all_all_moves blocksMoved];
    all_all_coordinates = [all_all_coordinates allMoveCoordinates];
    all_all_times = [all_all_times allMoveTimes];
    sliderSuccessesAllPercentilesTiming(sliderSuccessesAllPercentilesTiming(:,1) == 9999,:) = [];
    sliderSuccessesAllPercentilesTiming = [sliderSuccessesAllPercentilesTiming zeros(length(sliderSuccessesAllPercentilesTiming),1)];
    for quiz = 1:length(sliderSuccessesAllPercentilesTiming)
        priorMoves = find(allMoveTimes < quizTimes(quiz));
        sliderSuccessesAllPercentilesTiming(quiz,7) = blocksMoved(max(priorMoves));
    end
    all_all_quizzes = [all_all_quizzes; sliderSuccessesAllPercentilesTiming]; 
    
    
end


toc

all_firstblock_indices = all_all_quizzes(find(all_all_quizzes(:,7) == 1),:);
all_otherblock_indices = all_all_quizzes(find(all_all_quizzes(:,7) ~= 1),:);
all_secondblock_indices = all_all_quizzes(find(all_all_quizzes(:,7) == 2),:);
all_thirdblock_indices = all_all_quizzes(find(all_all_quizzes(:,7) > 2),:);
%%
disp('Analyzing puzzle configuration information...')
puzzle_reset_indices = find(all_all_moves == 0);
puzzle_resets = all_all_coordinates(:,all_all_moves == 0);
puzzle_reset_times = all_all_times(all_all_moves == 0);
puzzle_configs = [];
for coordinate = 1:length(puzzle_resets)
    for config = 1:10
        try
            currentCoordinate = [puzzle_resets{1,coordinate}' puzzle_resets{2,coordinate}'];
            eval(['currentCase = case' num2str(config) ';'])
            currentSum = currentCoordinate == currentCase;
            if sum(sum(currentSum))/2 == length(currentCase);
                puzzle_configs = [puzzle_configs config];
            end
            
        end
    end
end

all_all_quizzes(:,8) = zeros(length(all_all_quizzes),1);

for quiz = 1:length(all_all_quizzes)
    puzzleTimeDiff = all_all_quizzes(quiz,6) - puzzle_reset_times;
    puzzle_time_diff_pos = puzzleTimeDiff(puzzleTimeDiff > 0);
    pos_idx = find(puzzleTimeDiff > 0);
    min_pos_idx = find(puzzle_time_diff_pos == min(puzzle_time_diff_pos));
    closest_puzzle_idx = pos_idx(min_pos_idx);
    
    all_all_quizzes(quiz,8) = puzzle_configs(closest_puzzle_idx);
end
disp('Done.')
%%

% Case 1: Solvable in 4
% Case 2: Solvable in 4
% Case 3: Solvable in 5
% Case 4: Solvable in 6
% Case 5: Solvable in 8
% Case 6: Solvable in 5
% Case 7: Solvable in 4
% Case 8: Solvable in 8
% Case 9: Solvable in 4
% Case 10: Solvable in 5
configMinSolve = [4 4 5 6 8 5 4 8 4 5];
configUnawarenessRates = zeros(1,10);
configAwarenessRates = zeros(1,10);
configQuizFrequency = zeros(1,10);
configConfidences = [];
configAccuracies = [];
for config = 1:10
    currentConfigAware = 0;
    currentConfigUnaware = 0;
    currentConfigConfidence = [];
    currentConfigAccuracy = [];
    eval(['case' num2str(config) '_quizzes = all_all_quizzes(find(all_all_quizzes(:,8) == ' num2str(config) '),:);'])
    eval(['currentConfig = case' num2str(config) '_quizzes;'])
    for quiz = 1:length(currentConfig)
        if currentConfig(quiz,3) < 25 && currentConfig(quiz,4) == 0;
            currentConfigUnaware = currentConfigUnaware + 1;
        end
        if currentConfig(quiz,3) > 75 && currentConfig(quiz,4) == 1;
            currentConfigAware = currentConfigAware + 1;
        end
        currentConfigConfidence = [currentConfigConfidence currentConfig(quiz,3)];
        currentConfigAccuracy = [currentConfigAccuracy currentConfig(quiz,4)*100];
        
    end
    configUnawarenessRates(config) = currentConfigUnaware / length(currentConfig);
    configAwarenessRates(config) = currentConfigAware / length(currentConfig);
    configAccuracy(config) = mean(currentConfigAccuracy);
    configConfidence(config) = mean(currentConfigConfidence);
    configQuizFrequency(config) = length(currentConfig);
    
    
    
end

configQuizFrequency = configQuizFrequency/56;
figure;
hold on
scatter(configMinSolve,configQuizFrequency,96,'filled')
xlabel('Minimum Moves to Solve')
ylabel('Quizzes Per Subject')
ylim([0 30])
set(gca,'FontSize',24)
set(gca,'xtick',[4:8])
p = polyfit(configMinSolve, configQuizFrequency, 1);          % linear fit (degree 1)
yfit = polyval(p, configMinSolve);

plot(configMinSolve, yfit, '-', 'LineWidth', 2)
hold off

figure
hold on
scatter(configMinSolve,configUnawarenessRates*100,96,'filled')
xlabel('Minimum Moves to Solve')
ylabel('Unawareness Rate (%)')
ylim([0 30])
set(gca,'FontSize',24)
set(gca,'xtick',[4:8])

p = polyfit(configMinSolve, configUnawarenessRates*100, 1);          % linear fit (degree 1)
yfit = polyval(p, configMinSolve);

plot(configMinSolve, yfit, '-', 'LineWidth', 2)
hold off



figure
hold on
scatter(configMinSolve,configAwarenessRates*100,96,'filled')
xlabel('Minimum Moves to Solve')
ylabel('Awareness Rate (%)')

ylim([0 30])
set(gca,'FontSize',24)
set(gca,'xtick',[4:8])

p = polyfit(configMinSolve, configAwarenessRates*100, 1);          % linear fit (degree 1)
yfit = polyval(p, configMinSolve);

plot(configMinSolve, yfit, '-', 'LineWidth', 2)
hold off

figure
hold on
scatter(configMinSolve,configAccuracy,96,'filled')
xlabel('Minimum Moves to Solve')
ylabel('Accuracy (%)')

set(gca,'xtick',[4:8])
set(gca,'FontSize',24)

p = polyfit(configMinSolve, configAccuracy, 1);          % linear fit (degree 1)
yfit = polyval(p, configMinSolve);

plot(configMinSolve, yfit, '-', 'LineWidth', 2)
hold off

figure
hold on
scatter(configMinSolve,configConfidence,96,'filled')
xlabel('Minimum Moves to Solve')
ylabel('Confidence (Percentile)')
set(gca,'xtick',[4:8])
set(gca,'FontSize',24)

p = polyfit(configMinSolve, configConfidence, 1);          % linear fit (degree 1)
yfit = polyval(p, configMinSolve);

plot(configMinSolve, yfit, '-', 'LineWidth', 2)
hold off

[r_unawareness,pval_unawareness] = corr(configMinSolve',configUnawarenessRates');
[r_awareness,pval_awareness] = corr(configMinSolve',configAwarenessRates');
[r_accuracy,pval_accuracy] = corr(configMinSolve',configAccuracy');
[r_confidence,pval_confidence] = corr(configMinSolve',configConfidence');

%%
aware_count_firstblock = 0;
unaware_count_firstblock = 0;
other_count_firstblock = 0;
midhigh_count_firstblock = 0;
midlow_count_firstblock = 0;
unvalidated_count_firstblock = 0
for item = 1:length(all_firstblock_indices)
    if all_firstblock_indices(item,3) > 75 && all_firstblock_indices(item,4) == 1
        aware_count_firstblock = aware_count_firstblock + 1;
    elseif all_firstblock_indices(item,3) < 25 && all_firstblock_indices(item,4) == 0
        unaware_count_firstblock = unaware_count_firstblock + 1;
    elseif all_firstblock_indices(item,3) >= 25 && all_firstblock_indices(item,3) <= 50;
        midlow_count_firstblock = midlow_count_firstblock + 1;
    elseif all_firstblock_indices(item,3) > 50 && all_firstblock_indices(item,3) <= 75;
        midhigh_count_firstblock = midhigh_count_firstblock + 1;
    else
        other_count_firstblock = other_count_firstblock + 1;
    end
end

aware_count_otherblock = 0;
unaware_count_otherblock = 0;
other_count_otherblock = 0;
midhigh_count_otherblock = 0;
midlow_count_otherblock = 0;
unvalidated_count_otherblock = 0
for item = 1:length(all_otherblock_indices)
    if all_otherblock_indices(item,3) > 75 && all_otherblock_indices(item,4) == 1
        aware_count_otherblock = aware_count_otherblock + 1;
    elseif all_otherblock_indices(item,3) < 25 && all_otherblock_indices(item,4) == 0
        unaware_count_otherblock = unaware_count_otherblock + 1;
    elseif all_otherblock_indices(item,3) >= 25 && all_otherblock_indices(item,3) <= 50;
        midlow_count_otherblock = midlow_count_otherblock + 1;
    elseif all_otherblock_indices(item,3) > 50 && all_otherblock_indices(item,3) <= 75;
        midhigh_count_otherblock = midhigh_count_otherblock + 1;
    else
        other_count_otherblock = other_count_otherblock + 1;
    end
end
aware_count_firstblock_raw = aware_count_firstblock;
unaware_count_firstblock_raw = unaware_count_firstblock;
midhigh_count_firstblock_raw = midhigh_count_firstblock;
midlow_count_firstblock_raw = midlow_count_firstblock;
other_count_firstblock_raw = other_count_firstblock;

aware_count_firstblock = aware_count_firstblock*100 / length(all_firstblock_indices);
unaware_count_firstblock = unaware_count_firstblock*100 / length(all_firstblock_indices);
midhigh_count_firstblock = midhigh_count_firstblock*100 / length(all_firstblock_indices);
midlow_count_firstblock = midlow_count_firstblock*100 / length(all_firstblock_indices);
other_count_firstblock = other_count_firstblock*100 / length(all_firstblock_indices);


aware_count_otherblock_raw = aware_count_otherblock;
unaware_count_otherblock_raw = unaware_count_otherblock;
midhigh_count_otherblock_raw = midhigh_count_otherblock;
midlow_count_otherblock_raw = midlow_count_otherblock;
other_count_otherblock_raw = other_count_otherblock;

aware_count_otherblock = aware_count_otherblock*100 / length(all_otherblock_indices);
unaware_count_otherblock = unaware_count_otherblock*100 / length(all_otherblock_indices);
midhigh_count_otherblock = midhigh_count_otherblock*100 / length(all_otherblock_indices);
midlow_count_otherblock = midlow_count_otherblock*100 / length(all_otherblock_indices);
other_count_otherblock = other_count_otherblock*100 / length(all_otherblock_indices);


aware_count_secondblock = 0;
unaware_count_secondblock = 0;
second_count_secondblock = 0;
midhigh_count_secondblock = 0;
midlow_count_secondblock = 0;
other_count_secondblock = 0;
unvalidated_count_secondblock = 0
for item = 1:length(all_secondblock_indices)
    if all_secondblock_indices(item,3) > 75 && all_secondblock_indices(item,4) == 1
        aware_count_secondblock = aware_count_secondblock + 1;
    elseif all_secondblock_indices(item,3) < 25 && all_secondblock_indices(item,4) == 0
        unaware_count_secondblock = unaware_count_secondblock + 1;
    elseif all_secondblock_indices(item,3) >= 25 && all_secondblock_indices(item,3) <= 50;
        midlow_count_secondblock = midlow_count_secondblock + 1;
    elseif all_secondblock_indices(item,3) > 50 && all_secondblock_indices(item,3) <= 75;
        midhigh_count_secondblock = midhigh_count_secondblock + 1;
    else
        other_count_secondblock = other_count_secondblock + 1;
    end
end

aware_count_secondblock_raw = aware_count_secondblock;
unaware_count_secondblock_raw = unaware_count_secondblock;
midhigh_count_secondblock_raw = midhigh_count_secondblock;
midlow_count_secondblock_raw = midlow_count_secondblock;
other_count_secondblock_raw = other_count_secondblock;

aware_count_secondblock = aware_count_secondblock*100 / length(all_secondblock_indices);
unaware_count_secondblock = unaware_count_secondblock*100 / length(all_secondblock_indices);
midhigh_count_secondblock = midhigh_count_secondblock*100 / length(all_secondblock_indices);
midlow_count_secondblock = midlow_count_secondblock*100 / length(all_secondblock_indices);
other_count_secondblock = other_count_secondblock*100 / length(all_secondblock_indices);

aware_count_thirdblock = 0;
unaware_count_thirdblock = 0;
third_count_thirdblock = 0;
for item = 1:length(all_thirdblock_indices)
    if all_thirdblock_indices(item,3) > 75 && all_thirdblock_indices(item,4) == 1
        aware_count_thirdblock = aware_count_thirdblock + 1;
    elseif all_thirdblock_indices(item,3) < 25 && all_thirdblock_indices(item,4) == 0
        unaware_count_thirdblock = unaware_count_thirdblock + 1;
    else
        third_count_thirdblock = third_count_thirdblock + 1;
    end
end

aware_count_thirdblock = aware_count_thirdblock*100 / length(all_thirdblock_indices);
unaware_count_thirdblock = unaware_count_thirdblock*100 / length(all_thirdblock_indices);
third_count_thirdblock = third_count_thirdblock*100 / length(all_thirdblock_indices);

%%
figure;

allBars = [aware_count_firstblock unaware_count_firstblock midhigh_count_firstblock midlow_count_firstblock other_count_firstblock; aware_count_secondblock unaware_count_secondblock midhigh_count_secondblock midlow_count_secondblock other_count_secondblock; aware_count_otherblock unaware_count_otherblock midhigh_count_otherblock midlow_count_otherblock other_count_otherblock]
xs = categorical({'Red Block','First Non-Red Block','Other Blocks'});
barchart_figure = bar(xs,allBars,'grouped');
barchart_figure(1).BarWidth = 1;
legend({'Aware','Unaware','Mid-High','Mid-Low','Unvalidated'})
set(gca,'FontSize',24)
ylim([0 30])
barchart_figure = 0.25
title('Red Block Awareness/Unawareness Rates')


%% Chi-Squared Testing for Color Salience

firstblock_counts_fivecat = [aware_count_firstblock_raw unaware_count_firstblock_raw midhigh_count_firstblock_raw midlow_count_firstblock_raw other_count_firstblock_raw];
otherblock_counts_fivecat = [aware_count_otherblock_raw unaware_count_otherblock_raw midhigh_count_otherblock_raw midlow_count_otherblock_raw other_count_otherblock_raw];

firstblock_counts_threecat = [aware_count_firstblock_raw unaware_count_firstblock_raw midhigh_count_firstblock_raw+midlow_count_firstblock_raw+other_count_firstblock_raw];
otherblock_counts_threecat = [aware_count_otherblock_raw unaware_count_otherblock_raw midhigh_count_otherblock_raw+midlow_count_otherblock_raw+other_count_otherblock_raw];

observed_fivecat = [firstblock_counts_fivecat; otherblock_counts_fivecat];

rowSums = sum(observed_fivecat, 2);
colSums = sum(observed_fivecat, 1);
N = sum(observed_fivecat(:));

expected = (rowSums * colSums) / N;

chi2stat_fivecat = sum((observed_fivecat - expected).^2 ./ expected, 'all');
df_fivecat = (size(observed_fivecat,1)-1) * (size(observed_fivecat,2)-1);
p_fivecat = 1 - chi2cdf(chi2stat_fivecat, df_fivecat);


observed_threecat = [firstblock_counts_threecat; otherblock_counts_threecat];

rowSums = sum(observed_threecat, 2);
colSums = sum(observed_threecat, 1);
N = sum(observed_threecat(:));

expected = (rowSums * colSums) / N;

chi2stat_threecat = sum((observed_threecat - expected).^2 ./ expected, 'all');
df_threecat = (size(observed_threecat,1)-1) * (size(observed_threecat,2)-1);
p_threecat = 1 - chi2cdf(chi2stat_threecat, df_threecat);
