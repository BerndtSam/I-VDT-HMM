classdef classificator_time_rate_class < handle
    % This class implement delta_t_sec and sample_rate variables and their
    % methods.
    
    properties (Hidden)
        delta_t_sec = nan;  % Time step between eye trackers readings
        sample_rate = nan;  % Eye tracker sample rate
    end
    
    methods
% Public access interface to class properties
        function set.delta_t_sec(obj, value)
            obj.delta_t_sec = value;
        end
        
        function set.sample_rate(obj, value)
            obj.sample_rate = value;
        end
        
        function calculate_delta_t(obj)
            obj.delta_t_sec = 1 / obj.sample_rate;
        end
        
        function calculate_sample_rate(obj)
            obj.sample_rate = 1 / obj.delta_t_sec;
        end

    end
    
end

