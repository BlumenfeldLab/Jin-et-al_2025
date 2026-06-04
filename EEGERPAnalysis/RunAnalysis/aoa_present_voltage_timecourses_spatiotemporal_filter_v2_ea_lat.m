%% Presents early vs late data for delays ('gaps') and runs ('runs').
saveFigures = true;
set(0,'DefaultFigureRenderer','Painters')

location = 'd'
without_blinks = false;
without_stdev_diff = true;
saveSuffix = 'gaps'; % This is the suffix for the filtered topoplot data
suffix = 'split_designations_raw'; % This is the suffix for the unfiltered topoplot data
condition = 'unaware';


if strcmp(location,'s')

    root = '/mnt/Data27/HNCT_AoA_Study/AoA_Subjects/';
    % eeglabLocation = '/mnt/Data27/HNCT_AoA_Study/eeglab14_0_0b';
        % Photo_dir = '/mnt/Data27/HNCT_AoA_Study/eeglab14_0_0b/sample_locs/GSN-HydroCel-257.sfp';
    dataRoot = '/mnt/Data27/HNCT_AoA_Study/HPC_Analyses/';
    addpath(dataRoot)
    
end
if strcmp(location,'l')
    root = 'Y:/HNCT_AoA_Study/AoA_Subjects/';
    eeglabLocation = 'Y:/HNCT_AoA_Study/eeglab14_0_0b';
    Photo_dir = 'Y:\HNCT_AoA_Study\eeglab14_0_0b\sample_locs\GSN-HydroCel-257.sfp';
    dataRoot = 'Y:\HNCT_AoA_Study\HPC_Analyses\';
end
if strcmp(location,'d')
    root = 'D:/'
    eeglabLocation = 'D:/eeglab-current/eeglab2023.0/';
    Photo_dir = 'D:/eeglab-current/eeglab2023.0/sample_locs/GSN-Hydrocel-257.sfp';
    dataRoot = 'D:\Spatiotemporal_Filter\Cluster_Permutation_Voltage_v2/'
end
mkdir([dataRoot '\Cluster_Permutation_Voltage_v2/Spatiotemporal_Filter/' saveSuffix])
% addpath(eeglabLocation)
% eeglab('nogui')
data_dir = [dataRoot '/Cluster_Permutation_Voltage_v2/'];

if strcmp(condition,'aware')
    load([dataRoot '\topoplot_data_filtered20ms_20electrodes_Aware_Early_Late_all_' saveSuffix '.mat'])
    folderName = 'Aware_Early_Late';
elseif strcmp(condition,'unaware')
    load([dataRoot '\topoplot_data_filtered20ms_20electrodes_Unaware_Early_Late_all_' saveSuffix '.mat'])
    folderName = 'Unaware_Early_Late';
end
load([root '/aoa_group_erp_means_' suffix '_early.mat'])
eval(['avg_erp_all_channels_early_subjects = avg_erp_all_channels_' condition '_subjects;']);
load([root '/aoa_group_erp_means_' suffix '_late.mat'])
eval(['avg_erp_all_channels_late_subjects = avg_erp_all_channels_' condition '_subjects;']);




topoplot_data_filtered_temp = [];

