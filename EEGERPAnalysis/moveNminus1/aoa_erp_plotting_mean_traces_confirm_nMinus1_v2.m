clear all
clc

%% This script aggregates individual participant pre-quizzed ERP confirms. The average unaware and average aware variables must be saved separately. 
% These averaged aware and unaware variables will be checked further by the script aoa_set_key_epoch_confirm_n_minus_1.m
location = 'l'
without_blinks = false;
without_stdev_diff = true;

if strcmp(location,'s')

    root = '/mnt/Data27/HNCT_AoA_Study/AoA_Subjects/';
    eeglabLocation = '/mnt/Data27/HNCT_AoA_Study/eeglab14_0_0b';
end
if strcmp(location,'l')
    root = 'Y:/HNCT_AoA_Study/AoA_Subjects/';
    eeglabLocation = 'Y:/HNCT_AoA_Study/eeglab14_0_0b';
end
addpath(eeglabLocation);
eeglab('nogui')
cleanline_dir = [eeglabLocation '/plugins/tmullen-cleanline-696a7181b7d0'];
cleanraw_dir = [eeglabLocation '/plugins/clean_rawdata-master'];
Photo_dir = [eeglabLocation '/sample_locs/GSN-HydroCel-257.sfp'];
[num text raw] = xlsread([root '/AoA_ERP_Quizzes_Then_Choose.xlsx']);
addpath(eeglabLocation);
eeglab('nogui')


allICAs = [];
allDesignations = {};
allSubjectERPs = [unique(text(1,:)); cell(1,length(unique(text(1,:)))); cell(1,length(unique(text(1,:)))); cell(1,length(unique(text(1,:)))); cell(1,length(unique(text(1,:))))];
allSubjectDesignations = [unique(text(1,:)); cell(1,length(unique(text(1,:))))];

subjects = length(allSubjectERPs);
disp('Loading data...')
load([root '/aoa_eeglab_blank.mat'])
sessionRange = [];

