% Modified by Sam Berndt, Tim Taviano, Doug Kirkpatrick 
% Project 3 - Ternary Classification
% Oleg K. 
% Last Modified 12/3/17

% I-DT model classificator
classdef classificator_pursuits_class <  eye_tracker_raw_data_reader_class & ...             % Reader from eye tracker data
                                         eye_records_class & ...                             % Basic class for placing eye tracker data
                                         eye_tracker_raw_data_converter_ETU_degree & ...     % Convertor between ETU and degress in data
                                         eye_tracker_raw_data_filter_class & ...             % Eye tracker data filtering by range of degrees
                                         classificator_merge_class & ...                     % Creates sequences of eye movements
                                         classificator_saccade_amplitude_filter_class & ...  % Filtered saccades based theire amplitude
                                         classificator_datafile_output_class & ...           % Output sequences to the files
                                         classificator_get_percentage_class & ...            % Calculate percentage of movements of every type
                                         classificator_enumerations_class & ...              % Basic enumerations definitions
                                         classificator_time_rate_class & ...                 % Time step and sample rate definitions
                                    handle
    % This is skeleton class for user classification
  
    properties
    end

    methods

% Classification function
        function classify(obj, test_thresholds, saccade_threshold, dispersion_threshold, duration_threshold, sample_rate)
            visualize_output = false;

            if( obj.debug_mode ~= 0 && visualize_output == true)
                fprintf(strcat('Begin data classification with user classifier in :',datestr(now),'\n'));
            end

%% Define Global Variables
            eye_record_length = length(obj.eye_records);
                        
            if exist('test_thresholds')                
                % I-VT variables
                SACCADE_DETECTION_THRESHOLD_DEG_SEC = saccade_threshold;

                % I-DT variables
                DISPERSION_THRESHOLD = dispersion_threshold;
                DURATION_THRESHOLD = floor(duration_threshold/sample_rate);
            else
                sample_rate = 1000/obj.sample_rate;

                % I-VT variables
                SACCADE_DETECTION_THRESHOLD_DEG_SEC = 114;
                % I-DT variables
                DISPERSION_THRESHOLD = 0.67;
                DURATION_THRESHOLD = floor(150/sample_rate);
            end
            
            % HMM Variables
            EPSILON_S_S = 1;
            EPSILON_S_F = 1;
            EPSILON_F_S = 1;
            EPSILON_F_F = 1;
            EPSILON_P_S = 1; 
            EPSILON_P_F = 1; 
            EPSILON_S_P = 1;
            EPSILON_F_P = 1;
            EPSILON_P_P = 1;
            EPSILON_S_MEAN = 1;
            EPSILON_F_MEAN = 1;
            EPSILON_P_MEAN = 1;
            EPSILON_S_SDEV = 1;
            EPSILON_F_SDEV = 1;
            EPSILON_P_SDEV = 1;

%% I-VT to classify Saccades from Fixations/SP
            if visualize_output == true
                disp('Beginning I-VT to separate saccades from fixations and smooth pursuits...');
            end 
            
            obj = I_VT(obj, SACCADE_DETECTION_THRESHOLD_DEG_SEC);
            
            if visualize_output == true
                disp('Finished I-VT classification.');
            end
            
%% Create new Eye Record for classification
            if visualize_output == true
                disp('Creating new eye record for classification...');
            end
            
            eye_record = initialize_eye_record(eye_record_length);
        
            for i=1:eye_record_length
                eye_record(i).xy_velocity_measured_deg = obj.eye_records(i, obj.VELOCITY);
                eye_record(i).x = obj.eye_records(i, obj.X_COORD);
                eye_record(i).y = obj.eye_records(i, obj.Y_COORD);
                eye_record(i).xy_movement_EMD = obj.eye_records(i, obj.MOV_TYPE);
            end
            
            if visualize_output == true
                disp('Eye record created.');
            end
            
