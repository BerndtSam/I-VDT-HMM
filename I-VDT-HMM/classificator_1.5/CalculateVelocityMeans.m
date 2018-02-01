function [ fixation_mean, saccade_mean, pursuit_mean ] = CalculateVelocityMeans( noiseless_eye_record )
% Calculate the velocity means of the given eye records
% Input
% noiseless_eye_record: Matrix containing all eye records which will be
% processed in this stage of the algorithm
% Output
% fixation_mean: Mean of fixation velocity
% saccade_mean: Mean of saccade velocity
% pursuit_mean: Mean of smooth pursuit velocity

    fixation_counter = 0;
    fixation_sum = 0; 
    saccade_counter = 0;
    saccade_sum = 0; 
    pursuit_sum = 0; 
    pursuit_counter = 0;

    % Count the number of classifications and sum up the velocity
    for noiseless_eye_record_index=1:length(noiseless_eye_record)
        if (noiseless_eye_record(noiseless_eye_record_index).xy_movement_EMD == 2)
            % Saccade
            saccade_counter = saccade_counter + 1;
            saccade_sum = saccade_sum + abs(noiseless_eye_record(noiseless_eye_record_index).xy_velocity_measured_deg);
        elseif(noiseless_eye_record(noiseless_eye_record_index).xy_movement_EMD == 1)
            % Fixation
            fixation_counter = fixation_counter + 1;
            fixation_sum = fixation_sum + abs(noiseless_eye_record(noiseless_eye_record_index).xy_velocity_measured_deg); 
        elseif(noiseless_eye_record(noiseless_eye_record_index).xy_movement_EMD == 3)
            % Pursuit
             pursuit_counter = pursuit_counter + 1;      
             pursuit_sum = pursuit_sum + abs(noiseless_eye_record(noiseless_eye_record_index).xy_velocity_measured_deg);   
        end
    end
    
    
    % Calculate the velocity means
    try
        fixation_mean = fixation_sum/fixation_counter;
    catch
        fixation_mean = 0;
    end
    
    try
        saccade_mean = saccade_sum/saccade_counter;
    catch
        saccade_mean = 0;
    end
       
    try
        pursuit_mean = pursuit_sum/pursuit_counter;
    catch
        pursuit_mean = 0;
    end
    
      

end


