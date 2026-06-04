%% Groups and plots ERPs for early delays (1-5s)

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
    %load([sessionDates{session} '_power_vectors_quizzes_then_choose_250_window_31_sliding.mat'],'awareTotals','unawareTotals','mean_electrode_all_freq_zscore_aware','mean_electrode_all_freq_zscore_unaware')
    load([sessionDates{session} '_mean_erps_split_designations_raw.mat'])
    mean_aware_erp = mean_aware_erp_early;
    mean_unaware_erp = mean_unaware_erp_early;
    awareTotals = awareTotals_early;
    unawareTotals = unawareTotals_early;
    for subject = 1:length(allSubjectERPs)
        if strcmp(allSubjectERPs{1,subject},allSubjectNames{session})
            allSubjectERPs{2,subject} = cat(3,allSubjectERPs{2,subject},mean_aware_erp);
            allSubjectERPs{3,subject} = cat(3,allSubjectERPs{3,subject},mean_unaware_erp);
            allSubjectERPs{4,subject} = [allSubjectERPs{4,subject} awareTotals];
            allSubjectERPs{5,subject} = [allSubjectERPs{5,subject} unawareTotals]; 
        end
    end
    toc
end

allSubjectERPs_temp = allSubjectERPs;
allSubjectERPs = [];
for subject = 1:size(allSubjectERPs_temp,2)
    if strcmp(allSubjectERPs_temp{1,subject},'774') || strcmp(allSubjectERPs_temp{1,subject},'778') || strcmp(allSubjectERPs_temp{1,subject},'780') || strcmp(allSubjectERPs_temp{1,subject},'783')
        continue
    end
    %if sum(allSubjectERPs_temp{4,subject}) >= 12 && sum(allSubjectERPs_temp{5,subject}) >= 12
        allSubjectERPs = [allSubjectERPs allSubjectERPs_temp(:,subject)];
    %end
end

%% Instantiate empty subject mean vectors, and concatenate the weighted two-day mean trace
allSubjectMeansAware = zeros([size(mean_aware_erp) length(allSubjectERPs)]);
allSubjectMeansUnaware = zeros([size(mean_unaware_erp) length(allSubjectERPs)]);

allSubjectMeansAwareTwoSessionOnly = [];
allSubjectMeansUnawareTwoSessionOnly = [];
for subject = 1:length(allSubjectERPs)
    disp(['Concatenating subject ' allSubjectERPs{1,subject}])
    if length(allSubjectERPs{4,subject}) == 2 & allSubjectERPs{4,subject}(1) > 0 & allSubjectERPs{4,subject}(2) > 0
        day2erp_aware = allSubjectERPs{2,subject}(:,:,1);
        day3erp_aware = allSubjectERPs{2,subject}(:,:,2);
        allSubjectMeansAware(:,:,subject) = (day2erp_aware*allSubjectERPs{4,subject}(1) + day3erp_aware*allSubjectERPs{4,subject}(2)) / sum(allSubjectERPs{4,subject});
        allSubjectMeansAwareTwoSessionOnly = cat(4,allSubjectMeansAwareTwoSessionOnly,(day2erp_aware*allSubjectERPs{4,subject}(1) + day3erp_aware*allSubjectERPs{4,subject}(2)) / sum(allSubjectERPs{4,subject}));
    elseif length(allSubjectERPs{4,subject}) == 1
        allSubjectMeansAware(:,:,subject) = allSubjectERPs{2,subject};
    end
    if length(allSubjectERPs{5,subject}) == 2 & allSubjectERPs{5,subject}(1) > 0 & allSubjectERPs{5,subject}(2) > 0
        day2erp_unaware = allSubjectERPs{3,subject}(:,:,1);
        day3erp_unaware = allSubjectERPs{3,subject}(:,:,2);
        allSubjectMeansUnaware(:,:,subject) = (day2erp_unaware*allSubjectERPs{5,subject}(1) + day3erp_unaware*allSubjectERPs{5,subject}(2)) / sum(allSubjectERPs{5,subject});
        allSubjectMeansUnawareTwoSessionOnly = cat(4,allSubjectMeansUnawareTwoSessionOnly,(day2erp_unaware*allSubjectERPs{5,subject}(1) + day3erp_unaware*allSubjectERPs{5,subject}(2)) / sum(allSubjectERPs{5,subject}));
    elseif length(allSubjectERPs{4,subject}) == 1
        allSubjectMeansUnaware(:,:,subject) = allSubjectERPs{3,subject};
    end
end


