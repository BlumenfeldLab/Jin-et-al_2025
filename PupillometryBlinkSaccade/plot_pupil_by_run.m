clear all;
close all;


root = '//gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Pupil_Data/';

addpath(root)


allDirectories = dir('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Pupil_Data');
allSubjectDirectories = [];
allSubjectNames = [];
allSubjectDays = [];
subject_names = [];
sessionDates = [];
problem_subjs = [];
for entry = 3:length(allDirectories)
    subject_name = allDirectories(entry).name;
    allSubdirectories = dir(['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Pupil_Data/' subject_name]);
    for subdirectory = 3:length(allSubdirectories)
        allSubjectDirectories = [allSubjectDirectories;{['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Pupil_Data/' subject_name '/' allSubdirectories(subdirectory).name]}];
        
        allSubjectNames = [allSubjectNames; {subject_name}];
        allSubjectDays = [allSubjectDays;{allSubdirectories(subdirectory).name}];
        folderContents = dir(['/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Pupil_Data/' subject_name '/' allSubdirectories(subdirectory).name]);
    end
end

disp('Loading data...')

tic

%% Load and average all subjects together

all_subj_pupil_data_left = [unique(allSubjectNames)'; cell(14,length(unique(allSubjectNames)))];
all_subj_pupil_data_right = [unique(allSubjectNames)'; cell(14,length(unique(allSubjectNames)))];



for currenteye = 1:2
    
    if currenteye == 1
        eye = 'left'
    elseif currenteye == 2
        eye = 'right'
    end
    for session_number = 1:length(allSubjectNames)
        disp(['Loading ' allSubjectNames{session_number}])
        %try
            sessionPath = allSubjectDirectories{session_number};
            cd(sessionPath)
            fullsession = [allSubjectNames{session_number} '_' allSubjectDays{session_number}];
            load([fullsession '_mean_eye_metrics_' eye '_v5.mat'],'meanRun1All','meanRun2All','meanRun3All','meanRun4All','meanRun5All','meanRun6All');
            load([fullsession '_mean_eye_metrics_' eye '_v5.mat'],'trialRunsAwareRaw','trialRunsUnawareRaw','trialRunsMHRaw','trialRunsMLRaw');
            load([fullsession '_mean_eye_metrics_' eye '_v5.mat'],'allSubjAwareNoNansRaw','allSubjUnawareNoNansRaw','allSubjMHNoNansRaw','allSubjMLNoNansRaw')
            % If any nans are found, turn into empty vectors

            totalTrialRuns = [trialRunsAwareRaw trialRunsUnawareRaw trialRunsMHRaw trialRunsMLRaw];

 
            

            
            if strcmp(eye,'left')
                for subject = 1:length(all_subj_pupil_data_left)
                    if strcmp(allSubjectNames{session_number},all_subj_pupil_data_left{1,subject})
                        all_subj_pupil_data_left{2,subject} = [all_subj_pupil_data_left{2,subject}; meanRun1All];
                        all_subj_pupil_data_left{3,subject} = [all_subj_pupil_data_left{3,subject}; meanRun2All];
                        all_subj_pupil_data_left{4,subject} = [all_subj_pupil_data_left{4,subject}; meanRun3All];
                        all_subj_pupil_data_left{5,subject} = [all_subj_pupil_data_left{5,subject}; meanRun4All];
                        all_subj_pupil_data_left{6,subject} = [all_subj_pupil_data_left{6,subject}; meanRun5All];
                        all_subj_pupil_data_left{7,subject} = [all_subj_pupil_data_left{7,subject}; meanRun6All];
                        all_subj_pupil_data_left{8,subject} = [all_subj_pupil_data_left{8,subject}; sum(totalTrialRuns == 1)];
                        all_subj_pupil_data_left{9,subject} = [all_subj_pupil_data_left{9,subject}; sum(totalTrialRuns == 2)];
                        all_subj_pupil_data_left{10,subject} = [all_subj_pupil_data_left{10,subject}; sum(totalTrialRuns == 3)];
                        all_subj_pupil_data_left{11,subject} = [all_subj_pupil_data_left{11,subject}; sum(totalTrialRuns == 4)];
                        all_subj_pupil_data_left{12,subject} = [all_subj_pupil_data_left{12,subject}; sum(totalTrialRuns == 5)];
                        all_subj_pupil_data_left{13,subject} = [all_subj_pupil_data_left{13,subject}; sum(totalTrialRuns == 6)];
                        all_subj_pupil_data_left{14,subject} = [all_subj_pupil_data_left{14,subject}; allSubjAwareNoNansRaw];
                        all_subj_pupil_data_left{15,subject} = [all_subj_pupil_data_left{15,subject}; allSubjUnawareNoNansRaw];
                        
                        
                        



                    end
                end
            end
            if strcmp(eye,'right')
                for subject = 1:length(all_subj_pupil_data_right)
                    if strcmp(allSubjectNames{session_number},all_subj_pupil_data_right{1,subject})
                        all_subj_pupil_data_right{2,subject} = [all_subj_pupil_data_right{2,subject}; meanRun1All];
                        all_subj_pupil_data_right{3,subject} = [all_subj_pupil_data_right{3,subject}; meanRun2All];
                        all_subj_pupil_data_right{4,subject} = [all_subj_pupil_data_right{4,subject}; meanRun3All];
                        all_subj_pupil_data_right{5,subject} = [all_subj_pupil_data_right{5,subject}; meanRun4All];
                        all_subj_pupil_data_right{6,subject} = [all_subj_pupil_data_right{6,subject}; meanRun5All];
                        all_subj_pupil_data_right{7,subject} = [all_subj_pupil_data_right{7,subject}; meanRun6All];
                        all_subj_pupil_data_right{8,subject} = [all_subj_pupil_data_right{8,subject}; sum(totalTrialRuns == 1)];
                        all_subj_pupil_data_right{9,subject} = [all_subj_pupil_data_right{9,subject}; sum(totalTrialRuns == 2)];
                        all_subj_pupil_data_right{10,subject} = [all_subj_pupil_data_right{10,subject}; sum(totalTrialRuns == 3)];
                        all_subj_pupil_data_right{11,subject} = [all_subj_pupil_data_right{11,subject}; sum(totalTrialRuns == 4)];
                        all_subj_pupil_data_right{12,subject} = [all_subj_pupil_data_right{12,subject}; sum(totalTrialRuns == 5)];
                        all_subj_pupil_data_right{13,subject} = [all_subj_pupil_data_right{13,subject}; sum(totalTrialRuns == 6)];
                        all_subj_pupil_data_right{14,subject} = [all_subj_pupil_data_right{14,subject}; allSubjAwareNoNansRaw];
                        all_subj_pupil_data_right{15,subject} = [all_subj_pupil_data_right{15,subject}; allSubjUnawareNoNansRaw];
                        



                    end
                end
            end
        %catch
%             problem_subjs = [problem_subjs; {allSubjectNames{session_number}}];
%             continue
%         end
        toc
    end
end
%% Exclude participants with fewer than minimum of 12 trials each
all_subj_pupil_data_left_kept = [];
all_subj_pupil_data_right_kept = [];

for subject = 1:length(all_subj_pupil_data_left)
    if size(all_subj_pupil_data_left{14,subject},1) >= 12 && size(all_subj_pupil_data_left{15,subject},1) >= 12
        all_subj_pupil_data_left_kept = [all_subj_pupil_data_left_kept all_subj_pupil_data_left(:,subject)];
    end
end

for subject = 1:length(all_subj_pupil_data_right)
    if size(all_subj_pupil_data_right{14,subject},1) >= 12 && size(all_subj_pupil_data_right{15,subject},1) >= 12
        all_subj_pupil_data_right_kept = [all_subj_pupil_data_right_kept all_subj_pupil_data_right(:,subject)];
    end
end

%% Group data by run

allSubjectPupilRun1_left = [];
allSubjectPupilRun2_left = [];
allSubjectPupilRun3_left = [];
allSubjectPupilRun4_left = [];
allSubjectPupilRun5_left = [];
allSubjectPupilRun6_left = [];

for subject = 1:length(all_subj_pupil_data_left_kept)
    if isempty(all_subj_pupil_data_left_kept{2,subject});
        allSubjectPupilRun1_left = [allSubjectPupilRun1_left; nan(1,8000)];
    elseif size(all_subj_pupil_data_left_kept{2,subject},1) == 1;
        allSubjectPupilRun1_left = [allSubjectPupilRun1_left; all_subj_pupil_data_left_kept{2,subject}];
    elseif size(all_subj_pupil_data_left_kept{2,subject},1) == 2;
        allSubjectPupilRun1_left = [allSubjectPupilRun1_left; (all_subj_pupil_data_left_kept{2,subject}(1,:)*all_subj_pupil_data_left_kept{8,subject}(1) + all_subj_pupil_data_left_kept{2,subject}(2,:)*all_subj_pupil_data_left_kept{8,subject}(2))/sum(all_subj_pupil_data_left_kept{8,subject})];
    end
    
    if isempty(all_subj_pupil_data_left_kept{3,subject});
        allSubjectPupilRun2_left = [allSubjectPupilRun2_left; nan(1,8000)];
    elseif size(all_subj_pupil_data_left_kept{3,subject},1) == 1;
        allSubjectPupilRun2_left = [allSubjectPupilRun2_left; all_subj_pupil_data_left_kept{3,subject}];
    elseif size(all_subj_pupil_data_left_kept{3,subject},1) == 2;
        allSubjectPupilRun2_left = [allSubjectPupilRun2_left; (all_subj_pupil_data_left_kept{3,subject}(1,:)*all_subj_pupil_data_left_kept{9,subject}(1) + all_subj_pupil_data_left_kept{3,subject}(2,:)*all_subj_pupil_data_left_kept{9,subject}(2))/sum(all_subj_pupil_data_left_kept{9,subject})];
    end
    
    if isempty(all_subj_pupil_data_left_kept{4,subject});
        allSubjectPupilRun3_left = [allSubjectPupilRun3_left; nan(1,8000)];
    elseif size(all_subj_pupil_data_left_kept{4,subject},1) == 1;
        allSubjectPupilRun3_left = [allSubjectPupilRun3_left; all_subj_pupil_data_left_kept{4,subject}];
    elseif size(all_subj_pupil_data_left_kept{4,subject},1) == 2;
        allSubjectPupilRun3_left = [allSubjectPupilRun3_left; (all_subj_pupil_data_left_kept{4,subject}(1,:)*all_subj_pupil_data_left_kept{10,subject}(1) + all_subj_pupil_data_left_kept{4,subject}(2,:)*all_subj_pupil_data_left_kept{10,subject}(2))/sum(all_subj_pupil_data_left_kept{10,subject})];
    end
    
    if isempty(all_subj_pupil_data_left_kept{5,subject});
        allSubjectPupilRun4_left = [allSubjectPupilRun4_left; nan(1,8000)];
    elseif size(all_subj_pupil_data_left_kept{5,subject},1) == 1;
        allSubjectPupilRun4_left = [allSubjectPupilRun4_left; all_subj_pupil_data_left_kept{5,subject}];
    elseif size(all_subj_pupil_data_left_kept{5,subject},1) == 2;
        allSubjectPupilRun4_left = [allSubjectPupilRun4_left; (all_subj_pupil_data_left_kept{5,subject}(1,:)*all_subj_pupil_data_left_kept{11,subject}(1) + all_subj_pupil_data_left_kept{5,subject}(2,:)*all_subj_pupil_data_left_kept{11,subject}(2))/sum(all_subj_pupil_data_left_kept{11,subject})];
    end
    
    if isempty(all_subj_pupil_data_left_kept{6,subject});
        allSubjectPupilRun5_left = [allSubjectPupilRun5_left; nan(1,8000)];
    elseif size(all_subj_pupil_data_left_kept{6,subject},1) == 1;
        allSubjectPupilRun5_left = [allSubjectPupilRun5_left; all_subj_pupil_data_left_kept{6,subject}];
    elseif size(all_subj_pupil_data_left_kept{6,subject},1) == 2;
        allSubjectPupilRun5_left = [allSubjectPupilRun5_left; (all_subj_pupil_data_left_kept{6,subject}(1,:)*all_subj_pupil_data_left_kept{12,subject}(1) + all_subj_pupil_data_left_kept{6,subject}(2,:)*all_subj_pupil_data_left_kept{12,subject}(2))/sum(all_subj_pupil_data_left_kept{12,subject})];
    end
    
     if isempty(all_subj_pupil_data_left_kept{7,subject});
        allSubjectPupilRun6_left = [allSubjectPupilRun6_left; nan(1,8000)];
    elseif size(all_subj_pupil_data_left_kept{7,subject},1) == 1;
        allSubjectPupilRun6_left = [allSubjectPupilRun6_left; all_subj_pupil_data_left_kept{7,subject}];
    elseif size(all_subj_pupil_data_left_kept{7,subject},1) == 2;
        allSubjectPupilRun6_left = [allSubjectPupilRun6_left; (all_subj_pupil_data_left_kept{7,subject}(1,:)*all_subj_pupil_data_left_kept{13,subject}(1) + all_subj_pupil_data_left_kept{7,subject}(2,:)*all_subj_pupil_data_left_kept{13,subject}(2))/sum(all_subj_pupil_data_left_kept{13,subject})];
    end
    
end

allSubjectPupilRun1_right = [];
allSubjectPupilRun2_right = [];
allSubjectPupilRun3_right = [];
allSubjectPupilRun4_right = [];
allSubjectPupilRun5_right = [];
allSubjectPupilRun6_right = [];

for subject = 1:length(all_subj_pupil_data_right_kept)
    if isempty(all_subj_pupil_data_right_kept{2,subject});
        allSubjectPupilRun1_right = [allSubjectPupilRun1_right; nan(1,8000)];
    elseif size(all_subj_pupil_data_right_kept{2,subject},1) == 1;
        allSubjectPupilRun1_right = [allSubjectPupilRun1_right; all_subj_pupil_data_right_kept{2,subject}];
    elseif size(all_subj_pupil_data_right_kept{2,subject},1) == 2;
        allSubjectPupilRun1_right = [allSubjectPupilRun1_right; (all_subj_pupil_data_right_kept{2,subject}(1,:)*all_subj_pupil_data_right_kept{8,subject}(1) + all_subj_pupil_data_right_kept{2,subject}(2,:)*all_subj_pupil_data_right_kept{8,subject}(2))/sum(all_subj_pupil_data_right_kept{8,subject})];
    end
    
    if isempty(all_subj_pupil_data_right_kept{3,subject});
        allSubjectPupilRun2_right = [allSubjectPupilRun2_right; nan(1,8000)];
    elseif size(all_subj_pupil_data_right_kept{3,subject},1) == 1;
        allSubjectPupilRun2_right = [allSubjectPupilRun2_right; all_subj_pupil_data_right_kept{3,subject}];
    elseif size(all_subj_pupil_data_right_kept{3,subject},1) == 2;
        allSubjectPupilRun2_right = [allSubjectPupilRun2_right; (all_subj_pupil_data_right_kept{3,subject}(1,:)*all_subj_pupil_data_right_kept{9,subject}(1) + all_subj_pupil_data_right_kept{3,subject}(2,:)*all_subj_pupil_data_right_kept{9,subject}(2))/sum(all_subj_pupil_data_right_kept{9,subject})];
    end
    
    if isempty(all_subj_pupil_data_right_kept{4,subject});
        allSubjectPupilRun3_right = [allSubjectPupilRun3_right; nan(1,8000)];
    elseif size(all_subj_pupil_data_right_kept{4,subject},1) == 1;
        allSubjectPupilRun3_right = [allSubjectPupilRun3_right; all_subj_pupil_data_right_kept{4,subject}];
    elseif size(all_subj_pupil_data_right_kept{4,subject},1) == 2;
        allSubjectPupilRun3_right = [allSubjectPupilRun3_right; (all_subj_pupil_data_right_kept{4,subject}(1,:)*all_subj_pupil_data_right_kept{10,subject}(1) + all_subj_pupil_data_right_kept{4,subject}(2,:)*all_subj_pupil_data_right_kept{10,subject}(2))/sum(all_subj_pupil_data_right_kept{10,subject})];
    end
    
    if isempty(all_subj_pupil_data_right_kept{5,subject});
        allSubjectPupilRun4_right = [allSubjectPupilRun4_right; nan(1,8000)];
    elseif size(all_subj_pupil_data_right_kept{5,subject},1) == 1;
        allSubjectPupilRun4_right = [allSubjectPupilRun4_right; all_subj_pupil_data_right_kept{5,subject}];
    elseif size(all_subj_pupil_data_right_kept{5,subject},1) == 2;
        allSubjectPupilRun4_right = [allSubjectPupilRun4_right; (all_subj_pupil_data_right_kept{5,subject}(1,:)*all_subj_pupil_data_right_kept{11,subject}(1) + all_subj_pupil_data_right_kept{5,subject}(2,:)*all_subj_pupil_data_right_kept{11,subject}(2))/sum(all_subj_pupil_data_right_kept{11,subject})];
    end
    
    if isempty(all_subj_pupil_data_right_kept{6,subject});
        allSubjectPupilRun5_right = [allSubjectPupilRun5_right; nan(1,8000)];
    elseif size(all_subj_pupil_data_right_kept{6,subject},1) == 1;
        allSubjectPupilRun5_right = [allSubjectPupilRun5_right; all_subj_pupil_data_right_kept{6,subject}];
    elseif size(all_subj_pupil_data_right_kept{6,subject},1) == 2;
        allSubjectPupilRun5_right = [allSubjectPupilRun5_right; (all_subj_pupil_data_right_kept{6,subject}(1,:)*all_subj_pupil_data_right_kept{12,subject}(1) + all_subj_pupil_data_right_kept{6,subject}(2,:)*all_subj_pupil_data_right_kept{12,subject}(2))/sum(all_subj_pupil_data_right_kept{12,subject})];
    end
    
     if isempty(all_subj_pupil_data_right_kept{7,subject});
        allSubjectPupilRun6_right = [allSubjectPupilRun6_right; nan(1,8000)];
    elseif size(all_subj_pupil_data_right_kept{7,subject},1) == 1;
        allSubjectPupilRun6_right = [allSubjectPupilRun6_right; all_subj_pupil_data_right_kept{7,subject}];
    elseif size(all_subj_pupil_data_right_kept{7,subject},1) == 2;
        allSubjectPupilRun6_right = [allSubjectPupilRun6_right; (all_subj_pupil_data_right_kept{7,subject}(1,:)*all_subj_pupil_data_right_kept{13,subject}(1) + all_subj_pupil_data_right_kept{7,subject}(2,:)*all_subj_pupil_data_right_kept{13,subject}(2))/sum(all_subj_pupil_data_right_kept{13,subject})];
    end
    
end

%%

colorset = jet(6);
aware_sem_run1 = zeros(1,8000);

for point = 1:length(allSubjectPupilRun1_left)
    SEM_run1(point) = nanstd(allSubjectPupilRun1_left(:,point))/ sqrt(size(allSubjectPupilRun1_left,1));
end
for point = 1:length(allSubjectPupilRun2_left)
    SEM_run2(point) = nanstd(allSubjectPupilRun2_left(:,point))/ sqrt(size(allSubjectPupilRun2_left,1));
end
for point = 1:length(allSubjectPupilRun3_left)
    SEM_run3(point) = nanstd(allSubjectPupilRun3_left(:,point))/ sqrt(size(allSubjectPupilRun3_left,1));
end
for point = 1:length(allSubjectPupilRun4_left)
    SEM_run4(point) = nanstd(allSubjectPupilRun4_left(:,point))/ sqrt(size(allSubjectPupilRun4_left,1));
end
for point = 1:length(allSubjectPupilRun5_left)
    SEM_run5(point) = nanstd(allSubjectPupilRun5_left(:,point))/ sqrt(size(allSubjectPupilRun5_left,1));
end
for point = 1:length(allSubjectPupilRun6_left)
    SEM_run6(point) = nanstd(allSubjectPupilRun6_left(:,point))/ sqrt(size(allSubjectPupilRun6_left,1));
end

figure;
hold on;
patch([-3999:4000 fliplr(-3999:4000)], [nanmean(allSubjectPupilRun1_left)-SEM_run1 fliplr(nanmean(allSubjectPupilRun1_left)+SEM_run1)], colorset(1,:),'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-3999:4000 fliplr(-3999:4000)], [nanmean(allSubjectPupilRun2_left)-SEM_run2 fliplr(nanmean(allSubjectPupilRun2_left)+SEM_run2)], colorset(2,:),'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-3999:4000 fliplr(-3999:4000)], [nanmean(allSubjectPupilRun3_left)-SEM_run3 fliplr(nanmean(allSubjectPupilRun3_left)+SEM_run3)], colorset(3,:),'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-3999:4000 fliplr(-3999:4000)], [nanmean(allSubjectPupilRun4_left)-SEM_run4 fliplr(nanmean(allSubjectPupilRun4_left)+SEM_run4)], colorset(4,:),'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-3999:4000 fliplr(-3999:4000)], [nanmean(allSubjectPupilRun5_left)-SEM_run5 fliplr(nanmean(allSubjectPupilRun5_left)+SEM_run5)], colorset(5,:),'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-3999:4000 fliplr(-3999:4000)], [nanmean(allSubjectPupilRun6_left)-SEM_run6 fliplr(nanmean(allSubjectPupilRun6_left)+SEM_run6)], colorset(6,:),'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')


plot(-3999:4000,nanmean(allSubjectPupilRun1_left),'Color',colorset(1,:),'LineWidth',5);
plot(-3999:4000,nanmean(allSubjectPupilRun2_left),'Color',colorset(2,:),'LineWidth',5);
plot(-3999:4000,nanmean(allSubjectPupilRun3_left),'Color',colorset(3,:),'LineWidth',5);
plot(-3999:4000,nanmean(allSubjectPupilRun4_left),'Color',colorset(4,:),'LineWidth',5);
plot(-3999:4000,nanmean(allSubjectPupilRun5_left),'Color',colorset(5,:),'LineWidth',5);
plot(-3999:4000,nanmean(allSubjectPupilRun6_left),'Color',colorset(6,:),'LineWidth',5);

title(['Pupil Diameter by Run, Left, N = ' num2str(size(allSubjectPupilRun1_left,1))])
legend({'Run 1','Run 2','Run 3','Run 4','Run 5','Run 6'})
xlim([-2000 2000])
ylim([3.4 4.2])
set(gca,'FontSize',24)
ylabel('Pupil Diameter (mm)')
xlabel('Time from Confirm')


for point = 1:length(allSubjectPupilRun1_right)
    SEM_run1(point) = nanstd(allSubjectPupilRun1_right(:,point))/ sqrt(size(allSubjectPupilRun1_right,1));
end
for point = 1:length(allSubjectPupilRun2_right)
    SEM_run2(point) = nanstd(allSubjectPupilRun2_right(:,point))/ sqrt(size(allSubjectPupilRun2_right,1));
end
for point = 1:length(allSubjectPupilRun3_right)
    SEM_run3(point) = nanstd(allSubjectPupilRun3_right(:,point))/ sqrt(size(allSubjectPupilRun3_right,1));
end
for point = 1:length(allSubjectPupilRun4_right)
    SEM_run4(point) = nanstd(allSubjectPupilRun4_right(:,point))/ sqrt(size(allSubjectPupilRun4_right,1));
end
for point = 1:length(allSubjectPupilRun5_right)
    SEM_run5(point) = nanstd(allSubjectPupilRun5_right(:,point))/ sqrt(size(allSubjectPupilRun5_right,1));
end
for point = 1:length(allSubjectPupilRun6_right)
    SEM_run6(point) = nanstd(allSubjectPupilRun6_right(:,point))/ sqrt(size(allSubjectPupilRun6_right,1));
end

figure;
hold on;
patch([-3999:4000 fliplr(-3999:4000)], [nanmean(allSubjectPupilRun1_right)-SEM_run1 fliplr(nanmean(allSubjectPupilRun1_right)+SEM_run1)], colorset(1,:),'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-3999:4000 fliplr(-3999:4000)], [nanmean(allSubjectPupilRun2_right)-SEM_run2 fliplr(nanmean(allSubjectPupilRun2_right)+SEM_run2)], colorset(2,:),'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-3999:4000 fliplr(-3999:4000)], [nanmean(allSubjectPupilRun3_right)-SEM_run3 fliplr(nanmean(allSubjectPupilRun3_right)+SEM_run3)], colorset(3,:),'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-3999:4000 fliplr(-3999:4000)], [nanmean(allSubjectPupilRun4_right)-SEM_run4 fliplr(nanmean(allSubjectPupilRun4_right)+SEM_run4)], colorset(4,:),'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-3999:4000 fliplr(-3999:4000)], [nanmean(allSubjectPupilRun5_right)-SEM_run5 fliplr(nanmean(allSubjectPupilRun5_right)+SEM_run5)], colorset(5,:),'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-3999:4000 fliplr(-3999:4000)], [nanmean(allSubjectPupilRun6_right)-SEM_run6 fliplr(nanmean(allSubjectPupilRun6_right)+SEM_run6)], colorset(6,:),'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')


