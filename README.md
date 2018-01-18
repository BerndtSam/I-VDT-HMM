# I-VDT-HMM
Ternary eye movement classification based off of the I-VDT algorithm, but enhanced using the Viterbi algorithm to determine the highest probabilistic classification after both the velocity and dispersion threshold algorithms


To run the parameter estimation script, where the file will test a range of saccade velocity thresholds, dispersion and duration thresholds, as well as subsample the frequencies to save the scores for each. The s_007.txt at the end of the 3rd parameter can be replaced by any of the 11 input files.:
classificator_run1_5('Run_Thresholding_Classifier', 0, '/Users/SamBerndt/Desktop/Class/Research/I-VDT-HMM/ternary_classifier/classificator_1.5/input/s_007.txt', 3)

To calculate the ideal threshold for the algorithm, run the following parameterized script:
classificator_run1_5('Run_IdealThresholdCalculator', 0, full_subsampled_input_data_file_path, subsampling_frequency,  3, full_frequency_results_path.mat).
An example for running this on sample 7 with subsampling frequency 30 is found below:
classificator_run1_5('Run_IdealThresholdCalculator', 0, '/Users/SamBerndt/Desktop/Class/Research/I-VDT-HMM/ternary_classifier/classificator_1.5/input/Subsamples/s_007_30.txt', 30,  3, '/Users/SamBerndt/Desktop/Class/Research/I-VDT-HMM/ternary_classifier/Results/FrequencyResults/2018-1-17-16-58-f30-s_007.mat')


To run I-BDT, choose the user defined threshold after opening the classificator_run1_5.fig with the input data source as a string to the correct subsampled data. This data is subsampled differently than it is for I-VDT-HMM as it requires specific timestamps. The subsampling algorithm is a python script found under classificator_1.5/Results/Input/.
Ensure that when inputting data subsampled lower than 1000 Hz that you update the Eye Trackers sampling rate in the GUI.
An example of the input file is found below:
/Users/SamBerndt/Desktop/Class/Research/I-VDT-HMM/I-BDT/ternary_classification/classificator_1.5/input/SubsamplesBDT/s_007_20.txt

To test I-BDT's performance on subjects 1-10 for each frequency, run the following script while in the I-BDT/ternary_classification directory:
classificator_run1_5('Run_Subsample_Classifier', 0, '/Users/SamBerndt/Desktop/Class/Research/I-VDT-HMM/I-BDT/ternary_classification/classificator_1.5/input/SubsamplesBDT', 3, [20, 30, 50, 60, 100, 200, 300, 500, 1000])
This was designed to run on a single computer as there is no threshold estimation being done.
Note that the results will be saved under:
'/I-VDT-HMM/I-BDT/ternary_classification/Results/FrequencyResults' and '../FinalResults'