%% I-HMM to seperate Saccades from fixations/SP
            if visualize_output == true
                disp('Beginning I-HMM to separate saccades from fixations and smooth pursuits...');
            end
            
            non_classifications = [4];
            noiseless_eye_record = CreateNoiselessEyeRecord(eye_record, non_classifications);
                    
            % Total number of records
            num_records = length(noiseless_eye_record);
            
            % Calculate mean of velocities for fixation and saccade
            [fixation_mean, saccade_mean] = CalculateVelocityMeans(noiseless_eye_record);
            
            % Calculate standard deviation of velocities for fixation and
            % saccade
            [fixation_std_dev, saccade_std_dev] = CalculateVelocityStandardDeviation(noiseless_eye_record, fixation_mean, saccade_mean, 0);

            % Calculate number of transitions between classifications
            [transition_matrix] = TransitionCounts(noiseless_eye_record);
            
            p_fixation_fixation = transition_matrix(1,1); 
            p_fixation_saccade = transition_matrix(1,2); 
            p_saccade_fixation = transition_matrix(2,1); 
            p_saccade_saccade = transition_matrix(2,2); 

            % Initialize variables to identify convergence of viterbi
            old_p_saccade_saccade = 0; 
            old_p_saccade_fixation = 0; 
            old_p_fixation_saccade = 0; 
            old_p_fixation_fixation = 0; 
            old_saccade_mean = 0; 
            old_fixation_mean = 0; 
            old_saccade_std_dev = 0; 
            old_fixation_std_dev = 0; 

            % Begin binary viterbi algorithm 
            converged = false; 
            while(converged == false)
                probability_matrix = zeros(2, num_records); 
                classification_matrix = zeros(2, num_records); 

                % Observation prob as initial prob for the first point
                pf = PDF_function(abs(noiseless_eye_record(1).xy_velocity_measured_deg), fixation_mean, fixation_std_dev);
                ps = PDF_function(abs(noiseless_eye_record(1).xy_velocity_measured_deg), saccade_mean, saccade_std_dev);

                % Insert first column probabilities into probability matrix
                probability_matrix(1,1) = pf / (pf + ps);
                probability_matrix(2,1) = ps / (pf + ps);

                for col = 2:num_records
                    % Calculate observation probabilities
                    pf = PDF_function(abs(noiseless_eye_record(col).xy_velocity_measured_deg), fixation_mean, fixation_std_dev);
                    
                    ps = PDF_function(abs(noiseless_eye_record(col).xy_velocity_measured_deg), saccade_mean, saccade_std_dev);
                    
                    observation_fixation = pf/(pf+ps); 
                    observation_saccade = ps/(pf+ps);

                    % Determine the maximum probability of sequence assuming fixation is the current point
                    fix_fix_prob = probability_matrix(1, col-1) * p_fixation_fixation * observation_fixation; 
                    sac_fix_prob = probability_matrix(2, col-1) * p_saccade_fixation * observation_fixation;  
                    
                    if(fix_fix_prob > sac_fix_prob)
                       probability_matrix(1, col) = fix_fix_prob;
                       classification_matrix(1, col) = 1;
                    else
                       probability_matrix(1, col) = sac_fix_prob; 
                       classification_matrix(1, col) = 2;
                    end

                    % Determine the maximum probability of sequence assuming saccade is the current point
                    fix_sac_prob = probability_matrix(1, col-1) * p_fixation_saccade * observation_saccade; 
                    sac_sac_prob = probability_matrix(2, col-1) * p_saccade_saccade * observation_saccade; 
                    
                    if (fix_sac_prob > sac_sac_prob)
                        probability_matrix(2, col) = fix_sac_prob;
                        classification_matrix(2, col) = 1; 
                    else
                        probability_matrix(2, col) = sac_sac_prob;
                        classification_matrix(2, col) = 2;
                    end
                    
                    if probability_matrix(1,col) < 1e-10 || probability_matrix(2,col) < 1e-10
                        exponent = log10(max(probability_matrix(1,col), probability_matrix(2,col)));
                        probability_matrix(1,col) = probability_matrix(1,col) * 10^-(exponent+1);
                        probability_matrix(2,col) = probability_matrix(2,col) * 10^-(exponent+1);
                    end
                    

                end

                % Determine the final classification
                final_fixation_probability = probability_matrix(1, num_records);
                final_saccade_probability = probability_matrix(2, num_records);
                if (final_fixation_probability > final_saccade_probability)
                    last_classification = 1;
                else
                    last_classification = 2;
                end

                noiseless_eye_record(num_records).xy_movement_EMD = last_classification;

                % Complete traceback & classification assignments on noiseless 
                % eye record through classification matrix 
                classification = last_classification;
                for classification_index = num_records-1:-1:1
                    classification = classification_matrix(classification, classification_index+1); 
                    noiseless_eye_record(classification_index).xy_movement_EMD = classification;
                end
                
                % End viterbi algorithm

                % Recalculate mean of velocities for fixations and saccades
                [fixation_mean, saccade_mean] = CalculateVelocityMeans(noiseless_eye_record);

                % Calculate standard deviation of velocities for fixation and
                % saccade
                [fixation_std_dev, saccade_std_dev] = CalculateVelocityStandardDeviation(noiseless_eye_record, fixation_mean, saccade_mean, 0);

                % Calculate number of transitions between classifications
                [transition_matrix] = TransitionCounts(noiseless_eye_record);

                p_fixation_fixation = transition_matrix(1,1); 
                p_fixation_saccade = transition_matrix(1,2); 
                p_saccade_fixation = transition_matrix(2,1); 
                p_saccade_saccade = transition_matrix(2,2); 
                
                % Check for convergence of transitional probabilities,
                % standard deviation and mean
                if(abs(old_p_saccade_saccade - p_saccade_saccade) <= EPSILON_S_S)
                    if(abs(old_p_saccade_fixation - p_saccade_fixation) <= EPSILON_S_F)
                        if(abs(old_p_fixation_saccade - p_fixation_saccade) <= EPSILON_F_S)
                            if(abs(old_p_fixation_fixation - p_fixation_fixation) <= EPSILON_F_F)
                                if(abs(old_saccade_mean - saccade_mean) <= EPSILON_S_MEAN)
                                    if(abs(old_fixation_mean - fixation_mean) <= EPSILON_F_MEAN)
                                        if(abs(old_saccade_std_dev - saccade_std_dev) <= EPSILON_S_SDEV)
                                            if(abs(old_fixation_std_dev - fixation_std_dev) <= EPSILON_F_SDEV)
                                                converged = true; 
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end

                old_p_saccade_saccade = p_saccade_saccade; 
                old_p_saccade_fixation = p_saccade_fixation; 
                old_p_fixation_saccade = p_fixation_saccade; 
                old_p_fixation_fixation = p_fixation_fixation; 
                old_saccade_mean = saccade_mean; 
                old_fixation_mean = fixation_mean; 
                old_saccade_std_dev = saccade_std_dev; 
                old_fixation_std_dev = fixation_std_dev; 

            end

            % Put classifications back in eye_record so that noise is accounted for
            eye_record = UpdateClassifications(noiseless_eye_record, eye_record, non_classifications);

            
            if visualize_output == true
                disp('Binary I-HMM Completed');
            end
            
