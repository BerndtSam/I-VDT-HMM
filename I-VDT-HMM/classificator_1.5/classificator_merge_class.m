classdef classificator_merge_class <    eye_records_class & ...                 % Basic eye tracker data definitions
                                        eye_movements_records_class & ...       % Contain definition for classifications lists
                                        eye_tracker_raw_data_filter_class & ... % Eye tracker data filtration based by allowed degress
                                        classificator_enumerations_class & ...  % Basic enumerations definitions
                                        classificator_time_rate_class & ...     % Time step and sample rate definitions
                                        handle
% This class is designed for merge eye records classified as saccades,
% fixations etc to lists.
    properties (Hidden)
        merge_fixation_time_interval;   % Time interval between two merged fixations
        merge_fixation_distance;        % Distance between two merged fixation
    end

    methods
% Merge method
        function merge_records(obj)
            if( obj.debug_mode ~= 0)
                fprintf(strcat('Begin merge fixations and splitting records in :',datestr(now),'\n'));
            end
            obj.calculate_delta_t();
% Clear all classifications lists
            obj.saccade_records =   {};
            obj.noise_records =     {};
            obj.fixation_records =  {};
            obj.pursuit_records =   {};
% And reset all counters
            counters = zeros(4,1);
% Now we are going to split our eye movement records into 4 separate lists
            i=1;
            while ( i < length(obj.eye_records) )
% Get the first position of our classified eye movement
                onset_position = i;
% and moving towards the end of the records list until we meet this
% movement end or reach the end of records.
                while ( i<length(obj.eye_records) && ...
                        obj.eye_records( i , obj.MOV_TYPE) == obj.eye_records( onset_position , obj.MOV_TYPE ))
                    i=i+1;
                end
% Now we found our offset position
                offset_position = i;
% Now we should exclude saccades with amplitudes less then 0.5 degree
% And saccades that outside of allowed range, if necessary
                if ( obj.eye_records( onset_position, obj.MOV_TYPE ) == obj.SACCADE_TYPE )
                    saccade_amplitude_x =   max( obj.eye_records( onset_position:offset_position,obj.X_COORD ) ) - ...
                                            min( obj.eye_records( onset_position:offset_position,obj.X_COORD ) );
                    saccade_amplitude_y =   max( obj.eye_records( onset_position:offset_position,obj.Y_COORD ) ) - ...
                                            min( obj.eye_records( onset_position:offset_position,obj.Y_COORD ) );                                        
                    saccade_amplitude = sqrt ( saccade_amplitude_x^2 + saccade_amplitude_y^2 );
% Eliminate microsaccades
                    if( saccade_amplitude <= 0.5 )
                        obj.eye_records( onset_position:offset_position,obj.MOV_TYPE ) = obj.NOISE_TYPE;
                    end
% If filtration enabled for X axis
                    if( obj.use_degree_data_filtering_X )
% We remove saccades with onset or offset out of allowed range
                        if( obj.eye_records( onset_position, obj.X_COORD ) < obj.minimal_allowed_X_degree || ...
                            obj.eye_records( offset_position, obj.X_COORD )< obj.minimal_allowed_X_degree || ...
                            obj.eye_records( onset_position, obj.X_COORD ) > obj.maximal_allowed_X_degree || ...
                            obj.eye_records( offset_position, obj.X_COORD )> obj.maximal_allowed_X_degree )
                            obj.eye_records( onset_position:offset_position,obj.MOV_TYPE ) = obj.NOISE_TYPE;
                        end
                    end
% If filtration enabled for Y axis
                    if( obj.use_degree_data_filtering_Y )
% We remove saccades with onset or offset out of allowed range
                        if( obj.eye_records( onset_position, obj.Y_COORD ) < obj.minimal_allowed_Y_degree || ...
                            obj.eye_records( offset_position, obj.Y_COORD )< obj.minimal_allowed_Y_degree || ...
                            obj.eye_records( onset_position, obj.Y_COORD ) > obj.maximal_allowed_Y_degree || ...
                            obj.eye_records( offset_position, obj.Y_COORD )> obj.maximal_allowed_Y_degree )
                            obj.eye_records( onset_position:offset_position,obj.MOV_TYPE ) = obj.NOISE_TYPE;
                        end
                    end
                end

