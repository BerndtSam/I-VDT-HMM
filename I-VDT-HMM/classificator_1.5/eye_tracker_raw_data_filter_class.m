classdef  eye_tracker_raw_data_filter_class <   eye_records_class & ...                 % Eye tracker data definition
                                                classificator_enumerations_class & ...  % Basic enumerations definitions
                                                handle
    % This class purposed for filtering eye tracker data. Methods of this
    % class should be invoked only after reading eye tracker data and
    % conversion if necessary.

    properties
        use_degree_data_filtering_X=0;  % Is data filtering by degree enabled for X axis
        use_degree_data_filtering_Y=0;  % Is data filtering by degree enabled for Y axis
        minimal_allowed_X_degree=0;     % Minimal allowed angle for X axis
        maximal_allowed_X_degree=0;     % Maximal allowed angle for X axis
        minimal_allowed_Y_degree=0;     % Minimal allowed angle for Y axis
        maximal_allowed_Y_degree=0;     % Maximal allowed angle for Y axis
    end
    
    methods
% Main function that filtrate eye tracker data by allowed range of angle,
% degrees
        function eye_tracker_data_filter_degree_range(obj)
% Check if we need to make a filtration by X axis
            if( obj.debug_mode ~= 0), fprintf(strcat('Begin data filtration in :',datestr(now),'\n')); end
            if( obj.use_degree_data_filtering_X )
% Cut everything that is lesser than minimal allowed angle by X
                obj.eye_records( (obj.eye_records(:,obj.X_COORD)<obj.minimal_allowed_X_degree), obj.MOV_TYPE ) = obj.NOISE_TYPE;
% Cut everything that is greater than maximal allowed angle by X
                obj.eye_records( (obj.eye_records(:,obj.X_COORD)>obj.maximal_allowed_X_degree), obj.MOV_TYPE ) = obj.NOISE_TYPE;
            end
% Check if we need to make a filtration by Y axis
            if( obj.use_degree_data_filtering_Y )
% Cut everything that is lesser than minimal allowed angle by X
                obj.eye_records( (obj.eye_records(:,obj.Y_COORD)<obj.minimal_allowed_Y_degree), obj.MOV_TYPE ) = obj.NOISE_TYPE;
% Cut everything that is greater than maximal allowed angle by X
                obj.eye_records( (obj.eye_records(:,obj.Y_COORD)>obj.maximal_allowed_Y_degree), obj.MOV_TYPE ) = obj.NOISE_TYPE;
            end
            if( obj.debug_mode ~= 0), fprintf(strcat('Complete data filtration in :',datestr(now),'\n')); end
        end
    end
    
end

