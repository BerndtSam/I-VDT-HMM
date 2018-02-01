% Modified by Sam Berndt, Tim Taviano, Doug Kirkpatrick 
% Project 3 - Ternary Classification
% Oleg K. 
% Last Modified 12/3/17

function eye_record = initialize_eye_record(eye_record_length) 

        for t=1:eye_record_length

                %Merge
            eye_record(t).xy_movement_EMD = 0; % 1-fixation, 2- saccade, 3-pursuit, 4-Noise
            eye_record(t).xy_movement_EMD_plot = 0; % 1-fixation, 2- saccade, 3-pursuit
            eye_record(t).xy_movement_EMD_plot_saccade_x = nan;
            eye_record(t).xy_movement_EMD_plot_fixation_x = nan;
            eye_record(t).xy_movement_EMD_plot_pursuit_x = nan;

                %fixation
            eye_record(t).xy_movement_EMD_fixation_onset_time_sec       = 0;
            eye_record(t).xy_movement_EMD_fixation_offset_time_sec      = 0;
            eye_record(t).xy_movement_EMD_fixation_duration_time_sec    = 0;

                %saccade
            eye_record(t).xy_movement_EMD_saccade  = 0;
            eye_record(t).xy_movement_EMD_saccade_onset_x_pos_deg   = 0;
            eye_record(t).xy_movement_EMD_saccade_onset_x_pos_deg   = 0;
            eye_record(t).xy_movement_EMD_saccade_onset_y_pos_deg   = 0;
            eye_record(t).xy_movement_EMD_saccade_onset_time_sec    = 0;
            eye_record(t).xy_movement_EMD_saccade_onset_time_smpl   = 0;
            eye_record(t).xy_movement_EMD_saccade_offset_x_pos_deg  = 0;
            eye_record(t).xy_movement_EMD_saccade_offset_y_pos_deg  = 0;
            eye_record(t).xy_movement_EMD_saccade_offset_time_sec   = 0;
            eye_record(t).xy_movement_EMD_saccade_offset_time_smpl  = 0;

                %pursuits
            eye_record(t).xy_movement_EMD_pursuit = 0;    
            eye_record(t).xy_movement_EMD_pursuit_onset_x_pos_deg   = 0;
            eye_record(t).xy_movement_EMD_pursuit_offset_x_pos_deg  = 0;
            eye_record(t).xy_movement_EMD_pursuit_onset_y_pos_deg   = 0;
            eye_record(t).xy_movement_EMD_pursuit_offset_y_pos_deg  = 0;
            eye_record(t).xy_movement_EMD_pursuit_onset_time_sec    = 0;
            eye_record(t).xy_movement_EMD_pursuit_offset_time_sec   = 0;
            eye_record(t).xy_movement_EMD_pursuit_onset_time_smpl   = 0;
            eye_record(t).xy_movement_EMD_pursuit_offset_time_smpl  = 0;
            eye_record(t).xy_movement_EMD_pursuit_detected          = 0;  

            eye_record(t).x = 0;
            eye_record(t).y = 0;

        end

 return
 
 