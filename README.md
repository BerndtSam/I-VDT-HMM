# I-VDT-HMM
Ternary eye movement classification based off of the I-VDT algorithm, but enhanced using the Viterbi algorithm to determine the highest probabilistic classification after both the velocity and dispersion threshold algorithms


To run the parameter estimation script, where the file will test a range of saccade velocity thresholds, dispersion and duration thresholds, as well as subsample the frequencies to save the scores for each. The s_007.txt at the end of the 3rd parameter can be replaced by any of the 11 input files.:
classificator_run1_5('Run_Thresholding_Classifier', 0, '/Users/SamBerndt/Desktop/Class/Research/I-VDT-HMM/ternary_classifier/classificator_1.5/input/s_007.txt', 3)
