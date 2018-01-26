function [ clean_data, noisy_data ] = ConcatenateData( subjects, frequencies, resultsDir )
%CONCATENATEDATA Summary of this function goes here
%   Detailed explanation goes here

%resultsDir = "Results/FrequencyResultsMu/";
%subjects = ["s_007", "s_010"]
%frequencies = [30, 100, 500, 1000]

mat_file_extension = ".mat";

noisy_data = [];
clean_data = [];

for frequency=1:length(frequencies)
    
    noisey_filename = resultsDir + "f" + frequencies(frequency) + "-" + subjects(2) + mat_file_extension;
    clean_filename = resultsDir + "f" + frequencies(frequency) + "-" + subjects(1) + mat_file_extension;

    noisey = load(noisey_filename);
    clean = load(clean_filename);

     noisey = noisey.frequency_threshold_scores;
     clean = clean.frequency_threshold_scores;

    noisy_data = [noisy_data; noisey(:,7:length(noisey))];
    clean_data = [clean_data; clean(:,7:length(clean))];

end

