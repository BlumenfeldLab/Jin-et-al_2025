clear all
clc


%% Calculates the delay (2-6s) between action and quiz and the ensuing awareness and unawareness rates ofthe quiz
creationFunction = 'aoa_plot_disappearance_aware_unaware.m'
location = 'l'

if strcmp(location,'s')

    root = '/mnt/Data27/HNCT_AoA_Study/AoA_Subjects/';
end
if strcmp(location,'l')
    root = 'Y:/HNCT_AoA_Study/AoA_Subjects/';
end

[num text raw] = xlsread([root '/AoA_ERP_Quizzes_Then_Choose.xlsx']);

disp('Loading data...')

tic
subject_sessions = [];
% Note: Subject 802 is not being included due to missing TTL flags. Iterate over all sessions, sorting by delay and by awareness outcome
for session = [1:length(text)];
    if strcmp(text{5,session},'Pupillometry')
        continue
    end
    subject_sessions = [subject_sessions text(1,session)];
    fileLocation = [root '/' text{1,session} '/' text{2,session} '/'];
    disp(['Analyzing ' text{1,session} ])
    sessionDate = num2str(num(1,session));
    cd(fileLocation)

    load([fileLocation sessionDate '_badConfirmTimes.mat'])
    load([fileLocation sessionDate '_goodConfirmTimes.mat'])
    load([fileLocation sessionDate '_event_times_and_types.mat'])
    load([fileLocation sessionDate '_confidenceDesignations_middles.mat'])



    Event_Times_array = cell2mat(Event_Times);


    allConfirmTimes = sort([badConfirmTimes goodConfirmTimes]);


    allConfirmTimes = sort([badConfirmTimes goodConfirmTimes]);
    aware_idx = [];
    unaware_idx = [];
    awareFirstBlockMoves = [];
    unawareFirstBlockMoves = [];
    quiz_idx = [];

    gap_2s = [];
    gap_3s = [];
    gap_4s = [];
    gap_5s = [];
    gap_6s = [];
    gap_7s = [];
    gap_8s = [];



    for quiz = 1:length(allConfirmTimes)
        trial = find(abs(Event_Times_array-allConfirmTimes(quiz)) == min(abs(Event_Times_array-allConfirmTimes(quiz))));
        trial = trial(1);
        quiz_idx = [quiz_idx trial];
    end

    quiz_gaps = [];
    
    for quiz = 1:length(quiz_idx)
        quiz_gaps = [quiz_gaps Event_Times_array(quiz_idx(quiz)+2)-Event_Times_array(quiz_idx(quiz))];
    end

    quiz_gaps = floor(quiz_gaps/1000);

    for quiz = 1:length(quiz_gaps)
        if quiz_gaps(quiz) == 2
            if strcmp(confidenceDesignations{quiz},'Aware') || strcmp(confidenceDesignations{quiz},'CH')
                gap_2s = [gap_2s 1];
            elseif strcmp(confidenceDesignations{quiz},'Unaware') || strcmp(confidenceDesignations{quiz},'IL')
                gap_2s = [gap_2s 2];
            elseif strcmp(confidenceDesignations{quiz},'Correct Mid High') || strcmp(confidenceDesignations{quiz},'Incorrect Mid High')
                gap_2s = [gap_2s 3];
            elseif strcmp(confidenceDesignations{quiz},'Correct Mid Low') || strcmp(confidenceDesignations{quiz},'Incorrect Mid Low')
                gap_2s = [gap_2s 4];
            elseif strcmp(confidenceDesignations{quiz},'Correct Low') || strcmp(confidenceDesignations{quiz},'Incorrect High')
                gap_2s = [gap_2s 5];
            end
        end
        if quiz_gaps(quiz) == 3
            if strcmp(confidenceDesignations{quiz},'Aware') || strcmp(confidenceDesignations{quiz},'CH')
                gap_3s = [gap_3s 1];
            elseif strcmp(confidenceDesignations{quiz},'Unaware') || strcmp(confidenceDesignations{quiz},'IL')
                gap_3s = [gap_3s 2];
            elseif strcmp(confidenceDesignations{quiz},'Correct Mid High') || strcmp(confidenceDesignations{quiz},'Incorrect Mid High')
                gap_3s = [gap_3s 3];
            elseif strcmp(confidenceDesignations{quiz},'Correct Mid Low') || strcmp(confidenceDesignations{quiz},'Incorrect Mid Low')
                gap_3s = [gap_3s 4];
            elseif strcmp(confidenceDesignations{quiz},'Correct Low') || strcmp(confidenceDesignations{quiz},'Incorrect High')
                gap_3s = [gap_3s 5];
            
            end
        end
        if quiz_gaps(quiz) == 4
            if strcmp(confidenceDesignations{quiz},'Aware') || strcmp(confidenceDesignations{quiz},'CH')
                gap_4s = [gap_4s 1];
            elseif strcmp(confidenceDesignations{quiz},'Unaware') || strcmp(confidenceDesignations{quiz},'IL')
                gap_4s = [gap_4s 2];
            elseif strcmp(confidenceDesignations{quiz},'Correct Mid High') || strcmp(confidenceDesignations{quiz},'Incorrect Mid High')
                gap_4s = [gap_4s 3];
            elseif strcmp(confidenceDesignations{quiz},'Correct Mid Low') || strcmp(confidenceDesignations{quiz},'Incorrect Mid Low')
                gap_4s = [gap_4s 4];
            elseif strcmp(confidenceDesignations{quiz},'Correct Low') || strcmp(confidenceDesignations{quiz},'Incorrect High')
                gap_4s = [gap_4s 5];
            
            end
        end
        if quiz_gaps(quiz) == 5
            if strcmp(confidenceDesignations{quiz},'Aware') || strcmp(confidenceDesignations{quiz},'CH')
                gap_5s = [gap_5s 1];
            elseif strcmp(confidenceDesignations{quiz},'Unaware') || strcmp(confidenceDesignations{quiz},'IL')
                gap_5s = [gap_5s 2];
            elseif strcmp(confidenceDesignations{quiz},'Correct Mid High') || strcmp(confidenceDesignations{quiz},'Incorrect Mid High')
                gap_5s = [gap_5s 3];
            elseif strcmp(confidenceDesignations{quiz},'Correct Mid Low') || strcmp(confidenceDesignations{quiz},'Incorrect Mid Low')
                gap_5s = [gap_5s 4];
            elseif strcmp(confidenceDesignations{quiz},'Correct Low') || strcmp(confidenceDesignations{quiz},'Incorrect High')
                gap_5s = [gap_5s 5];
            end
        end
        if quiz_gaps(quiz) == 6
            if strcmp(confidenceDesignations{quiz},'Aware') || strcmp(confidenceDesignations{quiz},'CH')
                gap_6s = [gap_6s 1];
            elseif strcmp(confidenceDesignations{quiz},'Unaware') || strcmp(confidenceDesignations{quiz},'IL')
                gap_6s = [gap_6s 2];
            elseif strcmp(confidenceDesignations{quiz},'Correct Mid High') || strcmp(confidenceDesignations{quiz},'Incorrect Mid High')
                gap_6s = [gap_6s 3];
            elseif strcmp(confidenceDesignations{quiz},'Correct Mid Low') || strcmp(confidenceDesignations{quiz},'Incorrect Mid Low')
                gap_6s = [gap_6s 4];
            elseif strcmp(confidenceDesignations{quiz},'Correct Low') || strcmp(confidenceDesignations{quiz},'Incorrect High')
                gap_6s = [gap_6s 5];
            
            end
        end
        if quiz_gaps(quiz) == 7
            if strcmp(confidenceDesignations{quiz},'Aware') || strcmp(confidenceDesignations{quiz},'CH')
                gap_7s = [gap_7s 1];
            elseif strcmp(confidenceDesignations{quiz},'Unaware') || strcmp(confidenceDesignations{quiz},'IL')
                gap_7s = [gap_7s 2];
            elseif strcmp(confidenceDesignations{quiz},'Correct Mid High') || strcmp(confidenceDesignations{quiz},'Incorrect Mid High')
                gap_7s = [gap_7s 3];
            elseif strcmp(confidenceDesignations{quiz},'Correct Mid Low') || strcmp(confidenceDesignations{quiz},'Incorrect Mid Low')
                gap_7s = [gap_7s 4];
            elseif strcmp(confidenceDesignations{quiz},'Correct Low') || strcmp(confidenceDesignations{quiz},'Incorrect High')
                gap_7s = [gap_7s 5];
            end
        end
        if quiz_gaps(quiz) == 8
            if strcmp(confidenceDesignations{quiz},'Aware') || strcmp(confidenceDesignations{quiz},'CH')
                gap_8s = [gap_8s 1];
            elseif strcmp(confidenceDesignations{quiz},'Unaware') || strcmp(confidenceDesignations{quiz},'IL')
                gap_8s = [gap_8s 2];
            elseif strcmp(confidenceDesignations{quiz},'Correct Mid High') || strcmp(confidenceDesignations{quiz},'Incorrect Mid High')
                gap_8s = [gap_8s 3];
            elseif strcmp(confidenceDesignations{quiz},'Correct Mid Low') || strcmp(confidenceDesignations{quiz},'Incorrect Mid Low')
                gap_8s = [gap_8s 4];
            elseif strcmp(confidenceDesignations{quiz},'Correct Low') || strcmp(confidenceDesignations{quiz},'Incorrect High')
                gap_8s = [gap_8s 5];
            end
        end
    end


    stack_2s = [sum(gap_2s == 5)/length(gap_2s) sum(gap_2s == 3)/length(gap_2s) sum(gap_2s == 4)/length(gap_2s) sum(gap_2s == 2)/length(gap_2s) sum(gap_2s == 1)/length(gap_2s)];

    stack_3s = [sum(gap_3s == 5)/length(gap_3s) sum(gap_3s == 3)/length(gap_3s) sum(gap_3s == 4)/length(gap_3s) sum(gap_3s == 2)/length(gap_3s) sum(gap_3s == 1)/length(gap_3s)];

    stack_4s = [sum(gap_4s == 5)/length(gap_4s) sum(gap_4s == 3)/length(gap_4s) sum(gap_4s == 4)/length(gap_4s) sum(gap_4s == 2)/length(gap_4s) sum(gap_4s == 1)/length(gap_4s)];


    stack_5s = [sum(gap_5s == 5)/length(gap_5s) sum(gap_5s == 3)/length(gap_5s) sum(gap_5s == 4)/length(gap_5s) sum(gap_5s == 2)/length(gap_5s) sum(gap_5s == 1)/length(gap_5s)];

    stack_6s = [sum(gap_6s == 5)/length(gap_6s) sum(gap_6s == 3)/length(gap_6s) sum(gap_6s == 4)/length(gap_6s) sum(gap_6s == 2)/length(gap_6s) sum(gap_6s == 1)/length(gap_6s)];

    stack_7s = [sum(gap_7s == 5)/length(gap_7s) sum(gap_7s == 3)/length(gap_7s) sum(gap_7s == 4)/length(gap_7s) sum(gap_7s == 2)/length(gap_7s) sum(gap_7s == 1)/length(gap_7s)];

    stack_8s = [sum(gap_8s == 5)/length(gap_8s) sum(gap_8s == 3)/length(gap_8s) sum(gap_8s == 4)/length(gap_8s) sum(gap_8s == 2)/length(gap_8s) sum(gap_8s == 1)/length(gap_8s)];
    save([sessionDate '_disappearance_awareness_rates.mat'], 'gap_2s', 'gap_3s', 'gap_4s', 'gap_5s', 'gap_6s', 'gap_7s', 'gap_8s', 'stack_2s', 'stack_3s', 'stack_4s', 'stack_5s', 'stack_6s', 'stack_7s', 'stack_8s','quiz_gaps','creationFunction')
    close all

    toc
