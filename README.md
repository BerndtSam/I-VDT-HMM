# I-VDT-HMM
Ternary eye movement classification based off of the I-VDT algorithm, but enhanced using the Viterbi algorithm to determine the highest probabilistic classification after both the velocity and dispersion threshold algorithms

I-VDT-HMM:
To run on a particular set of data, open the I-VDT-HMM directory, open classificator_run1_5.fig in MATLAB. Input the entire file path into the Input File settings bar. An example of such can be found below. After inputting the filepath, select "Use User Model for classification", and then select the classify button.
/Users/SamBerndt/Desktop/Class/Research/I-VDT-HMM/I-VDT-HMM/ternary_classification/classificator_1.5/input/s_007.txt

To run the parameter estimation script, where the file will test a range of saccade velocity thresholds, dispersion and duration thresholds, as well as subsample the frequencies to save the scores for each. The s_007.txt at the end of the 3rd parameter can be replaced by any of the 11 input files.:
classificator_run1_5('Run_Thresholding_Classifier', 0, '/Users/SamBerndt/Desktop/Class/Research/I-VDT-HMM/ternary_classifier/classificator_1.5/input/s_007.txt', 3, 30)

To run the parameter estimation script for a specific saccade threshold, run:
classificator_run1_5('Run_Saccade_Thresholding_Classifier', 0, '/Users/SamBerndt/Desktop/Class/Research/I-VDT-HMM/ternary_classifier/classificator_1.5/input/s_007.txt', 3, sample_rate, saccade_threshold)

To calculate the ideal threshold for the algorithm, run the following parameterized script:
classificator_run1_5('Run_IdealThresholdCalculator', 0, full_subsampled_input_data_file_path, subsampling_frequency,  3, full_frequency_results_path.mat).
An example for running this on sample 7 with subsampling frequency 30 is found below:
classificator_run1_5('Run_IdealThresholdCalculator', 0, '/Users/SamBerndt/Desktop/Class/Research/I-VDT-HMM/ternary_classifier/classificator_1.5/input/Subsamples/s_007_30.txt', 30,  3, '/Users/SamBerndt/Desktop/Class/Research/I-VDT-HMM/ternary_classifier/Results/FrequencyResults/f30-s_007.mat', true)
The final parameter uses a weighted calculation to put weight on all but the PQlS_P and PQlS_V.

To calculate the scores using the optimal thresholds and a set of frequencies, use the function below:
Run_Classifier_Ideal_Thresholds(hObject, InputFile, classifier_index, sample_rates, thresholds)
An example is as follows:
classificator_run1_5('Run_Classifier_Ideal_Thresholds', 0, '/Users/SamBerndt/Desktop/Class/Research/I-VDT-HMM/ternary_classifier/classificator_1.5/input/s_007.txt', 3, [30 100 1000], [70 0.67 150])

To calculate ideal scores, run:
classificator_run1_5('CalculateIdealScores', 0, '/Users/SamBerndt/Desktop/Class/Research/I-VDT-HMM/ternary_classifier/classificator_1.5/input/s_007.txt', 3)

I-BDT:

To run I-BDT, choose the user defined threshold after opening the classificator_run1_5.fig with the input data source as a string to the correct subsampled data. This data is subsampled differently than it is for I-VDT-HMM as it requires specific timestamps. The subsampling algorithm is a python script found under classificator_1.5/Results/Input/.
Ensure that when inputting data subsampled lower than 1000 Hz that you update the Eye Trackers sampling rate in the GUI.
An example of the input file is found below:
/Users/SamBerndt/Desktop/Class/Research/I-VDT-HMM/I-BDT/ternary_classification/classificator_1.5/input/SubsamplesBDT/s_007_20.txt

To test I-BDT's performance on subjects 1-10 for each frequency, run the following script while in the I-BDT/ternary_classification directory:
classificator_run1_5('Run_Subsample_Classifier', 0, '/Users/SamBerndt/Desktop/Class/Research/I-VDT-HMM/I-BDT/ternary_classification/classificator_1.5/input/SubsamplesBDT', 3, [30, 50, 60, 100, 200, 300, 500, 1000])
This was designed to run on a single computer as there is no threshold estimation being done.
Note that the results will be saved under:
'/I-VDT-HMM/I-BDT/ternary_classification/Results/FrequencyResults' and '../FinalResults'
Note that we only classify subsampled data starting at 30, this is because the I-BDT algorithm doesn't allow further subsampled data.