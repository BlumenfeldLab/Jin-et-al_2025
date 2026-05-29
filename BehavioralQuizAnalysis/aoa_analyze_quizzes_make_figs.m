clear all
clc

%% Load spreadsheet containing all subjects
[num text raw] = xlsread('Y:\HNCT_AoA_Study\AoA_Subjects\AoA_All_Subjs_Data_Sheet.xlsx');
root = 'Y:\HNCT_AoA_Study\AoA_Subjects\';
addpath(root)
badSession = 0;
allPercentiles = [];
allResults = [];
allSessions = [];
allSessionDays = [];
figure
hold on
for session = 1:length(text)
    try
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
        runNumbers = [];
        quizAnswers = [];
        quizConfidences = [];
        quizTimes = [];
        
        for run = 1:6
            
            psydatFileName = [psydatFileDirectory psydatSessionName '_run' num2str(run) '.psydat'];
            if isfile(psydatFileName)
                sliderList = py.list(py.pickle.load(py.open(psydatFileName,'rb')).entries{3}{'Slider Positions'}.values());
                multipleChoiceList = py.list(py.pickle.load(py.open(psydatFileName,'rb')).entries{2}{'Multiple Choice Answers'}.values());
                sliderSuccesses = [];
                quizKeys = py.list(py.pickle.load(py.open(psydatFileName,'rb')).entries{3}{'Slider Positions'}.keys());
                quizKeysCell = cell(quizKeys);
                quizTimes = [quizTimes cellfun(@double,quizKeysCell)];

                TTL_times = py.list(py.pickle.load(py.open(psydatFileName,'rb')).entries{1}{'Pulse Timing'}.keys());
                
                runFirstTTLTime = [runFirstTTLTime TTL_times{1}];
                
                for item = 1:length(sliderList)
                    statementspassed = 0;
                    
                    currentAnswerString = string(multipleChoiceList{item});
                    quizAnswers = [quizAnswers {currentAnswerString{1}}];
                    runNumbers = [runNumbers run];
                    
                    if isnumeric(sliderList{item}) 
                        sliderSuccesses = [sliderSuccesses sliderList{item}];
                        quizConfidences = [quizConfidences sliderList{item}];
                        statementspassed = statementspassed + 1;
                    end

                    try 
                        if double(sliderList{item}) == 0
                            sliderSuccesses = [sliderSuccesses double(sliderList{item})];
                            quizConfidences = [quizConfidences double(sliderList{item})];
                            statementspassed = statementspassed + 1;
                        end
                    catch
                        disp('')
                    end
                    try
                        string_to_compare = string(sliderList{item});
                        string_to_compare = string_to_compare{1};
                        if strcmp(string_to_compare,'Late')
                            disp('Late Found')
                            quizConfidences = [quizConfidences 9999];
                            statementspassed = statementspassed + 1;
                        end
                    catch
                        %disp(['Unable to resolve string, quiz ' num2str(item)])
                        disp('')
                    end
                    if statementspassed > 1
                        disp(['Found too many statements passed. ' num2str(statementspassed) ' passes found for run ' num2str(run), ', quiz ' num2str(item)])
                        disp(['Removing last item from lists. '])
                        quizConfidences = quizConfidences(1:length(quizConfidences)-1);
                        sliderSuccesses = sliderSuccesses(1:length(sliderSuccesses)-1);
                    end
                end
                
                multipleChoiceSuccesses = cell(size(sliderSuccesses));
                currentPosition = 1;
                for item = 1:length(multipleChoiceList)
                    if strcmp(string(multipleChoiceList{item}),"Y") || strcmp(string(multipleChoiceList{item}),"N")
                        multipleChoiceSuccesses{currentPosition} = string(multipleChoiceList{item});
                        currentPosition = currentPosition + 1;
                    end
                end

                sliderSuccessesAll = [sliderSuccessesAll sliderSuccesses];
                multipleChoiceSuccessesAll = [multipleChoiceSuccessesAll multipleChoiceSuccesses];
                disp(['Run ' num2str(run) ' had ' num2str(length(sliderList)) ' quizzes.'])
            else
                disp([sessionName ' run not found.'])
            end
        end
        
        


        sliderSuccessesAllPercentiles = sortrows([sliderSuccessesAll' (1:length(sliderSuccessesAll))' zeros(1,length(sliderSuccessesAll))' zeros(1,length(sliderSuccessesAll))']);
        
        for item = 1:length(sliderSuccessesAllPercentiles)
            yValue = rand/2;
            yValueRoll = rand;
            if yValueRoll <= 0.5
                yValue = -yValue;
            end
            percentileOfItem = sum(sliderSuccessesAllPercentiles(:,1) < sliderSuccessesAllPercentiles(item,1)) * 100 /(length(sliderSuccessesAll));
            sliderSuccessesAllPercentiles(item,3) = percentileOfItem;
            allPercentiles = [allPercentiles percentileOfItem];
            allSessions = [allSessions item];
            allSessionDays = [allSessionDays sessionDay];
            allResults = [allResults multipleChoiceSuccessesAll(sliderSuccessesAllPercentiles(item,2))];
            if strcmp(multipleChoiceSuccessesAll{sliderSuccessesAllPercentiles(item,2)},"Y")
               sliderSuccessesAllPercentiles(item,4) = 1;
               scatter(percentileOfItem,yValue,80,[0 0.5 0],'filled','MarkerFaceAlpha',.6)
            end
            if strcmp(multipleChoiceSuccessesAll{sliderSuccessesAllPercentiles(item,2)},"N")
               sliderSuccessesAllPercentiles(item,4) = 0;
               scatter(percentileOfItem,yValue,80,[1 0 0],'filled','MarkerFaceAlpha',.6)
            end
        end
        if ~isfile([psydatSaveDirectory sessionName '_sliders_and_percentiles.mat'])
            eval(['save ' psydatSaveDirectory sessionName '_sliders_and_percentiles.mat sliderSuccessesAllPercentiles'])
            eval(['save ' psydatSaveDirectory sessionName '_multiple_choice_successes.mat multipleChoiceSuccessesAll'])
        end
        %if ~isfile([psydatSaveDirectory sessionName '_python_timing_data.mat'])
            %eval(['save ' psydatSaveDirectory sessionName '_python_timing_data.mat runFirstTTLTime quizTimes quizAnswers quizConfidences runNumbers'])
        %end

    catch
        badSession = badSession + 1
        continue
    end
    