tic
for session = 1:length(text)%length(text);
    
    sessionRange = [sessionRange session];
    fileLocation = [root '/' text{1,session} '/' text{2,session} '/'];
    disp(['Analyzing ' text{1,session} ])
    sessionDate = num2str(num(1,session));
    cd(fileLocation)
    if ~isfile([sessionDate '_mean_confirm_ERPs_aware_unaware_nMinus1.mat']);
        load([fileLocation sessionDate '_ICA_epochs_components_removed_quizzes_then_choose_confirms_nMinus1.mat'])
        load([fileLocation sessionDate '_good_epoch_designations_quizzes_then_choose_confirms_nMinus1.mat']);    
        EEGlab_blank.data = ICA_epochs_components_removed;
        EEGlab_blank.trials = size(ICA_epochs_components_removed,3);
        EEGlab_blank_demean = pop_rmbase(EEGlab_blank,[]);
        awarecount = 0;
        unawarecount = 0;
        awareepochs = [];
        unawareepochs = [];
        for designation = 1:length(good_epoch_designations)
            if strcmp(good_epoch_designations{designation},'Aware') || strcmp(good_epoch_designations{designation},'CH')            
                awarecount = awarecount + 1;
                awareepochs = cat(3, awareepochs, ICA_epochs_components_removed(:,:,designation));
            elseif strcmp(good_epoch_designations{designation},'Unaware') || strcmp(good_epoch_designations{designation},'IL')
                unawarecount = unawarecount + 1;
                unawareepochs = cat(3, unawareepochs, ICA_epochs_components_removed(:,:,designation));
            end
        end
        mean_aware_trace = mean(awareepochs,3);
        mean_unaware_trace = mean(unawareepochs,3);
        eval(['save ' sessionDate '_mean_confirm_ERPs_aware_unaware_nMinus1.mat awareepochs unawareepochs mean_aware_trace mean_unaware_trace awarecount unawarecount'])
    end
    if ~isfile([sessionDate '_mean_confirm_ERPs_aware_unaware_stdev_diff_nMinus1.mat']);
        load([fileLocation sessionDate '_ICA_epochs_components_removed_quizzes_then_choose_confirms_nMinus1.mat'])
        load([fileLocation sessionDate '_good_epoch_designations_quizzes_then_choose_confirms_nMinus1.mat']);    
        EEGlab_blank.data = ICA_epochs_components_removed;
        EEGlab_blank.trials = size(ICA_epochs_components_removed,3);
        EEGlab_blank_demean = pop_rmbase(EEGlab_blank,[]);
        awarecount = 0;
        unawarecount = 0;
        awareepochs = [];
        unawareepochs = [];
        bad_std_epochs = [];
        for designation = 1:length(good_epoch_designations)
            bin_stds = zeros(1,16);
            bin_indices = 1:250:4000;
            for bin = 1:16
                bin_stds(bin) = std(ICA_epochs_components_removed(101,bin_indices(bin):bin_indices(bin)+249,designation));
            end
            if max(bin_stds)/min(bin_stds) > 10
                bad_std_epochs = [bad_std_epochs designation];
                disp('Abnormally high bin standard deviation found. Excluding trial.')
                continue
            end
                

            if (strcmp(good_epoch_designations{designation},'Aware') || strcmp(good_epoch_designations{designation},'CH'))  
                awarecount = awarecount + 1;
                awareepochs = cat(3, awareepochs, ICA_epochs_components_removed(:,:,designation));
            elseif (strcmp(good_epoch_designations{designation},'Unaware') || strcmp(good_epoch_designations{designation},'IL'))
                unawarecount = unawarecount + 1;
                unawareepochs = cat(3, unawareepochs, ICA_epochs_components_removed(:,:,designation));
            end
        end
        mean_aware_trace = mean(awareepochs,3);
        mean_unaware_trace = mean(unawareepochs,3);
        eval(['save ' sessionDate '_mean_confirm_ERPs_aware_unaware_stdev_diff_nMinus1.mat bad_std_epochs awareepochs unawareepochs mean_aware_trace mean_unaware_trace awarecount unawarecount'])
    end

    if without_blinks & ~without_stdev_diff
        load([sessionDate '_mean_confirm_ERPs_aware_unaware_blinked_nMinus1.mat'],'awarecount', 'unawarecount', 'mean_aware_trace', 'mean_unaware_trace')
    elseif ~without_blinks & ~without_stdev_diff
        load([sessionDate '_mean_confirm_ERPs_aware_unaware_nMinus1.mat'],'awarecount', 'unawarecount', 'mean_aware_trace', 'mean_unaware_trace')
    elseif without_stdev_diff
        disp('Loading with standard deviation-accepted trials only')
        load([sessionDate '_mean_confirm_ERPs_aware_unaware_stdev_diff_nMinus1.mat'],'awarecount', 'unawarecount', 'mean_aware_trace', 'mean_unaware_trace')
    end
    
    mean_aware_trace = mean_aware_trace - mean([mean_aware_trace],2);
    mean_unaware_trace = mean_unaware_trace - mean([mean_unaware_trace],2);
    for subject = 1:length(allSubjectERPs)
        if strcmp(allSubjectERPs{1,subject},text{1,session})
            allSubjectERPs{2,subject} = cat(3,allSubjectERPs{2,subject},mean_aware_trace);
            allSubjectERPs{3,subject} = cat(3,allSubjectERPs{3,subject},mean_unaware_trace);
            allSubjectERPs{4,subject} = [allSubjectERPs{4,subject} awarecount];
            allSubjectERPs{5,subject} = [allSubjectERPs{5,subject} unawarecount];
        end
    end
    toc
end
allSubjectERPsTemp = allSubjectERPs;
allSubjectERPs = [];
for subject = 1:length(allSubjectERPsTemp)
    if sum(allSubjectERPsTemp{4,subject}) >= 12 && sum(allSubjectERPsTemp{5,subject}) >= 12  
        allSubjectERPs = [allSubjectERPs allSubjectERPsTemp(:,subject)];
    end
end

disp('Taking weighted average of mean traces for two-session participants...')
avg_erp_all_channels_aware_subjects = zeros(257,4000, length(allSubjectERPs));
avg_erp_all_channels_unaware_subjects = zeros(257,4000, length(allSubjectERPs));

