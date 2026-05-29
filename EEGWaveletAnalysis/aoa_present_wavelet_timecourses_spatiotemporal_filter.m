%% This script plots individual channel timecourses for wavelet data, as well as significant timepoints determined by analyzing cluster sizes.

set(0,'DefaultFigureRenderer','Painters')

location = 'l'
without_blinks = false;
without_stdev_diff = true;

if strcmp(location,'s')

    root = '/mnt/Data27/HNCT_AoA_Study/AoA_Subjects/';
        Photo_dir = '/mnt/Data27/HNCT_AoA_Study/eeglab14_0_0b/sample_locs/GSN-HydroCel-257.sfp';
    dataRoot = '/mnt/Data27/HNCT_AoA_Study/HPC_Analyses/';
    addpath(dataRoot)
    
end
if strcmp(location,'l')
    root = 'Y:/HNCT_AoA_Study/AoA_Subjects/';
    eeglabLocation = 'Y:/HNCT_AoA_Study/eeglab14_0_0b';
    Photo_dir = 'Y:\HNCT_AoA_Study\eeglab14_0_0b\sample_locs\GSN-HydroCel-257.sfp';
    dataRoot = 'Y:\HNCT_AoA_Study\HPC_Analyses\';
end
mkdir([dataRoot '/Wavelet_TF_Group_Analyses/Spatiotemporal_Filter/'])
addpath([dataRoot '/Wavelet_TF_Group_Analyses_v2'])
data_dir = [dataRoot '/Wavelet_TF_Group_Analyses_v2/'];
load([root '/aoa_EEGlab_blank.mat'])
load([dataRoot '/Wavelet_Spatiotemporal_Clustering/Parallel_Analysis/topoplot_data_filtered200ms_10electrodes_Aware_minus_Unaware_v2.mat'])

% Load mean wavelet data for each band
load('aoa_group_wavelet_1000Hz_v2.mat')
allSubjectMeansAwareAlpha = allSubjectMeansAwareAlpha(:,1001:5000,:);
allSubjectMeansUnawareAlpha = allSubjectMeansUnawareAlpha(:,1001:5000,:);
allSubjectMeansAwareBeta = allSubjectMeansAwareBeta(:,1001:5000,:);
allSubjectMeansUnawareBeta = allSubjectMeansUnawareBeta(:,1001:5000,:);
allSubjectMeansAwareGamma = allSubjectMeansAwareGamma(:,1001:5000,:);
allSubjectMeansUnawareGamma = allSubjectMeansUnawareGamma(:,1001:5000,:);
allSubjectMeansAwareDelta = allSubjectMeansAwareDelta(:,1001:5000,:);
allSubjectMeansUnawareDelta = allSubjectMeansUnawareDelta(:,1001:5000,:);
allSubjectMeansAwareTheta = allSubjectMeansAwareTheta(:,1001:5000,:);
allSubjectMeansUnawareTheta = allSubjectMeansUnawareTheta(:,1001:5000,:);

