function [ noiseless_eye_record ] = CreateNoiselessEyeRecord( eye_record, non_classifications )
% Create a noiseless eye record with only the given classifications

% Input
% eye_record: All eye record information
% non_classifications: The classifications we want to remove

% Output
% noiseless_eye_record: Record without noise or non_classifications


    % Determine the size of the noiseless_eye_record to initialize the matrix
    noise_counter = 0;
    for eye_record_index=1:length(eye_record)
        if (ismember(eye_record(eye_record_index).xy_movement_EMD, non_classifications) || isempty(eye_record(eye_record_index).xy_velocity_measured_deg) || isnan(eye_record(eye_record_index).xy_velocity_measured_deg))
            noise_counter = noise_counter + 1;
        end
    end
    
    % Initialize the noiseless eye record
    noiseless_eye_record = initialize_eye_record(length(eye_record)-noise_counter);

    % Insert all but the non_classifications records into the noiseless
    % eye record
    noiseless_eye_record_index = 0; 
    for eye_record_index=1:length(eye_record)
      if(ismember(eye_record(eye_record_index).xy_movement_EMD, non_classifications))
            continue;
      else
          noiseless_eye_record_index = noiseless_eye_record_index+1; 
          noiseless_eye_record(noiseless_eye_record_index).xy_velocity_measured_deg = eye_record(eye_record_index).xy_velocity_measured_deg;
          noiseless_eye_record(noiseless_eye_record_index).x = eye_record(eye_record_index).x;
          noiseless_eye_record(noiseless_eye_record_index).y = eye_record(eye_record_index).y;
          noiseless_eye_record(noiseless_eye_record_index).xy_movement_EMD = eye_record(eye_record_index).xy_movement_EMD;
      end
    end
        
end