end

xlim([0 100])
ylim([-2 2])
line([25 25],[-2 2])
line([50 50],[-2 2])
line([75 75],[-2 2])
title(['All Subject Quiz Results, N = ' num2str(length(unique(text(1,:)))) ', n = ' num2str(length(allPercentiles))],'FontSize',24)
xlabel('Confidence Percentile','FontSize',24)
set(gca,'Yticklabel',[]) 
set(gca,'ytick',[]) 
set(gca,'FontSize',24)

%% Calculate relationships between confidence and accuracy

brackets = [0:5:100; zeros(1,21); zeros(1,21)];
for quiz = 1:length(allPercentiles)
    for bracket = 1:length(brackets)-1
        if allPercentiles(quiz) > brackets(1,bracket) && allPercentiles(quiz) <= brackets(1,bracket + 1)
            brackets(2,bracket) = brackets(2,bracket) + 1;
            if strcmp(allResults{quiz},"Y")
                brackets(3,bracket) = brackets(3,bracket) + 1;
            end
        end
    end
end
percentileBrackets = brackets(1,1:end-1)+2.5;
percentages = 100*(brackets(3,1:end-1)./brackets(2,1:end-1));

logreg = polyfit(log(percentileBrackets),log(percentages),1);
figure
hold on
grid on
scatter(percentileBrackets, percentages,80,'Filled')
plot(brackets(1,1:end),exp(logreg(1)*log(brackets(1,1:end)) + logreg(2)),'LineWidth',3)
ylim([0 100])
line([25 25],[0 100])
line([50 50],[0 100])
line([75 75],[0 100])
title('Confidence vs. Percent Correct')
xlabel('Confidence Percentile')
ylabel('Correct Percentage (%)')
set(gca,'FontSize',24)

