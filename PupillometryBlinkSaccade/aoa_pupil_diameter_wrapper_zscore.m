sheetToRead = 'Y:\HNCT_AoA_Study\AoA_Subjects\AoA_All_Subjs_Data.xlsx';

%% Perform pupil diameter calculation
unusable_mm_right = aoa_pupil_diameter_calculation(sheetToRead,'right');
unusable_mm_left = aoa_pupil_diameter_calculation(sheetToRead,'left');

%% Z-score the pupil to all non-quiz times (as quizzes are brighter) 
unusableLeft_non_quiz = aoa_zscore_pupil_non_quiz(sheetToRead,'left'); 
unusableRight_non_quiz = aoa_zscore_pupil_non_quiz(sheetToRead,'right');

%% Alternative approach: Look at the pupil with respect to the current half
unusableLeft_non_quiz_halves = aoa_zscore_pupil_non_quiz_halves(sheetToRead,'left'); 
unusableRight_non_quiz_halves = aoa_zscore_pupil_non_quiz_halves(sheetToRead,'right')

%% Calculate blinks before and after action
unusableBlinkLeft = aoa_build_blink_epochs(sheetToRead,'left')
unusableBlinkRight = aoa_build_blink_epochs(sheetToRead,'right')

%% Calculate saccades before and after action
unusableSaccade = aoa_saccade_analysis(sheetToRead);
unusableSaccadeEpochLeft = aoa_build_saccade_epochs(sheetToRead,'left');
unusableSaccadeEpochRight = aoa_build_saccade_epochs(sheetToRead,'right');
