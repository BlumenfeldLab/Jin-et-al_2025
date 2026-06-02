clear all
clc
%%
location = 'l'
if strcmp(location,'s')

    root = '/mnt/Data27/HNCT_AoA_Study/AoA_Subjects/';
end
if strcmp(location,'l')
    root = 'Y:/HNCT_AoA_Study/AoA_Subjects/';
end

[num text raw] = xlsread([root '/AoA_ERP_Quizzes_Then_Choose.xlsx']);

tic

for session = 1:length(text)   
    fileLocation = [root '/' text{1,session} '/' text{2,session} '/'];
    cd(fileLocation)
    sessionDate = num2str(num(1,session));

    disp(['Analyzing ' text{1,session} ])
    load([fileLocation sessionDate '_good_epoch_designations_confirms_nMinus1.mat'])
    load([fileLocation sessionDate '_goodConfirmEpochs_nMinus1.mat'])
    load([fileLocation sessionDate '_good_confirm_key_epochs_nMinus1.mat'])
    load([fileLocation sessionDate '_sliders_and_percentiles.mat'])
    load([fileLocation sessionDate '_bad_epochs_confirms_nMinus1.mat'])
    sorted_designations = sortrows(sliderSuccessesAllPercentiles,2);
    sorted_designations = sorted_designations(bad_epochs == 0,:,:,:);
    keyEpochDesignations = good_epoch_designations;
    good_epoch_designations = cell(1,size(goodConfirmEpochs,3));
    for designation = 1:length(keyEpochDesignations)
        for confirm = 1:size(goodConfirmEpochs,3);
            if sum(sum(good_confirm_key_epochs(:,:,designation) == goodConfirmEpochs(:,:,confirm))) == 1028000 
                good_epoch_designations{confirm} = keyEpochDesignations{designation};
                break
            end
        end
    end
        eval(['save ' fileLocation sessionDate '_good_epoch_designations_quizzes_then_choose_confirms_nMinus1.mat good_epoch_designations -v7.3'])
    
    for epoch = 1:sum(bad_epochs == 0)
        if isempty(good_epoch_designations{epoch}) && sorted_designations(epoch,3) < 25
            if sorted_designations(epoch,4) == 1
                good_epoch_designations{epoch} = 'Correct Low';
            end
        end
        if isempty(good_epoch_designations{epoch}) && sorted_designations(epoch,3) > 75
            if sorted_designations(epoch,4) == 1
                good_epoch_designations{epoch} = 'Incorrect High';
            end
        end
        if isempty(good_epoch_designations{epoch}) && sorted_designations(epoch,3) >=25 && sorted_designations(epoch,3) < 50
            if sorted_designations(epoch,4) == 1
                good_epoch_designations{epoch} = 'Correct Mid Low';
            elseif sorted_designations(epoch,4) == 0
                good_epoch_designations{epoch} = 'Incorrect Mid Low';
            end
        end
        if isempty(good_epoch_designations{epoch}) && sorted_designations(epoch,3) >=50 && sorted_designations(epoch,3) <= 75
            if sorted_designations(epoch,4) == 1
                good_epoch_designations{epoch} = 'Correct Mid High';
            elseif sorted_designations(epoch,4) == 0
                good_epoch_designations{epoch} = 'Incorrect Mid High';
            end
        end
    end
            
        eval(['save ' fileLocation sessionDate '_good_epoch_designations_middles_confirms_nMinus1.mat good_epoch_designations -v7.3'])

    toc    
end
    
    
    
    
