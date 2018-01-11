classdef eye_tracker_raw_data_converter_ETU_degree <    eye_records_class &...                  % Basic definition for eye tracker data array
                                                        classificator_enumerations_class & ...  % Basic enumerations definitions
                                                        handle
    % This class is the converter between ETU and degrees
    % For using it you have to setup all properties and after that
    % call appropriate function.
    %
    % This code based on S.Jayarathna's, D.H. Koh's and S.M. Gowda's code.
    
    properties (Hidden)
        image_width_mm;                 % Eye tracker image width in mm  
        image_height_mm;                % Eye tracker image height in mm
        image_width_etu;                % Eye tracker image width in ETU
        image_height_etu;               % Eye tracker image height in ETU
        distance_from_screen;           % Distance between eye tracker and subject in mm
        distance_to_lower_screen_edge;  % Distance between table and lower screen edge
        distance_to_eye_position;       % Distance between table and center of the screen
    end
    
    methods
% This function convert input data from ETU to degrees. Watch out! Dark
% calculations below!
        function convert_from_ETU_to_degrees(obj)
            if( obj.debug_mode ~= 0)
                fprintf(strcat('Begin data conversion from ETU to degress in :',datestr(now),'\n'));
            end
            obj.eye_records(:,obj.X_COORD) =...
                (( obj.image_width_etu - obj.eye_records(:,obj.X_COORD) ) *...
                obj.image_width_mm / obj.image_width_etu ) -...
                0.5 * obj.image_width_mm;
            obj.eye_records(:,obj.X_COORD) = ...
                180 * ...
                atan( obj.eye_records(:,obj.X_COORD) / obj.distance_from_screen) /...
                pi;

            obj.eye_records(:,obj.Y_COORD) = ...
                (( obj.image_height_etu - obj.eye_records(:,obj.Y_COORD) ) *...
                obj.image_height_mm / obj.image_height_etu ) ...
                - 0.5 * (obj.distance_to_eye_position - obj.distance_to_lower_screen_edge);
            obj.eye_records(:,obj.Y_COORD) = ...
                180 *...
                atan ( obj.eye_records(:,obj.Y_COORD) / obj.distance_from_screen ) /...
                pi;
            if( obj.debug_mode ~= 0)
                fprintf(strcat('Complete data conversion from ETU to degress in :',datestr(now),'\n'));
            end
        end

% This function convert input data from degress to ETU. Watch out! Dark
% calculations below!
        function convert_from_degree_to_ETU(obj)
            if( obj.debug_mode ~= 0)
                fprintf(strcat('Begin data conversion from degrees to ETU in :',datestr(now),'\n'));
            end
            obj.eye_records(:,obj.X_COORD) = obj.distance_from_screen *...
                tan(obj.eye_records(:,obj.X_COORD)*pi / 180 );
            obj.eye_records(:,obj.X_COORD) = obj.image_width_etu - ...
                (obj.eye_records(:,obj.X_COORD) + 0.5 * obj.image_width_mm ) *...
                obj.image_width_etu / obj.image_width_mm;

            obj.eye_records(:,obj.Y_COORD) = obj.distance_from_screen *...
                tan(obj.eye_records(:,obj.Y_COORD)*pi / 180 );
            obj.eye_records(:,obj.Y_COORD) = obj.image_height_etu -...
                (obj.eye_records(:,obj.Y_COORD) + 0.5 * (obj.distance_to_eye_position - obj.distance_to_lower_screen_edge) ) *...
                obj.image_height_etu / obj.image_height_mm;
            if( obj.debug_mode ~= 0)
                fprintf(strcat('Complete data conversion from degrees to ETU in :',datestr(now),'\n'));
            end
        end

% Public access interface for class properties
        function set.image_width_mm(obj, value)
            obj.image_width_mm = value;
        end

        function set.image_height_mm(obj, value)
            obj.image_height_mm = value;
        end

        function set.image_width_etu(obj, value)
            obj.image_width_etu = value;
        end

        function set.image_height_etu(obj, value)
            obj.image_height_etu = value;
        end

        function set.distance_from_screen(obj, value)
            obj.distance_from_screen = value;
        end

        function set.distance_to_lower_screen_edge(obj, value)
            obj.distance_to_lower_screen_edge = value;
        end

        function set.distance_to_eye_position(obj, value)
            obj.distance_to_eye_position = value;
        end
    end
    
end
