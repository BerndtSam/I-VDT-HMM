classdef eye_movements_records_class <  classificator_enumerations_class & ...  % Basic enumerations definitions
                                        handle
    % This is basic class for eye movement classifications arrays
    % It's define properties and arrays for 4 lists. This lists are for
    % saccades, fixations, pursuits and noises.
     properties (Hidden)
        saccade_records = {};   % Cell array for saccade data records
        pursuit_records = {};   % Cell array for pursuits data records
        noise_records = {};     % Cell array for noise data records
        fixation_records = {};  % Cell array for fixation data records
    end
    
    methods
% Public access interface for class properties
        function set.saccade_records(obj, value)
            obj.saccade_records = value;
        end

        function result = get.saccade_records(obj)
            result = obj.saccade_records;
        end

        function set.pursuit_records(obj, value)
            obj.pursuit_records = value;
        end

        function result = get.pursuit_records(obj)
            result = obj.pursuit_records;
        end

        function set.noise_records(obj, value)
            obj.noise_records = value;
        end

        function result = get.noise_records(obj)
            result = obj.noise_records;
        end

        function set.fixation_records(obj, value)
            obj.fixation_records = value;
        end

        function result = get.fixation_records(obj)
            result = obj.fixation_records;
        end
    end

end
