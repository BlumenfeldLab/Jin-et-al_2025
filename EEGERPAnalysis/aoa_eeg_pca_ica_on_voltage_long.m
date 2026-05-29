function output_end = aoa_eeg_pca_ica_on_voltage_long(fileRoot,eeglabLocation,subjectPath,sessionDay,sessionDate)

    fileLocation = [fileRoot '/' subjectPath '/' sessionDay '/'];
    cd(fileLocation)
    
    cleanline_dir = [eeglabLocation '/plugins/tmullen-cleanline-696a7181b7d0'];
    cleanraw_dir = [eeglabLocation '/plugins/clean_rawdata-master'];
    Photo_dir = [eeglabLocation '/sample_locs/GSN-HydroCel-257.sfp'];

    load([fileLocation sessionDate '_good_long_epochs.mat'])
    addpath(eeglabLocation)
    eeglab('nogui')
    %% Load a blank EEG lab struct, stuff with data, and perform ICA
    
    load([fileRoot '/aoa_EEGlab_blank.mat'])
    EEGlab_blank.event = [];
    EEGlab_blank.data = longGoodConfirmEpochs;
    EEGlab_blank.times = 0:5999;
    EEGlab_blank.xmax = 5.999;
    EEGlab_blank.pnts = 6000;
    EEGlab_blank.trials = size(longGoodConfirmEpochs,3);
    EEGlab_blank.ref = 'averef'
    EEGlab_blank.epoch = [1:size(longGoodConfirmEpochs,3)];

    [weightsrecut,~] = pop_runica(EEGlab_blank,'icatype','runica','pca',10);
     eval(['save ' sessionDate '_weightsrecut_long.mat weightsrecut -v7.3'])

    output_end = 1
end
