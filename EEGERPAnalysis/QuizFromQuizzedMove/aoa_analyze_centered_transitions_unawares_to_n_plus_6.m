%% Analyzes the moves surrounding a quiz to determine whether they were unaware.
clear all

[num text raw] = xlsread('Y:\HNCT_AoA_Study\AoA_Subjects\AoA_All_Subjs_Data.xlsx');
root = 'Y:\HNCT_AoA_Study\AoA_Subjects\';
tic
all_unaware_sequences = [];
all_aware_sequences = [];
allSubjectSessions = [unique(text(1,:)); cell(1,length(unique(text(1,:)))); cell(1,length(unique(text(1,:))))];
creationFunction = 'aoa_analyze_centered_transitions_unawares_to_n_plus_6.m';

for session = 1:length(text)

    psydatSaveDirectory = [root '\' text{1,session} '\' text{2,session} '\']
    psydatFileDirectory = psydatSaveDirectory;
    sessionName = num2str(num(1,session));
    psydatSessionName = [psydatSaveDirectory sessionName '_sliders_and_percentiles_timing.mat'];
    cd(psydatSaveDirectory)
    load(psydatSessionName);
    if isfile([sessionName '_centered_transitions_awares.mat'])
        currentsession_unaware_sequences = [];
        currentsession_aware_sequences = [];
        for quiz = 1:6


            currentQuiz = [nan(1,7-quiz) zeros(1,13-length(nan(1,7-quiz)))];
            currentQuiz(7) = 1;
            
            if sliderSuccessesAllPercentilesTiming(quiz,3) < 25 && sliderSuccessesAllPercentilesTiming(quiz,4) == 0
                for remainingquiz = 1:13-min(find(~isnan(currentQuiz)))
                    if sliderSuccessesAllPercentilesTiming(remainingquiz,3) < 25 && sliderSuccessesAllPercentilesTiming(remainingquiz,4) == 0
                        currentQuiz(remainingquiz+min(find(~isnan(currentQuiz)))-1) = 1;
                    end
                end
                currentsession_unaware_sequences = [currentsession_unaware_sequences; currentQuiz];

            end
            

            currentQuiz = [nan(1,7-quiz) zeros(1,13-length(nan(1,7-quiz)))];
            currentQuiz(7) = 0;
            if sliderSuccessesAllPercentilesTiming(quiz,3) > 75 && sliderSuccessesAllPercentilesTiming(quiz,4) == 1
                
                for remainingquiz = 1:13-min(find(~isnan(currentQuiz)))
                    if sliderSuccessesAllPercentilesTiming(remainingquiz,3) < 25 && sliderSuccessesAllPercentilesTiming(remainingquiz,4) == 0
                        currentQuiz(remainingquiz+min(find(~isnan(currentQuiz)))-1) = 1;
                    end
                end
                currentsession_aware_sequences = [currentsession_aware_sequences; currentQuiz];

            end
            

        end

        %%
        for quiz = 7:length(sliderSuccessesAllPercentilesTiming)-6

            currentQuiz = zeros(1,13);
            currentQuiz(7) = 1;
            if sliderSuccessesAllPercentilesTiming(quiz,3) < 25 && sliderSuccessesAllPercentilesTiming(quiz,4) == 0
                if sliderSuccessesAllPercentilesTiming(quiz-6,3) < 25 && sliderSuccessesAllPercentilesTiming(quiz-6,4) == 0
                    currentQuiz(1) = 1;
                end
                if sliderSuccessesAllPercentilesTiming(quiz-5,3) < 25 && sliderSuccessesAllPercentilesTiming(quiz-5,4) == 0
                    currentQuiz(2) = 1;
                end
                if sliderSuccessesAllPercentilesTiming(quiz-4,3) < 25 && sliderSuccessesAllPercentilesTiming(quiz-4,4) == 0
                    currentQuiz(3) = 1;
                end
                if sliderSuccessesAllPercentilesTiming(quiz-3,3) < 25 && sliderSuccessesAllPercentilesTiming(quiz-3,4) == 0
                    currentQuiz(4) = 1;
                end
                if sliderSuccessesAllPercentilesTiming(quiz-2,3) < 25 && sliderSuccessesAllPercentilesTiming(quiz-2,4) == 0
                    currentQuiz(5) = 1;
                end
                if sliderSuccessesAllPercentilesTiming(quiz-1,3) < 25 && sliderSuccessesAllPercentilesTiming(quiz-1,4) == 0
                    currentQuiz(6) = 1;
                end
                if sliderSuccessesAllPercentilesTiming(quiz+1,3) < 25 && sliderSuccessesAllPercentilesTiming(quiz+1,4) == 0
                    currentQuiz(8) = 1;
                end
                if sliderSuccessesAllPercentilesTiming(quiz+2,3) < 25 && sliderSuccessesAllPercentilesTiming(quiz+2,4) == 0
                    currentQuiz(9) = 1;
                end
                if sliderSuccessesAllPercentilesTiming(quiz+3,3) < 25 && sliderSuccessesAllPercentilesTiming(quiz+3,4) == 0
                    currentQuiz(10) = 1;
                end
                if sliderSuccessesAllPercentilesTiming(quiz+4,3) < 25 && sliderSuccessesAllPercentilesTiming(quiz+4,4) == 0
                    currentQuiz(11) = 1;
                end
                if sliderSuccessesAllPercentilesTiming(quiz+5,3) < 25 && sliderSuccessesAllPercentilesTiming(quiz+5,4) == 0
                    currentQuiz(12) = 1;
                end
                if sliderSuccessesAllPercentilesTiming(quiz+6,3) < 25 && sliderSuccessesAllPercentilesTiming(quiz+6,4) == 0
                    currentQuiz(13) = 1;
                end
                currentsession_unaware_sequences = [currentsession_unaware_sequences; currentQuiz];
            end
        end
        for quiz = 7:length(sliderSuccessesAllPercentilesTiming)-6

            currentQuiz = zeros(1,13);
            currentQuiz(7) = 0;
            if sliderSuccessesAllPercentilesTiming(quiz,3) > 75 && sliderSuccessesAllPercentilesTiming(quiz,4) == 1
                if sliderSuccessesAllPercentilesTiming(quiz-6,3) < 25 && sliderSuccessesAllPercentilesTiming(quiz-6,4) == 0
                    currentQuiz(1) = 1;
                end
                if sliderSuccessesAllPercentilesTiming(quiz-5,3) < 25 && sliderSuccessesAllPercentilesTiming(quiz-5,4) == 0
                    currentQuiz(2) = 1;
                end
                if sliderSuccessesAllPercentilesTiming(quiz-4,3) < 25 && sliderSuccessesAllPercentilesTiming(quiz-4,4) == 0
                    currentQuiz(3) = 1;
                end
                if sliderSuccessesAllPercentilesTiming(quiz-3,3) < 25 && sliderSuccessesAllPercentilesTiming(quiz-3,4) == 0
                    currentQuiz(4) = 1;
                end
                if sliderSuccessesAllPercentilesTiming(quiz-2,3) < 25 && sliderSuccessesAllPercentilesTiming(quiz-2,4) == 0
                    currentQuiz(5) = 1;
                end
                if sliderSuccessesAllPercentilesTiming(quiz-1,3) < 25 && sliderSuccessesAllPercentilesTiming(quiz-1,4) == 0
                    currentQuiz(6) = 1;
                end
                if sliderSuccessesAllPercentilesTiming(quiz+1,3) < 25 && sliderSuccessesAllPercentilesTiming(quiz+1,4) == 0
                    currentQuiz(8) = 1;
                end
                if sliderSuccessesAllPercentilesTiming(quiz+2,3) < 25 && sliderSuccessesAllPercentilesTiming(quiz+2,4) == 0
                    currentQuiz(9) = 1;
                end
                if sliderSuccessesAllPercentilesTiming(quiz+3,3) < 25 && sliderSuccessesAllPercentilesTiming(quiz+3,4) == 0
                    currentQuiz(10) = 1;
                end
                if sliderSuccessesAllPercentilesTiming(quiz+4,3) < 25 && sliderSuccessesAllPercentilesTiming(quiz+4,4) == 0
                    currentQuiz(11) = 1;
                end
                if sliderSuccessesAllPercentilesTiming(quiz+5,3) < 25 && sliderSuccessesAllPercentilesTiming(quiz+5,4) == 0
                    currentQuiz(12) = 1;
                end
                if sliderSuccessesAllPercentilesTiming(quiz+6,3) < 25 && sliderSuccessesAllPercentilesTiming(quiz+6,4) == 0
                    currentQuiz(13) = 1;
                end
                currentsession_aware_sequences = [currentsession_aware_sequences; currentQuiz];
            end
        end
        final_indices = [length(sliderSuccessesAllPercentilesTiming)-5:length(sliderSuccessesAllPercentilesTiming)];
        for quiz = length(sliderSuccessesAllPercentilesTiming)-5:length(sliderSuccessesAllPercentilesTiming)
            
            currentQuiz = [zeros(1,13-find(final_indices==quiz)) nan(1,find(final_indices==quiz))];
            currentQuiz(7) = 1;
            remaining_indices = quiz-6:length(sliderSuccessesAllPercentilesTiming);
            if sliderSuccessesAllPercentilesTiming(quiz,3) < 25 && sliderSuccessesAllPercentilesTiming(quiz,4) == 0
                for remainingquiz = 1:length(remaining_indices)
                    if sliderSuccessesAllPercentilesTiming(remaining_indices(remainingquiz),3) < 25 && sliderSuccessesAllPercentilesTiming(remaining_indices(remainingquiz),4) == 0
                        currentQuiz(remainingquiz) = 1;
                    end
                end
                currentsession_unaware_sequences = [currentsession_unaware_sequences; currentQuiz];

            end


            

            currentQuiz = [zeros(1,13-find(final_indices==quiz)) nan(1,find(final_indices==quiz))];
            currentQuiz(7) = 0;
            if sliderSuccessesAllPercentilesTiming(quiz,3) > 75 && sliderSuccessesAllPercentilesTiming(quiz,4) == 1
                
                for remainingquiz = 1:length(remaining_indices)
                    if sliderSuccessesAllPercentilesTiming(remaining_indices(remainingquiz),3) < 25 && sliderSuccessesAllPercentilesTiming(remaining_indices(remainingquiz),4) == 0
                        currentQuiz(remainingquiz) = 1;
                    end
                end
                currentsession_aware_sequences = [currentsession_aware_sequences; currentQuiz];

            end
        end
        creationDate = char(datetime('now'));
        save([sessionName '_centered_transitions_unawares.mat'],'currentsession_aware_sequences','currentsession_unaware_sequences','creationFunction','creationDate')


    end
    all_aware_sequences = [all_aware_sequences; currentsession_aware_sequences];
    all_unaware_sequences = [all_unaware_sequences; currentsession_unaware_sequences];
    load([sessionName '_centered_transitions_unawares.mat'])
    for subject = 1:length(allSubjectSessions)
        if strcmp(allSubjectSessions{1,subject},text{1,session})
            allSubjectSessions{2,subject} = [allSubjectSessions{2,subject}; currentsession_unaware_sequences];
            allSubjectSessions{3,subject} = [allSubjectSessions{3,subject}; currentsession_aware_sequences];
        end
    end


end

%%
figure;
hold on;
sem_aware_upper = nanmean(all_aware_sequences)*100 + nanstd(all_aware_sequences*100)/sqrt(length(all_aware_sequences));
sem_aware_lower = nanmean(all_aware_sequences)*100 - nanstd(all_aware_sequences*100)/sqrt(length(all_aware_sequences));


sem_unaware_upper = nanmean(all_unaware_sequences)*100 + nanstd(all_unaware_sequences*100)/sqrt(length(all_unaware_sequences));
sem_unaware_lower = nanmean(all_unaware_sequences)*100 - nanstd(all_unaware_sequences*100)/sqrt(length(all_unaware_sequences));

% subplot(1,2,1)
hold on
title('Unawareness Rates')
plot(-6:6,nanmean(all_aware_sequences)*100,'LineWidth',2,'Color','blue')
plot(-6:6,nanmean(all_unaware_sequences)*100,'LineWidth',2,'Color','red')
plot(-6:6,sem_aware_upper,'--','LineWidth',1,'Color','blue')
plot(-6:6,sem_aware_lower,'--','LineWidth',1,'Color','blue')

plot(-6:6,sem_unaware_upper,'--','LineWidth',1,'Color','red')
plot(-6:6,sem_unaware_lower,'--','LineWidth',1,'Color','red')

ylabel('Unawareness %')
set(gca,'FontSize',24)
ylim([0 100])
xlim([-6 6])
legend({['Aware, n = ' num2str(length(all_aware_sequences))],['Unaware, n = ' num2str(length(all_unaware_sequences))]})
xlabel('Quiz From Current Quiz')
% subplot(1,2,2)
%
% hold on
% title('Unaware')
% plot(-2:2,mean(all_unaware_sequences)*100,'LineWidth',2)
% ylabel('Unawareness %')
% set(gca,'FontSize',24)
% ylim([0 100])

%%

all_subject_mean_aware = [];
all_subject_mean_unaware = [];

for subject = 1:length(allSubjectSessions)
    all_subject_mean_unaware = [all_subject_mean_unaware; nanmean(allSubjectSessions{2,subject})];
    all_subject_mean_aware = [all_subject_mean_aware; nanmean(allSubjectSessions{3,subject})];
end

figure;
hold on;
sem_aware_upper = nanmean(all_subject_mean_aware)*100 + nanstd(all_subject_mean_aware*100)/sqrt(length(all_subject_mean_aware));
sem_aware_lower = nanmean(all_subject_mean_aware)*100 - nanstd(all_subject_mean_aware*100)/sqrt(length(all_subject_mean_aware));

sem_unaware_upper = nanmean(all_subject_mean_unaware)*100 + nanstd(all_subject_mean_unaware*100)/sqrt(length(all_subject_mean_unaware));
sem_unaware_lower = nanmean(all_subject_mean_unaware)*100 - nanstd(all_subject_mean_unaware*100)/sqrt(length(all_subject_mean_unaware));

hold on
title(['Unawareness Rates, N = ' num2str(length(all_subject_mean_aware))])
plot(-6:6,nanmean(all_subject_mean_aware)*100,'LineWidth',2,'Color','blue')
plot(-6:6,nanmean(all_subject_mean_unaware)*100,'LineWidth',2,'Color','red')
plot(-6:6,sem_aware_upper,'--','LineWidth',1,'Color','blue')
plot(-6:6,sem_aware_lower,'--','LineWidth',1,'Color','blue')

plot(-6:6,sem_unaware_upper,'--','LineWidth',1,'Color','red')
plot(-6:6,sem_unaware_lower,'--','LineWidth',1,'Color','red')

ylabel('Unawareness %')
set(gca,'FontSize',24)
ylim([0 100])
xlim([-6 6])
legend({['Aware'],['Unaware']})
xlabel('Quiz From Current Quiz')

%%
all_subject_mean_aware = all_subject_mean_aware(:,[1:6 8:13])
all_subject_mean_unaware = all_subject_mean_unaware(:,[1:6 8:13])
ttests_for_correction = [];
for item = 1:12
    [h,p] = ttest(all_subject_mean_aware(:,item),all_subject_mean_unaware(:,item));
    ttests_for_correction = [ttests_for_correction p];
end

pvalues_corrected =  mafdr( ttests_for_correction, 'BHFDR', true)

