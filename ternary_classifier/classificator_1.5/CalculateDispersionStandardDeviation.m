function [ fixation_std_dev, pursuit_std_dev ] = CalculateDispersionStandardDeviation( noiseless_eye_record, fixation_mean, pursuit_mean, duration_threshold, dispersion_threshold )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    fixation_var = 0; 
    fixation_counter = 0;
    pursuit_var = 0;
    pursuit_counter = 0;
    
    % Calculate Variance
    for noiseless_eye_record_index=1:length(noiseless_eye_record)
        if(noiseless_eye_record(noiseless_eye_record_index).xy_movement_EMD == 1)
            fixation_var = fixation_var + (CalculateDispersion(noiseless_eye_record, 1, noiseless_eye_record_index, duration_threshold, dispersion_threshold) - fixation_mean)^2; 
            fixation_counter = fixation_counter + 1;
        elseif (noiseless_eye_record(noiseless_eye_record_index).xy_movement_EMD == 3)
            pursuit_var = pursuit_var + (CalculateDispersion(noiseless_eye_record, 3, noiseless_eye_record_index, duration_threshold, dispersion_threshold) - pursuit_mean)^2;
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
        pursuit_std_dev = sqrt(pursuit_var/pursuit_counter);
    catch
        pursuit_std_dev = 0;
    end

end

