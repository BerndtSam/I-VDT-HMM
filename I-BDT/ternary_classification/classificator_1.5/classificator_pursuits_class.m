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
        function classify(obj)
            
            % Convert our dataset to I-BDT eye records
            
            % Call I-BDT code using converted dataset
            
            % Recieve output
            
            % Convert into our eye records
            
            % Report
            
            
        end
    end

end