%% Implement I-DT of Fixations vs SP
            if visualize_output == true
                disp('Beginning I-DT to separate fixations from smooth pursuits...');
            end
            
            non_classifications = [2, 4];
            noiseless_eye_record = CreateNoiselessEyeRecord(eye_record, non_classifications);

            noiseless_eye_record = I_DT(DISPERSION_THRESHOLD, DURATION_THRESHOLD, noiseless_eye_record);

            eye_record = UpdateClassifications(noiseless_eye_record, eye_record, non_classifications);

            if visualize_output == true
                disp('I-DT Completed');
            end
            
%% Binary HMM to separate Fixations from Smooth Pursuits using dispersion

            if visualize_output == true
                disp('Beginning I-HMM to separate saccades from fixations and smooth pursuits...');
            end
            
            non_classifications = [2, 4];
            noiseless_eye_record = CreateNoiselessEyeRecord(eye_record, non_classifications);
                    
            % Total number of records
            num_records = length(noiseless_eye_record);
            
            % Calculate mean of dispersion for fixations and pursuits
            [fixation_mean, pursuit_mean] = CalculateDispersionMeans(noiseless_eye_record, DURATION_THRESHOLD, DISPERSION_THRESHOLD);
            
            % Calculate standard deviation of dispersion for fixations and
            % pursuits
            [fixation_std_dev, pursuit_std_dev] = CalculateDispersionStandardDeviation(noiseless_eye_record, fixation_mean, pursuit_mean, DURATION_THRESHOLD, DISPERSION_THRESHOLD);

            % Calculate number of transitions between classifications
            [transition_matrix] = TransitionCounts(noiseless_eye_record);
            
            p_fixation_fixation = transition_matrix(1,1); 
            p_fixation_pursuit = transition_matrix(1,3); 
            p_pursuit_fixation = transition_matrix(3,1); 
            p_pursuit_pursuit = transition_matrix(3,3); 

            % Initialize variables to identify convergence of viterbi
            old_p_pursuit_pursuit = 0; 
            old_p_pursuit_fixation = 0; 
            old_p_fixation_pursuit = 0; 
            old_p_fixation_fixation = 0; 
            old_pursuit_mean = 0; 
            old_fixation_mean = 0; 
            old_pursuit_std_dev = 0; 
            old_fixation_std_dev = 0; 

            % Begin binary viterbi algorithm 
            converged = false; 
            while(converged == false)
                probability_matrix = zeros(2, num_records); 
                classification_matrix = zeros(2, num_records); 
                
                difference = CalculateDispersion(noiseless_eye_record, 1, 1, DURATION_THRESHOLD, DISPERSION_THRESHOLD);
                
                % Observation prob as initial prob for the first point
                pf = PDF_function(difference, fixation_mean, fixation_std_dev);
                pp = PDF_function(difference, pursuit_mean, pursuit_std_dev);

                % Insert first column probabilities into probability matrix
                probability_matrix(1,1) = pf / (pf + pp);
                probability_matrix(2,1) = pp / (pf + pp);

                for col = 2:num_records
                    % Calculate observation probabilities
                    difference = CalculateDispersion(noiseless_eye_record, noiseless_eye_record(col).xy_movement_EMD, col, DURATION_THRESHOLD, DISPERSION_THRESHOLD);
                    
                    pf = PDF_function(difference, fixation_mean, fixation_std_dev);
                    
                    pp = PDF_function(difference, pursuit_mean, pursuit_std_dev);
                    
                    observation_fixation = pf/(pf+pp); 
                    observation_pursuit = pp/(pf+pp);

                    % Determine the maximum probability of sequence assuming fixation is the current point
                    fix_fix_prob = probability_matrix(1, col-1) * p_fixation_fixation * observation_fixation; 
                    pur_fix_prob = probability_matrix(2, col-1) * p_pursuit_fixation * observation_fixation;  
                    
                    if(fix_fix_prob > pur_fix_prob)
                       probability_matrix(1, col) = fix_fix_prob;
                       classification_matrix(1, col) = 1;
                    else
                       probability_matrix(1, col) = pur_fix_prob; 
                       classification_matrix(1, col) = 2;
                    end

                    % Determine the maximum probability of sequence assuming saccade is the current point
                    fix_pur_prob = probability_matrix(1, col-1) * p_fixation_pursuit * observation_pursuit; 
                    pur_pur_prob = probability_matrix(2, col-1) * p_pursuit_pursuit * observation_pursuit; 
                    
                    if (fix_pur_prob > pur_pur_prob)
                        probability_matrix(2, col) = fix_pur_prob;
                        classification_matrix(2, col) = 1; 
                    else
                        probability_matrix(2, col) = pur_pur_prob;
                        classification_matrix(2, col) = 2;
                    end
                    
