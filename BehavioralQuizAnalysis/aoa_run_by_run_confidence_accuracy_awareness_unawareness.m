%% This script aggregates run-by-run data for quiz confidence (percentile), accuracy (percent correct), awareness, and unawareness

clear all
close all
clc
%% Iterate over all sessions, sorting by individual subjects

location = 'l'


[num text raw] = xlsread([root '/AoA_All_Subjs_Data.xlsx']);


allICAs = [];
allDesignations = {};
allSubjectERPs = [unique(text(1,:)); cell(1,length(unique(text(1,:)))); cell(1,length(unique(text(1,:)))); cell(1,length(unique(text(1,:)))); cell(1,length(unique(text(1,:))))];
allSubjectRuns = [unique(text(1,:)); cell(1,length(unique(text(1,:)))); cell(1,length(unique(text(1,:)))); cell(1,length(unique(text(1,:)))); cell(1,length(unique(text(1,:)))); cell(1,length(unique(text(1,:)))); cell(1,length(unique(text(1,:)))); cell(1,length(unique(text(1,:)))); cell(1,length(unique(text(1,:)))); cell(1,length(unique(text(1,:)))); cell(1,length(unique(text(1,:)))); cell(1,length(unique(text(1,:)))); cell(1,length(unique(text(1,:)))); cell(1,length(unique(text(1,:)))); cell(1,length(unique(text(1,:)))); cell(1,length(unique(text(1,:)))); cell(1,length(unique(text(1,:)))); cell(1,length(unique(text(1,:))))];
load([root '/aoa_pupil_data_subjects_kept.mat'])
allRunsAllSubjects = [];
allSessionRunsConfidence = [];
allSessionRunsAccuracy = [];
allSessionRunsUnawareness = [];
allSessionRunsAwareness = [];
allSessionRunsDays = [];
allSessionRunsSubject = [];
for session = 1:length(text);
    
    allSessionRunsSubject = [allSessionRunsSubject; text(1,session)];
    fileLocation = [root '/' text{1,session} '/' text{2,session} '/'];
    disp(['Analyzing ' text{1,session} ])
    sessionDate = num2str(num(1,session));
    cd(fileLocation)
    load([fileLocation sessionDate '_sliders_and_percentiles_timing.mat'])
    sliderSuccessesAllPercentilesTiming = sliderSuccessesAllPercentilesTiming(sliderSuccessesAllPercentilesTiming(:,1) ~= 9999,:);
    session_unawarenesses = zeros(1,length(sliderSuccessesAllPercentilesTiming));
    for item = 1:length(session_unawarenesses)
        if sliderSuccessesAllPercentilesTiming(item,3) < 25 && sliderSuccessesAllPercentilesTiming(item,4) == 0
            session_unawarenesses(item) = 1;
        end
    end
    for item = 1:length(session_awarenesses)
        if sliderSuccessesAllPercentilesTiming(item,3) > 75 && sliderSuccessesAllPercentilesTiming(item,4) == 1
            session_awarenesses(item) = 1;
        end
    end
    allRunsAllSubjects = [allRunsAllSubjects; sliderSuccessesAllPercentilesTiming];
    currentSubjectRun1 = sliderSuccessesAllPercentilesTiming(sliderSuccessesAllPercentilesTiming(:,5) == 1,:);
    currentSubjectRun2 = sliderSuccessesAllPercentilesTiming(sliderSuccessesAllPercentilesTiming(:,5) == 2,:);
    currentSubjectRun3 = sliderSuccessesAllPercentilesTiming(sliderSuccessesAllPercentilesTiming(:,5) == 3,:);
    currentSubjectRun4 = sliderSuccessesAllPercentilesTiming(sliderSuccessesAllPercentilesTiming(:,5) == 4,:);
    currentSubjectRun5 = sliderSuccessesAllPercentilesTiming(sliderSuccessesAllPercentilesTiming(:,5) == 5,:);
    currentSubjectRun6 = sliderSuccessesAllPercentilesTiming(sliderSuccessesAllPercentilesTiming(:,5) == 6,:);
    currentSubjectUnawarenessesRun1 = session_unawarenesses(sliderSuccessesAllPercentilesTiming(:,5) == 1);
    currentSubjectUnawarenessesRun2 = session_unawarenesses(sliderSuccessesAllPercentilesTiming(:,5) == 2);
    currentSubjectUnawarenessesRun3 = session_unawarenesses(sliderSuccessesAllPercentilesTiming(:,5) == 3);
    currentSubjectUnawarenessesRun4 = session_unawarenesses(sliderSuccessesAllPercentilesTiming(:,5) == 4);
    currentSubjectUnawarenessesRun5 = session_unawarenesses(sliderSuccessesAllPercentilesTiming(:,5) == 5);
    currentSubjectUnawarenessesRun6 = session_unawarenesses(sliderSuccessesAllPercentilesTiming(:,5) == 6);

    currentSubjectAwarenessesRun1 = session_awarenesses(sliderSuccessesAllPercentilesTiming(:,5) == 1);
    currentSubjectAwarenessesRun2 = session_awarenesses(sliderSuccessesAllPercentilesTiming(:,5) == 2);
    currentSubjectAwarenessesRun3 = session_awarenesses(sliderSuccessesAllPercentilesTiming(:,5) == 3);
    currentSubjectAwarenessesRun4 = session_awarenesses(sliderSuccessesAllPercentilesTiming(:,5) == 4);
    currentSubjectAwarenessesRun5 = session_awarenesses(sliderSuccessesAllPercentilesTiming(:,5) == 5);
    currentSubjectAwarenessesRun6 = session_awarenesses(sliderSuccessesAllPercentilesTiming(:,5) == 6);
    currentSessionConfidence = [mean(currentSubjectRun1(:,3)) mean(currentSubjectRun2(:,3)) mean(currentSubjectRun3(:,3)) mean(currentSubjectRun4(:,3)) mean(currentSubjectRun5(:,3)) mean(currentSubjectRun6(:,3))];
    allSessionRunsConfidence = [allSessionRunsConfidence; currentSessionConfidence];    
    
    currentSessionAccuracy = [mean(currentSubjectRun1(:,4)) mean(currentSubjectRun2(:,4)) mean(currentSubjectRun3(:,4)) mean(currentSubjectRun4(:,4)) mean(currentSubjectRun5(:,4)) mean(currentSubjectRun6(:,4))];
    currentSessionAccuracy = currentSessionAccuracy * 100;
    allSessionRunsAccuracy = [allSessionRunsAccuracy; currentSessionAccuracy];
    currentSessionUnawareness = [mean(currentSubjectUnawarenessesRun1) mean(currentSubjectUnawarenessesRun2) mean(currentSubjectUnawarenessesRun3) mean(currentSubjectUnawarenessesRun4) mean(currentSubjectUnawarenessesRun5) mean(currentSubjectUnawarenessesRun6)];
    currentSessionUnawareness = currentSessionUnawareness * 100;
    allSessionRunsUnawareness = [allSessionRunsUnawareness; currentSessionUnawareness];
    currentSessionAwareness = [mean(currentSubjectAwarenessesRun1) mean(currentSubjectAwarenessesRun2) mean(currentSubjectAwarenessesRun3) mean(currentSubjectAwarenessesRun4) mean(currentSubjectAwarenessesRun5) mean(currentSubjectAwarenessesRun6)];
    currentSessionAwareness = currentSessionAwareness * 100;
    allSessionRunsAwareness = [allSessionRunsAwareness; currentSessionAwareness];
    allSessionRunsDays = [allSessionRunsDays; text(2,session)];