allSubjectERPsConsolidated = allSubjectERPs;
for subject = 1:size(allSubjectERPs,2)
    if size(allSubjectERPs{2,subject},3) == 2
        allSubjectERPsConsolidated{2,subject} = [];
        allSubjectERPsConsolidated{3,subject} = [];
        allSubjectERPsConsolidated{2,subject} = (allSubjectERPs{2,subject}(:,:,1)*allSubjectERPs{4,subject}(1) + allSubjectERPs{2,subject}(:,:,2)*allSubjectERPs{4,subject}(2)) / sum(allSubjectERPs{4,subject});
        allSubjectERPsConsolidated{3,subject} = (allSubjectERPs{3,subject}(:,:,1)*allSubjectERPs{5,subject}(1) + allSubjectERPs{3,subject}(:,:,2)*allSubjectERPs{5,subject}(2)) / sum(allSubjectERPs{5,subject});
    end
    avg_erp_all_channels_aware_subjects(:,:,subject) = allSubjectERPsConsolidated{2,subject}; %save trace
    avg_erp_all_channels_unaware_subjects(:,:,subject) = allSubjectERPsConsolidated{3,subject}; %save trace;
end
disp('Done.')
toc

%%

electrodeChannel = 128;
extralpfilt = true;
load([root '/aoa_group_analyses/confirm_nMinus1/timecourse_cluster_aware_minus_unaware_channel_' num2str(electrodeChannel) '_E' num2str(electrodeChannel) '_5000perm.mat']);
sig_time_points_aware_minus_unaware = sig_time_pts;

load([root '/aoa_group_analyses/confirm_nMinus1/timecourse_cluster_aware_channel_' num2str(electrodeChannel) '_E' num2str(electrodeChannel) '_5000perm.mat']);
sig_time_points_aware = sig_time_pts;

load([root '/aoa_group_analyses/confirm_nMinus1/timecourse_cluster_unaware_channel_' num2str(electrodeChannel) '_E' num2str(electrodeChannel) '_5000perm.mat']);
sig_time_points_unaware = sig_time_pts;


allAverageAwareERP = zeros(1,4000);
allAverageUnawareERP = zeros(1,4000);
allAverageAwareERPs = [];
allAverageUnawareERPs = [];

allAverageAwareERPs = squeeze(avg_erp_all_channels_aware_subjects(electrodeChannel,:,:))';
allAverageUnawareERPs = squeeze(avg_erp_all_channels_unaware_subjects(electrodeChannel,:,:))';

allAverageAwareERP = mean(allAverageAwareERPs);
allAverageUnawareERP = mean(allAverageUnawareERPs);

avg_erp_aware_all = allAverageAwareERP;
avg_erp_unaware_all = allAverageUnawareERP;

aware_SEM = zeros(1,size(mean_aware_trace,2));
unaware_SEM = zeros(1,size(mean_aware_trace,2));
%all_SEM = zeros(1,size(mean_aware_trace,2));

for point = 1:length(mean_aware_trace)
    aware_SEM(point) = std(allAverageAwareERPs(:,point))/ sqrt(size(allSubjectERPs,2));
    unaware_SEM(point) = std(allAverageUnawareERPs(:,point))/ sqrt(size(allSubjectERPs,2));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end

offset = 0;
figure;
hold on
line([0 0],[-4 4])
line([-2000 2000],[0 0])


if ~extralpfilt
    lowpass_aware_high = lowpass(avg_erp_aware_all+aware_SEM,1,1000);
    lowpass_aware_low = lowpass(avg_erp_aware_all-aware_SEM,1,1000);
    lowpass_unaware_high = lowpass(avg_erp_unaware_all+unaware_SEM,1,1000);
    lowpass_unaware_low = lowpass(avg_erp_unaware_all-unaware_SEM,1,1000);
