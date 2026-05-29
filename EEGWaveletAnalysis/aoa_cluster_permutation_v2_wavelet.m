
function output_end = aoa_cluster_permutation_v2_wavelet(band,data_type) % Specify band (delta, theta, alpha, beta) or condition (Aware, Unaware, or Aware_Minus_Unaware)
    %% EEG Electrode Based Permutation Analysis - No report data

    %This code will:
    %(1) Load EEG data
    %(2) Baseline data
    %(3) Cluster based permutation analysis 
    %(4) Generate topoplots of significant clusters

    %Written by: Sharif I. Kronemer
    %Date: 2/24/2021
    %Modified: 5/31/2021

    %Re-adapted by David S. Jin
    %Date: 1/17/2024



    %% Parameters

    %Number of permutations
    num_permutation = 5000;

    %Specify baseline period 
    baseline_window = 1:1000; 

    %% Directories and Variable Names

    %Variable name
    folder_name ='aoa_cluster_permutation_2024'% ['cent_quad_threshold_score_thres_',score_threshold];

    if isequal(run_location, 's')

        %Load EEGLab Template
        load('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/aoa_EEGlab_blank.mat');

        %Photogrammetry directory
        Photo_dir = '/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/eeglab14_0_0b/sample_locs/GSN-HydroCel-257.sfp';

        %Data directory
        data_dir = '/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/';

        %Save directory
        save_dir = fullfile('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Cluster_Permutation_Wavelet/');

        %Neighborhood matrix directory
        hood_dir = '/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/';

    elseif isequal(run_location, 'l')

    end

    %Make save directory
    mkdir(save_dir)

    %% Load group voltage data for selected band

    cd(data_dir)

    load('aoa_group_wavelet_1000Hz.mat', ['allSubjectMeansAware' band]) 

    load('aoa_group_wavelet_1000Hz.mat', ['allSubjectMeansUnaware' band]) 
    %% Subtraction and Baseline 
    eval(['avg_wavelet_all_channels_aware_subjects = allSubjectMeansAware' band ' (:,1001:5000,:);'])
    eval(['avg_wavelet_all_channels_unaware_subjects = allSubjectMeansUnaware' band ' (:,1001:5000,:);'])
    
    disp('Baselining data from prestim period')

    %Subtraction
    if isequal(data_type, 'Aware_minus_Unaware')

        %Check if Aware and Unaware are equal sizes
        if not(isequal(size(avg_wavelet_all_channels_aware_subjects,3),size(avg_wavelet_all_channels_unaware_subjects,3)))

            %If more Unaware subjects
            if size(avg_wavelet_all_channels_unaware_subjects,3) > size(avg_wavelet_all_channels_aware_subjects,3)

                %Remove extra subjects from Unaware dataset
                avg_wavelet_all_channels_unaware_subjects(:,:,not(ismember(Unaware_epochs_subjects_list,Aware_epochs_subjects_list))) = [];

            %If more Aware subjects
            elseif size(avg_wavelet_all_channels_aware_subjects,3) > size(avg_wavelet_all_channels_unaware_subjects,3)

                %Remove extra subjects from Unaware dataset
                avg_wavelet_all_channels_aware_subjects(:,:,not(ismember(Aware_epochs_subjects_list,Unaware_epochs_subjects_list))) = [];       

            end

        end

        %Subtract main data from subtract data
        group_pc_data = avg_wavelet_all_channels_aware_subjects - avg_wavelet_all_channels_unaware_subjects;

        %Calculate baseline values [voxel x time x subjects]
        group_pc_baseline = squeeze(nanmean(group_pc_data(:,baseline_window,:),2));

        %Convert baseline [channel x time x subjects]
        group_pc_baseline = permute(repmat(group_pc_baseline,[1,1,4000]),[1,3,2]);

        %Subtract baseline from main data
        group_pc_baselined_data = group_pc_data - group_pc_baseline;

    %No subtraction    
    elseif isequal(data_type, 'Aware')

        %Calculate baseline values [channel x subjects]
        group_pc_baseline = squeeze(nanmean(avg_wavelet_all_channels_aware_subjects(:,baseline_window,:),2));

        %Convert baseline [channel x time x subjects]
        group_pc_baseline = permute(repmat(group_pc_baseline,[1,1,4000]),[1,3,2]);

        %Subtract baseline from main data
        group_pc_baselined_data = avg_wavelet_all_channels_aware_subjects - group_pc_baseline;


    elseif isequal(data_type, 'Unaware')

        %Calculate baseline values [voxel x time x subjects]
        group_pc_baseline = squeeze(nanmean(avg_wavelet_all_channels_unaware_subjects(:,baseline_window,:),2));

        %Convert baseline [channel x time x subjects]
        group_pc_baseline = permute(repmat(group_pc_baseline,[1,1,4000]),[1,3,2]);

        %Subtract baseline from main data
        group_pc_baselined_data = avg_wavelet_all_channels_unaware_subjects - group_pc_baseline;


    end

    %% Neighborhood Matrix

    %Load neighborhood matrix    
    load(fullfile(hood_dir,'net_neighborhood_matrix_257.mat'))

    %% Run Permutation Test

    disp('Running Permutation Test')


    tic

    %INPUTs: 3D data matrix, 2D Neighborhood matrix
    [pval, t_orig, clust_info, seed_state, est_alpha, mn_clust_mass] = EEG_clust_perm1_iceeg_sumt_rand(group_pc_baselined_data, net_neighborhood, num_permutation, 0.05, 0, 0.05, 2, [], 0);

    toc

    %Save output
    cd(save_dir)


    %% Plot Topoplot

    %Plotting Method
    plotting_method = 't';

    %Enter figure folder
    cd(save_dir)

    %Create empty matrix channels by time
    empty_matrix = zeros(257,4000);

    %Find significant clusters pvalue < 0.05 - Negative and positive clusters independently
    pos_clust = find(clust_info.pos_clust_pval < 0.05);
    neg_clust = find(clust_info.neg_clust_pval < 0.05);

    %Loop over postive clusters
    for clust = 1:length(pos_clust)

        %Loop over time
        for time = 1:size(empty_matrix,2)

            %Find postive significant cluster number/idx in voxel x time matrix
            [sig_grid_voxels, col] = find(clust_info.pos_clust_ids(:,time) == pos_clust(clust));

            %Constant
            if isequal(plotting_method, 'c')

                %Give post clusters constant value - find the voxel all volume idx
                empty_matrix(sig_grid_voxels,time) = 0.7;

            %T-value
            elseif isequal(plotting_method, 't')

                %T-value
                empty_matrix(sig_grid_voxels,time) = t_orig(sig_grid_voxels,time);

            end

        end

    end

    %Loop over postive clusters
    for clust = 1:length(neg_clust)

        %Loop over time
        for time = 1:size(empty_matrix,2)

            %Find postive significant cluster number/idx in voxel x time matrix
            [sig_grid_voxels, col] = find(clust_info.neg_clust_ids(:,time) == neg_clust(clust));

            %Constant
            if isequal(plotting_method, 'c')

                %Give post clusters constant value - find the voxel all volume idx
                empty_matrix(sig_grid_voxels,time) = -0.7;

            %T-value
            elseif isequal(plotting_method, 't')

                %T-value
                empty_matrix(sig_grid_voxels,time) = t_orig(sig_grid_voxels,time);

            end

        end

    end
    topoplot_data = empty_matrix;
    save([band '_permutation_stat_cluster_sumt_rand_005_',num2str(num_permutation),'_perm_' data_type '.mat'],'pval','t_orig','clust_info','seed_state','est_alpha','mn_clust_mass' ...
    ,'group_pc_baselined_data','topoplot_data');

    output_end = 1;
end