%% Look for all validated results (i.e. aware and unaware)

validated_correct_top = 0;
all_top = 0;
validated_incorrect_bottom = 0;
all_bottom = 0;

for item = 1:length(allPercentiles)
    if strcmp(allResults{item},"Y") & allPercentiles(item) > 75
        validated_correct_top = validated_correct_top + 1;
        all_top = all_top + 1;
    end
    if strcmp(allResults{item},"N") & allPercentiles(item) > 75
        all_top = all_top + 1;
    end
    if strcmp(allResults{item},"Y") & allPercentiles(item) <= 25
        all_bottom = all_bottom + 1;
    end
    if strcmp(allResults{item},"N") & allPercentiles(item) <= 25
        validated_incorrect_bottom = validated_incorrect_bottom + 1;
        all_bottom = all_bottom + 1;
    end
end

disp(['Percentage of validated correct: ' num2str(validated_correct_top*100/all_top) '%'])
disp(['Percentage of validated incorrect: ' num2str(validated_incorrect_bottom*100/all_bottom) '%'])



%% Calculate values for differences between Day 2 and Day 3

correctBinRatesDay2 = nan(1,max(allSessions));
correctBinRatesDay3 = nan(1,max(allSessions));
nthbinDay2 = nan(1,max(allSessions));
nthbinDay3 = nan(1,max(allSessions));
percentilebinsDay2 = nan(1,max(allSessions));
percentilebinsDay3 = nan(1,max(allSessions));
for item = 1:max(allSessions)
    correctsDay2 = 0;
    incorrectsDay2 = 0;
    correctsDay3 = 0;
    incorrectsDay3 = 0;
    nthcountDay2 = 0;
    nthcountDay3 = 0;
    percentileDay2 = 0;
    percentileDay3 = 0;
    for result = 1:length(allResults)
        if allSessions(result) == item && allSessionDays(result) == 2 
            nthcountDay2 = nthcountDay2 + 1;
            percentileDay2 = percentileDay2 + allPercentiles(result);
            if strcmp(allResults{result},"N")
                incorrectsDay2 = incorrectsDay2 + 1;
            end
            if strcmp(allResults{result},"Y")
                correctsDay2 = correctsDay2 + 1;
            end
        end
        if allSessions(result) == item && allSessionDays(result) == 3 
            nthcountDay3 = nthcountDay3 + 1;
            percentileDay3 = percentileDay3 + allPercentiles(result);
            if strcmp(allResults{result},"N")
                incorrectsDay3 = incorrectsDay3 + 1;
            end
            if strcmp(allResults{result},"Y")
                correctsDay3 = correctsDay3 + 1;
            end
        end
    end
    correctBinRatesDay2(item) = correctsDay2 / (correctsDay2 + incorrectsDay2);
    correctBinRatesDay3(item) = correctsDay3 / (correctsDay3 + incorrectsDay3);
    nthbinDay2(item) = nthcountDay2;
    nthbinDay3(item) = nthcountDay3;
    percentilebinsDay2(item) = percentileDay2;
    percentilebinsDay3(item) = percentileDay3;
    
end

percentilebinsDay2 = percentileDay2 ./ nthbinDay2;
percentilebinsDay3 = percentileDay3 ./ nthbinDay3;
nthbinDay2prop = nthbinDay2 / max(nthbinDay2);
nthbinDay3prop = nthbinDay3 / max(nthbinDay3);

%% Plot figures for Day 2 and Day 3
figure;
hold on;
plot(correctBinRatesDay2,'LineWidth',3);
plot(correctBinRatesDay3,'LineWidth',3)
plot(nthbinDay2prop,'LineWidth',3);
plot(nthbinDay3prop,'LineWidth',3)
set(gca,'FontSize',24)
xlabel('N-th Quiz Shown')
ylabel('Correct Proportion')
legend({'Day 2','Day 3','Day 2 Distribution','Day 3 Distribution'})
yyaxis right
ylabel('Proportion of Participants Reaching Quiz Number')