%                     if probability_matrix(1,col) < 1e-10 || probability_matrix(2,col) < 1e-10
%                         exponent = log10(max(probability_matrix(1,col), probability_matrix(2,col)));
%                         probability_matrix(1,col) = probability_matrix(1,col) * 10^-(exponent+1);
%                         probability_matrix(2,col) = probability_matrix(2,col) * 10^-(exponent+1);
%                     end
                    

                end

                % Determine the final classification
                final_fixation_probability = probability_matrix(1, num_records);
                final_pursuit_probability = probability_matrix(2, num_records);
                if (final_fixation_probability > final_pursuit_probability)
                    last_classification = 1;
                else
                    last_classification = 2;
                end

                if last_classification == 2
                    noiseless_eye_record(num_records).xy_movement_EMD = 3;
                else
                    noiseless_eye_record(num_records).xy_movement_EMD = 1;
                end

                % Complete traceback & classification assignments on noiseless 
                % eye record through classification matrix 
                classification = last_classification;
                num_changes = 0;
                for classification_index = num_records-1:-1:1
                    classification = classification_matrix(classification, classification_index+1); 
                    if classification == 2
                        if noiseless_eye_record(num_records).xy_movement_EMD ~= 3
                            num_changes = num_changes + 1;
                        end
                        noiseless_eye_record(num_records).xy_movement_EMD = 3;
                    else
                        if noiseless_eye_record(num_records).xy_movement_EMD ~= 1
                            num_changes = num_changes + 1;
                        end
                        noiseless_eye_record(classification_index).xy_movement_EMD = 1;
                    end
                end
                
                % End viterbi algorithm

                % Recalculate mean of velocities for fixations and saccades
                [fixation_mean, pursuit_mean] = CalculateDispersionMeans(noiseless_eye_record, DURATION_THRESHOLD, DISPERSION_THRESHOLD);

                % Calculate standard deviation of velocities for fixation and
                % saccade
                [fixation_std_dev, pursuit_std_dev] = CalculateDispersionStandardDeviation(noiseless_eye_record, fixation_mean, pursuit_mean, DURATION_THRESHOLD, DISPERSION_THRESHOLD);

                % Calculate number of transitions between classifications
                [transition_matrix] = TransitionCounts(noiseless_eye_record);

                p_fixation_fixation = transition_matrix(1,1); 
                p_fixation_pursuit = transition_matrix(1,2); 
                p_pursuit_fixation = transition_matrix(2,1); 
                p_pursuit_pursuit = transition_matrix(2,2); 
                
                % Check for convergence of transitional probabilities,
                % standard deviation and mean
                if(abs(old_p_pursuit_pursuit - p_pursuit_pursuit) <= EPSILON_P_P)
                    if(abs(old_p_pursuit_fixation - p_pursuit_fixation) <= EPSILON_P_F)
                        if(abs(old_p_fixation_pursuit - p_fixation_pursuit) <= EPSILON_F_P)
                            if(abs(old_p_fixation_fixation - p_fixation_fixation) <= EPSILON_F_F)
                                if(abs(old_pursuit_mean - pursuit_mean) <= EPSILON_P_MEAN)
                                    if(abs(old_fixation_mean - fixation_mean) <= EPSILON_F_MEAN)
                                        if(abs(old_pursuit_std_dev - pursuit_std_dev) <= EPSILON_P_SDEV)
                                            if(abs(old_fixation_std_dev - fixation_std_dev) <= EPSILON_F_SDEV)
                                                converged = true; 
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end

                old_p_pursuit_pursuit = p_pursuit_pursuit; 
                old_p_pursuit_fixation = p_pursuit_fixation; 
                old_p_fixation_pursuit = p_fixation_pursuit; 
                old_p_fixation_fixation = p_fixation_fixation; 
                old_pursuit_mean = pursuit_mean; 
                old_fixation_mean = fixation_mean; 
                old_pursuit_std_dev = pursuit_std_dev; 
                old_fixation_std_dev = fixation_std_dev; 

            end

            % Put classifications back in eye_record so that noise is accounted for
            eye_record = UpdateClassifications(noiseless_eye_record, eye_record, non_classifications);

            
            if visualize_output == true
                disp('Binary I-HMM Completed');
            end

