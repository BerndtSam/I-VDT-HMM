%Showing how our scores are affected by thresholds
%showing how we get the optimal thresholds
%noisey data and clean data (subject)
%Low and high frequency
%Each score on the same chart


import_directory = "FrequencyResults/";
mat_file_extension = ".mat";

noisey_dataset = "s_002";
clean_dataset = "s_001";

high_frequency = "f1000";
low_frequency = "f30";

noisey_low_frequency_filename = import_directory + low_frequency + '-' + noisey_dataset + mat_file_extension;
clean_low_frequency_filename = import_directory + low_frequency + '-' + clean_dataset + mat_file_extension;

noisey_high_frequency_filename = import_directory + high_frequency + '-' + noisey_dataset + mat_file_extension;
clean_high_frequency_filename = import_directory + high_frequency + '-' + clean_dataset + mat_file_extension;

noisey_low_frequency = load(noisey_low_frequency_filename);
clean_low_frequency = load(clean_low_frequency_filename);
noisey_high_frequency  = load(noisey_high_frequency_filename);
clean_high_frequency = load(clean_high_frequency_filename);

noisey_low_frequency = noisey_low_frequency.frequency_threshold_scores;
clean_low_frequency = clean_low_frequency.frequency_threshold_scores;
noisey_high_frequency = noisey_high_frequency.frequency_threshold_scores;
clean_high_frequency = clean_high_frequency.frequency_threshold_scores;


velocity_Index = 4;
duration_Index = 6;
dispersion_Index = 5;

SQnS_Index = 7;
FQnS_Index = 8;
PQnS_Index = 9;
MisFix_Index = 10;
FQlS_Index = 11;

SQnS = 'SQnS';
FQnS = 'FQnS';
PQnS = 'PQnS';
MisFix = 'MisFix';
FQlS = 'FQlS';

optimal_SQnS = 100;
optimal_FQnS = 83.9;
optimal_PQnS = 52;
optimal_MisFix = 7.1;
optimal_FQlS = 0;

noisey_dataset = strrep(noisey_dataset,'_','-');
clean_dataset = strrep(clean_dataset,'_','-');

%% Noisy vs Clean charts

% Noisey vs clean high frequency FQnS
ChartFrequencySamplesThresholdResults(noisey_high_frequency, clean_high_frequency, velocity_Index, dispersion_Index, duration_Index, FQnS_Index, FQnS, optimal_FQnS, high_frequency, noisey_dataset, clean_dataset, 'northwest')

% Noisey vs clean low frequency FQnS
ChartFrequencySamplesThresholdResults(noisey_low_frequency, clean_low_frequency, velocity_Index, dispersion_Index, duration_Index, FQnS_Index, FQnS, optimal_FQnS, low_frequency, noisey_dataset, clean_dataset, 'southeast')

% Noisey vs clean high frequency SQnS
ChartFrequencySamplesThresholdResults(noisey_high_frequency, clean_high_frequency, velocity_Index, dispersion_Index, duration_Index, SQnS_Index, SQnS, optimal_SQnS, high_frequency, noisey_dataset, clean_dataset, 'northwest')

% Noisey vs clean low frequency SQnS
ChartFrequencySamplesThresholdResults(noisey_low_frequency, clean_low_frequency, velocity_Index, dispersion_Index, duration_Index, SQnS_Index, SQnS, optimal_SQnS, low_frequency, noisey_dataset, clean_dataset, 'northwest')

% Noisey vs clean high frequency PQnS
ChartFrequencySamplesThresholdResults(noisey_high_frequency, clean_high_frequency, velocity_Index, dispersion_Index, duration_Index, PQnS_Index, PQnS, optimal_PQnS, high_frequency, noisey_dataset, clean_dataset, 'northwest')

% Noisey vs clean low frequency PQnS
ChartFrequencySamplesThresholdResults(noisey_low_frequency, clean_low_frequency, velocity_Index, dispersion_Index, duration_Index, PQnS_Index, PQnS, optimal_PQnS, low_frequency, noisey_dataset, clean_dataset, 'northwest')

% Noisey vs clean high frequency MisFix
ChartFrequencySamplesThresholdResults(noisey_high_frequency, clean_high_frequency, velocity_Index, dispersion_Index, duration_Index, MisFix_Index, MisFix, optimal_MisFix, high_frequency, noisey_dataset, clean_dataset, 'northwest')

% Noisey vs clean low frequency MisFix
ChartFrequencySamplesThresholdResults(noisey_low_frequency, clean_low_frequency, velocity_Index, dispersion_Index, duration_Index, MisFix_Index, MisFix, optimal_MisFix, low_frequency, noisey_dataset, clean_dataset, 'northwest')

% Noisey vs clean high frequency FQlS
ChartFrequencySamplesThresholdResults(noisey_high_frequency, clean_high_frequency, velocity_Index, dispersion_Index, duration_Index, FQlS_Index, FQlS, optimal_FQlS, high_frequency, noisey_dataset, clean_dataset, 'southeast')