group_mean_aware_erp = mean(allSubjectMeansAware,3);
group_mean_unaware_erp = mean(allSubjectMeansUnaware,3);


%% Plot channel with filtering

electrodeChannel = 164;

extralpfilt = true;

allAverageAwareERP = zeros(1,6000);
allAverageUnawareERP = zeros(1,6000);
allAverageAwareERPs = [];
allAverageUnawareERPs = [];

allAverageAwareERPs = squeeze(allSubjectMeansAware(electrodeChannel,:,:))';
allAverageUnawareERPs = squeeze(allSubjectMeansUnaware(electrodeChannel,:,:))';

allAverageAwareERP = mean(allAverageAwareERPs);
allAverageUnawareERP = mean(allAverageUnawareERPs);

group_mean_aware_erp = allAverageAwareERP;
group_mean_unaware_erp = allAverageUnawareERP;

aware_SEM = zeros(1,size(group_mean_aware_erp,2));
unaware_SEM = zeros(1,size(group_mean_unaware_erp,2));

for point = 1:length(group_mean_aware_erp)
    aware_SEM(point) = std(allAverageAwareERPs(:,point))/ sqrt(size(allSubjectERPs,2));
    unaware_SEM(point) = std(allAverageUnawareERPs(:,point))/ sqrt(size(allSubjectERPs,2));
end

figure;
hold on

line([0 0],[-4 4])
line([-2000 2000],[0 0])

if ~extralpfilt
    lowpass_aware_high = lowpass(group_mean_aware_erp+aware_SEM,1,1000);
    lowpass_aware_low = lowpass(group_mean_aware_erp-aware_SEM,1,1000);
    lowpass_unaware_high = lowpass(group_mean_unaware_erp+unaware_SEM,1,1000);
    lowpass_unaware_low = lowpass(group_mean_unaware_erp-unaware_SEM,1,1000);
elseif extralpfilt

    lpFilt = designfilt('lowpassfir','PassbandFrequency',8, ...
    'StopbandFrequency',14,'PassbandRipple',1, ...
    'StopbandAttenuation',65,'DesignMethod','kaiserwin','SampleRate',1000);
    lowpass_aware_high = filtfilt(lpFilt,group_mean_aware_erp+aware_SEM);
    lowpass_aware_low = filtfilt(lpFilt,group_mean_aware_erp-aware_SEM);
    lowpass_unaware_high = filtfilt(lpFilt,group_mean_unaware_erp+unaware_SEM);
    lowpass_unaware_low = filtfilt(lpFilt,group_mean_unaware_erp-unaware_SEM);
end

erp_legend = [];
erp_legend = [erp_legend patch([-2999:3000 fliplr(-2999:3000)], [lowpass_aware_low fliplr(lowpass_aware_high)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')];
erp_legend = [erp_legend patch([-2999:3000 fliplr(-2999:3000)], [lowpass_unaware_low fliplr(lowpass_unaware_high)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')];





if ~extralpfilt

    plot([-2999:3000],lowpass(group_mean_aware_erp,1,1000),'Color',[0 0 1 0.7],'LineWidth',5)
    plot([-2999:3000],lowpass(group_mean_unaware_erp,1,1000),'Color',[1 0.7 0 0.7],'LineWidth',5)
elseif extralpfilt
    plot([-2999:3000],filtfilt(lpFilt,group_mean_aware_erp),'Color',[0 0 1 0.7],'LineWidth',5)
    plot([-2999:3000],filtfilt(lpFilt,group_mean_unaware_erp),'Color',[1 0.7 0 0.7],'LineWidth',5)
end



ylim([-4 4])
xlim([-1000 1000])

legend(erp_legend,'Aware','Unaware')
title(['E' num2str(electrodeChannel) ', Mean ERP, Quiz Gap Split, N = ' num2str(length(allSubjectERPs)) ])

xlabel('Time (ms)')
ylabel('Voltage (microvolts)')
set(gca,'FontSize',24)



avg_erp_all_channels_aware_subjects = allSubjectMeansAware(:,1001:5000,:);
avg_erp_all_channels_unaware_subjects = allSubjectMeansUnaware(:,1001:5000,:);

creationFunction = 'aoa_hpc_plot_mean_erp_split_designations_raw_early.m'
save('/vast/palmer/pi/blumenfeld/dsj8/AoA_Study/aoa_group_erp_means_split_designations_raw_early.mat','avg_erp_all_channels_aware_subjects','avg_erp_all_channels_unaware_subjects','allSubjectMeansAware','allSubjectMeansUnaware','creationFunction')
