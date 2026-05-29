clear all
clc

%% This script performs the behavioral analysis, determining whether actions were aware or unaware.
psydatSaveDirectory = 'Y:\HNCT_AoA_Study\AoA_Subjects\827\Day2\';
cd(psydatSaveDirectory)
psydatFileDirectory = psydatSaveDirectory;
psydatSessionName = '999999999999_2';
subject = '1';
sessionDay = ['Day ' psydatSessionName(end)];

sliderSuccessesAll = [];
multipleChoiceSuccessesAll = [];
runLengths = [];

%% Iterate over run and read in .psydat files
for run = 1:6
    psydatFileName = [psydatFileDirectory psydatSessionName '_run' num2str(run) '.psydat'];
    sliderList = py.list(py.pickle.load(py.open(psydatFileName,'rb')).entries{3}{'Slider Positions'}.values());
    multipleChoiceList = py.list(py.pickle.load(py.open(psydatFileName,'rb')).entries{2}{'Multiple Choice Answers'}.values());
    sliderSuccesses = [];
    for item = 1:length(sliderList) 
        if isnumeric(sliderList{item})  & sliderList{item} ~= 0
            sliderSuccesses = [sliderSuccesses sliderList{item}];
        end
        try 
            if double(sliderList{item}) == 0
                sliderSuccesses = [sliderSuccesses double(sliderList{item})];
            end
        catch
            
            continue
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
    disp(['Run ' num2str(run) ' had ' num2str(length(multipleChoiceSuccesses)) ' non-late quizzes.'])
    runLengths = [runLengths; length(multipleChoiceSuccesses)];
end



%% Convert raw position to percentile
awareCount = 0;
unawareCount = 0;
figure
hold on
boxplot((sliderSuccessesAll+450)/9,'Orientation','Horizontal')
yVals = ones(1,length(multipleChoiceSuccessesAll));
for item = 1:length(yVals)
    yVals(item) = yVals(item) + randi([-3, 3]) / 100;
end
confidenceDesignations = cell(size(multipleChoiceSuccessesAll));
for item = 1:length(multipleChoiceSuccessesAll)
    if strcmp(multipleChoiceSuccessesAll{item},"Y")
        if sliderSuccessesAll(item) > quantile(sliderSuccessesAll,0.75)
            confidenceDesignations{item} = 'Aware';
            awareCount = awareCount + 1;
        end
        if sliderSuccessesAll(item) > quantile(sliderSuccessesAll,0.25) - 1.5*iqr(sliderSuccessesAll) && sliderSuccessesAll(item) < quantile(sliderSuccessesAll,0.75) + 1.5*iqr(sliderSuccessesAll)
            scatter((sliderSuccessesAll(item)+450)/9,yVals(item),50,[0 0.5 0],'filled')
        end
        if sliderSuccessesAll(item) < quantile(sliderSuccessesAll,0.25) - 1.5*iqr(sliderSuccessesAll) || sliderSuccessesAll(item) > quantile(sliderSuccessesAll,0.75) + 1.5*iqr(sliderSuccessesAll)
            scatter((sliderSuccessesAll(item)+450)/9,1,50,[0 0.5 0],'filled')
        end
    end
    if strcmp(multipleChoiceSuccessesAll{item},"N")
        if sliderSuccessesAll(item) < quantile(sliderSuccessesAll,0.25)
            confidenceDesignations{item} = 'Unaware';
            unawareCount = unawareCount + 1;
        end
        if sliderSuccessesAll(item) > quantile(sliderSuccessesAll,0.25) - 1.5*iqr(sliderSuccessesAll) && sliderSuccessesAll(item) < quantile(sliderSuccessesAll,0.75) + 1.5*iqr(sliderSuccessesAll)
            scatter((sliderSuccessesAll(item)+450)/9,yVals(item),50,[1 0 0],'filled')
        end
        if sliderSuccessesAll(item) < quantile(sliderSuccessesAll,0.25) - 1.5*iqr(sliderSuccessesAll) || sliderSuccessesAll(item) > quantile(sliderSuccessesAll,0.75) + 1.5*iqr(sliderSuccessesAll)
            scatter((sliderSuccessesAll(item)+450)/9,1,50,[1 0 0],'filled')
        end
    end
end
set(gca,'Yticklabel',[]) 
set(gca,'FontSize',16)
% title([subject ' ' sessionDay])
xlim([0 100])
xlabel('Confidence Percentage (%)')

%% Save All Designations
eval(['save ' psydatSaveDirectory psydatSessionName(1:12) '_designations.mat confidenceDesignations -v7.3'])

%%  Save Individual Runs
currentRunSum = 0;
confidenceDesignations_run1 = confidenceDesignations(currentRunSum+1:currentRunSum+runLengths(1));
currentRunSum = currentRunSum + runLengths(1)
eval(['save ' psydatSaveDirectory psydatSessionName(1:12) '_run1_designations.mat confidenceDesignations_run1 -v7.3'])

confidenceDesignations_run2 = confidenceDesignations(currentRunSum+1:currentRunSum+runLengths(2));
currentRunSum = currentRunSum + runLengths(2)
eval(['save ' psydatSaveDirectory psydatSessionName(1:12) '_run2_designations.mat confidenceDesignations_run2 -v7.3'])

confidenceDesignations_run3 = confidenceDesignations(currentRunSum+1:currentRunSum+runLengths(3));
currentRunSum = currentRunSum + runLengths(3)
eval(['save ' psydatSaveDirectory psydatSessionName(1:12) '_run3_designations.mat confidenceDesignations_run3 -v7.3'])

confidenceDesignations_run4 = confidenceDesignations(currentRunSum+1:currentRunSum+runLengths(4));
currentRunSum = currentRunSum + runLengths(4)
eval(['save ' psydatSaveDirectory psydatSessionName(1:12) '_run4_designations.mat confidenceDesignations_run4 -v7.3'])

confidenceDesignations_run5 = confidenceDesignations(currentRunSum+1:currentRunSum+runLengths(5));
currentRunSum = currentRunSum + runLengths(5)
eval(['save ' psydatSaveDirectory psydatSessionName(1:12) '_run5_designations.mat confidenceDesignations_run5 -v7.3'])

confidenceDesignations_run6 = confidenceDesignations(currentRunSum+1:currentRunSum+runLengths(6));
currentRunSum = currentRunSum + runLengths(6)
eval(['save ' psydatSaveDirectory psydatSessionName(1:12) '_run6_designations.mat confidenceDesignations_run6 -v7.3'])
