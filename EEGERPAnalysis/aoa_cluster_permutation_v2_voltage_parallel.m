
function output_end = aoa_cluster_permutation_v2_voltage_parallel(data_type,window,suffix)
    %% EEG Electrode Based Permutation Analysis 
    
    % Inputs: 
    % data_type: A string of the testing condition (Aware, Unaware, Aware_minus_Unaware)
    % window: string of time range that is tested. Due to the fact that
    % the whole time range is tested, this is set to ''. Future adaptation
    % of this code can use this specification to set this as a variable
    % name and a numeric.
    % suffix: A string which specifies the type of epoch to be used, such as that
    % timelocked to a click, confirm, n-1 confirm, etc. 
    

    %This code will:
    %(1) Load EEG data
    %(2) Baseline data
    %(3) Cluster based permutation analysis 

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
    
    %Specify length of timepoints
    vector_length = 4000;
    
    %Specify time window to use for permutation testing
    time_window = window;



    %% Directories and Variable Names
    
   
    %Variable name
    folder_name ='aoa_cluster_permutation_2024'% 
 

    %Load EEGLab Template
    load('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/aoa_EEGlab_blank.mat');

    %Photogrammetry directory
    Photo_dir = '/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/eeglab14_0_0b/sample_locs/GSN-HydroCel-257.sfp';

    %Data directory
    data_dir = '/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/';

    %Save directory
    save_dir = fullfile('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Cluster_Permutation_Voltage/');

    %Neighborhood matrix directory
    hood_dir = '/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/';


    %Make save directory
    mkdir(save_dir)

    %% Load group voltage data

    cd(data_dir)

    if ~strcmp(suffix, '')
        load(['aoa_group_erp_means_' suffix '.mat']) 
    elseif strcmp(suffix,'')
        load(['aoa_group_erp_means.mat']) 
    end
        
    

    %% Subtraction and Baseline 

    disp('Baselining data from prestim period')

    %Subtraction
    if isequal(data_type, 'Aware_minus_Unaware')

        %Check if Aware and Unaware are equal sizes
        if not(isequal(size(avg_erp_all_channels_aware_subjects,3),size(avg_erp_all_channels_unaware_subjects,3)))

            %If more Unaware subjects
            if size(avg_erp_all_channels_unaware_subjects,3) > size(avg_erp_all_channels_aware_subjects,3)

                %Remove extra subjects from Unaware dataset
                avg_erp_all_channels_unaware_subjects(:,:,not(ismember(Unaware_epochs_subjects_list,Aware_epochs_subjects_list))) = [];

            %If more Aware subjects
            elseif size(avg_erp_all_channels_aware_subjects,3) > size(avg_erp_all_channels_unaware_subjects,3)

                %Remove extra subjects from Unaware dataset
                avg_erp_all_channels_aware_subjects(:,:,not(ismember(Aware_epochs_subjects_list,Unaware_epochs_subjects_list))) = [];       

            end

        end

        %Subtract main data from subtract data
        group_pc_data = avg_erp_all_channels_aware_subjects - avg_erp_all_channels_unaware_subjects;

        %Calculate baseline values [voxel x time x subjects]
        group_pc_baseline = squeeze(nanmean(group_pc_data(:,baseline_window,:),2));

        %Convert baseline [channel x time x subjects]
        group_pc_baseline = permute(repmat(group_pc_baseline,[1,1,vector_length]),[1,3,2]);

        %Subtract baseline from main data
        group_pc_baselined_data = group_pc_data - group_pc_baseline;


    %No subtraction    
    elseif isequal(data_type, 'Aware')

        %Calculate baseline values [channel x subjects]
        group_pc_baseline = squeeze(nanmean(avg_erp_all_channels_aware_subjects(:,baseline_window,:),2));

        %Convert baseline [channel x time x subjects]
        group_pc_baseline = permute(repmat(group_pc_baseline,[1,1,vector_length]),[1,3,2]);

        %Subtract baseline from main data
        group_pc_baselined_data = avg_erp_all_channels_aware_subjects - group_pc_baseline;

    elseif isequal(data_type, 'Unaware')

        %Calculate baseline values [voxel x time x subjects]
        group_pc_baseline = squeeze(nanmean(avg_erp_all_channels_unaware_subjects(:,baseline_window,:),2));

        %Convert baseline [channel x time x subjects]
        group_pc_baseline = permute(repmat(group_pc_baseline,[1,1,vector_length]),[1,3,2]);

        %Subtract baseline from main data
        group_pc_baselined_data = avg_erp_all_channels_unaware_subjects - group_pc_baseline;

    end

    %% Neighborhood Matrix

    %Load neighborhood matrix    
    load(fullfile(hood_dir,'net_neighborhood_matrix_257.mat'))

    %% Run Permutation Test

    disp('Running Permutation Test')

    tic

    %INPUTs: 3D data matrix, 2D Neighborhood matrix
    [pval, t_orig, clust_info, seed_state, est_alpha, mn_clust_mass] = EEG_clust_perm1_iceeg_sumt_rand_parallel(group_pc_baselined_data, ...
        net_neighborhood, num_permutation, 0.05, 0, 0.05, 2, [], 0);

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
    
    % Take the filled empty matrix, and make a new topoplot data matrix out
    % of it.
    topoplot_data = empty_matrix;
    creationFunction = 'aoa_cluster_permutation_v2_voltage_parallel.m';
    if strcmp(suffix, '')
        save(['voltage_permutation_stat_cluster_sumt_rand_005_',num2str(num_permutation),'_perm_' data_type '_' time_window '.mat'],'pval','t_orig','clust_info','seed_state','est_alpha','mn_clust_mass' ...
    ,'group_pc_baselined_data','topoplot_data','creationFunction');
    elseif ~strcmp(suffix,'')
        save(['voltage_permutation_stat_cluster_sumt_rand_005_',num2str(num_permutation),'_perm_' data_type '_' time_window '_' suffix '.mat'],'pval','t_orig','clust_info','seed_state','est_alpha','mn_clust_mass' ...
        ,'group_pc_baselined_data','topoplot_data','creationFunction');
    end

    output_end = 1;
end
