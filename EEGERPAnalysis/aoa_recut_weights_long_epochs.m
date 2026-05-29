clear all
clc
%% This script is for selection of which artifacts to cut from the ICA step.
location = 'l'
if strcmp(location,'s')
    eeglabLocation = '/mnt/Data27/HNCT_AoA_Study/eeglab14_0_0b';
    cleanline_dir = [eeglabLocation '/plugins/tmullen-cleanline-696a7181b7d0'];
    cleanraw_dir = [eeglabLocation '/plugins/clean_rawdata-master'];
    Photo_dir = [eeglabLocation '/sample_locs/GSN-HydroCel-257.sfp'];


    [num text raw] = xlsread('/mnt/Data27/HNCT_AoA_Study/AoA_Subjects/AoA_ERP_Time_Frequency.xlsx');
    root = '/mnt/Data27/HNCT_AoA_Study/AoA_Subjects/';
elseif strcmp(location,'l')
    eeglabLocation = 'Y:\HNCT_AoA_Study\eeglab14_0_0b';
    cleanline_dir = [eeglabLocation '/plugins/tmullen-cleanline-696a7181b7d0'];
    cleanraw_dir = [eeglabLocation '/plugins/clean_rawdata-master'];
    Photo_dir = [eeglabLocation '/sample_locs/GSN-HydroCel-257.sfp'];


    [num text raw] = xlsread('Y:\HNCT_AoA_Study\AoA_Subjects/AoA_ERP_Time_Frequency.xlsx');
    root = 'Y:\HNCT_AoA_Study\AoA_Subjects/';
end
for session = 1:length(text)
    
    fileLocation = [root '/' text{1,session} '/' text{2,session} '/']
    sessionDate = num2str(num(1,session))
    disp(['Initiating component selection for session ' num2str(session)])
    %% If the file has not been created, perform the selection of the weights.
    if ~isfile([fileLocation sessionDate '_ICA_epochs_components_removed_quizzes_then_choose_long.mat'])
        cd(fileLocation)
        load([fileLocation sessionDate '_weights_recut_quizzes_then_choose_long.mat'])

        load([fileLocation sessionDate '_EEGlab_blank_quizzes_then_choose_long.mat'])

        weightsrecut.chanlocs = readlocs(Photo_dir)
        %Display ICA components
        display = pop_selectcomps(weightsrecut); % EEGlab function for selecting components to remove.
        %Select which components to remove (Need to type into command line)
        prompt_ICA = 'Components you want to remove (e.g., [1, 2, 4]; or "none"): ';
        remove_components = input(prompt_ICA);

        weightsrecut_subcomp = pop_subcomp(weightsrecut,remove_components,1,0);
        ICA_epochs_components_removed = weightsrecut_subcomp.data;


        
        eval(['save ' fileLocation sessionDate '_ICA_epochs_components_removed_quizzes_then_choose_long.mat ICA_epochs_components_removed -v7.3'])
        close all
    end
end