plot(-3999:4000,nanmean(allSubjectPupilRun1_right),'Color',colorset(1,:),'LineWidth',5);
plot(-3999:4000,nanmean(allSubjectPupilRun2_right),'Color',colorset(2,:),'LineWidth',5);
plot(-3999:4000,nanmean(allSubjectPupilRun3_right),'Color',colorset(3,:),'LineWidth',5);
plot(-3999:4000,nanmean(allSubjectPupilRun4_right),'Color',colorset(4,:),'LineWidth',5);
plot(-3999:4000,nanmean(allSubjectPupilRun5_right),'Color',colorset(5,:),'LineWidth',5);
plot(-3999:4000,nanmean(allSubjectPupilRun6_right),'Color',colorset(6,:),'LineWidth',5);



title(['Pupil Diameter by Run, Right, N = ' num2str(size(allSubjectPupilRun1_right,1))])
legend({'Run 1','Run 2','Run 3','Run 4','Run 5','Run 6'})
xlim([-2000 2000])
ylim([3.4 4.2])
set(gca,'FontSize',24)
ylabel('Pupil Diameter (mm)')
xlabel('Time from Confirm')

%% Only Run 1 and Run 6



colorset = jet(6);
aware_sem_run1 = zeros(1,8000);

for point = 1:length(allSubjectPupilRun1_left)
    SEM_run1(point) = nanstd(allSubjectPupilRun1_left(:,point))/ sqrt(size(allSubjectPupilRun1_left,1));
