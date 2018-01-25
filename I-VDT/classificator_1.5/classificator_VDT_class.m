% Modified by Sam Berndt, Tim Taviano, Doug Kirkpatrick 
% Project 3 - Ternary Classification
% Oleg K. 
% Last Modified 12/3/17

% I-DT model classificator
classdef classificator_VDT_class <  eye_tracker_raw_data_reader_class & ...             % Reader from eye tracker data
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