% %% Binary HMM to separate Fixations from Smooth Pursuits
% 
%             if visualize_output == true
%                 disp('Beginning I-HMM to separate saccades from fixations and smooth pursuits...');
%             end
%             
%             non_classifications = [2, 4];
%             noiseless_eye_record = CreateNoiselessEyeRecord(eye_record, non_classifications);
%                     
%             % Total number of records
%             num_records = length(noiseless_eye_record);
%             
%             % Calculate mean of velocities for fixation and pursuits
%             [fixation_mean, saccade_mean, pursuit_mean] = CalculateVelocityMeans(noiseless_eye_record);
%             
%             % Calculate standard deviation of velocities for fixation and
%             % pursuits
%             [fixation_std_dev, saccade_std_dev, pursuit_std_dev] = CalculateVelocityStandardDeviation(noiseless_eye_record, fixation_mean, saccade_mean, pursuit_mean);
% 
%             % Calculate number of transitions between classifications
%             [transition_matrix] = TransitionCounts(noiseless_eye_record);
%             
%             p_fixation_fixation = transition_matrix(1,1); 
%             p_fixation_pursuit = transition_matrix(1,3); 
%             p_pursuit_fixation = transition_matrix(3,1); 
%             p_pursuit_pursuit = transition_matrix(3,3); 
% 
%             % Initialize variables to identify convergence of viterbi
%             old_p_pursuit_pursuit = 0; 
%             old_p_pursuit_fixation = 0; 
%             old_p_fixation_pursuit = 0; 
%             old_p_fixation_fixation = 0; 
%             old_pursuit_mean = 0; 
%             old_fixation_mean = 0; 
%             old_pursuit_std_dev = 0; 
%             old_fixation_std_dev = 0; 
% 
%             % Begin binary viterbi algorithm 
%             converged = false; 
%             while(converged == false)
%                 probability_matrix = zeros(2, num_records); 
%                 classification_matrix = zeros(2, num_records); 
% 
%                 % Observation prob as initial prob for the first point
%                 pf = PDF_function(abs(noiseless_eye_record(1).xy_velocity_measured_deg), fixation_mean, fixation_std_dev);
%                 pp = PDF_function(abs(noiseless_eye_record(1).xy_velocity_measured_deg), pursuit_mean, pursuit_std_dev);
% 
%                 % Insert first column probabilities into probability matrix
%                 probability_matrix(1,1) = pf / (pf + pp);
%                 probability_matrix(2,1) = pp / (pf + pp);
% 
%                 for col = 2:num_records
%                     % Calculate observation probabilities
%                     pf = PDF_function(abs(noiseless_eye_record(col).xy_velocity_measured_deg), fixation_mean, fixation_std_dev);
%                     
%                     pp = PDF_function(abs(noiseless_eye_record(col).xy_velocity_measured_deg), pursuit_mean, pursuit_std_dev);
%                     
%                     if pp == 0
%                         pp = pf*10^-5;
%                     end
%                     if pf == 0
%                         pf = pp*10^-5;
%                     end
%                     if pf == 0 && pp == 0
%                         pf = 10^-10;
%                         pp = 10^-10;
%                     end
%                     
%                     
%                     observation_fixation = pf/(pf+pp); 
%                     observation_pursuit = pp/(pf+pp);
%                     
% 
%                     % Determine the maximum probability of sequence assuming fixation is the current point
%                     fix_fix_prob = probability_matrix(1, col-1) * p_fixation_fixation * observation_fixation; 
%                     pur_fix_prob = probability_matrix(2, col-1) * p_pursuit_fixation * observation_fixation;  
%                     
%                     if(fix_fix_prob > pur_fix_prob)
%                        probability_matrix(1, col) = fix_fix_prob;
%                        classification_matrix(1, col) = 1;
%                     else
%                        probability_matrix(1, col) = pur_fix_prob; 
%                        classification_matrix(1, col) = 2;
%                     end
% 
%                     % Determine the maximum probability of sequence assuming saccade is the current point
%                     fix_pur_prob = probability_matrix(1, col-1) * p_fixation_pursuit * observation_pursuit; 
%                     pur_pur_prob = probability_matrix(2, col-1) * p_pursuit_pursuit * observation_pursuit; 
%                     
%                     
%                     if (fix_pur_prob > pur_pur_prob)
%                         probability_matrix(2, col) = fix_pur_prob;
%                         classification_matrix(2, col) = 1; 
%                     else
%                         probability_matrix(2, col) = pur_pur_prob;
%                         classification_matrix(2, col) = 2;
%                     end
%                     
%                     if probability_matrix(1,col) < 1e-10 || probability_matrix(2,col) < 1e-10
%                         exponent = log10(max(probability_matrix(1,col), probability_matrix(2,col)));
%                         probability_matrix(1,col) = probability_matrix(1,col) * 10^-(exponent+1);
%                         probability_matrix(2,col) = probability_matrix(2,col) * 10^-(exponent+1);
%                     end
%                     
% 
%                 end
% 
%                 % Determine the final classification
%                 final_fixation_probability = probability_matrix(1, num_records);
%                 final_pursuit_probability = probability_matrix(2, num_records);
%                 if (final_fixation_probability > final_pursuit_probability)
%                     last_classification = 1;
%                 else
%                     last_classification = 2;
%                 end
% 
%                 if last_classification == 2
%                     noiseless_eye_record(num_records).xy_movement_EMD = 3;
%                 else
%                     noiseless_eye_record(num_records).xy_movement_EMD = 1;
%                 end
% 
%                 % Complete traceback & classification assignments on noiseless 
%                 % eye record through classification matrix 
%                 classification = last_classification;
%                 for classification_index = num_records-1:-1:1
%                     classification = classification_matrix(classification, classification_index+1); 
%                     if last_classification == 2
%                         noiseless_eye_record(num_records).xy_movement_EMD = 3;
%                     else
%                         noiseless_eye_record(classification_index).xy_movement_EMD = 1;
%                     end
%                 end
%                 
%                 % End viterbi algorithm
% 
%                 % Recalculate mean of velocities for fixations and saccades
%                 [fixation_mean, saccade_mean, pursuit_mean] = CalculateVelocityMeans(noiseless_eye_record);
% 
%                 % Calculate standard deviation of velocities for fixation and
%                 % saccade
%                 [fixation_std_dev, saccade_std_dev, pursuit_std_dev] = CalculateVelocityStandardDeviation(noiseless_eye_record, fixation_mean, saccade_mean, pursuit_mean);
% 
%                 % Calculate number of transitions between classifications
%                 [transition_matrix] = TransitionCounts(noiseless_eye_record);
% 
%                 p_fixation_fixation = transition_matrix(1,1); 
%                 p_fixation_pursuit = transition_matrix(1,2); 
%                 p_pursuit_fixation = transition_matrix(2,1); 
%                 p_pursuit_pursuit = transition_matrix(2,2); 
%                 
%                 % Check for convergence of transitional probabilities,
%                 % standard deviation and mean
%                 if(abs(old_p_pursuit_pursuit - p_pursuit_pursuit) <= EPSILON_P_P)
%                     if(abs(old_p_pursuit_fixation - p_pursuit_fixation) <= EPSILON_P_F)
%                         if(abs(old_p_fixation_pursuit - p_fixation_pursuit) <= EPSILON_F_P)
%                             if(abs(old_p_fixation_fixation - p_fixation_fixation) <= EPSILON_F_F)
%                                 if(abs(old_pursuit_mean - pursuit_mean) <= EPSILON_P_MEAN)
%                                     if(abs(old_fixation_mean - fixation_mean) <= EPSILON_F_MEAN)
%                                         if(abs(old_pursuit_std_dev - pursuit_std_dev) <= EPSILON_P_SDEV)
%                                             if(abs(old_fixation_std_dev - fixation_std_dev) <= EPSILON_F_SDEV)
%                                                 converged = true; 
%                                             end
%                                         end
%                                     end
%                                 end
%                             end
%                         end
%                     end
%                 end
% 
%                 old_p_pursuit_pursuit = p_pursuit_pursuit; 
%                 old_p_pursuit_fixation = p_pursuit_fixation; 
%                 old_p_fixation_pursuit = p_fixation_pursuit; 
%                 old_p_fixation_fixation = p_fixation_fixation; 
%                 old_pursuit_mean = pursuit_mean; 
%                 old_fixation_mean = fixation_mean; 
%                 old_pursuit_std_dev = pursuit_std_dev; 
%                 old_fixation_std_dev = fixation_std_dev; 
% 
%             end
% 
%             % Put classifications back in eye_record so that noise is accounted for
%             eye_record = UpdateClassifications(noiseless_eye_record, eye_record, non_classifications);
% 
%             
%             if visualize_output == true
%                 disp('Binary I-HMM Completed');
%             end
            %% Implement 3 state HMM to seperate Saccades From Fixations From Smooth Pursuits
