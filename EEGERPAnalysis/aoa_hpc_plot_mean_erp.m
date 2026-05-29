% Find all directories within the EEG data directory
% Create blank vectors which will contain subject IDs and testing days (2
% or 3)
allDirectories = dir('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Long_Epochs_For_Time_Frequency/');
allSubjectDirectories = [];
allSubjectNames = [];
allSubjectDays = [];
sessionDates = [];

% Iterate through all the folders in the EEG data directory, concatenating subject ID into the allSubjectNames vector
% and subject testing day into the allSubjectDays vector. The variable
% sessionDates is essentially the concatenation of the subject directory
% and name.
for entry = 3:length(allDirectories)
    subject_name = allDirectories(entry).name;
    allSubdirectories = dir(['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Long_Epochs_For_Time_Frequency/' subject_name]);
    for subdirectory = 3:length(allSubdirectories)
        allSubjectDirectories = [allSubjectDirectories;{['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Long_Epochs_For_Time_Frequency/' ...
            subject_name '/' allSubdirectories(subdirectory).name]}];
        
        allSubjectNames = [allSubjectNames; {subject_name}];
        allSubjectDays = [allSubjectDays;{allSubdirectories(subdirectory).name}];
        folderContents = dir(['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Long_Epochs_For_Time_Frequency/' subject_name '/' ...
            allSubdirectories(subdirectory).name]);
        sessionDates = [sessionDates; {folderContents(3).name(1:8)}];
    end
end


%%

% Create an empy subjects x epoch type cell. The contents of each column of the cell will
% be as follows:
% 1. Subject ID
% 2. Mean aware traces for each session
% 3. Mean unaware traces for each session
% 4. Total number of aware trials per session
% 5. Total number of unaware trials per session
% 6. Weighted average aware vector of both testing days
% 7. Weighted average unaware vector of both testing days

