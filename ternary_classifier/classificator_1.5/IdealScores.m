function [ ideal_behavioral_scores ] = IdealScores( stimulus_records, subsample_ratio )
% Calculate the ideal behavioral scores

%     IDEAL_PQNS = 52;
%     IDEAL_PQLS_V = 0;
%     IDEAL_PQLS_P = 0;
%     IDEAL_FQNS = 83.9;
%     IDEAL_SQNS = 100;
%     IDEAL_MISFIX = 7.1;
%     IDEAL_FQLS = 0.5;
        
    IDEAL_FQnS = GetIdealFQnS(stimulus_records, subsample_ratio);
    IDEAL_SQnS = GetIdealSQnS();
    IDEAL_PQnS = GetIdealPQnS(stimulus_records, subsample_ratio);
    IDEAL_PQlS_V = 0;
    IDEAL_PQlS_P = 0;
    IDEAL_MisFix = 7.1;
    IDEAL_FQlS = 0.5;
    
    ideal_behavioral_scores = [IDEAL_FQnS, IDEAL_SQnS, IDEAL_PQnS, ...
        IDEAL_FQlS, IDEAL_MisFix, IDEAL_PQlS_P, IDEAL_PQlS_V];
end

function [ideal_fqns] = GetIdealFQnS(stimulus_records, subsample_ratio)
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
    % Pulled from paper
    Sl = 200;
    
    % m = Number of stimulous transitions between fixations and saccades
    m = 0;
    
    % k = Number of stimulus transitions from SP to fixations
    k = 0;
    
    % Pl is the duration of the SP termination phase in ms during fixation stimulus
    % Pulled from paper
    Pl = 130;
    
    % D_sac_dur is the sum of expected duration of a saccade in response to the stimulus saccade j, 
    D_sac_dur = 0;
    
    min_sac_amp = 100;
    max_sac_amp = -100;
    sac_active = false;
    
    for stimulus=2:length(stimulus_records)
        previous_stimulus_classification = stimulus_records(stimulus-1, 4);
        current_stimulus_classification = stimulus_records(stimulus, 4);
        
        % If from fixation to saccade or saccade to fixation, increment m
        if (previous_stimulus_classification == 1 && current_stimulus_classification == 2) || ...
                previous_stimulus_classification == 2 && current_stimulus_classification == 1
            m = m + 1;
        % If from SP to fixation, increment k
        elseif (previous_stimulus_classification == 3 && current_stimulus_classification == 1)
            k = k + 1;
        end
        
        % Increment the number of the stimulus fixation duration
        if current_stimulus_classification == 1
            D_stim_fix_dur = D_stim_fix_dur + 1;
        end
        
        % Determine the max amplitude of the saccade to calculate the
        % estimated saccade duration based off citation
        % If the current stimulus is a saccade...
        if current_stimulus_classification == 2
            % If this is the first saccade
            if sac_active == false
                sac_active = true;
            end
            
            % Determine if the max or min saccade amplitude has been
            % broken, if so, reassign
            if stimulus_records(stimulus, x_coord) > max_sac_amp
                max_sac_amp = stimulus_records(stimulus, x_coord);
            end
            if stimulus_records(stimulus, x_coord) < min_sac_amp
                min_sac_amp = stimulus_records(stimulus, x_coord);
            end
        % If it is no longer a saccade, but this is the eye record immediately after
        % the saccade was taking place
        elseif sac_active == true
            % Take the max and min amplitude of the saccade to calculate
            % the duration
            D_sac_dur = D_sac_dur + 2.2*abs(max_sac_amp - min_sac_amp) + 21;
            sac_active = false;
            min_sac_amp = 100;
            max_sac_amp = -100;
        end
        
    end
    
    D_stim_fix_dur = D_stim_fix_dur * subsample_ratio;
    
    ideal_fqns = 100 * (1-((m*Sl + k*Pl + D_sac_dur)/(D_stim_fix_dur)));
end

function [ideal_sqns] = GetIdealSQnS()
    % Gathered from paper, standardized automation
    ideal_sqns = 100;
end

function [ideal_pqns] = GetIdealPQnS(stimulus_records, subsample_ratio)
% where n is the number of stimulus pursuits, Dstim pur duri is duration of 
% the ith stimulus pursuit, Pl is pursuit?s latency prior to the onset of 
% the corrective saccade that brings the fovea to the target, and 
% Dcor sac durj is the expected duration of the corrective saccade

    % n = number of stimulus pursuits
    n = 0;
    
    % Dstim pur dur is duration of the ith stimulus pursuit
    Dstim_pur_dur = 0;
    
    % Sum of Pursuit Speed, to be divided by n to calculate average speed
    % of saccades. Will then reference TernaryClassification paper to
    % determine Pl
    SPs = 0;
    
    % Dcor_sac_dur is expected duration of corrective saccade
    Dcor_sac_dur = 0;
    
    for stimulus=2:length(stimulus_records)
        previous_stimulus_classification = stimulus_records(stimulus-1, 4);
        current_stimulus_classification = stimulus_records(stimulus, 4);
        
        if previous_stimulus_classification ~= 3 && current_stimulus_classification == 3
            n = n + 1;
            % + 1 and + 2 due to ramp up speed
            pursuit_speed = (1000/subsample_ratio) * abs(stimulus_records(stimulus+1,1) - stimulus_records(stimulus+2,1));
               
            if pursuit_speed < 20
                catchupSaccadeLength = 0;
            elseif pursuit_speed < 30
                catchupSaccadeLength = 230;
            elseif pursuit_speed < 40
                catchupSaccadeLength = 210;
            elseif pursuit_speed < 50
                catchupSaccadeLength = 180;
            else
                catchupSaccadeLength = 210;
            end
            
            % Saccade amplitude needed to catch up from the delay
            Sac_amp_required = catchupSaccadeLength * pursuit_speed / 1000;
            sac_dur = 2.2*Sac_amp_required + 21;
            Dcor_sac_dur = Dcor_sac_dur + sac_dur; 

            SPs = SPs + pursuit_speed;
        end
        
        if current_stimulus_classification == 3
            Dstim_pur_dur = Dstim_pur_dur + 1;            
        end
        
    end
        
    % Pl = pursuit latency prior to onset of corrective saccade
    % Calculation pulled from ternary classification paper
    SPs = SPs / n;
    if SPs < 20
        Pl = 0;
    elseif SPs < 30
        Pl = 230;
    elseif SPs < 40
        Pl = 210;
    elseif SPs < 50
        Pl = 180;
    else
        Pl = 210;
    end
        
    Dstim_pur_dur = Dstim_pur_dur*subsample_ratio;
    
    ideal_pqns = 100 * (1 - ((n * Pl + Dcor_sac_dur)/(Dstim_pur_dur)));
end