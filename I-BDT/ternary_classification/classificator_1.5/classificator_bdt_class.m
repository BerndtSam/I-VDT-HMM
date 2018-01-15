% I-DT model classificator
classdef classificator_bdt_class <  eye_tracker_raw_data_reader_class & ...             % Reader from eye tracker data
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
            % I-BDT Setup
            addpath('classification');
            addpath('utils');
           
            in = '/Users/SamBerndt/Desktop/Class/Research/I-VDT-HMM/ternary_classifier/classificator_1.5/input/SubsamplesBDT/s_007_30.txt';
            entries = importdata(in, '\t', 2);

            % Convert our dataset to I-BDT eye records
            % Creates data class
            d = DataClass(entries.data);
            
            d.c.set(1, fixation);

            d.c.set( d.ev == 0 , noise );

            classifications = ibdt(d, 80);
            classifications = classifications.value;
            
            eye_record_length = length(obj.eye_records);
            for i=1:eye_record_length     
                try
                    if classifications(i) == 0
                        obj.eye_records(i,obj.MOV_TYPE ) = 4;
                    else
                        obj.eye_records(i,obj.MOV_TYPE ) = classifications(i);
                    end
                catch
                    obj.eye_records(i,obj.MOV_TYPE ) = 4;
                end
            end
            % Call I-BDT code using converted dataset
            %run(datasetDir, groundTruth, target, id)
            %run(datasetDir, groundTruth, target, '6/1');
            
            % Recieve output
            
            % Convert into our eye records
            
            % Report
            
            
        end
    end

end
