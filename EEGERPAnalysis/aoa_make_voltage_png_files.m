%% This script makes the composite topoplots between the given start times and end times. 
function output_end = aoa_make_voltage_png_files(start_times,end_times,suffix)
    set(0,'DefaultFigureRenderer','painters')
    
        
    addpath('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/eeglab14_0_0b/')
    load('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/aoa_EEGlab_blank.mat');
    chanloc_location = '/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/eeglab14_0_0b/sample_locs/GSN-HydroCel-257.sfp';

    eeglab('nogui')
    
    %% Load topoplots for aware, unaware, and their difference
    load(['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Cluster_Permutation_Voltage_' suffix '/topoplot_data_filtered20ms_20electrodes_Aware_all_' suffix '.mat'])
    eeglab_sig_aware = topoplot_data_filtered_voltage;
    
    load(['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Cluster_Permutation_Voltage_' suffix '/topoplot_data_filtered20ms_20electrodes_Unaware_all_' suffix '.mat'])
    eeglab_sig_unaware = topoplot_data_filtered_voltage;
    
    load(['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Cluster_Permutation_Voltage_' suffix '/topoplot_data_filtered20ms_20electrodes_Aware_minus_Unaware_all_' suffix '.mat'])
    eeglab_sig_difference = topoplot_data_filtered_voltage;
    

    load(['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/aoa_group_erp_means_' suffix '.mat'])
    allSubjectMeansAware = avg_erp_all_channels_aware_subjects;
    allSubjectMeansUnaware = avg_erp_all_channels_unaware_subjects;

    

    mkdir(['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Cluster_Permutation_Voltage_' suffix '/Composite_Topoplots/'])
    cd(['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Cluster_Permutation_Voltage_' suffix '/Composite_Topoplots/'])
    %% Iterate over all desired times, making the topoplot for that time
    % Only the significant channels from analyzing voltage size are
    % displayed on the topoplots.
    for time = 1:length(start_times)
        close all
        start_time = start_times(time);
        end_time = end_times(time);

        sig_channels = find(abs(eeglab_sig_aware(:,start_time+2000))>0)

        EEGlab_blank_aware = EEGlab_blank;
        EEGlab_blank_aware.data = mean(allSubjectMeansAware,3);
        EEGlab_blank_aware.xmin = -1.999;
        EEGlab_blank_aware.xmax = 2;
        EEGlab_blank_aware.pnts = 4000;
        EEGlab_blank_aware.chanlocs = readlocs(chanloc_location);
        pop_topoplot(EEGlab_blank_aware,1, start_time:5:end_time, ['ERP Scalp Topographies, Aware All Data'],[4:2] ,0, 'electrodes', 'off','gridscale',50,'intrad',[0.5],'maplimits',[-3,3],'style','map','emarker2',{sig_channels,'o',[1 1 1],6,1});

        set(gcf, 'WindowState', 'maximized')

        fig = gcf;
        awareChildren = get(fig,'Children')
        set(gcf, 'WindowState', 'maximized')
        set(gca,'FontSize',24)
      
        sig_channels = find(abs(eeglab_sig_unaware(:,start_time+2000))>0)

        EEGlab_blank_unaware = EEGlab_blank;
        EEGlab_blank_unaware.data = mean(allSubjectMeansUnaware,3);
        EEGlab_blank_unaware.xmin = -1.999;
        EEGlab_blank_unaware.xmax = 2;
        EEGlab_blank_unaware.pnts = 4000;
        EEGlab_blank_unaware.chanlocs = readlocs(chanloc_location);
        pop_topoplot(EEGlab_blank_unaware,1, start_time:5:end_time, ['ERP Scalp Topographies, Unaware All Data'],[4:2] ,0, 'electrodes', 'off','gridscale',50,'intrad',[0.5],'maplimits',[-3,3],'style','map','emarker2',{sig_channels,'o',[1 1 1],6,1});
        fig = gcf;
        unawareChildren = get(fig,'Children')
        set(gcf, 'WindowState', 'maximized')
        set(gca,'FontSize',24)


        sig_channels = find(abs(eeglab_sig_difference(:,start_time+2000))>0)

        EEGlab_blank_diff = EEGlab_blank;
        EEGlab_blank_diff.data = mean(allSubjectMeansAware,3) - mean(allSubjectMeansUnaware,3);
        EEGlab_blank_diff.xmin = -1.999;
        EEGlab_blank_diff.xmax = 2;
        EEGlab_blank_diff.pnts = 4000;
        EEGlab_blank_diff.chanlocs = readlocs(chanloc_location);
        pop_topoplot(EEGlab_blank_diff,1, start_time:5:end_time, ['ERP Scalp Topographies, Aware - Unaware All Data'],[4:2] ,0, 'electrodes', 'off','gridscale',50,'intrad',[0.5],'maplimits',[-3,3],'style','map','emarker2',{sig_channels,'o',[1 1 1],6,1});

        fig = gcf;
        awareminusunawareChildren = get(fig,'Children')
        set(gcf, 'WindowState', 'maximized')
        set(gca,'FontSize',24)

        f2 = figure;
        set(gcf,'Color','w');
        copyobj([awareChildren(4) unawareChildren(4) awareminusunawareChildren(4) awareminusunawareChildren(2)],f2);colormap jet
        ax3 = get(f2,'children')
        ax3(1).Position(1) = 0;
        ax3(2).Position(1) = 0.3;
        ax3(3).Position(1) = 0.6;
        ax3(1).Position(2) = 0.25;
        ax3(2).Position(2) = 0.25;
        ax3(3).Position(2) = 0.25;
        ax3(1).Position(4) = 0.6;
        ax3(2).Position(4) = 0.6;
        ax3(3).Position(4) = 0.6;
        ax3(1).FontSize = 24;
        ax3(2).FontSize = 24;
        ax3(3).FontSize = 24;
        ax3(4).FontSize = 24;
        ax3(1).Title.String = ['Aware ' abs(num2str(start_time)) ' ms'];
        ax3(2).Title.String = ['Unaware ' abs(num2str(start_time)) ' ms'];
        ax3(3).Title.String = ['Aware-Unaware ' abs(num2str(start_time)) ' ms'];
        set(gcf, 'WindowState', 'maximized')
        if start_time < 0
            saveas(gcf,['minus' num2str(start_time) 'ms_Composite.png'])
            saveas(gcf,['minus' num2str(start_time) 'ms_Composite.fig'])
            saveas(gcf,['minus' num2str(start_time) 'ms_Composite.eps'],'epsc')
        elseif start_time >= 0
            saveas(gcf,[num2str(start_time) 'ms_Composite.png'])
            saveas(gcf,[num2str(start_time) 'ms_Composite.fig'])
            saveas(gcf,[num2str(start_time) 'ms_Composite.eps'],'epsc')
        end

    end
    output_end = 1;
end
    
