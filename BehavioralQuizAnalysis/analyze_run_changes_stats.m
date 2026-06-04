load('Y:\HNCT_AoA_Study\AoA_Subjects\allSessionRunAccuracyAwarenessConfidence.mat')
load('Y:\HNCT_AoA_Study\AoA_Subjects\allSessionRunAccuracyUnawarenessConfidence.mat')

% Example data with missing values
timepoints = {'Run 1', 'Run 2', 'Run 3', 'Run 4', 'Run 5', 'Run 6'};
std_calc_data = allSessionRunsUnawareness;
% for row = 1:length(allSessionRunsConfidence)
%     allSessionRunsConfidence(row,:) = allSessionRunsConfidence(row,:)-allSessionRunsConfidence(row,1);
% end
% for row = 1:length(allSessionRunsAccuracy)
%     allSessionRunsAccuracy(row,:) = allSessionRunsAccuracy(row,:)-allSessionRunsAccuracy(row,1);
% end
% for row = 1:length(allSessionRunsUnawareness)
%     allSessionRunsUnawareness(row,:) = allSessionRunsUnawareness(row,:)-allSessionRunsUnawareness(row,1);
% end
%%
types = {'Unawareness','Accuracy','Confidence','Awareness'};
ylabels = {'Percentage Point Change From Run 1','Percentage Point Change From Run 1','Percentile Point Change From Run 1','Percentage Point Change From Run 1'};

for day = 2:3
    for graph = 1:4
        if day == 2
            if graph == 1
                data = allSessionRunsUnawareness(strcmp(allSessionRunsDays,'Day2'),:);
            elseif graph == 2
                data = allSessionRunsAccuracy(strcmp(allSessionRunsDays,'Day2'),:);
            elseif graph == 3
                data = allSessionRunsConfidence(strcmp(allSessionRunsDays,'Day2'),:);
            elseif graph == 4
                data = allSessionRunsAwareness(strcmp(allSessionRunsDays,'Day2'),:);
            end
        elseif day == 3
            if graph == 1
                data = allSessionRunsUnawareness(strcmp(allSessionRunsDays,'Day3'),:);
            elseif graph == 2
                data = allSessionRunsAccuracy(strcmp(allSessionRunsDays,'Day3'),:);
            elseif graph == 3
                data = allSessionRunsConfidence(strcmp(allSessionRunsDays,'Day3'),:);
            elseif graph == 4
                data = allSessionRunsAwareness(strcmp(allSessionRunsDays,'Day3'),:);
            end
        end
        % Perform pairwise paired t-tests with pairwise complete case analysis
        p_values = nan(numel(timepoints), numel(timepoints));
        for i = 1:numel(timepoints)
            for j = 1:numel(timepoints)
                if i == j
                    continue;  % Skip if comparing the same timepoint
                end

                % Perform pairwise complete case analysis
                valid_indices = ~isnan(data(:, i)) & ~isnan(data(:, j));
                if any(valid_indices)
                    x = data(valid_indices, i);
                    y = data(valid_indices, j);
                    [~, p_values(i, j)] = ttest(x, y, 'Alpha', 0.05);
                else
                    p_values(i, j) = NaN;  % Assign NaN if no complete cases exist
                end
            end
        end

        % Apply Benjamini-Hochberg procedure to p-values
        p_values_vector = reshape(p_values, [], 1);
        valid_p_values = p_values_vector(~isnan(p_values_vector));  % Exclude NaN p-values
        adjusted_p_values = zeros(size(p_values));
        adjusted_p_values(~isnan(p_values)) = mafdr(valid_p_values, 'BHFDR', true);  % Apply Benjamini-Hochberg procedure

        % Display adjusted p-values
        fprintf('Pairwise paired t-test adjusted p-values (Benjamini-Hochberg procedure):\n');
        disp(adjusted_p_values);


        p_values_compared_to_run1 = mafdr( p_values(1,2:6), 'BHFDR', true);
        disp(['Adjusted p-values for run 1 tests only, ' types{graph} ])
        disp(p_values_compared_to_run1)
        
        
        dataNoNaN = data(valid_indices == 1,:);
        dataNoNaN = data;
        dataSEM1 = nanstd(std_calc_data(:,1))/sqrt(length(std_calc_data));
        dataSEM2 = nanstd(std_calc_data(:,2))/sqrt(length(std_calc_data));
        dataSEM3 = nanstd(std_calc_data(:,3))/sqrt(length(std_calc_data));
        dataSEM4 = nanstd(std_calc_data(:,4))/sqrt(length(std_calc_data));
        dataSEM5 = nanstd(std_calc_data(:,5))/sqrt(length(std_calc_data));
        dataSEM6 = nanstd(std_calc_data(:,6))/sqrt(length(std_calc_data));
        figure;
        hold on
        plot(nanmean(dataNoNaN),'LineWidth',3)
        errorbar(nanmean(dataNoNaN),[dataSEM1 dataSEM2 dataSEM3 dataSEM4 dataSEM5 dataSEM6],'linestyle','none','LineWidth',2)
        title(['Run ' types{graph} ' N = ' num2str(length(dataNoNaN)) ' Sessions, Day ' num2str(day)]);
        
        xlim([1 6])
        set(gca,'FontSize',24)
        ax = gca;
        ax.XTick = unique( round(ax.XTick) );
        xlabel('Run')
        ylabel('Percentage')
        if strcmp(types{graph},'Unawareness')
            ylim([10 25])
        elseif strcmp(types{graph},'Confidence')
            ylim([45 55])
        elseif strcmp(types{graph},'Accuracy')
            ylim([60 72])
        elseif strcmp(types{graph},'Awareness')
            ylim([10 30])
        end
    end
