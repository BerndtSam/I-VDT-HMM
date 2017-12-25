classdef classificator_saccade_amplitude_filter_class < eye_records_class &...                  % Eye tracker data definitions
                                                        classificator_enumerations_class & ...  % Basic enumerations definitions
                                                        handle
    % This class is designed to filter unsuitable saccades from the list of
    % saccades. Filtration is based on comparison saccades amplitude with
    % threshold values for minimal and maximal acceptable level. Also we
    % are discarding saccades that are too short for us.
    %
    % For filtration you have to do:
    % 1. Setup minimal saccade length in minimal_saccade_length property by
    % calling set.minimal_saccade_length method
    % 2. Setup minimal saccade amplitude in minimal_saccade_amplitude by
    % calling set.minimal_saccade_amplitude method
    % 3. Setup maximal saccade amplitude in maximal_saccade_amplitude by
    % calling set.maximal_saccade_amplitude method
    % 4. Provide unfiltered saccades list in unfiltered_saccade_records
    % property by calling set.unfiltered_saccade_records. This list is a
    % cell array, each cell of which contains a two dimensional array of
    % records. Each record hold x and y coordinate of eye movement.
    % 5. To make a filtration call saccade_filtering method. Filtered
    % saccades will be available in filtered_saccade_records property in
    % the same format as in unfiltered_saccade_records property.
    
    properties (Hidden)
        unfiltered_saccade_records = {};    % This is a cell array that contains unfiltered saccade records list
        filtered_saccade_records = {};      % This is a cell array that contains purified saccade records list
        minimal_saccade_amplitude = 0;      % This is minimal allowed saccade amplitude
        maximal_saccade_amplitude = 0;      % This is maximal allowed saccade amplitude
        minimal_saccade_length = 0;         % This is minimal allowed length of saccade sequence
    end
    
    methods
% Filtration function
        function saccade_filtering(obj)
            if( obj.debug_mode ~= 0)
                fprintf(strcat('Begin saccade filtration in :',datestr(now),'\n'));
            end
% Reset our variables
            filtered_saccade_count = 0;
            obj.filtered_saccade_records = {};

% Check every saccade from the list
            for i=1:length(obj.unfiltered_saccade_records)
                current_saccade = obj.unfiltered_saccade_records{i};
                if( isempty(current_saccade))
                    continue;
                end
% Calculate saccade amplitude in X and Y axis
                x_saccade_amplitude = max ( current_saccade (: , obj.X_COORD) ) - min ( current_saccade (:, obj.X_COORD) );
                y_saccade_amplitude = max ( current_saccade (: , obj.Y_COORD) ) - min ( current_saccade (:, obj.Y_COORD) );
                saccade_amplitude = sqrt ( x_saccade_amplitude^2 + y_saccade_amplitude^2 );
% Now performing some amplitude comparisings
                if (    saccade_amplitude >= obj.minimal_saccade_amplitude && ...
                        saccade_amplitude <= obj.maximal_saccade_amplitude && ...
                        length( current_saccade ) >= obj.minimal_saccade_length )
                    filtered_saccade_count = filtered_saccade_count + 1;
                    obj.filtered_saccade_records{filtered_saccade_count} = current_saccade;
                end
            end

            if( obj.debug_mode ~= 0)
                fprintf(strcat('Complete saccade filtration in :',datestr(now),'\n'));
            end
        end

% Public access interface to class properties
        function set.unfiltered_saccade_records(obj, value)
            obj.unfiltered_saccade_records = value;
        end

        function set.minimal_saccade_amplitude(obj, value)
            obj.minimal_saccade_amplitude = value;
        end

        function set.maximal_saccade_amplitude(obj, value)
            obj.maximal_saccade_amplitude = value;
        end

        function set.minimal_saccade_length(obj, value)
            obj.minimal_saccade_length = value;
        end

        function result = get.filtered_saccade_records(obj)
            result = obj.filtered_saccade_records;
        end
    end

end
