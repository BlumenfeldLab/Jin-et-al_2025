function output_end = aoa_make_wavelet_png_files(band,start_times,end_times) 
    % Specify the band (delta, theta, alpha, or beta)
    % Specify the start times of the topoplot
    % Specify the end times of the topoplot

    set(0,'DefaultFigureRenderer','painters')
    
        
    addpath('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/eeglab14_0_0b/')
    load('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/aoa_EEGlab_blank.mat');
    chanloc_location = '/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/eeglab14_0_0b/sample_locs/GSN-HydroCel-257.sfp';

    eeglab('nogui')
    
    load('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Cluster_Permutation_Wavelet_Parallel/topoplot_data_filtered200ms_10electrodes_Aware_v2.mat')
    eval(['eeglab_sig_aware = topoplot_data_filtered_' band ';']);
    
    load('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Cluster_Permutation_Wavelet_Parallel/topoplot_data_filtered200ms_10electrodes_Unaware_v2.mat')
    eval(['eeglab_sig_unaware = topoplot_data_filtered_' band ';']);
    
    load('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Cluster_Permutation_Wavelet_Parallel/topoplot_data_filtered200ms_10electrodes_Aware_minus_Unaware_v2.mat')
    eval(['eeglab_sig_difference = topoplot_data_filtered_' band ';']);
    

    load('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/aoa_group_wavelet_1000Hz_v2.mat',['allSubjectMeansAware' band],['allSubjectMeansUnaware' band] );
    

    %% Using all the start times and end times, plot the composite data.

    mkdir(['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Cluster_Permutation_Wavelet_Parallel/Composite_Topoplots/' band ])
    cd(['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Cluster_Permutation_Wavelet_Parallel/Composite_Topoplots/' band ])

    % For each time, load and plot the aware, unaware, and difference
    % plots.
    for time = 1:length(start_times)
        close all
        start_time = start_times(time);
        end_time = end_times(time);

        sig_channels = find(abs(eeglab_sig_aware(:,start_time+2000))>0)

        EEGlab_blank_aware = EEGlab_blank;
        eval(['EEGlab_blank_aware.data = mean(allSubjectMeansAware' band ',3);']);
        EEGlab_blank_aware.xmin = -2.999;
        EEGlab_blank_aware.xmax = 3;
        EEGlab_blank_aware.pnts = 6000;
        EEGlab_blank_aware.chanlocs = readlocs(chanloc_location);
        pop_topoplot(EEGlab_blank_aware,1, start_time:5:end_time, ['ERP Scalp Topographies, Aware All Data'],[4:2] ,0, 'electrodes', 'off','gridscale',50,'intrad',[0.5],'maplimits',[-3,3],'style','map','emarker2',{sig_channels,'o',[1 1 1],6,1});

        set(gcf, 'WindowState', 'maximized')

        fig = gcf;
        awareChildren = get(fig,'Children')
        set(gcf, 'WindowState', 'maximized')
        set(gca,'FontSize',24)
      
        sig_channels = find(abs(eeglab_sig_unaware(:,start_time+2000))>0)

        EEGlab_blank_unaware = EEGlab_blank;
        eval(['EEGlab_blank_unaware.data = mean(allSubjectMeansUnaware' band ',3);'])
        EEGlab_blank_unaware.xmin = -2.999;
        EEGlab_blank_unaware.xmax = 3;
        EEGlab_blank_unaware.pnts = 6000;
        EEGlab_blank_unaware.chanlocs = readlocs(chanloc_location);
        pop_topoplot(EEGlab_blank_unaware,1, start_time:5:end_time, ['ERP Scalp Topographies, Unaware All Data'],[4:2] ,0, 'electrodes', 'off','gridscale',50,'intrad',[0.5],'maplimits',[-3,3],'style','map','emarker2',{sig_channels,'o',[1 1 1],6,1});
        fig = gcf;
        unawareChildren = get(fig,'Children')
        set(gcf, 'WindowState', 'maximized')
        set(gca,'FontSize',24)


        sig_channels = find(abs(eeglab_sig_difference(:,start_time+2000))>0)

        EEGlab_blank_diff = EEGlab_blank;
        eval(['EEGlab_blank_diff.data = mean(allSubjectMeansAware' band ',3) - mean(allSubjectMeansUnaware' band ',3);'])
        EEGlab_blank_diff.xmin = -2.999;
        EEGlab_blank_diff.xmax = 3;
        EEGlab_blank_diff.pnts = 6000;
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
    
