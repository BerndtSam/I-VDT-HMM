function [ fixation_mean, pursuit_mean ] = CalculateDispersionMeans( noiseless_eye_record, duration_threshold, dispersion_threshold )
%CALCULATESCOPEDVELOCITY Summary of this function goes here
%   Detailed explanation goes here
    fixation_counter = 0;
    fixation_sum = 0; 
    pursuit_sum = 0; 
    pursuit_counter = 0;

    % Count the number of classifications and sum up the velocity
    for noiseless_eye_record_index=1:length(noiseless_eye_record)
        if(noiseless_eye_record(noiseless_eye_record_index).xy_movement_EMD == 1)
            % Fixation
            fixation_counter = fixation_counter + 1;
            fixation_sum = fixation_sum + CalculateDispersion(noiseless_eye_record, 1, noiseless_eye_record_index, duration_threshold, dispersion_threshold);
        elseif(noiseless_eye_record(noiseless_eye_record_index).xy_movement_EMD == 3)
            % Pursuit
             pursuit_counter = pursuit_counter + 1;      
             pursuit_sum = pursuit_sum + CalculateDispersion(noiseless_eye_record, 3, noiseless_eye_record_index, duration_threshold, dispersion_threshold);
        end
    end
    
    
    % Calculate the velocity means
    try
        fixation_mean = fixation_sum/fixation_counter;
    catch
        fixation_mean = 0;
    end
       
    try
        pursuit_mean = pursuit_sum/pursuit_counter;
    catch
        pursuit_mean = 0;
    end

end

