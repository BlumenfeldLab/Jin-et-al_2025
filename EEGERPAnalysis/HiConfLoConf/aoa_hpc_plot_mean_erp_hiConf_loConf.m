%% Plots group means for high-confidence and low-confidence actions
allDirectories = dir('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Long_Epochs_For_Time_Frequency/');
allSubjectDirectories = [];
allSubjectNames = [];
allSubjectDays = [];
subject_names = [];
sessionDates = [];
window_size_factor = 4;
sliding_window_factor = 8;
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
    %load([sessionDates{session} '_power_vectors_quizzes_then_choose_250_window_31_sliding.mat'],'hiConfTotals','loConfTotals','mean_electrode_all_freq_zscore_hiConf','mean_electrode_all_freq_zscore_loConf')
    load([sessionDates{session} '_mean_erps_hiConf_loConf.mat'])
    for subject = 1:length(allSubjectERPs)
        if strcmp(allSubjectERPs{1,subject},allSubjectNames{session})
            allSubjectERPs{2,subject} = cat(3,allSubjectERPs{2,subject},mean_hiConf_erp);
            allSubjectERPs{3,subject} = cat(3,allSubjectERPs{3,subject},mean_loConf_erp);
            allSubjectERPs{4,subject} = [allSubjectERPs{4,subject} hiConfTotals];
            allSubjectERPs{5,subject} = [allSubjectERPs{5,subject} loConfTotals]; 
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
allSubjectMeansHiConf = zeros([size(mean_hiConf_erp) length(allSubjectERPs)]);
allSubjectMeansLoConf = zeros([size(mean_loConf_erp) length(allSubjectERPs)]);

allSubjectMeansHiConfTwoSessionOnly = [];
allSubjectMeansLoConfTwoSessionOnly = [];
for subject = 1:length(allSubjectERPs)
    disp(['Concatenating subject ' allSubjectERPs{1,subject}])
    if length(allSubjectERPs{4,subject}) == 2 & allSubjectERPs{4,subject}(1) > 0 & allSubjectERPs{4,subject}(2) > 0
        day2erp_hiConf = allSubjectERPs{2,subject}(:,:,1);
        day3erp_hiConf = allSubjectERPs{2,subject}(:,:,2);
        allSubjectMeansHiConf(:,:,subject) = (day2erp_hiConf*allSubjectERPs{4,subject}(1) + day3erp_hiConf*allSubjectERPs{4,subject}(2)) / sum(allSubjectERPs{4,subject});
        allSubjectMeansHiConfTwoSessionOnly = cat(4,allSubjectMeansHiConfTwoSessionOnly,(day2erp_hiConf*allSubjectERPs{4,subject}(1) + day3erp_hiConf*allSubjectERPs{4,subject}(2)) / sum(allSubjectERPs{4,subject}));
    elseif length(allSubjectERPs{4,subject}) == 1
        allSubjectMeansHiConf(:,:,subject) = allSubjectERPs{2,subject};
    end
    if length(allSubjectERPs{5,subject}) == 2 & allSubjectERPs{5,subject}(1) > 0 & allSubjectERPs{5,subject}(2) > 0
        day2erp_loConf = allSubjectERPs{3,subject}(:,:,1);
        day3erp_loConf = allSubjectERPs{3,subject}(:,:,2);
        allSubjectMeansLoConf(:,:,subject) = (day2erp_loConf*allSubjectERPs{5,subject}(1) + day3erp_loConf*allSubjectERPs{5,subject}(2)) / sum(allSubjectERPs{5,subject});
        allSubjectMeansLoConfTwoSessionOnly = cat(4,allSubjectMeansLoConfTwoSessionOnly,(day2erp_loConf*allSubjectERPs{5,subject}(1) + day3erp_loConf*allSubjectERPs{5,subject}(2)) / sum(allSubjectERPs{5,subject}));
    elseif length(allSubjectERPs{4,subject}) == 1
        allSubjectMeansLoConf(:,:,subject) = allSubjectERPs{3,subject};
    end
end


group_mean_hiConf_erp = mean(allSubjectMeansHiConf,3);
group_mean_loConf_erp = mean(allSubjectMeansLoConf,3);


%%

electrodeChannel = 5;

extralpfilt = true;

allAverageHiConfERP = zeros(1,6000);
allAverageLoConfERP = zeros(1,6000);
allAverageHiConfERPs = [];
allAverageLoConfERPs = [];