%% Plot beta timecourses
cd([dataRoot '/Sig_Time_Frequency_Band_Timecourses/Spatiotemporal_Filter/Beta'])
clims = [-6 6];
close all
clc
for electrodeChannel = 1%:257
    
    

    sig_line = NaN(1,4000);
    
    sig_line(abs(topoplot_data_filtered_Beta(electrodeChannel,:))>0 ) = clims(2)-0.5;
    
    if sum(isnan(sig_line)) == 4000
        continue
    end
    mean_beta_aware_trace = mean(allSubjectMeansAwareBeta(electrodeChannel,:,:),3);
    mean_beta_aware_sem = std(squeeze(allSubjectMeansAwareBeta(electrodeChannel,:,:))')/sqrt(size(allSubjectMeansAwareBeta,3));
    
    mean_beta_unaware_trace = mean(allSubjectMeansUnawareBeta(electrodeChannel,:,:),3);
    mean_beta_unaware_sem = std(squeeze(allSubjectMeansUnawareBeta(electrodeChannel,:,:))')/sqrt(size(allSubjectMeansUnawareBeta,3));
    
    mean_beta_aware_high = mean_beta_aware_trace + mean_beta_aware_sem;
    mean_beta_aware_low = mean_beta_aware_trace - mean_beta_aware_sem;
    
    mean_beta_unaware_high = mean_beta_unaware_trace + mean_beta_unaware_sem;
    mean_beta_unaware_low = mean_beta_unaware_trace - mean_beta_unaware_sem;
    
    
    f = figure('units','normalized','outerposition',[0 0 1 1]);
    hold on; 
    line([0 0],clims)
    line([-2000 2000],[0 0])
    xlabel(['Time from Confirm (ms)'])
    ylabel(['Z-Scored Power From Baseline'])
    patch([-1999:2000 fliplr(-1999:2000)], [mean_beta_aware_low fliplr(mean_beta_aware_high)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
    patch([-1999:2000 fliplr(-1999:2000)], [mean_beta_unaware_low fliplr(mean_beta_unaware_high)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
    
    erp_legend = plot(-1999:2000,mean_beta_aware_trace,'Color',[0 0 1 0.7],'LineWidth',5);
    erp_legend = [erp_legend plot(-1999:2000,mean_beta_unaware_trace,'Color',[1 0.7 0 0.7],'LineWidth',5)];
    plot(-1999:2000,sig_line,'Color','green','LineWidth',5)
    
    title(['Average Z-scored Beta Power Change, Electrode ' num2str(electrodeChannel)])
    ylim(clims)
    set(gca,'FontSize',24)
    hLegend = legend(erp_legend,{'Aware','Unaware'});
    set(hLegend, 'Location', 'southeast', 'Orientation', 'vertical');


    saveas(f,['E' num2str(electrodeChannel) '_Beta_Timecourse.fig'])
    saveas(f,['E' num2str(electrodeChannel) '_Beta_Timecourse.png'])
    saveas(f,['E' num2str(electrodeChannel) '_Beta_Timecourse.eps'])
    close all

end

%% Plot alpha timecourses
cd([dataRoot '/Sig_Time_Frequency_Band_Timecourses/Spatiotemporal_Filter/Alpha'])
clims = [-6 6];
close all
clc
for electrodeChannel = 1:257
    
    

    sig_line = NaN(1,4000);
    
    sig_line(abs(topoplot_data_filtered_Alpha(electrodeChannel,:))>0 ) = clims(2)-0.5;
    
    if sum(isnan(sig_line)) == 4000
        continue
    end
    mean_alpha_aware_trace = mean(allSubjectMeansAwareAlpha(electrodeChannel,:,:),3);
    mean_alpha_aware_sem = std(squeeze(allSubjectMeansAwareAlpha(electrodeChannel,:,:))')/sqrt(size(allSubjectMeansAwareAlpha,3));
    
    mean_alpha_unaware_trace = mean(allSubjectMeansUnawareAlpha(electrodeChannel,:,:),3);
    mean_alpha_unaware_sem = std(squeeze(allSubjectMeansUnawareAlpha(electrodeChannel,:,:))')/sqrt(size(allSubjectMeansUnawareAlpha,3));
    
    mean_alpha_aware_high = mean_alpha_aware_trace + mean_alpha_aware_sem;
    mean_alpha_aware_low = mean_alpha_aware_trace - mean_alpha_aware_sem;
    
    mean_alpha_unaware_high = mean_alpha_unaware_trace + mean_alpha_unaware_sem;
    mean_alpha_unaware_low = mean_alpha_unaware_trace - mean_alpha_unaware_sem;
    
    
    f = figure('units','normalized','outerposition',[0 0 1 1]);
    hold on; 
    line([0 0],clims)
    line([-2000 2000],[0 0])
    xlabel(['Time from Confirm (ms)'])
    ylabel(['Z-Scored Power From Baseline'])
    patch([-1999:2000 fliplr(-1999:2000)], [mean_alpha_aware_low fliplr(mean_alpha_aware_high)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
    patch([-1999:2000 fliplr(-1999:2000)], [mean_alpha_unaware_low fliplr(mean_alpha_unaware_high)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
    
    erp_legend = plot(-1999:2000,mean_alpha_aware_trace,'Color',[0 0 1 0.7],'LineWidth',5);
    erp_legend = [erp_legend plot(-1999:2000,mean_alpha_unaware_trace,'Color',[1 0.7 0 0.7],'LineWidth',5)];
    plot(-1999:2000,sig_line,'Color','green','LineWidth',5)
    
    title(['Average Z-scored Alpha Power Change, Electrode ' num2str(electrodeChannel)])
    ylim(clims)
    set(gca,'FontSize',24)
    hLegend = legend(erp_legend,{'Aware','Unaware'});
    set(hLegend, 'Location', 'southeast', 'Orientation', 'vertical');


    saveas(f,['E' num2str(electrodeChannel) '_Alpha_Timecourse.fig'])
    saveas(f,['E' num2str(electrodeChannel) '_Alpha_Timecourse.png'])
    saveas(f,['E' num2str(electrodeChannel) '_Alpha_Timecourse.eps'])
    close all

end

%% Plot gamma timecourses
cd([dataRoot '/Sig_Time_Frequency_Band_Timecourses/Spatiotemporal_Filter/Gamma'])
clims = [-6 6];
close all
clc
for electrodeChannel = 1:257
    
    

    sig_line = NaN(1,4000);
    
    sig_line(abs(topoplot_data_filtered_Gamma(electrodeChannel,:))>0 ) = clims(2)-0.5;
    
    if sum(isnan(sig_line)) == 4000
        continue
    end
    mean_gamma_aware_trace = mean(allSubjectMeansAwareGamma(electrodeChannel,:,:),3);
    mean_gamma_aware_sem = std(squeeze(allSubjectMeansAwareGamma(electrodeChannel,:,:))')/sqrt(size(allSubjectMeansAwareGamma,3));
    
    mean_gamma_unaware_trace = mean(allSubjectMeansUnawareGamma(electrodeChannel,:,:),3);
    mean_gamma_unaware_sem = std(squeeze(allSubjectMeansUnawareGamma(electrodeChannel,:,:))')/sqrt(size(allSubjectMeansUnawareGamma,3));
    
    mean_gamma_aware_high = mean_gamma_aware_trace + mean_gamma_aware_sem;
    mean_gamma_aware_low = mean_gamma_aware_trace - mean_gamma_aware_sem;
    
    mean_gamma_unaware_high = mean_gamma_unaware_trace + mean_gamma_unaware_sem;
    mean_gamma_unaware_low = mean_gamma_unaware_trace - mean_gamma_unaware_sem;
    
    
    f = figure('units','normalized','outerposition',[0 0 1 1]);
    hold on; 
    line([0 0],clims)
    line([-2000 2000],[0 0])
    xlabel(['Time from Confirm (ms)'])
    ylabel(['Z-Scored Power From Baseline'])
    patch([-1999:2000 fliplr(-1999:2000)], [mean_gamma_aware_low fliplr(mean_gamma_aware_high)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
    patch([-1999:2000 fliplr(-1999:2000)], [mean_gamma_unaware_low fliplr(mean_gamma_unaware_high)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
    
    erp_legend = plot(-1999:2000,mean_gamma_aware_trace,'Color',[0 0 1 0.7],'LineWidth',5);
    erp_legend = [erp_legend plot(-1999:2000,mean_gamma_unaware_trace,'Color',[1 0.7 0 0.7],'LineWidth',5)];
    plot(-1999:2000,sig_line,'Color','green','LineWidth',5)
    
    title(['Average Z-scored Gamma Power Change, Electrode ' num2str(electrodeChannel)])
    ylim(clims)
    set(gca,'FontSize',24)
    hLegend = legend(erp_legend,{'Aware','Unaware'});
    set(hLegend, 'Location', 'southeast', 'Orientation', 'vertical');


    saveas(f,['E' num2str(electrodeChannel) '_Gamma_Timecourse.fig'])
    saveas(f,['E' num2str(electrodeChannel) '_Gamma_Timecourse.png'])
    saveas(f,['E' num2str(electrodeChannel) '_Gamma_Timecourse.eps'])
    close all

end

%% Plot delta timecourses
cd([dataRoot '/Sig_Time_Frequency_Band_Timecourses/Spatiotemporal_Filter/Delta'])
clims = [-6 6];
close all
clc
for electrodeChannel = 1:257
    
    

    sig_line = NaN(1,4000);
    
    sig_line(abs(topoplot_data_filtered_Delta(electrodeChannel,:))>0 ) = clims(2)-0.5;
    
    if sum(isnan(sig_line)) == 4000
        continue
    end
    mean_delta_aware_trace = mean(allSubjectMeansAwareDelta(electrodeChannel,:,:),3);
    mean_delta_aware_sem = std(squeeze(allSubjectMeansAwareDelta(electrodeChannel,:,:))')/sqrt(size(allSubjectMeansAwareDelta,3));
    
    mean_delta_unaware_trace = mean(allSubjectMeansUnawareDelta(electrodeChannel,:,:),3);
    mean_delta_unaware_sem = std(squeeze(allSubjectMeansUnawareDelta(electrodeChannel,:,:))')/sqrt(size(allSubjectMeansUnawareDelta,3));
    
    mean_delta_aware_high = mean_delta_aware_trace + mean_delta_aware_sem;
    mean_delta_aware_low = mean_delta_aware_trace - mean_delta_aware_sem;
    
    mean_delta_unaware_high = mean_delta_unaware_trace + mean_delta_unaware_sem;
    mean_delta_unaware_low = mean_delta_unaware_trace - mean_delta_unaware_sem;
    
    
    f = figure('units','normalized','outerposition',[0 0 1 1]);
    hold on; 
    line([0 0],clims)
    line([-2000 2000],[0 0])
    xlabel(['Time from Confirm (ms)'])
    ylabel(['Z-Scored Power From Baseline'])
    patch([-1999:2000 fliplr(-1999:2000)], [mean_delta_aware_low fliplr(mean_delta_aware_high)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
    patch([-1999:2000 fliplr(-1999:2000)], [mean_delta_unaware_low fliplr(mean_delta_unaware_high)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
    
    erp_legend = plot(-1999:2000,mean_delta_aware_trace,'Color',[0 0 1 0.7],'LineWidth',5);
    erp_legend = [erp_legend plot(-1999:2000,mean_delta_unaware_trace,'Color',[1 0.7 0 0.7],'LineWidth',5)];
    plot(-1999:2000,sig_line,'Color','green','LineWidth',5)
    
    title(['Average Z-scored Delta Power Change, Electrode ' num2str(electrodeChannel)])
    ylim(clims)
    set(gca,'FontSize',24)
    hLegend = legend(erp_legend,{'Aware','Unaware'});
    set(hLegend, 'Location', 'southeast', 'Orientation', 'vertical');


    saveas(f,['E' num2str(electrodeChannel) '_Delta_Timecourse.fig'])
    saveas(f,['E' num2str(electrodeChannel) '_Delta_Timecourse.png'])
    saveas(f,['E' num2str(electrodeChannel) '_Delta_Timecourse.eps'])
    close all

end

%% Plot Theta timecourses

cd([dataRoot '/Sig_Time_Frequency_Band_Timecourses/Spatiotemporal_Filter/Theta'])
clims = [-6 6];
close all
clc
for electrodeChannel = 1:257
    
    

    sig_line = NaN(1,4000);
    
    sig_line(abs(topoplot_data_filtered_Theta(electrodeChannel,:))>0 ) = clims(2)-0.5;
    
    if sum(isnan(sig_line)) == 4000
        continue
    end
    mean_theta_aware_trace = mean(allSubjectMeansAwareTheta(electrodeChannel,:,:),3);
    mean_theta_aware_sem = std(squeeze(allSubjectMeansAwareTheta(electrodeChannel,:,:))')/sqrt(size(allSubjectMeansAwareTheta,3));
    
    mean_theta_unaware_trace = mean(allSubjectMeansUnawareTheta(electrodeChannel,:,:),3);
    mean_theta_unaware_sem = std(squeeze(allSubjectMeansUnawareTheta(electrodeChannel,:,:))')/sqrt(size(allSubjectMeansUnawareTheta,3));
    
    mean_theta_aware_high = mean_theta_aware_trace + mean_theta_aware_sem;
    mean_theta_aware_low = mean_theta_aware_trace - mean_theta_aware_sem;
    
    mean_theta_unaware_high = mean_theta_unaware_trace + mean_theta_unaware_sem;
    mean_theta_unaware_low = mean_theta_unaware_trace - mean_theta_unaware_sem;
    
    
    f = figure('units','normalized','outerposition',[0 0 1 1]);
    hold on; 
    line([0 0],clims)
    line([-2000 2000],[0 0])
    xlabel(['Time from Confirm (ms)'])
    ylabel(['Z-Scored Power From Baseline'])
    patch([-1999:2000 fliplr(-1999:2000)], [mean_theta_aware_low fliplr(mean_theta_aware_high)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
    patch([-1999:2000 fliplr(-1999:2000)], [mean_theta_unaware_low fliplr(mean_theta_unaware_high)], [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
    
    erp_legend = plot(-1999:2000,mean_theta_aware_trace,'Color',[0 0 1 0.7],'LineWidth',5);
    erp_legend = [erp_legend plot(-1999:2000,mean_theta_unaware_trace,'Color',[1 0.7 0 0.7],'LineWidth',5)];
    plot(-1999:2000,sig_line,'Color','green','LineWidth',5)
    
    title(['Average Z-scored Theta Power Change, Electrode ' num2str(electrodeChannel)])
    ylim(clims)
    set(gca,'FontSize',24)
    hLegend = legend(erp_legend,{'Aware','Unaware'});
    set(hLegend, 'Location', 'southeast', 'Orientation', 'vertical');


    saveas(f,['E' num2str(electrodeChannel) '_Theta_Timecourse.fig'])
    saveas(f,['E' num2str(electrodeChannel) '_Theta_Timecourse.png'])
    saveas(f,['E' num2str(electrodeChannel) '_Theta_Timecourse.eps'])
    close all

end
