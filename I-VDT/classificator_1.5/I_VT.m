function [ obj ] = I_VT( obj, SACCADE_DETECTION_THRESHOLD_DEG_SEC )
% I-VT            
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
    obj.eye_records( ((abs(obj.eye_records(:,obj.VELOCITY)) < SACCADE_DETECTION_THRESHOLD_DEG_SEC) & (obj.eye_records(:,obj.MOV_TYPE) ~= obj.NOISE_TYPE)),obj.MOV_TYPE ) = obj.FIXATION_TYPE;
    
    % Now we mark saccades
    obj.eye_records( ((abs(obj.eye_records(:,obj.VELOCITY)) >= SACCADE_DETECTION_THRESHOLD_DEG_SEC) & (obj.eye_records(:,obj.MOV_TYPE) ~= obj.NOISE_TYPE)),obj.MOV_TYPE ) = obj.SACCADE_TYPE;
    
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

end

