function [ output_args ] = IdealScores( stimulus_records, subsample_ratio )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%     IDEAL_PQNS = 52;
%     IDEAL_PQLS_V = 0;
%     IDEAL_PQLS_P = 0;
%     IDEAL_FQNS = 83.9;
%     IDEAL_SQNS = 100;
%     IDEAL_MISFIX = 7.1;
%     IDEAL_FQLS = 0.5;
        
        IDEAL_FQnS = GetFQnS(stimulus_records, subsample_ratio);
    
end

function [ideal_fqns] = GetFQnS(stimulus_records, subsample_ratio)
%  where n is the number of stimulus fixations, Dstim fix duri is
% duration of the ith stimulus fixation, Sl is saccadic latency, m is
% the number of stimulus transitions between fixations and
% saccades, Dsac durj is the expected duration of a saccade in
% response to the stimulus saccade j, k is the number of stimulus
% transitions from SP to fixations, and Pl is the duration of the
% SP termination phase during fixation stimulus.
    x_coord = 1;
    
    
    % Dstim_fix_dur is sum of duration of the ith stimulus fixation
    D_stim_fix_dur = 0;
    
    % Sl = saccade latency;
    Sl = 200/20;
    
    % m = Number of stimulous transitions between fixations and saccades
    m = 0;
    
    % k = Number of stimulus transitions from SP to fixations
    k = 0;
    
    % D_sac_dur is the sum of expected duration of a saccade in response to the stimulus saccade j, 
    D_sac_dur = 0;
    
    min_sac_amp = 100;
    max_sac_amp = -100;
    sac_active = false;
    
    for stimulus=2:length(stimulus_records)
        previous_stimulus_classification = stimulus_records(stimulus-1, 4);
        current_stimulus_classification = stimulus_records(stimulus, 4);
        if (previous_stimulus_classification == 1 && current_stimulus_classification == 2) || ...
                previous_stimulus_classification == 2 && current_stimulus_classification == 1
            m = m + 1;
        elseif (previous_stimulus_classification == 3 && current_stimulus_classification == 1)
            k = k + 1;
        end
        
        if current_stimulus_classification == 1
            D_stim_fix_dur = D_stim_fix_dur + 1;
        end
        
        if current_stimulus_classification == 2
            if sac_active == false
                sac_active = true;
            end
            
            if stimulus_records(stimulus, x_coord) > max_sac_amp
                max_sac_amp = stimulus_records(stimulus, x_coord);
            elseif stimulus_records(stimulus, x_coord) < min_sac_amp
                min_sac_amp = stimulus_records(stimulus, x_coord);
            end
        elseif sac_active == true
            D_sac_dur = D_sac_dur + 2.2*abs(max_sac_amp - min_sac_amp) + 21;
            sac_active = false;
            min_sac_amp = 100;
            max_sac_amp = -100;
        end
        
    end
            
    % Pl is the duration of the SP termination phase during fixation stimulus
    Pl = 130;
    
    ideal_fqns = 100 * (1-((m*Sl + k*Pl + D_sac_dur)/(D_stim_fix_dur))/subsample_ratio);
end