elseif extralpfilt

    lpFilt = designfilt('lowpassfir','PassbandFrequency',5, ...
    'StopbandFrequency',14,'PassbandRipple',1, ...
    'StopbandAttenuation',65,'DesignMethod','kaiserwin','SampleRate',1000);
    lowpass_aware_high = filtfilt(lpFilt,avg_erp_aware_all+aware_SEM);
    lowpass_aware_low = filtfilt(lpFilt,avg_erp_aware_all-aware_SEM);
    lowpass_unaware_high = filtfilt(lpFilt,avg_erp_unaware_all+unaware_SEM);
    lowpass_unaware_low = filtfilt(lpFilt,avg_erp_unaware_all-unaware_SEM);
end



patch([-1999+offset:2000+offset fliplr(-1999+offset:2000+offset)], [lowpass_aware_low fliplr(lowpass_aware_high)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-1999+offset:2000+offset fliplr(-1999+offset:2000+offset)], [lowpass_unaware_low fliplr(lowpass_unaware_high)], [1 0 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')



ys_aware = 3.9*ones(1,length(sig_time_points_aware));

sig_line_aware = nan(1,4000);
sig_line_unaware = nan(1,4000);
sig_line_aware_minus_unaware = nan(1,4000);

for timepoint = 1:length(sig_time_points_aware)
   sig_line_aware(sig_time_points_aware(timepoint)) = sig_time_points_aware(timepoint);
end
for timepoint = 1:length(sig_time_points_unaware)
   sig_line_unaware(sig_time_points_unaware(timepoint)) = sig_time_points_unaware(timepoint);
end
for timepoint = 1:length(sig_time_points_aware_minus_unaware)
   sig_line_aware_minus_unaware(sig_time_points_aware_minus_unaware(timepoint)) = sig_time_points_aware_minus_unaware(timepoint);
end


if ~extralpfilt

    plot([-1999+offset:2000+offset],lowpass(avg_erp_aware_all,1,1000),'Color',[0 0 1 0.7],'LineWidth',5)
    plot([-1999+offset:2000+offset],lowpass(avg_erp_unaware_all,1,1000),'Color',[1 0 0 0.7],'LineWidth',5)
elseif extralpfilt
    plot([-1999+offset:2000+offset],filtfilt(lpFilt,avg_erp_aware_all),'Color',[0 0 1 0.7],'LineWidth',5)
    plot([-1999+offset:2000+offset],filtfilt(lpFilt,avg_erp_unaware_all),'Color',[1 0 0 0.7],'LineWidth',5)
end
erp_legend = plot(sig_line_aware-2000,5*ones(1,4000),'Color','blue','LineWidth',5);
erp_legend = [erp_legend; plot(sig_line_unaware-2000,5*ones(1,4000),'Color','red','LineWidth',5)];


erp_legend = [erp_legend; plot(sig_line_aware_minus_unaware-2000,3.5*ones(1,4000),'Color','green','LineWidth',5)];

ylim([-6 6])
xlim([-1000 1000])

legend(erp_legend,'Aware','Unaware','Aware Minus Unaware')
title(['Average ERP, Channel ' num2str(electrodeChannel) ', Aware vs. Unaware, N = ' num2str(length(allSubjectERPs)) ])

xlabel('Time (ms)')
ylabel('Voltage (microvolts)')
set(gca,'FontSize',24)
%%
load([root '/aoa_EEGlab_blank.mat'])
EEGlab_blank.chanlocs = readlocs(Photo_dir);
EEGlab_blank.xmin = -1.999;
EEGlab_blank.xmax = 2;
EEGlab_blank_aware = EEGlab_blank;
EEGlab_blank_aware.data = mean(avg_erp_all_channels_aware_subjects,3);
EEGlab_blank_unaware = EEGlab_blank;
EEGlab_blank_unaware.data = mean(avg_erp_all_channels_unaware_subjects,3);
%%
pop_topoplot(EEGlab_blank_aware,1, -1000:50:1000 , ['ERP Scalp Topographies, Aware, No Blinks'],[4:2] ,0, 'electrodes', 'on','gridscale',50,'intrad',[0.5],'maplimits',[-3,3],'style','map');
pop_topoplot(EEGlab_blank_unaware,1, -1000:50:1000 , ['ERP Scalp Topographies, Unaware, No Blinks'],[4:2] ,0, 'electrodes', 'on','gridscale',50,'intrad',[0.5],'maplimits',[-3,3],'style','map');

%%
pop_topoplot(EEGlab_blank_aware,1, 100:5:300 , ['ERP Scalp Topographies, Aware, No Blinks'],[4:2] ,0, 'electrodes', 'on','gridscale',50,'intrad',[0.5],'maplimits',[-3,3],'style','map');
pop_topoplot(EEGlab_blank_unaware,1, 100:5:300 , ['ERP Scalp Topographies, Unaware, No Blinks'],[4:2] ,0, 'electrodes', 'on','gridscale',50,'intrad',[0.5],'maplimits',[-3,3],'style','map');

%%
allAverageAwareERP = zeros(1,4000);
allAverageUnawareERP = zeros(1,4000);
allAverageAwareERPs = [];
allAverageUnawareERPs = [];

for subject = 1:length(allSubjectERPs)
    allAverageAwareERPs = [allAverageAwareERPs; allSubjectERPsConsolidated{2,subject}];
    allAverageUnawareERPs = [allAverageUnawareERPs; allSubjectERPsConsolidated{3,subject}];
    allAverageAwareERP = allAverageAwareERP + allSubjectERPsConsolidated{2,subject};
    allAverageUnawareERP = allAverageUnawareERP + allSubjectERPsConsolidated{3,subject};
end

allAverageAwareERPs = squeeze(avg_erp_all_channels_aware_subjects(electrodeChannel,:,:))';
allAverageUnawareERPs = squeeze(avg_erp_all_channels_unaware_subjects(electrodeChannel,:,:))';
%allAverageAwareERP = allAverageAwareERP/subject;
%allAverageUnawareERP = allAverageUnawareERP/subject;

allAverageAwareERP = mean(allAverageAwareERPs);
allAverageUnawareERP = mean(allAverageUnawareERPs);

avg_erp_aware_all = allAverageAwareERP;
avg_erp_unaware_all = allAverageUnawareERP;

aware_SEM = zeros(1,length(mean_aware_trace));
unaware_SEM = zeros(1,length(mean_unaware_trace));


for point = 1:length(mean_aware_trace)
    aware_SEM(point) = std(allAverageAwareERPs(:,point))/ sqrt(size(allSubjectDesignations,2));
    unaware_SEM(point) = std(allAverageUnawareERPs(:,point))/ sqrt(size(allSubjectDesignations,2));
    %all_SEM(point) = std(all_ERPs(1,point,:))/ sqrt(totalERPs);
end

offset = 0;
figure;
hold on
line([0 0],[-4 4])
line([-2000 2000],[0 0])


lowpass_aware_high = lowpass(avg_erp_aware_all+aware_SEM,500,1000);
lowpass_aware_low = lowpass(avg_erp_aware_all-aware_SEM,500,1000);
lowpass_unaware_high = lowpass(avg_erp_unaware_all+unaware_SEM,500,1000);
lowpass_unaware_low = lowpass(avg_erp_unaware_all-unaware_SEM,500,1000);

patch([-1999+offset:2000+offset fliplr(-1999+offset:2000+offset)], [lowpass_aware_low fliplr(lowpass_aware_high)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat')
patch([-1999+offset:2000+offset fliplr(-1999+offset:2000+offset)], [lowpass_unaware_low fliplr(lowpass_unaware_high)], [1 0 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat')

erp_legend = plot([-1999+offset:2000+offset],lowpass(avg_erp_aware_all,500,1000),'Color',[0 0 1 0.7],'LineWidth',2)
erp_legend = [erp_legend; plot([-1999+offset:2000+offset],lowpass(avg_erp_unaware_all,500,1000),'Color',[1 0 0 0.7],'LineWidth',2)]
plot([-1999+offset:2000+offset],lowpass(avg_erp_aware_all+aware_SEM,500,1000),'Color',[0 0 1 0.7],'LineWidth',1)
plot([-1999+offset:2000+offset],lowpass(avg_erp_aware_all-aware_SEM,500,1000),'Color',[0 0 1 0.7],'LineWidth',1)
plot([-1999+offset:2000+offset],lowpass(avg_erp_unaware_all+unaware_SEM,500,1000),'Color',[1 0 0 0.7],'LineWidth',1)
plot([-1999+offset:2000+offset],lowpass(avg_erp_unaware_all-unaware_SEM,500,1000),'Color',[1 0 0 0.7],'LineWidth',1)

ylim([-4 4])
xlim([-1000 1000])

legend(erp_legend,'Aware','Unaware')
%title(['Average ERP, Channel ' num2str(electrodeChannel) ', Aware (n = ' num2str(total_aware_ERPs/size(allSubjectDesignations,2)) ') vs. Unaware (n = ' num2str(total_unaware_ERPs/size(allSubjectDesignations,2)) '), N = ' num2str(length(allSubjectERPs)) ])
title(['Average ERP, Channel ' num2str(electrodeChannel) ', Aware vs. Unaware, N = ' num2str(length(allSubjectERPs)) ])

xlabel('Time (ms)')
ylabel('Voltage (microvolts)')
set(gca,'FontSize',24)

figure;
hold on;
for subject = 1:length(allSubjectDesignations)
    plot([-1999+offset:2000+offset],avg_erp_all_channels_aware_subjects(electrodeChannel,:,subject)+(subject-1)*10);
end

colors = jet(length(allSubjectDesignations));
figure;
hold on;
for subject = 1:length(allSubjectDesignations)
%for subject = 4:21
    if subject == length(allSubjectDesignations)
        linewidth = 5;
    elseif subject < length(allSubjectDesignations)
        linewidth = 1;
    end
    plot([-1999+offset:2000+offset],lowpass(avg_erp_all_channels_aware_subjects(electrodeChannel,:,subject),500,1000),'color',[colors(subject,:) 0.5],'LineWidth',linewidth);
end


xlim([-1000 1000])
figure;
hold on;
for subject = 1:length(allSubjectDesignations)
%for subject = 4:21
    scatter(subject,max(lowpass(avg_erp_all_channels_aware_subjects(electrodeChannel,:,subject),500,1000)));
end

subjectsNL09 = [1,2,3,20,23:40];

subjectsG07 = [4:6,15:18,41:57];

for sub = 1:length(subjectsNL09)
    subject = subjectsNL09(sub);
    plot([-1999+offset:2000+offset],lowpass(mean(avg_erp_all_channels_aware_subjects(electrodeChannel,:,subjectsNL09),3),500,1000),'color',[colors(subject,:) 0.5]);
end
for sub = 1:length(subjectsG07)
    subject = subjectsG07(sub);
    plot([-1999+offset:2000+offset],lowpass(mean(avg_erp_all_channels_aware_subjects(electrodeChannel,:,subjectsG07),3),500,1000),'color',[colors(subject,:) 0.5]);
end
offset = 0


figure;
hold on
plot([-1999:2000],lowpass(mean(avg_erp_all_channels_aware_subjects(electrodeChannel,:,subjectsNL09),3),500,1000),'color',[1 0 0 0.5]);
plot([-1999:2000],lowpass(mean(avg_erp_all_channels_aware_subjects(electrodeChannel,:,subjectsG07),3),500,1000),'color',[0 1 1 0.5]);

legend({'TAC MRRC NL09','CSC G07'})
title('Time from Confirmation, CSC G07 vs TAC MRRC NL09')
xlim([-2000 2000])

lpFilt = designfilt('lowpassfir','PassbandFrequency',1, ...
'StopbandFrequency',14,'PassbandRipple',1, ...
'StopbandAttenuation',65,'DesignMethod','kaiserwin','SampleRate',1000);
figure;
hold on;
plot(-1999:2000,diff(filtfilt(lpFilt,[0 double(avg_erp_aware_all)]))*1000,'Color','blue');
plot(-1999:2000,diff(filtfilt(lpFilt,[0 double(avg_erp_unaware_all)]))*1000,'Color','red')



%%
avg_erp_diff = avg_erp_all_channels_aware_subjects - avg_erp_all_channels_unaware_subjects;

mean_diff_magnitude = abs(mean(avg_erp_diff(electrodeChannel,:,:),3));

allDiffMagnitudes = squeeze(avg_erp_diff(electrodeChannel,:,:))';

for point = 1:length(mean_diff_magnitude)
    diff_SEM(point) = std(allDiffMagnitudes(:,point))/ sqrt(size(allSubjectDesignations,2));
end

figure;
hold on
line([0 0],[-1 1])
line([-2000 2000],[0 0])
%avg_erp_aware_all = avg_erp_aware_all - avg_erp_aware_all(1);
%avg_erp_aware_all = avg_erp_unaware_all - avg_erp_unaware_all(1);

lowpass_diff_high = lowpass(mean_diff_magnitude+diff_SEM,1,1000);
lowpass_diff_low = lowpass(mean_diff_magnitude-diff_SEM,1,1000);
patch([-1999+offset:2000+offset fliplr(-1999+offset:2000+offset)], [lowpass_diff_low fliplr(lowpass_diff_high)], [0 1 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat')

erp_legend = plot([-1999+offset:2000+offset],lowpass(mean_diff_magnitude,1,1000),'Color',[0 1 0 0.7],'LineWidth',5)

plot([-1999+offset:2000+offset],lowpass(mean_diff_magnitude+diff_SEM,1,1000),'Color',[0 1 0 0.7],'LineWidth',1)
plot([-1999+offset:2000+offset],lowpass(mean_diff_magnitude-diff_SEM,1,1000),'Color',[0 1 0 0.7],'LineWidth',1)

%%

figure;

shortmovieaware = EEGlab_blank_aware.data(:,1001-offset:3000-offset);
shortmovieaware(225:256,:) = zeros(length(225:256),2000);
EEGlab_shortaware = EEGlab_blank_aware;
EEGlab_shortaware.data = shortmovieaware;
EEGlab_shortaware.pnts = 2000;
% shortmovieaware = [shortmovieaware(31,:); shortmovieaware(67,:);shortmovieaware(219,:);shortmovieaware]
addpath([eeglabLocation '/plugins/dipfit'])

channelLocs = readlocs([eeglabLocation '/sample_locs/GSN257.sfp'],'filetype','sfp')
splinefile = '257_splinefile.spl'

headplot('setup',channelLocs,splinefile)
% EEGlab_blank_movie = EEGlab_blank_all;
EEGlab_blank_movie.splinefile = splinefile;
%pop_headplot(shortmovieaware,splinefileparams, 'maplimits', [-1.5 1.5], 'lighting', 'on','electrodes','on');
%pop_headplot(EEGlab_blank_all,1, -1000:50:1000 , ['ERP Scalp Topographies, Confirm at 2000, All Non-Board Disappearance Confirms, n = ' num2str(size(ICA_epochs_components_removed,3))],[4:2] ,0, 'electrodes', 'on','intrad',[0.6],'maplimits',[-1.5,1.5]);
%pop_headplot(EEGlab_blank_movie, 1, [-1000: 50: 1000], 'ERP scalp maps', [5 10],'maplimits',[-1.5 1.5],'electrodes', 'off','labels',0,'view',[90 30])
% if isfile([sessionDate '_coordinates.sfp'])
%     disp('Photogrammetry found...')
%     movie_channels = readlocs([sessionDate '_coordinates.sfp'])
%     movie_channels(1:3) = [];
% elseif ~isfile([sessionDate '_coordinates.sfp'])
%     disp('No photogrammetry found. Using default channel locations...')
%     movie_channels = EEGlab_blank.chanlocs;
% end

movie_channels = EEGlab_blank_aware.chanlocs;
figure; [movietowrite,Colormap] = eegmovie(shortmovieaware, EEGlab_blank_aware.srate, movie_channels, 'framenum', 'off','minmax',[-3,3], 'vert', 0, 'startsec', -1,'mode','3D','headplotopt',{'view' 'top','maplimits' [-3 3]});
vidObj = VideoWriter(['erpmovie3d_rescale_overhead_aware_nocheek.mp4']);
open(vidObj);
writeVideo(vidObj, movietowrite);
close(vidObj);

movie_channels = EEGlab_blank_aware.chanlocs;
figure; [movietowrite,Colormap] = eegmovie(shortmovieaware, EEGlab_blank_unaware.srate, movie_channels, 'framenum', 'off','minmax',[-3,3], 'vert', 0, 'startsec', -1,'mode','3D','headplotopt',{'view' 'backright','maplimits' [-3 3]});
vidObj = VideoWriter(['erpmovie3d_rescale_backright_aware_nocheek.mp4']);
open(vidObj);
writeVideo(vidObj, movietowrite);
close(vidObj);

movie_channels = EEGlab_blank_aware.chanlocs;
figure; [movietowrite,Colormap] = eegmovie(shortmovieaware, EEGlab_blank_unaware.srate, movie_channels, 'framenum', 'off','minmax',[-3,3], 'vert', 0, 'startsec', -1,'mode','3D','headplotopt',{'view' 'frontleft','maplimits' [-3 3]});
vidObj = VideoWriter(['erpmovie3d_rescale_frontleft_aware_nocheek.mp4']);
open(vidObj);
writeVideo(vidObj, movietowrite);
close(vidObj);

%avg_erp_all_channels_unaware = mean(avg_erp_all_channels_unaware_subjects,3);
shortmovieunaware = EEGlab_blank_unaware.data(:,1001-offset:3000-offset);
shortmovieunaware(225:256,:) = zeros(length(225:256),2000)
EEGlab_shortunaware = EEGlab_blank_unaware;
EEGlab_shortunaware.data = shortmovieunaware;
EEGlab_shortunaware.pnts = 2000;
% shortmovieunaware = [shortmovieunaware(31,:); shortmovieunaware(67,:);shortmovieunaware(219,:);shortmovieunaware]
addpath([eeglabLocation '/plugins/dipfit'])

channelLocs = readlocs([eeglabLocation '/sample_locs/GSN257.sfp'],'filetype','sfp')
splinefile = '257_splinefile.spl'

headplot('setup',channelLocs,splinefile)
% EEGlab_blank_movie = EEGlab_blank_all;
EEGlab_blank_movie.splinefile = splinefile;


movie_channels = EEGlab_blank_unaware.chanlocs;
figure; [movietowrite,Colormap] = eegmovie(shortmovieunaware, EEGlab_blank_unaware.srate, movie_channels, 'framenum', 'off','minmax',[-3,3], 'vert', 0, 'startsec', -1,'mode','3D','headplotopt',{'view' 'top','maplimits' [-3 3]});
vidObj = VideoWriter(['erpmovie3d_rescale_overhead_unaware_nocheek.mp4']);
open(vidObj);
writeVideo(vidObj, movietowrite);
close(vidObj);

movie_channels = EEGlab_blank_unaware.chanlocs;
figure; [movietowrite,Colormap] = eegmovie(shortmovieunaware, EEGlab_blank_unaware.srate, movie_channels, 'framenum', 'off','minmax',[-3,3], 'vert', 0, 'startsec', -1,'mode','3D','headplotopt',{'view' 'backright','maplimits' [-3 3]});
vidObj = VideoWriter(['erpmovie3d_rescale_backright_unaware_nocheek.mp4']);
open(vidObj);
writeVideo(vidObj, movietowrite);
close(vidObj);

movie_channels = EEGlab_blank_unaware.chanlocs;
figure; [movietowrite,Colormap] = eegmovie(shortmovieunaware, EEGlab_blank_unaware.srate, movie_channels, 'framenum', 'off','minmax',[-3,3], 'vert', 0, 'startsec', -1,'mode','3D','headplotopt',{'view' 'frontleft','maplimits' [-3 3]});
vidObj = VideoWriter(['erpmovie3d_rescale_frontleft_unaware_nocheek.mp4']);
open(vidObj);
writeVideo(vidObj, movietowrite);
close(vidObj);