end

%%

allSubjectSessionWeighted = [unique(allSessionRunsSubject)'; cell(4,length(unique(allSessionRunsSubject)))];
for session = 1:length(allSessionRunsAccuracy)
    for subject = 1:length(allSubjectSessionWeighted)
        if strcmp(allSessionRunsSubject{session},allSubjectSessionWeighted{1,subject})
            allSubjectSessionWeighted{2,subject} = [allSubjectSessionWeighted{2,subject}; allSessionRunsAccuracy(session,:)];
            allSubjectSessionWeighted{3,subject} = [allSubjectSessionWeighted{3,subject}; allSessionRunsConfidence(session,:)];
            allSubjectSessionWeighted{4,subject} = [allSubjectSessionWeighted{4,subject}; allSessionRunsUnawareness(session,:)];
            allSubjectSessionWeighted{5,subject} = [allSubjectSessionWeighted{5,subject}; allSessionRunsAwareness(session,:)];
        end
    end
end

twoDayMeanAccuracy = [];
twoDayMeanConfidence = [];
twoDayMeanUnawareness = [];
twoDayMeanAwareness = [];
for subject = 1:length(allSubjectSessionWeighted)

    if size(allSubjectSessionWeighted{2,subject},1) == 2
        twoDayMeanAccuracy = [twoDayMeanAccuracy; mean(allSubjectSessionWeighted{2,subject})];
        twoDayMeanConfidence = [twoDayMeanConfidence; mean(allSubjectSessionWeighted{3,subject})];
        twoDayMeanUnawareness = [twoDayMeanUnawareness; mean(allSubjectSessionWeighted{4,subject})];
        twoDayMeanAwareness = [twoDayMeanAwareness; mean(allSubjectSessionWeighted{5,subject})];
    elseif size(allSubjectSessionWeighted{2,subject},1) == 1
        twoDayMeanAccuracy = [twoDayMeanAccuracy; allSubjectSessionWeighted{2,subject}];
        twoDayMeanConfidence = [twoDayMeanConfidence; allSubjectSessionWeighted{3,subject}];
        twoDayMeanUnawareness = [twoDayMeanUnawareness; allSubjectSessionWeighted{4,subject}];
        twoDayMeanAwareness = [twoDayMeanAwareness; allSubjectSessionWeighted{5,subject}];
    end
end

confidence_level = 0.95;


semRun1 = nanstd(twoDayMeanAccuracy(:,1))/sqrt(length(twoDayMeanAccuracy));
semRun2 = nanstd(twoDayMeanAccuracy(:,2))/sqrt(length(twoDayMeanAccuracy));
semRun3 = nanstd(twoDayMeanAccuracy(:,3))/sqrt(length(twoDayMeanAccuracy));
semRun4 = nanstd(twoDayMeanAccuracy(:,4))/sqrt(length(twoDayMeanAccuracy));
semRun5 = nanstd(twoDayMeanAccuracy(:,5))/sqrt(length(twoDayMeanAccuracy));
semRun6 = nanstd(twoDayMeanAccuracy(:,6))/sqrt(length(twoDayMeanAccuracy));
figure;
hold on;
plot(1:6,nanmean(twoDayMeanAccuracy),'LineWidth',3,'Color','blue')
errorbar(nanmean(twoDayMeanAccuracy),[semRun1 semRun2 semRun3 semRun4 semRun5 semRun6],'linestyle','none','LineWidth',3,'Color','red')
set(gca,'FontSize',24)
xlim([1 6])
ylim([60 72])
ax = gca;
ax.XTick = unique( round(ax.XTick) );
xlabel(['Run'])
ylabel('Correct Percentage')
title(['Subject Session Accuracy Averages, N = ' num2str(length(twoDayMeanAccuracy))])

semRun1 = nanstd(twoDayMeanConfidence(:,1))/sqrt(length(twoDayMeanConfidence));
semRun2 = nanstd(twoDayMeanConfidence(:,2))/sqrt(length(twoDayMeanConfidence));
semRun3 = nanstd(twoDayMeanConfidence(:,3))/sqrt(length(twoDayMeanConfidence));
semRun4 = nanstd(twoDayMeanConfidence(:,4))/sqrt(length(twoDayMeanConfidence));
semRun5 = nanstd(twoDayMeanConfidence(:,5))/sqrt(length(twoDayMeanConfidence));
semRun6 = nanstd(twoDayMeanConfidence(:,6))/sqrt(length(twoDayMeanConfidence));


critical_run1 = tinv((1+confidence_level)/2,sum(~isnan(twoDayMeanConfidence(:,1)))-1);
critical_run2 = tinv((1+confidence_level)/2,sum(~isnan(twoDayMeanConfidence(:,2)))-1);
critical_run3 = tinv((1+confidence_level)/2,sum(~isnan(twoDayMeanConfidence(:,3)))-1);
critical_run4 = tinv((1+confidence_level)/2,sum(~isnan(twoDayMeanConfidence(:,4)))-1);
critical_run5 = tinv((1+confidence_level)/2,sum(~isnan(twoDayMeanConfidence(:,5)))-1);
critical_run6 = tinv((1+confidence_level)/2,sum(~isnan(twoDayMeanConfidence(:,6)))-1);

ci95 = [critical_run1*semRun1 critical_run2*semRun2 critical_run3*semRun3 critical_run4*semRun4 critical_run5*semRun5 critical_run6*semRun6];

figure;
hold on;
plot(1:6,nanmean(twoDayMeanConfidence),'LineWidth',3,'Color','b')
% plot(1:6,nanmean(twoDayMeanConfidence)+ci95,'Color','b','LineStyle','--')
% plot(1:6,nanmean(twoDayMeanConfidence)-ci95,'Color','b','LineStyle','--')


% plot(1:6,nanmean(twoDayMeanConfidence)+[semRun1 semRun2 semRun3 semRun4 semRun5 semRun6],'Color','b','LineStyle','--')
% plot(1:6,nanmean(twoDayMeanConfidence)-[semRun1 semRun2 semRun3 semRun4 semRun5 semRun6],'Color','b','LineStyle','--')
errorbar(nanmean(twoDayMeanConfidence),[semRun1 semRun2 semRun3 semRun4 semRun5 semRun6],'linestyle','none','LineWidth',3,'Color','r')
scatter([4 5 6], [52 52 52],256,'*','black','LineWidth',3)
set(gca,'FontSize',24)
xlim([1 6])
ylim([45 55])
ax = gca;
ax.XTick = unique( round(ax.XTick) );
xlabel(['Run'])
ylabel('Confidence Percentile')
title(['Subject Session Confidence Averages, N = ' num2str(length(twoDayMeanConfidence))])

semRun1 = nanstd(twoDayMeanUnawareness(:,1))/sqrt(length(twoDayMeanUnawareness));
semRun2 = nanstd(twoDayMeanUnawareness(:,2))/sqrt(length(twoDayMeanUnawareness));
semRun3 = nanstd(twoDayMeanUnawareness(:,3))/sqrt(length(twoDayMeanUnawareness));
semRun4 = nanstd(twoDayMeanUnawareness(:,4))/sqrt(length(twoDayMeanUnawareness));
semRun5 = nanstd(twoDayMeanUnawareness(:,5))/sqrt(length(twoDayMeanUnawareness));
semRun6 = nanstd(twoDayMeanUnawareness(:,6))/sqrt(length(twoDayMeanUnawareness));
figure;
hold on;
plot(1:6,nanmean(twoDayMeanUnawareness),'LineWidth',3,'Color','b')
errorbar(nanmean(twoDayMeanUnawareness),[semRun1 semRun2 semRun3 semRun4 semRun5 semRun6],'linestyle','none','LineWidth',3,'Color','r')
scatter([5 6], [23 23],256,'*','black','LineWidth',3)
set(gca,'FontSize',24)
xlim([1 6])
ylim([10 25])
ax = gca;
ax.XTick = unique( round(ax.XTick) );
xlabel(['Run'])
ylabel('Unawareness Percentage')
title(['Subject Session Unawareness Averages, N = ' num2str(length(twoDayMeanUnawareness))])

semRun1 = nanstd(twoDayMeanAwareness(:,1))/sqrt(length(twoDayMeanAwareness));
semRun2 = nanstd(twoDayMeanAwareness(:,2))/sqrt(length(twoDayMeanAwareness));
semRun3 = nanstd(twoDayMeanAwareness(:,3))/sqrt(length(twoDayMeanAwareness));
semRun4 = nanstd(twoDayMeanAwareness(:,4))/sqrt(length(twoDayMeanAwareness));
semRun5 = nanstd(twoDayMeanAwareness(:,5))/sqrt(length(twoDayMeanAwareness));
semRun6 = nanstd(twoDayMeanAwareness(:,6))/sqrt(length(twoDayMeanAwareness));


critical_run1 = tinv((1+confidence_level)/2,sum(~isnan(twoDayMeanAwareness(:,1)))-1);
critical_run2 = tinv((1+confidence_level)/2,sum(~isnan(twoDayMeanAwareness(:,2)))-1);
critical_run3 = tinv((1+confidence_level)/2,sum(~isnan(twoDayMeanAwareness(:,3)))-1);
critical_run4 = tinv((1+confidence_level)/2,sum(~isnan(twoDayMeanAwareness(:,4)))-1);
critical_run5 = tinv((1+confidence_level)/2,sum(~isnan(twoDayMeanAwareness(:,5)))-1);
critical_run6 = tinv((1+confidence_level)/2,sum(~isnan(twoDayMeanAwareness(:,6)))-1);

ci95 = [critical_run1*semRun1 critical_run2*semRun2 critical_run3*semRun3 critical_run4*semRun4 critical_run5*semRun5 critical_run6*semRun6];

figure;
hold on;
plot(1:6,nanmean(twoDayMeanAwareness),'LineWidth',3,'Color','b')
% plot(1:6,nanmean(twoDayMeanAwareness)+ci95,'Color','b','LineStyle','--')
% plot(1:6,nanmean(twoDayMeanAwareness)-ci95,'Color','b','LineStyle','--')


% plot(1:6,nanmean(twoDayMeanAwareness)+[semRun1 semRun2 semRun3 semRun4 semRun5 semRun6],'Color','b','LineStyle','--')
% plot(1:6,nanmean(twoDayMeanAwareness)-[semRun1 semRun2 semRun3 semRun4 semRun5 semRun6],'Color','b','LineStyle','--')
errorbar(nanmean(twoDayMeanAwareness),[semRun1 semRun2 semRun3 semRun4 semRun5 semRun6],'linestyle','none','LineWidth',3,'Color','r')
set(gca,'FontSize',24)
xlim([1 6])
ylim([15 30])
scatter([2 4 6], [28 28 28],256,'*','black','LineWidth',3)
ax = gca;
ax.XTick = unique( round(ax.XTick) );
xlabel(['Run'])
ylabel('Awareness Percentage')
title(['Subject Session Awareness Averages, N = ' num2str(length(twoDayMeanAwareness))])

%%

pvalue_vector_awareness = []; 
pvalue_vector_awareness_signrank = [];
for test = 2:6
    [h,p] = ttest(twoDayMeanAwareness(:,1),twoDayMeanAwareness(:,test));
    pvalue_vector_awareness = [pvalue_vector_awareness p];
    p = signrank(twoDayMeanAwareness(:,1),twoDayMeanAwareness(:,test));
    pvalue_vector_awareness_signrank = [pvalue_vector_awareness_signrank p];
end

pvalues_to_run_1_awareness =  mafdr( pvalue_vector_unawareness, 'BHFDR', true)

pvalues_to_run_1_signrank_awareness =  mafdr( pvalue_vector_awareness_signrank, 'BHFDR', true)
%%

pvalue_vector_unawareness = []; 
pvalue_vector_unawareness_signrank = [];
for test = 2:6
    [h,p] = ttest(twoDayMeanUnawareness(:,1),twoDayMeanUnawareness(:,test));
    pvalue_vector_unawareness = [pvalue_vector_unawareness p];
    p = signrank(twoDayMeanUnawareness(:,1),twoDayMeanUnawareness(:,test));
    pvalue_vector_unawareness_signrank = [pvalue_vector_unawareness_signrank p];
end

pvalues_to_run_1 =  mafdr( pvalue_vector_unawareness, 'BHFDR', true)

pvalues_to_run_1_signrank =  mafdr( pvalue_vector_unawareness_signrank, 'BHFDR', true)

%%
pvalue_vector_confidence = []; 
pvalue_vector_unawareness_signrank = [];
for test = 2:6
    [h,p] = ttest(twoDayMeanConfidence(:,1),twoDayMeanConfidence(:,test));
    pvalue_vector_confidence = [pvalue_vector_confidence p];
    p = signrank(twoDayMeanConfidence(:,1),twoDayMeanConfidence(:,test));
    pvalue_vector_unawareness_signrank = [pvalue_vector_unawareness_signrank p];
end

pvalues_to_run_1_confidence =  mafdr( pvalue_vector_confidence, 'BHFDR', true)

pvalues_to_run_1_signrank_confidence =  mafdr( pvalue_vector_unawareness_signrank, 'BHFDR', true)

%%


pvalue_vector_accuracy = []; 
pvalue_vector_accuracy_signrank = [];
for test = 2:6
    [h,p] = ttest(twoDayMeanAccuracy(:,1),twoDayMeanAccuracy(:,test));
    pvalue_vector_accuracy = [pvalue_vector_accuracy p];
    p = signrank(twoDayMeanAccuracy(:,1),twoDayMeanAccuracy(:,test));
    pvalue_vector_accuracy_signrank = [pvalue_vector_accuracy_signrank p];
end

pvalues_to_run_1_accuracy =  mafdr( pvalue_vector_accuracy, 'BHFDR', true)

pvalues_to_run_1_signrank_accuracy =  mafdr( pvalue_vector_accuracy_signrank, 'BHFDR', true)


%%

allSessionRunPearsonsAccuracy = [];
for session = 1:128
    
    currentCoeff = corrcoef(1:6,allSessionRunsAccuracy(session,:));
    allSessionRunPearsonsAccuracy = [allSessionRunPearsonsAccuracy currentCoeff(2)];
end
figure
histogram(allSessionRunPearsonsAccuracy)
title('Accuracy')
xlabel('Pearson correlation coefficient')

allSessionRunPearsonsAwareness = [];
for session = 1:128
    
    currentCoeff = corrcoef(1:6,allSessionRunsAwareness(session,:));
    allSessionRunPearsonsAwareness = [allSessionRunPearsonsAwareness currentCoeff(2)];
end
figure
histogram(allSessionRunPearsonsAwareness)
title('Awareness')
xlabel('Pearson correlation coefficient')

allSessionRunPearsonsConfidence = [];
for session = 1:128
    
    currentCoeff = corrcoef(1:6,allSessionRunsConfidence(session,:));
    allSessionRunPearsonsConfidence = [allSessionRunPearsonsConfidence currentCoeff(2)];
end
figure
histogram(allSessionRunPearsonsConfidence)
title('Confidence')
xlabel('Pearson correlation coefficient')

allSessionRunPearsonsUnawareness = [];
for session = 1:128
    
    currentCoeff = corrcoef(1:6,allSessionRunsUnawareness(session,:));
    allSessionRunPearsonsUnawareness = [allSessionRunPearsonsUnawareness currentCoeff(2)];
end
figure
histogram(allSessionRunPearsonsUnawareness)
title('Unawareness')
xlabel('Pearson correlation coefficient')

%%
full_table = [];
for subject = 1:length(allSubjectSessionWeighted)
    currentSubjectUnawareness = twoDayMeanUnawareness(subject,:);
    currentSubjectAwareness = twoDayMeanAwareness(subject,:);
    currentSubjectConfidence = twoDayMeanConfidence(subject,:);
    currentSubjectAccuracy = twoDayMeanAccuracy(subject,:);
    for run = 1:6
        if ~isnan(twoDayMeanAccuracy(subject,run))
            currentRow = [twoDayMeanAccuracy(subject,run) twoDayMeanConfidence(subject,run) twoDayMeanAwareness(subject,run) twoDayMeanUnawareness(subject,run) run subject];

        end
        full_table = [full_table; currentRow];
    end
end

full_table = array2table(full_table);
full_table.Properties.VariableNames = {'Accuracy','Confidence','Awareness','Unawareness','Run','Subject'};


% % Convert 'subject' and 'run' to categorical if they are not already
% full_table.Subject = categorical(full_table.Subject);
% full_table.Run = categorical(full_table.Run);
% 
% % Fit the repeated measures model
% rm = fitrm(full_table, 'Unawareness ~ Run', 'WithinDesign', full_table.Run, 'WithinModel', 'Run');
% 
% % Run the repeated measures ANOVA
% ranovatbl = ranova(rm);
% 
% % Display the results
% disp(ranovatbl);


%%


dataTable = array2table(twoDayMeanUnawareness);
dataTable.Properties.VariableNames = {'Run_1','Run_2','Run_3','Run_4','Run_5','Run_6'};
rm = fitrm(dataTable,'Run_1-Run_6')
rm_coeffs_unawareness = rm.Coefficients;
ranovaResultsUnawareness = ranova(rm)



dataTable = array2table(twoDayMeanAwareness);
dataTable.Properties.VariableNames = {'Run_1','Run_2','Run_3','Run_4','Run_5','Run_6'};
rm = fitrm(dataTable,'Run_1-Run_6~1')
rm_coeffs_awareness = rm.Coefficients;
ranovaResultsAwareness = ranova(rm)


dataTable = array2table(twoDayMeanConfidence);
dataTable.Properties.VariableNames = {'Run_1','Run_2','Run_3','Run_4','Run_5','Run_6'};
rm = fitrm(dataTable,'Run_1-Run_6~1')
rm_coeffs_confidence = rm.Coefficients;
ranovaResultsConfidence = ranova(rm)




dataTable = array2table(twoDayMeanAccuracy);
dataTable.Properties.VariableNames = {'Run_1','Run_2','Run_3','Run_4','Run_5','Run_6'};
rm = fitrm(dataTable,'Run_1-Run_6~1')
rm_coeffs_accuracy = rm.Coefficients;
ranovaResultsAccuracy = ranova(rm)

%%

[RHO,PVAL] = corr([nanmean(twoDayMeanAccuracy(:,1)) nanmean(twoDayMeanAccuracy(:,2)) nanmean(twoDayMeanAccuracy(:,3)) nanmean(twoDayMeanAccuracy(:,4)) nanmean(twoDayMeanAccuracy(:,5)) nanmean(twoDayMeanAccuracy(:,6))]',[1 2 3 4 5 6]','Type','Spearman')
accuracyColumn = [nanmean(twoDayMeanAccuracy)'; RHO; PVAL];

[RHO,PVAL] = corr([nanmean(twoDayMeanConfidence(:,1)) nanmean(twoDayMeanConfidence(:,2)) nanmean(twoDayMeanConfidence(:,3)) nanmean(twoDayMeanConfidence(:,4)) nanmean(twoDayMeanConfidence(:,5)) nanmean(twoDayMeanConfidence(:,6))]',[1 2 3 4 5 6]','Type','Spearman')
confidenceColumn = [nanmean(twoDayMeanConfidence)'; RHO; PVAL];

[RHO,PVAL] = corr([nanmean(twoDayMeanAwareness(:,1)) nanmean(twoDayMeanAwareness(:,2)) nanmean(twoDayMeanAwareness(:,3)) nanmean(twoDayMeanAwareness(:,4)) nanmean(twoDayMeanAwareness(:,5)) nanmean(twoDayMeanAwareness(:,6))]',[1 2 3 4 5 6]','Type','Spearman')
awarenessColumn = [nanmean(twoDayMeanAwareness)'; RHO; PVAL];

[RHO,PVAL] = corr([nanmean(twoDayMeanUnawareness(:,1)) nanmean(twoDayMeanUnawareness(:,2)) nanmean(twoDayMeanUnawareness(:,3)) nanmean(twoDayMeanUnawareness(:,4)) nanmean(twoDayMeanUnawareness(:,5)) nanmean(twoDayMeanUnawareness(:,6))]',[1 2 3 4 5 6]','Type','Spearman')
unawarenessColumn = [nanmean(twoDayMeanUnawareness)'; RHO; PVAL];

master_column = round([accuracyColumn confidenceColumn awarenessColumn unawarenessColumn],2);

master_column = array2table(master_column);
master_column.Properties.VariableNames = {'Accuracy','Confidence','Awareness','Unawareness'}

% Assuming you have a table T
% Display table within a figure window
figure;
uitable('Data', master_column{:,:}, 'ColumnName', master_column.Properties.VariableNames,'RowName',{'Run 1','Run 2','Run 3','Run 4','Run 5','Run 6','ρ','p-value'}, 'Units', 'Normalized', 'Position', [0, 0, 1, 1]);
title('Table Visualization');