% Noisey vs clean low frequency FQlS
ChartFrequencySamplesThresholdResults(noisey_low_frequency, clean_low_frequency, velocity_Index, dispersion_Index, duration_Index, FQlS_Index, FQlS, optimal_FQlS, low_frequency, noisey_dataset, clean_dataset, 'southeast')






%% Singular Charts
% Noisey Low Frequency
% ChartFrequencyThresholdResults( noisey_low_frequency, velocity_Index, dispersion_Index, duration_Index, FQnS_Index, FQnS, optimal_FQnS, low_frequency, noisey_dataset, 'southwest')
% ChartFrequencyThresholdResults( noisey_low_frequency, velocity_Index, dispersion_Index, duration_Index, SQnS_Index, SQnS, optimal_SQnS, low_frequency, noisey_dataset, 'northwest')
% ChartFrequencyThresholdResults( noisey_low_frequency, velocity_Index, dispersion_Index, duration_Index, PQnS_Index, PQnS, optimal_PQnS, low_frequency, noisey_dataset, 'northwest')
% ChartFrequencyThresholdResults( noisey_low_frequency, velocity_Index, dispersion_Index, duration_Index, MisFix_Index, MisFix, optimal_MisFix, low_frequency, noisey_dataset, 'northwest')
% ChartFrequencyThresholdResults( noisey_low_frequency, velocity_Index, dispersion_Index, duration_Index, FQlS_Index, FQlS, optimal_FQlS, low_frequency, noisey_dataset, 'northwest')
% 
% % Clean Low Frequency
% ChartFrequencyThresholdResults( clean_low_frequency, velocity_Index, dispersion_Index, duration_Index, FQnS_Index, FQnS, optimal_FQnS, low_frequency, clean_dataset, 'southwest')
% ChartFrequencyThresholdResults( clean_low_frequency, velocity_Index, dispersion_Index, duration_Index, SQnS_Index, SQnS, optimal_SQnS, low_frequency, clean_dataset, 'northwest')
% ChartFrequencyThresholdResults( clean_low_frequency, velocity_Index, dispersion_Index, duration_Index, PQnS_Index, PQnS, optimal_PQnS, low_frequency, clean_dataset, 'northwest')
% ChartFrequencyThresholdResults( clean_low_frequency, velocity_Index, dispersion_Index, duration_Index, MisFix_Index, MisFix, optimal_MisFix, low_frequency, clean_dataset, 'northwest')
% ChartFrequencyThresholdResults( clean_low_frequency, velocity_Index, dispersion_Index, duration_Index, FQlS_Index, FQlS, optimal_FQlS, low_frequency, clean_dataset, 'northwest')
% 
% % noisey high frequency
% ChartFrequencyThresholdResults( noisey_high_frequency, velocity_Index, dispersion_Index, duration_Index, FQnS_Index, FQnS, optimal_FQnS, high_frequency, noisey_dataset, 'southwest')
% ChartFrequencyThresholdResults( noisey_high_frequency, velocity_Index, dispersion_Index, duration_Index, SQnS_Index, SQnS, optimal_SQnS, high_frequency, noisey_dataset, 'northwest')
% ChartFrequencyThresholdResults( noisey_high_frequency, velocity_Index, dispersion_Index, duration_Index, PQnS_Index, PQnS, optimal_PQnS, high_frequency, noisey_dataset, 'northwest')
% ChartFrequencyThresholdResults( noisey_high_frequency, velocity_Index, dispersion_Index, duration_Index, MisFix_Index, MisFix, optimal_MisFix, high_frequency, noisey_dataset, 'northwest')
% ChartFrequencyThresholdResults( noisey_high_frequency, velocity_Index, dispersion_Index, duration_Index, FQlS_Index, FQlS, optimal_FQlS, high_frequency, noisey_dataset, 'northwest')
% 
% % Clean high frequency
% ChartFrequencyThresholdResults( clean_high_frequency, velocity_Index, dispersion_Index, duration_Index, FQnS_Index, FQnS, optimal_FQnS, high_frequency, clean_dataset, 'southwest')
% ChartFrequencyThresholdResults( clean_high_frequency, velocity_Index, dispersion_Index, duration_Index, SQnS_Index, SQnS, optimal_SQnS, high_frequency, clean_dataset, 'northwest')
% ChartFrequencyThresholdResults( clean_high_frequency, velocity_Index, dispersion_Index, duration_Index, PQnS_Index, PQnS, optimal_PQnS, high_frequency, clean_dataset, 'northwest')
% ChartFrequencyThresholdResults( clean_high_frequency, velocity_Index, dispersion_Index, duration_Index, MisFix_Index, MisFix, optimal_MisFix, high_frequency, clean_dataset, 'northwest')
% ChartFrequencyThresholdResults( clean_high_frequency, velocity_Index, dispersion_Index, duration_Index, FQlS_Index, FQlS, optimal_FQlS, high_frequency, clean_dataset, 'northwest')



%plot(noisey_low_frequency(:, windowLength_Index), noisey_low_frequency(:, FQnS_Index)); 
%figure;
%plot(noisey_low_frequency(:, dispersion_Index), noisey_low_frequency(:, FQnS_Index)); 