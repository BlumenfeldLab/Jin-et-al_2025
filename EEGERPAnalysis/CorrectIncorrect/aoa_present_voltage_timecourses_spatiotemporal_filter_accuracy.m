%% Presents voltage timecourses for correctly vs incorrectly identified actions.
saveFigures = true;
set(0,'DefaultFigureRenderer','Painters')

location = 'd'
without_blinks = false;
without_stdev_diff = true;
suffix = 'correct_incorrect';
if strcmp(location,'s')

    root = '/mnt/Data27/HNCT_AoA_Study/AoA_Subjects/';
    dataRoot = '/mnt/Data27/HNCT_AoA_Study/HPC_Analyses/';
    addpath(dataRoot)
    
end
if strcmp(location,'l')
    root = 'Y:/HNCT_AoA_Study/AoA_Subjects/';
    dataRoot = 'Y:\HNCT_AoA_Study\HPC_Analyses\';
end
if strcmp(location,'d')
    root = 'D:/'
    dataRoot = 'D:\Spatiotemporal_Filter\Cluster_Permutation_Voltage_v2/'
end
mkdir([dataRoot '\Cluster_Permutation_Voltage_v2/Spatiotemporal_Filter/' suffix])

data_dir = [dataRoot '/Cluster_Permutation_Voltage_v2/'];
load([dataRoot '\topoplot_data_filtered20ms_20electrodes_Correct_minus_Incorrect_all_' suffix '.mat'])

load([root '/aoa_group_erp_means_' suffix '.mat'])
electrodeSubset = [5 155 127 164]
% avg_erp_all_channels_correct_subjects = allSubjectMeansCorrect(:,1001:5000,:);
% avg_erp_all_channels_incorrect_subjects = allSubjectMeansIncorrect(:,1001:5000,:);

topoplot_data_filtered_temp = [];

%%
cd([dataRoot])
mkdir(suffix)
cd(suffix)
clims = [-3.5 3.5];
close all
clc
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
    
    sig_line(result_vector >= 20) = clims(2)-0.5;
    
    
    mean_voltage_correct_trace = mean(avg_erp_all_channels_correct_subjects(electrodeChannel,:,:),3);
    mean_voltage_correct_sem = std(squeeze(avg_erp_all_channels_correct_subjects(electrodeChannel,:,:))')/sqrt(size(avg_erp_all_channels_correct_subjects,3));
    
    mean_voltage_incorrect_trace = mean(avg_erp_all_channels_incorrect_subjects(electrodeChannel,:,:),3);
    mean_voltage_incorrect_sem = std(squeeze(avg_erp_all_channels_incorrect_subjects(electrodeChannel,:,:))')/sqrt(size(avg_erp_all_channels_incorrect_subjects,3));
    
    mean_voltage_correct_high = mean_voltage_correct_trace + mean_voltage_correct_sem;
    mean_voltage_correct_low = mean_voltage_correct_trace - mean_voltage_correct_sem;
    
    mean_voltage_incorrect_high = mean_voltage_incorrect_trace + mean_voltage_incorrect_sem;
    mean_voltage_incorrect_low = mean_voltage_incorrect_trace - mean_voltage_incorrect_sem;
    
    lpFilt = designfilt('lowpassfir','PassbandFrequency',8, ...
    'StopbandFrequency',14,'PassbandRipple',1, ...
    'StopbandAttenuation',65,'DesignMethod','kaiserwin','SampleRate',1000);
    lowpass_correct_high = filtfilt(lpFilt,mean_voltage_correct_trace+mean_voltage_correct_sem);
    lowpass_correct_low = filtfilt(lpFilt,mean_voltage_correct_trace-mean_voltage_correct_sem);
    lowpass_incorrect_high = filtfilt(lpFilt,mean_voltage_incorrect_trace+mean_voltage_incorrect_sem);
    lowpass_incorrect_low = filtfilt(lpFilt,mean_voltage_incorrect_trace-mean_voltage_incorrect_sem);


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
        patch([-1999:2000 fliplr(-1999:2000)], [lowpass_correct_low fliplr(lowpass_correct_high)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
        patch([-1999:2000 fliplr(-1999:2000)], [lowpass_incorrect_low fliplr(lowpass_incorrect_high)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
        
        erp_legend = plot(-1999:2000,filtfilt(lpFilt,mean_voltage_correct_trace),'Color',[0 0 1 0.7],'LineWidth',5);
        erp_legend = [erp_legend plot(-1999:2000,filtfilt(lpFilt,mean_voltage_incorrect_trace),'Color',[1 0.7 0 0.7],'LineWidth',5)];
        
        plot(-1999:2000,sig_line,'Color',[.863, .078, .235],'LineWidth',20)
        
        title(['Voltage (μV), Electrode ' num2str(electrodeChannel) ', ' suffix])
        ylim(clims)
        xlim([-1000 1000])
        set(gca,'FontSize',24)
        hLegend = legend(erp_legend,{'Correct','Incorrect'});
        set(hLegend, 'Location', 'southeast', 'Orientation', 'vertical');
    
    
        saveas(f,['E' num2str(electrodeChannel) '_Voltage_Timecourse.fig'])
        saveas(f,['E' num2str(electrodeChannel) '_Voltage_Timecourse.png'])
        saveas(f,['E' num2str(electrodeChannel) '_Voltage_Timecourse.eps'])
        close all
    end
    topoplot_data_filtered_temp = [topoplot_data_filtered_temp; result_vector];

end

topoplot_data_filtered_voltage = topoplot_data_filtered_temp;

