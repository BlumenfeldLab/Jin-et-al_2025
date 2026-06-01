%% Blink Permutation Analysis - ROI Timecourse

%The purpose of this code is to find statically
%signficiant changes in time via the cluster based permutation method. This
%is completed both by aware vs unaware and aware-unaware vs baseline (prestimulus period)

%Written by: Sharif I. Kronemer
%Adapted by: David S. Jin
%Date: 3/10/2021
%Modified: 6/11/2022

clear

%% Run Location

%Select run location
%prompt_1 = 'Running code local or server [l, s]: ';
run_location = 'l';%input(prompt_1,'s');

%Smooth data prior to visualization
smooth_data = 'yes';

%% Directories and Variable Names

%Variable name
folder_name = 'cent_quad_threshold_15s'; %'cent_quad_threshold_1_15s';

if strcmp(run_location,'l')
    data_dir = 'Y:\HNCT_AoA_Study\HPC_Analyses\';
    addpath(genpath(data_dir));    
    %Save directory
    save_dir = 'Y:\HNCT_AoA_Study\HPC_Analyses\';
elseif strcmp(run_location,'s')
    data_dir = '/mnt/Data27/HNCT_AoA_Study/AoA_Subjects/';
    addpath(genpath(data_dir));    
    %Save directory
    save_dir = '/mnt/Data27/HNCT_AoA_Study/AoA_Subjects/';
end
if ~exist(save_dir)
    mkdir(save_dir);
end
%% Load group blink data
cd(data_dir)
eye = 'right'
load([data_dir '/aoa_group_pupil_data_hpc.mat'])


if strcmp(eye,'left')

    all_avg_pupil_aware_temp = all_avg_all_blink_aware_left(:,6001:10000);
    all_avg_pupil_unaware_temp = all_avg_all_blink_unaware_left(:,6001:10000);
    all_avg_pupil_aware = [];
    all_avg_pupil_unaware = [];
elseif strcmp(eye,'right')
    all_avg_pupil_aware_temp = all_avg_all_blink_aware_right(:,6001:10000);
    all_avg_pupil_unaware_temp = all_avg_all_blink_unaware_right(:,6001:10000);
    all_avg_pupil_aware = [];
    all_avg_pupil_unaware = [];
end



for subject = 1:size(all_avg_pupil_aware_temp,1)

    currentEpochAware = [all_avg_pupil_aware_temp(subject,:); all_avg_pupil_aware_temp(subject,:)];
    all_avg_pupil_aware = cat(3,all_avg_pupil_aware,currentEpochAware);

    currentEpochUnaware = [all_avg_pupil_unaware_temp(subject,:); all_avg_pupil_unaware_temp(subject,:)];
    all_avg_pupil_unaware = cat(3,all_avg_pupil_unaware,currentEpochUnaware);
end

    
%% Parameters

%Number of permutations
num_permutations = 5000;

%Are samples dependent (default is true)
dependent_samples = 'true';

%Define alpha threshold
p_threshold = 0.05;

%Two-sided
two_sided = 'true';

%% Main and Subtraction Epoch Subtraction and Baseline 


disp('Setting up data')

%Specify baseline period 
baseline_window = 1:1000;

%aware minus unaware

%Subtract main data from subtract data
group_pc_data = all_avg_pupil_aware - all_avg_pupil_unaware;

%Calculate baseline values 
group_pc_baseline = squeeze(nanmean(group_pc_data(:,baseline_window,:),2));

%Convert baseline 
group_aware_minus_unaware_baseline = permute(repmat(group_pc_baseline,[1,1,4000]),[1,3,2]);

%Subtract baseline from main data
group_aware_minus_unaware_baselined_data = group_pc_data; %- group_aware_minus_unaware_baseline;

%Mean blink over subjects
aware_minus_unaware_mean_blink = nanmean(group_aware_minus_unaware_baselined_data,3);

%aware

%Calculate baseline values
group_pc_baseline = squeeze(nanmean(all_avg_pupil_aware(:,baseline_window,:),2));

%Convert baseline
group_aware_baseline = permute(repmat(group_pc_baseline,[1,1,4000]),[1,3,2]);

%Subtract baseline from main data
group_aware_baselined_data = all_avg_pupil_aware - group_aware_baseline;