allAverageHiConfERPs = squeeze(allSubjectMeansHiConf(electrodeChannel,:,:))';
allAverageLoConfERPs = squeeze(allSubjectMeansLoConf(electrodeChannel,:,:))';

allAverageHiConfERP = mean(allAverageHiConfERPs);
allAverageLoConfERP = mean(allAverageLoConfERPs);

group_mean_hiConf_erp = allAverageHiConfERP;
group_mean_loConf_erp = allAverageLoConfERP;

hiConf_SEM = zeros(1,size(group_mean_hiConf_erp,2));
loConf_SEM = zeros(1,size(group_mean_loConf_erp,2));

for point = 1:length(group_mean_hiConf_erp)
    hiConf_SEM(point) = std(allAverageHiConfERPs(:,point))/ sqrt(size(allSubjectERPs,2));
    loConf_SEM(point) = std(allAverageLoConfERPs(:,point))/ sqrt(size(allSubjectERPs,2));
end

figure;
hold on

line([0 0],[-4 4])
line([-2000 2000],[0 0])

if ~extralpfilt
    lowpass_hiConf_high = lowpass(group_mean_hiConf_erp+hiConf_SEM,1,1000);
    lowpass_hiConf_low = lowpass(group_mean_hiConf_erp-hiConf_SEM,1,1000);
    lowpass_loConf_high = lowpass(group_mean_loConf_erp+loConf_SEM,1,1000);
    lowpass_loConf_low = lowpass(group_mean_loConf_erp-loConf_SEM,1,1000);
elseif extralpfilt

    lpFilt = designfilt('lowpassfir','PassbandFrequency',8, ...
    'StopbandFrequency',14,'PassbandRipple',1, ...
    'StopbandAttenuation',65,'DesignMethod','kaiserwin','SampleRate',1000);
    lowpass_hiConf_high = filtfilt(lpFilt,group_mean_hiConf_erp+hiConf_SEM);
    lowpass_hiConf_low = filtfilt(lpFilt,group_mean_hiConf_erp-hiConf_SEM);
    lowpass_loConf_high = filtfilt(lpFilt,group_mean_loConf_erp+loConf_SEM);
    lowpass_loConf_low = filtfilt(lpFilt,group_mean_loConf_erp-loConf_SEM);
end

erp_legend = [];
erp_legend = [erp_legend patch([-2999:3000 fliplr(-2999:3000)], [lowpass_hiConf_low fliplr(lowpass_hiConf_high)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')];
erp_legend = [erp_legend patch([-2999:3000 fliplr(-2999:3000)], [lowpass_loConf_low fliplr(lowpass_loConf_high)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')];





if ~extralpfilt

    plot([-2999:3000],lowpass(group_mean_hiConf_erp,1,1000),'Color',[0 0 1 0.7],'LineWidth',5)
    plot([-2999:3000],lowpass(group_mean_loConf_erp,1,1000),'Color',[1 0.7 0 0.7],'LineWidth',5)
elseif extralpfilt
    plot([-2999:3000],filtfilt(lpFilt,group_mean_hiConf_erp),'Color',[0 0 1 0.7],'LineWidth',5)
    plot([-2999:3000],filtfilt(lpFilt,group_mean_loConf_erp),'Color',[1 0.7 0 0.7],'LineWidth',5)
end



ylim([-4 4])
xlim([-1000 1000])

legend(erp_legend,'HiConf','LoConf')
title(['E' num2str(electrodeChannel) ', Mean ERP, Quiz Run Split, N = ' num2str(length(allSubjectERPs)) ])

xlabel('Time (ms)')
ylabel('Voltage (microvolts)')
set(gca,'FontSize',24)



avg_erp_all_channels_hiConf_subjects = allSubjectMeansHiConf(:,1001:5000,:);
avg_erp_all_channels_loConf_subjects = allSubjectMeansLoConf(:,1001:5000,:);

creationFunction = 'aoa_hpc_plot_mean_erp_hiConf_loConf.m'
save('/vast/palmer/pi/blumenfeld/dsj8/AoA_Study/aoa_group_erp_means_hiConf_loConf.mat','avg_erp_all_channels_hiConf_subjects','avg_erp_all_channels_loConf_subjects','allSubjectMeansHiConf','allSubjectMeansLoConf','creationFunction')