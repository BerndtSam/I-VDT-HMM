# I-VDT-HMM
Ternary eye movement classification based off of the I-VDT algorithm, but enhanced using the Viterbi algorithm to determine the highest probabilistic classification after both the velocity and dispersion threshold algorithms


To run the parameter estimation script, where the file will test a range of saccade velocity thresholds, dispersion and duration thresholds, as well as subsample the frequencies to save the scores for each. The s_007.txt at the end of the 3rd parameter can be replaced by any of the 11 input files.:
classificator_run1_5('Run_Thresholding_Classifier', 0, '/Users/SamBerndt/Desktop/Class/Research/I-VDT-HMM/ternary_classifier/classificator_1.5/input/s_007.txt', 3)

To calculate the ideal threshold for the algorithm, run the following parameterized script:
classificator_run1_5('Run_IdealThresholdCalculator', 0, full_subsampled_input_data_file_path, subsampling_frequency,  3, full_frequency_results_path.mat).
An example for running this on sample 7 with subsampling frequency 30 is found below:
classificator_run1_5('Run_IdealThresholdCalculator', 0, '/Users/SamBerndt/Desktop/Class/Research/I-VDT-HMM/ternary_classifier/classificator_1.5/input/Subsamples/s_007_30.txt', 30,  3, '/Users/SamBerndt/Desktop/Class/Research/I-VDT-HMM/ternary_classifier/Results/FrequencyResults/2018-1-17-16-58-f30-s_007.mat')