%%
cd([dataRoot])
mkdir(suffix)
cd(suffix)
mkdir(condition)
cd(condition)
clims = [-3.5 3.5];
close all
clc
electrodeSubset = [5 155 127 164]
for channel = 1:length(electrodeSubset)
    electrodeChannel = electrodeSubset(channel);
    
    % Define your vector
    vector = topoplot_data_filtered_voltage(electrodeChannel,:);
    
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
    
    


    sig_line = NaN(1,4000);
    % sig_line(result_vector > 0) = clims(2)-0.5;
    
    sig_line(result_vector >= 20) = clims(2);
    
    
    mean_voltage_early_trace = mean(avg_erp_all_channels_early_subjects(electrodeChannel,:,:),3);
    mean_voltage_early_sem = std(squeeze(avg_erp_all_channels_early_subjects(electrodeChannel,:,:))')/sqrt(size(avg_erp_all_channels_early_subjects,3));
    
    mean_voltage_late_trace = mean(avg_erp_all_channels_late_subjects(electrodeChannel,:,:),3);
    mean_voltage_late_sem = std(squeeze(avg_erp_all_channels_late_subjects(electrodeChannel,:,:))')/sqrt(size(avg_erp_all_channels_late_subjects,3));
    
    mean_voltage_early_high = mean_voltage_early_trace + mean_voltage_early_sem;
    mean_voltage_early_low = mean_voltage_early_trace - mean_voltage_early_sem;
    
    mean_voltage_late_high = mean_voltage_late_trace + mean_voltage_late_sem;
    mean_voltage_late_low = mean_voltage_late_trace - mean_voltage_late_sem;
    
    lpFilt = designfilt('lowpassfir','PassbandFrequency',8, ...
    'StopbandFrequency',14,'PassbandRipple',1, ...
    'StopbandAttenuation',65,'DesignMethod','kaiserwin','SampleRate',1000);
    lowpass_early_high = filtfilt(lpFilt,mean_voltage_early_trace+mean_voltage_early_sem);
    lowpass_early_low = filtfilt(lpFilt,mean_voltage_early_trace-mean_voltage_early_sem);
    lowpass_late_high = filtfilt(lpFilt,mean_voltage_late_trace+mean_voltage_late_sem);
    lowpass_late_low = filtfilt(lpFilt,mean_voltage_late_trace-mean_voltage_late_sem);


    if saveFigures
        % if sum(isnan(sig_line(1001:3000))) == 2000
        %     continue
        % end
        f = figure('units','normalized','outerposition',[0 0 1 1]);
        
        
        
        
        hold on; 
        line([0 0],clims)
        line([-2000 2000],[0 0])
        xlabel(['Time from Confirm (ms)'])
        ylabel(['Voltage (uV)'])

        if strcmp(condition,'aware')
            latePatchColor = [0 1 1];
            earlyPatchColor = [0 0 1];
            lateTraceColor = [0.5 0.7 1 0.7];
            earlyTraceColor = [0 0 1 0.7];
        elseif strcmp(condition,'unaware')
            earlyPatchColor = [1 0.7 0];
            earlyTraceColor = [1 0.7 0 0.7];
            latePatchColor = [1 0 0];
            lateTraceColor = [1 0 0 0.7]
        end
        patch([-1999:2000 fliplr(-1999:2000)], [lowpass_early_low fliplr(lowpass_early_high)], earlyPatchColor,'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
        patch([-1999:2000 fliplr(-1999:2000)], [lowpass_late_low fliplr(lowpass_late_high)], latePatchColor,'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
        
        erp_legend = plot(-1999:2000,filtfilt(lpFilt,mean_voltage_early_trace),'Color',earlyTraceColor,'LineWidth',5);
        erp_legend = [erp_legend plot(-1999:2000,filtfilt(lpFilt,mean_voltage_late_trace),'Color',lateTraceColor,'LineWidth',5)];
        
        plot(-1999:2000,sig_line,'Color',[.863, .078, .235],'LineWidth',20)
        
        title(['Voltage (μV), Electrode ' num2str(electrodeChannel) ', ' suffix ' Early vs Late ' condition])
        ylim(clims)
        xlim([-1000 1000])
        set(gca,'FontSize',24)
        hLegend = legend(erp_legend,{'Early','Late'});
        set(hLegend, 'Location', 'southeast', 'Orientation', 'vertical');
    
    
        saveas(f,['E' num2str(electrodeChannel) '_Voltage_Timecourse.fig'])
        saveas(f,['E' num2str(electrodeChannel) '_Voltage_Timecourse.png'])
        saveas(f,['E' num2str(electrodeChannel) '_Voltage_Timecourse.eps'])
        close all
    end
    topoplot_data_filtered_temp = [topoplot_data_filtered_temp; result_vector];

end

topoplot_data_filtered_voltage = topoplot_data_filtered_temp;

