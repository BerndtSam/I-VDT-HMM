classdef classificator_enumerations_class < handle
    %This class is declare some basic enumerations
    properties
        debug_mode = 0;     % Show some debug info
    end

    properties(Constant)
% Some eye tracker data format declarations
        DATA_FIELDS = 6;     % Count of data fields in eye tracker data
        X_COORD = 1;         % Number of field that contain x coordinate
        Y_COORD = 2;         % Number of field that contain y coordinate
        VELOCITY = 3;        % Number of field that contain velocity
        MOV_TYPE = 4;        % Number of field that contain movement type
        VALIDITY = 5;        % Number of feild that contain data validity
        T_COORD = 6;         % Number of field that contain time step
% Some data validity declarations
        DATA_VALID = 1;      % Definition of valid data constant
        DATA_INVALID = 0;    % Definition of invalid data constant
% Some eye movement type definitions
        SACCADE_TYPE = 2;    % Definition of saccade type movement
        FIXATION_TYPE = 1;   % Definition of fixation type movement
        PURSUIT_TYPE = 3;    % Definition of pursuit type movement
        NOISE_TYPE = 4;      % Definition if noise type movement
    end
    
    methods
        function set.debug_mode(obj,value)
            obj.debug_mode = value;
        end
    end

end