end 

%%

list_of_findings = [unique(subject_sessions); cell(14,length(unique(subject_sessions)))];


% Remove columns corresponding to missing participant data
list_of_findings(:, any(strcmp(list_of_findings, '774VT'), 1)) = [];
list_of_findings(:, any(strcmp(list_of_findings, '778MS'), 1)) = [];
list_of_findings(:, any(strcmp(list_of_findings, '780PA'), 1)) = [];
list_of_findings(:, any(strcmp(list_of_findings, '783AS'), 1)) = [];
for session = 1:length(text);
    fileLocation = [root '/' text{1,session} '/' text{2,session} '/'];
    disp(['Loading ' text{1,session} ])
    sessionDate = num2str(num(1,session));
    cd(fileLocation)
    load([sessionDate '_disappearance_awareness_rates.mat'])
    for subject = 1:size(list_of_findings,2)
        if strcmp(list_of_findings{1,subject},text{1,session})
            for item = 2:8
                eval(['list_of_findings{' num2str(item) ',subject} = [list_of_findings{' num2str(item) ',subject} gap_' num2str(item) 's];']);
            end
            
        end
    end
end
        
    
all_2s_distributions = [];
all_3s_distributions = [];
all_4s_distributions = [];
all_5s_distributions = [];
all_6s_distributions = [];
all_7s_distributions = [];
all_8s_distributions = [];
for subject = 1:size(list_of_findings,2)      
    for row = 9:15
        eval(['list_of_findings{' num2str(row) ',subject} = [list_of_findings{' num2str(row) ',subject} sum(list_of_findings{' num2str(row-7) ',subject} == 5)/length(list_of_findings{' num2str(row-7) ',subject}) list_of_findings{' num2str(row) ',subject} sum(list_of_findings{' num2str(row-7) ',subject} == 3)/length(list_of_findings{' num2str(row-7) ',subject}) sum(list_of_findings{' num2str(row-7) ',subject} == 4)/length(list_of_findings{' num2str(row-7) ',subject}) sum(list_of_findings{' num2str(row-7) ',subject} == 2)/length(list_of_findings{' num2str(row-7) ',subject}) sum(list_of_findings{' num2str(row-7) ',subject} == 1)/length(list_of_findings{' num2str(row-7) ',subject})];']);
    end
    for item = 2:8
        eval(['all_' num2str(item) 's_distributions = [all_' num2str(item) 's_distributions; list_of_findings{' num2str(item+7) ',subject}];'])
    end
