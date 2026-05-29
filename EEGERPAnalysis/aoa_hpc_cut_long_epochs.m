clear all
clc
%% Instantiate variables 
location = 'l'
if strcmp(location,'s')
    eeglabLocation = '/mnt/Data27/HNCT_AoA_Study/eeglab14_0_0b';
    cleanline_dir = [eeglabLocation '/plugins/tmullen-cleanline-696a7181b7d0'];
    cleanraw_dir = [eeglabLocation '/plugins/clean_rawdata-master'];
    Photo_dir = [eeglabLocation '/sample_locs/GSN-HydroCel-257.sfp'];
    [num text raw] = xlsread('/mnt/Data27/HNCT_AoA_Study/AoA_Subjects/AoA_ERP_Quizzes_Then_Choose.xlsx');
    root = '/mnt/Data27/HNCT_AoA_Study/AoA_Subjects/';
elseif strcmp(location,'l')
    eeglabLocation = 'Y:\HNCT_AoA_Study\eeglab14_0_0b';
    cleanline_dir = [eeglabLocation '/plugins/tmullen-cleanline-696a7181b7d0'];
    cleanraw_dir = [eeglabLocation '/plugins/clean_rawdata-master'];
    Photo_dir = [eeglabLocation '/sample_locs/GSN-HydroCel-257.sfp'];
    [num text raw] = xlsread('Y:\HNCT_AoA_Study\AoA_Subjects/AoA_ERP_Quizzes_Then_Choose.xlsx');
    root = 'Y:\HNCT_AoA_Study\AoA_Subjects/';
end
tic
for session = 1:length(text)
    
    fileLocation = [root '/' text{1,session} '/' text{2,session} '/'];
    cd(fileLocation)
    sessionDate = num2str(num(1,session))

    %% Look through the average-referenced EEG for each participant and find the key timepoint. Then cut epochs from 3 seconds before to 3 seconds after.
        disp(['Loading ' text{1,session} ', Day ' text{2,session}(end) '...'])
        cd(fileLocation)
        
        load([fileLocation sessionDate '_EEG_avgref.mat'])
        load([fileLocation sessionDate '_goodConfirmTimes.mat'])
        if isfile([fileLocation sessionDate '_offsetGoodConfirmEpochs.mat'])
            load([fileLocation sessionDate '_offsetGoodConfirmEpochs.mat'])
        elseif ~isfile([fileLocation sessionDate '_goodConfirmEpochs.mat'])
            load([fileLocation sessionDate '_goodConfirmEpochs.mat'])
        end
        longGoodConfirmEpochs = zeros(257,6000,size(goodConfirmEpochs,3));
        currentEpoch = 1;
        currentPoint = 1001;
        currentPoints = [];
        tic
        while currentEpoch <= size(goodConfirmEpochs,3)
            currentPoints = [currentPoints currentPoint];
            
            if sum(sum(goodConfirmEpochs(:,:,currentEpoch)==EEG_avgref(:,currentPoint:currentPoint+3999))) == 257*4000; % This would land you at 2-seconds before action
                longGoodConfirmEpochs(:,:,currentEpoch) = EEG_avgref(:,currentPoint-1000:currentPoint+4999);
                currentEpoch = currentEpoch + 1
                toc
                currentPoint = currentPoint + 10000;
            end
            currentPoint = currentPoint + 1;
        end


       


        eval(['save ' sessionDate '_good_long_epochs.mat longGoodConfirmEpochs -v7.3']) 
                
    toc
end
        
        
        