end

eval('allSessionRunAccuracyUnawarenessAwarenessConfidence.mat','allSessionRunsAwareness','allSessionRunsUnawareness','allSessionRunsConfidence','allSessionRunsAccuracy')
%% Calculate all run averages and plot

allRunsAllSubjectsNoLates = allRunsAllSubjects(allRunsAllSubjects(:,1) ~= 9999,:);


allRunsRun1 = allRunsAllSubjectsNoLates(allRunsAllSubjectsNoLates(:,5) == 1,:);
allRunsRun2 = allRunsAllSubjectsNoLates(allRunsAllSubjectsNoLates(:,5) == 2,:);
allRunsRun3 = allRunsAllSubjectsNoLates(allRunsAllSubjectsNoLates(:,5) == 3,:);
allRunsRun4 = allRunsAllSubjectsNoLates(allRunsAllSubjectsNoLates(:,5) == 4,:);
allRunsRun5 = allRunsAllSubjectsNoLates(allRunsAllSubjectsNoLates(:,5) == 5,:);
allRunsRun6 = allRunsAllSubjectsNoLates(allRunsAllSubjectsNoLates(:,5) == 6,:);


allRunsRun1Confidence = mean(allRunsRun1(:,3));
allRunsRun1SEMConfidence = std(allRunsRun1(:,3))/sqrt(length(allRunsRun1(:,3)));
allRunsRun2Confidence = mean(allRunsRun2(:,3));
allRunsRun2SEMConfidence = std(allRunsRun2(:,3))/sqrt(length(allRunsRun2(:,3)));
allRunsRun3Confidence = mean(allRunsRun3(:,3));
allRunsRun3SEMConfidence = std(allRunsRun3(:,3))/sqrt(length(allRunsRun3(:,3)));
allRunsRun4Confidence = mean(allRunsRun4(:,3));
allRunsRun4SEMConfidence = std(allRunsRun4(:,3))/sqrt(length(allRunsRun4(:,3)));
allRunsRun5Confidence = mean(allRunsRun5(:,3));
allRunsRun5SEMConfidence = std(allRunsRun5(:,3))/sqrt(length(allRunsRun5(:,3)));
allRunsRun6Confidence = mean(allRunsRun6(:,3));
allRunsRun6SEMConfidence = std(allRunsRun6(:,3))/sqrt(length(allRunsRun6(:,3)));
figure
%subplot(1,2,1)
hold on
bar(1:6,[allRunsRun1Confidence allRunsRun2Confidence allRunsRun3Confidence allRunsRun4Confidence allRunsRun5Confidence allRunsRun6Confidence])
errorbar([allRunsRun1Confidence allRunsRun2Confidence allRunsRun3Confidence allRunsRun4Confidence allRunsRun5Confidence allRunsRun6Confidence],[allRunsRun1SEMConfidence  allRunsRun2SEMConfidence allRunsRun3SEMConfidence allRunsRun4SEMConfidence allRunsRun5SEMConfidence allRunsRun6SEMConfidence],'linestyle','none','LineWidth',2)
set(gca,'FontSize',24)
xlabel('Run Number')
ylabel('Average Confidence Percentile')
ylim([0 100])
title('Quiz Confidence by Run')