end

%% Plot stacked bar graphs for the five outcomes in each of the delays
figure;
hold on;
bar(2:8,[mean(all_2s_distributions); mean(all_3s_distributions); mean(all_4s_distributions); mean(all_5s_distributions); mean(all_6s_distributions); mean(all_7s_distributions); mean(all_8s_distributions)]*100,'stacked')
set(gca,'FontSize',24)
legend({'Unvalidated','Mid-Low','Mid-High','Unaware','Aware'})
ylim([0 100])
xlim([0 10])
set(gca,'XTickLabel',{'','','2','3','4','5','6','7','8','',''})
xlabel(['Time From Confirm to Quiz Appearance (s)'])
ylabel(['Total Percentage'])

%% Calculate correlations between awareness vs. delay and unawareness vs. delay

allSubjectCorrelationsAware = [];
allSubjectCorrelationsUnaware = [];
for subject = 1:length(all_2s_distributions)
    currentDistributionUnaware = [all_2s_distributions(subject,4) all_3s_distributions(subject,4) all_4s_distributions(subject,4) all_5s_distributions(subject,4) all_6s_distributions(subject,4) all_7s_distributions(subject,4) all_8s_distributions(subject,4)];
    [r_unaware,p_unaware] = corrcoef(2:8,currentDistributionUnaware);
    allSubjectCorrelationsUnaware = [allSubjectCorrelationsUnaware r_unaware(1,2)];
    currentDistributionAware = [all_2s_distributions(subject,5) all_3s_distributions(subject,5) all_4s_distributions(subject,5) all_5s_distributions(subject,5) all_6s_distributions(subject,5) all_7s_distributions(subject,5) all_8s_distributions(subject,5)];
    [r_aware,p_aware] = corrcoef(2:8,currentDistributionAware);
    allSubjectCorrelationsAware = [allSubjectCorrelationsAware r_aware(1,2)];

end
