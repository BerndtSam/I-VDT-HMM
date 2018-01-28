
samples = [30 100 500 100];
clean_dataset = "s_007";
noisy_dataset = "s_010";
mat_file_extension = ".mat";
import_directory = "OptimalResults/";

clean_results = [];
noisy_results = [];
for sample = 1:length(samples)
    frequency = "f" + string(samples(sample)) + "-";
    
    noisy_filename = import_directory + frequency + noisy_dataset + mat_file_extension;
    clean_filename = import_directory + frequency + clean_dataset + mat_file_extension;
    
    noisy = load(noisy_filename);
    clean = load(clean_filename);

    noisy = [noisy.best_saccade_threshold, noisy.best_dispersion_threshold, noisy.best_duration_threshold, noisy.minimum_distance, noisy.best_PQnS, noisy.best_FQnS, noisy.best_SQnS, noisy.best_MisFix, noisy.best_FQlS, noisy.best_PQlS_P, noisy.best_PQlS_V];
    clean = [clean.best_saccade_threshold, clean.best_dispersion_threshold, clean.best_duration_threshold, clean.minimum_distance, clean.best_PQnS, clean.best_FQnS, clean.best_SQnS, clean.best_MisFix, clean.best_FQlS, clean.best_PQlS_P, clean.best_PQlS_V];

    clean_results = [clean_results; clean];
    noisy_results = [noisy_results; noisy];

end

filename = import_directory + clean_dataset + "-final0.mat";
save(filename, 'clean_results');

filename = import_directory + noisy_dataset + "-final0.mat";
save(filename, 'noisy_results');

        