% Now we include current eye movements sequence to one of our list based on
% first record type
                counters(obj.eye_records( onset_position, obj.MOV_TYPE ) ) = ...
                    counters(obj.eye_records( onset_position, obj.MOV_TYPE ) ) + 1;
                switch obj.eye_records( onset_position , obj.MOV_TYPE )
                    case obj.FIXATION_TYPE
                        obj.fixation_records{ counters( obj.FIXATION_TYPE  ) } =...
                            obj.eye_records( onset_position:offset_position, [obj.X_COORD obj.Y_COORD obj.T_COORD]);
                    case obj.SACCADE_TYPE
% If saccade detected then we should expand it to both sides - left edge
% and right edge due our method of velocity calculations
                        if( onset_position > 1 )
                            if( obj.eye_records( onset_position-1,obj.VALIDITY) == obj.DATA_VALID)
                                onset_position = onset_position - 1;
                            end
                        end
                        if( offset_position < length(obj.eye_records) )
                            if( obj.eye_records( offset_position+1,obj.VALIDITY) == obj.DATA_VALID)
                                offset_position = offset_position +1;
                            end
                        end
                        obj.saccade_records{ counters( obj.SACCADE_TYPE ) } =...
                            obj.eye_records( onset_position:offset_position, [obj.X_COORD obj.Y_COORD obj.T_COORD]);
                    case obj.PURSUIT_TYPE
                        obj.pursuit_records{ counters( obj.PURSUIT_TYPE ) } =...
                            obj.eye_records( onset_position:offset_position, [obj.X_COORD obj.Y_COORD obj.T_COORD]);
                    case obj.NOISE_TYPE
                        obj.noise_records{ counters( obj.NOISE_TYPE ) } =...
                            obj.eye_records( onset_position:offset_position, [obj.X_COORD obj.Y_COORD obj.T_COORD]);
                end
                i=i+1;
            end
% Checking all detected fixations for possibility of merge
            if( ~isempty(obj.fixation_records) > 0 )
                tmp_list=obj.fixation_records{1};
                tmp_records = {};
                tmp_count = 0;
                for i=2:length(obj.fixation_records)
% Calculate centroid coordinates for last merged fixation and current
% unmerged fixation
                    centroid_x1 = mean( tmp_list( :,obj.X_COORD) );
                    centroid_y1 = mean( tmp_list( :,obj.Y_COORD) );
                    centroid_x2 = mean( obj.fixation_records{i}( :,obj.X_COORD) );
                    centroid_y2 = mean( obj.fixation_records{i}( :,obj.Y_COORD) );
% Calculate distance between two centroids
                    distance = sqrt ( (centroid_x1 - centroid_x2)^2 + (centroid_y1 - centroid_y2)^2 );
% Calculate time interval between these fixations
                    time_ms = ( obj.fixation_records{i}(1,3) - tmp_list( end,3 )) * obj.delta_t_sec * 1000;
% If all requirements are satisfied we merge these fixations
                    if ( distance <= obj.merge_fixation_distance && time_ms <= obj.merge_fixation_time_interval )
                        tmp_list = cat(1,tmp_list,obj.fixation_records{i});
                    else
% This mean that we complete merge fixations to one large fixation and we
% should start the new one. But before that we have to check our fixation
% for duration and if it less then 100 ms we should discard it
                        if( ( tmp_list( end,3 ) - tmp_list(1,3) ) * obj.delta_t_sec * 1000 >= 100 )
                            tmp_count = tmp_count+1;
                            tmp_records{tmp_count}=tmp_list;
                            tmp_list = [];
                        else
% such improper fixations we mark as noise
                            obj.eye_records( tmp_list(:,3),obj.MOV_TYPE ) = obj.NOISE_TYPE;
                            obj.noise_records{ length(obj.noise_records) + 1 } = tmp_list;
                            tmp_list = [];
                        end
% just copy current fixation
                        tmp_list = obj.fixation_records{i};
                    end
                end
% A last fixation
                if( ~isempty(tmp_list) )
                    if( ( tmp_list( end,3 ) - tmp_list(1,3) ) * obj.delta_t_sec * 1000 >= 100 )
                            tmp_count = tmp_count+1;
                            tmp_records{tmp_count}=tmp_list;
                    end
                end
                obj.fixation_records = tmp_records;
            end

            if( obj.debug_mode ~= 0)
                fprintf(strcat('Complete merge fixations and splitting records in :',datestr(now),'\n'));
            end
        end

% Public access interface to class properties
        function set.merge_fixation_time_interval(obj,value)
            obj.merge_fixation_time_interval = value;
        end

        function set.merge_fixation_distance(obj, value)
            obj.merge_fixation_distance = value;
        end

    end
    
end
