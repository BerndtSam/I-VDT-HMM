%Show how I-BDT compares when 0 and when with mean and std dev.
% Show each score for each fixation threshold with score on left 
additions = ["0", "Mu", "MuStd" "Mu2Std", "Mu5Std", "Mu10Std"];

noisey_dataset = "s_010";
clean_dataset = "s_007";

mat_file_extension = ".mat";

high_frequency = "f1000";
low_frequency = "f30";

%velocity_Index = 4;
%duration_Index = 6;
%dispersion_Index = 5;

SQnS_Index = 7;
FQnS_Index = 8;
PQnS_Index = 9;
MisFix_Index = 10;
FQlS_Index = 11;
PQlS_P_Index = 12;
PQlS_V_Index = 13;

SQnS = 'SQnS';
FQnS = 'FQnS';
PQnS = 'PQnS';
MisFix = 'MisFix';
FQlS = 'FQlS';
PQlS_P = 'PQlS_P';
PQlS_V = 'PQlS_V';

high_clean = zeros(6, 7);
high_noisy = zeros(6, 7);
low_clean = zeros(6, 7);
low_noisy = zeros(6, 7);

data_index = 1;

for addition=1:length(additions)
    
    import_directory = "Results/FrequencyResults" + additions(addition) + "/";

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

    low_noisy(data_index, :) = noisey_low_frequency(SQnS_Index:PQlS_V_Index);
    low_clean(data_index, :) = clean_low_frequency(SQnS_Index:PQlS_V_Index);
    high_noisy(data_index, :) = noisey_high_frequency(SQnS_Index:PQlS_V_Index);
    high_clean(data_index, :) = clean_high_frequency(SQnS_Index:PQlS_V_Index);
    data_index = data_index + 1;
    
end

O_SQnS = 'Opt. SQnS';
O_FQnS = 'Opt. FQnS';
O_PQnS = 'Opt. PQnS';
O_MisFix = 'Opt. MisFix';
O_FQlS_PQlS = 'Opt. FQlS/PQlS_P/PQlS_V';

optimal_SQnS = 100;
optimal_FQnS = 83.9;
optimal_PQnS = 52;
optimal_MisFix = 7.1;
optimal_FQlS = 0;
optimal_PQlS_P = 0;
optimal_PQlS_V = 0;

noisey_dataset = strrep(noisey_dataset,'_','-');
clean_dataset = strrep(clean_dataset,'_','-');

% Low Noisy
ChartIBDTFixationThreshold(low_noisy, additions, noisey_dataset, low_frequency, 'north');

% Low Clean
ChartIBDTFixationThreshold(low_clean, additions, clean_dataset, low_frequency, 'north');

% High Noisy
ChartIBDTFixationThreshold(high_noisy, additions, noisey_dataset, high_frequency, 'north');

% High Clean
ChartIBDTFixationThreshold(high_clean, additions, clean_dataset, high_frequency, 'north');



