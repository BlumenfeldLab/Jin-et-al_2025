%% Makes topoplots for low-confidence vs high-confidence actions.
function output_end = aoa_make_voltage_png_files_hiConf_loConf(start_times,end_times,suffix)
    set(0,'DefaultFigureRenderer','painters')
    
        
    addpath('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/eeglab14_0_0b/')
    load('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/aoa_EEGlab_blank.mat');
    chanloc_location = '/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/eeglab14_0_0b/sample_locs/GSN-HydroCel-257.sfp';

    eeglab('nogui')
    
    load(['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Cluster_Permutation_Voltage_' suffix '/topoplot_data_filtered20ms_20electrodes_HiConf_all_' suffix '.mat'])
    eeglab_sig_hiConf = topoplot_data_filtered_voltage;
    
    load(['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Cluster_Permutation_Voltage_' suffix '/topoplot_data_filtered20ms_20electrodes_LoConf_all_' suffix '.mat'])
    eeglab_sig_loConf = topoplot_data_filtered_voltage;
    
    load(['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Cluster_Permutation_Voltage_' suffix '/topoplot_data_filtered20ms_20electrodes_HiConf_minus_LoConf_all_' suffix '.mat'])
    eeglab_sig_difference = topoplot_data_filtered_voltage;
    

    %load('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Long_Epochs_For_Time_Frequency/aoa_group_erp_means_v2.mat','allSubjectMeansHiConf','allSubjectMeansLoConf');
    load(['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/aoa_group_erp_means_' suffix '.mat'])
    allSubjectMeansHiConf = avg_erp_all_channels_hiConf_subjects;
    allSubjectMeansLoConf = avg_erp_all_channels_loConf_subjects;

    %%

    mkdir(['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Cluster_Permutation_Voltage_' suffix '/Composite_Topoplots/'])
    cd(['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Cluster_Permutation_Voltage_' suffix '/Composite_Topoplots/'])

%     start_times = -1995:5:1990;
%     end_times = -1990:5:1995;
%     parpool(feature('NumCores'));
    
    for time = 1:length(start_times)
        close all
        start_time = start_times(time);
        end_time = end_times(time);

        sig_channels = find(abs(eeglab_sig_hiConf(:,start_time+2000))>0)

        EEGlab_blank_hiConf = EEGlab_blank;
        EEGlab_blank_hiConf.data = mean(allSubjectMeansHiConf,3);
        EEGlab_blank_hiConf.xmin = -1.999;
        EEGlab_blank_hiConf.xmax = 2;
        EEGlab_blank_hiConf.pnts = 4000;
        EEGlab_blank_hiConf.chanlocs = readlocs(chanloc_location);
        pop_topoplot(EEGlab_blank_hiConf,1, start_time:5:end_time, ['ERP Scalp Topographies, HiConf All Data'],[4:2] ,0, 'electrodes', 'off','gridscale',50,'intrad',[0.5],'maplimits',[-3,3],'style','map','emarker2',{sig_channels,'o',[1 1 1],6,1});

        set(gcf, 'WindowState', 'maximized')

        fig = gcf;
        hiConfChildren = get(fig,'Children')
        set(gcf, 'WindowState', 'maximized')
        set(gca,'FontSize',24)
      
        sig_channels = find(abs(eeglab_sig_loConf(:,start_time+2000))>0)

        EEGlab_blank_loConf = EEGlab_blank;
        EEGlab_blank_loConf.data = mean(allSubjectMeansLoConf,3);
        EEGlab_blank_loConf.xmin = -1.999;
        EEGlab_blank_loConf.xmax = 2;
        EEGlab_blank_loConf.pnts = 4000;
        EEGlab_blank_loConf.chanlocs = readlocs(chanloc_location);
        pop_topoplot(EEGlab_blank_loConf,1, start_time:5:end_time, ['ERP Scalp Topographies, LoConf All Data'],[4:2] ,0, 'electrodes', 'off','gridscale',50,'intrad',[0.5],'maplimits',[-3,3],'style','map','emarker2',{sig_channels,'o',[1 1 1],6,1});
        fig = gcf;
        loConfChildren = get(fig,'Children')
        set(gcf, 'WindowState', 'maximized')
        set(gca,'FontSize',24)


        sig_channels = find(abs(eeglab_sig_difference(:,start_time+2000))>0)

        EEGlab_blank_diff = EEGlab_blank;
        EEGlab_blank_diff.data = mean(allSubjectMeansHiConf,3) - mean(allSubjectMeansLoConf,3);
        EEGlab_blank_diff.xmin = -1.999;
        EEGlab_blank_diff.xmax = 2;
        EEGlab_blank_diff.pnts = 4000;
        EEGlab_blank_diff.chanlocs = readlocs(chanloc_location);
        pop_topoplot(EEGlab_blank_diff,1, start_time:5:end_time, ['ERP Scalp Topographies, HiConf - LoConf All Data'],[4:2] ,0, 'electrodes', 'off','gridscale',50,'intrad',[0.5],'maplimits',[-3,3],'style','map','emarker2',{sig_channels,'o',[1 1 1],6,1});

        fig = gcf;
        hiConfminusloConfChildren = get(fig,'Children')
        set(gcf, 'WindowState', 'maximized')
        set(gca,'FontSize',24)

        f2 = figure;
        set(gcf,'Color','w');
        copyobj([hiConfChildren(4) loConfChildren(4) hiConfminusloConfChildren(4) hiConfminusloConfChildren(2)],f2);colormap jet
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
        ax3(1).Title.String = ['HiConf ' abs(num2str(start_time)) ' ms'];
        ax3(2).Title.String = ['LoConf ' abs(num2str(start_time)) ' ms'];
        ax3(3).Title.String = ['HiConf-LoConf ' abs(num2str(start_time)) ' ms'];
        set(gcf, 'WindowState', 'maximized')
        if start_time < 0
            saveas(gcf,['minus' num2str(start_time) 'ms_Composite_Band.png'])
            saveas(gcf,['minus' num2str(start_time) 'ms_Composite_Band.fig'])
            saveas(gcf,['minus' num2str(start_time) 'ms_Composite_Band.eps'],'epsc')
        elseif start_time >= 0
            saveas(gcf,[num2str(start_time) 'ms_Composite_Band.png'])
            saveas(gcf,[num2str(start_time) 'ms_Composite_Band.fig'])
            saveas(gcf,[num2str(start_time) 'ms_Composite_Band.eps'],'epsc')
        end

    end
    output_end = 1;
end
    