% This code is a part of Eye Movement classifier written by Alex Karpov
% Department of Computer Science, Texas State University
% ak26@txstate.edu

classdef classificator_IVVT_class < eye_tracker_raw_data_reader_class & ...             % Reader from eye tracker data
                                    eye_records_class & ...                             % Basic class for placing eye tracker data
                                    eye_tracker_raw_data_converter_ETU_degree & ...     % Convertor between ETU and degress in data
                                    eye_tracker_raw_data_filter_class & ...             % Eye tracker data filtering by range of degrees
                                    classificator_merge_class & ...                     % Creates sequences of eye movements
                                    classificator_saccade_amplitude_filter_class & ...  % Filtered saccades based theire amplitude
                                    classificator_datafile_output_class & ...           % Output sequences to the files
                                    classificator_get_percentage_class & ...            % Calculate percentage of movements of every type
                                    classificator_enumerations_class & ...              % Basic enumerations definitions
                                    classificator_time_rate_class & ...                 % Time step and sample rate definition
                                    handle
    % This is implementation of I-VVT classification for tertiary
    % For classification you have to do next:
    % 1. Setup delta_t_sec property calling set.delta_t_sec method
    % 2. Setup saccade_detection_threshold property calling set.saccade_detection_threshold method
    % 3. Setup fixation_detection_threshold property calling set.fixation_detection_threshold method
    % 4. Call classify method to make classification
    properties (Hidden)
% Publicly accessible properties
        saccade_detection_threshold;     % saccade detection threshold value - see I-VVT model description for details
        fixation_detection_threshold;    % fixation detection threshold value - see I-VVT model description for details
    end    

    methods
% Classification functions

% Classification function - ver 1 with pursuits.
        function classify(obj)
            if( obj.debug_mode ~= 0), fprintf(strcat('Begin data classification with I-VVT classifier in :',datestr(now),'\n')); end
            obj.calculate_delta_t();
            x_velocity_degree = zeros( length(obj.eye_records),1 );
            y_velocity_degree = zeros( length(obj.eye_records),1 );
% Calculate absolute degree velocity of our records
            x_velocity_degree( 2:end ) =(   obj.eye_records( 2:end,obj.X_COORD ) - ...
                                            obj.eye_records( 1:end-1,obj.X_COORD ) ) / obj.delta_t_sec;
            y_velocity_degree( 2:end ) =(   obj.eye_records( 2:end,obj.Y_COORD ) - ...
                                            obj.eye_records( 1:end-1,obj.Y_COORD ) ) / obj.delta_t_sec;
% First point is a special case
            x_velocity_degree(1) = 0;
            y_velocity_degree(1) = 0;
            obj.eye_records(:,obj.VELOCITY) = sqrt( x_velocity_degree.^2 + y_velocity_degree.^2 );
% First point is a special case
            obj.eye_records(1,obj.MOV_TYPE ) = obj.NOISE_TYPE;
            obj.eye_records(1,obj.VELOCITY) = 0;

% Now we mark fixations
            obj.eye_records( ((abs(obj.eye_records(:,obj.VELOCITY)) < obj.fixation_detection_threshold) & (obj.eye_records(:,obj.MOV_TYPE) ~= obj.NOISE_TYPE)),obj.MOV_TYPE ) = obj.FIXATION_TYPE;
% Now we mark pursuits
            obj.eye_records( ((abs(obj.eye_records(:,obj.VELOCITY)) >= obj.fixation_detection_threshold) & (abs(obj.eye_records(:,obj.VELOCITY)) < obj.saccade_detection_threshold) & (obj.eye_records(:,obj.MOV_TYPE) ~= obj.NOISE_TYPE)),obj.MOV_TYPE ) = obj.PURSUIT_TYPE;
% Now we mark saccades
            obj.eye_records( ((abs(obj.eye_records(:,obj.VELOCITY)) >= obj.saccade_detection_threshold) & (obj.eye_records(:,obj.MOV_TYPE) ~= obj.NOISE_TYPE)),obj.MOV_TYPE ) = obj.SACCADE_TYPE;
% Now we mark every invalid point as noise
            obj.eye_records( (obj.eye_records(:,obj.VALIDITY) == obj.DATA_INVALID),obj.MOV_TYPE ) = obj.NOISE_TYPE;
% And we mark every noise points as invalid
            obj.eye_records( (obj.eye_records(:,obj.MOV_TYPE) == obj.NOISE_TYPE),obj.VALIDITY ) = obj.DATA_INVALID;
% Now we have to expand saccade mark to previous point
            tmp_type = obj.eye_records(2:end,obj.MOV_TYPE);
            tmp_type(length(tmp_type)+1) = NaN;
            obj.eye_records( ((obj.eye_records(:,obj.VALIDITY) == obj.DATA_VALID) & (tmp_type(:) == obj.SACCADE_TYPE)),obj.MOV_TYPE) = obj.SACCADE_TYPE;

% This is special case
            obj.eye_records( 1 , obj.MOV_TYPE ) = obj.eye_records( 2 , obj.MOV_TYPE );

            if( obj.debug_mode ~= 0)
                fprintf(strcat('Complete data classification with I-VT classifier in :',datestr(now),'\n'));
            end
        end

% Access interface to publicly accessible properties
        function set.saccade_detection_threshold(obj,value), obj.saccade_detection_threshold = value; end
        function set.fixation_detection_threshold(obj,value), obj.fixation_detection_threshold = value; end

    end

end