end
for point = 1:length(allSubjectPupilRun2_left)
    SEM_run2(point) = nanstd(allSubjectPupilRun2_left(:,point))/ sqrt(size(allSubjectPupilRun2_left,1));
end
for point = 1:length(allSubjectPupilRun3_left)
    SEM_run3(point) = nanstd(allSubjectPupilRun3_left(:,point))/ sqrt(size(allSubjectPupilRun3_left,1));
end
for point = 1:length(allSubjectPupilRun4_left)
    SEM_run4(point) = nanstd(allSubjectPupilRun4_left(:,point))/ sqrt(size(allSubjectPupilRun4_left,1));
end
for point = 1:length(allSubjectPupilRun5_left)
    SEM_run5(point) = nanstd(allSubjectPupilRun5_left(:,point))/ sqrt(size(allSubjectPupilRun5_left,1));
end
for point = 1:length(allSubjectPupilRun6_left)
    SEM_run6(point) = nanstd(allSubjectPupilRun6_left(:,point))/ sqrt(size(allSubjectPupilRun6_left,1));
end

figure;
hold on;
patch([-3999:4000 fliplr(-3999:4000)], [nanmean(allSubjectPupilRun1_left)-SEM_run1 fliplr(nanmean(allSubjectPupilRun1_left)+SEM_run1)], colorset(1,:),'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-3999:4000 fliplr(-3999:4000)], [nanmean(allSubjectPupilRun6_left)-SEM_run6 fliplr(nanmean(allSubjectPupilRun6_left)+SEM_run6)], colorset(6,:),'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')


plot(-3999:4000,nanmean(allSubjectPupilRun1_left),'Color',colorset(1,:),'LineWidth',5);
plot(-3999:4000,nanmean(allSubjectPupilRun6_left),'Color',colorset(6,:),'LineWidth',5);


title(['Pupil Diameter by Run, Runs 1 and 6, N = ' num2str(size(allSubjectPupilRun1_left,1))])
legend({'Run 1','Run 5'})
xlim([-2000 2000])
ylim([3.4 4.2])
set(gca,'FontSize',24)
ylabel('Pupil Diameter (mm)')
xlabel('Time from Confirm')


for point = 1:length(allSubjectPupilRun1_right)
    SEM_run1(point) = nanstd(allSubjectPupilRun1_right(:,point))/ sqrt(size(allSubjectPupilRun1_right,1));
end
for point = 1:length(allSubjectPupilRun2_right)
    SEM_run2(point) = nanstd(allSubjectPupilRun2_right(:,point))/ sqrt(size(allSubjectPupilRun2_right,1));
end
for point = 1:length(allSubjectPupilRun3_right)
    SEM_run3(point) = nanstd(allSubjectPupilRun3_right(:,point))/ sqrt(size(allSubjectPupilRun3_right,1));
end
for point = 1:length(allSubjectPupilRun4_right)
    SEM_run4(point) = nanstd(allSubjectPupilRun4_right(:,point))/ sqrt(size(allSubjectPupilRun4_right,1));
end
for point = 1:length(allSubjectPupilRun5_right)
    SEM_run5(point) = nanstd(allSubjectPupilRun5_right(:,point))/ sqrt(size(allSubjectPupilRun5_right,1));
end
for point = 1:length(allSubjectPupilRun6_right)
    SEM_run6(point) = nanstd(allSubjectPupilRun6_right(:,point))/ sqrt(size(allSubjectPupilRun6_right,1));
end

figure;
hold on;
patch([-3999:4000 fliplr(-3999:4000)], [nanmean(allSubjectPupilRun1_right)-SEM_run1 fliplr(nanmean(allSubjectPupilRun1_right)+SEM_run1)], colorset(1,:),'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')
patch([-3999:4000 fliplr(-3999:4000)], [nanmean(allSubjectPupilRun6_right)-SEM_run6 fliplr(nanmean(allSubjectPupilRun6_right)+SEM_run6)], colorset(6,:),'FaceVertexAlphaData',0.1,'FaceAlpha','flat','LineStyle','none')


plot(-3999:4000,nanmean(allSubjectPupilRun1_right),'Color',colorset(1,:),'LineWidth',5);
plot(-3999:4000,nanmean(allSubjectPupilRun6_right),'Color',colorset(6,:),'LineWidth',5);

title(['Pupil Diameter, Runs 1 and 6, Right, N = ' num2str(size(allSubjectPupilRun1_right,1))])
legend({'Run 1','Run 6'})
xlim([-2000 2000])
ylim([3.4 4.2])
set(gca,'FontSize',24)
ylabel('Pupil Diameter (mm)')
xlabel('Time from Confirm')

%% Perform calculations with B-H FWE procedure

pupil_means_run1 = mean(allSubjectPupilRun1_right(:,3001:4000),2);
pupil_means_run2 = mean(allSubjectPupilRun2_right(:,3001:4000),2);
pupil_means_run3 = mean(allSubjectPupilRun3_right(:,3001:4000),2);
pupil_means_run4 = mean(allSubjectPupilRun4_right(:,3001:4000),2);
pupil_means_run5 = mean(allSubjectPupilRun5_right(:,3001:4000),2);
pupil_means_run6 = mean(allSubjectPupilRun6_right(:,3001:4000),2);
figure;
hold on

boxplot([pupil_means_run1' pupil_means_run2' pupil_means_run3' pupil_means_run4' pupil_means_run5' pupil_means_run6'],[ones(1,size(pupil_means_run1,1)) ones(1,size(pupil_means_run2,1))*2 ones(1,size(pupil_means_run3,1))*3 ones(1,size(pupil_means_run4,1))*4 ones(1,size(pupil_means_run5,1))*5 ones(1,size(pupil_means_run6,1))*6],'labels',{'Run 1','Run 2','Run 3','Run 4','Run 5','Run 6'})


swarmchart(ones(1,size(pupil_means_run1,1)),pupil_means_run1,'filled','XJitterWidth',0.3,'MarkerFaceColor',colorset(1,:),'MarkerEdgeColor',colorset(1,:),'SizeData',150)
swarmchart(ones(1,size(pupil_means_run2,1))*2,pupil_means_run2,'filled','XJitterWidth',0.3,'MarkerFaceColor',colorset(2,:),'MarkerEdgeColor',colorset(2,:),'SizeData',150)
swarmchart(ones(1,size(pupil_means_run3,1))*3,pupil_means_run3,'filled','XJitterWidth',0.3,'MarkerFaceColor',colorset(3,:),'MarkerEdgeColor',colorset(3,:),'SizeData',150)
swarmchart(ones(1,size(pupil_means_run4,1))*4,pupil_means_run4,'filled','XJitterWidth',0.3,'MarkerFaceColor',colorset(4,:),'MarkerEdgeColor',colorset(4,:),'SizeData',150)
swarmchart(ones(1,size(pupil_means_run5,1))*5,pupil_means_run5,'filled','XJitterWidth',0.3,'MarkerFaceColor',colorset(5,:),'MarkerEdgeColor',colorset(5,:),'SizeData',150)
swarmchart(ones(1,size(pupil_means_run6,1))*6,pupil_means_run6,'filled','XJitterWidth',0.3,'MarkerFaceColor',colorset(6,:),'MarkerEdgeColor',colorset(6,:),'SizeData',150)

title('Average Pupil Diameter, -1000 ms to Action Confirmation, Right Eye')
set(gca,'FontSize',24)
ylabel('Pupil Diameter (mm)')

data = [pupil_means_run1 pupil_means_run2 pupil_means_run3 pupil_means_run4 pupil_means_run5 pupil_means_run6];
timepoints = 1:6;
% Perform pairwise paired t-tests with pairwise complete case analysis
p_values = nan(numel(timepoints), numel(timepoints));
for i = 1:numel(timepoints)
    for j = 1:numel(timepoints)
        if i == j
            continue;  % Skip if comparing the same timepoint
        end

        % Perform pairwise complete case analysis
        valid_indices = ~isnan(data(:, i)) & ~isnan(data(:, j));
        if any(valid_indices)
            x = data(valid_indices, i);
            y = data(valid_indices, j);
            [~, p_values(i, j)] = ttest(x, y, 'Alpha', 0.05);
        else
            p_values(i, j) = NaN;  % Assign NaN if no complete cases exist
        end
    end
end

% Apply Benjamini-Hochberg procedure to p-values
p_values_vector = reshape(p_values, [], 1);
valid_p_values = p_values_vector(~isnan(p_values_vector));  % Exclude NaN p-values
adjusted_p_values = zeros(size(p_values));
adjusted_p_values(~isnan(p_values)) = mafdr(valid_p_values, 'BHFDR', true);  % Apply Benjamini-Hochberg procedure

% Display adjusted p-values
fprintf('Pairwise paired t-test adjusted p-values (Benjamini-Hochberg procedure):\n');
disp(adjusted_p_values);


p_values_compared_to_run1 = mafdr( p_values(1,2:6), 'BHFDR', true);
disp(['Adjusted p-values for run 1 tests only, right eye' ])
disp(p_values_compared_to_run1)
        
semRun1 = nanstd(pupil_means_run1)/sqrt(length(pupil_means_run1));
semRun2 = nanstd(pupil_means_run2)/sqrt(length(pupil_means_run2));
semRun3 = nanstd(pupil_means_run3)/sqrt(length(pupil_means_run3));
semRun4 = nanstd(pupil_means_run4)/sqrt(length(pupil_means_run4));
semRun5 = nanstd(pupil_means_run5)/sqrt(length(pupil_means_run5));
semRun6 = nanstd(pupil_means_run6)/sqrt(length(pupil_means_run6));


semRun1 = nanstd(pupil_means_run1)/sqrt(length(pupil_means_run1));
semRun2 = nanstd(pupil_means_run2)/sqrt(length(pupil_means_run2));
semRun3 = nanstd(pupil_means_run3)/sqrt(length(pupil_means_run3));
semRun4 = nanstd(pupil_means_run4)/sqrt(length(pupil_means_run4));
semRun5 = nanstd(pupil_means_run5)/sqrt(length(pupil_means_run5));
semRun6 = nanstd(pupil_means_run6)/sqrt(length(pupil_means_run6));

figure;
hold on;
plot(1:6,[nanmean(pupil_means_run1) nanmean(pupil_means_run2) nanmean(pupil_means_run3) nanmean(pupil_means_run4) nanmean(pupil_means_run5) nanmean(pupil_means_run6)],'LineWidth',3,'Color','b');
errorbar([nanmean(pupil_means_run1) nanmean(pupil_means_run2) nanmean(pupil_means_run3) nanmean(pupil_means_run4) nanmean(pupil_means_run5) nanmean(pupil_means_run6)],[semRun1 semRun2 semRun3 semRun4 semRun5 semRun6],'linestyle','none','LineWidth',3,'Color','r')
scatter([2 3 4 5 6], [3.9 3.9 3.9 3.9 3.9],256,'*','black','LineWidth',3)
set(gca,'FontSize',24)
xlim([1 6])
ylim([3.4 4])
ax = gca;
ax.XTick = unique( round(ax.XTick) );
xlabel(['Run'])
ylabel('Pupil Diameter (mm)')
title(['Average Pre-Action Pupil Diameter, Right, N = ' num2str(length(pupil_means_run1))])

pupil_means_run1 = mean(allSubjectPupilRun1_left(:,3001:4000),2);
pupil_means_run2 = mean(allSubjectPupilRun2_left(:,3001:4000),2);
pupil_means_run3 = mean(allSubjectPupilRun3_left(:,3001:4000),2);
pupil_means_run4 = mean(allSubjectPupilRun4_left(:,3001:4000),2);
pupil_means_run5 = mean(allSubjectPupilRun5_left(:,3001:4000),2);
pupil_means_run6 = mean(allSubjectPupilRun6_left(:,3001:4000),2);
figure;
hold on

boxplot([pupil_means_run1' pupil_means_run2' pupil_means_run3' pupil_means_run4' pupil_means_run5' pupil_means_run6'],[ones(1,size(pupil_means_run1,1)) ones(1,size(pupil_means_run2,1))*2 ones(1,size(pupil_means_run3,1))*3 ones(1,size(pupil_means_run4,1))*4 ones(1,size(pupil_means_run5,1))*5 ones(1,size(pupil_means_run6,1))*6],'labels',{'Run 1','Run 2','Run 3','Run 4','Run 5','Run 6'})


swarmchart(ones(1,size(pupil_means_run1,1)),pupil_means_run1,'filled','XJitterWidth',0.3,'MarkerFaceColor',colorset(1,:),'MarkerEdgeColor',colorset(1,:),'SizeData',150)
swarmchart(ones(1,size(pupil_means_run2,1))*2,pupil_means_run2,'filled','XJitterWidth',0.3,'MarkerFaceColor',colorset(2,:),'MarkerEdgeColor',colorset(2,:),'SizeData',150)
swarmchart(ones(1,size(pupil_means_run3,1))*3,pupil_means_run3,'filled','XJitterWidth',0.3,'MarkerFaceColor',colorset(3,:),'MarkerEdgeColor',colorset(3,:),'SizeData',150)
swarmchart(ones(1,size(pupil_means_run4,1))*4,pupil_means_run4,'filled','XJitterWidth',0.3,'MarkerFaceColor',colorset(4,:),'MarkerEdgeColor',colorset(4,:),'SizeData',150)
swarmchart(ones(1,size(pupil_means_run5,1))*5,pupil_means_run5,'filled','XJitterWidth',0.3,'MarkerFaceColor',colorset(5,:),'MarkerEdgeColor',colorset(5,:),'SizeData',150)
swarmchart(ones(1,size(pupil_means_run6,1))*6,pupil_means_run6,'filled','XJitterWidth',0.3,'MarkerFaceColor',colorset(6,:),'MarkerEdgeColor',colorset(6,:),'SizeData',150)

title('Average Pupil Diameter, -1000 ms to Action Confirmation, Left Eye')
set(gca,'FontSize',24)
ylabel('Pupil Diameter (mm)')

data = [pupil_means_run1 pupil_means_run2 pupil_means_run3 pupil_means_run4 pupil_means_run5 pupil_means_run6];
timepoints = 1:6;
% Perform pairwise paired t-tests with pairwise complete case analysis
p_values = nan(numel(timepoints), numel(timepoints));
for i = 1:numel(timepoints)
    for j = 1:numel(timepoints)
        if i == j
            continue;  % Skip if comparing the same timepoint
        end

        % Perform pairwise complete case analysis
        valid_indices = ~isnan(data(:, i)) & ~isnan(data(:, j));
        if any(valid_indices)
            x = data(valid_indices, i);
            y = data(valid_indices, j);
            [~, p_values(i, j)] = ttest(x, y, 'Alpha', 0.05);
        else
            p_values(i, j) = NaN;  % Assign NaN if no complete cases exist
        end
    end
end

% Apply Benjamini-Hochberg procedure to p-values
p_values_vector = reshape(p_values, [], 1);
valid_p_values = p_values_vector(~isnan(p_values_vector));  % Exclude NaN p-values
adjusted_p_values = zeros(size(p_values));
adjusted_p_values(~isnan(p_values)) = mafdr(valid_p_values, 'BHFDR', true);  % Apply Benjamini-Hochberg procedure

% Display adjusted p-values
fprintf('Pairwise paired t-test adjusted p-values (Benjamini-Hochberg procedure):\n');
disp(adjusted_p_values);


p_values_compared_to_run1 = mafdr( p_values(1,2:6), 'BHFDR', true);
disp(['Adjusted p-values for run 1 tests only, left eye' ])
disp(p_values_compared_to_run1)
        
semRun1 = nanstd(pupil_means_run1)/sqrt(length(pupil_means_run1));
semRun2 = nanstd(pupil_means_run2)/sqrt(length(pupil_means_run2));
semRun3 = nanstd(pupil_means_run3)/sqrt(length(pupil_means_run3));
semRun4 = nanstd(pupil_means_run4)/sqrt(length(pupil_means_run4));
semRun5 = nanstd(pupil_means_run5)/sqrt(length(pupil_means_run5));
semRun6 = nanstd(pupil_means_run6)/sqrt(length(pupil_means_run6));

figure;
hold on;
plot(1:6,[nanmean(pupil_means_run1) nanmean(pupil_means_run2) nanmean(pupil_means_run3) nanmean(pupil_means_run4) nanmean(pupil_means_run5) nanmean(pupil_means_run6)],'LineWidth',3,'Color','b');
errorbar([nanmean(pupil_means_run1) nanmean(pupil_means_run2) nanmean(pupil_means_run3) nanmean(pupil_means_run4) nanmean(pupil_means_run5) nanmean(pupil_means_run6)],[semRun1 semRun2 semRun3 semRun4 semRun5 semRun6],'linestyle','none','LineWidth',3,'Color','r')
scatter([2 3 4 5 6], [3.9 3.9 3.9 3.9 3.9],256,'*','black','LineWidth',3)
set(gca,'FontSize',24)
xlim([1 6])
ylim([3.4 4])
ax = gca;
ax.XTick = unique( round(ax.XTick) );
xlabel(['Run'])
ylabel('Pupil Diameter (mm)')
title(['Average Pre-Action Pupil Diameter, Left, N = ' num2str(length(pupil_means_run1))])





%% Save figures as PNGs
cd('/gpfs/gibbs/pi/blumenfeld/dsj8/AoA_Study/Pupil_Figures')
% Step 1: Get handles to all open figures
figHandles = findall(0, 'Type', 'figure');

% Step 2: Iterate through each open figure
for i = 1:length(figHandles)
    % Switch focus to the current figure
    figure(figHandles(i));
    
    % Get the title of the current figure
    figTitle = get(get(gca, 'Title'), 'String');
    set(gcf, 'Position', get(0, 'Screensize'));
    % If the title is empty, skip saving this figure
    if isempty(figTitle)
        continue;
    end
    
    % Set the 'Name' property to the figure title
    set(figHandles(i), 'Name', figTitle);
    
    % Replace spaces in the title with underscores to make a valid file name
    figTitle = strrep(figTitle, ' ', '_');
    
    % Save the figure as a .fig file
    figFileName = sprintf('%s.fig', figTitle);
    saveas(figHandles(i), figFileName);
    
    % Save the figure as a .png file
    pngFileName = sprintf('%s.png', figTitle);
    saveas(figHandles(i), pngFileName, 'png');
end
