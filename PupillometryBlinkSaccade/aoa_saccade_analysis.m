function unusable = aoa_saccade_analysis(sheetToRead);
    addpath('Y:\HNCT_AoA_Study\EyeLink_EDF_Reading')
    addpath(genpath('Y:\HNCT_AoA_Study\EyeLink_EDF_Reading'))
    addpath(genpath('Y:\HNCT_AoA_Study\AoA_Pipeline\AoA_Eyelink_Analysis\Create Session EyelinkTables\'));
    [num text raw] = xlsread(sheetToRead);

    %% Instantiate variables
    sacEpochAwareLAll = [];
    sacEpochAwareRAll = [];
    sacEpochUnawareLAll = [];
    sacEpochUnawareRAll = [];
    sacEpochMLLAll = [];
    sacEpochMLRAll = [];
    sacEpochMHLAll = [];
    sacEpochMHRAll = [];
    unusable = [];
    tic
    for subject = 1:size(text,2) % Iterate over subjects, performing analysis
        sessionPath = ['Y:\HNCT_AoA_Study\AoA_Subjects\'  raw{1,subject} '\' raw{2,subject} '\'];
        cd(sessionPath)
        fullsession = num2str(raw{3,subject});
        disp(['Analyzing ' raw{1,subject}])  
        for run = 1:6
            try
                session = [ fullsession(5:8) fullsession(10:11) num2str(run)];
                if isfile([sessionPath '/' session '_saccade.mat'])
                    continue
                end
                eval(['load ' session(1:6) num2str(run) '_eyedat_left.mat;']);

                %% Parameters
                currentGazeBlinkedLR = [];
                %Degree lower and upper for macrosaccades
                saccadeThresholdLower = 3;
                saccadeThresholdHigher = 7;

                %From the monitor manufacturer's website, pixel pitch = .254mm per pixel
                pixelPitch = 0.254; 

                %Screen center where eyes are fixated
                screenCenter_x = (1280/2);
                screenCenter_y = (768/2);

                %Distance from bridge of nose to center of screen (mm)
                distanceFromScreen = 550; 

                %To find when there is a simulatenous (binoc) microsaccade or saccade
                %Set this to be the number of time points that overlap between left and right eyes 
                sacOverlap = 1; 

                %%
                currentGazeXBlinked = currentGazeX;
                currentGazeYBlinked = currentGazeY;
                for timepoint = 1:length(currentGazeX)
                    if blinktimes(timepoint) == 1
                        currentGazeXBlinked(timepoint) = NaN;
                        currentGazeYBlinked(timepoint) = NaN;
                    end
                    if currentGazeXBlinked(timepoint) == 100000000
                        currentGazeXBlinked(timepoint) = NaN;
                    end
                    if currentGazeYBlinked(timepoint) == 100000000
                        currentGazeYBlinked(timepoint) = NaN;
                    end
                end
                currentGazeBlinkedLR = [currentGazeBlinkedLR; currentGazeXBlinked; currentGazeYBlinked];

                %%
                eval(['load ' session(1:6) num2str(run) '_eyedat_right.mat;']);

                currentGazeXBlinked = currentGazeX;
                currentGazeYBlinked = currentGazeY;
                for timepoint = 1:length(currentGazeX)
                    if blinktimes(timepoint) == 1
                        currentGazeXBlinked(timepoint) = NaN;
                        currentGazeYBlinked(timepoint) = NaN;
                    end
                    if currentGazeXBlinked(timepoint) == 100000000
                        currentGazeXBlinked(timepoint) = NaN;
                    end
                    if currentGazeYBlinked(timepoint) == 100000000
                        currentGazeYBlinked(timepoint) = NaN;
                    end
                end
                currentGazeBlinkedLR = [currentGazeBlinkedLR; currentGazeXBlinked; currentGazeYBlinked];

                %%
                currentGazes = currentGazeBlinkedLR;

                currentGazes([1 3],:) = currentGazeBlinkedLR([1 3],:)-screenCenter_x;
                currentGazes([2 4],:) = -(currentGazeBlinkedLR([2 4],:)-screenCenter_y);

                currentGazes = currentGazes.*(pixelPitch);
                currentGazes = atand(currentGazes./distanceFromScreen);

                currentGazesLeft = currentGazes([1 2],:);
                currentGazesRight = currentGazes([3 4],:);

                %% Left Eye Saccades

                if(sum(sum(isnan(currentGazesLeft)))) < 2*size(currentGazesLeft,2)/3

                    % Use Engbert & Mergenthaler algorithm
                    [allSacL,~,~,~,~,leftVel] = GetMicrosaccadesEK(currentGazesLeft,1000,5,5);

                    if isempty(allSacL)
                        allSacL = [NaN NaN NaN NaN NaN NaN NaN];
                    end

                    % Add on root square distance
                    for j = 1:size(allSacL,1)
                        allSacL(j,8) = sqrt(allSacL(j,7)^2+allSacL(j,6)^2);
                    end

                else
                    % Buffer to ensure output table is the same size as input table
                    leftVel = repmat(NaN, [1, size(currentGazesLeft,2)]);
                    allSacL = [NaN NaN NaN NaN NaN NaN NaN NaN];
                end

                % Define saccades (sacL) to be between 1-7 degrees
                sacL = allSacL(:,1:7);
                ind_sacL = [];
                for j = 1:size(sacL,1)
                    if sqrt(sacL(j,6)^2 + sacL(j,7)^2) > saccadeThresholdLower && sqrt(sacL(j,6)^2 + sacL(j,7)^2) < saccadeThresholdHigher
                        ind_sacL = [ind_sacL; j];
                    end
                end
                sacL = sacL(ind_sacL,:);

                %Create saccade binary (1 when there is a saccade)
                sacLOnes = zeros(1,size(currentGazes,2));
                for k=1:size(sacL,1)
                    sacLOnes(sacL(k,1):sacL(k,2))=1;
                end

                %% Right Eye Saccades

                if(sum(sum(isnan(currentGazesRight)))) < 2*size(currentGazesRight,2)/3

                    % Use Engbert & Mergenthaler algorithm
                    [allSacR,~,~,~,~,rightVel] = GetMicrosaccadesEK(currentGazesRight,1000,5,5);

                    if isempty(allSacR)
                        allSacR = [NaN NaN NaN NaN NaN NaN NaN];
                    end

                    % Add on root square distance
                    for j = 1:size(allSacR,1)
                        allSacR(j,8) = sqrt(allSacR(j,7)^2+allSacR(j,6)^2);
                    end

                else
                    % Buffer to ensure output table is the same size as input table
                    rightVel = repmat(NaN, [1, size(currentGazesRight,2)]);
                    allSacR = [NaN NaN NaN NaN NaN NaN NaN NaN];
                end

                % Define saccades (sacR) to be between 1-7 degrees
                sacR = allSacR(:,1:7);
                ind_sacR = [];
                for j = 1:size(sacR,1)
                    if sqrt(sacR(j,6)^2 + sacR(j,7)^2) > saccadeThresholdLower & sqrt(sacR(j,6)^2 + sacR(j,7)^2) < saccadeThresholdHigher
                        ind_sacR = [ind_sacR; j];
                    end
                end
                sacR = sacR(ind_sacR,:);

                %Create saccade binary (1 when there is a saccade)
                sacROnes = zeros(1,size(currentGazes,2));
                for k=1:size(sacR,1)
                    sacROnes(sacR(k,1):sacR(k,2))=1;
                end

                %% Generate Epochs for Rate Calculation
                sacEpochAwareR = [];
                sacEpochAwareL = [];
                

                for timepoint = 1:length(awareconfirmtimepoints)
                    if sum(blinktimes(awareconfirmtimepoints(timepoint)-3999:awareconfirmtimepoints(timepoint)+4000)) < 7999 && sum(blinktimes(awareconfirmtimepoints(timepoint)-3999:awareconfirmtimepoints(timepoint)+4000)) > 0
                        sacEpochAwareR = [sacEpochAwareR; sacROnes(awareconfirmtimepoints(timepoint)-3999:awareconfirmtimepoints(timepoint)+4000)];
                        sacEpochAwareL = [sacEpochAwareL; sacLOnes(awareconfirmtimepoints(timepoint)-3999:awareconfirmtimepoints(timepoint)+4000)];
                    end
                end

                %%
                sacEpochAwareLAll = [sacEpochAwareLAll; sacEpochAwareL];
                sacEpochAwareRAll = [sacEpochAwareRAll; sacEpochAwareR];

                sacEpochUnawareR = [];
                sacEpochUnawareL = [];

                for timepoint = 1:length(unawareconfirmtimepoints)
                    if sum(blinktimes(unawareconfirmtimepoints(timepoint)-3999:unawareconfirmtimepoints(timepoint)+4000)) < 7999 && sum(blinktimes(unawareconfirmtimepoints(timepoint)-3999:unawareconfirmtimepoints(timepoint)+4000)) > 0
                        sacEpochUnawareR = [sacEpochUnawareR; sacROnes(unawareconfirmtimepoints(timepoint)-3999:unawareconfirmtimepoints(timepoint)+4000)];
                        sacEpochUnawareL = [sacEpochUnawareL; sacLOnes(unawareconfirmtimepoints(timepoint)-3999:unawareconfirmtimepoints(timepoint)+4000)];
                    end
                end

                %%
                sacEpochUnawareLAll = [sacEpochUnawareLAll; sacEpochUnawareL];
                sacEpochUnawareRAll = [sacEpochUnawareRAll; sacEpochUnawareR];
                
                sacEpochMHR = [];
                sacEpochMHL = [];

                for timepoint = 1:length(MHconfirmtimepoints)
                    if sum(blinktimes(MHconfirmtimepoints(timepoint)-3999:MHconfirmtimepoints(timepoint)+4000)) < 7999 && sum(blinktimes(MHconfirmtimepoints(timepoint)-3999:MHconfirmtimepoints(timepoint)+4000)) > 0
                        sacEpochMHR = [sacEpochMHR; sacROnes(MHconfirmtimepoints(timepoint)-3999:MHconfirmtimepoints(timepoint)+4000)];
                        sacEpochMHL = [sacEpochMHL; sacLOnes(MHconfirmtimepoints(timepoint)-3999:MHconfirmtimepoints(timepoint)+4000)];
                    end
                end

                %%
                sacEpochMHLAll = [sacEpochMHLAll; sacEpochMHL];
                sacEpochMHRAll = [sacEpochMHRAll; sacEpochMHR];
                
                sacEpochMLR = [];
                sacEpochMLL = [];

                for timepoint = 1:length(MLconfirmtimepoints)
                    if sum(blinktimes(MLconfirmtimepoints(timepoint)-3999:MLconfirmtimepoints(timepoint)+4000)) < 7999 && sum(blinktimes(MLconfirmtimepoints(timepoint)-3999:MLconfirmtimepoints(timepoint)+4000)) > 0
                        sacEpochMLR = [sacEpochMLR; sacROnes(MLconfirmtimepoints(timepoint)-3999:MLconfirmtimepoints(timepoint)+4000)];
                        sacEpochMLL = [sacEpochMLL; sacLOnes(MLconfirmtimepoints(timepoint)-3999:MLconfirmtimepoints(timepoint)+4000)];
                    end
                end

                %%
                sacEpochMLLAll = [sacEpochMLLAll; sacEpochMLL];
                sacEpochMLRAll = [sacEpochMLRAll; sacEpochMLR];

                eval(['save ' sessionPath '/' session '_saccade.mat currentGazeBlinkedLR allSacL allSacR ind_sacL ind_sacR sacL sacLOnes sacR sacROnes sacOverlap currentGazes']);
            catch
                unusable = unusable + 1;
                continue
            end
        end
    end
    toc

    %% Saccade Percentages

    aware_sac = mean(sacEpochAwareLAll);
    aware_sem = std(sacEpochAwareLAll)/sqrt(size(sacEpochAwareLAll,1));
    unaware_sac = mean(sacEpochUnawareLAll);
    unaware_sem = std(sacEpochUnawareLAll)/sqrt(size(sacEpochUnawareLAll,1));

    aware_upper_error_lowpass = lowpass(aware_sac*100+aware_sem*100,0.5,1000);
    aware_lower_error_lowpass = lowpass(aware_sac*100-aware_sem*100,0.5,1000);
    unaware_upper_error_lowpass = lowpass(unaware_sac*100+unaware_sem*100,0.5,1000);
    unaware_lower_error_lowpass = lowpass(unaware_sac*100-unaware_sem*100,0.5,1000);


    figure;
    hold on
    plot(-3999:4000,lowpass(aware_sac*100,0.5,1000),'LineWidth',5,'Color','blue')
    plot(-3999:4000,lowpass(unaware_sac*100,0.5,1000),'LineWidth',5,'Color','red')
    patch([-3999:4000 fliplr(-3999:4000)], [aware_lower_error_lowpass fliplr(aware_upper_error_lowpass)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat')
    patch([-3999:4000 fliplr(-3999:4000)], [unaware_lower_error_lowpass fliplr(unaware_upper_error_lowpass)], [1 0 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat')


    plot(-3999:4000,aware_upper_error_lowpass,'LineWidth',1,'Color','blue')
    plot(-3999:4000,aware_lower_error_lowpass,'LineWidth',1,'Color','blue')


    plot(-3999:4000,unaware_upper_error_lowpass,'LineWidth',1,'Color','red')
    plot(-3999:4000,unaware_lower_error_lowpass,'LineWidth',1,'Color','red')



    set(gca,'FontSize',24)
    ylim([0 7])
    xlim([-1999 2000])
    ylabel('Percentage')
    xlabel('Time from Board Disappearance')
    title(['Saccade Percentages, Screen Disappearance'])
    legend({['Aware, n = ' num2str(size(sacEpochAwareLAll,1))],['Unaware, n = ' num2str(size(sacEpochUnawareLAll,1))]})


    %%
    binSize = 250;
    firstBin = 125;
    lastBin = 7875;
    all_bins_aware = zeros(size(sacEpochAwareLAll,1),length(firstBin:binSize/2:lastBin));
    all_bins_unaware = zeros(size(sacEpochUnawareLAll,1),length(firstBin:binSize/2:lastBin));
    all_bin_times = firstBin:binSize/2:lastBin;

    for epoch = 1:size(all_bins_aware,1)
        movingBin = 1;
        for bin = firstBin:binSize/2:lastBin
            currentEpoch = sacEpochAwareLAll(epoch,bin-(binSize/2)+1:bin+(binSize/2));
            if currentEpoch(1) == 0
               total_sacs = length(strfind(currentEpoch,[0 1]));
            end
            if currentEpoch(1) == 1 && currentEpoch(end) == 1
               total_sacs = length(strfind(currentEpoch,[1 0]))+1;
            end
            if currentEpoch(1) == 1 && currentEpoch(end) == 0
               total_sacs = length(strfind(currentEpoch,[1 0]));
            end
            all_bins_aware(epoch,movingBin) = total_sacs*1000/(binSize);

            movingBin = movingBin + 1;
        end
    end
    for epoch = 1:size(all_bins_unaware,1)
        movingBin = 1;
        for bin = firstBin:binSize/2:lastBin

            currentEpoch = sacEpochUnawareLAll(epoch,bin-(binSize/2)+1:bin+(binSize/2));
            if currentEpoch(1) == 0
               total_sacs = length(strfind(currentEpoch,[0 1]));
            end
            if currentEpoch(1) == 1 && currentEpoch(end) == 1
               total_sacs = length(strfind(currentEpoch,[1 0]))+1;
            end
            if currentEpoch(1) == 1 && currentEpoch(end) == 0
               total_sacs = length(strfind(currentEpoch,[1 0]));
            end
            all_bins_unaware(epoch,movingBin) = total_sacs*1000/(binSize);
            movingBin = movingBin + 1;
        end
    end


    aware_sem = std(all_bins_aware)/sqrt(size(all_bins_aware,1));
    unaware_sem = std(all_bins_unaware)/sqrt(size(all_bins_unaware,1));
    figure
    hold on
    plot(-3875:binSize/2:3875,mean(all_bins_aware),'LineWidth',5,'Color','Blue')
    plot(-3875:binSize/2:3875,mean(all_bins_unaware),'LineWidth',5,'Color','Red')


    patch([-3875:binSize/2:3875 fliplr(-3875:binSize/2:3875)], [mean(all_bins_aware)-aware_sem fliplr(mean(all_bins_aware)+aware_sem)], [0 0 1],'FaceVertexAlphaData',0.1,'FaceAlpha','flat')
    plot(-3875:binSize/2:3875,mean(all_bins_aware)+aware_sem,'LineWidth',1,'Color',[0 0 1])
    plot(-3875:binSize/2:3875,mean(all_bins_aware)-aware_sem,'LineWidth',1,'Color',[0 0 1])

    patch([-3875:binSize/2:3875 fliplr(-3875:binSize/2:3875)], [mean(all_bins_unaware)-unaware_sem fliplr(mean(all_bins_unaware)+unaware_sem)], [1 0 0],'FaceVertexAlphaData',0.1,'FaceAlpha','flat')
    plot(-3875:binSize/2:3875,mean(all_bins_unaware)+unaware_sem,'LineWidth',1,'Color',[1 0 0])
    plot(-3875:binSize/2:3875,mean(all_bins_unaware)-unaware_sem,'LineWidth',1,'Color',[1 0 0])

    set(gca,'FontSize',24)
    xlim([-2000 2000])
    ylim([0 1.5])
    ylabel('Saccades Per Second')
    xlabel('Time from Board Disappearance')
    title('Saccades per Second, Board Disappearance')
    legend({['Aware, n = ' num2str(size(sacEpochAwareLAll,1))],['Unaware, n = ' num2str(size(sacEpochUnawareLAll,1))]})
end