allRunsRun1Accuracy = mean(allRunsRun1(:,4)*100);
allRunsRun1SEMAccuracy = std(allRunsRun1(:,4)*100)/sqrt(length(allRunsRun1(:,4)*100));
allRunsRun2Accuracy = mean(allRunsRun2(:,4)*100);
allRunsRun2SEMAccuracy = std(allRunsRun2(:,4)*100)/sqrt(length(allRunsRun2(:,4)*100));
allRunsRun3Accuracy = mean(allRunsRun3(:,4)*100);
allRunsRun3SEMAccuracy = std(allRunsRun3(:,4)*100)/sqrt(length(allRunsRun3(:,4)*100));
allRunsRun4Accuracy = mean(allRunsRun4(:,4)*100);
allRunsRun4SEMAccuracy = std(allRunsRun4(:,4)*100)/sqrt(length(allRunsRun4(:,4)*100));
allRunsRun5Accuracy = mean(allRunsRun5(:,4)*100);
allRunsRun5SEMAccuracy = std(allRunsRun5(:,4)*100)/sqrt(length(allRunsRun5(:,4)*100));
allRunsRun6Accuracy = mean(allRunsRun6(:,4)*100);
allRunsRun6SEMAccuracy = std(allRunsRun6(:,4)*100)/sqrt(length(allRunsRun6(:,4)*100));
%subplot(1,2,2)
figure
hold on
bar(1:6,[allRunsRun1Accuracy allRunsRun2Accuracy allRunsRun3Accuracy allRunsRun4Accuracy allRunsRun5Accuracy allRunsRun6Accuracy])
errorbar([allRunsRun1Accuracy allRunsRun2Accuracy allRunsRun3Accuracy allRunsRun4Accuracy allRunsRun5Accuracy allRunsRun6Accuracy],[allRunsRun1SEMAccuracy  allRunsRun2SEMAccuracy allRunsRun3SEMAccuracy allRunsRun4SEMAccuracy allRunsRun5SEMAccuracy allRunsRun6SEMAccuracy],'linestyle','none','LineWidth',2)
set(gca,'FontSize',24)
xlabel('Run Number')
ylabel('Quiz Correct %')
ylim([0 100])
title('Quiz Accuracy by Run')

%% Plot confidence as run-by-run change
changeFromRun1Confidence = [allRunsRun1Confidence allRunsRun2Confidence allRunsRun3Confidence allRunsRun4Confidence allRunsRun5Confidence allRunsRun6Confidence] %- allRunsRun1Confidence;

figure
hold on
plot(changeFromRun1Confidence,'LineWidth',3)
errorbar([changeFromRun1Confidence],[allRunsRun1SEMConfidence  allRunsRun2SEMConfidence allRunsRun3SEMAccuracy allRunsRun4SEMConfidence allRunsRun5SEMConfidence allRunsRun6SEMConfidence],'linestyle','none','LineWidth',2)
xlim([1 6])
ylim([45 55])
set(gca,'FontSize',24)
ax = gca;
ax.XTick = unique( round(ax.XTick) );
xlabel('Run Number')
title('Confidence Change from First Run (Percentile)')
ylabel('Percentile Change')

%% Plot accuracy as run-by-run change
changeFromRun1Accuracy = [allRunsRun1Accuracy allRunsRun2Accuracy allRunsRun3Accuracy allRunsRun4Accuracy allRunsRun5Accuracy allRunsRun6Accuracy] - allRunsRun1Accuracy;

figure
hold on
plot(changeFromRun1Accuracy,'LineWidth',3)
errorbar(changeFromRun1Accuracy,[allRunsRun1SEMAccuracy  allRunsRun2SEMAccuracy allRunsRun3SEMAccuracy allRunsRun4SEMAccuracy allRunsRun5SEMAccuracy allRunsRun6SEMAccuracy],'linestyle','none','LineWidth',2)
xlim([1 6])
set(gca,'FontSize',24)
ax = gca;
ax.XTick = unique( round(ax.XTick) );
xlabel('Run Number')
title('Accuracy Change from First Run')
ylabel('Percentage Change')

%% 

save(allAc)