%             if visualize_output == true
%                 disp('Beginning I-HMM to separate saccades from fixations from smooth pursuits...');
%             end
%             
%             non_classifications = [4];
%     
%             noiseless_eye_record = CreateNoiselessEyeRecord(eye_record, non_classifications);
%     
%             % Total number of records
%             num_records = length(noiseless_eye_record);
%             
%             % Calculate mean of velocities for fixation, saccade, and
%             % pursuit
%             [fixation_mean, saccade_mean, pursuit_mean] = CalculateVelocityMeans(noiseless_eye_record);
%             
%             % Calculate standard deviation of velocities for fixation and
%             % saccade
%             [fixation_std_dev, saccade_std_dev, pursuit_std_dev] = CalculateVelocityStandardDeviation(noiseless_eye_record, fixation_mean, saccade_mean, pursuit_mean);
% 
%             % Calculate number of transitions between classifications
%             [transition_matrix] = TransitionCounts(noiseless_eye_record);
%             
%             p_fixation_fixation = transition_matrix(1,1); 
%             p_fixation_saccade = transition_matrix(1,2); 
%             p_fixation_pursuit = transition_matrix(1,3); 
% 
%             p_saccade_fixation = transition_matrix(2,1); 
%             p_saccade_saccade = transition_matrix(2,2); 
%             p_saccade_pursuit = transition_matrix(2,3); 
%             
%             p_pursuit_fixation = transition_matrix(3,1); 
%             p_pursuit_saccade = transition_matrix(3,2); 
%             p_pursuit_pursuit = transition_matrix(3,3); 
%             
%             % Initialize variables to identify convergence of viterbi
%             old_p_saccade_saccade = 0; 
%             old_p_saccade_fixation = 0; 
%             old_p_fixation_saccade = 0; 
%             old_p_fixation_fixation = 0; 
%             old_p_fixation_pursuit = 0; 
%             old_p_saccade_pursuit = 0; 
%             old_p_pursuit_fixation = 0; 
%             old_p_pursuit_saccade = 0; 
%             old_p_pursuit_pursuit = 0; 
%             old_saccade_mean = 0; 
%             old_fixation_mean = 0; 
%             old_pursuit_mean = 0;
%             old_saccade_std_dev = 0; 
%             old_fixation_std_dev = 0;  
%             old_pursuit_std_dev = 0; 
%     
%             % Begin ternary viterbi algorithm
%             converged = false; 
%             while(converged == false)
% 
%                 % Initialize probability and classification matrices
%                 probability_matrix = zeros(3, num_records); 
%                 classification_matrix = zeros(3, num_records); 
% 
%                 % Calculate probabilities for F, S, SP
%                 pf = PDF_function(abs(noiseless_eye_record(1).xy_velocity_measured_deg), fixation_mean, fixation_std_dev);
%                 ps = PDF_function(abs(noiseless_eye_record(1).xy_velocity_measured_deg), saccade_mean, saccade_std_dev);
%                 pp = PDF_function(abs(noiseless_eye_record(1).xy_velocity_measured_deg), pursuit_mean, pursuit_std_dev);
% 
%                 % Insert first values in probability matrix
%                 probability_matrix(1,1) = pf / (pf + ps + pp);
%                 probability_matrix(2,1) = ps / (pf + ps + pp);
%                 probability_matrix(3,1) = pp / (pf + ps + pp);
% 
%                 adjust_probabilities_iter = 1;
%                 for col = 2:num_records
%                     % Calculate current states probabilities
%                     pf = PDF_function(abs(noiseless_eye_record(col).xy_velocity_measured_deg), fixation_mean, fixation_std_dev);
%                     ps = PDF_function(abs(noiseless_eye_record(col).xy_velocity_measured_deg), saccade_mean, saccade_std_dev);
%                     pp = PDF_function(abs(noiseless_eye_record(col).xy_velocity_measured_deg), pursuit_mean, pursuit_std_dev);
% 
%                     %minProbability = min([pf(pf>0), ps(ps>0), pp(pp>0)]);
%                     if ps == 0
%                         ps = 10^-5;
%                         %ps = minProbability*10^-1;
%                     end
%                     if pf == 0
%                         pf = 10^-5;
%                         %pf = minProbability*10^-1;
%                     end
%                     if pp == 0
%                         pp = 10^-5;
%                        %pp = minProbability*10^-1;
%                     end
%                     if pf == 0 && ps == 0 && pp == 0
%                         pf = 10^-10;
%                         ps = 10^-10;
%                         pp = 10^-10;
%                     end
%                     if isnan(pf)
%                         pf = 10^-5;
%                         %pf = minProbability*10^-1;
%                     end
%                     if isnan(ps)
%                         ps = 10^-5;
%                         %ps = minProbability*10^-1;
%                     end
%                     if isnan(pp)
%                         pp = 10^-5;
%                         %pp = minProbability*10^-1;
%                     end
%                         
%                     % Determine observation probabilities
%                     try
%                         observation_fixation = pf / (pf + ps + pp); 
%                         observation_saccade = ps / (pf + ps + pp); 
%                         observation_pursuit = pp / (pf + ps + pp); 
%                     catch
%                         disp('...');
%                     end
% 
%                     % Determine the maximum probability of sequence assuming 
%                     % fixation is the current point
%                     fix_fix_prob = probability_matrix(1, col-1) * p_fixation_fixation * observation_fixation; 
%                     sac_fix_prob = probability_matrix(2, col-1) * p_saccade_fixation * observation_fixation;  
%                     pur_fix_prob = probability_matrix(3, col-1) * p_pursuit_fixation * observation_fixation; 
% 
%                     if(fix_fix_prob > sac_fix_prob && fix_fix_prob > pur_fix_prob)
%                        probability_matrix(1, col) = fix_fix_prob;
%                        classification_matrix(1, col) = 1;
%                     elseif (sac_fix_prob > fix_fix_prob && sac_fix_prob > pur_fix_prob)
%                        probability_matrix(1, col) = sac_fix_prob; 
%                        classification_matrix(1, col) = 2;
%                     else
%                        probability_matrix(1, col) = pur_fix_prob;
%                        classification_matrix(1, col) = 3;
%                     end
% 
%                     % Determine the maximum probability of sequence assuming 
%                     % saccade is the current point
%                     fix_sac_prob = probability_matrix(1, col-1) * p_fixation_saccade * observation_saccade; 
%                     sac_sac_prob = probability_matrix(2, col-1) * p_saccade_saccade * observation_saccade;  
%                     pur_sac_prob = probability_matrix(3, col-1) * p_pursuit_saccade * observation_saccade; 
% 
%                     if(fix_sac_prob > sac_sac_prob && fix_sac_prob > pur_sac_prob)
%                        probability_matrix(2, col) = fix_sac_prob;
%                        classification_matrix(2, col) = 1;
%                     elseif (sac_sac_prob > fix_sac_prob && sac_sac_prob > pur_sac_prob)
%                        probability_matrix(2, col) = sac_sac_prob; 
%                        classification_matrix(2, col) = 2;
%                     else
%                        probability_matrix(2, col) = pur_sac_prob;
%                        classification_matrix(2, col) = 3;
%                     end
% 
%                     % Determine the maximum probability of sequence assuming 
%                     % saccade is the current point
%                     fix_pur_prob = probability_matrix(1, col-1) * p_fixation_pursuit * observation_pursuit; 
%                     sac_pur_prob = probability_matrix(2, col-1) * p_saccade_pursuit * observation_pursuit;  
%                     pur_pur_prob = probability_matrix(3, col-1) * p_pursuit_pursuit * observation_pursuit; 
% 
%                     if(fix_pur_prob > sac_pur_prob && fix_pur_prob > pur_pur_prob)
%                        probability_matrix(3, col) = fix_pur_prob;
%                        classification_matrix(3, col) = 1;
%                     elseif (sac_pur_prob > fix_pur_prob && sac_pur_prob > pur_pur_prob)
%                        probability_matrix(3, col) = sac_pur_prob; 
%                        classification_matrix(3, col) = 2;
%                     else
%                        probability_matrix(3, col) = pur_pur_prob;
%                        classification_matrix(3, col) = 3;
%                     end
% 
%                     if probability_matrix(1,col) < 1e-20 || probability_matrix(2,col) < 1e-20 || probability_matrix(3,col) < 1e-20
%                         exponent = log10(max([probability_matrix(1,col), probability_matrix(2,col), probability_matrix(3,col)]));
%                         probability_matrix(1,col) = probability_matrix(1,col) * 10^-(exponent+1);
%                         probability_matrix(2,col) = probability_matrix(2,col) * 10^-(exponent+1);
%                         probability_matrix(3,col) = probability_matrix(3,col) * 10^-(exponent+1);
%                     elseif adjust_probabilities_iter > 150
%                         adjust_probabilities_iter = 1;
%                         probability_matrix(1,col) = 0.3333;
%                         probability_matrix(2,col) = 0.3333;
%                         probability_matrix(3,col) = 0.3333;
%                     end
%                     
%                     adjust_probabilities_iter = adjust_probabilities_iter + 1;
%                     
%                     
%                 end
% 
%                  % Determine the final classification
%                 final_fixation_probability = probability_matrix(1, num_records);
%                 final_saccade_probability = probability_matrix(2, num_records);
%                 final_pursuit_probability = probability_matrix(3, num_records);
% 
%                 if (final_fixation_probability > final_saccade_probability && final_fixation_probability > final_pursuit_probability)
%                     last_classification = 1;
%                 elseif (final_saccade_probability > final_fixation_probability && final_saccade_probability > final_pursuit_probability)
%                     last_classification = 2;
%                 else
%                     last_classification = 3;
%                 end
% 
%                 noiseless_eye_record(num_records).xy_movement_EMD = last_classification;
% 
%                 % Complete traceback & classification assignments on noiseless 
%                 % eye record through classification matrix 
%                 classification = last_classification;
%                 for classification_index = num_records-1:-1:1
%                     classification = classification_matrix(classification, classification_index+1); 
%                     noiseless_eye_record(classification_index).xy_movement_EMD = classification;
%                 end
% 
%                 % Calculate mean of velocities for fixation, saccade, and
%                 % pursuit
%                 [fixation_mean, saccade_mean, pursuit_mean] = CalculateVelocityMeans(noiseless_eye_record);
% 
%                 % Calculate standard deviation of velocities for fixation, saccade,
%                 % and pursuit
%                 [fixation_std_dev, saccade_std_dev, pursuit_std_dev] = CalculateVelocityStandardDeviation(noiseless_eye_record, fixation_mean, saccade_mean, pursuit_mean);
% 
%                 % Calculate number of transitions between classifications
%                 [transition_matrix] = TransitionCounts(noiseless_eye_record);
% 
%                 p_fixation_fixation = transition_matrix(1,1); 
%                 p_fixation_saccade = transition_matrix(1,2); 
%                 p_fixation_pursuit = transition_matrix(1,3); 
% 
%                 p_saccade_fixation = transition_matrix(2,1); 
%                 p_saccade_saccade = transition_matrix(2,2); 
%                 p_saccade_pursuit = transition_matrix(2,3); 
% 
%                 p_pursuit_fixation = transition_matrix(3,1); 
%                 p_pursuit_saccade = transition_matrix(3,2); 
%                 p_pursuit_pursuit = transition_matrix(3,3);
% 
%                 % End viterbi algorithm
% 
%                 % Check for convergence of transitional probabilities,
%                 % standard deviation and mean
%                 if(abs(old_p_saccade_saccade - p_saccade_saccade) <= EPSILON_S_S)
%                     if(abs(old_p_saccade_fixation - p_saccade_fixation) <= EPSILON_S_F)
%                         if(abs(old_p_fixation_saccade - p_fixation_saccade) <= EPSILON_F_S)
%                             if(abs(old_p_fixation_fixation - p_fixation_fixation) <= EPSILON_F_F)
%                                 if(abs(old_p_fixation_pursuit - p_fixation_pursuit) <= EPSILON_F_P) 
%                                     if(abs(old_p_saccade_pursuit - p_saccade_pursuit) <= EPSILON_S_P)
%                                         if(abs(old_p_pursuit_fixation - p_pursuit_fixation) <= EPSILON_P_F) 
%                                             if(abs(old_p_pursuit_saccade - p_pursuit_saccade) <= EPSILON_P_S)
%                                                 if(abs(old_p_pursuit_pursuit - p_pursuit_pursuit) <= EPSILON_P_P)                
%                                                     if(abs(old_saccade_mean - saccade_mean) <= EPSILON_S_MEAN)
%                                                         if(abs(old_fixation_mean - fixation_mean) <= EPSILON_F_MEAN)
%                                                             if(abs(old_pursuit_mean - pursuit_mean) <= EPSILON_P_MEAN)
%                                                                 if(abs(old_saccade_std_dev - saccade_std_dev) <= EPSILON_S_SDEV)
%                                                                     if(abs(old_fixation_std_dev - fixation_std_dev) <= EPSILON_F_SDEV)
%                                                                         if(abs(old_pursuit_std_dev - pursuit_std_dev) <= EPSILON_P_SDEV) 
%                                                                            converged = true; 
%                                                                         end
%                                                                     end
%                                                                 end
%                                                             end
%                                                         end
%                                                     end
%                                                 end
%                                             end
%                                         end
%                                     end
%                                 end
%                             end
%                         end
%                     end
%                 end
%                 
%                 old_p_saccade_saccade = p_saccade_saccade; 
%                 old_p_saccade_fixation = p_saccade_fixation; 
%                 old_p_fixation_saccade = p_fixation_saccade; 
%                 old_p_fixation_fixation = p_fixation_fixation; 
%                 old_p_fixation_pursuit = p_fixation_pursuit; 
%                 old_p_saccade_pursuit = p_saccade_pursuit; 
%                 old_p_pursuit_fixation = p_pursuit_fixation; 
%                 old_p_pursuit_saccade = p_pursuit_saccade; 
%                 old_p_pursuit_pursuit = p_pursuit_pursuit; 
%                 old_saccade_mean = saccade_mean; 
%                 old_fixation_mean = fixation_mean; 
%                 old_pursuit_mean = pursuit_mean; 
%                 old_saccade_std_dev = saccade_std_dev; 
%                 old_fixation_std_dev = fixation_std_dev; 
%                 old_pursuit_std_dev = pursuit_std_dev; 
%                 
%             end
% 
%             UpdateClassifications(noiseless_eye_record, eye_record, non_classifications);
%             
%             if visualize_output == true
%                 disp('Ternary I-HMM completed');
%             end
            
%% Merge back into reporting eye record
            if visualize_output == true
                disp('Merging data into reporting eye record...');
            end
            
            for i=1:eye_record_length            
                try
                    obj.eye_records(i,obj.MOV_TYPE ) = eye_record(i).xy_movement_EMD;
                catch
                    obj.eye_records(i,obj.MOV_TYPE ) = 4;
                end
            end
            
            % Ensure noise is put back in the correct place
            obj.eye_records( (obj.eye_records(:,obj.VALIDITY) == obj.DATA_INVALID),obj.MOV_TYPE ) = obj.NOISE_TYPE; 
        
            if visualize_output == true
                disp('Merge completed');
            end
            
            if(obj.debug_mode ~= 0 && visualize_output == true)
                fprintf(strcat('Complete data classification with user classifier in :',datestr(now),'\n'));
            end
        end
    end

end
