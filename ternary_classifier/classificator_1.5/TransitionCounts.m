function [ transition_matrix, total_transitions ] = TransitionCounts( noiseless_eye_record )
% Count the transition counts between then given classifications for the
% eye record

    p_saccade_saccade = 0; 
    p_saccade_fixation = 0; 
    p_saccade_pursuit = 0; 

    p_fixation_saccade = 0; 
    p_fixation_fixation = 0; 
    p_fixation_pursuit = 0; 
    
    p_pursuit_fixation = 0; 
    p_pursuit_saccade = 0; 
    p_pursuit_pursuit = 0; 
    
    total_transitions = 0;
    
    for noiseless_eye_record_index=1:length(noiseless_eye_record)
        if(noiseless_eye_record_index~=length(noiseless_eye_record))
           total_transitions = total_transitions + 1; 
           % From Fixation to...
           if(noiseless_eye_record(noiseless_eye_record_index).xy_movement_EMD == 1)
               if(noiseless_eye_record(noiseless_eye_record_index+1).xy_movement_EMD == 1)
                    p_fixation_fixation = p_fixation_fixation + 1; 
               elseif(noiseless_eye_record(noiseless_eye_record_index+1).xy_movement_EMD == 2) 
                    p_fixation_saccade = p_fixation_saccade + 1;
               elseif(noiseless_eye_record(noiseless_eye_record_index+1).xy_movement_EMD == 3) 
                    p_fixation_pursuit = p_fixation_pursuit + 1; 
               end 
            % From Saccade to...
            elseif(noiseless_eye_record(noiseless_eye_record_index).xy_movement_EMD == 2)
                if(noiseless_eye_record(noiseless_eye_record_index+1).xy_movement_EMD == 1)
                    p_saccade_fixation = p_saccade_fixation + 1; 
                elseif(noiseless_eye_record(noiseless_eye_record_index+1).xy_movement_EMD == 2) 
                    p_saccade_saccade = p_saccade_saccade + 1;
                elseif(noiseless_eye_record(noiseless_eye_record_index+1).xy_movement_EMD == 3) 
                    p_saccade_pursuit = p_saccade_pursuit + 1; 
                end
            % From Smooth Pursuit to...
            elseif(noiseless_eye_record(noiseless_eye_record_index).xy_movement_EMD == 3)
               if(noiseless_eye_record(noiseless_eye_record_index+1).xy_movement_EMD == 1)
                    p_pursuit_fixation = p_pursuit_fixation + 1; 
                elseif(noiseless_eye_record(noiseless_eye_record_index+1).xy_movement_EMD == 2) 
                    p_pursuit_saccade = p_pursuit_saccade + 1;
                elseif(noiseless_eye_record(noiseless_eye_record_index).xy_movement_EMD == 3)
                    p_pursuit_pursuit = p_pursuit_pursuit + 1; 
                end    
            end
        end
    end

    
    transition_matrix = [p_fixation_fixation/total_transitions p_fixation_saccade/total_transitions p_fixation_pursuit/total_transitions; ...
        p_saccade_fixation/total_transitions p_saccade_saccade/total_transitions p_saccade_pursuit/total_transitions; ...
        p_pursuit_fixation/total_transitions p_pursuit_saccade/total_transitions p_pursuit_pursuit/total_transitions;];
    
    min_value = min([min(transition_matrix(transition_matrix(1,:)>0)), min(transition_matrix(transition_matrix(2,:)>0)) , min(transition_matrix(transition_matrix(3,:)>0)) ]);
    for i=1:length(transition_matrix)
        for j=1:length(transition_matrix)
            if transition_matrix(i,j) == 0
                transition_matrix(i,j) = 100/total_transitions;
            end
        end
    end
    
    
end

