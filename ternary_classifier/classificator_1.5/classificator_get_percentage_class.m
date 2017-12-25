classdef classificator_get_percentage_class <   eye_movements_records_class & ...
                                                classificator_enumerations_class & ...
                                                handle
    % This class designed to provide percentage information about relations
    % between saccades, fixations and pursuits
    % For get percentage just call one of 4 percentage methods
    
    properties (Hidden)
        fixation_percentage;            % Contains percentage of fixation sequences among of all sequences
        saccade_percentage;             % Contains percentage of saccade sequences among of all sequences
        pursuit_percentage;             % Contains percentage of pursuit sequences among of all sequences
        noise_percentage;               % Contains percentage of noise sequences among of all sequences
        total_counter;                  % Total counter of all sequences
        fixation_records_percentage;    % Contains percentage of fixation records among of all records
        saccade_records_percentage;     % Contains percentage of saccade records among of all records
        pursuit_records_percentage;     % Contains percentage of pursuit records among of all records
        noise_records_percentage;       % Contains percentage of noise records among of all records
        total_records_counter;          % Total counter of all records
    end
    
    methods
% Access interface for properties
% This methods are for sequences
        function result = get.total_counter(obj)
            result = length(obj.saccade_records) + length (obj.noise_records) + length (obj.fixation_records) + length( obj.pursuit_records);
        end
        
        function result = get.fixation_percentage(obj)
            result = 100 * length( obj.fixation_records ) / obj.total_counter;
        end
        
        function result = get.saccade_percentage(obj)
            result = 100 * length( obj.saccade_records ) / obj.total_counter;
        end
        
        function result = get.pursuit_percentage(obj)
            result = 100 * length( obj.pursuit_records ) / obj.total_counter;
        end
        
        function result = get.noise_percentage(obj)
            result = 100 * length( obj.noise_records ) / obj.total_counter;
        end
        
% And this are for records
        function result = get_list_records_count(obj, list)
            result = 0;
            for i=1:length(list)
                result = result + length( list{i} );
            end
        end

        function result = get.total_records_counter(obj)
            result =    obj.get_list_records_count(obj.fixation_records) + ...
                        obj.get_list_records_count(obj.saccade_records) + ...
                        obj.get_list_records_count(obj.pursuit_records) + ...
                        obj.get_list_records_count(obj.noise_records);

        end
        
        function result = get.fixation_records_percentage(obj)
            result = 100 * obj.get_list_records_count(obj.fixation_records) / obj.total_records_counter;
        end
        
        function result = get.saccade_records_percentage(obj)
            result = 100 * obj.get_list_records_count(obj.saccade_records) / obj.total_records_counter;
        end
        
        function result = get.pursuit_records_percentage(obj)
            result = 100 * obj.get_list_records_count(obj.pursuit_records) / obj.total_records_counter;
        end
        
        function result = get.noise_records_percentage(obj)
            result = 100 * obj.get_list_records_count(obj.noise_records) / obj.total_records_counter;
        end
    end
    
end

