function [ fixation_std_dev, saccade_std_dev, pursuit_std_dev ] = CalculateVelocityStandardDeviation( noiseless_eye_record, fixation_mean, saccade_mean, pursuit_mean )
% Calculate the standard deviation of velocities for each classification
% Input
% noiseless_eye_record: Matrix of eye record classifications
% fixation_mean: Mean velocity of fixations
% saccade_mean: Mean velocity of saccades
% pursuit_mean: Mean velocity of pursuits
% Output
% fixation_std_dev: Standard deviation of fixations
% saccade_std_dev: Standard deviation of saccades
% pursuit_std_dev: Standard deviations of pursuits
    
    fixation_var = 0; 
    fixation_counter = 0;
    saccade_var = 0;
    saccade_counter = 0;
    pursuit_var = 0;
    pursuit_counter = 0;
    
    % Calculate Variance
    for noiseless_eye_record_index=1:length(noiseless_eye_record)
        if(noiseless_eye_record(noiseless_eye_record_index).xy_movement_EMD == 1)
            fixation_var = fixation_var + (abs(noiseless_eye_record(noiseless_eye_record_index).xy_velocity_measured_deg) - fixation_mean)^2; 
            fixation_counter = fixation_counter + 1;
        elseif (noiseless_eye_record(noiseless_eye_record_index).xy_movement_EMD == 2)
            saccade_var = saccade_var + (abs(noiseless_eye_record(noiseless_eye_record_index).xy_velocity_measured_deg) - saccade_mean)^2; 
            saccade_counter = saccade_counter + 1;
        elseif (noiseless_eye_record(noiseless_eye_record_index).xy_movement_EMD == 3)
            pursuit_var = pursuit_var + (abs(noiseless_eye_record(noiseless_eye_record_index).xy_velocity_measured_deg) - pursuit_mean)^2;
            pursuit_counter = pursuit_counter + 1;
        end
    end
    
    % Calculate Standard Deviation
    try
        fixation_std_dev = sqrt(fixation_var/fixation_counter); 
    catch
        fixation_std_dev = 0;
    end
    
    try
        saccade_std_dev = sqrt(saccade_var/saccade_counter);
    catch
        saccade_std_dev = 0;
    end
    
    try
       pursuit_std_dev = sqrt(pursuit_var/pursuit_counter);
    catch
        pursuit_std_dev = 0;
    end

end