allSubjectERPs = [unique(allSubjectNames)'; cell(6,length(unique(allSubjectNames)))];
tic
for session = 1:length(allSubjectNames)
    % For each subject, load aware vector, unaware vector, aware count, and unaware count
    % into their respective positions in the cell.
    disp(['Loading ' allSubjectNames{session} ', ' allSubjectDays{session}]);
    cd(allSubjectDirectories{session})
    load([sessionDates{session} '_mean_erps.mat'])
    for subject = 1:length(allSubjectERPs)
        if strcmp(allSubjectERPs{1,subject},allSubjectNames{session})
            allSubjectERPs{2,subject} = cat(3,allSubjectERPs{2,subject},mean_aware_erp);
            allSubjectERPs{3,subject} = cat(3,allSubjectERPs{3,subject},mean_unaware_erp);
            allSubjectERPs{4,subject} = [allSubjectERPs{4,subject} awareTotals];
            allSubjectERPs{5,subject} = [allSubjectERPs{5,subject} unawareTotals]; 
        end
    end
    toc
end

%%

% Create empty vector for all subject means in aware and unaware
allSubjectMeansAware = zeros([size(mean_aware_erp) length(allSubjectERPs)]);
allSubjectMeansUnaware = zeros([size(mean_unaware_erp) length(allSubjectERPs)]);

% Create an empty vector for sessions where there are only two available
% sessions.
allSubjectMeansAwareTwoSessionOnly = [];
allSubjectMeansUnawareTwoSessionOnly = [];

% Iterate through subjects, taking a weighted mean if two sessions are
% available for a subject
for subject = 1:length(allSubjectERPs)
    disp(['Concatenating subject ' allSubjectERPs{1,subject}])
    
    % Use the second column and fourth column to calculate weighted mean
    % aware trace. If there is only one session for the subject, then just
    % use the one session as the mean trace
    if length(allSubjectERPs{4,subject}) == 2
        day2erp_aware = allSubjectERPs{2,subject}(:,:,1);
        day3erp_aware = allSubjectERPs{2,subject}(:,:,2);
        allSubjectMeansAware(:,:,subject) = (day2erp_aware*allSubjectERPs{4,subject}(1) + day3erp_aware*allSubjectERPs{4,subject}(2)) ...
            / sum(allSubjectERPs{4,subject});
        allSubjectMeansAwareTwoSessionOnly = cat(4,allSubjectMeansAwareTwoSessionOnly, ...
            (day2erp_aware*allSubjectERPs{4,subject}(1) + day3erp_aware*allSubjectERPs{4,subject}(2)) / sum(allSubjectERPs{4,subject}));
    elseif length(allSubjectERPs{4,subject}) == 1
        allSubjectMeansAware(:,:,subject) = allSubjectERPs{2,subject};
    end
    
    % Use the third column and fifth column to calculate weighted mean
    % unaware trace. If there is only one session for the subject, then just
    % use the one session as the mean trace
    if length(allSubjectERPs{4,subject}) == 2
        day2erp_unaware = allSubjectERPs{3,subject}(:,:,1);
        day3erp_unaware = allSubjectERPs{3,subject}(:,:,2);
        allSubjectMeansUnaware(:,:,subject) = (day2erp_unaware*allSubjectERPs{5,subject}(1) + day3erp_unaware*allSubjectERPs{5,subject}(2)) ...
            / sum(allSubjectERPs{5,subject});
        allSubjectMeansUnawareTwoSessionOnly = cat(4,allSubjectMeansUnawareTwoSessionOnly, ...
            (day2erp_unaware*allSubjectERPs{5,subject}(1) + day3erp_unaware*allSubjectERPs{5,subject}(2)) / sum(allSubjectERPs{5,subject}));
    elseif length(allSubjectERPs{4,subject}) == 1
        allSubjectMeansUnaware(:,:,subject) = allSubjectERPs{3,subject};
    end
end
%%

% Designate a specific channel to plot and filter parameters
electrodeChannel = 5; % A frontal electrode, just as an example
extralpfilt = true; % Designates how smooth the curve should be

% Get data for example channel, calculating mean
allAverageAwareERPs = squeeze(allSubjectMeansAware(electrodeChannel,:,:))';
allAverageUnawareERPs = squeeze(allSubjectMeansUnaware(electrodeChannel,:,:))';
allAverageAwareERP = mean(allAverageAwareERPs);
allAverageUnawareERP = mean(allAverageUnawareERPs);

% These duplicate variables will be used for extra filtering if needed
group_mean_aware_erp = allAverageAwareERP; 
group_mean_unaware_erp = allAverageUnawareERP;

% Calculate SEM for individual points
aware_SEM = zeros(1,size(group_mean_aware_erp,2));
unaware_SEM = zeros(1,size(group_mean_unaware_erp,2));
for point = 1:length(group_mean_aware_erp)
    aware_SEM(point) = std(allAverageAwareERPs(:,point))/ sqrt(size(allSubjectERPs,2));
    unaware_SEM(point) = std(allAverageUnawareERPs(:,point))/ sqrt(size(allSubjectERPs,2));
end
%%

% Open a figure and draw the axes as well as timepoint 0
figure;
hold on

line([0 0],[-4 4])
line([-2000 2000],[0 0])

% If extra filtering is needed, use the filtfilt function. Otherwise, a 1
% Hz filter will be used for presentation only.
if ~extralpfilt
    lowpass_aware_high = lowpass(group_mean_aware_erp+aware_SEM,1,1000);
    lowpass_aware_low = lowpass(group_mean_aware_erp-aware_SEM,1,1000);
    lowpass_unaware_high = lowpass(group_mean_unaware_erp+unaware_SEM,1,1000);
    lowpass_unaware_low = lowpass(group_mean_unaware_erp-unaware_SEM,1,1000);
elseif extralpfilt

    lpFilt = designfilt('lowpassfir','PassbandFrequency',8, ...
    'StopbandFrequency',14,'PassbandRipple',1, ...
    'StopbandAttenuation',65,'DesignMethod','kaiserwin','SampleRate',1000);
    lowpass_aware_high = filtfilt(lpFilt,group_mean_aware_erp+aware_SEM);
    lowpass_aware_low = filtfilt(lpFilt,group_mean_aware_erp-aware_SEM);
    lowpass_unaware_high = filtfilt(lpFilt,group_mean_unaware_erp+unaware_SEM);
    lowpass_unaware_low = filtfilt(lpFilt,group_mean_unaware_erp-unaware_SEM);
end

% The SEM surrounding the average trace is made with the patch function. 
% In order for a wide legend square (blue if aware, yellow if gold if
% unaware) the patched SEM is used for the legend entry instead of the
% thinner mean trace.

erp_legend = [];
erp_legend = [erp_legend patch([-2999:3000 fliplr(-2999:3000)], [lowpass_aware_low fliplr(lowpass_aware_high)],...
    [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')];
erp_legend = [erp_legend patch([-2999:3000 fliplr(-2999:3000)], [lowpass_unaware_low fliplr(lowpass_unaware_high)],...
    [1 0.7 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')];

% Plot the average trace for aware and unaware depending on if there is
% extra filtering to be applied. 

if ~extralpfilt
    plot([-2999:3000],lowpass(group_mean_aware_erp,1,1000),'Color',[0 0 1 0.7],'LineWidth',5)
    plot([-2999:3000],lowpass(group_mean_unaware_erp,1,1000),'Color',[1 0.7 0 0.7],'LineWidth',5)
elseif extralpfilt
    plot([-2999:3000],filtfilt(lpFilt,group_mean_aware_erp),'Color',[0 0 1 0.7],'LineWidth',5)
    plot([-2999:3000],filtfilt(lpFilt,group_mean_unaware_erp),'Color',[1 0.7 0 0.7],'LineWidth',5)
end

% Set axis limits and plot the legend and label axes

ylim([-4 4])
xlim([-1000 1000])

legend(erp_legend,'Aware','Unaware')
title(['E' num2str(electrodeChannel) ', Mean ERP, N = ' num2str(length(allSubjectERPs)) ])

xlabel('Time (ms)')
ylabel('Voltage (microvolts)')
set(gca,'FontSize',24)

% To assist in identification of which function and when the group data
% were created, make variables accordingly
creationFunction = 'aoa_hpc_plot_mean_erp.m'
creationDate = string(datetime('now'))

% Create shorter 4000 ms vectors
avg_erp_all_channels_aware_subjects = allSubjectMeansAware(:,1001:5000,:);
avg_erp_all_channels_unaware_subjects = allSubjectMeansUnaware(:,1001:5000,:);

% Save the unfiltered aware mean, unfiltered unaware mean, 4000 ms aware
% subject means, 4000 ms unaware subject means, name of this function, and
% date and time of creation
save('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/aoa_group_erp_means.mat', ...
    'allSubjectMeansAware','allSubjectMeansUnaware','avg_erp_all_channels_aware_subjects',...
    'avg_erp_all_channels_unaware_subjects','creationFunction','creationDate')
