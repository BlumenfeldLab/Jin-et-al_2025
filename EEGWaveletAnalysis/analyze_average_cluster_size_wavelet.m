%% This script looks over all the clusters following permutation analysis in spectral analyses
% Clusters which are too small in size or duration are eliminated for
% timecourse presentation.

close all
addpath('Y:\HNCT_AoA_Study\HPC_Analyses\Cluster_Permutation_Voltage_v2')
cd('Y:\HNCT_AoA_Study\HPC_Analyses\Cluster_Permutation_Voltage_v2')
data_type = 'Aware_minus_Unaware_all'
bands = {'Alpha','Beta','Theta'};
timeMin = 200;
electrodeMin = 10;
creationFunction = 'analyze_average_cluster_size_wavelet.m';
creationDate = string(datetime('now'))
for band = 1:length(bands)
    currentBand = bands{band}
    load([currentBand '_permutation_stat_cluster_sumt_rand_005_5000_perm_' data_type '.mat'])
    eval(['pval_' currentBand ' = pval;'])
       

    averageClusterSize = zeros(1,257);
    allClusterSizes = [];
    % Evaluate individual channels for cluster durations and extents
    for electrodeChannel = 1:257
        disp(['Evaluating ' currentBand ' band, channel ' num2str(electrodeChannel)])
        currentChannelClusterStarts = [];
        currentChannelClusterEnds = [];
        for timepoint = 1:size(pval,2)
            if timepoint == 1 && pval(electrodeChannel, timepoint) < 0.05
                currentChannelClusterStarts = [currentChannelClusterStarts timepoint];
            end
            if timepoint == size(pval,2) && pval(electrodeChannel, timepoint) < 0.05
                currentChannelClusterEnds = [currentChannelClusterEnds timepoint];
            end
            if timepoint >= 2 && pval(electrodeChannel, timepoint-1) >= 0.05 && pval(electrodeChannel, timepoint) < 0.05
                currentChannelClusterStarts = [currentChannelClusterStarts timepoint];
            end
            if timepoint < size(pval,2) && pval(electrodeChannel, timepoint+1) >= 0.05 && pval(electrodeChannel, timepoint) < 0.05
                currentChannelClusterEnds = [currentChannelClusterEnds timepoint];
            end
        end
        currentChannelClusterDiffs = currentChannelClusterEnds - currentChannelClusterStarts + 1;
        allClusterSizes = [allClusterSizes currentChannelClusterDiffs];
        averageClusterSize(electrodeChannel) = median(currentChannelClusterDiffs);
    end
    eval(['allClusterSizes_' currentBand ' = allClusterSizes;'])
    eval(['averageClusterSize_' currentBand ' = averageClusterSize;'])
    topoplot_data(topoplot_data < 0) = -1;
    topoplot_data(topoplot_data > 0) = 1;
    eval(['topoplot_data_' currentBand ' = topoplot_data;'])
    eval(['clust_info_' currentBand ' = clust_info;'])
    topoplot_data_scaled = topoplot_data;
    pos_clust_total = max(unique(clust_info.pos_clust_ids));
    pos_clust_values = 0:(1/pos_clust_total):1;
    pos_clust_values = pos_clust_values(2:end);
    
    for cluster = 1:pos_clust_total;
        topoplot_data_scaled(clust_info.pos_clust_ids ==  cluster) = pos_clust_values(cluster);
    end
    
    neg_clust_total = max(unique(clust_info.neg_clust_ids));
    neg_clust_values = 0:-(1/neg_clust_total):-1;
    neg_clust_values = neg_clust_values(2:end);
    for cluster = 1:neg_clust_total;
        topoplot_data_scaled(clust_info.neg_clust_ids ==  cluster) = neg_clust_values(cluster);
    end
    eval( ['topoplot_data_scaled_' currentBand ' = topoplot_data_scaled;'])
    figure
    hold on
    eval(['imagesc(topoplot_data_scaled_' currentBand ')'])
    ylim([0 257])
    xlim([0 4000])
    set(gcf, 'WindowState', 'maximized')
    xt = get(gca, 'XTick');
    set(gca, 'XTick',xt, 'XTickLabel',[-2000:500:2000])
    set(gca,'FontSize',24)
    colormap('jet')
    caxis([-1 1])
    ylabel('Electrode Channel')
    xlabel('Time from Confirm')
    title(['Clusters and Electrodes, ' num2str(currentBand)])
    drawnow
    
    all_cluster_electrode_counts_pos = zeros(1,pos_clust_total);
    for cluster = 1:pos_clust_total
        all_cluster_electrode_counts_pos(cluster) = sum(sum(clust_info.pos_clust_ids == cluster, 2) > 0);
    end
    
    all_cluster_timepoints_counts_pos = zeros(1,pos_clust_total);
    for cluster = 1:pos_clust_total
        all_cluster_timepoints_counts_pos(cluster) = sum(sum(clust_info.pos_clust_ids == cluster, 1) > 0);
    end
    
    all_cluster_electrode_counts_neg = zeros(1,neg_clust_total);
    for cluster = 1:neg_clust_total
        all_cluster_electrode_counts_neg(cluster) = sum(sum(clust_info.neg_clust_ids == cluster, 2) > 0);
    end
    
    all_cluster_timepoints_counts_neg = zeros(1,neg_clust_total);
    for cluster = 1:neg_clust_total
        all_cluster_timepoints_counts_neg(cluster) = sum(sum(clust_info.neg_clust_ids == cluster, 1) > 0);
    end
    
    all_cluster_electrode_counts = [all_cluster_electrode_counts_pos all_cluster_electrode_counts_neg];
    all_cluster_timepoints_counts = [all_cluster_timepoints_counts_pos all_cluster_timepoints_counts_neg];
    figure;
    title(['Cluster Details, ' currentBand])
    subplot(1,2,1)
    bar(categorical(1:pos_clust_total+neg_clust_total),all_cluster_electrode_counts);
    set(gca,'FontSize',24)
    set(gca,'xtick',[])
    ylim([0 150])
    ylabel(['Number of Electrodes Contained in Cluster'])
    xlabel([currentBand ' Clusters'])
    subplot(1,2,2)
    bar(categorical(1:pos_clust_total+neg_clust_total),all_cluster_timepoints_counts);
    set(gca,'FontSize',24)
    set(gca,'xtick',[])
    ylabel(['Duration of Cluster (ms)'])
    xlabel([currentBand ' Clusters'])
    

    topoplot_data_filtered = topoplot_data_scaled;
    for cluster = 1:pos_clust_total
        if all_cluster_electrode_counts_pos(cluster) < electrodeMin || all_cluster_timepoints_counts_pos(cluster) < timeMin;
            topoplot_data_filtered(clust_info.pos_clust_ids ==  cluster) = 0;
        end
    end
    for cluster = 1:neg_clust_total
        if all_cluster_electrode_counts_neg(cluster) < electrodeMin || all_cluster_timepoints_counts_neg(cluster) < timeMin;
            topoplot_data_filtered(clust_info.neg_clust_ids ==  cluster) = 0;
        end
    end
    eval( ['topoplot_data_filtered_' currentBand ' = topoplot_data_filtered;'])

    figure
    hold on
    eval(['imagesc(topoplot_data_filtered_' currentBand ')'])
    ylim([0 257])
    xlim([0 4000])
    set(gcf, 'WindowState', 'maximized')
    xt = get(gca, 'XTick');
    set(gca, 'XTick',xt, 'XTickLabel',[-2000:500:2000])
    set(gca,'FontSize',24)
    colormap('jet')
    caxis([-1 1])
    ylabel('Electrode Channel')
    xlabel('Time from Confirm')
    title(['Clusters and Electrodes, min ' num2str(timeMin)  ' (ms), ' num2str(electrodeMin) ' electrodes, ' num2str(currentBand)])
    drawnow
    
    % Add criterion that the timecourse must be 20ms continuous
    for channel = 1:257
         % Define your vector
        vector = topoplot_data_filtered_voltage(channel,:);
        
        % Find the differences between consecutive elements
        differences = diff([0 vector]);
        
        % Find the indices where the sequences of increasing numbers start
        start_indices_pos = find(differences > 0);
        
        % Find the indices where the sequences of decreasing numbers start
        start_indices_neg = find(differences < 0);
        
        % Find the indices where the sequences of increasing numbers end
        end_indices_pos = find(differences < 0);
        
        % Find the indices where the sequences of decreasing numbers end
        end_indices_neg = find(differences > 0);
        
        % Calculate the lengths of each sequence of increasing numbers
        sequence_lengths_pos = end_indices_pos - start_indices_pos + 1;
        
        % Calculate the lengths of each sequence of decreasing numbers
        sequence_lengths_neg = end_indices_neg - start_indices_neg + 1;
        
        % Initialize the result vector
        result_vector = zeros(size(vector));
        
        % Assign the sequence lengths to the corresponding positions in the result vector
        for i = 1:numel(start_indices_pos)
            result_vector(start_indices_pos(i):end_indices_pos(i)) = sequence_lengths_pos(i);
        end
        
        for i = 1:numel(start_indices_neg)
            result_vector(start_indices_neg(i):end_indices_neg(i)) = sequence_lengths_neg(i);
        end

        result_vector(result_vector <= 20) = 0;
    end
    
end 

save(['topoplot_data_filtered' num2str(timeMin) 'ms_' num2str(electrodeMin) 'electrodes_' data_type '.mat'],'topoplot_data_filtered_voltage','creationFunction','creationDate');
