% Creates topoplot pngs for early vs late delay ("raw") or run ("runs") data. Can compare both early aware vs late aware, or early aware vs early unaware (same with late).
function output_end = aoa_make_voltage_png_files_early_late(start_times,end_times,suffix1,suffix2,condition,saveSuffix)
    set(0,'DefaultFigureRenderer','painters')
    
    if strcmp(condition,'aware')
        capCondition = 'Aware';
    end
    if strcmp(condition,'unaware')
        capCondition = 'Unaware';
    end
    addpath('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/eeglab14_0_0b/')
    load('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/aoa_EEGlab_blank.mat');
    chanloc_location = '/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/eeglab14_0_0b/sample_locs/GSN-HydroCel-257.sfp';

    eeglab('nogui')
    
    load(['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Cluster_Permutation_Voltage_' saveSuffix '/' condition '/topoplot_data_filtered20ms_20electrodes_' capCondition '_all_' suffix1 '.mat'])
    eeglab_sig_early = topoplot_data_filtered_voltage;
    
    load(['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Cluster_Permutation_Voltage_' saveSuffix '/' condition '/topoplot_data_filtered20ms_20electrodes_' capCondition '_all_' suffix2 '.mat'])
    eeglab_sig_late = topoplot_data_filtered_voltage;
    
    load(['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Cluster_Permutation_Voltage_' saveSuffix '/' condition '/topoplot_data_filtered20ms_20electrodes_' capCondition '_Early_Late_all_' saveSuffix '.mat'])
    eeglab_sig_difference = topoplot_data_filtered_voltage;
    

    %load('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Long_Epochs_For_Time_Frequency/aoa_group_erp_means_v2.mat','allSubjectMeansEarly','allSubjectMeansLate');
    load(['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/aoa_group_erp_means_' suffix1 '.mat'])
    eval(['allSubjectMeansEarly = avg_erp_all_channels_' condition '_subjects;'])
    
    load(['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/aoa_group_erp_means_' suffix2 '.mat'])
    eval(['allSubjectMeansLate = avg_erp_all_channels_' condition '_subjects;'])

    %%

    mkdir(['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Cluster_Permutation_Voltage_' saveSuffix '/' condition '/Composite_Topoplots/'])
    cd(['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Cluster_Permutation_Voltage_' saveSuffix '/' condition '/Composite_Topoplots/'])

%     start_times = -1995:5:1990;
%     end_times = -1990:5:1995;
%     parpool(feature('NumCores'));
    
    for time = 1:length(start_times)
        close all
        start_time = start_times(time);
        end_time = end_times(time);

        sig_channels = find(abs(eeglab_sig_early(:,start_time+2000))>0)

        EEGlab_blank_early = EEGlab_blank;
        EEGlab_blank_early.data = mean(allSubjectMeansEarly,3);
        EEGlab_blank_early.xmin = -1.999;
        EEGlab_blank_early.xmax = 2;
        EEGlab_blank_early.pnts = 4000;
        EEGlab_blank_early.chanlocs = readlocs(chanloc_location);
        pop_topoplot(EEGlab_blank_early,1, start_time:5:end_time, ['ERP Scalp Topographies, Early All Data'],[4:2] ,0, 'electrodes', 'off','gridscale',50,'intrad',[0.5],'maplimits',[-3,3],'style','map','emarker2',{sig_channels,'o',[1 1 1],6,1});

        set(gcf, 'WindowState', 'maximized')

        fig = gcf;
        earlyChildren = get(fig,'Children')
        set(gcf, 'WindowState', 'maximized')
        set(gca,'FontSize',24)
      
        sig_channels = find(abs(eeglab_sig_late(:,start_time+2000))>0)

        EEGlab_blank_late = EEGlab_blank;
        EEGlab_blank_late.data = mean(allSubjectMeansLate,3);
        EEGlab_blank_late.xmin = -1.999;
        EEGlab_blank_late.xmax = 2;
        EEGlab_blank_late.pnts = 4000;
        EEGlab_blank_late.chanlocs = readlocs(chanloc_location);
        pop_topoplot(EEGlab_blank_late,1, start_time:5:end_time, ['ERP Scalp Topographies, Late All Data'],[4:2] ,0, 'electrodes', 'off','gridscale',50,'intrad',[0.5],'maplimits',[-3,3],'style','map','emarker2',{sig_channels,'o',[1 1 1],6,1});
        fig = gcf;
        lateChildren = get(fig,'Children')
        set(gcf, 'WindowState', 'maximized')
        set(gca,'FontSize',24)


        sig_channels = find(abs(eeglab_sig_difference(:,start_time+2000))>0)

        EEGlab_blank_diff = EEGlab_blank;
        EEGlab_blank_diff.data = mean(allSubjectMeansEarly,3) - mean(allSubjectMeansLate,3);
        EEGlab_blank_diff.xmin = -1.999;
        EEGlab_blank_diff.xmax = 2;
        EEGlab_blank_diff.pnts = 4000;
        EEGlab_blank_diff.chanlocs = readlocs(chanloc_location);
        pop_topoplot(EEGlab_blank_diff,1, start_time:5:end_time, ['ERP Scalp Topographies, Early - Late All Data'],[4:2] ,0, 'electrodes', 'off','gridscale',50,'intrad',[0.5],'maplimits',[-3,3],'style','map','emarker2',{sig_channels,'o',[1 1 1],6,1});

        fig = gcf;
        earlyminuslateChildren = get(fig,'Children')
        set(gcf, 'WindowState', 'maximized')
        set(gca,'FontSize',24)

        f2 = figure;
        set(gcf,'Color','w');
        copyobj([earlyChildren(4) lateChildren(4) earlyminuslateChildren(4) earlyminuslateChildren(2)],f2);colormap jet
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
        ax3(1).Title.String = ['Early ' abs(num2str(start_time)) ' ms'];
        ax3(2).Title.String = ['Late ' abs(num2str(start_time)) ' ms'];
        ax3(3).Title.String = ['Early-Late ' abs(num2str(start_time)) ' ms'];
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
    
