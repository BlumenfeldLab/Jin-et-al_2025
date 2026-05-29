clear all
clc
%% For each session, load designations and raw slider values, and designate quartiles based on those.
location = 'l'
if strcmp(location,'s')

    root = '/mnt/Data27/HNCT_AoA_Study/AoA_Subjects/';
end
if strcmp(location,'l')
    root = 'Y:/HNCT_AoA_Study/AoA_Subjects/';
end

[num text raw] = xlsread([root '/AoA_ERP_Blink_Check_Pupil.xlsx']);

tic
for session = length(text):length(text);
   
    fileLocation = [root '/' text{1,session} '/' text{2,session} '/'];
    cd(fileLocation)
    sessionDate = num2str(num(1,session));

    disp(['Analyzing ' text{1,session} ])
    load([fileLocation sessionDate '_designations.mat'])
    load([fileLocation sessionDate '_sliders_and_percentiles.mat'])
    sorted_designations = sortrows(sliderSuccessesAllPercentiles,2);
    
    
    
    for epoch = 1:length(confidenceDesignations)
        if isempty(confidenceDesignations{epoch}) && sorted_designations(epoch,3) < 25
            if sorted_designations(epoch,4) == 1
                confidenceDesignations{epoch} = 'Correct Low';
            end
        end
        if isempty(confidenceDesignations{epoch}) && sorted_designations(epoch,3) > 75
            if sorted_designations(epoch,4) == 1
                confidenceDesignations{epoch} = 'Incorrect High';
            end
        end
        if isempty(confidenceDesignations{epoch}) && sorted_designations(epoch,3) >=25 && sorted_designations(epoch,3) < 50
            if sorted_designations(epoch,4) == 1
                confidenceDesignations{epoch} = 'Correct Mid Low';
            elseif sorted_designations(epoch,4) == 0
                confidenceDesignations{epoch} = 'Incorrect Mid Low';
            end
        end
        if isempty(confidenceDesignations{epoch}) && sorted_designations(epoch,3) >=50 && sorted_designations(epoch,3) <= 75
            if sorted_designations(epoch,4) == 1
                confidenceDesignations{epoch} = 'Correct Mid High';
            elseif sorted_designations(epoch,4) == 0
                confidenceDesignations{epoch} = 'Incorrect Mid High';
            end
        end
    end
            
    if ~isfile([fileLocation sessionDate '_confidenceDesignations_middles.mat'])
        eval(['save ' fileLocation sessionDate '_confidenceDesignations_middles.mat confidenceDesignations -v7.3'])
    end

    toc
    confidenceDesignationsRedo = confidenceDesignations;
    for run = 1:6
        if isfile([fileLocation sessionDate '_run' num2str(run) '_designations.mat']);
            load([fileLocation sessionDate '_run' num2str(run) '_designations.mat']);
            length_of_run = length(eval(['confidenceDesignations_run' num2str(run)]));
            eval(['confidenceDesignations_run' num2str(run) ' = confidenceDesignationsRedo(1:length_of_run);']);
            eval(['save ' fileLocation sessionDate '_run' num2str(run) '_designations_all_types.mat confidenceDesignations_run' num2str(run) ' -v7.3'])
            if run < 6
                confidenceDesignationsRedo(1:length_of_run) = [];
            end
        end
    end
end
    
    
    
    