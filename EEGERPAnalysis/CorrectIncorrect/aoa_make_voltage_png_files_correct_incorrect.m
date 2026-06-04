function output_end = aoa_make_voltage_png_files_correct_incorrect(start_times,end_times,suffix)
    set(0,'DefaultFigureRenderer','painters')
    
        
    addpath('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/eeglab14_0_0b/')
    load('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/aoa_EEGlab_blank.mat');
    chanloc_location = '/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/eeglab14_0_0b/sample_locs/GSN-HydroCel-257.sfp';

    eeglab('nogui')
    
    load(['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Cluster_Permutation_Voltage_' suffix '/topoplot_data_filtered20ms_20electrodes_Correct_all_' suffix '.mat'])
    eeglab_sig_correct = topoplot_data_filtered_voltage;
    
    load(['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Cluster_Permutation_Voltage_' suffix '/topoplot_data_filtered20ms_20electrodes_Incorrect_all_' suffix '.mat'])
    eeglab_sig_incorrect = topoplot_data_filtered_voltage;
    
    load(['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Cluster_Permutation_Voltage_' suffix '/topoplot_data_filtered20ms_20electrodes_Correct_minus_Incorrect_all_' suffix '.mat'])
    eeglab_sig_difference = topoplot_data_filtered_voltage;
    

    %load('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Long_Epochs_For_Time_Frequency/aoa_group_erp_means_v2.mat','allSubjectMeansCorrect','allSubjectMeansIncorrect');
    load(['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/aoa_group_erp_means_' suffix '.mat'])
    allSubjectMeansCorrect = avg_erp_all_channels_correct_subjects;
    allSubjectMeansIncorrect = avg_erp_all_channels_incorrect_subjects;

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

        sig_channels = find(abs(eeglab_sig_correct(:,start_time+2000))>0)

        EEGlab_blank_correct = EEGlab_blank;
        EEGlab_blank_correct.data = mean(allSubjectMeansCorrect,3);
        EEGlab_blank_correct.xmin = -1.999;
        EEGlab_blank_correct.xmax = 2;
        EEGlab_blank_correct.pnts = 4000;
        EEGlab_blank_correct.chanlocs = readlocs(chanloc_location);
        pop_topoplot(EEGlab_blank_correct,1, start_time:5:end_time, ['ERP Scalp Topographies, Correct All Data'],[4:2] ,0, 'electrodes', 'off','gridscale',50,'intrad',[0.5],'maplimits',[-3,3],'style','map','emarker2',{sig_channels,'o',[1 1 1],6,1});

        set(gcf, 'WindowState', 'maximized')

        fig = gcf;
        correctChildren = get(fig,'Children')
        set(gcf, 'WindowState', 'maximized')
        set(gca,'FontSize',24)
      
        sig_channels = find(abs(eeglab_sig_incorrect(:,start_time+2000))>0)

        EEGlab_blank_incorrect = EEGlab_blank;
        EEGlab_blank_incorrect.data = mean(allSubjectMeansIncorrect,3);
        EEGlab_blank_incorrect.xmin = -1.999;
        EEGlab_blank_incorrect.xmax = 2;
        EEGlab_blank_incorrect.pnts = 4000;
        EEGlab_blank_incorrect.chanlocs = readlocs(chanloc_location);
        pop_topoplot(EEGlab_blank_incorrect,1, start_time:5:end_time, ['ERP Scalp Topographies, Incorrect All Data'],[4:2] ,0, 'electrodes', 'off','gridscale',50,'intrad',[0.5],'maplimits',[-3,3],'style','map','emarker2',{sig_channels,'o',[1 1 1],6,1});
        fig = gcf;
        incorrectChildren = get(fig,'Children')
        set(gcf, 'WindowState', 'maximized')
        set(gca,'FontSize',24)


        sig_channels = find(abs(eeglab_sig_difference(:,start_time+2000))>0)

        EEGlab_blank_diff = EEGlab_blank;
        EEGlab_blank_diff.data = mean(allSubjectMeansCorrect,3) - mean(allSubjectMeansIncorrect,3);
        EEGlab_blank_diff.xmin = -1.999;
        EEGlab_blank_diff.xmax = 2;
        EEGlab_blank_diff.pnts = 4000;
        EEGlab_blank_diff.chanlocs = readlocs(chanloc_location);
        pop_topoplot(EEGlab_blank_diff,1, start_time:5:end_time, ['ERP Scalp Topographies, Correct - Incorrect All Data'],[4:2] ,0, 'electrodes', 'off','gridscale',50,'intrad',[0.5],'maplimits',[-3,3],'style','map','emarker2',{sig_channels,'o',[1 1 1],6,1});

        fig = gcf;
        correctminusincorrectChildren = get(fig,'Children')
        set(gcf, 'WindowState', 'maximized')
        set(gca,'FontSize',24)

        f2 = figure;
        set(gcf,'Color','w');
        copyobj([correctChildren(4) incorrectChildren(4) correctminusincorrectChildren(4) correctminusincorrectChildren(2)],f2);colormap jet
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
        ax3(1).Title.String = ['Correct ' abs(num2str(start_time)) ' ms'];
        ax3(2).Title.String = ['Incorrect ' abs(num2str(start_time)) ' ms'];
        ax3(3).Title.String = ['Correct-Incorrect ' abs(num2str(start_time)) ' ms'];
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
    
