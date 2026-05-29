clear all
clc
%%
location = 's'
if strcmp(location,'s')

    root = '/mnt/Data8/HNCT_AoA_Study/AoA_Subjects/';
    eeglabLocation = '/mnt/Data8/HNCT_AoA_Study/eeglab14_0_0b';
end
if strcmp(location,'l')
    root = 'Y:/HNCT_AoA_Study/AoA_Subjects/';
    eeglabLocation = 'Y:/HNCT_AoA_Study/eeglab14_0_0b';
end
addpath(eeglabLocation);
eeglab('nogui')
cleanline_dir = [eeglabLocation '/plugins/tmullen-cleanline-696a7181b7d0'];
cleanraw_dir = [eeglabLocation '/plugins/clean_rawdata-master'];
Photo_dir = [eeglabLocation '/sample_locs/GSN-HydroCel-257.sfp'];

[num text raw] = xlsread([root '/AoA_ERP_Quizzes_Then_Choose.xlsx']);

% Iterate through sessions in the spreadsheet and perform PCA and ICA.
for session = 1:length(text);
    fileLocation = [root '/' text{1,session} '/' text{2,session} '/'];
    sessionDate = num2str(num(1,session));
    disp(['Analyzing ' text{1,session} ])
    if isfile([fileLocation sessionDate '_weights_recut_quizzes_then_choose.mat'])
        disp('Already done.')
        continue
    end
    load([fileLocation sessionDate '_ICA_epochs_components_removed_key_epochs.mat'])


    %% Load EEG data
    load([fileLocation sessionDate '_EEGlab_blank_key_epochs.mat'])
    load([fileLocation sessionDate '_goodConfirmEpochs.mat'])
    %% Stuff an EEG lab struct with data and perform.

    
    EEGlab_blank.event = [];
    EEGlab_blank.data = goodConfirmEpochs;
    EEGlab_blank.times = 0:3999;
    EEGlab_blank.xmax = 3.999;
    EEGlab_blank.pnts = 4000;
    EEGlab_blank.trials = size(goodConfirmEpochs,3);
    EEGlab_blank.ref = 'averef'
    EEGlab_blank.epoch = [1:size(goodConfirmEpochs,3)];

    [weightsrecut,~] = pop_runica(EEGlab_blank,'icatype','runica','pca',10);
    %% Visually inspect and recut ICA weights.
    weightsrecut.chanlocs = readlocs(Photo_dir)
    %Display ICA components
    display = pop_selectcomps(weightsrecut);
    %Select which components to remove (Need to type into command line)
    prompt_ICA = 'Components you want to remove (e.g., [1, 2, 4]; or "none"): ';
    remove_components = input(prompt_ICA);

    weightsrecut_subcomp = pop_subcomp(weightsrecut,remove_components,1,0);
    ICA_epochs_components_removed = weightsrecut_subcomp.data;

    %% Save ICA artifact-rejected data.



    eval(['save ' fileLocation sessionDate '_ICA_epochs_components_removed_quizzes_then_choose.mat ICA_epochs_components_removed -v7.3'])
    eval(['save ' fileLocation sessionDate '_weights_recut_quizzes_then_choose.mat weightsrecut -v7.3'])
    EEGlab_blank.trials = 1;
    EEGlab_blank.nbchan = 257;


    eval(['save ' fileLocation sessionDate '_EEGlab_blank_quizzes_then_choose.mat EEGlab_blank -v7.3'])
    close all
end
close all
