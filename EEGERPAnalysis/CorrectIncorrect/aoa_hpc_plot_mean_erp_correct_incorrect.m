%% Creates and saves mean ERP data for correctly and incorrectly identified actions.
allDirectories = dir('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Long_Epochs_For_Time_Frequency/');
allSubjectDirectories = [];
allSubjectNames = [];
allSubjectDays = [];
subject_names = [];
sessionDates = [];

sampling_rate = 1000;


for entry = 3:length(allDirectories)
    subject_name = allDirectories(entry).name;
    allSubdirectories = dir(['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Long_Epochs_For_Time_Frequency/' subject_name]);
    for subdirectory = 3:length(allSubdirectories)
        allSubjectDirectories = [allSubjectDirectories;{['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Long_Epochs_For_Time_Frequency/' subject_name '/' allSubdirectories(subdirectory).name]}];
        
        allSubjectNames = [allSubjectNames; {subject_name}];
        allSubjectDays = [allSubjectDays;{allSubdirectories(subdirectory).name}];
        folderContents = dir(['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Long_Epochs_For_Time_Frequency/' subject_name '/' allSubdirectories(subdirectory).name]);
        sessionDates = [sessionDates; {folderContents(3).name(1:8)}];
    end
end


%%

allSubjectERPs = [unique(allSubjectNames)'; cell(6,length(unique(allSubjectNames)))];
tic
for session = 1:length(allSubjectNames)
    
    disp(['Loading ' allSubjectNames{session} ', ' allSubjectDays{session}]);
    cd(allSubjectDirectories{session})
    %load([sessionDates{session} '_power_vectors_quizzes_then_choose_250_window_31_sliding.mat'],'correctTotals','incorrectTotals','mean_electrode_all_freq_zscore_correct','mean_electrode_all_freq_zscore_incorrect')
    load([sessionDates{session} '_mean_erps_correct_incorrect.mat'])
    for subject = 1:length(allSubjectERPs)
        if strcmp(allSubjectERPs{1,subject},allSubjectNames{session})
            allSubjectERPs{2,subject} = cat(3,allSubjectERPs{2,subject},mean_correct_erp);
            allSubjectERPs{3,subject} = cat(3,allSubjectERPs{3,subject},mean_incorrect_erp);
            allSubjectERPs{4,subject} = [allSubjectERPs{4,subject} correctTotals];
            allSubjectERPs{5,subject} = [allSubjectERPs{5,subject} incorrectTotals]; 
        end
    end
    toc
end

allSubjectERPs_temp = allSubjectERPs;
allSubjectERPs = [];
for subject = 1:size(allSubjectERPs_temp,2)
    %if sum(allSubjectERPs_temp{4,subject}) >= 12 && sum(allSubjectERPs_temp{5,subject}) >= 12
        allSubjectERPs = [allSubjectERPs allSubjectERPs_temp(:,subject)];
    %end
end

%%
allSubjectMeansCorrect = zeros([size(mean_correct_erp) length(allSubjectERPs)]);
allSubjectMeansIncorrect = zeros([size(mean_incorrect_erp) length(allSubjectERPs)]);

allSubjectMeansCorrectTwoSessionOnly = [];
allSubjectMeansIncorrectTwoSessionOnly = [];
for subject = 1:length(allSubjectERPs)
    disp(['Concatenating subject ' allSubjectERPs{1,subject}])
    if length(allSubjectERPs{4,subject}) == 2 & allSubjectERPs{4,subject}(1) > 0 & allSubjectERPs{4,subject}(2) > 0
        day2erp_correct = allSubjectERPs{2,subject}(:,:,1);
        day3erp_correct = allSubjectERPs{2,subject}(:,:,2);
        allSubjectMeansCorrect(:,:,subject) = (day2erp_correct*allSubjectERPs{4,subject}(1) + day3erp_correct*allSubjectERPs{4,subject}(2)) / sum(allSubjectERPs{4,subject});
        allSubjectMeansCorrectTwoSessionOnly = cat(4,allSubjectMeansCorrectTwoSessionOnly,(day2erp_correct*allSubjectERPs{4,subject}(1) + day3erp_correct*allSubjectERPs{4,subject}(2)) / sum(allSubjectERPs{4,subject}));
    elseif length(allSubjectERPs{4,subject}) == 1
        allSubjectMeansCorrect(:,:,subject) = allSubjectERPs{2,subject};
    end
    if length(allSubjectERPs{5,subject}) == 2 & allSubjectERPs{5,subject}(1) > 0 & allSubjectERPs{5,subject}(2) > 0
        day2erp_incorrect = allSubjectERPs{3,subject}(:,:,1);
        day3erp_incorrect = allSubjectERPs{3,subject}(:,:,2);
        allSubjectMeansIncorrect(:,:,subject) = (day2erp_incorrect*allSubjectERPs{5,subject}(1) + day3erp_incorrect*allSubjectERPs{5,subject}(2)) / sum(allSubjectERPs{5,subject});
        allSubjectMeansIncorrectTwoSessionOnly = cat(4,allSubjectMeansIncorrectTwoSessionOnly,(day2erp_incorrect*allSubjectERPs{5,subject}(1) + day3erp_incorrect*allSubjectERPs{5,subject}(2)) / sum(allSubjectERPs{5,subject}));
    elseif length(allSubjectERPs{4,subject}) == 1
        allSubjectMeansIncorrect(:,:,subject) = allSubjectERPs{3,subject};
    end
end


group_mean_correct_erp = mean(allSubjectMeansCorrect,3);
group_mean_incorrect_erp = mean(allSubjectMeansIncorrect,3);


%%

electrodeChannel = 183;

extralpfilt = true;

allAverageCorrectERP = zeros(1,6000);
allAverageIncorrectERP = zeros(1,6000);
allAverageCorrectERPs = [];
allAverageIncorrectERPs = [];

allAverageCorrectERPs = squeeze(allSubjectMeansCorrect(electrodeChannel,:,:))';
allAverageIncorrectERPs = squeeze(allSubjectMeansIncorrect(electrodeChannel,:,:))';

allAverageCorrectERP = mean(allAverageCorrectERPs);
allAverageIncorrectERP = mean(allAverageIncorrectERPs);

group_mean_correct_erp = allAverageCorrectERP;
group_mean_incorrect_erp = allAverageIncorrectERP;

correct_SEM = zeros(1,size(group_mean_correct_erp,2));
incorrect_SEM = zeros(1,size(group_mean_incorrect_erp,2));

for point = 1:length(group_mean_correct_erp)
    correct_SEM(point) = std(allAverageCorrectERPs(:,point))/ sqrt(size(allSubjectERPs,2));
    incorrect_SEM(point) = std(allAverageIncorrectERPs(:,point))/ sqrt(size(allSubjectERPs,2));
end

figure;
hold on

line([0 0],[-4 4])
line([-2000 2000],[0 0])

if ~extralpfilt
    lowpass_correct_high = lowpass(group_mean_correct_erp+correct_SEM,1,1000);
    lowpass_correct_low = lowpass(group_mean_correct_erp-correct_SEM,1,1000);
    lowpass_incorrect_high = lowpass(group_mean_incorrect_erp+incorrect_SEM,1,1000);
    lowpass_incorrect_low = lowpass(group_mean_incorrect_erp-incorrect_SEM,1,1000);
elseif extralpfilt

    lpFilt = designfilt('lowpassfir','PassbandFrequency',8, ...
    'StopbandFrequency',14,'PassbandRipple',1, ...
    'StopbandAttenuation',65,'DesignMethod','kaiserwin','SampleRate',1000);
    lowpass_correct_high = filtfilt(lpFilt,group_mean_correct_erp+correct_SEM);
    lowpass_correct_low = filtfilt(lpFilt,group_mean_correct_erp-correct_SEM);
    lowpass_incorrect_high = filtfilt(lpFilt,group_mean_incorrect_erp+incorrect_SEM);
    lowpass_incorrect_low = filtfilt(lpFilt,group_mean_incorrect_erp-incorrect_SEM);
end

erp_legend = [];
erp_legend = [erp_legend patch([-2999:3000 fliplr(-2999:3000)], [lowpass_correct_low fliplr(lowpass_correct_high)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')];
erp_legend = [erp_legend patch([-2999:3000 fliplr(-2999:3000)], [lowpass_incorrect_low fliplr(lowpass_incorrect_high)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')];





if ~extralpfilt

    plot([-2999:3000],lowpass(group_mean_correct_erp,1,1000),'Color',[0 0 1 0.7],'LineWidth',5)
    plot([-2999:3000],lowpass(group_mean_incorrect_erp,1,1000),'Color',[1 0.7 0 0.7],'LineWidth',5)
elseif extralpfilt
    plot([-2999:3000],filtfilt(lpFilt,group_mean_correct_erp),'Color',[0 0 1 0.7],'LineWidth',5)
    plot([-2999:3000],filtfilt(lpFilt,group_mean_incorrect_erp),'Color',[1 0.7 0 0.7],'LineWidth',5)
end



ylim([-4 4])
xlim([-1000 1000])

legend(erp_legend,'Correct','Incorrect')
title(['E' num2str(electrodeChannel) ', Mean ERP, Quiz Run Split, N = ' num2str(length(allSubjectERPs)) ])

xlabel('Time (ms)')
ylabel('Voltage (microvolts)')
set(gca,'FontSize',24)


%%
avg_erp_all_channels_correct_subjects = allSubjectMeansCorrect(:,1001:5000,:);
avg_erp_all_channels_incorrect_subjects = allSubjectMeansIncorrect(:,1001:5000,:);

creationFunction = 'aoa_hpc_plot_mean_erp_correct_incorrect.m'
save('/vast/palmer/pi/blumenfeld/dsj8/AoA_Study/aoa_group_erp_means_correct_incorrect.mat','avg_erp_all_channels_correct_subjects','avg_erp_all_channels_incorrect_subjects','allSubjectMeansCorrect','allSubjectMeansIncorrect','creationFunction')