%Mean blink over subjects
aware_mean_blink = nanmean(group_aware_baselined_data,3);

%unaware
    
%Calculate baseline values
group_pc_baseline = squeeze(nanmean(all_avg_pupil_unaware(:,baseline_window,:),2));

%Convert baseline
group_unaware_baseline = permute(repmat(group_pc_baseline,[1,1,4000]),[1,3,2]);

%Subtract baseline from main data
group_unaware_baselined_data = all_avg_pupil_unaware - group_unaware_baseline;

%Mean blink over subjects
unaware_mean_blink = nanmean(group_unaware_baselined_data,3);

%% Run Permutation Tests

%Select channels (21 = Fz; 257 = Cz; 101 = Pz; 126 = Oz)
eye_list = [1];


%Loop over channels
tic
for chan = 1:length(eye_list)
    
    
    
    %Define channel
    current_channel = eye_list(chan);
    current_eye_name = ['E' num2str(eye_list(chan))];
    %aware vs unaware Testing
    disp(['Running Permutation Tests - ',num2str(current_channel)])
    
    %aware vs unaware Testing
    [clusters, pval, t_sums, permutation_distribution] = permutest_TimeCourses(squeeze(group_aware_baselined_data(current_channel,:,:)), squeeze(group_unaware_baselined_data(current_channel,:,:)), dependent_samples, ...
        p_threshold, num_permutations, two_sided);

    %Find significant clusters pvalue < 0.05
    sig_clust = find(pval < 0.05);

    %Find the significant time points
    sig_time_pts = sort([clusters{sig_clust}]);

    %Save output
    cd(save_dir)
    save(['timecourse_cluster_aware_vs_unaware_eye_',eye,'_',current_eye_name,'_',num2str(num_permutations),'perm_all_blink.mat'],...
        'clusters','pval','t_sums','permutation_distribution','sig_clust','sig_time_pts');

    %aware-unaware vs Baseline Testing
    [clusters, pval, t_sums, permutation_distribution] = permutest_TimeCourses(squeeze(group_aware_minus_unaware_baselined_data(current_channel,:,:)), squeeze(group_aware_minus_unaware_baseline(current_channel,:,:)), dependent_samples, ...
        p_threshold, num_permutations, two_sided);

    %Find significant clusters pvalue < 0.05
    sig_clust = find(pval < 0.05);

    %Find the significant time points
    sig_time_pts = sort([clusters{sig_clust}]);

    %Save output
    cd(save_dir)
    save(['timecourse_cluster_aware_minus_unaware_eye_',eye,'_',current_eye_name,'_',num2str(num_permutations),'perm_all_blink.mat'],...
        'clusters','pval','t_sums','permutation_distribution','sig_clust','sig_time_pts');
  
    %aware vs Baseline Testing
    [clusters, pval, t_sums, permutation_distribution] = permutest_TimeCourses(squeeze(group_aware_baselined_data(current_channel,:,:)), squeeze(group_aware_baseline(current_channel,:,:)), dependent_samples, ...
        p_threshold, num_permutations, two_sided);

    %Find significant clusters pvalue < 0.05
    sig_clust = find(pval < 0.05);

    %Find the significant time points
    sig_time_pts = sort([clusters{sig_clust}]);

    %Save output
    cd(save_dir)
    save(['timecourse_cluster_aware_eye_',eye,'_',current_eye_name,'_',num2str(num_permutations),'perm_all_blink.mat'],...
        'clusters','pval','t_sums','permutation_distribution','sig_clust','sig_time_pts');
    
    %unaware vs Baseline Testing
    [clusters, pval, t_sums, permutation_distribution] = permutest_TimeCourses(squeeze(group_unaware_baselined_data(current_channel,:,:)), squeeze(group_unaware_baseline(current_channel,:,:)), dependent_samples, ...
        p_threshold, num_permutations, two_sided);

    %Find significant clusters pvalue < 0.05
    sig_clust = find(pval < 0.05);

    %Find the significant time points
    sig_time_pts = sort([clusters{sig_clust}]);

    %Save output
    cd(save_dir)
    save(['timecourse_cluster_unaware_eye_',eye,'_',current_eye_name,'_',num2str(num_permutations),'perm_all_blink.mat'],...
        'clusters','pval','t_sums','permutation_distribution','sig_clust','sig_time_pts');
    toc
    
end
